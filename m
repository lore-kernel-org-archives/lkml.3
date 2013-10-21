Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3JUJRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:17:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39554 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753793Ab3JUIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:37 -0400
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
Message-ID: <lsq.1382345188.152234434@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 070/149] HID: LG: validate HID output report details
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 0fb6bd06e06792469acc15bbe427361b56ada528 upstream.

A HID device could send a malicious output report that would cause the
lg, lg3, and lg4 HID drivers to write beyond the output report allocation
during an event, causing a heap overflow:

[  325.245240] usb 1-1: New USB device found, idVendor=046d, idProduct=c287
...
[  414.518960] BUG kmalloc-4096 (Not tainted): Redzone overwritten

Additionally, while lg2 did correctly validate the report details, it was
cleaned up and shortened.

CVE-2013-2893

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-lg2ff.c | 19 +++----------------
 drivers/hid/hid-lg3ff.c | 29 ++++++-----------------------
 drivers/hid/hid-lg4ff.c | 20 +-------------------
 drivers/hid/hid-lgff.c  | 17 ++---------------
 4 files changed, 12 insertions(+), 73 deletions(-)

--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -66,26 +66,13 @@ int lg2ff_init(struct hid_device *hid)
 	struct hid_report *report;
 	struct hid_input *hidinput = list_entry(hid->inputs.next,
 						struct hid_input, list);
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
 	int error;
 
-	if (list_empty(report_list)) {
-		hid_err(hid, "no output report found\n");
+	/* Check that the report looks ok */
+	report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7);
+	if (!report)
 		return -ENODEV;
-	}
-
-	report = list_entry(report_list->next, struct hid_report, list);
-
-	if (report->maxfield < 1) {
-		hid_err(hid, "output report is empty\n");
-		return -ENODEV;
-	}
-	if (report->field[0]->report_count < 7) {
-		hid_err(hid, "not enough values in the field\n");
-		return -ENODEV;
-	}
 
 	lg2ff = kmalloc(sizeof(struct lg2ff_device), GFP_KERNEL);
 	if (!lg2ff)
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -68,10 +68,11 @@ static int hid_lg3ff_play(struct input_d
 	int x, y;
 
 /*
- * Maxusage should always be 63 (maximum fields)
- * likely a better way to ensure this data is clean
+ * Available values in the field should always be 63, but we only use up to
+ * 35. Instead, clear the entire area, however big it is.
  */
-	memset(report->field[0]->value, 0, sizeof(__s32)*report->field[0]->maxusage);
+	memset(report->field[0]->value, 0,
+	       sizeof(__s32) * report->field[0]->report_count);
 
 	switch (effect->type) {
 	case FF_CONSTANT:
@@ -131,32 +132,14 @@ static const signed short ff3_joystick_a
 int lg3ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	const signed short *ff_bits = ff3_joystick_ac;
 	int error;
 	int i;
 
-	/* Find the report to use */
-	if (list_empty(report_list)) {
-		hid_err(hid, "No output report found\n");
-		return -1;
-	}
-
 	/* Check that the report looks ok */
-	report = list_entry(report_list->next, struct hid_report, list);
-	if (!report) {
-		hid_err(hid, "NULL output report\n");
-		return -1;
-	}
-
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
-		return -1;
-	}
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 35))
+		return -ENODEV;
 
 	/* Assume single fixed device G940 */
 	for (i = 0; ff_bits[i] >= 0; i++)
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -339,33 +339,15 @@ static ssize_t lg4ff_range_store(struct
 int lg4ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	struct lg4ff_device_entry *entry;
 	struct usb_device_descriptor *udesc;
 	int error, i, j;
 	__u16 bcdDevice, rev_maj, rev_min;
 
-	/* Find the report to use */
-	if (list_empty(report_list)) {
-		hid_err(hid, "No output report found\n");
-		return -1;
-	}
-
 	/* Check that the report looks ok */
-	report = list_entry(report_list->next, struct hid_report, list);
-	if (!report) {
-		hid_err(hid, "NULL output report\n");
-		return -1;
-	}
-
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -1;
-	}
 
 	/* Check what wheel has been connected */
 	for (i = 0; i < ARRAY_SIZE(lg4ff_devices); i++) {
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -130,27 +130,14 @@ static void hid_lgff_set_autocenter(stru
 int lgff_init(struct hid_device* hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	const signed short *ff_bits = ff_joystick;
 	int error;
 	int i;
 
-	/* Find the report to use */
-	if (list_empty(report_list)) {
-		hid_err(hid, "No output report found\n");
-		return -1;
-	}
-
 	/* Check that the report looks ok */
-	report = list_entry(report_list->next, struct hid_report, list);
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
-		return -1;
-	}
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
+		return -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(devices); i++) {
 		if (dev->id.vendor == devices[i].idVendor &&

