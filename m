Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3BFLTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:19:14 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44345 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3BFLTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:19:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: do not use pointers towards hid-core
Date: Wed,  6 Feb 2013 12:10:47 +0100
Message-Id: <1360149047-23061-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous implementation registered a pointer towards hid-core
to the value of contact count. This is not safe and may be difficult
to debug if hid-core ever changes its implementation.
The use of regular indexes is a better choice.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 28af54f..e22fbd3 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -84,7 +84,8 @@ struct mt_device {
 	struct mt_class mtclass;	/* our mt device class */
 	struct mt_fields *fields;	/* temporary placeholder for storing the
 					   multitouch fields */
-	__s32 *contactcount;		/* contact count value in the report */
+	int cc_index;	/* contact count field index in the report */
+	int cc_value_index;	/* contact count value index in the field */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	unsigned mt_report_id;	/* the report ID of the multitouch device */
@@ -269,7 +270,7 @@ static ssize_t mt_set_quirks(struct device *dev,
 
 	td->mtclass.quirks = val;
 
-	if (!td->contactcount)
+	if (td->cc_index < 0)
 		td->mtclass.quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
 
 	return count;
@@ -483,7 +484,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
-			td->contactcount = field->value + usage->usage_index;
+			td->cc_index = field->index;
+			td->cc_value_index = usage->usage_index;
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
@@ -701,8 +703,12 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 	 * Includes multi-packet support where subsequent
 	 * packets are sent with zero contactcount.
 	 */
-	if (td->contactcount && *td->contactcount)
-		td->num_expected = *td->contactcount;
+	if (td->cc_index >= 0) {
+		struct hid_field *field = report->field[td->cc_index];
+		int value = field->value[td->cc_value_index];
+		if (value)
+			td->num_expected = value;
+	}
 
 	for (r = 0; r < report->maxfield; r++) {
 		field = report->field[r];
@@ -786,7 +792,7 @@ static void mt_post_parse(struct mt_device *td)
 		td->last_slot_field = f->usages[field_count_per_touch - 1];
 	}
 
-	if (!td->contactcount)
+	if (td->cc_index < 0)
 		cls->quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
 }
 
@@ -845,6 +851,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	td->mtclass = *mtclass;
 	td->inputmode = -1;
 	td->maxcontact_report_id = -1;
+	td->cc_index = -1;
 	hid_set_drvdata(hdev, td);
 
 	td->fields = kzalloc(sizeof(struct mt_fields), GFP_KERNEL);
-- 
1.8.1

