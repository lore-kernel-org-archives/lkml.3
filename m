Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3CREtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:49:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33353 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738Ab3CREaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:00 -0400
Message-Id: <20130318042144.371676557@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Michael Neuling <mikey@neuling.org>
Subject: [ 01/82] Revert "powerpc/eeh: Fix crash when adding a device in a slot with  DDW"
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 066f289835f09a3f744d6bac96f25e25d20b3ded which was
6a040ce72598159a74969a2d01ab0ba5ee6536b3 upstream.

This was not needed and is not suitable for 3.2.y.

Reported-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/include/asm/eeh.h       |    3 ---
 arch/powerpc/kernel/of_platform.c    |    3 ---
 arch/powerpc/kernel/pci-common.c     |    7 ++-----
 arch/powerpc/platforms/pseries/eeh.c |   24 +-----------------------
 4 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.h
index 21165a4..66ea9b8 100644
--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -61,7 +61,6 @@ void __init pci_addr_cache_build(void);
  */
 void eeh_add_device_tree_early(struct device_node *);
 void eeh_add_device_tree_late(struct pci_bus *);
-void eeh_add_sysfs_files(struct pci_bus *);
 
 /**
  * eeh_remove_device_recursive - undo EEH for device & children.
@@ -106,8 +105,6 @@ static inline void eeh_add_device_tree_early(struct device_node *dn) { }
 
 static inline void eeh_add_device_tree_late(struct pci_bus *bus) { }
 
-static inline void eeh_add_sysfs_files(struct pci_bus *bus) { }
-
 static inline void eeh_remove_bus_device(struct pci_dev *dev) { }
 #define EEH_POSSIBLE_ERROR(val, type) (0)
 #define EEH_IO_ERROR_VALUE(size) (-1UL)
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index b10beef..e1612df 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -91,9 +91,6 @@ static int __devinit of_pci_phb_probe(struct platform_device *dev)
 	/* Add probed PCI devices to the device model */
 	pci_bus_add_devices(phb->bus);
 
-	/* sysfs files should only be added after devices are added */
-	eeh_add_sysfs_files(phb->bus);
-
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index a3cd949..458ed3b 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1536,14 +1536,11 @@ void pcibios_finish_adding_to_bus(struct pci_bus *bus)
 	pcibios_allocate_bus_resources(bus);
 	pcibios_claim_one_bus(bus);
 
-	/* Fixup EEH */
-	eeh_add_device_tree_late(bus);
-
 	/* Add new devices to global lists.  Register in proc, sysfs. */
 	pci_bus_add_devices(bus);
 
-	/* sysfs files should only be added after devices are added */
-	eeh_add_sysfs_files(bus);
+	/* Fixup EEH */
+	eeh_add_device_tree_late(bus);
 }
 EXPORT_SYMBOL_GPL(pcibios_finish_adding_to_bus);
 
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 389e06b..5658690 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -1238,6 +1238,7 @@ static void eeh_add_device_late(struct pci_dev *dev)
 	pdn->pcidev = dev;
 
 	pci_addr_cache_insert_device(dev);
+	eeh_sysfs_add_device(dev);
 }
 
 void eeh_add_device_tree_late(struct pci_bus *bus)
@@ -1256,29 +1257,6 @@ void eeh_add_device_tree_late(struct pci_bus *bus)
 EXPORT_SYMBOL_GPL(eeh_add_device_tree_late);
 
 /**
- * eeh_add_sysfs_files - Add EEH sysfs files for the indicated PCI bus
- * @bus: PCI bus
- *
- * This routine must be used to add EEH sysfs files for PCI
- * devices which are attached to the indicated PCI bus. The PCI bus
- * is added after system boot through hotplug or dlpar.
- */
-void eeh_add_sysfs_files(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		eeh_sysfs_add_device(dev);
-		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
-			struct pci_bus *subbus = dev->subordinate;
-			if (subbus)
-				eeh_add_sysfs_files(subbus);
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(eeh_add_sysfs_files);
-
-/**
  * eeh_remove_device - undo EEH setup for the indicated pci device
  * @dev: pci device to be removed
  *



