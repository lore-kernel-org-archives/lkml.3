Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaIWQIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaIWQIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:22 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        killertofu@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] HID: wacom: implement generic HID handling for pen generic devices
Date: Tue, 23 Sep 2014 12:08:08 -0400
Message-Id: <1411488489-10625-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISDv4 and v5 are plain HID devices. We can directly implement a generic
HID parsing/handling and remove the need to manually add those PID in
the list of supported devices.

This patch implements the pen support only. The finger part will come in
a later patch.

To be properly notified of an .event() and a .report(), we need to force
hid-core to go through the HID parsing. By default, wacom.ko binds only
hidraw, so the hid parsing is not done by hid-core. When a true HID device
is there, we add the flag HID_CLAIMED_DRIVER to hid->claimed which will
force hid-core to parse the incoming reports.
(Note that this can be easily backported by directly setting the .claimed
flag to HID_CLAIMED_DRIVER even if hid-core does not support
HID_CONNECT_DRIVER)

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c  |   3 +
 drivers/hid/wacom.h     |   6 ++
 drivers/hid/wacom_sys.c |  12 +++-
 drivers/hid/wacom_wac.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/wacom_wac.h |   8 +++
 include/linux/hid.h     |   2 +
 6 files changed, 208 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb50818..73bd9e2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1591,6 +1591,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 	if ((connect_mask & HID_CONNECT_HIDRAW) && !hidraw_connect(hdev))
 		hdev->claimed |= HID_CLAIMED_HIDRAW;
 
+	if (connect_mask & HID_CONNECT_DRIVER)
+		hdev->claimed |= HID_CLAIMED_DRIVER;
+
 	/* Drivers with the ->raw_event callback set are not required to connect
 	 * to any other listener. */
 	if (!hdev->claimed && !hdev->driver->raw_event) {
diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index 64bc1b2..0cc5344 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -89,6 +89,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
+#include <linux/hid.h>
 #include <linux/usb/input.h>
 #include <linux/power_supply.h>
 #include <asm/unaligned.h>
@@ -143,4 +144,9 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 				   struct wacom_wac *wacom_wac);
 int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
 				       struct wacom_wac *wacom_wac);
+void wacom_wac_usage_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage);
+int wacom_wac_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value);
+void wacom_wac_report(struct hid_device *hdev, struct hid_report *report);
 #endif
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 21ac2ba..dd288b2 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -13,7 +13,6 @@
 
 #include "wacom_wac.h"
 #include "wacom.h"
-#include <linux/hid.h>
 
 #define WAC_MSG_RETRIES		5
 
@@ -215,6 +214,9 @@ static void wacom_usage_mapping(struct hid_device *hdev,
 			features->pressure_max = field->logical_maximum;
 		break;
 	}
