Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3KZB3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:29:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26368 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3KZB3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:29:08 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 07/10] PCI: Try to allocate mem64 above 4G at first
Date: Mon, 25 Nov 2013 17:28:07 -0800
Message-Id: <1385429290-25397-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will fall back to below 4g if it can not find any above 4g.

x86 32bit without X86_PAE support will have bottom set to 0, because
resource_size_t is 32bit.

Also for 32bit with resource_size_t 64bit kernel on machine with pae support
we are safe because iomem_resource is limited to 32bit according to
x86_phys_bits.

-v2: update bottom assigning to make it clear for non-pae support machine.
-v3: Bjorn's change:
        use MAX_RESOURCE instead of -1
        use start/end instead of bottom/max
        for all arch instead of just x86_64
-v4: updated after PCI_MAX_RESOURCE_32 change.
-v5: restore io handling to use PCI_MAX_RESOURCE_32 as limit.
-v6: checking pcibios_resource_to_bus return for every bus res, to decide it
	if we need to try high at first.
     It supports all arches instead of just x86_64.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h |  1 -
 drivers/pci/bus.c          | 42 ++++++++++++++++++++++++++++++++++--------
 drivers/pci/pci.h          |  2 ++
 include/linux/pci.h        |  4 ----
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 947b5c4..122c299 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -125,7 +125,6 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 /* generic pci stuff */
 #include <asm-generic/pci.h>
-#define PCIBIOS_MAX_MEM_32 0xffffffff
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 1ffd95b..f801f6a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -125,15 +125,13 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 {
 	int i, ret = -ENOMEM;
 	struct resource *r;
-	resource_size_t max = -1;
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
-	/* don't allocate too high if the pref mem doesn't support 64bit*/
-	if (!(res->flags & IORESOURCE_MEM_64))
-		max = PCIBIOS_MAX_MEM_32;
-
 	pci_bus_for_each_resource(bus, r, i) {
+		resource_size_t start, end, middle;
+		struct pci_bus_region region;
+
 		if (!r)
 			continue;
 
@@ -147,14 +145,42 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		    !(res->flags & IORESOURCE_PREFETCH))
 			continue;
 
+		start = 0;
+		end = MAX_RESOURCE;
+		/*
+		 * don't allocate too high if the pref mem doesn't
+		 * support 64bit, also if this is a 64-bit mem
+		 * resource, try above 4GB first
+		 */
+		__pcibios_resource_to_bus(bus, &region, r);
+		if (region.start <= PCI_MAX_ADDR_32 &&
+		    region.end > PCI_MAX_ADDR_32) {
+			middle = pcibios_bus_addr_to_res(bus, res->flags,
+						      PCI_MAX_ADDR_32);
+			if (res->flags & IORESOURCE_MEM_64)
+				start = middle + 1;
+			else
+				end = middle;
+		} else if (region.start > PCI_MAX_ADDR_32 &&
+			   !(res->flags & IORESOURCE_MEM_64))
+				continue;
+
+again:
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
-					r->start ? : min,
-					max, align,
+					max(start, r->start ? : min),
+					end, align,
 					alignf, alignf_data);
 		if (ret == 0)
-			break;
+			return 0;
+
+		if (start != 0) {
+			start = 0;
+			goto again;
+		}
 	}
+
+
 	return ret;
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9c91ecc..aea4efb 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -198,6 +198,8 @@ enum pci_bar_type {
 	pci_bar_mem64,		/* A 64-bit memory BAR */
 };
 
+#define PCI_MAX_ADDR_32	((resource_size_t)0xffffffff)
+
 bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
 				int crs_timeout);
 int pci_setup_device(struct pci_dev *dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3c6e399..1c69789 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1491,10 +1491,6 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 #include <asm/pci.h>
 
-#ifndef PCIBIOS_MAX_MEM_32
-#define PCIBIOS_MAX_MEM_32 (-1)
-#endif
-
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
 #define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-- 
1.8.1.4

