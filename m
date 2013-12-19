Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3LSQXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3LSQXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:23:21 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Edel Maks <edelmaks@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] HID: multitouch: switch to a callback system for handling events
Date: Thu, 19 Dec 2013 11:23:09 -0500
Message-Id: <1387470191-9725-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel v3.10, we added the support of pen in addition to touch because
some devices presents both pen and touch on the same HID device.
Now, we are seeing at least one device (ANTON Touch Pad) which presents
a multitouch collection and a mouse collection which are both valid.

Instead of adding a lot of ifs and messing up with the code, we can switch
to a callback system which allows to define in a better way each protocol
used by each input report.

Tested-by: Edel Maks <edelmaks@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 136 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 101 insertions(+), 35 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1f0ba5c..1cdc21a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -91,6 +91,21 @@ struct mt_fields {
 	unsigned int length;
 };
 
+struct mt_protocol {
+	char *suffix;
+	int (*event)(struct hid_device *hdev, struct hid_field *field,
+			struct hid_usage *usage, __s32 value);
+	void (*report)(struct hid_device *hdev, struct hid_report *report);
+	int (*input_mapping)(struct hid_device *hdev,
+			struct hid_input *hidinput, struct hid_field *field,
+			struct hid_usage *usage, unsigned long **bit, int *max);
+	int (*input_mapped)(struct hid_device *hdev,
+			struct hid_input *hidinput, struct hid_field *field,
+			struct hid_usage *usage, unsigned long **bit, int *max);
+	void (*input_configured)(struct hid_device *hdev,
+				 struct hid_input *hidinput);
+};
+
 struct mt_device {
 	struct mt_slot curdata;	/* placeholder of incoming data */
 	struct mt_class mtclass;	/* our mt device class */
@@ -99,8 +114,7 @@ struct mt_device {
 	int cc_index;	/* contact count field index in the report */
 	int cc_value_index;	/* contact count value index in the field */
 	unsigned last_slot_field;	/* the last field of a slot */
-	unsigned mt_report_id;	/* the report ID of the multitouch device */
-	unsigned pen_report_id;	/* the report ID of the pen device */
+	struct mt_protocol protocols[HID_MAX_IDS]; /* per-id callbacks */
 	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
 	__s16 inputmode_index;	/* InputMode HID feature index in the report */
 	__s16 maxcontact_report_id;	/* Maximum Contact Number HID feature,
@@ -119,6 +133,54 @@ struct mt_device {
 static void mt_post_parse_default_settings(struct mt_device *td);
 static void mt_post_parse(struct mt_device *td);
 
+static int mt_touch_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max);
+static int mt_touch_input_mapped(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max);
+static int mt_touch_event(struct hid_device *hid,
+		struct hid_field *field, struct hid_usage *usage,
+		__s32 value);
+static void mt_touch_report(struct hid_device *hid,
+		struct hid_report *report);
+static void mt_touch_input_configured(struct hid_device *hdev,
+		struct hid_input *hi);
+
+static struct mt_protocol mt_protocol_touch = {
+	.suffix = NULL,
+	.event = mt_touch_event,
+	.report = mt_touch_report,
+	.input_mapping = mt_touch_input_mapping,
+	.input_mapped = mt_touch_input_mapped,
+	.input_configured = mt_touch_input_configured,
+};
+
+static int mt_pen_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max);
+static int mt_pen_input_mapped(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max);
+static int mt_pen_event(struct hid_device *hid,
+		struct hid_field *field, struct hid_usage *usage,
+		__s32 value);
+static void mt_pen_report(struct hid_device *hid,
+		struct hid_report *report);
+static void mt_pen_input_configured(struct hid_device *hdev,
+		struct hid_input *hi);
+
+static struct mt_protocol mt_protocol_pen = {
+	.suffix = "Pen",
+	.event = mt_pen_event,
+	.report = mt_pen_report,
+	.input_mapping = mt_pen_input_mapping,
+	.input_mapped = mt_pen_input_mapped,
+	.input_configured = mt_pen_input_configured,
+};
+
+static struct mt_protocol mt_protocol_ignore = { 0 };
+
 /* classes of device behavior */
 #define MT_CLS_DEFAULT				0x0001
 
@@ -364,10 +426,6 @@ static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	struct mt_device *td = hid_get_drvdata(hdev);
-
-	td->pen_report_id = field->report->id;
-
 	return 0;
 }
 
@@ -480,7 +538,6 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTID:
 			mt_store_field(usage, td, hi);
 			td->touches_by_report++;
-			td->mt_report_id = field->report->id;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -776,57 +833,71 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	struct mt_device *td = hid_get_drvdata(hdev);
+	unsigned report_id = field->report->id;
+
 	/* Only map fields from TouchScreen or TouchPad collections.
 	* We need to ignore fields that belong to other collections
 	* such as Mouse that might have the same GenericDesktop usages. */
 	if (field->application != HID_DG_TOUCHSCREEN &&
 	    field->application != HID_DG_PEN &&
 	    field->application != HID_DG_TOUCHPAD)
-		return -1;
+		td->protocols[report_id] = mt_protocol_ignore;
 
 	if (field->physical == HID_DG_STYLUS)
-		return mt_pen_input_mapping(hdev, hi, field, usage, bit, max);
+		td->protocols[report_id] = mt_protocol_pen;
+
+	else if (field->application == HID_DG_TOUCHSCREEN ||
+	    field->application == HID_DG_PEN ||
+	    field->application == HID_DG_TOUCHPAD)
+		td->protocols[report_id] = mt_protocol_touch;
 
-	return mt_touch_input_mapping(hdev, hi, field, usage, bit, max);
+	if (td->protocols[report_id].input_mapping)
+		return td->protocols[report_id].input_mapping(hdev, hi,
+				field, usage, bit, max);
+
+	/* ignore if no protocol is given */
+	return -1;
 }
 
 static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	if (field->physical == HID_DG_STYLUS)
