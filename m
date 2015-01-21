Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbbAUMwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:52:13 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34500 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbAUMwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:52:04 -0500
From: Baptiste Reynal <b.reynal@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Baptiste Reynal <b.reynal@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v12 07/18] vfio/platform: support MMAP of MMIO regions
Date: Wed, 21 Jan 2015 13:49:55 +0100
Message-Id: <1421844606-24751-8-git-send-email-b.reynal@virtualopensystems.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Allow to memory map the MMIO regions of the device so userspace can
directly access them. PIO regions are not being handled at this point.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 65 ++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index fda4c30..6bf78ee 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -54,6 +54,16 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 			if (!(res->flags & IORESOURCE_READONLY))
 				vdev->regions[i].flags |=
 					VFIO_REGION_INFO_FLAG_WRITE;
+
+			/*
+			 * Only regions addressed with PAGE granularity may be
+			 * MMAPed securely.
+			 */
+			if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
+					!(vdev->regions[i].size & ~PAGE_MASK))
+				vdev->regions[i].flags |=
+					VFIO_REGION_INFO_FLAG_MMAP;
+
 			break;
 		case IORESOURCE_IO:
 			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
@@ -333,8 +343,63 @@ static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
 	return -EINVAL;
 }
 
+static int vfio_platform_mmap_mmio(struct vfio_platform_region region,
+				   struct vm_area_struct *vma)
+{
+	u64 req_len, pgoff, req_start;
+
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start = pgoff << PAGE_SHIFT;
+
+	if (region.size < PAGE_SIZE || req_start + req_len > region.size)
+		return -EINVAL;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       req_len, vma->vm_page_prot);
+}
+
 static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
 {
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int index;
+
+	index = vma->vm_pgoff >> (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if (!(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+	if (index >= vdev->num_regions)
+		return -EINVAL;
+	if (vma->vm_start & ~PAGE_MASK)
+		return -EINVAL;
+	if (vma->vm_end & ~PAGE_MASK)
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ)
+			&& (vma->vm_flags & VM_READ))
+		return -EINVAL;
+
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
+			&& (vma->vm_flags & VM_WRITE))
+		return -EINVAL;
+
+	vma->vm_private_data = vdev;
+
+	if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_MMIO)
+		return vfio_platform_mmap_mmio(vdev->regions[index], vma);
+
+	else if (vdev->regions[index].type & VFIO_PLATFORM_REGION_TYPE_PIO)
+		return -EINVAL; /* not implemented */
+
 	return -EINVAL;
 }
 
-- 
2.2.2

