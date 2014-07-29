Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaG2Sns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbaG2Snn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:43:43 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v3 5/7] Input - wacom: Remove passing id for wacom_set_report
Date: Tue, 29 Jul 2014 14:43:03 -0400
Message-Id: <1406659385-3256-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Przemo Firszt <przemo@firszt.eu>

Every call of wacom_set_report was passing "id" as a separate parameter
and buffer also passed the same information. We can use first u8 of the
buffer instead of "id"

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index a12cd9c..6e0c191 100644
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
@@ -274,15 +274,15 @@ static int wacom_bt_query_tablet_data(struct hid_device *hdev, u8 speed,
 	case GRAPHIRE_BT:
 		rep_data[0] = 0x03;
 		rep_data[1] = 0x00;
-		ret = wacom_set_report(hdev, HID_FEATURE_REPORT,
-					rep_data[0], rep_data, 2, 3);
+		ret = wacom_set_report(hdev, HID_FEATURE_REPORT, rep_data, 2,
+					3);
 
 		if (ret >= 0) {
 			rep_data[0] = speed == 0 ? 0x05 : 0x06;
 			rep_data[1] = 0x00;
 
 			ret = wacom_set_report(hdev, HID_FEATURE_REPORT,
-						rep_data[0], rep_data, 2, 3);
+						rep_data, 2, 3);
 
 			if (ret >= 0) {
 				wacom->wacom_wac.bt_high_speed = speed;
@@ -306,8 +306,8 @@ static int wacom_bt_query_tablet_data(struct hid_device *hdev, u8 speed,
 		rep_data[0] = 0x03;
 		rep_data[1] = wacom->wacom_wac.bt_features;
 
-		ret = wacom_set_report(hdev, HID_FEATURE_REPORT,
-					rep_data[0], rep_data, 2, 1);
+		ret = wacom_set_report(hdev, HID_FEATURE_REPORT, rep_data, 2,
+					1);
 		if (ret >= 0)
 			wacom->wacom_wac.bt_high_speed = speed;
 		break;
@@ -520,8 +520,8 @@ static int wacom_led_control(struct wacom *wacom)
 		buf[4] = wacom->led.img_lum;
 	}
 
-	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-				  WAC_CMD_LED_CONTROL, buf, 9, WAC_CMD_RETRIES);
+	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 9,
+				  WAC_CMD_RETRIES);
 	kfree(buf);
 
 	return retval;
@@ -541,8 +541,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, u8 xfer_id,
 	/* Send 'start' command */
 	buf[0] = WAC_CMD_ICON_START;
 	buf[1] = 1;
-	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-				  WAC_CMD_ICON_START, buf, 2, WAC_CMD_RETRIES);
+	retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT, buf, 2,
+				  WAC_CMD_RETRIES);
 	if (retval < 0)
 		goto out;
 
@@ -553,8 +553,7 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, u8 xfer_id,
 		memcpy(buf + 3, img + i * chunk_len, chunk_len);
 
 		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
-					  xfer_id, buf, chunk_len + 3,
-					  WAC_CMD_RETRIES);
+					  buf, chunk_len + 3, WAC_CMD_RETRIES);
 		if (retval < 0)
 			break;
 	}
@@ -562,8 +561,8 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, u8 xfer_id,
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
2.0.3

