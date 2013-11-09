Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab3KIHV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:21:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab3KIGva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 3.10 50/74] uio: provide vm access to UIO_MEM_PHYS maps
Date: Fri,  8 Nov 2013 22:51:55 -0800
Message-Id: <20131109065117.016923315@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 7294151d0592e0ff48c61fca9fd7c93d613134da upstream.

This makes it possible to let gdb access mappings of the process that is
being debugged.

uio_mmap_logical was moved and uio_vm_ops renamed to group related code
and differentiate to new stuff.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/uio/uio.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -630,12 +630,26 @@ static int uio_vma_fault(struct vm_area_
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
@@ -643,6 +657,8 @@ static int uio_mmap_physical(struct vm_a
 	if (mi < 0)
 		return -EINVAL;
 
+	vma->vm_ops = &uio_physical_vm_ops;
+
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	return remap_pfn_range(vma,
@@ -652,14 +668,6 @@ static int uio_mmap_physical(struct vm_a
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


