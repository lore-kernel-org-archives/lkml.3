Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3HFRC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:02:27 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:47230 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3HFRCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:02:25 -0400
Message-ID: <201308061702.r76H2ORe011248@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 2 Aug 2013 12:24:42 -0400
Subject: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
In-Reply-To: <52012B96.9000207@tilera.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LSI MEGARAID SAS HBA suffers from the problem where it can do
64-bit DMA to streaming buffers but not to consistent buffers.
In other words, 64-bit DMA is used for disk data transfers and 32-bit
DMA must be used for control message transfers. According to LSI,
the firmware is not fully functional yet. This change implements a
kind of hybrid dma_ops to support this.

Note that on most other platforms, the 64-bit DMA addressing space is the
same as the 32-bit DMA space and they overlap the physical memory space.
No special arrangement is needed to support this kind of mixed DMA
capability.  On TILE-Gx, the 64-bit DMA space is completely separate
from the 32-bit DMA space.  Due to the use of the IOMMU, the 64-bit DMA
space doesn't overlap the physical memory space.  On the other hand,
the 32-bit DMA space overlaps the physical memory space under 4GB.
The separate address spaces make it necessary to have separate dma_ops.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/dma-mapping.h | 10 +++++++---
 arch/tile/kernel/pci-dma.c          | 40 ++++++++++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index f2ff191..4a60059 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -23,6 +23,7 @@
 extern struct dma_map_ops *tile_dma_map_ops;
 extern struct dma_map_ops *gx_pci_dma_map_ops;
 extern struct dma_map_ops *gx_legacy_pci_dma_map_ops;
+extern struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 
 static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
@@ -44,12 +45,12 @@ static inline void set_dma_offset(struct device *dev, dma_addr_t off)
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
-	return paddr + get_dma_offset(dev);
+	return paddr;
 }
 
 static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
-	return daddr - get_dma_offset(dev);
+	return daddr;
 }
 
 static inline void dma_mark_clean(void *addr, size_t size) {}
@@ -88,7 +89,10 @@ dma_set_mask(struct device *dev, u64 mask)
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	/* Handle legacy PCI devices with limited memory addressability. */
-	if ((dma_ops == gx_pci_dma_map_ops) && (mask <= DMA_BIT_MASK(32))) {
+	if ((dma_ops == gx_pci_dma_map_ops ||
+	     dma_ops == gx_hybrid_pci_dma_map_ops ||
+	     dma_ops == gx_legacy_pci_dma_map_ops) &&
+	    (mask <= DMA_BIT_MASK(32))) {
 		set_dma_ops(dev, gx_legacy_pci_dma_map_ops);
 		set_dma_offset(dev, 0);
 		if (mask > dev->archdata.max_direct_dma_addr)
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index b9fe80e..7e22e73 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -357,7 +357,7 @@ static void *tile_pci_dma_alloc_coherent(struct device *dev, size_t size,
 
 	addr = page_to_phys(pg);
 
-	*dma_handle = phys_to_dma(dev, addr);
+	*dma_handle = addr + get_dma_offset(dev);
 
 	return page_address(pg);
 }
@@ -387,7 +387,7 @@ static int tile_pci_dma_map_sg(struct device *dev, struct scatterlist *sglist,
 		sg->dma_address = sg_phys(sg);
 		__dma_prep_pa_range(sg->dma_address, sg->length, direction);
 
-		sg->dma_address = phys_to_dma(dev, sg->dma_address);
+		sg->dma_address = sg->dma_address + get_dma_offset(dev);
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 		sg->dma_length = sg->length;
 #endif
@@ -422,7 +422,7 @@ static dma_addr_t tile_pci_dma_map_page(struct device *dev, struct page *page,
 	BUG_ON(offset + size > PAGE_SIZE);
 	__dma_prep_page(page, offset, size, direction);
 
-	return phys_to_dma(dev, page_to_pa(page) + offset);
+	return page_to_pa(page) + offset + get_dma_offset(dev);
 }
 
 static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
@@ -432,7 +432,7 @@ static void tile_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_address,
 {
 	BUG_ON(!valid_dma_direction(direction));
 
-	dma_address = dma_to_phys(dev, dma_address);
+	dma_address -= get_dma_offset(dev);
 
 	__dma_complete_page(pfn_to_page(PFN_DOWN(dma_address)),
 			    dma_address & PAGE_OFFSET, size, direction);
@@ -445,7 +445,7 @@ static void tile_pci_dma_sync_single_for_cpu(struct device *dev,
 {
 	BUG_ON(!valid_dma_direction(direction));
 
-	dma_handle = dma_to_phys(dev, dma_handle);
+	dma_handle -= get_dma_offset(dev);
 
 	__dma_complete_pa_range(dma_handle, size, direction);
 }
@@ -456,7 +456,7 @@ static void tile_pci_dma_sync_single_for_device(struct device *dev,
 						enum dma_data_direction
 						direction)
 {
-	dma_handle = dma_to_phys(dev, dma_handle);
+	dma_handle -= get_dma_offset(dev);
 
 	__dma_prep_pa_range(dma_handle, size, direction);
 }
@@ -558,21 +558,43 @@ static struct dma_map_ops pci_swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 };
 
+static struct dma_map_ops pci_hybrid_dma_ops = {
+	.alloc = tile_swiotlb_alloc_coherent,
+	.free = tile_swiotlb_free_coherent,
+	.map_page = tile_pci_dma_map_page,
+	.unmap_page = tile_pci_dma_unmap_page,
+	.map_sg = tile_pci_dma_map_sg,
+	.unmap_sg = tile_pci_dma_unmap_sg,
+	.sync_single_for_cpu = tile_pci_dma_sync_single_for_cpu,
+	.sync_single_for_device = tile_pci_dma_sync_single_for_device,
+	.sync_sg_for_cpu = tile_pci_dma_sync_sg_for_cpu,
+	.sync_sg_for_device = tile_pci_dma_sync_sg_for_device,
+	.mapping_error = tile_pci_dma_mapping_error,
+	.dma_supported = tile_pci_dma_supported
+};
+
 struct dma_map_ops *gx_legacy_pci_dma_map_ops = &pci_swiotlb_dma_ops;
+struct dma_map_ops *gx_hybrid_pci_dma_map_ops = &pci_hybrid_dma_ops;
 #else
 struct dma_map_ops *gx_legacy_pci_dma_map_ops;
+struct dma_map_ops *gx_hybrid_pci_dma_map_ops;
 #endif
 EXPORT_SYMBOL(gx_legacy_pci_dma_map_ops);
+EXPORT_SYMBOL(gx_hybrid_pci_dma_map_ops);
 
 #ifdef CONFIG_ARCH_HAS_DMA_SET_COHERENT_MASK
 int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
-	/* Handle legacy PCI devices with limited memory addressability. */
-	if (((dma_ops == gx_pci_dma_map_ops) ||
-	    (dma_ops == gx_legacy_pci_dma_map_ops)) &&
+	/* Handle hybrid PCI devices with limited memory addressability. */
+	if ((dma_ops == gx_pci_dma_map_ops ||
+	     dma_ops == gx_hybrid_pci_dma_map_ops ||
+	     dma_ops == gx_legacy_pci_dma_map_ops) &&
 	    (mask <= DMA_BIT_MASK(32))) {
+		if (dma_ops == gx_pci_dma_map_ops)
+			set_dma_ops(dev, gx_hybrid_pci_dma_map_ops);
+
 		if (mask > dev->archdata.max_direct_dma_addr)
 			mask = dev->archdata.max_direct_dma_addr;
 	}
-- 
1.8.3.1

