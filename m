Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaG2Sna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:43:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaG2Sn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:43:28 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v3 1/7] Input - wacom: prepare the driver to include BT devices
Date: Tue, 29 Jul 2014 14:42:59 -0400
Message-Id: <1406659385-3256-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that wacom is a hid driver, there is no point in having a separate
driver for bluetooth devices.
This patch prepares the common paths of Bluetooth devices in the
common wacom driver.
It also adds the sysfs file "speed" used by Bluetooth devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/hid/wacom_wac.h |  2 ++
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 37888c3..18154a5 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -262,6 +262,12 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
 	return error < 0 ? error : 0;
 }
 
+static int wacom_bt_query_tablet_data(struct hid_device *hdev, u8 speed,
+		struct wacom_features *features)
+{
+	return 0;
+}
+
 /*
  * Switch the tablet into its most-capable mode. Wacom tablets are
  * typically configured to power-up in a mode which sends mouse-like
@@ -272,6 +278,9 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
 static int wacom_query_tablet_data(struct hid_device *hdev,
 		struct wacom_features *features)
 {
+	if (hdev->bus == BUS_BLUETOOTH)
+		return wacom_bt_query_tablet_data(hdev, 1, features);
+
 	if (features->device_type == BTN_TOOL_FINGER) {
 		if (features->type > TABLETPC) {
 			/* MT Tablet PC touch */
@@ -890,6 +899,38 @@ static void wacom_destroy_battery(struct wacom *wacom)
 	}
 }
 
+static ssize_t wacom_show_speed(struct device *dev,
+				struct device_attribute
+				*attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct wacom *wacom = hid_get_drvdata(hdev);
+
+	return snprintf(buf, PAGE_SIZE, "%i\n", wacom->wacom_wac.bt_high_speed);
+}
+
+static ssize_t wacom_store_speed(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	u8 new_speed;
+
+	if (kstrtou8(buf, 0, &new_speed))
+		return -EINVAL;
+
+	if (new_speed != 0 && new_speed != 1)
+		return -EINVAL;
+
+	wacom_bt_query_tablet_data(hdev, new_speed, &wacom->wacom_wac.features);
+
+	return count;
+}
+
+static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR | S_IWGRP,
+		wacom_show_speed, wacom_store_speed);
+
 static struct input_dev *wacom_allocate_input(struct wacom *wacom)
 {
 	struct input_dev *input_dev;
@@ -1210,6 +1251,9 @@ static int wacom_probe(struct hid_device *hdev,
 		features->y_max = 4096;
 	}
 
+	if (hdev->bus == BUS_BLUETOOTH)
+		features->quirks |= WACOM_QUIRK_BATTERY;
+
 	wacom_setup_device_quirks(features);
 
 	/* set unit to "100th of a mm" for devices not reported by HID */
@@ -1241,10 +1285,25 @@ static int wacom_probe(struct hid_device *hdev,
 	if (error)
 		goto fail2;
 
+	if (!(features->quirks & WACOM_QUIRK_MONITOR) &&
+	     (features->quirks & WACOM_QUIRK_BATTERY)) {
+		error = wacom_initialize_battery(wacom);
+		if (error)
+			goto fail3;
+	}
+
 	if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
 		error = wacom_register_inputs(wacom);
 		if (error)
-			goto fail3;
+			goto fail4;
+	}
+
+	if (hdev->bus == BUS_BLUETOOTH) {
+		error = device_create_file(&hdev->dev, &dev_attr_speed);
+		if (error)
+			hid_warn(hdev,
+				 "can't create sysfs speed attribute err: %d\n",
+				 error);
 	}
 
 	/* Note that if query fails it is not a hard failure */
@@ -1254,7 +1313,7 @@ static int wacom_probe(struct hid_device *hdev,
 	error = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
 	if (error) {
 		hid_err(hdev, "hw start failed\n");
-		goto fail4;
+		goto fail5;
 	}
 
 	if (features->quirks & WACOM_QUIRK_MONITOR)
@@ -1267,7 +1326,10 @@ static int wacom_probe(struct hid_device *hdev,
 
 	return 0;
 
- fail4:	wacom_unregister_inputs(wacom);
+ fail5:	if (hdev->bus == BUS_BLUETOOTH)
+		device_remove_file(&hdev->dev, &dev_attr_speed);
+	wacom_unregister_inputs(wacom);
+ fail4:	wacom_destroy_battery(wacom);
  fail3:	wacom_destroy_leds(wacom);
  fail2:	wacom_remove_shared_data(wacom_wac);
  fail1:	kfree(wacom);
@@ -1283,6 +1345,8 @@ static void wacom_remove(struct hid_device *hdev)
 
 	cancel_work_sync(&wacom->work);
 	wacom_unregister_inputs(wacom);
+	if (hdev->bus == BUS_BLUETOOTH)
+		device_remove_file(&hdev->dev, &dev_attr_speed);
 	wacom_destroy_battery(wacom);
 	wacom_destroy_leds(wacom);
 	wacom_remove_shared_data(&wacom->wacom_wac);
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 3433a0e..3aa55d9 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -169,6 +169,8 @@ struct wacom_wac {
 	int num_contacts_left;
 	int bat_charging;
 	int ps_connected;
+	__u8 bt_features;
+	__u8 bt_high_speed;
 };
 
 #endif
-- 
2.0.3

