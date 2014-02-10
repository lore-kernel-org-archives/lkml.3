Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaBJSB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:01:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbaBJR7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:11 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] HID: replace hid_output_raw_report with hid_hw_raw_request for feature requests
Date: Mon, 10 Feb 2014 12:58:54 -0500
Message-Id: <1392055139-19631-10-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  ret = hid_output_raw_report(A, B, C, HID_FEATURE_REPORT);
is equivalent to
  ret = hid_hw_raw_request(A, B[0], B, C, HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
whatever the transport layer is.

So use the new API where available

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-lg.c         |  8 ++++----
 drivers/hid/hid-magicmouse.c |  4 ++--
 drivers/hid/hid-sony.c       |  4 ++--
 drivers/hid/hid-thingm.c     |  4 ++--
 drivers/hid/hid-wacom.c      | 26 +++++++++++++++-----------
 5 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 76ed7e5..a976f48 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -692,8 +692,8 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (hdev->product == USB_DEVICE_ID_LOGITECH_WII_WHEEL) {
 		unsigned char buf[] = { 0x00, 0xAF,  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
-		ret = hid_output_raw_report(hdev, buf, sizeof(buf),
-					    HID_FEATURE_REPORT);
+		ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 
 		if (ret >= 0) {
 			/* insert a little delay of 10 jiffies ~ 40ms */
@@ -705,8 +705,8 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			buf[1] = 0xB2;
 			get_random_bytes(&buf[2], 2);
 
-			ret = hid_output_raw_report(hdev, buf, sizeof(buf),
-						    HID_FEATURE_REPORT);
+			ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 		}
 	}
 
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index cb5db3a..ecc2cbf 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -538,8 +538,8 @@ static int magicmouse_probe(struct hid_device *hdev,
 	 * but there seems to be no other way of switching the mode.
 	 * Thus the super-ugly hacky success check below.
 	 */
-	ret = hid_output_raw_report(hdev, feature, sizeof(feature),
-			HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, feature[0], feature, sizeof(feature),
+				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	if (ret != -EIO && ret != sizeof(feature)) {
 		hid_err(hdev, "unable to request touch data (%d)\n", ret);
 		goto err_stop_hw;
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index d275c0d..d980943 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -824,8 +824,8 @@ static int sixaxis_set_operational_usb(struct hid_device *hdev)
 static int sixaxis_set_operational_bt(struct hid_device *hdev)
 {
 	unsigned char buf[] = { 0xf4,  0x42, 0x03, 0x00, 0x00 };
-	return hid_output_raw_report(hdev, buf, sizeof(buf),
-				     HID_FEATURE_REPORT);
+	return hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
+				  HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 }
 
 static void buzz_set_leds(struct hid_device *hdev, const __u8 *leds)
diff --git a/drivers/hid/hid-thingm.c b/drivers/hid/hid-thingm.c
index 7dd3197..a97c788 100644
--- a/drivers/hid/hid-thingm.c
+++ b/drivers/hid/hid-thingm.c
@@ -48,8 +48,8 @@ static int blink1_send_command(struct blink1_data *data,
 			buf[0], buf[1], buf[2], buf[3], buf[4],
 			buf[5], buf[6], buf[7], buf[8]);
 
-	ret = hid_output_raw_report(data->hdev, buf, BLINK1_CMD_SIZE,
-				    HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(data->hdev, buf[0], buf, BLINK1_CMD_SIZE,
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 
 	return ret < 0 ? ret : 0;
 }
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index c720db9..902013e 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -128,7 +128,8 @@ static void wacom_set_image(struct hid_device *hdev, const char *image,
 
 	rep_data[0] = WAC_CMD_ICON_START_STOP;
 	rep_data[1] = 0;
-	ret = hid_output_raw_report(hdev, rep_data, 2, HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, rep_data[0], rep_data, 2,
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	if (ret < 0)
 		goto err;
 
@@ -142,14 +143,15 @@ static void wacom_set_image(struct hid_device *hdev, const char *image,
 			rep_data[j + 3] = p[(i << 6) + j];
 
 		rep_data[2] = i;
-		ret = hid_output_raw_report(hdev, rep_data, 67,
-					HID_FEATURE_REPORT);
+		ret = hid_hw_raw_request(hdev, rep_data[0], rep_data, 67,
+					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 	}
 
 	rep_data[0] = WAC_CMD_ICON_START_STOP;
 	rep_data[1] = 0;
 
-	ret = hid_output_raw_report(hdev, rep_data, 2, HID_FEATURE_REPORT);
+	ret = hid_hw_raw_request(hdev, rep_data[0], rep_data, 2,
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 
 err:
 	return;
@@ -181,7 +183,8 @@ static void wacom_leds_set_brightness(struct led_classdev *led_dev,
 		buf[3] = value;
 		/* use fixed brightness for OLEDs */
 		buf[4] = 0x08;
-		hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
+		hid_hw_raw_request(hdev, buf[0], buf, 9, HID_FEATURE_REPORT,
+				   HID_REQ_SET_REPORT);
 		kfree(buf);
 	}
 
@@ -337,8 +340,8 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
 		limit = 3;
 		do {
-			ret = hid_output_raw_report(hdev, rep_data, 2,
-					HID_FEATURE_REPORT);
+			ret = hid_hw_raw_request(hdev, rep_data[0], rep_data, 2,
+					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 		} while (ret < 0 && limit-- > 0);
 
 		if (ret >= 0) {
@@ -350,8 +353,9 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 			rep_data[1] = 0x00;
 			limit = 3;
 			do {
-				ret = hid_output_raw_report(hdev,
-					rep_data, 2, HID_FEATURE_REPORT);
+				ret = hid_hw_raw_request(hdev, rep_data[0],
+					rep_data, 2, HID_FEATURE_REPORT,
+					HID_REQ_SET_REPORT);
 			} while (ret < 0 && limit-- > 0);
 
 			if (ret >= 0) {
@@ -376,8 +380,8 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 		rep_data[0] = 0x03;
 		rep_data[1] = wdata->features;
 
-		ret = hid_output_raw_report(hdev, rep_data, 2,
-					HID_FEATURE_REPORT);
+		ret = hid_hw_raw_request(hdev, rep_data[0], rep_data, 2,
+				HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 		if (ret >= 0)
 			wdata->high_speed = speed;
 		break;
-- 
1.8.3.1

