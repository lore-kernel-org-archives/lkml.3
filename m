Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3JCEJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:09:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3JCEJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:09:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 16/16] HID: LG: validate HID output report details
Date: Wed,  2 Oct 2013 21:05:40 -0700
Message-Id: <20131003040446.646215809@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040445.523176877@linuxfoundation.org>
References: <20131003040445.523176877@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-lg2ff.c |   19 +++----------------
 drivers/hid/hid-lg3ff.c |   29 ++++++-----------------------
 drivers/hid/hid-lg4ff.c |   20 +-------------------
 drivers/hid/hid-lgff.c  |   17 ++---------------
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


