Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbaAGA46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:58 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63013 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942AbaAGA4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:53 -0500
Subject: [PATCH v7 14/15] PCI: Enforce bus address limits in resource
 allocation
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:51 -0700
Message-ID: <20140107005651.10786.28216.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

When allocating space for 32-bit BARs, we previously limited RESOURCE
addresses so they would fit in 32 bits.  However, the BUS address need not
be the same as the resource address, and it's the bus address that must fit
in the 32-bit BAR.

This patch adds:

  - pci_clip_resource_to_region(), which clips a resource so it contains
    only the range that maps to the specified bus address region, e.g., to
    clip a resource to 32-bit bus addresses, and

  - pci_bus_alloc_from_region(), which allocates space for a resource from
    the specified bus address region,

and changes pci_bus_alloc_resource() to allocate space for 64-bit BARs from
the entire bus address region, and space for 32-bit BARs from only the bus
address region below 4GB.

If we had this window:

  pci_root HWP0002:0a: host bridge window [mem 0xf0180000000-0xf01fedfffff] (bus address [0x80000000-0xfedfffff])

we previously could not put a 32-bit BAR there, because the CPU addresses
don't fit in 32 bits.  This patch fixes this, so we can use this space for
32-bit BARs.

It's also possible (though unlikely) to have resources with 32-bit CPU
addresses but bus addresses above 4GB.  In this case the previous code
would allocate space that a 32-bit BAR could not map.

Remove PCIBIOS_MAX_MEM_32, which is no longer used.

[bhelgaas: reworked starting from http://lkml.kernel.org/r/1386658484-15774-3-git-send-email-yinghai@kernel.org]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/include/asm/pci.h |    1 
 drivers/pci/bus.c          |  107 ++++++++++++++++++++++++++++++++------------
 include/linux/pci.h        |    4 --
 3 files changed, 79 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 947b5c417e83..122c299e90c8 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -125,7 +125,6 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 /* generic pci stuff */
 #include <asm-generic/pci.h>
-#define PCIBIOS_MAX_MEM_32 0xffffffff
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 6f2f47a7b6c6..58beaaba50ee 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -98,41 +98,50 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 	}
 }
 
-/**
- * pci_bus_alloc_resource - allocate a resource from a parent bus
- * @bus: PCI bus
- * @res: resource to allocate
- * @size: size of resource to allocate
- * @align: alignment of resource to allocate
- * @min: minimum /proc/iomem address to allocate
- * @type_mask: IORESOURCE_* type flags
- * @alignf: resource alignment function
- * @alignf_data: data argument for resource alignment function
- *
- * Given the PCI bus a device resides on, the size, minimum address,
- * alignment and type, try to find an acceptable resource allocation
- * for a specific device resource.
+static struct pci_bus_region pci_32_bit = {0, 0xffffffffULL};
+static struct pci_bus_region pci_64_bit = {0,
+				(resource_size_t) 0xffffffffffffffffULL};
+
+/*
+ * @res contains CPU addresses.  Clip it so the corresponding bus addresses
+ * on @bus are entirely within @region.  This is used to control the bus
+ * addresses of resources we allocate, e.g., we may need a resource that
+ * can be mapped by a 32-bit BAR.
  */
-int
-pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
+static void pci_clip_resource_to_region(struct pci_bus *bus,
+					struct resource *res,
+					struct pci_bus_region *region)
+{
+	struct pci_bus_region r;
+
+	pcibios_resource_to_bus(bus, &r, res);
+	if (r.start < region->start)
+		r.start = region->start;
+	if (r.end > region->end)
+		r.end = region->end;
+
+	if (r.end < r.start)
+		res->end = res->start - 1;
+	else
+		pcibios_bus_to_resource(bus, res, &r);
+}
+
+static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 		resource_size_t size, resource_size_t align,
 		resource_size_t min, unsigned int type_mask,
 		resource_size_t (*alignf)(void *,
 					  const struct resource *,
 					  resource_size_t,
 					  resource_size_t),
-		void *alignf_data)
+		void *alignf_data,
+		struct pci_bus_region *region)
 {
-	int i, ret = -ENOMEM;
-	struct resource *r;
-	resource_size_t max = -1;
+	int i, ret;
+	struct resource *r, avail;
+	resource_size_t max;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
-	/* don't allocate too high if the pref mem doesn't support 64bit*/
-	if (!(res->flags & IORESOURCE_MEM_64))
-		max = PCIBIOS_MAX_MEM_32;
-
 	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
@@ -147,22 +156,64 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		    !(res->flags & IORESOURCE_PREFETCH))
 			continue;
 
+		avail = *r;
+		pci_clip_resource_to_region(bus, &avail, region);
+		if (!resource_size(&avail))
+			continue;
+
 		/*
 		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to
 		 * protect badly documented motherboard resources, but if
 		 * this is an already-configured bridge window, its start
 		 * overrides "min".
 		 */
-		if (r->start)
-			min = r->start;
+		if (avail.start)
+			min = avail.start;
+
+		max = avail.end;
 
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size, min, max,
 					align, alignf, alignf_data);
 		if (ret == 0)
-			break;
+			return 0;
 	}
-	return ret;
+	return -ENOMEM;
+}
+
+/**
+ * pci_bus_alloc_resource - allocate a resource from a parent bus
+ * @bus: PCI bus
+ * @res: resource to allocate
+ * @size: size of resource to allocate
+ * @align: alignment of resource to allocate
+ * @min: minimum /proc/iomem address to allocate
+ * @type_mask: IORESOURCE_* type flags
+ * @alignf: resource alignment function
+ * @alignf_data: data argument for resource alignment function
+ *
+ * Given the PCI bus a device resides on, the size, minimum address,
+ * alignment and type, try to find an acceptable resource allocation
+ * for a specific device resource.
+ */
+int
+pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
+		resource_size_t size, resource_size_t align,
+		resource_size_t min, unsigned int type_mask,
+		resource_size_t (*alignf)(void *,
+					  const struct resource *,
+					  resource_size_t,
+					  resource_size_t),
+		void *alignf_data)
+{
+	if (res->flags & IORESOURCE_MEM_64)
+		return pci_bus_alloc_from_region(bus, res, size, align, min,
+						 type_mask, alignf, alignf_data,
+						 &pci_64_bit);
+
+	return pci_bus_alloc_from_region(bus, res, size, align, min,
+					 type_mask, alignf, alignf_data,
+					 &pci_32_bit);
 }
 
 void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 966b286b5d53..095eb44fcbb6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1493,10 +1493,6 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 #include <asm/pci.h>
 
-#ifndef PCIBIOS_MAX_MEM_32
-#define PCIBIOS_MAX_MEM_32 (-1)
-#endif
-
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
 #define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)

