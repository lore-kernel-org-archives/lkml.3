Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3LJGy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:54:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34121 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3LJGyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:54:55 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 2/5] PCI: Don't use 4G bus address directly in resource allocation
Date: Mon,  9 Dec 2013 22:54:41 -0800
Message-Id: <1386658484-15774-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386658484-15774-1-git-send-email-yinghai@kernel.org>
References: <1386658484-15774-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current we are using PCIBIOS_MAX_MEM_32 (4G limit) directly in the
pci_bus_alloc_resource to make sure that don't allocate too high
pref 64bit above 4G in the system that does not support that.

That is not right, as allocate_resource() should take resource limit.

Add pci_clip_resource() and use it check the pci bus address limit.

At last remove PCIBIOS_MAX_MEM_32.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h |  1 -
 drivers/pci/bus.c          | 41 ++++++++++++++++++++++++++++++++++-------
 include/linux/pci.h        |  4 ----
 3 files changed, 34 insertions(+), 12 deletions(-)

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
index fc1b740..3ad4fd9 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -98,6 +98,25 @@ void pci_bus_remove_resources(struct pci_bus *bus)
 	}
 }
 
+static struct pci_bus_region pci_mem_32 = {0, 0xffffffff};
+
+static void pci_clip_resource(struct resource *res, struct pci_bus *bus,
+			      struct pci_bus_region *region)
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
 /**
  * pci_bus_alloc_resource - allocate a resource from a parent bus
  * @bus: PCI bus
@@ -125,15 +144,12 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
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
+		struct resource avail;
+
 		if (!r)
 			continue;
 
@@ -147,10 +163,21 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		    !(res->flags & IORESOURCE_PREFETCH))
 			continue;
 
+		/*
+		 * don't allocate too high if the pref mem doesn't
+		 * support 64bit.
+		 */
+		avail = *r;
+		if (!(res->flags & IORESOURCE_MEM_64)) {
+			pci_clip_resource(&avail, bus, &pci_mem_32);
+			if (!resource_size(&avail))
+				continue;
+		}
+
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size,
-					r->start ? : min,
-					max, align,
+					max(avail.start, r->start ? : min),
+					avail.end, align,
 					alignf, alignf_data);
 		if (ret == 0)
 			break;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index da069fa..99e9040 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1485,10 +1485,6 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 #include <asm/pci.h>
 
-#ifndef PCIBIOS_MAX_MEM_32
-#define PCIBIOS_MAX_MEM_32 (-1)
-#endif
-
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
 #define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-- 
1.8.4

