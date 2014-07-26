Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaGZMRC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 08:17:02 -0400
Received: from si-002-i48.relay.mailchannels.net ([184.154.112.222]:24804 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751092AbaGZMRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 08:17:00 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
From: Przemo Firszt <przemo@firszt.eu>
To: benjamin.tissoires@redhat.com
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, pinglinux@gmail.com,
        killertofu@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 2/2] Input - wacom: Remove passing id for wacom_set_report
Date: Sat, 26 Jul 2014 12:59:29 +0100
Message-Id: <1406375969-4453-2-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406375969-4453-1-git-send-email-przemo@firszt.eu>
References: <1406375969-4453-1-git-send-email-przemo@firszt.eu>
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every call of wacom_set_report was passing "id" as a separate parameter
and buffer also passed the same information. We can use first u8 of the
buffer instead of "id"

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/wacom_sys.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 51437e2..db17198 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -36,13 +36,13 @@ static int wacom_get_report(struct hid_device *hdev, u8 type, u8 id,
 	return retval;
 }
 
-static int wacom_set_report(struct hid_device *hdev, u8 type, u8 id,
-			    void *buf, size_t size, unsigned int retries)
+static int wacom_set_report(struct hid_device *hdev, u8 type, u8 *buf,
+			    size_t size, unsigned int retries)
 {
 	int retval;
 
 	do {
-		retval = hid_hw_raw_request(hdev, id, buf, size, type,
+		retval = hid_hw_raw_request(hdev, buf[0], buf, size, type,
 				HID_REQ_SET_REPORT);
 	} while ((retval == -ETIMEDOUT || retval == -EPIPE) && --retries);
 
@@ -251,8 +251,8 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
 		rep_data[0] = report_id;
 		rep_data[1] = mode;
 
-		error = wacom_set_report(hdev, HID_FEATURE_REPORT,
-		                         report_id, rep_data, length, 1);
+		error = wacom_set_report(hdev, HID_FEATURE_REPORT, rep_data,
+					 length, 1);
 		if (error >= 0)
 			error = wacom_get_report(hdev, HID_FEATURE_REPORT,
 			                         report_id, rep_data, length, 1);
@@ -525,8 +525,8 @@ static int wacom_led_control(struct wacom *wacom)
 		buf[4] = wacom->led.img_lum;
 	}
 
-	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-				  WAC_CMD_LED_CONTROL, buf, 9, WAC_CMD_RETRIES);
+	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 9,
+				  WAC_CMD_RETRIES);
 	kfree(buf);
 
 	return retval;
@@ -546,8 +546,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
 	/* Send 'start' command */
 	buf[0] = WAC_CMD_ICON_START;
 	buf[1] = 1;
-	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-				  WAC_CMD_ICON_START, buf, 2, WAC_CMD_RETRIES);
+	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 2,
+				  WAC_CMD_RETRIES);
 	if (retval < 0)
 		goto out;
 
@@ -557,9 +557,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
 		buf[2] = i;
 		memcpy(buf + 3, img + i * chunk_len, chunk_len);
 
-		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-					  WAC_CMD_ICON_XFER,
-					  buf, chunk_len + 3, WAC_CMD_RETRIES);
+		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf,
+					  chunk_len + 3, WAC_CMD_RETRIES);
 		if (retval < 0)
 			break;
 	}
@@ -567,8 +566,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
 	/* Send 'stop' */
 	buf[0] = WAC_CMD_ICON_START;
 	buf[1] = 0;
-	wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, WAC_CMD_ICON_START,
-			 buf, 2, WAC_CMD_RETRIES);
+	wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 2,
+			 WAC_CMD_RETRIES);
 
 out:
 	kfree(buf);
-- 
1.9.3

