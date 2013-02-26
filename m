Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab3B0Awp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:52:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3BZX6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 111/150] powerpc/eeh: Fix crash when adding a device in a slot with DDW
Date: Tue, 26 Feb 2013 15:56:08 -0800
Message-Id: <20130226235535.621435556@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/eeh.h       |    3 +++
 arch/powerpc/kernel/of_platform.c    |    3 +++
 arch/powerpc/kernel/pci-common.c     |    7 +++++--
 arch/powerpc/platforms/pseries/eeh.c |   24 +++++++++++++++++++++++-
 4 files changed, 34 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/eeh.h
+++ b/arch/powerpc/include/asm/eeh.h
@@ -201,6 +201,7 @@ int eeh_dev_check_failure(struct eeh_dev
 void __init eeh_addr_cache_build(void);
 void eeh_add_device_tree_early(struct device_node *);
 void eeh_add_device_tree_late(struct pci_bus *);
+void eeh_add_sysfs_files(struct pci_bus *);
 void eeh_remove_bus_device(struct pci_dev *, int);
 
 /**
@@ -240,6 +241,8 @@ static inline void eeh_add_device_tree_e
 
 static inline void eeh_add_device_tree_late(struct pci_bus *bus) { }
 
+static inline void eeh_add_sysfs_files(struct pci_bus *bus) { }
+
 static inline void eeh_remove_bus_device(struct pci_dev *dev, int purge_pe) { }
 
 static inline void eeh_lock(void) { }
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -95,6 +95,9 @@ static int of_pci_phb_probe(struct platf
 	/* Add probed PCI devices to the device model */
 	pci_bus_add_devices(phb->bus);
 
+	/* sysfs files should only be added after devices are added */
+	eeh_add_sysfs_files(phb->bus);
+
 	return 0;
 }
 
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1477,11 +1477,14 @@ void pcibios_finish_adding_to_bus(struct
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
 
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -788,7 +788,6 @@ static void eeh_add_device_late(struct p
 	dev->dev.archdata.edev = edev;
 
 	eeh_addr_cache_insert_dev(dev);
-	eeh_sysfs_add_device(dev);
 }
 
 /**
@@ -815,6 +814,29 @@ void eeh_add_device_tree_late(struct pci
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
  * @purge_pe: remove the PE or not


