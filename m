Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab3JJPvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:51:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736Ab3JJPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 039/104] HID: LG: validate HID output report details
Date: Thu, 10 Oct 2013 08:41:27 -0700
Message-Id: <1381419752-29733-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-lg2ff.c | 19 +++----------------
 drivers/hid/hid-lg3ff.c | 29 ++++++-----------------------
 drivers/hid/hid-lg4ff.c | 20 +-------------------
 drivers/hid/hid-lgff.c  | 17 ++---------------
 4 files changed, 12 insertions(+), 73 deletions(-)

diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 3c31bc6..128f011 100644
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
diff --git a/drivers/hid/hid-lg3ff.c b/drivers/hid/hid-lg3ff.c
index f98644c..91f981f 100644
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -68,10 +68,11 @@ static int hid_lg3ff_play(struct input_dev *dev, void *data,
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
@@ -131,32 +132,14 @@ static const signed short ff3_joystick_ac[] = {
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
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index d7947c7..7edeee0 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -487,34 +487,16 @@ static enum led_brightness lg4ff_led_get_brightness(struct led_classdev *led_cde
 int lg4ff_init(struct hid_device *hid)
 {
 	struct hid_input *hidinput = list_entry(hid->inputs.next, struct hid_input, list);
-	struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	struct hid_report *report;
-	struct hid_field *field;
 	struct lg4ff_device_entry *entry;
 	struct lg_drv_data *drv_data;
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
+	if (!hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 7))
 		return -1;
-	}
-
-	field = report->field[0];
-	if (!field) {
-		hid_err(hid, "NULL field\n");
-		return -1;
-	}
 
 	/* Check what wheel has been connected */
 	for (i = 0; i < ARRAY_SIZE(lg4ff_devices); i++) {
diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
index 27bc54f..1d978daa 100644
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -130,27 +130,14 @@ static void hid_lgff_set_autocenter(struct input_dev *dev, u16 magnitude)
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
-- 
1.8.1.2

