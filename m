Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbbAPSvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:51:17 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45963 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbbAPSuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:50:08 -0500
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: [PATCH 2/4] uio: Remove unused uio_info mmap method.
Date: Fri, 16 Jan 2015 10:49:37 -0800
Message-Id: <1421434179-3650-3-git-send-email-mandeep.sandhu@cyaninc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no drivers in the kernel that implement the uio_info mmap
method so there is no point in keeping it.

Further keeping the mmap method would necessitate wrapping all of the
methods in vm_operations_struct to successfully implement support for
hotunplugable hardware, and it I have yet to find a correct way to wrap
the the vm_operations_struct close method.

Tested-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
---
 drivers/uio/uio.c          | 6 ------
 include/linux/uio_driver.h | 2 --
 2 files changed, 8 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 350b81b..4b57c6b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -670,7 +670,6 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct uio_device *idev = listener->dev;
 	int mi;
 	unsigned long requested_pages, actual_pages;
-	int ret = 0;
 
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
@@ -687,11 +686,6 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	if (requested_pages > actual_pages)
 		return -EINVAL;
 
-	if (idev->info->mmap) {
-		ret = idev->info->mmap(idev->info, vma);
-		return ret;
-	}
-
 	switch (idev->info->mem[mi].memtype) {
 		case UIO_MEM_PHYS:
 			return uio_mmap_physical(vma);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index e8f7f82..3d906e0 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -87,7 +87,6 @@ struct uio_device {
  * @irq_flags:		flags for request_irq()
  * @priv:		optional private data
  * @handler:		the device's irq handler
- * @mmap:		mmap operation for this uio device
  * @open:		open operation for this uio device
  * @release:		release operation for this uio device
  * @irqcontrol:		disable/enable irqs when 0/1 is written to /dev/uioX
@@ -102,7 +101,6 @@ struct uio_info {
 	unsigned long		irq_flags;
 	void			*priv;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
-	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
-- 
1.9.1

