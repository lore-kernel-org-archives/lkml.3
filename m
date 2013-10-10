Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3JJPz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:55:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53030 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3JJPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 038/104] HID: zeroplus: validate output report details
Date: Thu, 10 Oct 2013 08:41:26 -0700
Message-Id: <1381419752-29733-39-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-zpff.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index f6ba81d..f348f7f 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -70,21 +70,13 @@ static int zpff_init(struct hid_device *hid)
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
-- 
1.8.1.2