+
+	if (features->type == HID_GENERIC)
+		wacom_wac_usage_mapping(hdev, field, usage);
 }
 
 static void wacom_parse_hid(struct hid_device *hdev,
@@ -1318,6 +1320,7 @@ static int wacom_probe(struct hid_device *hdev,
 	struct wacom_wac *wacom_wac;
 	struct wacom_features *features;
 	int error;
+	unsigned int connect_mask = HID_CONNECT_HIDRAW;
 
 	if (!id->driver_data)
 		return -EINVAL;
@@ -1451,8 +1454,11 @@ static int wacom_probe(struct hid_device *hdev,
 	/* Note that if query fails it is not a hard failure */
 	wacom_query_tablet_data(hdev, features);
 
+	if (features->type == HID_GENERIC)
+		connect_mask |= HID_CONNECT_DRIVER;
+
 	/* Regular HID work starts now */
-	error = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	error = hid_hw_start(hdev, connect_mask);
 	if (error) {
 		hid_err(hdev, "hw start failed\n");
 		goto fail_hw_start;
@@ -1532,6 +1538,8 @@ static struct hid_driver wacom_driver = {
 	.id_table =	wacom_ids,
 	.probe =	wacom_probe,
 	.remove =	wacom_remove,
+	.event =	wacom_wac_event,
+	.report =	wacom_wac_report,
 #ifdef CONFIG_PM
 	.resume =	wacom_resume,
 	.reset_resume =	wacom_reset_resume,
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index b8180e4..e77d46d 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1248,6 +1248,176 @@ static int wacom_tpc_irq(struct wacom_wac *wacom, size_t len)
 	return 0;
 }
 
+static void wacom_map_usage(struct wacom *wacom, struct hid_usage *usage,
+		struct hid_field *field, __u8 type, __u16 code, int fuzz)
+{
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct input_dev *input = wacom_wac->input;
+	int fmin = field->logical_minimum;
+	int fmax = field->logical_maximum;
+
+	usage->type = type;
+	usage->code = code;
+
+	set_bit(type, input->evbit);
+
+	switch (type) {
+	case EV_ABS:
+		input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
+		input_abs_set_res(input, code,
+				  hidinput_calc_abs_res(field, code));
+		break;
+	case EV_KEY:
+		input_set_capability(input, EV_KEY, code);
+		break;
+	case EV_MSC:
+		input_set_capability(input, EV_MSC, code);
+		break;
+	}
+}
+
+static void wacom_wac_pen_usage_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+
+	switch (usage->hid) {
+	case HID_GD_X:
+		wacom_map_usage(wacom, usage, field, EV_ABS, ABS_X, 4);
+		break;
+	case HID_GD_Y:
+		wacom_map_usage(wacom, usage, field, EV_ABS, ABS_Y, 4);
+		break;
+	case HID_DG_TIPPRESSURE:
+		wacom_map_usage(wacom, usage, field, EV_ABS, ABS_PRESSURE, 0);
+		break;
+	case HID_DG_INRANGE:
+		wacom_map_usage(wacom, usage, field, EV_KEY, BTN_TOOL_PEN, 0);
+		break;
+	case HID_DG_INVERT:
+		wacom_map_usage(wacom, usage, field, EV_KEY,
+				BTN_TOOL_RUBBER, 0);
+		break;
+	case HID_DG_ERASER:
+	case HID_DG_TIPSWITCH:
+		wacom_map_usage(wacom, usage, field, EV_KEY, BTN_TOUCH, 0);
+		break;
+	case HID_DG_BARRELSWITCH:
+		wacom_map_usage(wacom, usage, field, EV_KEY, BTN_STYLUS, 0);
+		break;
+	case HID_DG_BARRELSWITCH2:
+		wacom_map_usage(wacom, usage, field, EV_KEY, BTN_STYLUS2, 0);
+		break;
+	case HID_DG_TOOLSERIALNUMBER:
+		wacom_map_usage(wacom, usage, field, EV_MSC, MSC_SERIAL, 0);
+		break;
+	}
+}
+
+static int wacom_wac_pen_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct input_dev *input = wacom_wac->input;
+
+	/* checking which Tool / tip switch to send */
+	switch (usage->hid) {
+	case HID_DG_INRANGE:
+		wacom_wac->hid_data.inrange_state = value;
+		return 0;
+	case HID_DG_INVERT:
+		wacom_wac->hid_data.invert_state = value;
+		return 0;
+	case HID_DG_ERASER:
+	case HID_DG_TIPSWITCH:
+		wacom_wac->hid_data.tipswitch |= value;
+		return 0;
+	}
+
+	/* send pen events only when touch is up or forced out */
+	if (!usage->type || wacom_wac->shared->touch_down)
+		return 0;
+
+	input_event(input, usage->type, usage->code, value);
+
+	return 0;
+}
+
+static void wacom_wac_pen_report(struct hid_device *hdev,
+		struct hid_report *report)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct input_dev *input = wacom_wac->input;
+	bool prox = wacom_wac->hid_data.inrange_state;
+
+	if (!wacom_wac->shared->stylus_in_proximity) /* first in prox */
+		/* Going into proximity select tool */
+		wacom_wac->tool[0] = wacom_wac->hid_data.invert_state ?
+						BTN_TOOL_RUBBER : BTN_TOOL_PEN;
+
+	/* keep pen state for touch events */
+	wacom_wac->shared->stylus_in_proximity = prox;
+
+	/* send pen events only when touch is up or forced out */
+	if (!wacom_wac->shared->touch_down) {
+		input_report_key(input, BTN_TOUCH,
+				wacom_wac->hid_data.tipswitch);
+		input_report_key(input, wacom_wac->tool[0], prox);
+
+		wacom_wac->hid_data.tipswitch = false;
+
+		input_sync(input);
+	}
+}
+
+#define WACOM_PEN_FIELD(f)	(((f)->logical == HID_DG_STYLUS) || \
+				 ((f)->physical == HID_DG_STYLUS))
+#define WACOM_FINGER_FIELD(f)	(((f)->logical == HID_DG_FINGER) || \
+				 ((f)->physical == HID_DG_FINGER))
+
+void wacom_wac_usage_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct input_dev *input = wacom_wac->input;
+
+	/* currently, only direct devices have proper hid report descriptors */
+	__set_bit(INPUT_PROP_DIRECT, input->propbit);
+
+	if (WACOM_PEN_FIELD(field))
+		return wacom_wac_pen_usage_mapping(hdev, field, usage);
+}
+
+int wacom_wac_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+
+	if (wacom->wacom_wac.features.type != HID_GENERIC)
+		return 0;
+
+	if (WACOM_PEN_FIELD(field))
+		return wacom_wac_pen_event(hdev, field, usage, value);
+
+	return 0;
+}
+
+void wacom_wac_report(struct hid_device *hdev, struct hid_report *report)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct hid_field *field = report->field[0];
+
+	if (wacom_wac->features.type != HID_GENERIC)
+		return;
+
+	if (WACOM_PEN_FIELD(field))
+		return wacom_wac_pen_report(hdev, report);
+}
+
 static int wacom_bpt_touch(struct wacom_wac *wacom)
 {
 	struct wacom_features *features = &wacom->features;
@@ -1746,6 +1916,10 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 
+	if (features->type == HID_GENERIC)
+		/* setup has already been done */
+		return 0;
+
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(ABS_MISC, input_dev->absbit);
 
@@ -2585,6 +2759,9 @@ static const struct wacom_features wacom_features_0x30C =
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x30A, .touch_max = 10,
 	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 
+static const struct wacom_features wacom_features_HID_ANY_ID =
+	{ "Wacom HID", .type = HID_GENERIC };
+
 #define USB_DEVICE_WACOM(prod)						\
 	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -2729,6 +2906,8 @@ const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },
 	{ USB_DEVICE_WACOM(0x5002) },
