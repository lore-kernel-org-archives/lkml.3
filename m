Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3HGLDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:03:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51739 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3HGLDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:03:31 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH v3 2/3] uio: provide vm access to UIO_MEM_PHYS maps
Date: Wed,  7 Aug 2013 13:02:53 +0200
Message-Id: <1375873374-12601-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1375873374-12601-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1375873374-12601-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/uio/uio.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 3b96f18..c4279b2 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -630,12 +630,26 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
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
+	vma->vm_ops = &uio_logical_vm_ops;
+	uio_vma_open(vma);
+	return 0;
+}
+
+static const struct vm_operations_struct uio_physical_vm_ops = {
+#ifdef CONFIG_HAVE_IOREMAP_PROT
+	.access = generic_access_phys,
+#endif
+};
+
 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -643,6 +657,8 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	if (mi < 0)
 		return -EINVAL;
 
+	vma->vm_ops = &uio_physical_vm_ops;
+
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	return remap_pfn_range(vma,
@@ -652,14 +668,6 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
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
1.8.4.rc1

