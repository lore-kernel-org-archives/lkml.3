Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399Ab3LIUDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:03:21 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56636 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3LIUDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:03:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUebPPcTyHGssxTwJJ3GYx4aq-=infapvxOQgAm+PL4rA@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-2-git-send-email-yinghai@kernel.org>
	<CAErSpo7HaAbsoy0n5sr_d3iPazEnpnO8WupJrDn2QR2Kid=EgQ@mail.gmail.com>
	<CAE9FiQUebPPcTyHGssxTwJJ3GYx4aq-=infapvxOQgAm+PL4rA@mail.gmail.com>
Date: Mon, 9 Dec 2013 12:03:18 -0800
X-Google-Sender-Auth: G6xJrnMF5n6uHn6nStfWQnj7qjk
Message-ID: <CAE9FiQUrTAnQkiS9SU3-pJ35-U9CqXQNQEceUUarf-WiPXCF2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: pcibus address to resource converting take bus
 instead of dev
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 11:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Dec 9, 2013 at 9:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> Ugh.  Why would we add new functions with "__" prefixes?  There are
>> only a handful of callers to pcibios_bus_to_resource() and
>> pcibios_resource_to_bus().  We can just change them to supply a
>> "struct pci_bus *" directly.  That's a better match for how the
>> hardware works anyway.
>

Please double check if you are happy with the change.
Hope that will not update stable tree maintainer guys.

Subject: [PATCH] PCI: pcibus address to resource converting take bus
instead of dev

For allocating resource under bus path, we do not have dev to pass along,
and we only have bus to use instead.

-v2: drop pcibios_bus_addr_to_resource().
-v3: drop __* change requested by Bjorn.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@vger.kernel.org

---
 arch/alpha/kernel/pci-sysfs.c       |    4 ++--
 arch/powerpc/kernel/pci-common.c    |    4 ++--
 arch/powerpc/kernel/pci_of_scan.c   |    4 ++--
 arch/sparc/kernel/pci.c             |    6 +++---
 drivers/pci/host-bridge.c           |   24 +++++++++++-------------
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
 17 files changed, 52 insertions(+), 53 deletions(-)

Index: linux-2.6/drivers/pci/host-bridge.c
===================================================================
--- linux-2.6.orig/drivers/pci/host-bridge.c
+++ linux-2.6/drivers/pci/host-bridge.c
@@ -9,22 +9,19 @@

 #include "pci.h"

-static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
+static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
 {
-    struct pci_bus *bus;
-
-    bus = dev->bus;
     while (bus->parent)
         bus = bus->parent;

     return bus;
 }

-static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
+static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
 {
-    struct pci_bus *bus = find_pci_root_bus(dev);
+    struct pci_bus *root_bus = find_pci_root_bus(bus);

-    return to_pci_host_bridge(bus->bridge);
+    return to_pci_host_bridge(root_bus->bridge);
 }

 void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
@@ -40,10 +37,11 @@ static bool resource_contains(struct res
     return res1->start <= res2->start && res1->end >= res2->end;
 }

