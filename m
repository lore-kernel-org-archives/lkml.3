Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab3FAGEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 02:04:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49697 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab3FAGDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 02:03:38 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 6/7] PCI: Enable pci bridge when it is needed
Date: Fri, 31 May 2013 23:03:11 -0700
Message-Id: <1370066593-22736-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
References: <1370066593-22736-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current we enable bridges after bus scan and assign resources.
and it is spreaded a lot of places.

We can enable them later when their children pci device is enabled.
Need to go up to root bus and enable bridge one by one down to pci
device.

So that will delay enable bridge as needed bassis,
also kill one inconsistent between boot path and hot-add
path in acpi_pci_root_add().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/arm/kernel/bios32.c           |    5 -----
 arch/m68k/platform/coldfire/pci.c  |    1 -
 arch/mips/pci/pci.c                |    1 -
 arch/sh/drivers/pci/pci.c          |    1 -
 drivers/acpi/pci_root.c            |    4 ----
 drivers/parisc/lba_pci.c           |    1 -
 drivers/pci/bus.c                  |   19 -------------------
 drivers/pci/hotplug/acpiphp_glue.c |    1 -
 drivers/pci/pci.c                  |   20 ++++++++++++++++++++
 drivers/pci/probe.c                |    1 -
 drivers/pci/setup-bus.c            |   10 +++-------
 drivers/pcmcia/cardbus.c           |    1 -
 include/linux/pci.h                |    1 -
 13 files changed, 23 insertions(+), 43 deletions(-)

Index: linux-2.6/arch/arm/kernel/bios32.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/bios32.c
+++ linux-2.6/arch/arm/kernel/bios32.c
@@ -524,11 +524,6 @@ void pci_common_init(struct hw_pci *hw)
 			 * Assign resources.
 			 */
 			pci_bus_assign_resources(bus);
-
-			/*
-			 * Enable bridges
-			 */
-			pci_enable_bridges(bus);
 		}
 
 		/*
Index: linux-2.6/arch/m68k/platform/coldfire/pci.c
===================================================================
--- linux-2.6.orig/arch/m68k/platform/coldfire/pci.c
+++ linux-2.6/arch/m68k/platform/coldfire/pci.c
@@ -319,7 +319,6 @@ static int __init mcf_pci_init(void)
 	pci_fixup_irqs(pci_common_swizzle, mcf_pci_map_irq);
 	pci_bus_size_bridges(rootbus);
 	pci_bus_assign_resources(rootbus);
-	pci_enable_bridges(rootbus);
 
 	return 0;
 }
Index: linux-2.6/arch/mips/pci/pci.c
===================================================================
--- linux-2.6.orig/arch/mips/pci/pci.c
+++ linux-2.6/arch/mips/pci/pci.c
@@ -113,7 +113,6 @@ static void pcibios_scanbus(struct pci_c
 		if (!pci_has_flag(PCI_PROBE_ONLY)) {
 			pci_bus_size_bridges(bus);
 			pci_bus_assign_resources(bus);
-			pci_enable_bridges(bus);
 		}
 	}
 }
Index: linux-2.6/arch/sh/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/pci/pci.c
+++ linux-2.6/arch/sh/drivers/pci/pci.c
@@ -69,7 +69,6 @@ static void pcibios_scanbus(struct pci_c
 
 		pci_bus_size_bridges(bus);
 		pci_bus_assign_resources(bus);
-		pci_enable_bridges(bus);
 	} else {
 		pci_free_resource_list(&resources);
 	}
Index: linux-2.6/drivers/parisc/lba_pci.c
===================================================================
--- linux-2.6.orig/drivers/parisc/lba_pci.c
+++ linux-2.6/drivers/parisc/lba_pci.c
@@ -1533,7 +1533,6 @@ lba_driver_probe(struct parisc_device *d
 		lba_dump_res(&lba_dev->hba.lmmio_space, 2);
 #endif
 	}
-	pci_enable_bridges(lba_bus);
 
 	/*
 	** Once PCI register ops has walked the bus, access to config
Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -216,24 +216,6 @@ void pci_bus_add_devices(const struct pc
 	}
 }
 
-void pci_enable_bridges(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-	int retval;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		if (dev->subordinate) {
-			if (!pci_is_enabled(dev)) {
-				retval = pci_enable_device(dev);
-				if (retval)
-					dev_err(&dev->dev, "Error enabling bridge (%d), continuing\n", retval);
-				pci_set_master(dev);
-			}
-			pci_enable_bridges(dev->subordinate);
-		}
-	}
-}
-
 /** pci_walk_bus - walk devices on/under bus, calling callback.
  *  @top      bus whose devices should be walked
  *  @cb       callback to be called for each device found
@@ -301,4 +283,3 @@ EXPORT_SYMBOL(pci_bus_put);
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
 EXPORT_SYMBOL(pci_bus_add_devices);
-EXPORT_SYMBOL(pci_enable_bridges);
Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
@@ -704,7 +704,6 @@ static int __ref enable_device(struct ac
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
 	acpiphp_set_acpi_region(slot);
-	pci_enable_bridges(bus);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		/* Assume that newly added devices are powered on already. */
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1145,6 +1145,24 @@ int pci_reenable_device(struct pci_dev *
 	return 0;
 }
 
