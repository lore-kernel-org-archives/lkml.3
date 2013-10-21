Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3JUJOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:14:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39599 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833Ab3JUIvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Kees Cook" <keescook@chromium.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.468981022@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 071/149] HID: validate feature and input report details
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Drop inapplicable changes to hid_usage::usage_index initialisation and
   to hid_report_raw_event()
 - Adjust context in report_features()
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -218,9 +218,9 @@ static int hid_add_field(struct hid_pars
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
@@ -239,7 +239,8 @@ static int hid_add_field(struct hid_pars
 	if (!parser->local.usage_index) /* Ignore padding fields */
 		return 0;
 
-	usages = max_t(int, parser->local.usage_index, parser->global.report_count);
+	usages = max_t(unsigned, parser->local.usage_index,
+				 parser->global.report_count);
 
 	field = hid_register_field(report, usages, parser->global.report_count);
 	if (!field)
@@ -250,7 +251,7 @@ static int hid_add_field(struct hid_pars
 	field->application = hid_lookup_collection(parser, HID_COLLECTION_APPLICATION);
 
 	for (i = 0; i < usages; i++) {
-		int j = i;
+		unsigned j = i;
 		/* Duplicate the last usage we parsed if we have excess values */
 		if (i >= parser->local.usage_index)
 			j = parser->local.usage_index - 1;
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -284,6 +284,10 @@ static void hidinput_configure_usage(str
 	if (field->flags & HID_MAIN_ITEM_CONSTANT)
 		goto ignore;
 
+	/* Ignore if report count is out of bounds. */
+	if (field->report_count < 1)
+		goto ignore;
+
 	/* only LED usages are supported in output fields */
 	if (field->report_type == HID_OUTPUT_REPORT &&
 			(usage->hid & HID_USAGE_PAGE) != HID_UP_LED) {
@@ -887,10 +891,15 @@ static void report_features(struct hid_d
 
 	rep_enum = &hid->report_enum[HID_FEATURE_REPORT];
 	list_for_each_entry(rep, &rep_enum->report_list, list)
-		for (i = 0; i < rep->maxfield; i++)
+		for (i = 0; i < rep->maxfield; i++) {
+			/* Ignore if report count is out of bounds. */
+			if (rep->field[i]->report_count < 1)
+				continue;
+
 			for (j = 0; j < rep->field[i]->maxusage; j++)
 				drv->feature_mapping(hid, rep->field[i],
 						     rep->field[i]->usage + j);
+		}
 }
 
 /*

