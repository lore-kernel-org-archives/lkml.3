Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3IYAIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:08:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab3IYAIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:08:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Rafi Rubin <rafi@seas.upenn.edu>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 20/28] HID: ntrig: validate feature report details
Date: Tue, 24 Sep 2013 17:07:51 -0700
Message-Id: <20130925000653.231748565@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925000648.404447782@linuxfoundation.org>
References: <20130925000648.404447782@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-ntrig.c |    3 ++-
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


