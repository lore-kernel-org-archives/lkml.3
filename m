Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3HEUnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50981 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3HEUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:02 -0400
Message-ID: <5ddf090f5ff168deb4fc415ced11c75b040f84d4.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 12/20] tile PCI RC: eliminate pci_controller.mem_resources field
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .mem_resources[] field in the pci_controller struct
is now obsoleted by the .mem_space and .io_space fields.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pci.h |  3 --
 arch/tile/kernel/pci_gx.c   | 71 ++++++++-------------------------------------
 2 files changed, 12 insertions(+), 62 deletions(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 1f1b654..2c001b2 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -173,9 +173,6 @@ struct pci_controller {
 
 	/* Table that maps the INTx numbers to Linux irq numbers. */
 	int irq_intx_table[4];
-
-	/* Address ranges that are routed to this controller/bridge. */
-	struct resource mem_resources[3];
 };
 
 extern struct pci_controller pci_controllers[TILEGX_NUM_TRIO * TILEGX_TRIO_PCIES];
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 8051638..6837be2 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -929,9 +929,6 @@ int __init pcibios_init(void)
 		struct pci_controller *controller = &pci_controllers[i];
 		gxio_trio_context_t *trio_context = controller->trio;
 		struct pci_bus *root_bus = pci_controllers[i].root_bus;
-		struct pci_bus *next_bus;
-		uint32_t bus_address_hi;
-		struct pci_dev *dev;
 		int ret;
 		int j;
 
@@ -945,35 +942,6 @@ int __init pcibios_init(void)
 		/* Configure the max_payload_size values for this domain. */
 		fixup_read_and_payload_sizes(controller);
 
-		list_for_each_entry(dev, &root_bus->devices, bus_list) {
-			/* Find the PCI host controller, ie. the 1st bridge. */
-			if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
-				(PCI_SLOT(dev->devfn) == 0)) {
-				next_bus = dev->subordinate;
-				pci_controllers[i].mem_resources[0] =
-					*next_bus->resource[0];
-				pci_controllers[i].mem_resources[1] =
-					*next_bus->resource[1];
-				pci_controllers[i].mem_resources[2] =
-					*next_bus->resource[2];
-
-				break;
-			}
-		}
-
-		if (pci_controllers[i].mem_resources[1].flags & IORESOURCE_MEM)
-			bus_address_hi =
-				pci_controllers[i].mem_resources[1].start >> 32;
-		else if (pci_controllers[i].mem_resources[2].flags & IORESOURCE_PREFETCH)
-			bus_address_hi =
-				pci_controllers[i].mem_resources[2].start >> 32;
-		else {
-			/* This is unlikely. */
-			pr_err("PCI: no memory resources on TRIO %d mac %d\n",
-				controller->trio_index, controller->mac);
-			continue;
-		}
-
 		/*
 		 * Alloc a PIO region for PCI memory access for each RC port.
 		 */
@@ -1153,16 +1121,13 @@ void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
 	resource_size_t start;
 	resource_size_t end;
 	int trio_fd;
-	int i, j;
+	int i;
 
 	start = phys_addr;
 	end = phys_addr + size - 1;
 
 	/*
-	 * In the following, each PCI controller's mem_resources[1]
-	 * represents its (non-prefetchable) PCI memory resource and
-	 * mem_resources[2] refers to its prefetchable PCI memory resource.
-	 * By searching phys_addr in each controller's mem_resources[], we can
+	 * By searching phys_addr in each controller's mem_space, we can
 	 * determine the controller that should accept the PCI memory access.
 	 */
 
@@ -1174,25 +1139,18 @@ void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
 		if (pci_controllers[i].root_bus == NULL)
 			continue;
 
-		for (j = 1; j < 3; j++) {
-			bar_start =
-				pci_controllers[i].mem_resources[j].start;
-			bar_end =
-				pci_controllers[i].mem_resources[j].end;
-
-			if ((start >= bar_start) && (end <= bar_end)) {
+		bar_start = pci_controllers[i].mem_space.start;
+		bar_end = pci_controllers[i].mem_space.end;
 
-				controller = &pci_controllers[i];
-
-				goto got_it;
-			}
+		if ((start >= bar_start) && (end <= bar_end)) {
+			controller = &pci_controllers[i];
+			break;
 		}
 	}
 
 	if (controller == NULL)
 		return NULL;
 
-got_it:
 	trio_fd = controller->trio->fd;
 
 	/* Convert the resource start to the bus address offset. */
@@ -1225,10 +1183,8 @@ void __iomem *ioport_map(unsigned long port, unsigned int size)
 	end = port + size - 1;
 
 	/*
-	 * In the following, each PCI controller's mem_resources[0]
-	 * represents its PCI I/O resource. By searching port in each
-	 * controller's mem_resources[0], we can determine the controller
-	 * that should accept the PCI I/O access.
+	 * By searching the port in each controller's io_space, we can
+	 * determine the controller that should accept the PCI I/O access.
 	 */
 
 	for (i = 0; i < num_rc_controllers; i++) {
@@ -1239,21 +1195,18 @@ void __iomem *ioport_map(unsigned long port, unsigned int size)
 		if (pci_controllers[i].root_bus == NULL)
 			continue;
 
-		bar_start = pci_controllers[i].mem_resources[0].start;
-		bar_end = pci_controllers[i].mem_resources[0].end;
+		bar_start = pci_controllers[i].io_space.start;
+		bar_end = pci_controllers[i].io_space.end;
 
 		if ((start >= bar_start) && (end <= bar_end)) {
-
 			controller = &pci_controllers[i];
-
-			goto got_it;
+			break;
 		}
 	}
 
 	if (controller == NULL)
 		return NULL;
 
-got_it:
 	trio_fd = controller->trio->fd;
 
 	/* Convert the resource start to the bus address offset. */
-- 
1.8.3.1

