Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaG2Sne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaG2Snc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:43:32 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v3 3/7] Input - wacom: handle Intuos 4 BT in wacom.ko
Date: Tue, 29 Jul 2014 14:43:01 -0400
Message-Id: <1406659385-3256-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A good point of this change is that now, the Intuos4 bluetooth can handle
the different tools (artpen, airbrush, mice), and we get a common interface
between USB and BT for accessing the LEDs/OLEDs.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c  |  1 -
 drivers/hid/hid-wacom.c |  1 -
 drivers/hid/wacom_sys.c | 16 +++++++++++
 drivers/hid/wacom_wac.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/wacom_wac.h |  1 +
 5 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d824a45..774e5b6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1943,7 +1943,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_JOY_BOX_3_PRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_DUAL_BOX_PRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_JOY_BOX_5_PRO) },
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_5_8_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_Q_PAD) },
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 967c457..db2d07d 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -952,7 +952,6 @@ static void wacom_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id wacom_devices[] = {
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH) },
 
 	{ }
 };
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index c21e58b..f5c9c56 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -296,6 +296,20 @@ static int wacom_bt_query_tablet_data(struct hid_device *hdev, u8 speed,
 		hid_warn(hdev, "failed to poke device, command %d, err %d\n",
 			 rep_data[0], ret);
 		break;
+	case INTUOS4WL:
+		if (speed == 1)
+			wacom->wacom_wac.bt_features &= ~0x20;
+		else
+			wacom->wacom_wac.bt_features |= 0x20;
+
+		rep_data[0] = 0x03;
+		rep_data[1] = wacom->wacom_wac.bt_features;
+
+		ret = wacom_set_report(hdev, HID_FEATURE_REPORT,
+					rep_data[0], rep_data, 2, 1);
+		if (ret >= 0)
+			wacom->wacom_wac.bt_high_speed = speed;
+		break;
 	}
 
 	return 0;
