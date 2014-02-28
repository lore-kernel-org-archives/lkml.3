Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaB1Qlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:41:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaB1Qlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:41:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] HID: multitouch: remove pen special handling
Date: Fri, 28 Feb 2014 11:41:24 -0500
Message-Id: <1393605685-17025-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1393605685-17025-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pens have a special handling in hid-mt as hybrid pen/touch devices
are quite common now. However, some fancy devices presents also
useful collections like mouse or keyboard.
The special case for the pen may not be a special case, and treat it as
a generic case.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 61 +++++++-------------------------------------
 1 file changed, 9 insertions(+), 52 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3e81f4e..8250cc0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -100,7 +100,6 @@ struct mt_device {
 	int cc_value_index;	/* contact count value index in the field */
 	unsigned last_slot_field;	/* the last field of a slot */
 	unsigned mt_report_id;	/* the report ID of the multitouch device */
-	unsigned pen_report_id;	/* the report ID of the pen device */
 	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
 	__s16 inputmode_index;	/* InputMode HID feature index in the report */
 	__s16 maxcontact_report_id;	/* Maximum Contact Number HID feature,
@@ -342,45 +341,6 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 	f->usages[f->length++] = usage->hid;
 }
 
-static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
-{
-	struct mt_device *td = hid_get_drvdata(hdev);
-
-	td->pen_report_id = field->report->id;
-
-	return 0;
-}
-
-static int mt_pen_input_mapped(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
-{
-	return 0;
-}
-
-static int mt_pen_event(struct hid_device *hid, struct hid_field *field,
-				struct hid_usage *usage, __s32 value)
-{
-	/* let hid-input handle it */
-	return 0;
-}
-
-static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
-{
-	struct hid_field *field = report->field[0];
-
-	input_sync(field->hidinput->input);
-}
-
-static void mt_pen_input_configured(struct hid_device *hdev,
-					struct hid_input *hi)
-{
-	/* force BTN_STYLUS to allow tablet matching in udev */
-	__set_bit(BTN_STYLUS, hi->input->keybit);
-}
-
 static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -767,7 +727,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		return -1;
 
 	if (field->physical == HID_DG_STYLUS)
-		return mt_pen_input_mapping(hdev, hi, field, usage, bit, max);
+		return 0;
 
 	return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
 }
@@ -777,7 +737,7 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		unsigned long **bit, int *max)
 {
 	if (field->physical == HID_DG_STYLUS)
-		return mt_pen_input_mapped(hdev, hi, field, usage, bit, max);
+		return 0;
 
 	return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
 }
@@ -790,25 +750,22 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	if (field->report->id == td->mt_report_id)
 		return mt_touch_event(hid, field, usage, value);
 
-	if (field->report->id == td->pen_report_id)
-		return mt_pen_event(hid, field, usage, value);
-
-	/* ignore other reports */
-	return 1;
+	return 0;
 }
 
 static void mt_report(struct hid_device *hid, struct hid_report *report)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
+	struct hid_field *field = report->field[0];
 
 	if (!(hid->claimed & HID_CLAIMED_INPUT))
 		return;
 
 	if (report->id == td->mt_report_id)
-		mt_touch_report(hid, report);
+		return mt_touch_report(hid, report);
 
-	if (report->id == td->pen_report_id)
-		mt_pen_report(hid, report);
+	if (field && field->hidinput && field->hidinput->input)
+		input_sync(field->hidinput->input);
 }
 
 static void mt_set_input_mode(struct hid_device *hdev)
@@ -895,7 +852,8 @@ static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 
 	if (hi->report->field[0]->physical == HID_DG_STYLUS) {
 		suffix = "Pen";
-		mt_pen_input_configured(hdev, hi);
+		/* force BTN_STYLUS to allow tablet matching in udev */
+		__set_bit(BTN_STYLUS, hi->input->keybit);
 	}
 
 	if (suffix) {
@@ -957,7 +915,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	td->maxcontact_report_id = -1;
 	td->cc_index = -1;
 	td->mt_report_id = -1;
-	td->pen_report_id = -1;
 	hid_set_drvdata(hdev, td);
 
 	td->fields = devm_kzalloc(&hdev->dev, sizeof(struct mt_fields),
-- 
1.8.5.3

