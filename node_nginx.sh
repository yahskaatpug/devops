
#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null
}

# Check if Node.js is installed, if not install it
if ! command_exists node; then
    echo "Node.js is not installed. Installing Node.js"
    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js is already installed."
fi

# Check if MongoDB is installed, if not install it
if ! command_exists mongod; then
    echo "MongoDB is not installed. Installing MongoDB..."
    # Import the public key used by the package management system
    wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

    # Create a list file for MongoDB
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

    # Reload local package database
    sudo apt-get update

    # Install MongoDB packages
    sudo apt-get install -y mongodb-org

    # Start MongoDB
    sudo systemctl start mongod

    # Enable MongoDB to start on boot
    sudo systemctl enable mongod
else
    echo "MongoDB is already installed."
fi

# Check if Node.js is installed, if not install it
if ! command_exists pm2; then
    echo "Pm2 is not installed. Installing pm2"
    sudo npm install -g pm2
else
    echo "Pm2 is already installed."
fi


# Clone the repository if it does not exist
REPO_URL="https://github.com/Vidhya-Skill-School/NodeJS-Express-API-V1.git"
REPO_NAME="NodeJS-Express-API-V1"
if [ ! -d "$REPO_NAME" ]; then
    echo "Cloning repository"
    git clone "$REPO_URL"
else
    echo "Repository already exists"
fi

# Navigate to the cloned repository
cd "$REPO_NAME"

# Install dependencies using npm
echo "Installing dependencies with npm"
npm install

# Run the development server
echo "Starting server"
pm2 start ./src/main.js