@@ -720,6 +734,7 @@ static int wacom_initialize_leds(struct wacom *wacom)
 	switch (wacom->wacom_wac.features.type) {
 	case INTUOS4S:
 	case INTUOS4:
+	case INTUOS4WL:
 	case INTUOS4L:
 		wacom->led.select[0] = 0;
 		wacom->led.select[1] = 0;
@@ -786,6 +801,7 @@ static void wacom_destroy_leds(struct wacom *wacom)
 	switch (wacom->wacom_wac.features.type) {
 	case INTUOS4S:
 	case INTUOS4:
+	case INTUOS4WL:
 	case INTUOS4L:
 		sysfs_remove_group(&wacom->hdev->dev.kobj,
 				   &intuos4_led_attr_group);
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index ac891dc..4670db8 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -34,6 +34,9 @@
   8th value means AC online and show 100% capacity */
 static unsigned short batcap_gr[8] = { 1, 15, 25, 35, 50, 70, 100, 100 };
 
+/*percent of battery capacity for Intuos4 WL, AC has a separate bit*/
+static unsigned short batcap_i4[8] = { 1, 15, 30, 45, 60, 70, 85, 100 };
+
 static int wacom_penpartner_irq(struct wacom_wac *wacom)
 {
 	unsigned char *data = wacom->data;
@@ -950,6 +953,58 @@ static int int_dist(int x1, int y1, int x2, int y2)
 	return int_sqrt(x*x + y*y);
 }
 
+static void wacom_intuos_bt_process_data(struct wacom_wac *wacom,
+		unsigned char *data)
+{
+	memcpy(wacom->data, data, 10);
+	wacom_intuos_irq(wacom);
+
+	input_sync(wacom->input);
+	if (wacom->pad_input)
+		input_sync(wacom->pad_input);
+}
+
+static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
+{
+	unsigned char data[WACOM_PKGLEN_MAX];
+	int i = 1;
+	unsigned power_raw, battery_capacity, bat_charging, ps_connected;
+
+	memcpy(data, wacom->data, len);
+
+	switch (data[0]) {
+	case 0x04:
+		wacom_intuos_bt_process_data(wacom, data + i);
+		i += 10;
+		/* fall through */
+	case 0x03:
+		wacom_intuos_bt_process_data(wacom, data + i);
+		i += 10;
+		wacom_intuos_bt_process_data(wacom, data + i);
+		i += 10;
+		power_raw = data[i];
+		bat_charging = (power_raw & 0x08) ? 1 : 0;
+		ps_connected = (power_raw & 0x10) ? 1 : 0;
+		battery_capacity = batcap_i4[power_raw & 0x07];
+		if ((wacom->battery_capacity != battery_capacity) ||
+		    (wacom->bat_charging != bat_charging) ||
+		    (wacom->ps_connected != ps_connected)) {
+			wacom->battery_capacity = battery_capacity;
+			wacom->bat_charging = bat_charging;
+			wacom->ps_connected = ps_connected;
+			wacom_notify_battery(wacom);
+		}
+
+		break;
+	default:
+		dev_dbg(wacom->input->dev.parent,
+				"Unknown report: %d,%d size:%li\n",
+				data[0], data[1], len);
+		return 0;
+	}
+	return 0;
+}
+
 static int wacom_24hdt_irq(struct wacom_wac *wacom)
 {
 	struct input_dev *input = wacom->input;
@@ -1509,6 +1564,10 @@ void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
 		sync = wacom_intuos_irq(wacom_wac);
 		break;
 
+	case INTUOS4WL:
+		sync = wacom_intuos_bt_irq(wacom_wac, len);
+		break;
+
 	case WACOM_24HDT:
 		sync = wacom_24hdt_irq(wacom_wac);
 		break;
@@ -1800,6 +1859,7 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 		break;
 
 	case INTUOS4:
+	case INTUOS4WL:
 	case INTUOS4L:
 	case INTUOS4S:
 		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
@@ -2062,6 +2122,15 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 		input_set_abs_params(input_dev, ABS_WHEEL, 0, 71, 0, 0);
 		break;
 
+	case INTUOS4WL:
+		/*
+		 * For Bluetooth devices, the udev rule does not work correctly
+		 * for pads unless we add a stylus capability, which forces
+		 * ID_INPUT_TABLET to be set.
+		 */
+		__set_bit(BTN_STYLUS, input_dev->keybit);
+		/* fall through */
+
 	case INTUOS4:
 	case INTUOS4L:
 		__set_bit(BTN_7, input_dev->keybit);
@@ -2276,6 +2345,9 @@ static const struct wacom_features wacom_features_0xBB =
 static const struct wacom_features wacom_features_0xBC =
 	{ "Wacom Intuos4 WL", 40640, 25400, 2047, 63,
 	  INTUOS4, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
+static const struct wacom_features wacom_features_0xBD =
+	{ "Wacom Intuos4 WL", 40640, 25400, 2047, 63,
+	  INTUOS4WL, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
 static const struct wacom_features wacom_features_0x26 =
 	{ "Wacom Intuos5 touch S", 31496, 19685, 2047, 63,
 	  INTUOS5S, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, .touch_max = 16 };
@@ -2592,6 +2664,7 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xBA) },
 	{ USB_DEVICE_WACOM(0xBB) },
 	{ USB_DEVICE_WACOM(0xBC) },
+	{ BT_DEVICE_WACOM(0xBD) },
 	{ USB_DEVICE_WACOM(0xC0) },
 	{ USB_DEVICE_WACOM(0xC2) },
 	{ USB_DEVICE_WACOM(0xC4) },
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 0f3df34..5039357 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -86,6 +86,7 @@ enum {
 	INTUOS3L,
 	INTUOS4S,
 	INTUOS4,
+	INTUOS4WL,
 	INTUOS4L,
 	INTUOS5S,
 	INTUOS5,
-- 
2.0.3

