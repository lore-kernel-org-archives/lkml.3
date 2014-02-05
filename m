Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbaBEVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:16:10 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47903 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbaBEUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 020/213] HID: zeroplus: validate output report details
Date: Wed, 5 Feb 2014 14:59:35 -0500
Message-ID: <1391630568-49251-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hid-zpff.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index b7acceabba80..a24f9fb43c34 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -69,21 +69,13 @@ static int zpff_init(struct hid_device *hid)
 	struct hid_report *report;
 	struct hid_input *hidinput = list_entry(hid->inputs.next,
 						struct hid_input, list);
-	struct list_head *report_list =
-			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
 	struct input_dev *dev = hidinput->input;
-	int error;
+	int i, error;
 
-	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output report found\n");
-		return -ENODEV;
-	}
-
-	report = list_entry(report_list->next, struct hid_report, list);
-
-	if (report->maxfield < 4) {
-		dev_err(&hid->dev, "not enough fields in report\n");
-		return -ENODEV;
+	for (i = 0; i < 4; i++) {
+		report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, i, 1);
+		if (!report)
+			return -ENODEV;
 	}
 
 	zpff = kzalloc(sizeof(struct zpff_device), GFP_KERNEL);
-- 
1.8.5.2