+static void pci_enable_bridge(struct pci_dev *dev)
+{
+	int retval;
+
+	if (!dev)
+		return;
+
+	pci_enable_bridge(dev->bus->self);
+
+	if (pci_is_enabled(dev))
+		return;
+	retval = pci_enable_device(dev);
+	if (retval)
+		dev_err(&dev->dev, "Error enabling bridge (%d), continuing\n",
+			retval);
+	pci_set_master(dev);
+}
+
 static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 {
 	int err;
@@ -1165,6 +1183,8 @@ static int pci_enable_device_flags(struc
 	if (atomic_inc_return(&dev->enable_cnt) > 1)
 		return 0;		/* already enabled */
 
+	pci_enable_bridge(dev->bus->self);
+
 	/* only skip sriov related */
 	for (i = 0; i <= PCI_ROM_RESOURCE; i++)
 		if (dev->resource[i].flags & flags)
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1964,7 +1964,6 @@ unsigned int __ref pci_rescan_bus(struct
 
 	max = pci_scan_child_bus(bus);
 	pci_assign_unassigned_bus_resources(bus);
-	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
 	return max;
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1503,7 +1503,7 @@ again:
 
 	/* any device complain? */
 	if (list_empty(&fail_head))
-		goto enable_and_dump;
+		goto dump;
 
 	if (tried_times >= pci_try_num) {
 		if (enable_local == undefined)
@@ -1512,7 +1512,7 @@ again:
 			dev_info(&bus->dev, "Automatically enabled pci realloc, if you have problem, try booting with pci=realloc=off\n");
 
 		free_list(&fail_head);
-		goto enable_and_dump;
+		goto dump;
 	}
 
 	dev_printk(KERN_DEBUG, &bus->dev,
@@ -1545,10 +1545,7 @@ again:
 
 	goto again;
 
-enable_and_dump:
-	/* Depth last, update the hardware. */
-	pci_enable_bridges(bus);
-
+dump:
 	/* dump the resource on buses */
 	pci_bus_dump_resources(bus);
 }
@@ -1621,7 +1618,6 @@ enable_all:
 	if (retval)
 		dev_err(&bridge->dev, "Error reenabling bridge (%d)\n", retval);
 	pci_set_master(bridge);
-	pci_enable_bridges(parent);
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);
 
Index: linux-2.6/drivers/pcmcia/cardbus.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/cardbus.c
+++ linux-2.6/drivers/pcmcia/cardbus.c
@@ -91,7 +91,6 @@ int __ref cb_alloc(struct pcmcia_socket
 	if (s->tune_bridge)
 		s->tune_bridge(s, bus);
 
-	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
 	return 0;
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1043,7 +1043,6 @@ int __must_check pci_bus_alloc_resource(
 						  resource_size_t,
 						  resource_size_t),
 			void *alignf_data);
-void pci_enable_bridges(struct pci_bus *bus);
 
 /* Proper probing supporting hot-pluggable devices */
 int __must_check __pci_register_driver(struct pci_driver *, struct module *,
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -537,10 +537,6 @@ static int acpi_pci_root_add(struct acpi
 		pci_assign_unassigned_bus_resources(root->bus);
 	}
 
-	/* need to after hot-added ioapic is registered */
-	if (system_state != SYSTEM_BOOTING)
-		pci_enable_bridges(root->bus);
-
 	pci_bus_add_devices(root->bus);
 	return 1;
 
