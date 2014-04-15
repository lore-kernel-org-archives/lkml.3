Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaDONKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:10:53 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47893 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaDONJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:09:16 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v3 3/5] intel-iommu: integrate DMA CMA
Date: Tue, 15 Apr 2014 22:08:47 +0900
Message-Id: <1397567329-3771-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the DMA Contiguous Memory Allocator for intel-iommu.
This change enables dma_alloc_coherent() to allocate big contiguous
memory.

It is achieved in the same way as nommu_dma_ops currently does, i.e.
trying to allocate memory by dma_alloc_from_contiguous() and alloc_pages()
is used as a fallback.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org
Cc: iommu@lists.linux-foundation.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* Changes from v2
- Fix gfp flags check for __GFP_ATOMIC, reported by Marek Szyprowski
- Rebased on current Linus tree

 drivers/iommu/intel-iommu.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index cdb97c4..78c68cb 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3185,7 +3185,7 @@ static void *intel_alloc_coherent(struct device *dev, size_t size,
 				  dma_addr_t *dma_handle, gfp_t flags,
 				  struct dma_attrs *attrs)
 {
-	void *vaddr;
+	struct page *page = NULL;
 	int order;
 
 	size = PAGE_ALIGN(size);
@@ -3200,17 +3200,31 @@ static void *intel_alloc_coherent(struct device *dev, size_t size,
 			flags |= GFP_DMA32;
 	}
 
-	vaddr = (void *)__get_free_pages(flags, order);
-	if (!vaddr)
+	if (flags & __GFP_WAIT) {
+		unsigned int count = size >> PAGE_SHIFT;
+
+		page = dma_alloc_from_contiguous(dev, count, order);
+		if (page && iommu_no_mapping(dev) &&
+		    page_to_phys(page) + size > dev->coherent_dma_mask) {
+			dma_release_from_contiguous(dev, page, count);
+			page = NULL;
+		}
+	}
+
+	if (!page)
+		page = alloc_pages(flags, order);
+	if (!page)
 		return NULL;
-	memset(vaddr, 0, size);
+	memset(page_address(page), 0, size);
 
-	*dma_handle = __intel_map_single(dev, virt_to_bus(vaddr), size,
+	*dma_handle = __intel_map_single(dev, page_to_phys(page), size,
 					 DMA_BIDIRECTIONAL,
 					 dev->coherent_dma_mask);
 	if (*dma_handle)
-		return vaddr;
-	free_pages((unsigned long)vaddr, order);
+		return page_address(page);
+	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
+		__free_pages(page, order);
+
 	return NULL;
 }
 
@@ -3218,12 +3232,14 @@ static void intel_free_coherent(struct device *dev, size_t size, void *vaddr,
 				dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	int order;
+	struct page *page = virt_to_page(vaddr);
 
 	size = PAGE_ALIGN(size);
 	order = get_order(size);
 
 	intel_unmap_page(dev, dma_handle, size, DMA_BIDIRECTIONAL, NULL);
-	free_pages((unsigned long)vaddr, order);
+	if (!dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT))
+		__free_pages(page, order);
 }
 
 static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
-- 
1.8.3.2