+
+	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, wacom_ids);
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 72f9ca8..f472eac 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -113,6 +113,7 @@ enum {
 	MTSCREEN,
 	MTTPC,
 	MTTPC_B,
+	HID_GENERIC,
 	MAX_TYPE
 };
 
@@ -154,6 +155,12 @@ struct wacom_shared {
 	struct input_dev *touch_input;
 };
 
+struct hid_data {
+	bool inrange_state;
+	bool invert_state;
+	bool tipswitch;
+};
+
 struct wacom_wac {
 	char name[WACOM_NAME_MAX];
 	char pad_name[WACOM_NAME_MAX];
@@ -175,6 +182,7 @@ struct wacom_wac {
 	int ps_connected;
 	u8 bt_features;
 	u8 bt_high_speed;
+	struct hid_data hid_data;
 };
 
 #endif
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 26ee25f..78ea9bf 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -265,6 +265,7 @@ struct hid_item {
 #define HID_CONNECT_HIDDEV		0x08
 #define HID_CONNECT_HIDDEV_FORCE	0x10
 #define HID_CONNECT_FF			0x20
+#define HID_CONNECT_DRIVER		0x40
 #define HID_CONNECT_DEFAULT	(HID_CONNECT_HIDINPUT|HID_CONNECT_HIDRAW| \
 		HID_CONNECT_HIDDEV|HID_CONNECT_FF)
 
@@ -441,6 +442,7 @@ struct hid_output_fifo {
 #define HID_CLAIMED_INPUT	1
 #define HID_CLAIMED_HIDDEV	2
 #define HID_CLAIMED_HIDRAW	4
+#define HID_CLAIMED_DRIVER	8
 
 #define HID_STAT_ADDED		1
 #define HID_STAT_PARSED		2
-- 
2.1.0

