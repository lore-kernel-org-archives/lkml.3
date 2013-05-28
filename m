Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab3E1Re7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:34:59 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54215 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796Ab3E1Re6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:34:58 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 28 May 2013 12:34:56 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Yuanquan Chen <Yuanquan.Chen@freescale.com>,
        Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Subject: [PATCH] powerpc/pci: Improve device hotplug initialization
Date: Tue, 28 May 2013 10:35:14 -0700
Message-Id: <1369762514-27352-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 37f02195b (powerpc/pci: fix PCI-e devices rescan issue on powerpc
platform) fixes a problem with interrupt and DMA initialization on hot
plugged devices. With this commit, interrupt and DMA initialization for
hot plugged devices is handled in the pci device enable function.

This approach has a couple of drawbacks. First, it creates two code paths
for device initialization, one for hot plugged devices and another for devices
known during the initial PCI scan. Second, the initialization code for hot
plugged devices is only called when the device is enabled, ie typically
in the probe function. Also, the platform specific setup code is called each
time pci_enable_device() is called, not only once during device discovery,
meaning it is actually called multiple times, once for devices discovered
during the initial scan and again each time a driver is re-loaded.

The visible result is that interrupt pins are only assigned to hot plugged
devices when the device driver is loaded. Effectively this changes the PCI
probe API, since pci_dev->irq and the device's dma configuration will now
only be valid after pci_enable() was called at least once. A more subtle
change is that platform specific PCI device setup is moved from device
discovery into the driver's probe function, more specifically into the
pci_enable_device() call.

To fix the inconsistencies, replace pcibios_setup_device() with
pcibios_add_device(). Drop explicit calls to pcibios_setup_device();
this makes pcibios_setup_bus_devices() a noop function which could
eventually be dropped. With this change, device initialization is called
exactly once and consistently for both static and hot plugged devices.

Since pcibios_add_device() is called from pci_device_add(), which initializes
the numa node, drop the now redundant additional numa node initialization.

Cc: Yuanquan Chen <Yuanquan.Chen@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hiroo Matsumoto <matsumoto.hiroo@jp.fujitsu.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/powerpc/kernel/pci-common.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 6053f03..41dd980 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1004,13 +1004,8 @@ void pcibios_setup_bus_self(struct pci_bus *bus)
 		ppc_md.pci_dma_bus_setup(bus);
 }
 
-void pcibios_setup_device(struct pci_dev *dev)
+int pcibios_add_device(struct pci_dev *dev)
 {
-	/* Fixup NUMA node as it may not be setup yet by the generic
-	 * code and is needed by the DMA init
-	 */
-	set_dev_node(&dev->dev, pcibus_to_node(dev->bus));
-
 	/* Hook up default DMA ops */
 	set_dma_ops(&dev->dev, pci_dma_ops);
 	set_dma_offset(&dev->dev, PCI_DRAM_OFFSET);
@@ -1023,24 +1018,16 @@ void pcibios_setup_device(struct pci_dev *dev)
 	pci_read_irq_line(dev);
 	if (ppc_md.pci_irq_fixup)
 		ppc_md.pci_irq_fixup(dev);
+
+	return 0;
 }
 
 void pcibios_setup_bus_devices(struct pci_bus *bus)
 {
-	struct pci_dev *dev;
-
 	pr_debug("PCI: Fixup bus devices %d (%s)\n",
 		 bus->number, bus->self ? pci_name(bus->self) : "PHB");
 
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		/* Cardbus can call us to add new devices to a bus, so ignore
-		 * those who are already fully discovered
-		 */
-		if (dev->is_added)
-			continue;
-
-		pcibios_setup_device(dev);
-	}
+	/* nothing to do */
 }
 
 void pcibios_set_master(struct pci_dev *dev)
@@ -1479,10 +1466,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 		if (ppc_md.pcibios_enable_device_hook(dev))
 			return -EINVAL;
 
-	/* avoid pcie irq fix up impact on cardbus */
-	if (dev->hdr_type != PCI_HEADER_TYPE_CARDBUS)
-		pcibios_setup_device(dev);
-
 	return pci_enable_resources(dev, mask);
 }
 
-- 
1.7.9.7

