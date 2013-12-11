Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3LKVAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:00:24 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63579 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3LKVAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:00:16 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 6/9] VFIO_PLATFORM: Support MMAP of MMIO regions
Date: Wed, 11 Dec 2013 21:58:30 +0100
Message-Id: <1386795513-32426-7-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to memory map the MMIO regions of the device so userspace can
directly access them.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index d0b2941..9786660 100644
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
 
@@ -283,6 +288,34 @@ err:
 
 static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
 {
+	struct vfio_platform_device *vdev = device_data;
+	u64 req_len = vma->vm_end - vma->vm_start;
+	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
+	int i;
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+	if (vma->vm_end & ~PAGE_MASK)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+	for (i = 0; i < vdev->num_regions; i++) {
+		struct vfio_platform_region region = vdev->region[i];
+
+		if ((addr < region.addr)
+		     || (addr + req_len - 1) >= (region.addr + region.size))
+			continue;
+
+		vma->vm_private_data = vdev;
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+		return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+				       req_len, vma->vm_page_prot);
+	}
+
 	return -EINVAL;
 }
 
-- 
1.8.3.2

