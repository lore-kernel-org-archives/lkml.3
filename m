Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3AYNXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:23:41 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:57603 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab3AYNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:34 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/25] HID: multitouch: add support for Nexio 42" panel
Date: Fri, 25 Jan 2013 14:22:47 +0100
Message-Id: <1359120190-18281-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device is the worst device I saw. It keeps TipSwitch and InRange
at 1 for fingers that are not touching the panel.
The solution is to rely on the field ContactCount, which is accurate
as the correct information are packed at the begining of the frame.

Unfortunately, CountactCount is most of the time at the end of the report.
The solution is to pick it when we have the whole report in raw_event.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-ids.h        |  3 ++
 drivers/hid/hid-multitouch.c | 91 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 78 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index dad56aa..0935012 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -597,6 +597,9 @@
 #define USB_VENDOR_ID_NEC		0x073e
 #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
 
+#define USB_VENDOR_ID_NEXIO		0x1870
+#define USB_DEVICE_ID_NEXIO_MULTITOUCH_420	0x010d
+
 #define USB_VENDOR_ID_NEXTWINDOW	0x1926
 #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 46d8136..c4acdd0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -32,6 +32,8 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/input/mt.h>
+#include <asm/unaligned.h>
+#include <asm/byteorder.h>
 #include "usbhid/usbhid.h"
 
 
@@ -54,6 +56,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_NO_AREA		(1 << 9)
 #define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
 #define MT_QUIRK_HOVERING		(1 << 11)
+#define MT_QUIRK_CONTACT_CNT_ACCURATE	(1 << 12)
 
 struct mt_slot {
 	__s32 x, y, cx, cy, p, w, h;
@@ -83,6 +86,10 @@ struct mt_device {
 	struct mt_class mtclass;	/* our mt device class */
 	struct mt_fields *fields;	/* temporary placeholder for storing the
 					   multitouch fields */
+	struct hid_field *contactcount;	/* the hid_field contact count that
+					   will be picked in mt_raw_event */
+	__s8 contactcount_index;	/* the index of the usage contact count
+					   in its hid_field. */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
@@ -111,6 +118,7 @@ struct mt_device {
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
 #define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
 #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
+#define MT_CLS_ALWAYS_TRUE			0x000a
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -170,6 +178,9 @@ static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
+	{ .name = MT_CLS_ALWAYS_TRUE,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE },
 
 	/*
 	 * vendor specific classes
@@ -250,6 +261,9 @@ static ssize_t mt_set_quirks(struct device *dev,
 
 	td->mtclass.quirks = val;
 
+	if (!td->contactcount)
+		td->mtclass.quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
+
 	return count;
 }
 
@@ -264,24 +278,26 @@ static struct attribute_group mt_attribute_group = {
 	.attrs = sysfs_attrs
 };
 
+static int mt_find_usage_index(struct hid_field *field, struct hid_usage *usage)
+{
+	int i;
+	for (i = 0; i < field->maxusage; i++) {
+		if (field->usage[i].hid == usage->hid)
+			return i;
+	}
+	return -1;
+}
+
 static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
-	int i;
 
 	switch (usage->hid) {
 	case HID_DG_INPUTMODE:
 		td->inputmode = field->report->id;
-		td->inputmode_index = 0; /* has to be updated below */
-
-		for (i=0; i < field->maxusage; i++) {
-			if (field->usage[i].hid == usage->hid) {
-				td->inputmode_index = i;
-				break;
-			}
-		}
-
+		td->inputmode_index = mt_find_usage_index(field, usage);
+		/* inputmode_index can't be set at -1 */
 		break;
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
@@ -459,6 +475,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
+			td->contactcount = field;
+			td->contactcount_index = mt_find_usage_index(field,
+									usage);
+			/* contactcount_index can't be set at -1 */
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
@@ -523,6 +543,10 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
  */
 static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 {
+	if ((td->mtclass.quirks & MT_QUIRK_CONTACT_CNT_ACCURATE) &&
+	    td->num_received >= td->num_expected)
+		return;
+
 	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
 		int slotnum = mt_compute_slot(td, input);
 		struct mt_slot *s = &td->curdata;
@@ -623,12 +647,6 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			td->curdata.h = value;
 			break;
 		case HID_DG_CONTACTCOUNT:
-			/*
-			 * Includes multi-packet support where subsequent
-			 * packets are sent with zero contactcount.
-			 */
-			if (value)
-				td->num_expected = value;
 			break;
 		case HID_DG_TOUCH:
 			/* do nothing */
@@ -658,6 +676,37 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	return 1;
 }
 
+static int mt_raw_event(struct hid_device *hid, struct hid_report *report,
+			u8 *data, int size)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
+	struct hid_field *field = td->contactcount;
+	s32 *value;
+
+	if (field && report->id == field->report->id) {
+		/*
+		 * Pick in advance the field HID_DG_CONTACTCOUNT as it is
+		 * often placed at the end of the report.
+		 */
+		if (report->id)
+			data++;
+
+		value = hid_extract_field(hid, field, data);
+		if (!value)
+			return 0;
+
+		/*
+		 * Includes multi-packet support where subsequent
+		 * packets are sent with zero contactcount.
+		 */
+		if (value[td->contactcount_index])
+			td->num_expected = value[td->contactcount_index];
+
+		kfree(value);
+	}
+	return 0;
+}
+
 static void mt_set_input_mode(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
@@ -719,11 +768,15 @@ static void mt_post_parse_default_settings(struct mt_device *td)
 static void mt_post_parse(struct mt_device *td)
 {
 	struct mt_fields *f = td->fields;
+	struct mt_class *cls = &td->mtclass;
 
 	if (td->touches_by_report > 0) {
 		int field_count_per_touch = f->length / td->touches_by_report;
 		td->last_slot_field = f->usages[field_count_per_touch - 1];
 	}
+
+	if (!td->contactcount)
+		cls->quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
 }
 
 static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
@@ -1056,6 +1109,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_TURBOX,
 			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
 
+	/* Nexio panels */
+	{ .driver_data = MT_CLS_ALWAYS_TRUE,
+		MT_USB_DEVICE(USB_VENDOR_ID_NEXIO,
+			USB_DEVICE_ID_NEXIO_MULTITOUCH_420)},
+
 	/* Panasonic panels */
 	{ .driver_data = MT_CLS_PANASONIC,
 		MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
@@ -1193,6 +1251,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.raw_event = mt_raw_event,
 #ifdef CONFIG_PM
 	.reset_resume = mt_reset_resume,
 	.resume = mt_resume,
-- 
1.8.1

