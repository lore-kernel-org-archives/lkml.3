Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaBBEvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaBBEut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:49 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] HID: introduce helper to access hid_output_raw_report()
Date: Sat,  1 Feb 2014 23:50:29 -0500
Message-Id: <1391316630-29541-11-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper to access hdev->hid_output_raw_report().

To convert the drivers, use the following snippets:

for i in drivers/hid/*.c
do
  sed -i.bak "s/[^ \t]*->hid_output_raw_report(/hid_output_raw_report(/g" $i
done

Then manually fix for checkpatch.pl

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-input.c        |  2 +-
 drivers/hid/hid-lg.c           |  6 ++++--
 drivers/hid/hid-logitech-dj.c  |  2 +-
 drivers/hid/hid-magicmouse.c   |  2 +-
 drivers/hid/hid-sony.c         |  5 +++--
 drivers/hid/hid-thingm.c       |  4 ++--
 drivers/hid/hid-wacom.c        | 16 +++++++---------
 drivers/hid/hid-wiimote-core.c |  2 +-
 drivers/hid/hidraw.c           |  2 +-
 include/linux/hid.h            | 16 ++++++++++++++++
 10 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 1de5997..78293c3 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1184,7 +1184,7 @@ static void hidinput_led_worker(struct work_struct *work)
 
 	hid_output_report(report, buf);
 	/* synchronous output report */
