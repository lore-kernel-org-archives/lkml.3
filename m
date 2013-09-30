Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3I3KTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:19:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43763 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3I3KNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 084/104] HID: pantherlord: validate output report details
Date: Mon, 30 Sep 2013 11:11:01 +0100
Message-Id: <1380535881-9239-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-pl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 47ed74c..00cd2f8 100644
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
1.8.3.2

