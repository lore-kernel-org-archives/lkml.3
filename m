Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422750Ab3CVRla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422685Ab3CVRjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:39:31 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] HID: multitouch: breaks out touch handling in specific functions
Date: Fri, 22 Mar 2013 18:38:29 +0100
Message-Id: <1363973914-5661-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow easier integration of hybrid pen and touch devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 123 +++++++++++++++++++++++++++++--------------
 1 file changed, 83 insertions(+), 40 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1f544a4..35b6025 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -114,6 +114,9 @@ struct mt_device {
 	unsigned mt_flags;	/* flags to pass to input-mt */
 };
 
+static void mt_post_parse_default_settings(struct mt_device *td);
+static void mt_post_parse(struct mt_device *td);
+
 /* classes of device behavior */
 #define MT_CLS_DEFAULT				0x0001
 
@@ -364,7 +367,7 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 	f->usages[f->length++] = usage->hid;
 }
 
-static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
@@ -373,13 +376,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	int code;
 	struct hid_usage *prev_usage = NULL;
 
-	/* Only map fields from TouchScreen or TouchPad collections.
-	* We need to ignore fields that belong to other collections
-	* such as Mouse that might have the same GenericDesktop usages. */
 	if (field->application == HID_DG_TOUCHSCREEN)
 		td->mt_flags |= INPUT_MT_DIRECT;
-	else if (field->application != HID_DG_TOUCHPAD)
-		return 0;
 
 	/*
 	 * Model touchscreens providing buttons as touchpads.
@@ -388,12 +386,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	    (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
 		td->mt_flags |= INPUT_MT_POINTER;
 
-	/* eGalax devices provide a Digitizer.Stylus input which overrides
-	 * the correct Digitizers.Finger X/Y ranges.
-	 * Let's just ignore this input. */
-	if (field->physical == HID_DG_STYLUS)
-		return -1;
-
 	if (usage->usage_index)
 		prev_usage = &field->usage[usage->usage_index - 1];
 
@@ -514,7 +506,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	return 0;
 }
 
-static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+static int mt_touch_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
@@ -605,7 +597,7 @@ static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 	td->num_received = 0;
 }
 
-static int mt_event(struct hid_device *hid, struct hid_field *field,
+static int mt_touch_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	/* we will handle the hidinput part later, now remains hiddev */
@@ -681,19 +673,13 @@ static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
 	}
 }
 
-static void mt_report(struct hid_device *hid, struct hid_report *report)
+static void mt_touch_report(struct hid_device *hid, struct hid_report *report)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
 	struct hid_field *field;
 	unsigned count;
 	int r, n;
 
-	if (report->id != td->mt_report_id)
-		return;
-
-	if (!(hid->claimed & HID_CLAIMED_INPUT))
-		return;
-
 	/*
 	 * Includes multi-packet support where subsequent
 	 * packets are sent with zero contactcount.
@@ -721,6 +707,81 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 		mt_sync_frame(td, report->field[0]->hidinput->input);
 }
 
+static void mt_touch_input_configured(struct hid_device *hdev,
+					struct hid_input *hi)
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	struct mt_class *cls = &td->mtclass;
+	struct input_dev *input = hi->input;
+
+	if (!td->maxcontacts)
+		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
+
+	mt_post_parse(td);
+	if (td->serial_maybe)
+		mt_post_parse_default_settings(td);
+
+	if (cls->is_indirect)
+		td->mt_flags |= INPUT_MT_POINTER;
+
+	if (cls->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
+		td->mt_flags |= INPUT_MT_DROP_UNUSED;
+
+	input_mt_init_slots(input, td->maxcontacts, td->mt_flags);
+
+	td->mt_flags = 0;
+}
+
+static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	/* Only map fields from TouchScreen or TouchPad collections.
+	* We need to ignore fields that belong to other collections
+	* such as Mouse that might have the same GenericDesktop usages. */
+	if (field->application != HID_DG_TOUCHSCREEN &&
+	    field->application != HID_DG_TOUCHPAD)
+		return 0;
+
+	/* eGalax devices provide a Digitizer.Stylus input which overrides
+	 * the correct Digitizers.Finger X/Y ranges.
+	 * Let's just ignore this input. */
+	if (field->physical == HID_DG_STYLUS)
+		return -1;
+
+	return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
+}
+
+static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
+}
+
+static int mt_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
+
+	if (field->report->id == td->mt_report_id)
+		return mt_touch_event(hid, field, usage, value);
+
+	/* ignore other reports */
+	return 1;
+}
+
+static void mt_report(struct hid_device *hid, struct hid_report *report)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
+
+	if (!(hid->claimed & HID_CLAIMED_INPUT))
+		return;
+
+	if (report->id == td->mt_report_id)
+		mt_touch_report(hid, report);
+}
+
 static void mt_set_input_mode(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
@@ -795,32 +856,14 @@ static void mt_post_parse(struct mt_device *td)
 }
 
 static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
-
 {
-	struct mt_device *td = hid_get_drvdata(hdev);
-	struct mt_class *cls = &td->mtclass;
 	struct input_dev *input = hi->input;
 
 	/* Only initialize slots for MT input devices */
 	if (!test_bit(ABS_MT_POSITION_X, input->absbit))
 		return;
 
-	if (!td->maxcontacts)
-		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
-
-	mt_post_parse(td);
-	if (td->serial_maybe)
-		mt_post_parse_default_settings(td);
-
-	if (cls->is_indirect)
-		td->mt_flags |= INPUT_MT_POINTER;
-
-	if (cls->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
-		td->mt_flags |= INPUT_MT_DROP_UNUSED;
-
-	input_mt_init_slots(input, td->maxcontacts, td->mt_flags);
-
-	td->mt_flags = 0;
+	mt_touch_input_configured(hdev, hi);
 }
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
-- 
1.8.1.4

