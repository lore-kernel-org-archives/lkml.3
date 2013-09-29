Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3I2T1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:27:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3I2T12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 06/22] HID: zeroplus: validate output report details
Date: Sun, 29 Sep 2013 12:26:52 -0700
Message-Id: <20130929191159.322323351@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191158.889693326@linuxfoundation.org>
References: <20130929191158.889693326@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 78214e81a1bf43740ce89bb5efda78eac2f8ef83 upstream.

The zeroplus HID driver was not checking the size of allocated values
in fields it used. A HID device could send a malicious output report
that would cause the driver to write beyond the output report allocation
during initialization, causing a heap overflow:

[ 1442.728680] usb 1-1: New USB device found, idVendor=0c12, idProduct=0005
...
[ 1466.243173] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

CVE-2013-2889

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-zpff.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -70,21 +70,13 @@ static int zpff_init(struct hid_device *
 	struct hid_report *report;
 	struct hid_input *hidinput = list_entry(hid->inputs.next,
 						struct hid_input, list);
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	int error;
+	int i, error;
 
-	if (list_empty(report_list)) {
-		hid_err(hid, "no output report found\n");
-		return -ENODEV;
-	}
-
-	report = list_entry(report_list->next, struct hid_report, list);
-
-	if (report->maxfield < 4) {
-		hid_err(hid, "not enough fields in report\n");
-		return -ENODEV;
+	for (i = 0; i < 4; i++) {
+		report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, i, 1);
+		if (!report)
+			return -ENODEV;
 	}
 
 	zpff = kzalloc(sizeof(struct zpff_device), GFP_KERNEL);


