Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbaDJDWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934650AbaDJDVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 017/134] HID: validate feature and input report details
Date: Wed,  9 Apr 2014 20:22:13 -0700
Message-Id: <20140410032302.046717723@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2:
 - Drop inapplicable changes to hid_usage::usage_index initialisation and
   to hid_report_raw_event()
 - Adjust context in report_features()
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[yijingwang: Backported to 3.4: context adjust]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c  |    9 +++++----
 drivers/hid/hid-input.c |   12 +++++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -222,9 +222,9 @@ static int hid_add_field(struct hid_pars
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
@@ -244,7 +244,8 @@ static int hid_add_field(struct hid_pars
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
 
-	usages = max_t(int, parser->local.usage_index, parser->global.report_count);
+	usages = max_t(unsigned, parser->local.usage_index,
+				 parser->global.report_count);
 
 	field = hid_register_field(report, usages, parser->global.report_count);
 	if (!field)
@@ -255,7 +256,7 @@ static int hid_add_field(struct hid_pars
 	field->application = hid_lookup_collection(parser, HID_COLLECTION_APPLICATION);
 
 	for (i = 0; i < usages; i++) {
-		int j = i;
+		unsigned j = i;
 		/* Duplicate the last usage we parsed if we have excess values */
 		if (i >= parser->local.usage_index)
 			j = parser->local.usage_index - 1;
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -459,6 +459,10 @@ static void hidinput_configure_usage(str
 	if (field->flags & HID_MAIN_ITEM_CONSTANT)
 		goto ignore;
 
+	/* Ignore if report count is out of bounds. */
+	if (field->report_count < 1)
+		goto ignore;
+
 	/* only LED usages are supported in output fields */
 	if (field->report_type == HID_OUTPUT_REPORT &&
 			(usage->hid & HID_USAGE_PAGE) != HID_UP_LED) {
@@ -1119,7 +1123,12 @@ static void report_features(struct hid_d
 
 	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
 	list_for_each_entry(rep, &rep_enum->report_list, list)
-		for (i = 0; i < rep->maxfield; i++)
+		for (i = 0; i < rep->maxfield; i++) {
+
+			/* Ignore if report count is out of bounds. */
+			if (rep->field[i]->report_count < 1)
+				continue;
+
 			for (j = 0; j < rep->field[i]->maxusage; j++) {
 				/* Verify if Battery Strength feature is available */
 				hidinput_setup_battery(hid, HID_FEATURE_REPORT, rep->field[i]);
@@ -1128,6 +1137,7 @@ static void report_features(struct hid_d
 					drv->feature_mapping(hid, rep->field[i],
 							     rep->field[i]->usage + j);
 			}
+		}
 }
 
 /*


