Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818Ab3GaTyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:54:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:46045 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763Ab3GaTyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:54:32 -0400
X-IronPort-AV: E=Sophos;i="4.89,789,1367971200"; 
   d="scan'208";a="40581751"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <david.vrabel@citrix.com>
Subject: [PATCH v2 RFC 7/8] swiotlb-xen: support autotranslate guests
Date: Wed, 31 Jul 2013 20:54:11 +0100
Message-ID: <1375300452-12545-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support autotranslate guests in swiotlb-xen by keeping track of the
phys-to-bus and bus-to-phys mappings of the swiotlb buffer
(xen_io_tlb_start-xen_io_tlb_end).

Use a simple direct access on a pre-allocated array for phys-to-bus
queries. Use a red-black tree for bus-to-phys queries.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: david.vrabel@citrix.com
---
 drivers/xen/swiotlb-xen.c |  127 +++++++++++++++++++++++++++++++++++++++------
 1 files changed, 111 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 353f013..3fadb6b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -38,32 +38,116 @@
 #include <linux/bootmem.h>
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/spinlock_types.h>
+#include <linux/rbtree.h>
 #include <xen/swiotlb-xen.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
 #include <xen/hvc-console.h>
+#include <xen/features.h>
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 
+#define NR_DMA_SEGS  ((xen_io_tlb_nslabs + IO_TLB_SEGSIZE - 1) / IO_TLB_SEGSIZE)
 static char *xen_io_tlb_start, *xen_io_tlb_end;
 static unsigned long xen_io_tlb_nslabs;
 /*
  * Quick lookup value of the bus address of the IOTLB.
  */
 
