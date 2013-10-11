Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3JKPsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:48:07 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60750 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3JKPsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:48:05 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, agraf@suse.de, B08248@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Subject: [PATCH] VFIO: vfio_iommu_type1: fix bug caused by break in nested loop
Date: Fri, 11 Oct 2013 17:47:31 +0200
Message-Id: <1381506452-2069-1-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vfio_iommu_type1.c there is a bug in vfio_dma_do_map, when checking
that pages are not already mapped. Since the check is being done in a
for loop nested within the main loop, breaking out of it does not create
the intended behavior. If the underlying IOMMU driver returns a non-NULL
value, this will be ignored and mapping the DMA range will be attempted
anyway, leading to unpredictable behavior.

This interracts badly with the ARM SMMU driver issue fixed in the patch
that was submitted with the title:
"[PATCH 2/2] ARM: SMMU: return NULL on error in arm_smmu_iova_to_phys"
Both fixes are required in order to use the vfio_iommu_type1 driver
with an ARM SMMU.

This patch refactors the function slightly, in order to also make this
kind of bug less likely.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/vfio_iommu_type1.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index fa72a71..023ba12 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -548,6 +548,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	long npage;
 	int ret = 0, prot = 0;
 	uint64_t mask;
+	struct vfio_dma *dma = NULL;
+	unsigned long pfn;
 
 	end = map->iova + map->size;
 
@@ -590,8 +592,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	}
 
 	for (iova = map->iova; iova < end; iova += size, vaddr += size) {
-		struct vfio_dma *dma = NULL;
-		unsigned long pfn;
 		long i;
 
 		/* Pin a contiguous chunk of memory */
@@ -600,16 +600,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
-			break;
+			goto out;
 		}
 
 		/* Verify pages are not already mapped */
 		for (i = 0; i < npage; i++) {
 			if (iommu_iova_to_phys(iommu->domain,
 					       iova + (i << PAGE_SHIFT))) {
-				vfio_unpin_pages(pfn, npage, prot, true);
 				ret = -EBUSY;
-				break;
+				goto out_unpin;
 			}
 		}
 
@@ -619,8 +618,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		if (ret) {
 			if (ret != -EBUSY ||
 			    map_try_harder(iommu, iova, pfn, npage, prot)) {
-				vfio_unpin_pages(pfn, npage, prot, true);
-				break;
+				goto out_unpin;
 			}
 		}
 
@@ -675,9 +673,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			dma = kzalloc(sizeof(*dma), GFP_KERNEL);
 			if (!dma) {
 				iommu_unmap(iommu->domain, iova, size);
-				vfio_unpin_pages(pfn, npage, prot, true);
 				ret = -ENOMEM;
-				break;
+				goto out_unpin;
 			}
 
 			dma->size = size;
@@ -688,16 +685,21 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		}
 	}
 
-	if (ret) {
-		struct vfio_dma *tmp;
-		iova = map->iova;
-		size = map->size;
-		while ((tmp = vfio_find_dma(iommu, iova, size))) {
-			int r = vfio_remove_dma_overlap(iommu, iova,
-							&size, tmp);
-			if (WARN_ON(r || !size))
-				break;
-		}
+	WARN_ON(ret);
+	mutex_unlock(&iommu->lock);
+	return ret;
+
+out_unpin:
+	vfio_unpin_pages(pfn, npage, prot, true);
+
+out:
+	iova = map->iova;
+	size = map->size;
+	while ((dma = vfio_find_dma(iommu, iova, size))) {
+		int r = vfio_remove_dma_overlap(iommu, iova,
+						&size, dma);
+		if (WARN_ON(r || !size))
+			break;
 	}
 
 	mutex_unlock(&iommu->lock);
-- 
1.8.1.2

