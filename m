Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3ITURV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:17:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3ITUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Rafi Rubin <rafi@seas.upenn.edu>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 72/93] HID: ntrig: validate feature report details
Date: Fri, 20 Sep 2013 13:09:07 -0700
Message-Id: <1379707768-1804-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 875b4e3763dbc941f15143dd1a18d10bb0be303b upstream.

A HID device could send a malicious feature report that would cause the
ntrig HID driver to trigger a NULL dereference during initialization:

[57383.031190] usb 3-1: New USB device found, idVendor=1b96, idProduct=0001
...
[57383.315193] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[57383.315308] IP: [<ffffffffa08102de>] ntrig_probe+0x25e/0x420 [hid_ntrig]

CVE-2013-2896

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-ntrig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 86a969f..60bd823 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -115,7 +115,8 @@ static inline int ntrig_get_mode(struct hid_device *hdev)
 	struct hid_report *report = hdev->report_enum[HID_FEATURE_REPORT].
 				    report_id_hash[0x0d];
 
-	if (!report)
+	if (!report || report->maxfield < 1 ||
+	    report->field[0]->report_count < 1)
 		return -EINVAL;
 
 	usbhid_submit_report(hdev, report, USB_DIR_IN);
-- 
1.8.1.2

