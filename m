Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaAGAzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:55:33 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:56382 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbaAGAz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:55:28 -0500
Subject: [PATCH v7 02/15] PCI: Convert pcibios_resource_to_bus() to take a
 pci_bus, not a pci_dev
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:55:26 -0700
Message-ID: <20140107005526.10786.92444.stgit@bhelgaas-glaptop.roam.corp.google.com>
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

These interfaces:

  pcibios_resource_to_bus(struct pci_dev *dev, *bus_region, *resource)
  pcibios_bus_to_resource(struct pci_dev *dev, *resource, *bus_region)

took a pci_dev, but they really depend only on the pci_bus.  And we want to
use them in resource allocation paths where we have the bus but not a
device, so this patch converts them to take the pci_bus instead of the
pci_dev:

  pcibios_resource_to_bus(struct pci_bus *bus, *bus_region, *resource)
  pcibios_bus_to_resource(struct pci_bus *bus, *resource, *bus_region)

In fact, with standard PCI-PCI bridges, they only depend on the host
bridge, because that's the only place address translation occurs, but
we aren't going that far yet.

[bhelgaas: changelog]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/alpha/kernel/pci-sysfs.c       |    4 ++--
 arch/powerpc/kernel/pci-common.c    |    4 ++--
 arch/powerpc/kernel/pci_of_scan.c   |    4 ++--
 arch/sparc/kernel/pci.c             |    6 +++---
 drivers/pci/host-bridge.c           |   19 ++++++++-----------
 drivers/pci/probe.c                 |   18 +++++++++---------
 drivers/pci/quirks.c                |    2 +-
 drivers/pci/rom.c                   |    2 +-
 drivers/pci/setup-bus.c             |   16 ++++++++--------
 drivers/pci/setup-res.c             |    2 +-
 drivers/pcmcia/i82092.c             |    2 +-
 drivers/pcmcia/yenta_socket.c       |    6 +++---
 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 +++--
 drivers/video/arkfb.c               |    2 +-
 drivers/video/s3fb.c                |    2 +-
 drivers/video/vt8623fb.c            |    2 +-
 include/linux/pci.h                 |    4 ++--
 17 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/arch/alpha/kernel/pci-sysfs.c b/arch/alpha/kernel/pci-sysfs.c
