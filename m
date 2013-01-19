Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3ASKSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:18:55 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53403 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3ASKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:18:52 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 1/2] staging: line6: clean up line6_pod_process_message()
Date: Sat, 19 Jan 2013 11:18:43 +0100
Message-Id: <1358590724-30961-2-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358590724-30961-1-git-send-email-stefanha@gmail.com>
References: <1358590724-30961-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous versions of the line6 driver snooped MIDI traffic in order to
make device state accessible via sysfs attributes.  This involved a lot
of logic in line6_pod_process_message() that has since been removed.

Drop unused conditionals in line6_pod_process_message() and reduce the
levels of indentation.  Only two MIDI messages are still tracked: the
POD version message on startup and monitor level changes originating
from the device.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 96 +++++++++------------------------------------
 1 file changed, 19 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index ba6fed4..74898c3 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -135,85 +135,27 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 {
 	const unsigned char *buf = pod->line6.buffer_message;
 
-	/* filter messages by type */
-	switch (buf[0] & 0xf0) {
-	case LINE6_PARAM_CHANGE:
-	case LINE6_PROGRAM_CHANGE:
-	case LINE6_SYSEX_BEGIN:
-		break;		/* handle these further down */
-
-	default:
-		return;		/* ignore all others */
+	if (memcmp(buf, pod_version_header, sizeof(pod_version_header)) == 0) {
+		pod->firmware_version = buf[13] * 100 + buf[14] * 10 + buf[15];
+		pod->device_id = ((int)buf[8] << 16) | ((int)buf[9] << 8) |
+				 (int) buf[10];
+		pod_startup3(pod);
+		return;
+	}
+
+	/* Only look for sysex messages from this device */
+	if (buf[0] != (LINE6_SYSEX_BEGIN | LINE6_CHANNEL_DEVICE) &&
+	    buf[0] != (LINE6_SYSEX_BEGIN | LINE6_CHANNEL_UNKNOWN)) {
+		return;
+	}
+	if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) != 0) {
+		return;
 	}
 
-	/* process all remaining messages */
-	switch (buf[0]) {
-	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_DEVICE:
-	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
-		break;
-
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		break;
-
-	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_DEVICE:
-	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_UNKNOWN:
-		if (memcmp(buf + 1, line6_midi_id,
-			   sizeof(line6_midi_id)) == 0) {
-			switch (buf[5]) {
-			case POD_SYSEX_DUMP:
-				break;
-
-			case POD_SYSEX_SYSTEM:{
-					short value =
-					    ((int)buf[7] << 12) | ((int)buf[8]
-								   << 8) |
-					    ((int)buf[9] << 4) | (int)buf[10];
-
-					if (buf[6] == POD_MONITOR_LEVEL)
-						pod->monitor_level = value;
-					break;
-				}
-
-			case POD_SYSEX_FINISH:
-				/* do we need to respond to this? */
-				break;
-
-			case POD_SYSEX_SAVE:
-				break;
-
-			case POD_SYSEX_STORE:
-				dev_dbg(pod->line6.ifcdev,
-					"message %02X not yet implemented\n",
-					buf[5]);
-				break;
-
-			default:
-				dev_dbg(pod->line6.ifcdev,
-					"unknown sysex message %02X\n",
-					buf[5]);
-			}
-		} else
-		    if (memcmp
-			(buf, pod_version_header,
-			 sizeof(pod_version_header)) == 0) {
-			pod->firmware_version =
-			    buf[13] * 100 + buf[14] * 10 + buf[15];
-			pod->device_id =
-			    ((int)buf[8] << 16) | ((int)buf[9] << 8) | (int)
-			    buf[10];
-			pod_startup3(pod);
-		} else
-			dev_dbg(pod->line6.ifcdev, "unknown sysex header\n");
-
-		break;
-
-	case LINE6_SYSEX_END:
-		break;
-
-	default:
-		dev_dbg(pod->line6.ifcdev, "POD: unknown message %02X\n",
-			buf[0]);
+	if (buf[5] == POD_SYSEX_SYSTEM && buf[6] == POD_MONITOR_LEVEL) {
+		short value = ((int)buf[7] << 12) | ((int)buf[8] << 8) |
+			      ((int)buf[9] << 4) | (int)buf[10];
+		pod->monitor_level = value;
 	}
 }
 
-- 
1.8.0.2

