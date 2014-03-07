Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaCGBkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:40:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50975 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCGBkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:40:08 -0500
From: Tolga Cakir <cevelnet@gmail.com>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tolga Cakir <tolga@cevel.net>
Subject: [PATCH 1/1] HID: microsoft: adding support for Sidewinder X4 and X6 keyboards
Date: Fri,  7 Mar 2014 02:39:00 +0100
Message-Id: <1394156340-20650-1-git-send-email-tolga@cevel.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Sidewinder X4 and X6 gaming keyboards offer special keys,
which now can be read via sysfs, so they can be handled by user-space
tools. Profile switching support, LED support and macro pad
support (X6 only) are implemented aswell.

Both keyboards have been tested and run perfectly well.

Signed-off-by: Tolga Cakir <tolga@cevel.net>
---
 .../ABI/testing/sysfs-driver-hid-microsoft         |  31 ++
 drivers/hid/hid-core.c                             |   2 +
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-microsoft.c                        | 390 ++++++++++++++++++++-
 4 files changed, 410 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-microsoft

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-microsoft b/Documentation/ABI/testing/sysfs-driver-hid-microsoft
new file mode 100644
index 0000000..35a90c7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-microsoft
@@ -0,0 +1,31 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/auto_led
+Date:		March 2014
+Contact:	Tolga Cakir <cevelnet@gmail.com>
+Description:	This file allows you to set and view the Auto LED status.
+		Valid values are 0 and 1.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/profile
+Date:		March 2014
+Contact:	Tolga Cakir <cevelnet@gmail.com>
+Description:	Both, the Sidewinder X4 and the X6 can handle profiles.
+		They can be switched either by pressing the Bank switch button, or
+		writing to this file.
+		Valid values are 1 - 3.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/key_mask
+Date:		March 2014
+Contact:	Tolga Cakir <cevelnet@gmail.com>
+Description:	This file is read-only and outputs an unsigned long integer.
+		Every bit individually represents one of the S1 - S6 extra keys on
+		the Sidewinder X4 and S1 - S30 on the Sidewinder X6. The least
+		significant bit represents S1 on both gaming keyboards, the most
+		significant bit represents S6 on the Sidewinder X4 and S30 on the
+		Sidewinder X6 keyboard. Multiple special keys can be pressed at the
+		same time.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/record_led
+Date:		March 2014
+Contact:	Tolga Cakir <cevelnet@gmail.com>
+Description:	This file allows you to set and view the Record LED status.
+		Valid values are 0 - 2. 0 stands for off, 1 for solid mode and 2
+		for blinking mode.
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index cc32a6f..6b3435a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1774,6 +1774,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD_BOOTLOADER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_COMFORT_MOUSE_4500) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X6) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X4) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K_JP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 22f28d6..4268d35 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -623,6 +623,8 @@
 #define USB_DEVICE_ID_MS_PRESENTER_8K_BT	0x0701
 #define USB_DEVICE_ID_MS_PRESENTER_8K_USB	0x0713
 #define USB_DEVICE_ID_MS_DIGITAL_MEDIA_3K	0x0730
+#define USB_DEVICE_ID_SIDEWINDER_X6	0x074b
+#define USB_DEVICE_ID_SIDEWINDER_X4	0x0768
 #define USB_DEVICE_ID_MS_COMFORT_MOUSE_4500	0x076c
 #define USB_DEVICE_ID_MS_TOUCH_COVER_2	0x07a7
 #define USB_DEVICE_ID_MS_TYPE_COVER_2	0x07a9
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 404a3a8..154ac93 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -19,6 +19,8 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/sysfs.h>
+#include <linux/usb.h>
 
 #include "hid-ids.h"
 
@@ -29,24 +31,47 @@
 #define MS_NOGET		0x10
 #define MS_DUPLICATE_USAGES	0x20
 #define MS_RDESC_3K		0x40
