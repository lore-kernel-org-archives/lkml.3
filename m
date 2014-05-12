Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaELBop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:45 -0400
Received: from 1wt.eu ([62.212.114.60]:34812 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbaELBol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:41 -0400
Message-Id: <20140512003201.508840183@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, stable@kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Willy Tarreau <w@1wt.eu>
Subject: [ 021/143] HID: pantherlord: validate output report details
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 412f30105ec6735224535791eed5cdc02888ecb4 upstream

A HID device could send a malicious output report that would cause the
pantherlord HID driver to write beyond the output report allocation
during initialization, causing a heap overflow:

[  310.939483] usb 1-1: New USB device found, idVendor=0e8f, idProduct=0003
...
[  315.980774] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

CVE-2013-2892

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/hid/hid-pl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index c6d7dbc..8cdf7b8 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -128,8 +128,14 @@ static int plff_init(struct hid_device *hid)
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
1.7.12.2.21.g234cd45.dirty



