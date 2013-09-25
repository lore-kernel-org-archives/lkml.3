Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab3IYBF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:05:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3IYAQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 063/110] HID: pantherlord: validate output report details
Date: Tue, 24 Sep 2013 17:15:01 -0700
Message-Id: <20130925001330.239690408@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-pl.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -132,8 +132,14 @@ static int plff_init(struct hid_device *
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


