Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbaD1P6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:58:46 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50291 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbaD1Pyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:54:33 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v5 08/11] VFIO_PLATFORM: Support MMAP of MMIO regions
Date: Mon, 28 Apr 2014 17:52:48 +0200
Message-Id: <1398700371-20096-9-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to memory map the MMIO regions of the device so userspace can
directly access them.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c | 40 ++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 7c01ced..37beff3 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -58,6 +58,11 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 		region.flags = VFIO_REGION_INFO_FLAG_READ
 				| VFIO_REGION_INFO_FLAG_WRITE;
 
+		/* Only regions addressed with PAGE granularity can be MMAPed
+		 * securely. */
+		if (!(region.addr & ~PAGE_MASK) && !(region.size & ~PAGE_MASK))
+			region.flags |= VFIO_REGION_INFO_FLAG_MMAP;
+
 		vdev->region[i] = region;
 	}
 
@@ -268,7 +273,40 @@ err:
 
 static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
 {
-	return -EINVAL;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index;
+	u64 req_len, pgoff, req_start;
+	struct vfio_platform_region region;
+
+	index = vma->vm_pgoff >> (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+	if (vma->vm_end & ~PAGE_MASK)
+		return -EINVAL;
+
+	region = vdev->region[index];
+
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start = pgoff << PAGE_SHIFT;
+
+	if (region.size < PAGE_SIZE || req_start + req_len > region.size)
+		return -EINVAL;
+
+	vma->vm_private_data = vdev;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       req_len, vma->vm_page_prot);
 }
 
 static const struct vfio_device_ops vfio_platform_ops = {
-- 
1.8.3.2

