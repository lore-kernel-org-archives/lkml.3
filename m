Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3B1OqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41863 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3B1Op6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:45:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 005/139] powerpc/eeh: Fix crash when adding a device in a slot with DDW
Date: Thu, 28 Feb 2013 14:42:35 +0000
Message-Id: <1362062689-2567-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

commit 6a040ce72598159a74969a2d01ab0ba5ee6536b3 upstream.

The DDW code uses a eeh_dev struct from the pci_dev. However, this is
not set until eeh_add_device_late is called.

Since pci_bus_add_devices is called before eeh_add_device_late, the PCI
devices are added to the bus, making drivers' probe hooks to be called.
These will call set_dma_mask, which will call the DDW code, which will
require the eeh_dev struct from pci_dev. This would result in a crash,
due to a NULL dereference.

Calling eeh_add_device_late after pci_bus_add_devices would make the
system BUG, because device files shouldn't be added to devices there
were not added to the system. So, a new function is needed to add such
files only after pci_bus_add_devices have been called.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Acked-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/include/asm/eeh.h       |  4 ++++
 arch/powerpc/kernel/of_platform.c    |  3 +++
 arch/powerpc/kernel/pci-common.c     |  7 +++++--
 arch/powerpc/platforms/pseries/eeh.c | 24 +++++++++++++++++++++++-
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/eeh.h b/arch/powerpc/include/asm/eeh.h
index d60f998..c487556 100644
--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -130,6 +130,7 @@ int eeh_dn_check_failure(struct device_node *dn, struct pci_dev *dev);
 void __init pci_addr_cache_build(void);
 void eeh_add_device_tree_early(struct device_node *);
 void eeh_add_device_tree_late(struct pci_bus *);
+void eeh_add_sysfs_files(struct pci_bus *);
 void eeh_remove_bus_device(struct pci_dev *);
 
 /**
@@ -183,7 +184,10 @@ static inline void eeh_add_device_tree_early(struct device_node *dn) { }
 
 static inline void eeh_add_device_tree_late(struct pci_bus *bus) { }
 
+static inline void eeh_add_sysfs_files(struct pci_bus *bus) { }
+
 static inline void eeh_remove_bus_device(struct pci_dev *dev) { }
+
 #define EEH_POSSIBLE_ERROR(val, type) (0)
 #define EEH_IO_ERROR_VALUE(size) (-1UL)
 #endif /* CONFIG_EEH */
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 2049f2d..2089fbd 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -95,6 +95,9 @@ static int __devinit of_pci_phb_probe(struct platform_device *dev)
 	/* Add probed PCI devices to the device model */
 	pci_bus_add_devices(phb->bus);
 
+	/* sysfs files should only be added after devices are added */
+	eeh_add_sysfs_files(phb->bus);
+
 	return 0;
 }
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 8e78e93..41d69fc 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1458,11 +1458,14 @@ void pcibios_finish_adding_to_bus(struct pci_bus *bus)
 	pcibios_allocate_bus_resources(bus);
 	pcibios_claim_one_bus(bus);
 
+	/* Fixup EEH */
+	eeh_add_device_tree_late(bus);
+
 	/* Add new devices to global lists.  Register in proc, sysfs. */
 	pci_bus_add_devices(bus);
 
-	/* Fixup EEH */
-	eeh_add_device_tree_late(bus);
+	/* sysfs files should only be added after devices are added */
+	eeh_add_sysfs_files(bus);
 }
 EXPORT_SYMBOL_GPL(pcibios_finish_adding_to_bus);
 
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 9a0b5f5..b1d91b5 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -1088,7 +1088,6 @@ static void eeh_add_device_late(struct pci_dev *dev)
 	dev->dev.archdata.edev = edev;
 
 	pci_addr_cache_insert_device(dev);
-	eeh_sysfs_add_device(dev);
 }
 
 /**
@@ -1115,6 +1114,29 @@ void eeh_add_device_tree_late(struct pci_bus *bus)
 EXPORT_SYMBOL_GPL(eeh_add_device_tree_late);
 
 /**
+ * eeh_add_sysfs_files - Add EEH sysfs files for the indicated PCI bus
+ * @bus: PCI bus
+ *
+ * This routine must be used to add EEH sysfs files for PCI
+ * devices which are attached to the indicated PCI bus. The PCI bus
+ * is added after system boot through hotplug or dlpar.
+ */
+void eeh_add_sysfs_files(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		eeh_sysfs_add_device(dev);
+		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+			struct pci_bus *subbus = dev->subordinate;
+			if (subbus)
+				eeh_add_sysfs_files(subbus);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(eeh_add_sysfs_files);
+
+/**
  * eeh_remove_device - Undo EEH setup for the indicated pci device
  * @dev: pci device to be removed
  *
-- 
1.8.1.2