+#define MS_SIDEWINDER	0x80
+
+struct ms_data {
+	unsigned long quirks;
+	void *extra;
+};
+
+/*
+ * For Sidewinder X4 / X6 devices.
+ * @profile: currently, only 3 profiles are used, eventhough it would
+ * be possible to set up more (combining LEDs 1 -3 for profile
+ * indication).
+ * @status: holds information about LED states and numpad mode (X6
+ * only). The 1st bit is for numpad mode, bits 2 - 7 are reserved for
+ * LED configuration and the last bit is currently unused.
+ * @key_mask: holds information about pressed special keys. It's
+ * readable via sysfs, so user-space tools can handle keypresses.
+ */
+struct ms_sidewinder_extra {
+	unsigned profile;
+	__u8 status;
+	unsigned long key_mask;
+};
 
 static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
 	/*
 	 * Microsoft Wireless Desktop Receiver (Model 1028) has
 	 * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
 	 */
-	if ((quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
+	if ((sc->quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
 			rdesc[559] == 0x29) {
 		hid_info(hdev, "fixing up Microsoft Wireless Receiver Model 1028 report descriptor\n");
 		rdesc[557] = 0x35;
 		rdesc[559] = 0x45;
 	}
 	/* the same as above (s/usage/physical/) */
-	if ((quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
+	if ((sc->quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
 			rdesc[95] == 0x00 && rdesc[96] == 0x29 &&
 			rdesc[97] == 0xff) {
 		rdesc[94] = 0x35;
@@ -96,25 +121,261 @@ static int ms_presenter_8k_quirk(struct hid_input *hi, struct hid_usage *usage,
 	return 1;
 }
 
+static int ms_sidewinder_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	set_bit(EV_REP, hi->input->evbit);
+	switch (usage->hid & HID_USAGE) {
+	/*
+	 * Registering Sidewinder X4 / X6 special keys. S1 - S6 macro keys
+	 * are shared between Sidewinder X4 & X6 and are programmable.
+	 */
+	case 0xfb01: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S1 */
+	case 0xfb02: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S2 */
+	case 0xfb03: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S3 */
+	case 0xfb04: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S4 */
+	case 0xfb05: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S5 */
+	case 0xfb06: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S6 */
+	/* S7 - S30 macro keys are only present on the Sidewinder X6 */
+	case 0xfb07: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S7 */
+	case 0xfb08: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S8 */
+	case 0xfb09: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S9 */
+	case 0xfb0a: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S10 */
+	case 0xfb0b: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S11 */
+	case 0xfb0c: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S12 */
+	case 0xfb0d: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S13 */
+	case 0xfb0e: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S14 */
+	case 0xfb0f: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S15 */
+	case 0xfb10: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S16 */
+	case 0xfb11: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S17 */
+	case 0xfb12: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S18 */
+	case 0xfb13: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S19 */
+	case 0xfb14: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S20 */
+	case 0xfb15: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S21 */
+	case 0xfb16: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S22 */
+	case 0xfb17: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S23 */
+	case 0xfb18: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S24 */
+	case 0xfb19: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S25 */
+	case 0xfb1a: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S26 */
+	case 0xfb1b: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S27 */
+	case 0xfb1c: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S28 */
+	case 0xfb1d: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S29 */
+	case 0xfb1e: ms_map_key_clear(KEY_UNKNOWN);	break;	/* S30 */
+	/* Not programmable keys: Profile, Game Center (X6 only) and Macro Key */
+	case 0xfd11: ms_map_key_clear(KEY_UNKNOWN);	break;	/* X6 only: Macro Pad toggle key*/
+	case 0xfd12: ms_map_key_clear(KEY_MACRO);	break;	/* Macro Record key */
+	case 0xfd15: ms_map_key_clear(KEY_UNKNOWN);	break;	/* Profile switch key */
+	default:
+		return 0;
+	}
+	return 1;
+}
+#undef ms_map_key_clear
+
+static int ms_sidewinder_control(struct hid_device *hdev, __u8 setup)
+{
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	struct hid_report *report =
+			hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[7];
+
+	/*
+	 * LEDs 1 - 3 should not be set simultaneously, however
+	 * they can be set in any combination with Auto or Record LEDs.
+	 */
+	report->field[0]->value[0] = (setup & 0x01) ? 0x01 : 0x00;	/* X6 only: Macro Pad toggle */
+	report->field[0]->value[1] = (setup & 0x02) ? 0x01 : 0x00;	/* LED Auto */
+	report->field[0]->value[2] = (setup & 0x04) ? 0x01 : 0x00;	/* LED 1 */
+	report->field[0]->value[3] = (setup & 0x08) ? 0x01 : 0x00;	/* LED 2 */
+	report->field[0]->value[4] = (setup & 0x10) ? 0x01 : 0x00;	/* LED 3 */
+	report->field[1]->value[0] = 0x00;	/* Clear Record LED */
+
+	switch (setup & 0x60) {
+	case 0x40: report->field[1]->value[0] = 0x02;	break;	/* Record LED Blink */
+	case 0x20: report->field[1]->value[0] = 0x03;	break;	/* Record LED Solid */
+	}
+
+	/*
+	 * Check if there are any changes, in order to avoid unnecessary
+	 * setup packets. Both, the Sidewinder X4 and X6, have identical
+	 * USB communication.
+	 */
+	if (sidewinder->status != setup) {
+		hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
+		sidewinder->status = setup;
+	}
+
+	return 0;
+}
+
+/*
+ * Sidewinder sysfs
+ * @key_mask: show pressed special keys
+ * @profile: show and set profile count and LED status
+ * @auto_led: show and set LED Auto
+ * @record_led: show and set Record LED
+ */
+static ssize_t ms_sidewinder_key_mask_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", sidewinder->key_mask);
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_key_mask = {
+	.attr = { .name = __stringify(key_mask), .mode = S_IRUGO },
+	.show = ms_sidewinder_key_mask_show
+};
+
+static ssize_t ms_sidewinder_profile_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1u\n", sidewinder->profile);
+}
+
+static ssize_t ms_sidewinder_profile_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	__u8 leds = sidewinder->status & ~(0x1c);	/* Clear Profile LEDs */
+
+	if (sscanf(buf, "%1u", &sidewinder->profile) != 1)
+		return -EINVAL;
+
+	if (sidewinder->profile >= 1 && sidewinder->profile <= 3) {
+		leds |= 0x02 << sidewinder->profile;
+		ms_sidewinder_control(hdev, leds);
+		return strnlen(buf, PAGE_SIZE);
+	} else {
+		return -EINVAL;
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_profile =
+	__ATTR(profile, S_IWUSR | S_IRUGO,
+		ms_sidewinder_profile_show,
+		ms_sidewinder_profile_store);
+
+static ssize_t ms_sidewinder_record_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1d\n", (sidewinder->status & 0x60) >> 5);
+}
+
+static ssize_t ms_sidewinder_record_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	unsigned int record_led;
+	__u8 leds;
+
+	if (sscanf(buf, "%1d", &record_led) != 1)
+		return -EINVAL;
+
+	if (record_led >= 0 && record_led <= 2) {
+		leds = sidewinder->status & ~(0xe0);	/* Clear Record LED */
+		if (record_led)
+			leds |= 0x10 << record_led;
+		ms_sidewinder_control(hdev, leds);
+		return strnlen(buf, PAGE_SIZE);
+	} else {
+		return -EINVAL;
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_record =
+	__ATTR(record_led, S_IWUSR | S_IRUGO,
+		ms_sidewinder_record_show,
+		ms_sidewinder_record_store);
+
+static ssize_t ms_sidewinder_auto_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1d\n", (sidewinder->status & 0x02) >> 1);	/* Check if Auto LED bit is set */
+}
+
+static ssize_t ms_sidewinder_auto_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	unsigned int auto_led;
+	__u8 leds;
+
+	if (sscanf(buf, "%1d", &auto_led) != 1)
+		return -EINVAL;
+
+	if (auto_led == 0 || auto_led == 1) {
+		leds = sidewinder->status & ~(0x02);	/* Clear Auto LED */
+		if (auto_led)
+			leds |= 0x02;
+		ms_sidewinder_control(hdev, leds);
+		return strnlen(buf, PAGE_SIZE);
+	} else {
+		return -EINVAL;
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_auto =
+	__ATTR(auto_led, S_IWUSR | S_IRUGO,
+		ms_sidewinder_auto_show,
+		ms_sidewinder_auto_store);
+
+static struct attribute *ms_attributes[] = {
+	&dev_attr_ms_sidewinder_key_mask.attr,
+	&dev_attr_ms_sidewinder_profile.attr,
+	&dev_attr_ms_sidewinder_record.attr,
+	&dev_attr_ms_sidewinder_auto.attr,
+	NULL
+};
+
+static const struct attribute_group ms_attr_group = {
+	.attrs = ms_attributes,
+};
+
 static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
 	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_MSVENDOR)
 		return 0;
 
-	if (quirks & MS_ERGONOMY) {
+	if (sc->quirks & MS_ERGONOMY) {
 		int ret = ms_ergonomy_kb_quirk(hi, usage, bit, max);
 		if (ret)
 			return ret;
 	}
 
-	if ((quirks & MS_PRESENTER) &&
+	if ((sc->quirks & MS_PRESENTER) &&
 			ms_presenter_8k_quirk(hi, usage, bit, max))
 		return 1;
 
+	if ((sc->quirks & MS_SIDEWINDER) &&
+			ms_sidewinder_kb_quirk(hi, usage, bit, max))
+		return 1;
+
 	return 0;
 }
 
@@ -122,25 +383,39 @@ static int ms_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
-	if (quirks & MS_DUPLICATE_USAGES)
+	if (sc->quirks & MS_DUPLICATE_USAGES)
 		clear_bit(usage->code, *bit);
 
 	return 0;
 }
 
+/* Setting initial profile and LED of Sidewinder keyboards */
+static void ms_feature_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage)
+{
+	struct ms_data *sc = hid_get_drvdata(hdev);
+
+	if (sc->quirks & MS_SIDEWINDER) {
+		struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+		sidewinder->profile = 1;
+		ms_sidewinder_control(hdev, 0x02 << sidewinder->profile);
+	}
+}
+
 static int ms_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
-	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
 
 	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput ||
 			!usage->type)
 		return 0;
 
 	/* Handling MS keyboards special buttons */
-	if (quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
+	if (sc->quirks & MS_ERGONOMY && usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
 		struct input_dev *input = field->hidinput->input;
 		static unsigned int last_key = 0;
 		unsigned int key = 0;
@@ -154,8 +429,53 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 		if (key) {
 			input_event(input, usage->type, key, 1);
 			last_key = key;
-		} else
+		} else {
 			input_event(input, usage->type, last_key, 0);
+		}
+
+		return 1;
+	}
+
+	/*
+	 * Sidewinder special button handling & profile switching
+	 *
+	 * Pressing S1 - S30 macro keys will not send out any keycodes, but
+	 * set bits on key_mask (readable via sysfs). It's possible to press
+	 * multiple special keys at the same time.
+	 */
+	if (sc->quirks & MS_SIDEWINDER) {
+		struct input_dev *input = field->hidinput->input;
+		struct ms_sidewinder_extra *sidewinder = sc->extra;
+		int i;
+
+		for (i = 0; i <= 29; i++) {	/* Run through S1 - S30 keys */
+			if ((usage->hid & HID_USAGE) == (0xfb01 + i)) {
+				value ? set_bit(i, &sidewinder->key_mask) : clear_bit(i, &sidewinder->key_mask);
+				break;	/* Exit loop, when correct hid usage has been found */
+			}
+		}
+
+		switch (usage->hid & HID_USAGE) {
+		case 0xfd11:
+			if (value) {	/* Run this only once on a keypress */
+				__u8 numpad = sidewinder->status ^ (0x01);	/* Toggle Macro Pad */
+				ms_sidewinder_control(hdev, numpad);
+			}
+			break;
+		case 0xfd12: input_event(input, usage->type, KEY_MACRO, value);	break;
+		case 0xfd15:
+			if (value) {	/* Run this only once on a keypress */
+				__u8 leds = sidewinder->status & ~(0x1c);	/* Clear Profile LEDs */
+				if (sidewinder->profile < 1 || sidewinder->profile >= 3) {
+					sidewinder->profile = 1;
+				} else
+					sidewinder->profile++;
+
+				leds |= 0x02 << sidewinder->profile;	/* Set Profile LEDs */
+				ms_sidewinder_control(hdev, leds);
+			}
+			break;
+		}
 
 		return 1;
 	}
@@ -165,21 +485,47 @@ static int ms_event(struct hid_device *hdev, struct hid_field *field,
 
 static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
-	unsigned long quirks = id->driver_data;
+	struct ms_data *sc;
 	int ret;
 
-	hid_set_drvdata(hdev, (void *)quirks);
+	sc = devm_kzalloc(&hdev->dev, sizeof(struct ms_data), GFP_KERNEL);
+	if (!sc) {
+		hid_err(hdev, "can't alloc microsoft descriptor\n");
+		return -ENOMEM;
+	}
+
+	sc->quirks = id->driver_data;
+	hid_set_drvdata(hdev, sc);
 
-	if (quirks & MS_NOGET)
+	if (sc->quirks & MS_NOGET)
 		hdev->quirks |= HID_QUIRK_NOGET;
 
+	if (sc->quirks & MS_SIDEWINDER) {
+		struct ms_sidewinder_extra *sidewinder;
+
+		sidewinder = devm_kzalloc(&hdev->dev, sizeof(struct ms_sidewinder_extra),
+					GFP_KERNEL);
+		if (!sidewinder) {
+			hid_err(hdev, "can't alloc microsoft descriptor\n");
+			return -ENOMEM;
+		}
+		sc->extra = sidewinder;
+
+		/* Create sysfs files for the Consumer Control Device only */
+		if (hdev->type == 2) {
+			if (sysfs_create_group(&hdev->dev.kobj, &ms_attr_group)) {
+				hid_warn(hdev, "Could not create sysfs group\n");
+			}
+		}
+	}
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
-	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((quirks & MS_HIDINPUT) ?
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((sc->quirks & MS_HIDINPUT) ?
 				HID_CONNECT_HIDINPUT_FORCE : 0));
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
@@ -191,9 +537,21 @@ err_free:
 	return ret;
 }
 
+static void ms_remove(struct hid_device *hdev)
+{
+	sysfs_remove_group(&hdev->dev.kobj,
+		&ms_attr_group);
+
+	hid_hw_stop(hdev);
+}
+
 static const struct hid_device_id ms_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV),
 		.driver_data = MS_HIDINPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X6),
+		.driver_data = MS_SIDEWINDER },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_X4),
+		.driver_data = MS_SIDEWINDER },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K),
 		.driver_data = MS_ERGONOMY },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K_JP),
@@ -225,8 +583,10 @@ static struct hid_driver ms_driver = {
 	.report_fixup = ms_report_fixup,
 	.input_mapping = ms_input_mapping,
 	.input_mapped = ms_input_mapped,
+	.feature_mapping = ms_feature_mapping,
 	.event = ms_event,
 	.probe = ms_probe,
+	.remove = ms_remove,
 };
 module_hid_driver(ms_driver);
 
-- 
1.9.0

