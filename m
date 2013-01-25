Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab3AYNXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:23:37 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45947 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab3AYNXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:23:32 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/25] HID: break out hid_extract_field
Date: Fri, 25 Jan 2013 14:22:46 +0100
Message-Id: <1359120190-18281-2-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breaking out this function allows third parties hid drivers to retrieve
the data fields of a hid report in the raw_event callback.

No functional changes, only exports the function.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-core.c | 60 ++++++++++++++++++++++++++++++++++----------------
 include/linux/hid.h    |  1 +
 2 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5ae2cb1..ea478f5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -962,6 +962,45 @@ static void implement(const struct hid_device *hid, __u8 *report,
 }
 
 /*
+ * Extract and allocate a data field from a little endian report (bit array).
+ */
+
+s32 *hid_extract_field(const struct hid_device *hid, struct hid_field *field,
+		       __u8 *data)
+{
+	unsigned n;
+	unsigned count = field->report_count;
+	unsigned offset = field->report_offset;
+	unsigned size = field->report_size;
+	__s32 min = field->logical_minimum;
+	__s32 max = field->logical_maximum;
+	__s32 *value;
+
+	value = kmalloc(sizeof(__s32) * count, GFP_ATOMIC);
+	if (!value)
+		return value;
+
+	for (n = 0; n < count; n++) {
+
+		value[n] = min < 0 ?
+			snto32(extract(hid, data, offset + n * size, size),
+			       size) :
+			extract(hid, data, offset + n * size, size);
+
+		/* Ignore report if ErrorRollOver */
+		if (!(field->flags & HID_MAIN_ITEM_VARIABLE) &&
+		    value[n] >= min && value[n] <= max &&
+		    field->usage[value[n] - min].hid == HID_UP_KEYBOARD + 1) {
+			kfree(value);
+			return NULL;
+		}
+	}
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(hid_extract_field);
+
+/*
  * Search an array for a value.
  */
 
@@ -1059,32 +1098,15 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
 {
 	unsigned n;
 	unsigned count = field->report_count;
-	unsigned offset = field->report_offset;
-	unsigned size = field->report_size;
 	__s32 min = field->logical_minimum;
 	__s32 max = field->logical_maximum;
-	__s32 *value;
+	__s32 *value = hid_extract_field(hid, field, data);
 
-	value = kmalloc(sizeof(__s32) * count, GFP_ATOMIC);
 	if (!value)
 		return;
 
 	for (n = 0; n < count; n++) {
 
-		value[n] = min < 0 ?
-			snto32(extract(hid, data, offset + n * size, size),
-			       size) :
-			extract(hid, data, offset + n * size, size);
-
-		/* Ignore report if ErrorRollOver */
-		if (!(field->flags & HID_MAIN_ITEM_VARIABLE) &&
-		    value[n] >= min && value[n] <= max &&
-		    field->usage[value[n] - min].hid == HID_UP_KEYBOARD + 1)
-			goto exit;
-	}
-
-	for (n = 0; n < count; n++) {
-
 		if (HID_MAIN_ITEM_VARIABLE & field->flags) {
 			hid_process_event(hid, field, &field->usage[n], value[n], interrupt);
 			continue;
@@ -1102,7 +1124,7 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
 	}
 
 	memcpy(field->value, value, count * sizeof(__s32));
-exit:
+
 	kfree(value);
 }
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 828726c..91bfee4 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -718,6 +718,7 @@ extern int hidinput_connect(struct hid_device *hid, unsigned int force);
 extern void hidinput_disconnect(struct hid_device *);
 
 int hid_set_field(struct hid_field *, unsigned, __s32);
+s32 *hid_extract_field(const struct hid_device *, struct hid_field *, __u8 *);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
 struct hid_field *hidinput_get_led_field(struct hid_device *hid);
-- 
1.8.1