-	hid->hid_output_raw_report(hid, buf, len, HID_OUTPUT_REPORT);
+	hid_output_raw_report(hid, buf, len, HID_OUTPUT_REPORT);
 	kfree(buf);
 }
 
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 9fe9d4a..76ed7e5 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -692,7 +692,8 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (hdev->product == USB_DEVICE_ID_LOGITECH_WII_WHEEL) {
 		unsigned char buf[] = { 0x00, 0xAF,  0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
-		ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
+		ret = hid_output_raw_report(hdev, buf, sizeof(buf),
+					    HID_FEATURE_REPORT);
 
 		if (ret >= 0) {
 			/* insert a little delay of 10 jiffies ~ 40ms */
@@ -704,7 +705,8 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			buf[1] = 0xB2;
 			get_random_bytes(&buf[2], 2);
 
-			ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
+			ret = hid_output_raw_report(hdev, buf, sizeof(buf),
+						    HID_FEATURE_REPORT);
 		}
 	}
 
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 61d2bbf..9347625 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -567,7 +567,7 @@ static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
 	out_buf[1] = djdev->device_index;
 	memcpy(out_buf + 2, buf, count);
 
-	ret = djrcv_dev->hdev->hid_output_raw_report(djrcv_dev->hdev, out_buf,
+	ret = hid_output_raw_report(djrcv_dev->hdev, out_buf,
 		DJREPORT_SHORT_LENGTH, report_type);
 
 	kfree(out_buf);
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 3b43d1c..cb5db3a 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -538,7 +538,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 	 * but there seems to be no other way of switching the mode.
 	 * Thus the super-ugly hacky success check below.
 	 */
-	ret = hdev->hid_output_raw_report(hdev, feature, sizeof(feature),
+	ret = hid_output_raw_report(hdev, feature, sizeof(feature),
 			HID_FEATURE_REPORT);
 	if (ret != -EIO && ret != sizeof(feature)) {
 		hid_err(hdev, "unable to request touch data (%d)\n", ret);
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 3930acb..8494b8c 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -720,7 +720,8 @@ static int sixaxis_set_operational_usb(struct hid_device *hdev)
 static int sixaxis_set_operational_bt(struct hid_device *hdev)
 {
 	unsigned char buf[] = { 0xf4,  0x42, 0x03, 0x00, 0x00 };
-	return hdev->hid_output_raw_report(hdev, buf, sizeof(buf), HID_FEATURE_REPORT);
+	return hid_output_raw_report(hdev, buf, sizeof(buf),
+				     HID_FEATURE_REPORT);
 }
 
 static void buzz_set_leds(struct hid_device *hdev, const __u8 *leds)
@@ -942,7 +943,7 @@ static void sixaxis_state_worker(struct work_struct *work)
 	buf[10] |= sc->led_state[2] << 3;
 	buf[10] |= sc->led_state[3] << 4;
 
-	sc->hdev->hid_output_raw_report(sc->hdev, buf, sizeof(buf),
+	hid_output_raw_report(sc->hdev, buf, sizeof(buf),
 					HID_OUTPUT_REPORT);
 }
 
diff --git a/drivers/hid/hid-thingm.c b/drivers/hid/hid-thingm.c
index 99342cf..7dd3197 100644
--- a/drivers/hid/hid-thingm.c
+++ b/drivers/hid/hid-thingm.c
@@ -48,8 +48,8 @@ static int blink1_send_command(struct blink1_data *data,
 			buf[0], buf[1], buf[2], buf[3], buf[4],
 			buf[5], buf[6], buf[7], buf[8]);
 
-	ret = data->hdev->hid_output_raw_report(data->hdev, buf,
-			BLINK1_CMD_SIZE, HID_FEATURE_REPORT);
+	ret = hid_output_raw_report(data->hdev, buf, BLINK1_CMD_SIZE,
+				    HID_FEATURE_REPORT);
 
 	return ret < 0 ? ret : 0;
 }
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 60c75dc..c720db9 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -128,8 +128,7 @@ static void wacom_set_image(struct hid_device *hdev, const char *image,
 
 	rep_data[0] = WAC_CMD_ICON_START_STOP;
 	rep_data[1] = 0;
-	ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
-				HID_FEATURE_REPORT);
+	ret = hid_output_raw_report(hdev, rep_data, 2, HID_FEATURE_REPORT);
 	if (ret < 0)
 		goto err;
 
@@ -143,15 +142,14 @@ static void wacom_set_image(struct hid_device *hdev, const char *image,
 			rep_data[j + 3] = p[(i << 6) + j];
 
 		rep_data[2] = i;
-		ret = hdev->hid_output_raw_report(hdev, rep_data, 67,
+		ret = hid_output_raw_report(hdev, rep_data, 67,
 					HID_FEATURE_REPORT);
 	}
 
 	rep_data[0] = WAC_CMD_ICON_START_STOP;
 	rep_data[1] = 0;
 
-	ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
-				HID_FEATURE_REPORT);
+	ret = hid_output_raw_report(hdev, rep_data, 2, HID_FEATURE_REPORT);
 
 err:
 	return;
@@ -183,7 +181,7 @@ static void wacom_leds_set_brightness(struct led_classdev *led_dev,
 		buf[3] = value;
 		/* use fixed brightness for OLEDs */
 		buf[4] = 0x08;
-		hdev->hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
+		hid_output_raw_report(hdev, buf, 9, HID_FEATURE_REPORT);
 		kfree(buf);
 	}
 
@@ -339,7 +337,7 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
 		limit = 3;
 		do {
-			ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+			ret = hid_output_raw_report(hdev, rep_data, 2,
 					HID_FEATURE_REPORT);
 		} while (ret < 0 && limit-- > 0);
 
@@ -352,7 +350,7 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 			rep_data[1] = 0x00;
 			limit = 3;
 			do {
-				ret = hdev->hid_output_raw_report(hdev,
+				ret = hid_output_raw_report(hdev,
 					rep_data, 2, HID_FEATURE_REPORT);
 			} while (ret < 0 && limit-- > 0);
 
@@ -378,7 +376,7 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
 		rep_data[0] = 0x03;
 		rep_data[1] = wdata->features;
 
-		ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
+		ret = hid_output_raw_report(hdev, rep_data, 2,
 					HID_FEATURE_REPORT);
 		if (ret >= 0)
 			wdata->high_speed = speed;
diff --git a/drivers/hid/hid-wiimote-core.c b/drivers/hid/hid-wiimote-core.c
index abb20db..d7dc6c5b 100644
--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -35,7 +35,7 @@ static int wiimote_hid_send(struct hid_device *hdev, __u8 *buffer,
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hdev->hid_output_raw_report(hdev, buf, count, HID_OUTPUT_REPORT);
+	ret = hid_output_raw_report(hdev, buf, count, HID_OUTPUT_REPORT);
 
 	kfree(buf);
 	return ret;
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 4b2dc95..f8708c9 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -153,7 +153,7 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
 		goto out_free;
 	}
 
-	ret = dev->hid_output_raw_report(dev, buf, count, report_type);
+	ret = hid_output_raw_report(dev, buf, count, report_type);
 out_free:
 	kfree(buf);
 out:
diff --git a/include/linux/hid.h b/include/linux/hid.h
index c56681a..a837ede 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1012,6 +1012,22 @@ static inline int hid_hw_output_report(struct hid_device *hdev, __u8 *buf,
 }
 
 /**
+ * hid_output_raw_report - send an output or a feature report to the device
+ *
+ * @hdev: hid device
+ * @buf: raw data to transfer
+ * @len: length of buf
+ * @report_type: HID_FEATURE_REPORT or HID_OUTPUT_REPORT
+ *
+ * @return: count of data transfered, negative if error
+ */
+static inline int hid_output_raw_report(struct hid_device *hdev, __u8 *buf,
+					size_t len, unsigned char report_type)
+{
+	return hdev->hid_output_raw_report(hdev, buf, len, report_type);
+}
+
+/**
  * hid_hw_idle - send idle request to device
  *
  * @hdev: hid device
-- 
1.8.3.1

