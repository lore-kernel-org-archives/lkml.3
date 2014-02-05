Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaBEUDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:03:45 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47898 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaBEUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 018/213] HID: pantherlord: validate output report details
Date: Wed, 5 Feb 2014 14:59:33 -0500
Message-ID: <1391630568-49251-19-git-send-email-paul.gortmaker@windriver.com>
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

commit 412f30105ec6735224535791eed5cdc02888ecb4 upstream.

A HID device could send a malicious output report that would cause the
pantherlord HID driver to write beyond the output report allocation
during initialization, causing a heap overflow:

[  310.939483] usb 1-1: New USB device found, idVendor=0e8f, idProduct=0003
...
[  315.980774] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

CVE-2013-2892

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hid-pl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 9f41e2bd8483..427f3a57aa23 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -129,8 +129,14 @@ static int plff_init(struct hid_device *hid)
 			strong = &report->field[0]->value[2];
 			weak = &report->field[0]->value[3];
 			debug("detected single-field device");
-		} else if (report->maxfield >= 4 && report->field[0]->maxusage == 1 &&
-				report->field[0]->usage[0].hid == (HID_UP_LED | 0x43)) {
+		} else if (report->field[0]->maxusage == 1 &&
+			   report->field[0]->usage[0].hid ==
+				(HID_UP_LED | 0x43) &&
+			   report->maxfield >= 4 &&
+			   report->field[0]->report_count >= 1 &&
+			   report->field[1]->report_count >= 1 &&
+			   report->field[2]->report_count >= 1 &&
+			   report->field[3]->report_count >= 1) {
 			report->field[0]->value[0] = 0x00;
 			report->field[1]->value[0] = 0x00;
 			strong = &report->field[2]->value[0];
-- 
1.8.5.2

