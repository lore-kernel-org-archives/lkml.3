Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422804Ab3CVRjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422774Ab3CVRjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:39:37 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] HID: multitouch: add handling for pen in dual-sensors device
Date: Fri, 22 Mar 2013 18:38:32 +0100
Message-Id: <1363973914-5661-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dual sensors devices reports pen and touch on two different reports.
Using the quirk HID_QUIRK_MULTI_INPUT allows us to create a new input
device to forward pen events.

The quirk HID_QUIRK_NO_EMPTY_INPUT avoids the creation of input devices
for the not used mouse emulation present on Win7 certified devices.

Since hid-multitouch sets the quirk HID_QUIRK_NO_INPUT_SYNC, we need
to manually send SYN events for pen report too.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 66 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6a934de..099a7ad 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -99,6 +99,7 @@ struct mt_device {
 	int cc_value_index;	/* contact count value index in the field */
 	unsigned last_slot_field;	/* the last field of a slot */
 	unsigned mt_report_id;	/* the report ID of the multitouch device */
+	unsigned pen_report_id;	/* the report ID of the pen device */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__s8 inputmode_index;	/* InputMode HID feature index in the report */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
@@ -367,6 +368,43 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 	f->usages[f->length++] = usage->hid;
 }
 
+static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	td->pen_report_id = field->report->id;
+
+	return 0;
+}
+
+static int mt_pen_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	return 0;
+}
+
+static int mt_pen_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
+	/* let hid-input handle it */
+	return 0;
+}
+
+static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
+{
+	struct hid_field *field = report->field[0];
+
+	input_sync(field->hidinput->input);
+}
+
+static void mt_pen_input_configured(struct hid_device *hdev,
+					struct hid_input *hi)
+{
+}
+
 static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -740,14 +778,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	* We need to ignore fields that belong to other collections
 	* such as Mouse that might have the same GenericDesktop usages. */
 	if (field->application != HID_DG_TOUCHSCREEN &&
+	    field->application != HID_DG_PEN &&
 	    field->application != HID_DG_TOUCHPAD)
 		return -1;
 
-	/* eGalax devices provide a Digitizer.Stylus input which overrides
-	 * the correct Digitizers.Finger X/Y ranges.
-	 * Let's just ignore this input. */
 	if (field->physical == HID_DG_STYLUS)
-		return -1;
+		return mt_pen_input_mapping(hdev, hi, field, usage, bit, max);
 
 	return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
 }
@@ -756,6 +792,9 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	if (field->physical == HID_DG_STYLUS)
+		return mt_pen_input_mapped(hdev, hi, field, usage, bit, max);
+
 	return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
 }
 
@@ -767,6 +806,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	if (field->report->id == td->mt_report_id)
 		return mt_touch_event(hid, field, usage, value);
 
+	if (field->report->id == td->pen_report_id)
+		return mt_pen_event(hid, field, usage, value);
+
 	/* ignore other reports */
 	return 1;
 }
@@ -780,6 +822,9 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 
 	if (report->id == td->mt_report_id)
 		mt_touch_report(hid, report);
+
+	if (report->id == td->pen_report_id)
+		mt_pen_report(hid, report);
 }
 
 static void mt_set_input_mode(struct hid_device *hdev)
@@ -861,6 +906,9 @@ static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 
 	if (hi->report->id == td->mt_report_id)
 		mt_touch_input_configured(hdev, hi);
+
+	if (hi->report->id == td->pen_report_id)
+		mt_pen_input_configured(hdev, hi);
 }
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
@@ -881,6 +929,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 */
 	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
 
+	/*
+	 * This allows the driver to handle different input sensors
+	 * that emits events through different reports on the same HID
+	 * device.
+	 */
+	hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+	hdev->quirks |= HID_QUIRK_NO_EMPTY_INPUT;
+
 	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
 		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
@@ -890,6 +946,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	td->inputmode = -1;
 	td->maxcontact_report_id = -1;
 	td->cc_index = -1;
+	td->mt_report_id = -1;
+	td->pen_report_id = -1;
 	hid_set_drvdata(hdev, td);
 
 	td->fields = kzalloc(sizeof(struct mt_fields), GFP_KERNEL);
-- 
1.8.1.4

