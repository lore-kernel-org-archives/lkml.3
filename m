Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572Ab3B0Q6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:58:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760399Ab3B0Q4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:24 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] HID: multitouch: breaks out touch handling in specific functions
Date: Wed, 27 Feb 2013 17:55:22 +0100
Message-Id: <1361984127-912-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow easier integration of hybrid pen and touch devices.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 75 +++++++++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3af9efdd..6314473 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -365,7 +365,7 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 	f->usages[f->length++] = usage->hid;
 }
 
-static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
@@ -374,13 +374,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
@@ -389,12 +384,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
 
@@ -526,7 +515,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	return 0;
 }
 
-static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+static int mt_touch_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
@@ -617,7 +606,7 @@ static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 	td->num_received = 0;
 }
 
-static int mt_event(struct hid_device *hid, struct hid_field *field,
+static int mt_touch_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	/* we will handle the hidinput part later, now remains hiddev */
@@ -697,19 +686,13 @@ static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
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
@@ -734,6 +717,56 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 	}
 }
 
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
-- 
1.8.1.2

