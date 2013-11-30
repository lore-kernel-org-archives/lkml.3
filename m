Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3K3Wln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51857 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3K3Wkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 10/12] PCI: Try best to allocate pref mmio 64bit above 4g
Date: Sat, 30 Nov 2013 14:40:36 -0800
Message-Id: <1385851238-21085-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When one of children resources does not support MEM_64, MEM_64 for
bridge get reset, so pull down whole pref resource on the bridge under 4G.

If the bridge support pref mem 64, will only allocate that with pref mem64 to
children that support it.
For children resources if they only support pref mem 32, will allocate them
from non pref mem instead.

If the bridge only support 32bit pref mmio, will still have all children pref
mmio under that.

-v2: Add release bridge res support with bridge mem res for pref_mem children res.
-v3: refresh and make it can be applied early before for_each_dev_res patchset.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/pci/setup-bus.c | 133 ++++++++++++++++++++++++++++++++----------------
 drivers/pci/setup-res.c |  14 ++++-
 2 files changed, 101 insertions(+), 46 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index f9e6efb..6f38e66 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -711,12 +711,11 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
    bus resource of a given type. Note: we intentionally skip
    the bus resources which have already been assigned (that is,
    have non-NULL parent resource). */
-static struct resource *find_free_bus_resource(struct pci_bus *bus, unsigned long type)
+static struct resource *find_free_bus_resource(struct pci_bus *bus,
+			 unsigned long type_mask, unsigned long type)
 {
 	int i;
 	struct resource *r;
-	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
-				  IORESOURCE_PREFETCH;
 
 	pci_bus_for_each_resource(bus, r, i) {
 		if (r == &ioport_resource || r == &iomem_resource)
@@ -813,7 +812,8 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 		resource_size_t add_size, struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
-	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
+	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO,
+							IORESOURCE_IO);
 	resource_size_t size = 0, size0 = 0, size1 = 0;
 	resource_size_t children_add_size = 0;
 	resource_size_t min_align, align;
@@ -913,15 +913,16 @@ static inline resource_size_t calculate_mem_align(resource_size_t *aligns,
  * guarantees that all child resources fit in this size.
  */
 static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
-			 unsigned long type, resource_size_t min_size,
-			resource_size_t add_size,
-			struct list_head *realloc_head)
+			 unsigned long type, unsigned long type2,
+			 resource_size_t min_size, resource_size_t add_size,
+			 struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size, size0, size1;
 	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
 	int order, max_order;
-	struct resource *b_res = find_free_bus_resource(bus, type);
+	struct resource *b_res = find_free_bus_resource(bus,
+					 mask | IORESOURCE_PREFETCH, type);
 	unsigned int mem64_mask = 0;
 	resource_size_t children_add_size = 0;
 
@@ -942,7 +943,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			struct resource *r = &dev->resource[i];
 			resource_size_t r_size;
 
-			if (r->parent || (r->flags & mask) != type)
+			if (r->parent || ((r->flags & mask) != type &&
+					  (r->flags & mask) != type2))
 				continue;
 			r_size = resource_size(r);
 #ifdef CONFIG_PCI_IOV
@@ -1115,8 +1117,9 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 			struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
-	unsigned long mask, prefmask;
+	unsigned long mask, prefmask, type2 = 0;
 	resource_size_t additional_mem_size = 0, additional_io_size = 0;
+	struct resource *b_res;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		struct pci_bus *b = dev->subordinate;
@@ -1161,15 +1164,31 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 		   has already been allocated by arch code, try
 		   non-prefetchable range for both types of PCI memory
 		   resources. */
+		b_res = &bus->self->resource[PCI_BRIDGE_RESOURCES];
 		mask = IORESOURCE_MEM;
 		prefmask = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-		if (pbus_size_mem(bus, prefmask, prefmask,
+		if (b_res[2].flags & IORESOURCE_MEM_64) {
+			prefmask |= IORESOURCE_MEM_64;
+			if (pbus_size_mem(bus, prefmask, prefmask, prefmask,
 				  realloc_head ? 0 : additional_mem_size,
-				  additional_mem_size, realloc_head))
-			mask = prefmask; /* Success, size non-prefetch only. */
-		else
-			additional_mem_size += additional_mem_size;
-		pbus_size_mem(bus, mask, IORESOURCE_MEM,
+				  additional_mem_size, realloc_head)) {
+					/* Success, size non-pref64 only. */
+					mask = prefmask;
+					type2 = prefmask & ~IORESOURCE_MEM_64;
+			}
+		}
+		if (!type2) {
+			prefmask &= ~IORESOURCE_MEM_64;
+			if (pbus_size_mem(bus, prefmask, prefmask, prefmask,
+					 realloc_head ? 0 : additional_mem_size,
+					 additional_mem_size, realloc_head)) {
+				/* Success, size non-prefetch only. */
+				mask = prefmask;
+			} else
+				additional_mem_size += additional_mem_size;
+			type2 = IORESOURCE_MEM;
+		}
+		pbus_size_mem(bus, mask, IORESOURCE_MEM, type2,
 				realloc_head ? 0 : additional_mem_size,
 				additional_mem_size, realloc_head);
 		break;
@@ -1255,42 +1274,66 @@ static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
 static void pci_bridge_release_resources(struct pci_bus *bus,
 					  unsigned long type)
 {
-	int idx;
-	bool changed = false;
-	struct pci_dev *dev;
+	struct pci_dev *dev = bus->self;
 	struct resource *r;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
-				  IORESOURCE_PREFETCH;
+				  IORESOURCE_PREFETCH | IORESOURCE_MEM_64;
+	unsigned old_flags = 0;
+	struct resource *b_res;
+	int idx = 1;
 
-	dev = bus->self;
-	for (idx = PCI_BRIDGE_RESOURCES; idx <= PCI_BRIDGE_RESOURCE_END;
-	     idx++) {
-		r = &dev->resource[idx];
-		if ((r->flags & type_mask) != type)
-			continue;
-		if (!r->parent)
-			continue;
-		/*
-		 * if there are children under that, we should release them
-		 *  all
-		 */
-		release_child_resources(r);
-		if (!release_resource(r)) {
-			dev_printk(KERN_DEBUG, &dev->dev,
-				 "resource %d %pR released\n", idx, r);
-			/* keep the old size */
-			r->end = resource_size(r) - 1;
-			r->start = 0;
-			r->flags = 0;
-			changed = true;
-		}
-	}
+	b_res = &dev->resource[PCI_BRIDGE_RESOURCES];
+
+	/*
+	 *     1. if there is io port assign fail, will release bridge
+	 *	  io port.
+	 *     2. if there is non pref mmio assign fail, release bridge
+	 *	  nonpref mmio.
+	 *     3. if there is 64bit pref mmio assign fail, and bridge pref
+	 *	  is 64bit, release bridge pref mmio.
+	 *     4. if there is pref mmio assign fail, and bridge pref is
+	 *	  32bit mmio, release bridge pref mmio
+	 *     5. if there is pref mmio assign fail, and bridge pref is not
+	 *	  assigned, release bridge nonpref mmio.
+	 */
+	if (type & IORESOURCE_IO)
+		idx = 0;
+	else if (!(type & IORESOURCE_PREFETCH))
+		idx = 1;
+	else if ((type & IORESOURCE_MEM_64) &&
+		 (b_res[2].flags & IORESOURCE_MEM_64))
+		idx = 2;
+	else if (!(b_res[2].flags & IORESOURCE_MEM_64) &&
+		 (b_res[2].flags & IORESOURCE_PREFETCH))
+		idx = 2;
+	else
+		idx = 1;
+
+	r = &b_res[idx];
+
+	if (!r->parent)
+		return;
+
+	/*
+	 * if there are children under that, we should release them
+	 *  all
+	 */
+	release_child_resources(r);
+	if (!release_resource(r)) {
+		type = old_flags = r->flags & type_mask;
+		dev_printk(KERN_DEBUG, &dev->dev, "resource %d %pR released\n",
+					PCI_BRIDGE_RESOURCES + idx, r);
+		/* keep the old size */
+		r->end = resource_size(r) - 1;
+		r->start = 0;
+		r->flags = 0;
 
-	if (changed) {
 		/* avoiding touch the one without PREF */
 		if (type & IORESOURCE_PREFETCH)
 			type = IORESOURCE_PREFETCH;
 		__pci_setup_bridge(bus, type);
+		/* for next child res under same bridge */
+		r->flags = old_flags;
 	}
 }
 
@@ -1491,7 +1534,7 @@ void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 	LIST_HEAD(fail_head);
 	struct pci_dev_resource *fail_res;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
-				  IORESOURCE_PREFETCH;
+				  IORESOURCE_PREFETCH | IORESOURCE_MEM_64;
 	int pci_try_num = 1;
 	enum enable_type enable_local;
 
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 83c4d3b..e968412 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -208,9 +208,21 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 
 	/* First, try exact prefetching match.. */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
-				     IORESOURCE_PREFETCH,
+				     IORESOURCE_PREFETCH | IORESOURCE_MEM_64,
 				     pcibios_align_resource, dev);
 
+	if (ret < 0 &&
+	    (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64))) {
+		/*
+		 * That failed.
+		 *
+		 * Try below 4g pref
+		 */
+		ret = pci_bus_alloc_resource(bus, res, size, align, min,
+					     IORESOURCE_PREFETCH,
+					     pcibios_align_resource, dev);
+	}
+
 	if (ret < 0 && (res->flags & IORESOURCE_PREFETCH)) {
 		/*
 		 * That failed.
-- 
1.8.1.4