index 2b183b0d3207..99e8d4796c96 100644
--- a/arch/alpha/kernel/pci-sysfs.c
+++ b/arch/alpha/kernel/pci-sysfs.c
@@ -83,7 +83,7 @@ static int pci_mmap_resource(struct kobject *kobj,
 	if (iomem_is_exclusive(res->start))
 		return -EINVAL;
 
-	pcibios_resource_to_bus(pdev, &bar, res);
+	pcibios_resource_to_bus(pdev->bus, &bar, res);
 	vma->vm_pgoff += bar.start >> (PAGE_SHIFT - (sparse ? 5 : 0));
 	mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;
 
@@ -139,7 +139,7 @@ static int sparse_mem_mmap_fits(struct pci_dev *pdev, int num)
 	long dense_offset;
 	unsigned long sparse_size;
 
-	pcibios_resource_to_bus(pdev, &bar, &pdev->resource[num]);
+	pcibios_resource_to_bus(pdev->bus, &bar, &pdev->resource[num]);
 
 	/* All core logic chips have 4G sparse address space, except
 	   CIA which has 16G (see xxx_SPARSE_MEM and xxx_DENSE_MEM
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index a1e3e40ca3fd..d9476c1fc959 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -835,7 +835,7 @@ static void pcibios_fixup_resources(struct pci_dev *dev)
 		 * at 0 as unset as well, except if PCI_PROBE_ONLY is also set
 		 * since in that case, we don't want to re-assign anything
 		 */
-		pcibios_resource_to_bus(dev, &reg, res);
+		pcibios_resource_to_bus(dev->bus, &reg, res);
 		if (pci_has_flag(PCI_REASSIGN_ALL_RSRC) ||
 		    (reg.start == 0 && !pci_has_flag(PCI_PROBE_ONLY))) {
 			/* Only print message if not re-assigning */
@@ -886,7 +886,7 @@ static int pcibios_uninitialized_bridge_resource(struct pci_bus *bus,
 
 	/* Job is a bit different between memory and IO */
 	if (res->flags & IORESOURCE_MEM) {
-		pcibios_resource_to_bus(dev, &region, res);
+		pcibios_resource_to_bus(dev->bus, &region, res);
 
 		/* If the BAR is non-0 then it's probably been initialized */
 		if (region.start != 0)
diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index ac0b034f9ae0..83c26d829991 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -111,7 +111,7 @@ static void of_pci_parse_addrs(struct device_node *node, struct pci_dev *dev)
 		res->name = pci_name(dev);
 		region.start = base;
 		region.end = base + size - 1;
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 	}
 }
 
@@ -280,7 +280,7 @@ void of_scan_pci_bridge(struct pci_dev *dev)
 		res->flags = flags;
 		region.start = of_read_number(&ranges[1], 2);
 		region.end = region.start + size - 1;
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 	}
 	sprintf(bus->name, "PCI Bus %04x:%02x", pci_domain_nr(bus),
 		bus->number);
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index cb021453de2a..7de8d1f590b7 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -392,7 +392,7 @@ static void apb_fake_ranges(struct pci_dev *dev,
 	res->flags = IORESOURCE_IO;
 	region.start = (first << 21);
 	region.end = (last << 21) + ((1 << 21) - 1);
-	pcibios_bus_to_resource(dev, res, &region);
+	pcibios_bus_to_resource(dev->bus, res, &region);
 
 	pci_read_config_byte(dev, APB_MEM_ADDRESS_MAP, &map);
 	apb_calc_first_last(map, &first, &last);
@@ -400,7 +400,7 @@ static void apb_fake_ranges(struct pci_dev *dev,
 	res->flags = IORESOURCE_MEM;
 	region.start = (first << 29);
 	region.end = (last << 29) + ((1 << 29) - 1);
-	pcibios_bus_to_resource(dev, res, &region);
+	pcibios_bus_to_resource(dev->bus, res, &region);
 }
 
 static void pci_of_scan_bus(struct pci_pbm_info *pbm,
@@ -491,7 +491,7 @@ static void of_scan_pci_bridge(struct pci_pbm_info *pbm,
 		res->flags = flags;
 		region.start = GET_64BIT(ranges, 1);
 		region.end = region.start + size - 1;
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 	}
 after_ranges:
 	sprintf(bus->name, "PCI Bus %04x:%02x", pci_domain_nr(bus),
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index a68dc613a5be..06ace6248c61 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -9,22 +9,19 @@
 
 #include "pci.h"
 
-static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
+static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
 {
-	struct pci_bus *bus;
-
-	bus = dev->bus;
 	while (bus->parent)
 		bus = bus->parent;
 
 	return bus;
 }
 
-static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
+static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
 {
-	struct pci_bus *bus = find_pci_root_bus(dev);
+	struct pci_bus *root_bus = find_pci_root_bus(bus);
 
-	return to_pci_host_bridge(bus->bridge);
+	return to_pci_host_bridge(root_bus->bridge);
 }
 
 void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
@@ -40,10 +37,10 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
 	return res1->start <= res2->start && res1->end >= res2->end;
 }
 
-void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 			     struct resource *res)
 {
-	struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
 	struct pci_host_bridge_window *window;
 	resource_size_t offset = 0;
 
@@ -68,10 +65,10 @@ static bool region_contains(struct pci_bus_region *region1,
 	return region1->start <= region2->start && region1->end >= region2->end;
 }
 
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 			     struct pci_bus_region *region)
 {
-	struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
 	struct pci_host_bridge_window *window;
 	resource_size_t offset = 0;
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 38e403dddf6e..f049e3f53fcc 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -269,8 +269,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		region.end = l + sz;
 	}
 
-	pcibios_bus_to_resource(dev, res, &region);
-	pcibios_resource_to_bus(dev, &inverted_region, res);
+	pcibios_bus_to_resource(dev->bus, res, &region);
+	pcibios_resource_to_bus(dev->bus, &inverted_region, res);
 
 	/*
 	 * If "A" is a BAR value (a bus address), "bus_to_resource(A)" is
@@ -364,7 +364,7 @@ static void pci_read_bridge_io(struct pci_bus *child)
 		res->flags = (io_base_lo & PCI_IO_RANGE_TYPE_MASK) | IORESOURCE_IO;
 		region.start = base;
 		region.end = limit + io_granularity - 1;
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 }
@@ -386,7 +386,7 @@ static void pci_read_bridge_mmio(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		region.start = base;
 		region.end = limit + 0xfffff;
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 }
@@ -436,7 +436,7 @@ static void pci_read_bridge_mmio_pref(struct pci_bus *child)
 			res->flags |= IORESOURCE_MEM_64;
 		region.start = base;
 		region.end = limit + 0xfffff;
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
 	}
 }
@@ -1084,24 +1084,24 @@ int pci_setup_device(struct pci_dev *dev)
 				region.end = 0x1F7;
 				res = &dev->resource[0];
 				res->flags = LEGACY_IO_RESOURCE;
-				pcibios_bus_to_resource(dev, res, &region);
+				pcibios_bus_to_resource(dev->bus, res, &region);
 				region.start = 0x3F6;
 				region.end = 0x3F6;
 				res = &dev->resource[1];
 				res->flags = LEGACY_IO_RESOURCE;
-				pcibios_bus_to_resource(dev, res, &region);
+				pcibios_bus_to_resource(dev->bus, res, &region);
 			}
 			if ((progif & 4) == 0) {
 				region.start = 0x170;
 				region.end = 0x177;
 				res = &dev->resource[2];
 				res->flags = LEGACY_IO_RESOURCE;
-				pcibios_bus_to_resource(dev, res, &region);
+				pcibios_bus_to_resource(dev->bus, res, &region);
 				region.start = 0x376;
 				region.end = 0x376;
 				res = &dev->resource[3];
 				res->flags = LEGACY_IO_RESOURCE;
-				pcibios_bus_to_resource(dev, res, &region);
+				pcibios_bus_to_resource(dev->bus, res, &region);
 			}
 		}
 		break;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index b3b1b9aa8863..4ad6bf6c107b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -343,7 +343,7 @@ static void quirk_io_region(struct pci_dev *dev, int port,
 	/* Convert from PCI bus to resource space */
 	bus_region.start = region;
 	bus_region.end = region + size - 1;
-	pcibios_bus_to_resource(dev, res, &bus_region);
+	pcibios_bus_to_resource(dev->bus, res, &bus_region);
 
 	if (!pci_claim_resource(dev, nr))
 		dev_info(&dev->dev, "quirk: %pR claimed by %s\n", res, name);
diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index c5d0a08a8747..5d595724e5f4 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -31,7 +31,7 @@ int pci_enable_rom(struct pci_dev *pdev)
 	if (!res->flags)
 		return -1;
 
-	pcibios_resource_to_bus(pdev, &region, res);
+	pcibios_resource_to_bus(pdev->bus, &region, res);
 	pci_read_config_dword(pdev, pdev->rom_base_reg, &rom_addr);
 	rom_addr &= ~PCI_ROM_ADDRESS_MASK;
 	rom_addr |= region.start | PCI_ROM_ADDRESS_ENABLE;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 219a4106480a..79339822d80e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -475,7 +475,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 		 &bus->busn_res);
 
 	res = bus->resource[0];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_IO) {
 		/*
 		 * The IO resource is allocated a range twice as large as it
@@ -489,7 +489,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	}
 
 	res = bus->resource[1];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_IO) {
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
@@ -499,7 +499,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	}
 
 	res = bus->resource[2];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
@@ -509,7 +509,7 @@ void pci_setup_cardbus(struct pci_bus *bus)
 	}
 
 	res = bus->resource[3];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
 		pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
@@ -546,7 +546,7 @@ static void pci_setup_bridge_io(struct pci_bus *bus)
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
 	res = bus->resource[0];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_IO) {
 		pci_read_config_dword(bridge, PCI_IO_BASE, &l);
 		l &= 0xffff0000;
@@ -578,7 +578,7 @@ static void pci_setup_bridge_mmio(struct pci_bus *bus)
 
 	/* Set up the top and bottom of the PCI Memory segment for this bus. */
 	res = bus->resource[1];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
@@ -604,7 +604,7 @@ static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
 	/* Set up PREF base/limit. */
 	bu = lu = 0;
 	res = bus->resource[2];
-	pcibios_resource_to_bus(bridge, &region, res);
+	pcibios_resource_to_bus(bridge->bus, &region, res);
 	if (res->flags & IORESOURCE_PREFETCH) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
@@ -1422,7 +1422,7 @@ static int iov_resources_unassigned(struct pci_dev *dev, void *data)
 		if (!r->flags)
 			continue;
 
-		pcibios_resource_to_bus(dev, &region, r);
+		pcibios_resource_to_bus(dev->bus, &region, r);
 		if (!region.start) {
 			*unassigned = true;
 			return 1; /* return early from pci_walk_bus() */
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 83c4d3bc47ab..5c060b152ce6 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -52,7 +52,7 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 	if (res->flags & IORESOURCE_PCI_FIXED)
 		return;
 
-	pcibios_resource_to_bus(dev, &region, res);
+	pcibios_resource_to_bus(dev->bus, &region, res);
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 519c4d6003a6..7d47456429a1 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -608,7 +608,7 @@ static int i82092aa_set_mem_map(struct pcmcia_socket *socket, struct pccard_mem_
 	
 	enter("i82092aa_set_mem_map");
 
-	pcibios_resource_to_bus(sock_info->dev, &region, mem->res);
+	pcibios_resource_to_bus(sock_info->dev->bus, &region, mem->res);
 	
 	map = mem->map;
 	if (map > 4) {
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index dc18a3a5e010..8485761e76af 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -445,7 +445,7 @@ static int yenta_set_mem_map(struct pcmcia_socket *sock, struct pccard_mem_map *
 	unsigned int start, stop, card_start;
 	unsigned short word;
 
-	pcibios_resource_to_bus(socket->dev, &region, mem->res);
+	pcibios_resource_to_bus(socket->dev->bus, &region, mem->res);
 
 	map = mem->map;
 	start = region.start;
@@ -709,7 +709,7 @@ static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type
 	region.start = config_readl(socket, addr_start) & mask;
 	region.end = config_readl(socket, addr_end) | ~mask;
 	if (region.start && region.end > region.start && !override_bios) {
-		pcibios_bus_to_resource(dev, res, &region);
+		pcibios_bus_to_resource(dev->bus, res, &region);
 		if (pci_claim_resource(dev, PCI_BRIDGE_RESOURCES + nr) == 0)
 			return 0;
 		dev_printk(KERN_INFO, &dev->dev,
@@ -1033,7 +1033,7 @@ static void yenta_config_init(struct yenta_socket *socket)
 	struct pci_dev *dev = socket->dev;
 	struct pci_bus_region region;
 
-	pcibios_resource_to_bus(socket->dev, &region, &dev->resource[0]);
+	pcibios_resource_to_bus(socket->dev->bus, &region, &dev->resource[0]);
 
 	config_writel(socket, CB_LEGACY_MODE_BASE, 0);
 	config_writel(socket, PCI_BASE_ADDRESS_0, region.start);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index bac55f7f69f9..6d3ee1ab6362 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1531,7 +1531,7 @@ static int sym_iomap_device(struct sym_device *device)
 	struct pci_bus_region bus_addr;
 	int i = 2;
 
-	pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[1]);
+	pcibios_resource_to_bus(pdev->bus, &bus_addr, &pdev->resource[1]);
 	device->mmio_base = bus_addr.start;
 
 	if (device->chip.features & FE_RAM) {
@@ -1541,7 +1541,8 @@ static int sym_iomap_device(struct sym_device *device)
 		 */
 		if (!pdev->resource[i].flags)
 			i++;
-		pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
+		pcibios_resource_to_bus(pdev->bus, &bus_addr,
+					&pdev->resource[i]);
 		device->ram_base = bus_addr.start;
 	}
 
diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index a6b29bd4a12a..adc4ea2cc5a0 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -1014,7 +1014,7 @@ static int ark_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	vga_res.flags = IORESOURCE_IO;
 
-	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
+	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
 
 	par->state.vgabase = (void __iomem *) vga_res.start;
 
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 968b2997175a..9a3f8f1c6aab 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -1180,7 +1180,7 @@ static int s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	vga_res.flags = IORESOURCE_IO;
 
-	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
+	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
 
 	par->state.vgabase = (void __iomem *) vga_res.start;
 
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 8bc6e0958a09..5c7cbc6c6236 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -729,7 +729,7 @@ static int vt8623_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	vga_res.flags = IORESOURCE_IO;
 
-	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
+	pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
 
 	par->state.vgabase = (void __iomem *) vga_res.start;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7d5555270491..bf32412704a7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -737,9 +737,9 @@ void pci_fixup_cardbus(struct pci_bus *);
 
 /* Generic PCI functions used internally */
 
-void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
+void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 			     struct resource *res);
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 			     struct pci_bus_region *region);
 void pcibios_scan_specific_bus(int busn);
 struct pci_bus *pci_find_bus(int domain, int busnr);

