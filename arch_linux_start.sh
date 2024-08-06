#!/bin/bash

# Global variable to track the background process PIDs
declare -a pids

function menu {
    echo
    echo --------------------------------------------------------------------------------
    echo "Choose an option:"
    echo     "1.  Update everything (monorepo, app, api, websocket) (Recommended once a day)"
    echo     "2.  Start everything (Flattrade, Shoonya, Dhan, API, and app)"
    echo
    echo    "31.  Run Flattrade websocket, API, app, and terminal."
    echo    "42.  Run Shoonya websocket, API, app, and terminal."
    echo    "53.  Run Dhan websocket, API, app, and terminal."
    echo
    echo    "310.  Run Flattrade websocket, API, and app"
    echo    "420.  Run Shoonya websocket, API, and app"
    echo    "530.  Run Dhan websocket, API, and app"
    echo
    echo     "6.  Exit"
    echo --------------------------------------------------------------------------------
    echo

    read -p "Enter your choice (1, 2, 31, 42, 53, 310, 420, 530, or 6): " choice
    echo
    case $choice in
    1) update ;;
    2) start_all ;;
    31) run_flattrade_open_link ;;
    42) run_shoonya_open_link ;;
    53) run_dhan_open_link ;;
    310) run_flattrade ;;
    420) run_shoonya ;;
    530) run_dhan ;;    
    6) exit 0 ;;
    *)
        echo "Invalid choice. Please try again."
        menu
        ;;
    esac
}

function update {
    echo "Updating steadfast-monorepo..."
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-monorepo || {
        echo "Error updating steadfast-monorepo."
        error
    }

    echo "Updating steadfast-app..."
    cd steadfast-app || { echo "Directory steadfast-app not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-app || {
        echo "Error updating steadfast-app."
        error
    }
    cd ..

    echo "Updating steadfast-api..."
    cd steadfast-api || { echo "Directory steadfast-api not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-api || {
        echo "Error updating steadfast-api."
        error
    }
    cd ..

    echo "Updating steadfast-websocket..."
    cd steadfast-websocket || { echo "Directory steadfast-websocket not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-websocket || {
        echo "Error updating steadfast-websocket."
        error
    }
    cd ..

    echo "Update complete."
    menu
}

function start_api {
    echo "Starting API..."
    konsole --noclose -e bash -c "cd steadfast-api && sleep 2 && node server.js" || { echo "Failed to start API."; error; } &
    pids+=($!)
}

function start_app {
    echo "Starting app..."
    konsole --noclose -e bash -c "cd steadfast-app && sleep 2 && npm run dev" || { echo "Failed to start app."; error; } &
    pids+=($!)
}

function start_websockets {
    echo "Starting all websocket services..."
    konsole --noclose -e bash -c "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py" || { echo "Failed to start Flattrade websocket."; error; } &
    pids+=($!)

    konsole --noclose -e bash -c "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py" || { echo "Failed to start Shoonya websocket."; error; } &
    pids+=($!)

    konsole --noclose -e bash -c "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py" || { echo "Failed to start Dhan websocket."; error; } &
    pids+=($!)
}

function start_all {
    echo "Starting all services..."
    start_websockets
    start_api
    start_app

    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "All services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}

function run_flattrade_open_link {
    echo "Starting Flattrade websocket..."
    konsole --noclose -e bash -c "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py" || { echo "Failed to start Flattrade websocket."; error; } &
    pids+=($!)

    start_api
    start_app

    echo "Flattrade, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}

function run_flattrade {
    echo "Starting Flattrade websocket..."
    konsole --noclose -e bash -c "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py" || { echo "Failed to start Flattrade websocket."; error; } &
    pids+=($!)

    start_api
    start_app

    echo "Flattrade, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Services started."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}

function run_shoonya_open_link {
    echo "Starting Shoonya websocket..."
    konsole --noclose -e bash -c "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py" || { echo "Failed to start Shoonya websocket."; error; } &
    pids+=($!)

    start_api
    start_app

    echo "Shoonya, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}
function run_shoonya {
    echo "Starting Shoonya websocket..."
    konsole --noclose -e bash -c "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py" || { echo "Failed to start Shoonya websocket."; error; } &
    pids+=($!)

    start_api
    start_app

    echo "Shoonya, API, and app started."
    echo "Waiting for services to start..."
    sleep 5
    echo "Services started."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}
function run_dhan_open_link {
    echo "Starting Dhan websocket..."
    konsole --noclose -e bash -c "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py" || { echo "Failed to start Dhan websocket."; error; } &
    pids+=($!)

    start_api
    start_app

    echo "Dhan, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}

function run_dhan {
    echo "Starting Dhan websocket..."
    konsole --noclose -e bash -c "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py" || { echo "Failed to start Dhan websocket."; error; } &
    pids+=($!)

    start_api
    start_app

    echo "Dhan, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Services started."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Keep the script running
    while true; do
        sleep 1
    done
}
function stop_services {
    echo "Stopping all services..."
    for pid in "${pids[@]}"; do
        kill "$pid" 2>/dev/null
    done
    pids=()
    echo "All services stopped."
    clear
    menu
}

function error {
    echo "An error occurred. Returning to menu."
    menu
}

menu
