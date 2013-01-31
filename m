Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3AaQXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:23:05 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49694 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3AaQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:22:58 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/9] HID: multitouch: use the callback "report" instead of sequential events
Date: Thu, 31 Jan 2013 17:22:24 +0100
Message-Id: <1359649351-11092-3-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nexio 42" devices requires to rely on the HID field Contact
Count to compute the valid values. However, this field is
most of the time at the end of the report, meaning that we
need to get the all report parsed before processing it.

This patch does not introduce functional changes.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 46d8136..092c09b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -85,6 +85,7 @@ struct mt_device {
 					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
+	unsigned mt_report_id;	/* the report ID of the multitouch device */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__s8 inputmode_index;	/* InputMode HID feature index in the report */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
@@ -428,6 +429,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
+			td->mt_report_id = field->report->id;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
@@ -578,6 +580,16 @@ static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
+	/* we will handle the hidinput part later, now remains hiddev */
+	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
+		hid->hiddev_hid_event(hid, field, usage, value);
+
+	return 1;
+}
+
+static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
+				struct hid_usage *usage, __s32 value)
+{
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
 
@@ -635,8 +647,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
-			/* fallback to the generic hidinput handling */
-			return 0;
+			return;
 		}
 
 		if (usage->usage_index + 1 == field->report_count) {
@@ -650,12 +661,32 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		}
 
 	}
+}
 
-	/* we have handled the hidinput part, now remains hiddev */
-	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
-		hid->hiddev_hid_event(hid, field, usage, value);
+static void mt_report(struct hid_device *hid, struct hid_report *report)
+{
+	struct mt_device *td = hid_get_drvdata(hid);
+	struct hid_field *field;
+	unsigned count;
+	int r, n;
 
-	return 1;
+	if (report->id != td->mt_report_id)
+		return;
+
+	if (!(hid->claimed & HID_CLAIMED_INPUT))
+		return;
+
+	for (r = 0; r < report->maxfield; r++) {
+		field = report->field[r];
+		count = field->report_count;
+
+		if (!(HID_MAIN_ITEM_VARIABLE & field->flags))
+			continue;
+
+		for (n = 0; n < count; n++)
+			mt_process_mt_event(hid, field, &field->usage[n],
+					field->value[n]);
+	}
 }
 
 static void mt_set_input_mode(struct hid_device *hdev)
@@ -1193,6 +1224,7 @@ static struct hid_driver mt_driver = {
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
+	.report = mt_report,
 #ifdef CONFIG_PM
 	.reset_resume = mt_reset_resume,
 	.resume = mt_resume,
-- 
1.8.1

