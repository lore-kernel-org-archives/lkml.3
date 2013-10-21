Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3JUJTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:19:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39534 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab3JUIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Kees Cook" <keescook@chromium.org>,
        "Rafi Rubin" <rafi@seas.upenn.edu>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.747695565@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 055/149] HID: ntrig: validate feature report details
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-ntrig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -115,7 +115,8 @@ static inline int ntrig_get_mode(struct
 	struct hid_report *report = hdev->report_enum[HID_FEATURE_REPORT].
 				    report_id_hash[0x0d];
 
-	if (!report)
+	if (!report || report->maxfield < 1 ||
+	    report->field[0]->report_count < 1)
 		return -EINVAL;
 
 	usbhid_submit_report(hdev, report, USB_DIR_IN);

