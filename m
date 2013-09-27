Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3I0Qf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:35:29 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6236 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab3I0Qf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:35:27 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="58130946"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 11/19] swiotlb-xen: use xen_alloc/free_coherent_pages
Date: Fri, 27 Sep 2013 17:09:59 +0100
Message-ID: <1380298207-29151-11-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use xen_alloc_coherent_pages and xen_free_coherent_pages to allocate or
free coherent pages.

We need to be careful handling the pointer returned by
xen_alloc_coherent_pages, because on ARM the pointer is not equal to
phys_to_virt(*dma_handle). In fact virt_to_phys only works for kernel
direct mapped RAM memory.
In ARM case the pointer could be an ioremap address, therefore passing
it to virt_to_phys would give you another physical address that doesn't
correspond to it.

Make xen_create_contiguous_region take a phys_addr_t as start parameter to
avoid the virt_to_phys calls which would be incorrect.

Changes in v6:
- remove extra spaces.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/mm.c         |    7 +++----
 arch/x86/xen/mmu.c        |    7 +++++--
 drivers/xen/swiotlb-xen.c |   31 +++++++++++++++++++++----------
 include/xen/xen-ops.h     |    4 ++--
 4 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index 4330b15..b305b94 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -55,11 +55,10 @@ static int xen_exchange_memory(xen_ulong_t extents_in,
 	return success;
 }
 
-int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
 {
-	phys_addr_t pstart = __pa(vstart);
 	xen_pfn_t in_frame, out_frame;
 	int success;
 
@@ -78,9 +77,9 @@ int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
 }
 EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
 
-void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
+void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order)
 {
-	xen_pfn_t in_frame = __pa(vstart) >> PAGE_SHIFT;
+	xen_pfn_t in_frame = pstart >> PAGE_SHIFT;
 	struct xen_unpin unpin = {
 		.in = {
 			.nr_extents   = 1,
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6c34d7c..8830883 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2328,13 +2328,14 @@ static int xen_exchange_memory(unsigned long extents_in, unsigned int order_in,
 	return success;
 }
 
-int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
 {
 	unsigned long *in_frames = discontig_frames, out_frame;
 	unsigned long  flags;
 	int            success;
+	unsigned long vstart = (unsigned long)phys_to_virt(pstart);
 
 	/*
 	 * Currently an auto-translated guest will not perform I/O, nor will
@@ -2374,11 +2375,12 @@ int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
 }
 EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
 
-void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
+void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order)
 {
 	unsigned long *out_frames = discontig_frames, in_frame;
 	unsigned long  flags;
 	int success;
+	unsigned long vstart;
 
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return;
@@ -2386,6 +2388,7 @@ void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
 	if (unlikely(order > MAX_CONTIG_ORDER))
 		return;
 
+	vstart = (unsigned long)phys_to_virt(pstart);
 	memset((void *) vstart, 0, PAGE_SIZE << order);
 
 	spin_lock_irqsave(&xen_reservation_lock, flags);
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index deb9131..96ad316 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -46,6 +46,7 @@
 #include <xen/hvc-console.h>
 #include <xen/features.h>
 #include <asm/dma-mapping.h>
+#include <asm/xen/page-coherent.h>
 
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
@@ -244,6 +245,7 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
 	int i, j, rc;
 	int dma_bits;
+	phys_addr_t p = virt_to_phys(buf);
 
 	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
 
@@ -253,7 +255,7 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 
 		do {
 			rc = xen_create_contiguous_region(
-				(unsigned long)buf + (i << IO_TLB_SHIFT),
+				p + (i << IO_TLB_SHIFT),
 				get_order(slabs << IO_TLB_SHIFT),
 				dma_bits, &xen_dma_seg[j].dma_addr);
 		} while (rc && dma_bits++ < max_dma_bits);
@@ -389,7 +391,6 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	void *ret;
 	int order = get_order(size);
 	u64 dma_mask = DMA_BIT_MASK(32);
-	unsigned long vstart;
 	phys_addr_t phys;
 	dma_addr_t dev_addr;
 	struct xen_dma_info *dma_info = NULL;
@@ -405,8 +406,12 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	if (dma_alloc_from_coherent(hwdev, size, dma_handle, &ret))
 		return ret;
 
-	vstart = __get_free_pages(flags, order);
-	ret = (void *)vstart;
+	/* On ARM this function returns an ioremap'ped virtual address for
+	 * which virt_to_phys doesn't return the corresponding physical
+	 * address. In fact on ARM virt_to_phys only works for kernel direct
+	 * mapped RAM memory. Also see comment below.
+	 */
+	ret = xen_alloc_coherent_pages(hwdev, size, dma_handle, flags, attrs);
 
 	if (!ret)
 		return ret;
@@ -414,16 +419,20 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	if (hwdev && hwdev->coherent_dma_mask)
 		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
 
-	phys = virt_to_phys(ret);
+	/* At this point dma_handle is the physical address, next we are
+	 * going to set it to the machine address.
+	 * Do not use virt_to_phys(ret) because on ARM it doesn't correspond
+	 * to *dma_handle. */
+	phys = *dma_handle;
 	dev_addr = xen_phys_to_bus(phys);
 	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
 	    ((dev_addr + size - 1 <= dma_mask)) &&
 	    !range_straddles_page_boundary(phys, size))
 		*dma_handle = dev_addr;
 	else {
-		if (xen_create_contiguous_region(vstart, order,
+		if (xen_create_contiguous_region(phys, order,
 						 fls64(dma_mask), dma_handle) != 0) {
-			free_pages(vstart, order);
+			xen_free_coherent_pages(hwdev, size, ret, (dma_addr_t)phys, attrs);
 			return NULL;
 		}
 
@@ -463,18 +472,20 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 	if (hwdev && hwdev->coherent_dma_mask)
 		dma_mask = hwdev->coherent_dma_mask;
 
-	phys = virt_to_phys(vaddr);
+	/* do not use virt_to_phys because on ARM it doesn't return you the
+	 * physical address */
+	phys = xen_bus_to_phys(dev_addr);
 
 	if (xen_feature(XENFEAT_auto_translated_physmap) ||
 		(((dev_addr + size - 1 > dma_mask)) ||
 		 range_straddles_page_boundary(phys, size))) {
-		xen_destroy_contiguous_region((unsigned long)vaddr, order);
+		xen_destroy_contiguous_region(phys, order);
 		dma_info = xen_get_dma_info_from_dma(dev_addr);
 		rb_erase(&dma_info->rbnode, &bus_to_phys);
 		kfree(dma_info);
 	}
 
-	free_pages((unsigned long)vaddr, order);
+	xen_free_coherent_pages(hwdev, size, vaddr, (dma_addr_t)phys, attrs);
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_free_coherent);
 
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 9ef704d..fb2ea8f 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -19,11 +19,11 @@ void xen_arch_resume(void);
 int xen_setup_shutdown_event(void);
 
 extern unsigned long *xen_contiguous_bitmap;
-int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				unsigned int address_bits,
 				dma_addr_t *dma_handle);
 
-void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
+void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order);
 
 struct vm_area_struct;
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
-- 
1.7.2.5

