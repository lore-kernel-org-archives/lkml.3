Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3I0QgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:36:22 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13935 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab3I0QgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="58131166"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 18/19] swiotlb-xen: introduce a rbtree to track phys to bus mappings
Date: Fri, 27 Sep 2013 17:10:06 +0100
Message-ID: <1380298207-29151-18-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a second red-back tree to track phys to bus mappings created after
the initialization of the swiotlb buffer.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/swiotlb-xen.c |   99 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 83 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 3011736..022bcaf 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -79,7 +79,8 @@ struct xen_dma_info {
 	dma_addr_t dma_addr;
 	phys_addr_t phys_addr;
 	size_t size;
-	struct rb_node rbnode;
+	struct rb_node rbnode_dma;
+	struct rb_node rbnode_phys;
 };
 
 /*
@@ -96,8 +97,13 @@ static struct xen_dma_info *xen_dma_seg;
  * mappings.
  */
 static struct rb_root bus_to_phys = RB_ROOT;
+/*
+ * This tree keeps track of physical address to bus address
+ * mappings apart from the ones belonging to the initial swiotlb buffer.
+ */
+static struct rb_root phys_to_bus = RB_ROOT;
 
-static int xen_dma_add_entry(struct xen_dma_info *new)
+static int xen_dma_add_entry_bus(struct xen_dma_info *new)
 {
 	struct rb_node **link = &bus_to_phys.rb_node;
 	struct rb_node *parent = NULL;
@@ -106,7 +112,7 @@ static int xen_dma_add_entry(struct xen_dma_info *new)
 
 	while (*link) {
 		parent = *link;
-		entry = rb_entry(parent, struct xen_dma_info, rbnode);
+		entry = rb_entry(parent, struct xen_dma_info, rbnode_dma);
 
 		if (new->dma_addr == entry->dma_addr)
 			goto err_out;
@@ -118,8 +124,41 @@ static int xen_dma_add_entry(struct xen_dma_info *new)
 		else
 			link = &(*link)->rb_right;
 	}
-	rb_link_node(&new->rbnode, parent, link);
-	rb_insert_color(&new->rbnode, &bus_to_phys);
+	rb_link_node(&new->rbnode_dma, parent, link);
+	rb_insert_color(&new->rbnode_dma, &bus_to_phys);
+	goto out;
+
+err_out:
+	rc = -EINVAL;
+	pr_warn("%s: cannot add phys=%pa -> dma=%pa: phys=%pa -> dma=%pa already exists\n",
+			__func__, &new->phys_addr, &new->dma_addr, &entry->phys_addr, &entry->dma_addr);
+out:
+	return rc;
+}
+
+static int xen_dma_add_entry_phys(struct xen_dma_info *new)
+{
+	struct rb_node **link = &phys_to_bus.rb_node;
+	struct rb_node *parent = NULL;
+	struct xen_dma_info *entry;
+	int rc = 0;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct xen_dma_info, rbnode_phys);
+
+		if (new->dma_addr == entry->dma_addr)
+			goto err_out;
+		if (new->phys_addr == entry->phys_addr)
+			goto err_out;
+
+		if (new->phys_addr < entry->phys_addr)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+	rb_link_node(&new->rbnode_phys, parent, link);
+	rb_insert_color(&new->rbnode_phys, &phys_to_bus);
 	goto out;
 
 err_out:
@@ -130,13 +169,22 @@ out:
 	return rc;
 }
 
+static int xen_dma_add_entry(struct xen_dma_info *new)
+{
+	int rc;
+	if ((rc = xen_dma_add_entry_bus(new) < 0) ||
+		(rc = xen_dma_add_entry_phys(new) < 0))
+		return rc;
+	return 0;
+}
+
 static struct xen_dma_info *xen_get_dma_info_from_dma(dma_addr_t dma_addr)
 {
 	struct rb_node *n = bus_to_phys.rb_node;
 	struct xen_dma_info *entry;
 
 	while (n) {
-		entry = rb_entry(n, struct xen_dma_info, rbnode);
+		entry = rb_entry(n, struct xen_dma_info, rbnode_dma);
 		if (entry->dma_addr <= dma_addr &&
 				entry->dma_addr + entry->size > dma_addr) {
 			return entry;
@@ -150,11 +198,30 @@ static struct xen_dma_info *xen_get_dma_info_from_dma(dma_addr_t dma_addr)
 	return NULL;
 }
 
-static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
+static struct xen_dma_info *xen_get_dma_info_from_phys(phys_addr_t phys)
 {
-	int nr_seg;
-	unsigned long offset;
-	char *vaddr;
+	struct rb_node *n = phys_to_bus.rb_node;
+	struct xen_dma_info *entry;
+
+	while (n) {
+		entry = rb_entry(n, struct xen_dma_info, rbnode_phys);
+		if (entry->phys_addr <= phys &&
+				entry->phys_addr + entry->size > phys) {
+			return entry;
+		}
+		if (phys < entry->phys_addr)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+
+	return NULL;
+}
+
+/* Only looks into the initial buffer allocation in case of
+ * XENFEAT_auto_translated_physmap guests. */
+static dma_addr_t xen_phys_to_bus_quick(phys_addr_t paddr) { int nr_seg;
+	unsigned long offset; char *vaddr;
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
 		return phys_to_machine(XPADDR(paddr)).maddr;
@@ -184,7 +251,7 @@ static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
 
 static dma_addr_t xen_virt_to_bus(void *address)
 {
-	return xen_phys_to_bus(virt_to_phys(address));
+	return xen_phys_to_bus_quick(virt_to_phys(address));
 }
 
 static int check_pages_physically_contiguous(unsigned long pfn,
@@ -424,7 +491,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	 * Do not use virt_to_phys(ret) because on ARM it doesn't correspond
 	 * to *dma_handle. */
 	phys = *dma_handle;
-	dev_addr = xen_phys_to_bus(phys);
+	dev_addr = xen_phys_to_bus_quick(phys);
 	if (!xen_feature(XENFEAT_auto_translated_physmap) &&
 	    ((dev_addr + size - 1 <= dma_mask)) &&
 	    !range_straddles_page_boundary(phys, size))
@@ -503,7 +570,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				struct dma_attrs *attrs)
 {
 	phys_addr_t map, phys = page_to_phys(page) + offset;
-	dma_addr_t dev_addr = xen_phys_to_bus(phys);
+	dma_addr_t dev_addr = xen_phys_to_bus_quick(phys);
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -527,7 +594,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	if (map == SWIOTLB_MAP_ERROR)
 		return DMA_ERROR_CODE;
 
-	dev_addr = xen_phys_to_bus(map);
+	dev_addr = xen_phys_to_bus_quick(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -656,7 +723,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
+		dma_addr_t dev_addr = xen_phys_to_bus_quick(paddr);
 
 		if (swiotlb_force ||
 		    xen_feature(XENFEAT_auto_translated_physmap) ||
@@ -682,7 +749,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				sg_dma_len(sgl) = 0;
 				return DMA_ERROR_CODE;
 			}
-			sg->dma_address = xen_phys_to_bus(map);
+			sg->dma_address = xen_phys_to_bus_quick(map);
 		} else
 			sg->dma_address = dev_addr;
 		sg_dma_len(sg) = sg->length;
-- 
1.7.2.5

