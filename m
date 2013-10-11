Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3JKKm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab3JKKm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/100] HID: validate feature and input report details
Date: Fri, 11 Oct 2013 11:40:38 +0100
Message-Id: <1381488130-30235-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit cc6b54aa54bf40b762cab45a9fc8aa81653146eb upstream.

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

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ luis: backported to 3.5:
  - dropped changes to hid_report_raw_event() as these depend on
    commit b94e3c9 "HID: hid-core: optimize in case of hidraw" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c  | 10 ++++++----
 drivers/hid/hid-input.c | 11 ++++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4043d73..adca1b0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -226,9 +226,9 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
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
@@ -255,7 +255,8 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
 
-	usages = max_t(int, parser->local.usage_index, parser->global.report_count);
+	usages = max_t(unsigned, parser->local.usage_index,
+				 parser->global.report_count);
 
 	field = hid_register_field(report, usages, parser->global.report_count);
 	if (!field)
@@ -266,13 +267,14 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
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
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c460b74..0c218f8 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -470,6 +470,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	if (field->flags & HID_MAIN_ITEM_CONSTANT)
 		goto ignore;
 
+	/* Ignore if report count is out of bounds. */
+	if (field->report_count < 1)
+		goto ignore;
+
 	/* only LED usages are supported in output fields */
 	if (field->report_type == HID_OUTPUT_REPORT &&
 			(usage->hid & HID_USAGE_PAGE) != HID_UP_LED) {
@@ -1134,7 +1138,11 @@ static void report_features(struct hid_device *hid)
 
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
@@ -1143,6 +1151,7 @@ static void report_features(struct hid_device *hid)
 					drv->feature_mapping(hid, rep->field[i],
 							     rep->field[i]->usage + j);
 			}
+		}
 }
 
 /*
-- 
1.8.3.2