-		return mt_pen_input_mapped(hdev, hi, field, usage, bit, max);
+	struct mt_device *td = hid_get_drvdata(hdev);
+	unsigned report_id = field->report->id;
+
+	if (td->protocols[report_id].input_mapped)
+		return td->protocols[report_id].input_mapped(hdev, hi, field,
+				usage, bit, max);
 
-	return mt_touch_input_mapped(hdev, hi, field, usage, bit, max);
+	/* ignore if no protocol is given */
+	return -1;
 }
 
 static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
+	unsigned report_id = field->report->id;
 
-	if (field->report->id == td->mt_report_id)
-		return mt_touch_event(hid, field, usage, value);
-
-	if (field->report->id == td->pen_report_id)
-		return mt_pen_event(hid, field, usage, value);
+	if (td->protocols[report_id].event)
+		return td->protocols[report_id].event(hid, field, usage, value);
 
-	/* ignore other reports */
+	/* ignore if no protocol is given */
 	return 1;
 }
 
 static void mt_report(struct hid_device *hid, struct hid_report *report)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
+	unsigned report_id = report->id;
 
 	if (!(hid->claimed & HID_CLAIMED_INPUT))
 		return;
 
-	if (report->id == td->mt_report_id)
-		mt_touch_report(hid, report);
-
-	if (report->id == td->pen_report_id)
-		mt_pen_report(hid, report);
+	if (td->protocols[report_id].report)
+		return td->protocols[report_id].report(hid, report);
 }
 
 static void mt_set_input_mode(struct hid_device *hdev)
@@ -906,17 +977,14 @@ static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 	char *name;
-	const char *suffix = NULL;
-
-	if (hi->report->id == td->mt_report_id)
-		mt_touch_input_configured(hdev, hi);
+	const char *suffix;
+	unsigned report_id = hi->report->id;
 
-	if (hi->report->field[0]->physical == HID_DG_STYLUS) {
-		suffix = "Pen";
-		mt_pen_input_configured(hdev, hi);
-	}
+	if (td->protocols[report_id].input_configured)
+		td->protocols[report_id].input_configured(hdev, hi);
 
-	if (suffix) {
+	if (td->protocols[report_id].suffix) {
+		suffix = td->protocols[report_id].suffix;
 		name = devm_kzalloc(&hi->input->dev,
 				    strlen(hdev->name) + strlen(suffix) + 2,
 				    GFP_KERNEL);
@@ -974,8 +1042,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	td->inputmode = -1;
 	td->maxcontact_report_id = -1;
 	td->cc_index = -1;
-	td->mt_report_id = -1;
-	td->pen_report_id = -1;
 	hid_set_drvdata(hdev, td);
 
 	td->fields = devm_kzalloc(&hdev->dev, sizeof(struct mt_fields),
-- 
1.8.3.1