-static u64 start_dma_addr;
+struct xen_dma{
+	dma_addr_t dma_addr;
+	phys_addr_t phys_addr;
+	size_t size;
+	struct rb_node rbnode;
+};
+
+static struct xen_dma *xen_dma_seg;
+static struct rb_root bus_to_phys = RB_ROOT;
+static DEFINE_SPINLOCK(xen_dma_lock);
+
+static void xen_dma_insert(struct xen_dma *entry)
+{
+	struct rb_node **link = &bus_to_phys.rb_node;
+	struct rb_node *parent = NULL;
+	struct xen_dma *e;
+
+	spin_lock(&xen_dma_lock);
+
+	while (*link) {
+		parent = *link;
+		e = rb_entry(parent, struct xen_dma, rbnode);
+
+		WARN_ON(entry->dma_addr == e->dma_addr);
+
+		if (entry->dma_addr < e->dma_addr)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+	rb_link_node(&entry->rbnode, parent, link);
+	rb_insert_color(&entry->rbnode, &bus_to_phys);
+
+	spin_unlock(&xen_dma_lock);
+}
+
+static struct xen_dma *xen_dma_retrieve(dma_addr_t dma_addr)
+{
+	struct rb_node *n = bus_to_phys.rb_node;
+	struct xen_dma *e;
+	
+	spin_lock(&xen_dma_lock);
+
+	while (n) {
+		e = rb_entry(n, struct xen_dma, rbnode);
+		if (e->dma_addr <= dma_addr && e->dma_addr + e->size > dma_addr) {
+			spin_unlock(&xen_dma_lock);
+			return e;
+		}
+		if (dma_addr < e->dma_addr)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+
+	spin_unlock(&xen_dma_lock);
+	return NULL;
+}
 
 static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
-	return phys_to_machine(XPADDR(paddr)).maddr;
+	int nr_seg;
+	unsigned long offset;
+	char* vaddr;
+
+	if (!xen_feature(XENFEAT_auto_translated_physmap))
+		return phys_to_machine(XPADDR(paddr)).maddr;
+
+	vaddr = (char *) phys_to_virt(paddr);
+	if (vaddr >= xen_io_tlb_end || vaddr < xen_io_tlb_start)
+		return ~0;
+
+	offset = vaddr - xen_io_tlb_start;
+	nr_seg = offset / (IO_TLB_SEGSIZE << IO_TLB_SHIFT);
+
+	return xen_dma_seg[nr_seg].dma_addr + (paddr - xen_dma_seg[nr_seg].phys_addr);
 }
 
 static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
 {
-	return machine_to_phys(XMADDR(baddr)).paddr;
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+	{
+		struct xen_dma *dma = xen_dma_retrieve(baddr);
+		if (dma == NULL)
+			return ~0;
+		else
+			return dma->phys_addr + (baddr - dma->dma_addr);
+	} else
+		return machine_to_phys(XMADDR(baddr)).paddr;
 }
 
 static dma_addr_t xen_virt_to_bus(void *address)
@@ -107,6 +191,9 @@ static int is_xen_swiotlb_buffer(dma_addr_t dma_addr)
 	unsigned long pfn = mfn_to_local_pfn(mfn);
 	phys_addr_t paddr;
 
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 1;
+
 	/* If the address is outside our domain, it CAN
 	 * have the same virtual address as another address
 	 * in our domain. Therefore _only_ check address within our domain.
@@ -124,13 +211,12 @@ static int max_dma_bits = 32;
 static int
 xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 {
-	int i, rc;
+	int i, j, rc;
 	int dma_bits;
-	dma_addr_t dma_handle;
 
 	dma_bits = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT) + PAGE_SHIFT;
 
-	i = 0;
+	i = j = 0;
 	do {
 		int slabs = min(nslabs - i, (unsigned long)IO_TLB_SEGSIZE);
 
@@ -138,12 +224,16 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 			rc = xen_create_contiguous_region(
 				(unsigned long)buf + (i << IO_TLB_SHIFT),
 				get_order(slabs << IO_TLB_SHIFT),
-				dma_bits, &dma_handle);
+				dma_bits, &xen_dma_seg[j].dma_addr);
 		} while (rc && dma_bits++ < max_dma_bits);
 		if (rc)
 			return rc;
 
+		xen_dma_seg[j].phys_addr = virt_to_phys(buf + (i << IO_TLB_SHIFT));
+		xen_dma_seg[j].size = slabs << IO_TLB_SHIFT;
+		xen_dma_insert(&xen_dma_seg[j]);
 		i += slabs;
+		j++;
 	} while (i < nslabs);
 	return 0;
 }
@@ -193,9 +283,10 @@ retry:
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-	if (early)
+	if (early) {
 		xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
-	else {
+		xen_dma_seg = alloc_bootmem(sizeof(struct xen_dma) * NR_DMA_SEGS);
+	} else {
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 		while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -210,6 +301,7 @@ retry:
 			xen_io_tlb_nslabs = SLABS_PER_PAGE << order;
 			bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
 		}
+		xen_dma_seg = kzalloc(sizeof(struct xen_dma) * NR_DMA_SEGS, GFP_KERNEL);
 	}
 	if (!xen_io_tlb_start) {
 		m_ret = XEN_SWIOTLB_ENOMEM;
@@ -232,7 +324,6 @@ retry:
 		m_ret = XEN_SWIOTLB_EFIXUP;
 		goto error;
 	}
-	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
 	if (early) {
 		if (swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs,
 			 verbose))
@@ -290,7 +381,8 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 
 	phys = virt_to_phys(ret);
 	dev_addr = xen_phys_to_bus(phys);
-	if (((dev_addr + size - 1 <= dma_mask)) &&
+	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
+	    ((dev_addr + size - 1 <= dma_mask)) &&
 	    !range_straddles_page_boundary(phys, size))
 		*dma_handle = dev_addr;
 	else {
@@ -321,8 +413,9 @@ xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 
 	phys = virt_to_phys(vaddr);
 
-	if (((dev_addr + size - 1 > dma_mask)) ||
-	    range_straddles_page_boundary(phys, size))
+	if (xen_feature(XENFEAT_auto_translated_physmap) ||
+		(((dev_addr + size - 1 > dma_mask)) ||
+		 range_straddles_page_boundary(phys, size)))
 		xen_destroy_contiguous_region((unsigned long)vaddr, order);
 
 	free_pages((unsigned long)vaddr, order);
@@ -351,14 +444,15 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (dma_capable(dev, dev_addr, size) &&
+	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
+	    dma_capable(dev, dev_addr, size) &&
 	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
 		return dev_addr;
 
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
+	map = swiotlb_tbl_map_single(dev, xen_dma_seg[0].dma_addr, phys, size, dir);
 	if (map == SWIOTLB_MAP_ERROR)
 		return DMA_ERROR_CODE;
 
@@ -494,10 +588,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
 
 		if (swiotlb_force ||
+		    xen_feature(XENFEAT_auto_translated_physmap) ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
 		    range_straddles_page_boundary(paddr, sg->length)) {
 			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
-								 start_dma_addr,
+								 xen_dma_seg[0].dma_addr,
 								 sg_phys(sg),
 								 sg->length,
 								 dir);
-- 
1.7.2.5

