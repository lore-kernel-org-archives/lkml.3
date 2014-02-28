Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaB1Qlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:41:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbaB1Qlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:41:39 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] HID: multitouch: add support of other generic collections in hid-mt
Date: Fri, 28 Feb 2014 11:41:25 -0500
Message-Id: <1393605685-17025-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ANTON Touch Pad is a device which can switch from a multitouch
touchpad to a mouse. It thus presents several generic collections which
are currently ignored by hid-multitouch. Enable them by not ignoring
them in mt_input_mapping.
Adding also a suffix for them depending on their application.

Reported-by: Edel Maks <edelmaks@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-ids.h        |  3 ++
 drivers/hid/hid-multitouch.c | 82 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/hid.h          |  3 ++
 3 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 00be0d0..7045a71 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -67,6 +67,9 @@
 #define USB_VENDOR_ID_ALPS		0x0433
 #define USB_DEVICE_ID_IBM_GAMEPAD	0x1101
 
+#define USB_VENDOR_ID_ANTON		0x1130
+#define USB_DEVICE_ID_ANTON_TOUCH_PAD	0x3101
+
 #define USB_VENDOR_ID_APPLE		0x05ac
 #define USB_DEVICE_ID_APPLE_MIGHTYMOUSE	0x0304
 #define USB_DEVICE_ID_APPLE_MAGICMOUSE	0x030d
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 8250cc0..0d31139 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -84,6 +84,7 @@ struct mt_class {
 	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
 	__u8 maxcontacts;
 	bool is_indirect;	/* true for touchpads */
+	bool export_all_inputs;	/* do not ignore mouse, keyboards, etc... */
 };
 
 struct mt_fields {
@@ -133,6 +134,7 @@ static void mt_post_parse(struct mt_device *td);
 /* reserved					0x0010 */
 /* reserved					0x0011 */
 #define MT_CLS_WIN_8				0x0012
+#define MT_CLS_EXPORT_ALL_INPUTS		0x0013
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -196,6 +198,10 @@ static struct mt_class mt_classes[] = {
 			MT_QUIRK_IGNORE_DUPLICATES |
 			MT_QUIRK_HOVERING |
 			MT_QUIRK_CONTACT_CNT_ACCURATE },
+	{ .name = MT_CLS_EXPORT_ALL_INPUTS,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -718,28 +724,52 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	/* Only map fields from TouchScreen or TouchPad collections.
-	* We need to ignore fields that belong to other collections
-	* such as Mouse that might have the same GenericDesktop usages. */
-	if (field->application != HID_DG_TOUCHSCREEN &&
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	/*
+	 * If mtclass.export_all_inputs is not set, only map fields from
+	 * TouchScreen or TouchPad collections. We need to ignore fields
+	 * that belong to other collections such as Mouse that might have
+	 * the same GenericDesktop usages.
+	 */
+	if (!td->mtclass.export_all_inputs &&
+	    field->application != HID_DG_TOUCHSCREEN &&
 	    field->application != HID_DG_PEN &&
 	    field->application != HID_DG_TOUCHPAD)
 		return -1;
 
+	/*
+	 * some egalax touchscreens have "application == HID_DG_TOUCHSCREEN"
+	 * for the stylus.
+	 */
 	if (field->physical == HID_DG_STYLUS)
 		return 0;
 
-	return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
+	if (field->application == HID_DG_TOUCHSCREEN ||
+	    field->application == HID_DG_TOUCHPAD)
+		return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
+
+	/* let hid-core decide for the others */
+	return 0;
 }
 
 static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	/*
+	 * some egalax touchscreens have "application == HID_DG_TOUCHSCREEN"
+	 * for the stylus.
+	 */
 	if (field->physical == HID_DG_STYLUS)
 		return 0;
 
-	return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
+	if (field->application == HID_DG_TOUCHSCREEN ||
+	    field->application == HID_DG_TOUCHPAD)
+		return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
+
+	/* let hid-core decide for the others */
+	return 0;
 }
 
 static int mt_event(struct hid_device *hid, struct hid_field *field,
@@ -846,14 +876,49 @@ static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	struct mt_device *td = hid_get_drvdata(hdev);
 	char *name;
 	const char *suffix = NULL;
+	struct hid_field *field = hi->report->field[0];
 
 	if (hi->report->id == td->mt_report_id)
 		mt_touch_input_configured(hdev, hi);
 
+	/*
+	 * some egalax touchscreens have "application == HID_DG_TOUCHSCREEN"
+	 * for the stylus. Check this first, and then rely on the application
+	 * field.
+	 */
 	if (hi->report->field[0]->physical == HID_DG_STYLUS) {
 		suffix = "Pen";
 		/* force BTN_STYLUS to allow tablet matching in udev */
 		__set_bit(BTN_STYLUS, hi->input->keybit);
+	} else {
+		switch (field->application) {
+		case HID_GD_KEYBOARD:
+			suffix = "Keyboard";
+			break;
+		case HID_GD_KEYPAD:
+			suffix = "Keypad";
+			break;
+		case HID_GD_MOUSE:
+			suffix = "Mouse";
+			break;
+		case HID_DG_STYLUS:
+			suffix = "Pen";
+			/* force BTN_STYLUS to allow tablet matching in udev */
+			__set_bit(BTN_STYLUS, hi->input->keybit);
+			break;
+		case HID_DG_TOUCHSCREEN:
+			/* we do not set suffix = "Touchscreen" */
+			break;
+		case HID_GD_SYSTEM_CONTROL:
+			suffix = "System Control";
+			break;
+		case HID_CP_CONSUMER_CONTROL:
+			suffix = "Consumer Control";
+			break;
+		default:
+			suffix = "UNKNOWN";
+			break;
+		}
 	}
 
 	if (suffix) {
@@ -992,6 +1057,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M3266) },
 
+	/* Anton devices */
+	{ .driver_data = MT_CLS_EXPORT_ALL_INPUTS,
+		MT_USB_DEVICE(USB_VENDOR_ID_ANTON,
+			USB_DEVICE_ID_ANTON_TOUCH_PAD) },
+
 	/* Atmel panels */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ATMEL,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 5eb282e..e224516 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -201,6 +201,7 @@ struct hid_item {
 #define HID_GD_VBRZ		0x00010045
 #define HID_GD_VNO		0x00010046
 #define HID_GD_FEATURE		0x00010047
+#define HID_GD_SYSTEM_CONTROL	0x00010080
 #define HID_GD_UP		0x00010090
 #define HID_GD_DOWN		0x00010091
 #define HID_GD_RIGHT		0x00010092
@@ -208,6 +209,8 @@ struct hid_item {
 
 #define HID_DC_BATTERYSTRENGTH	0x00060020
 
+#define HID_CP_CONSUMER_CONTROL	0x000c0001
+
 #define HID_DG_DIGITIZER	0x000d0001
 #define HID_DG_PEN		0x000d0002
 #define HID_DG_LIGHTPEN		0x000d0003
-- 
1.8.5.3