-void pcibios_resource_to_bus(struct pci_dev *dev, struct
pci_bus_region *region,
-                 struct resource *res)
+void pcibios_resource_to_bus(struct pci_bus *bus,
+                      struct pci_bus_region *region,
+                      struct resource *res)
 {
-    struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
+    struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
     struct pci_host_bridge_window *window;
     resource_size_t offset = 0;

@@ -68,10 +66,10 @@ static bool region_contains(struct pci_b
     return region1->start <= region2->start && region1->end >= region2->end;
 }

-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
-                 struct pci_bus_region *region)
+void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
+                      struct pci_bus_region *region)
 {
-    struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
+    struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
     struct pci_host_bridge_window *window;
     resource_size_t offset = 0;

Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -738,9 +738,9 @@ void pci_fixup_cardbus(struct pci_bus *)

 /* Generic PCI functions used internally */

-void pcibios_resource_to_bus(struct pci_dev *dev, struct
pci_bus_region *region,
+void pcibios_resource_to_bus(struct pci_bus *bus, struct
pci_bus_region *region,
                  struct resource *res);
-void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
+void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
                  struct pci_bus_region *region);
 void pcibios_scan_specific_bus(int busn);
 struct pci_bus *pci_find_bus(int domain, int busnr);
Index: linux-2.6/arch/alpha/kernel/pci-sysfs.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/pci-sysfs.c
+++ linux-2.6/arch/alpha/kernel/pci-sysfs.c
@@ -83,7 +83,7 @@ static int pci_mmap_resource(struct kobj
     if (iomem_is_exclusive(res->start))
         return -EINVAL;

-    pcibios_resource_to_bus(pdev, &bar, res);
+    pcibios_resource_to_bus(pdev->bus, &bar, res);
     vma->vm_pgoff += bar.start >> (PAGE_SHIFT - (sparse ? 5 : 0));
     mmap_type = res->flags & IORESOURCE_MEM ? pci_mmap_mem : pci_mmap_io;

@@ -139,7 +139,7 @@ static int sparse_mem_mmap_fits(struct p
     long dense_offset;
     unsigned long sparse_size;

-    pcibios_resource_to_bus(pdev, &bar, &pdev->resource[num]);
+    pcibios_resource_to_bus(pdev->bus, &bar, &pdev->resource[num]);

     /* All core logic chips have 4G sparse address space, except
        CIA which has 16G (see xxx_SPARSE_MEM and xxx_DENSE_MEM
Index: linux-2.6/arch/powerpc/kernel/pci-common.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/pci-common.c
+++ linux-2.6/arch/powerpc/kernel/pci-common.c
@@ -835,7 +835,7 @@ static void pcibios_fixup_resources(stru
          * at 0 as unset as well, except if PCI_PROBE_ONLY is also set
          * since in that case, we don't want to re-assign anything
          */
-        pcibios_resource_to_bus(dev, &reg, res);
+        pcibios_resource_to_bus(dev->bus, &reg, res);
         if (pci_has_flag(PCI_REASSIGN_ALL_RSRC) ||
             (reg.start == 0 && !pci_has_flag(PCI_PROBE_ONLY))) {
             /* Only print message if not re-assigning */
@@ -886,7 +886,7 @@ static int pcibios_uninitialized_bridge_

     /* Job is a bit different between memory and IO */
     if (res->flags & IORESOURCE_MEM) {
-        pcibios_resource_to_bus(dev, &region, res);
+        pcibios_resource_to_bus(dev->bus, &region, res);

         /* If the BAR is non-0 then it's probably been initialized */
         if (region.start != 0)
Index: linux-2.6/drivers/pci/rom.c
===================================================================
--- linux-2.6.orig/drivers/pci/rom.c
+++ linux-2.6/drivers/pci/rom.c
@@ -31,7 +31,7 @@ int pci_enable_rom(struct pci_dev *pdev)
     if (!res->flags)
         return -1;

-    pcibios_resource_to_bus(pdev, &region, res);
+    pcibios_resource_to_bus(pdev->bus, &region, res);
     pci_read_config_dword(pdev, pdev->rom_base_reg, &rom_addr);
     rom_addr &= ~PCI_ROM_ADDRESS_MASK;
     rom_addr |= region.start | PCI_ROM_ADDRESS_ENABLE;
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -475,7 +475,7 @@ void pci_setup_cardbus(struct pci_bus *b
          &bus->busn_res);

     res = bus->resource[0];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_IO) {
         /*
          * The IO resource is allocated a range twice as large as it
@@ -489,7 +489,7 @@ void pci_setup_cardbus(struct pci_bus *b
     }

     res = bus->resource[1];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_IO) {
         dev_info(&bridge->dev, "  bridge window %pR\n", res);
         pci_write_config_dword(bridge, PCI_CB_IO_BASE_1,
@@ -499,7 +499,7 @@ void pci_setup_cardbus(struct pci_bus *b
     }

     res = bus->resource[2];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_MEM) {
         dev_info(&bridge->dev, "  bridge window %pR\n", res);
         pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_0,
@@ -509,7 +509,7 @@ void pci_setup_cardbus(struct pci_bus *b
     }

     res = bus->resource[3];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_MEM) {
         dev_info(&bridge->dev, "  bridge window %pR\n", res);
         pci_write_config_dword(bridge, PCI_CB_MEMORY_BASE_1,
@@ -546,7 +546,7 @@ static void pci_setup_bridge_io(struct p

     /* Set up the top and bottom of the PCI I/O segment for this bus. */
     res = bus->resource[0];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_IO) {
         pci_read_config_dword(bridge, PCI_IO_BASE, &l);
         l &= 0xffff0000;
@@ -578,7 +578,7 @@ static void pci_setup_bridge_mmio(struct

     /* Set up the top and bottom of the PCI Memory segment for this bus. */
     res = bus->resource[1];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_MEM) {
         l = (region.start >> 16) & 0xfff0;
         l |= region.end & 0xfff00000;
@@ -604,7 +604,7 @@ static void pci_setup_bridge_mmio_pref(s
     /* Set up PREF base/limit. */
     bu = lu = 0;
     res = bus->resource[2];
-    pcibios_resource_to_bus(bridge, &region, res);
+    pcibios_resource_to_bus(bridge->bus, &region, res);
     if (res->flags & IORESOURCE_PREFETCH) {
         l = (region.start >> 16) & 0xfff0;
         l |= region.end & 0xfff00000;
@@ -1422,7 +1422,7 @@ static int iov_resources_unassigned(stru
         if (!r->flags)
             continue;

-        pcibios_resource_to_bus(dev, &region, r);
+        pcibios_resource_to_bus(dev->bus, &region, r);
         if (!region.start) {
             *unassigned = true;
             return 1; /* return early from pci_walk_bus() */
Index: linux-2.6/drivers/pci/setup-res.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-res.c
+++ linux-2.6/drivers/pci/setup-res.c
@@ -52,7 +52,7 @@ void pci_update_resource(struct pci_dev
     if (res->flags & IORESOURCE_PCI_FIXED)
         return;

-    pcibios_resource_to_bus(dev, &region, res);
+    pcibios_resource_to_bus(dev->bus, &region, res);

     new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
     if (res->flags & IORESOURCE_IO)
Index: linux-2.6/drivers/pcmcia/i82092.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/i82092.c
+++ linux-2.6/drivers/pcmcia/i82092.c
@@ -608,7 +608,7 @@ static int i82092aa_set_mem_map(struct p

     enter("i82092aa_set_mem_map");

-    pcibios_resource_to_bus(sock_info->dev, &region, mem->res);
+    pcibios_resource_to_bus(sock_info->dev->bus, &region, mem->res);

     map = mem->map;
     if (map > 4) {
Index: linux-2.6/drivers/pcmcia/yenta_socket.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/yenta_socket.c
+++ linux-2.6/drivers/pcmcia/yenta_socket.c
@@ -445,7 +445,7 @@ static int yenta_set_mem_map(struct pcmc
     unsigned int start, stop, card_start;
     unsigned short word;

-    pcibios_resource_to_bus(socket->dev, &region, mem->res);
+    pcibios_resource_to_bus(socket->dev->bus, &region, mem->res);

     map = mem->map;
     start = region.start;
@@ -709,7 +709,7 @@ static int yenta_allocate_res(struct yen
     region.start = config_readl(socket, addr_start) & mask;
     region.end = config_readl(socket, addr_end) | ~mask;
     if (region.start && region.end > region.start && !override_bios) {
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
         if (pci_claim_resource(dev, PCI_BRIDGE_RESOURCES + nr) == 0)
             return 0;
         dev_printk(KERN_INFO, &dev->dev,
@@ -1033,7 +1033,7 @@ static void yenta_config_init(struct yen
     struct pci_dev *dev = socket->dev;
     struct pci_bus_region region;

-    pcibios_resource_to_bus(socket->dev, &region, &dev->resource[0]);
+    pcibios_resource_to_bus(socket->dev->bus, &region, &dev->resource[0]);

     config_writel(socket, CB_LEGACY_MODE_BASE, 0);
     config_writel(socket, PCI_BASE_ADDRESS_0, region.start);
Index: linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1531,7 +1531,7 @@ static int sym_iomap_device(struct sym_d
     struct pci_bus_region bus_addr;
     int i = 2;

-    pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[1]);
+    pcibios_resource_to_bus(pdev->bus, &bus_addr, &pdev->resource[1]);
     device->mmio_base = bus_addr.start;

     if (device->chip.features & FE_RAM) {
@@ -1541,7 +1541,8 @@ static int sym_iomap_device(struct sym_d
          */
         if (!pdev->resource[i].flags)
             i++;
-        pcibios_resource_to_bus(pdev, &bus_addr, &pdev->resource[i]);
+        pcibios_resource_to_bus(pdev->bus, &bus_addr,
+                    &pdev->resource[i]);
         device->ram_base = bus_addr.start;
     }

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -269,8 +269,8 @@ int __pci_read_base(struct pci_dev *dev,
         region.end = l + sz;
     }

-    pcibios_bus_to_resource(dev, res, &region);
-    pcibios_resource_to_bus(dev, &inverted_region, res);
+    pcibios_bus_to_resource(dev->bus, res, &region);
+    pcibios_resource_to_bus(dev->bus, &inverted_region, res);

     /*
      * If "A" is a BAR value (a bus address), "bus_to_resource(A)" is
@@ -364,7 +364,7 @@ static void pci_read_bridge_io(struct pc
         res->flags = (io_base_lo & PCI_IO_RANGE_TYPE_MASK) | IORESOURCE_IO;
         region.start = base;
         region.end = limit + io_granularity - 1;
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
         dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
     }
 }
@@ -386,7 +386,7 @@ static void pci_read_bridge_mmio(struct
         res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
IORESOURCE_MEM;
         region.start = base;
         region.end = limit + 0xfffff;
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
         dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
     }
 }
@@ -436,7 +436,7 @@ static void pci_read_bridge_mmio_pref(st
             res->flags |= IORESOURCE_MEM_64;
         region.start = base;
         region.end = limit + 0xfffff;
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
         dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
     }
 }
@@ -1084,24 +1084,24 @@ int pci_setup_device(struct pci_dev *dev
                 region.end = 0x1F7;
                 res = &dev->resource[0];
                 res->flags = LEGACY_IO_RESOURCE;
-                pcibios_bus_to_resource(dev, res, &region);
+                pcibios_bus_to_resource(dev->bus, res, &region);
                 region.start = 0x3F6;
                 region.end = 0x3F6;
                 res = &dev->resource[1];
                 res->flags = LEGACY_IO_RESOURCE;
-                pcibios_bus_to_resource(dev, res, &region);
+                pcibios_bus_to_resource(dev->bus, res, &region);
             }
             if ((progif & 4) == 0) {
                 region.start = 0x170;
                 region.end = 0x177;
                 res = &dev->resource[2];
                 res->flags = LEGACY_IO_RESOURCE;
-                pcibios_bus_to_resource(dev, res, &region);
+                pcibios_bus_to_resource(dev->bus, res, &region);
                 region.start = 0x376;
                 region.end = 0x376;
                 res = &dev->resource[3];
                 res->flags = LEGACY_IO_RESOURCE;
-                pcibios_bus_to_resource(dev, res, &region);
+                pcibios_bus_to_resource(dev->bus, res, &region);
             }
         }
         break;
Index: linux-2.6/arch/powerpc/kernel/pci_of_scan.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/pci_of_scan.c
+++ linux-2.6/arch/powerpc/kernel/pci_of_scan.c
@@ -111,7 +111,7 @@ static void of_pci_parse_addrs(struct de
         res->name = pci_name(dev);
         region.start = base;
         region.end = base + size - 1;
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
     }
 }

@@ -280,7 +280,7 @@ void of_scan_pci_bridge(struct pci_dev *
         res->flags = flags;
         region.start = of_read_number(&ranges[1], 2);
         region.end = region.start + size - 1;
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
     }
     sprintf(bus->name, "PCI Bus %04x:%02x", pci_domain_nr(bus),
         bus->number);
Index: linux-2.6/arch/sparc/kernel/pci.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pci.c
+++ linux-2.6/arch/sparc/kernel/pci.c
@@ -392,7 +392,7 @@ static void apb_fake_ranges(struct pci_d
     res->flags = IORESOURCE_IO;
     region.start = (first << 21);
     region.end = (last << 21) + ((1 << 21) - 1);
-    pcibios_bus_to_resource(dev, res, &region);
+    pcibios_bus_to_resource(dev->bus, res, &region);

     pci_read_config_byte(dev, APB_MEM_ADDRESS_MAP, &map);
     apb_calc_first_last(map, &first, &last);
@@ -400,7 +400,7 @@ static void apb_fake_ranges(struct pci_d
     res->flags = IORESOURCE_MEM;
     region.start = (first << 29);
     region.end = (last << 29) + ((1 << 29) - 1);
-    pcibios_bus_to_resource(dev, res, &region);
+    pcibios_bus_to_resource(dev->bus, res, &region);
 }

 static void pci_of_scan_bus(struct pci_pbm_info *pbm,
@@ -491,7 +491,7 @@ static void of_scan_pci_bridge(struct pc
         res->flags = flags;
         region.start = GET_64BIT(ranges, 1);
         region.end = region.start + size - 1;
-        pcibios_bus_to_resource(dev, res, &region);
+        pcibios_bus_to_resource(dev->bus, res, &region);
     }
 after_ranges:
     sprintf(bus->name, "PCI Bus %04x:%02x", pci_domain_nr(bus),
Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -339,7 +339,7 @@ static void quirk_io_region(struct pci_d
     /* Convert from PCI bus to resource space */
     bus_region.start = region;
     bus_region.end = region + size - 1;
-    pcibios_bus_to_resource(dev, res, &bus_region);
+    pcibios_bus_to_resource(dev->bus, res, &bus_region);

     if (!pci_claim_resource(dev, nr))
         dev_info(&dev->dev, "quirk: %pR claimed by %s\n", res, name);
Index: linux-2.6/drivers/video/arkfb.c
===================================================================
--- linux-2.6.orig/drivers/video/arkfb.c
+++ linux-2.6/drivers/video/arkfb.c
@@ -1014,7 +1014,7 @@ static int ark_pci_probe(struct pci_dev

     vga_res.flags = IORESOURCE_IO;

-    pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
+    pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);

     par->state.vgabase = (void __iomem *) vga_res.start;

Index: linux-2.6/drivers/video/s3fb.c
===================================================================
--- linux-2.6.orig/drivers/video/s3fb.c
+++ linux-2.6/drivers/video/s3fb.c
@@ -1180,7 +1180,7 @@ static int s3_pci_probe(struct pci_dev *

     vga_res.flags = IORESOURCE_IO;

-    pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
+    pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);

     par->state.vgabase = (void __iomem *) vga_res.start;

Index: linux-2.6/drivers/video/vt8623fb.c
===================================================================
--- linux-2.6.orig/drivers/video/vt8623fb.c
+++ linux-2.6/drivers/video/vt8623fb.c
@@ -729,7 +729,7 @@ static int vt8623_pci_probe(struct pci_d

     vga_res.flags = IORESOURCE_IO;

-    pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
+    pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);

     par->state.vgabase = (void __iomem *) vga_res.start;
