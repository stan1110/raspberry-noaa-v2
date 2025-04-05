#!/bin/bash
#
# Purpose: Send image and message to a Discord webhook URL that will post the data to a Discord channel.
#
# Input parameters:
#   1. Image
#   2. Message
#
# Example:
#   ./scripts/push_processors/push_discord.sh https://discord.com/api/webhooks/1351282018574536866/vZu7RILNYLxL-zH2WNf8GS7rAiE_9nGFtII75cY8w6diNbnQlqf-78s-hwlwkal4fZlU /srv/images/OjumH9-1005327605.jpg "test"

# import common lib and settings
. "$HOME/.noaa-v2.conf"
. "$NOAA_HOME/scripts/common.sh"

# input params
DISCORD_WEBHOOK=$1
IMAGE=$2
MESSAGE=$3

# check that the file exists and is accessible
if [ -f "${IMAGE}" ]; then 
  log "Sending message to Discord webhook" "INFO"
  Imagename=$(basename $IMAGE)
  echo $Imagename
  push_log=$(curl -H "Content-Type: multipart/form-data" \
             -F file=@$IMAGE \
             -F "payload_json={\"username\":\"Walter Froport\",\
		\"avatar_url\":\"https://media.discordapp.net/attachments/860580595380781066/1351308331595202570/image.png?ex=67d9e774&is=67d895f4&hm=aa4a238ecb903bbecc0d8018a18ea978b7a9f13d9c89c3292b4c3aef722d8968&=&format=webp&quality=lossless\",\
	\"embeds\":[\
	{\"title\":\"Daily Weather Report\",\
	\"description\":\"**Walter Froport:** $MESSAGE\\n\",\
	\"color\":3341417,\
	\"image\":{\"url\":\"attachment://$Imagename\"},\
	\"footer\":{\"text\":\"BOTTOMTEXT\"}\
	}\
	]}" $DISCORD_WEBHOOK 2>&1)
             
             #"payload_json={\"content\":\"$MESSAGE\"}" \ $DISCORD_WEBHOOK 2>&1)
  log "${push_log}" "INFO"
else
  log "Could not find or access image/attachment - not sending message to Discord" "ERROR"
fi
