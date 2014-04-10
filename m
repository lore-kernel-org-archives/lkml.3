Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993AbaDJDWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:22:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934651AbaDJDVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 018/134] HID: multitouch: validate indexes details
Date: Wed,  9 Apr 2014 20:22:14 -0700
Message-Id: <20140410032302.186214554@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 8821f5dc187bdf16cfb32ef5aa8c3035273fa79a upstream.

When working on report indexes, always validate that they are in bounds.
Without this, a HID device could report a malicious feature report that
could trick the driver into a heap overflow:

[  634.885003] usb 1-1: New USB device found, idVendor=0596, idProduct=0500
...
[  676.469629] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

Note that we need to change the indexes from s8 to s16 as they can
be between -1 and 255.

CVE-2013-2897

Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: mt_device::{cc,cc_value,inputmode}_index do not
 exist and the corresponding indices do not need to be validated.
 mt_device::maxcontact_report_id does not exist either.  So all we need
 to do is to widen mt_device::inputmode.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[yjw: Backport to 3.4: maxcontact_report_id exists,
 need to be validated]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -82,8 +82,8 @@ struct mt_device {
 					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
-	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
-	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
+	__s16 inputmode;		/* InputMode HID feature, -1 if non-existent */
+	__s16 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */


