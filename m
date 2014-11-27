Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaK0RXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:23:39 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40084 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaK0RXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:23:36 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 6/6] vfio: type1: implement the VFIO_DMA_MAP_FLAG_NOEXEC flag
Date: Thu, 27 Nov 2014 18:22:56 +0100
Message-Id: <1417108976-10113-7-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417108976-10113-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417108976-10113-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some IOMMU drivers, such as the ARM SMMU driver, make available the
IOMMU_NOEXEC flag to set the page tables for a device as XN (execute never).
This affects devices such as the ARM PL330 DMA Controller, which respects
this flag and will refuse to fetch DMA instructions from memory where the
XN flag has been set.

The flag can be used only if all IOMMU domains behind the container support
the IOMMU_NOEXEC flag. Also, if any mappings are created with the flag, any
new domains with devices will have to support it as well.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bdf7dc9..8ba8a87 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -573,6 +573,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (!prot || !size || (size | iova | vaddr) & mask)
 		return -EINVAL;
 
+	if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
+		if (!vfio_domains_have_iommu_cap(iommu, IOMMU_CAP_NOEXEC))
+			return -EINVAL;
+		prot |= IOMMU_NOEXEC;
+	}
+
 	/* Don't allow IOVA or virtual address wrap */
 	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr)
 		return -EINVAL;
@@ -663,6 +669,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 		dma = rb_entry(n, struct vfio_dma, node);
 		iova = dma->iova;
 
+		/*
+		 * if any of the mappings to be replayed has the NOEXEC flag
+		 * set, then the new iommu domain must support it
+		 */
+		if ((dma->prot & IOMMU_NOEXEC) &&
+				!(domain->caps & IOMMU_CAP_NOEXEC))
+			return -EINVAL;
+
 		while (iova < dma->iova + dma->size) {
 			phys_addr_t phys = iommu_iova_to_phys(d->domain, iova);
 			size_t size;
@@ -759,6 +773,9 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
 		domain->caps |= IOMMU_CAP_CACHE_COHERENCY;
 
+	if (iommu_capable(bus, IOMMU_CAP_NOEXEC))
+		domain->caps |= IOMMU_CAP_NOEXEC;
+
 	/*
 	 * Try to match an existing compatible domain.  We don't want to
 	 * preclude an IOMMU driver supporting multiple bus_types and being
@@ -920,6 +937,11 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 				return 0;
 			return vfio_domains_have_iommu_cap(iommu,
 						  IOMMU_CAP_CACHE_COHERENCY);
+		case VFIO_DMA_NOEXEC_IOMMU:
+			if (!iommu)
+				return 0;
+			return vfio_domains_have_iommu_cap(iommu,
+							   IOMMU_CAP_NOEXEC);
 		default:
 			return 0;
 		}
@@ -943,7 +965,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
 		struct vfio_iommu_type1_dma_map map;
 		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
-				VFIO_DMA_MAP_FLAG_WRITE;
+				VFIO_DMA_MAP_FLAG_WRITE |
+				VFIO_DMA_MAP_FLAG_NOEXEC;
 
 		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
 
-- 
2.1.3

