Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaDGW30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031AbaDGW3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:29:01 -0400
Subject: [PATCH 3/3] vfio/iommu_type1: Avoid overflow
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 07 Apr 2014 16:29:00 -0600
Message-ID: <20140407222900.12761.64686.stgit@bling.home>
In-Reply-To: <20140407221857.12761.73684.stgit@bling.home>
References: <20140407221857.12761.73684.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity reports use of a tained scalar used as a loop boundary.
For the most part, any values passed from userspace for a DMA mapping
size, IOVA, or virtual address are valid, with some alignment
constraints.  The size is ultimately bound by how many pages the user
is able to lock, IOVA is tested by the IOMMU driver when doing a map,
and the virtual address needs to pass get_user_pages.  The only
problem I can find is that we do expect the __u64 user values to fit
within our variables, which might not happen on 32bit platforms.  Add
a test for this and return error on overflow.  Also propagate use of
the type-correct local variables throughout the function.

The above also points to the 'end' variable, which can be zero if
we're operating at the very top of the address space.  We try to
account for this, but our loop botches it.  Rework the loop to use
the remaining size as our loop condition rather than the IOVA vs end.

Detected by Coverity: CID 714659

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c |   45 ++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6673e7b..0734fbe 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -524,7 +524,7 @@ unwind:
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
-	dma_addr_t end, iova;
+	dma_addr_t iova = map->iova;
 	unsigned long vaddr = map->vaddr;
 	size_t size = map->size;
 	long npage;
@@ -533,39 +533,30 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	unsigned long pfn;
 
-	end = map->iova + map->size;
+	/* Verify that none of our __u64 fields overflow */
+	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
+		return -EINVAL;
 
 	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
 
+	WARN_ON(mask & PAGE_MASK);
+
 	/* READ/WRITE from device perspective */
 	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
 		prot |= IOMMU_WRITE;
 	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
 		prot |= IOMMU_READ;
 
-	if (!prot)
-		return -EINVAL; /* No READ/WRITE? */
-
-	if (vaddr & mask)
-		return -EINVAL;
-	if (map->iova & mask)
-		return -EINVAL;
-	if (!map->size || map->size & mask)
-		return -EINVAL;
-
-	WARN_ON(mask & PAGE_MASK);
-
-	/* Don't allow IOVA wrap */
-	if (end && end < map->iova)
+	if (!prot || !size || (size | iova | vaddr) & mask)
 		return -EINVAL;
 
-	/* Don't allow virtual address wrap */
-	if (vaddr + map->size && vaddr + map->size < vaddr)
+	/* Don't allow IOVA or virtual address wrap */
+	if (iova + size - 1 < iova || vaddr + size - 1 < vaddr)
 		return -EINVAL;
 
 	mutex_lock(&iommu->lock);
 
-	if (vfio_find_dma(iommu, map->iova, map->size)) {
+	if (vfio_find_dma(iommu, iova, size)) {
 		mutex_unlock(&iommu->lock);
 		return -EEXIST;
 	}
@@ -576,17 +567,17 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		return -ENOMEM;
 	}
 
-	dma->iova = map->iova;
-	dma->vaddr = map->vaddr;
+	dma->iova = iova;
+	dma->vaddr = vaddr;
 	dma->prot = prot;
 
 	/* Insert zero-sized and grow as we map chunks of it */
 	vfio_link_dma(iommu, dma);
 
-	for (iova = map->iova; iova < end; iova += size, vaddr += size) {
+	while (size) {
 		/* Pin a contiguous chunk of memory */
-		npage = vfio_pin_pages(vaddr, (end - iova) >> PAGE_SHIFT,
-				       prot, &pfn);
+		npage = vfio_pin_pages(vaddr + dma->size,
+				       size >> PAGE_SHIFT, prot, &pfn);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
@@ -594,14 +585,14 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		}
 
 		/* Map it! */
-		ret = vfio_iommu_map(iommu, iova, pfn, npage, prot);
+		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage, prot);
 		if (ret) {
 			vfio_unpin_pages(pfn, npage, prot, true);
 			break;
 		}
 
-		size = npage << PAGE_SHIFT;
-		dma->size += size;
+		size -= npage << PAGE_SHIFT;
+		dma->size += npage << PAGE_SHIFT;
 	}
 
 	if (ret)

