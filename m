Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3IKT51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab3IKT5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:57:25 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/10] HID: validate feature and input report details
Date: Wed, 11 Sep 2013 21:56:57 +0200
Message-Id: <1378929419-6269-9-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dealing with usage_index, be sure to properly use unsigned instead of
int to avoid overflows.

When working on report fields, always validate that their report_counts are
in bounds.
Without this, a HID device could report a malicious feature report that
could trick the driver into a heap overflow:

[  634.885003] usb 1-1: New USB device found, idVendor=0596, idProduct=0500
...
[  676.469629] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

CVE-2013-2897

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
v3:
 - new patch: extract from the hid-multitouch patch, the generic checks so that
   every hid drivers will benefit from them

 drivers/hid/hid-core.c  | 16 +++++++---------
 drivers/hid/hid-input.c | 11 ++++++++++-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 44b6c68..329e24e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -94,7 +94,6 @@ EXPORT_SYMBOL_GPL(hid_register_report);
 static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
 {
 	struct hid_field *field;
-	int i;
 
 	if (report->maxfield == HID_MAX_FIELDS) {
 		hid_err(report->device, "too many fields in report\n");
@@ -113,9 +112,6 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
 	field->value = (s32 *)(field->usage + usages);
 	field->report = report;
 
-	for (i = 0; i < usages; i++)
-		field->usage[i].usage_index = i;
-
 	return field;
 }
 
@@ -226,9 +222,9 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 {
 	struct hid_report *report;
 	struct hid_field *field;
-	int usages;
+	unsigned usages;
 	unsigned offset;
-	int i;
+	unsigned i;
 
 	report = hid_register_report(parser->device, report_type, parser->global.report_id);
 	if (!report) {
@@ -255,7 +251,8 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
 
-	usages = max_t(int, parser->local.usage_index, parser->global.report_count);
+	usages = max_t(unsigned, parser->local.usage_index,
+				 parser->global.report_count);
 
 	field = hid_register_field(report, usages, parser->global.report_count);
 	if (!field)
@@ -266,13 +263,14 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	field->application = hid_lookup_collection(parser, HID_COLLECTION_APPLICATION);
 
 	for (i = 0; i < usages; i++) {
-		int j = i;
+		unsigned j = i;
 		/* Duplicate the last usage we parsed if we have excess values */
 		if (i >= parser->local.usage_index)
 			j = parser->local.usage_index - 1;
 		field->usage[i].hid = parser->local.usage[j];
 		field->usage[i].collection_index =
 			parser->local.collection_index[j];
+		field->usage[i].usage_index = i;
 	}
 
 	field->maxusage = usages;
@@ -1354,7 +1352,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 			goto out;
 	}
 
-	if (hid->claimed != HID_CLAIMED_HIDRAW) {
+	if (hid->claimed != HID_CLAIMED_HIDRAW && report->maxfield) {
 		for (a = 0; a < report->maxfield; a++)
 			hid_input_field(hid, report->field[a], cdata, interrupt);
 		hdrv = hid->driver;
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index b420f4a..8741d95 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -485,6 +485,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	if (field->flags & HID_MAIN_ITEM_CONSTANT)
 		goto ignore;
 
+	/* Ignore if report count is out of bounds. */
+	if (field->report_count < 1)
+		goto ignore;
+
 	/* only LED usages are supported in output fields */
 	if (field->report_type == HID_OUTPUT_REPORT &&
 			(usage->hid & HID_USAGE_PAGE) != HID_UP_LED) {
@@ -1236,7 +1240,11 @@ static void report_features(struct hid_device *hid)
 
 	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
 	list_for_each_entry(rep, &rep_enum->report_list, list)
-		for (i = 0; i < rep->maxfield; i++)
+		for (i = 0; i < rep->maxfield; i++) {
+			/* Ignore if report count is out of bounds. */
+			if (rep->field[i]->report_count < 1)
+				continue;
+
 			for (j = 0; j < rep->field[i]->maxusage; j++) {
 				/* Verify if Battery Strength feature is available */
 				hidinput_setup_battery(hid, HID_FEATURE_REPORT, rep->field[i]);
@@ -1245,6 +1253,7 @@ static void report_features(struct hid_device *hid)
 					drv->feature_mapping(hid, rep->field[i],
 							     rep->field[i]->usage + j);
 			}
+		}
 }
 
 static struct hid_input *hidinput_allocate(struct hid_device *hid)
-- 
1.8.3.1

