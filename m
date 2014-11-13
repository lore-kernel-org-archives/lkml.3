Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaKMHrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:47:14 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52378 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaKMHrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:47:11 -0500
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH v4 2/6] uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
Date: Thu, 13 Nov 2014 13:15:18 +0530
Message-Id: <1415864722-2800-3-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415864722-2800-1-git-send-email-ankit.jindal@linaro.org>
References: <1415864722-2800-1-git-send-email-ankit.jindal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, three types of mem regions are supported: UIO_MEM_PHYS,
UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL. Among these UIO_MEM_PHYS helps
UIO driver export physcial memory to user space as non-cacheable
user memory. Typcially memory-mapped registers of a device are exported
to user space as UIO_MEM_PHYS type mem region. The UIO_MEM_PHYS type
is not efficient if dma-capable devices are capable of maintaining coherency
with CPU caches.

This patch adds new type UIO_MEM_PHYS_CACHE for mem regions to enable
cacheable access to physical memory from user space.

Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 drivers/uio/uio.c          |   11 ++++++++---
 include/linux/uio_driver.h |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 97e6444..120a84b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -644,7 +644,7 @@ static const struct vm_operations_struct uio_physical_vm_ops = {
 #endif
 };
 
-static int uio_mmap_physical(struct vm_area_struct *vma)
+static int uio_mmap_physical(struct vm_area_struct *vma, bool cacheable)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	int mi = uio_find_mem_index(vma);
@@ -659,7 +659,9 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 		return -EINVAL;
 
 	vma->vm_ops = &uio_physical_vm_ops;
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (!cacheable)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	/*
 	 * We cannot use the vm_iomap_memory() helper here,
@@ -707,10 +709,13 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 
 	switch (idev->info->mem[mi].memtype) {
 	case UIO_MEM_PHYS:
-		return uio_mmap_physical(vma);
+		return uio_mmap_physical(vma, false);
 	case UIO_MEM_LOGICAL:
 	case UIO_MEM_VIRTUAL:
 		return uio_mmap_logical(vma);
+	case UIO_MEM_PHYS_CACHE:
+		return uio_mmap_physical(vma, true);
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..40ca3f3 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -118,6 +118,7 @@ extern void uio_event_notify(struct uio_info *info);
 #define UIO_MEM_PHYS	1
 #define UIO_MEM_LOGICAL	2
 #define UIO_MEM_VIRTUAL 3
+#define UIO_MEM_PHYS_CACHE	4
 
 /* defines for uio_port->porttype */
 #define UIO_PORT_NONE	0
-- 
1.7.9.5

