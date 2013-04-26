Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3DZKCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:02:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55641 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3DZKCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:02:43 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/2] uio: provide vm access to UIO_MEM_PHYS maps
Date: Fri, 26 Apr 2013 12:02:28 +0200
Message-Id: <1366970549-16292-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <1366970549-16292-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1366970549-16292-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to let gdb access mappings of the process that is
being debugged.

uio_mmap_logical was moved and uio_vm_ops renamed to group related code
and differentiate to new stuff.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/uio/uio.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index c8b9262..f9c905a 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -629,12 +629,24 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return 0;
 }
 
-static const struct vm_operations_struct uio_vm_ops = {
+static const struct vm_operations_struct uio_logical_vm_ops = {
 	.open = uio_vma_open,
 	.close = uio_vma_close,
 	.fault = uio_vma_fault,
 };
 
+static int uio_mmap_logical(struct vm_area_struct *vma)
+{
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &uio_vm_ops;
+	uio_vma_open(vma);
+	return 0;
+}
+
+static const struct vm_operations_struct uio_physical_vm_ops = {
+	.access = generic_access_phys,
+};
+
 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -642,6 +654,8 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	if (mi < 0)
 		return -EINVAL;
 
+	vma->vm_ops = &uio_physical_vm_ops;
+
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	return remap_pfn_range(vma,
@@ -651,14 +665,6 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 			       vma->vm_page_prot);
 }
 
-static int uio_mmap_logical(struct vm_area_struct *vma)
-{
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
-	vma->vm_ops = &uio_vm_ops;
-	uio_vma_open(vma);
-	return 0;
-}
-
 static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct uio_listener *listener = filep->private_data;
-- 
1.8.2.rc2

