Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3HEUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:09 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50978 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3HEUmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:55 -0400
Message-ID: <5e7070022f78c3224fc7aba4dc82d999c946a680.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 09/20] tile PCI RC: support I/O space access
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To enable this functionality, configure CONFIG_TILE_PCI_IO.  Without
this flag, the kernel still assigns I/O address ranges to the
devices, but no TRIO resource and mapping support is provided.

We assign disjoint I/O address ranges to separate PCIe domains.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig           |  10 ++++
 arch/tile/include/asm/io.h  | 126 +++++++++++++++++++++++++++++++++++++++----
 arch/tile/include/asm/pci.h |  11 +++-
 arch/tile/kernel/pci_gx.c   | 128 +++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 257 insertions(+), 18 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 24565a7..bfff769 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -396,6 +396,16 @@ config NO_IOMEM
 config NO_IOPORT
 	def_bool !PCI
 
+config TILE_PCI_IO
+	bool "PCI I/O space support"
+	default n
+	depends on PCI
+	depends on TILEGX
+	---help---
+	  Enable PCI I/O space support on TILEGx. Since the PCI I/O space
+	  is used by few modern PCIe endpoint devices, its support is disabled
+	  by default to save the TRIO PIO Region resource for other purposes.
+
 source "drivers/pci/Kconfig"
 
 config TILE_USB
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index 3167291..73b319e 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -19,7 +19,8 @@
 #include <linux/bug.h>
 #include <asm/page.h>
 
-#define IO_SPACE_LIMIT 0xfffffffful
+/* Maximum PCI I/O space address supported. */
+#define IO_SPACE_LIMIT 0xffffffff
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
@@ -281,8 +282,108 @@ static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
 
 #endif
 
+#if CHIP_HAS_MMIO() && defined(CONFIG_TILE_PCI_IO)
+
+static inline u8 inb(unsigned long addr)
+{
+	return readb((volatile void __iomem *) addr);
+}
+
+static inline u16 inw(unsigned long addr)
+{
+	return readw((volatile void __iomem *) addr);
+}
+
+static inline u32 inl(unsigned long addr)
+{
+	return readl((volatile void __iomem *) addr);
+}
+
+static inline void outb(u8 b, unsigned long addr)
+{
+	writeb(b, (volatile void __iomem *) addr);
+}
+
+static inline void outw(u16 b, unsigned long addr)
+{
+	writew(b, (volatile void __iomem *) addr);
+}
+
+static inline void outl(u32 b, unsigned long addr)
+{
+	writel(b, (volatile void __iomem *) addr);
+}
+
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u8 *buf = buffer;
+		do {
+			u8 x = inb(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u16 *buf = buffer;
+		do {
+			u16 x = inw(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	if (count) {
+		u32 *buf = buffer;
+		do {
+			u32 x = inl(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u8 *buf = buffer;
+		do {
+			outb(*buf++, addr);
+		} while (--count);
+	}
+}
+
+static inline void outsw(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u16 *buf = buffer;
+		do {
+			outw(*buf++, addr);
+		} while (--count);
+	}
+}
+
+static inline void outsl(unsigned long addr, const void *buffer, int count)
+{
+	if (count) {
+		const u32 *buf = buffer;
+		do {
+			outl(*buf++, addr);
+		} while (--count);
+	}
+}
+
+extern void __iomem *ioport_map(unsigned long port, unsigned int len);
+extern void ioport_unmap(void __iomem *addr);
+
+#else
+
 /*
- * The Tile architecture does not support IOPORT, even with PCI.
+ * The TilePro architecture does not support IOPORT, even with PCI.
  * Unfortunately we can't yet simply not declare these methods,
  * since some generic code that compiles into the kernel, but
  * we never run, uses them unconditionally.
@@ -290,7 +391,12 @@ static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
 
 static inline long ioport_panic(void)
 {
+#ifdef __tilegx__
+	panic("PCI IO space support is disabled. Configure the kernel with"
+	      " CONFIG_TILE_PCI_IO to enable it");
+#else
 	panic("inb/outb and friends do not exist on tile");
+#endif
 	return 0;
 }
 
@@ -335,13 +441,6 @@ static inline void outl(u32 b, unsigned long addr)
 	ioport_panic();
 }
 
-#define inb_p(addr)	inb(addr)
-#define inw_p(addr)	inw(addr)
-#define inl_p(addr)	inl(addr)
-#define outb_p(x, addr)	outb((x), (addr))
-#define outw_p(x, addr)	outw((x), (addr))
-#define outl_p(x, addr)	outl((x), (addr))
-
 static inline void insb(unsigned long addr, void *buffer, int count)
 {
 	ioport_panic();
@@ -372,6 +471,15 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 	ioport_panic();
 }
 
+#endif /* CHIP_HAS_MMIO() && defined(CONFIG_TILE_PCI_IO) */
+
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+#define outb_p(x, addr)	outb((x), (addr))
+#define outw_p(x, addr)	outw((x), (addr))
+#define outl_p(x, addr)	outl((x), (addr))
+
 #define ioread16be(addr)	be16_to_cpu(ioread16(addr))
 #define ioread32be(addr)	be32_to_cpu(ioread32(addr))
 #define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index cd10e65..9cf5308 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -144,6 +144,10 @@ struct pci_controller {
 
 	int pio_mem_index;	/* PIO region index for memory access */
 
+#ifdef CONFIG_TILE_PCI_IO
+	int pio_io_index;	/* PIO region index for I/O space access */
+#endif
+
 	/*
 	 * Mem-Map regions for all the memory controllers so that Linux can
 	 * map all of its physical memory space to the PCI bus.
@@ -153,6 +157,10 @@ struct pci_controller {
 	int index;		/* PCI domain number */
 	struct pci_bus *root_bus;
 
+	/* PCI I/O space resource for this controller. */
+	struct resource io_space;
+	char io_space_name[32];
+
 	/* PCI memory space resource for this controller. */
 	struct resource mem_space;
 	char mem_space_name[32];
@@ -210,7 +218,8 @@ static inline int pcibios_assign_all_busses(void)
 }
 
 #define PCIBIOS_MIN_MEM		0
-#define PCIBIOS_MIN_IO		0
+/* Minimum PCI I/O address, starting at the page boundary. */
+#define PCIBIOS_MIN_IO		PAGE_SIZE
 
 /* Use any cpu for PCI. */
 #define cpumask_of_pcibus(bus) cpu_online_mask
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index bf8c69d..fde3589 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -77,6 +77,9 @@ static int rc_delay[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 /* Default number of seconds that the PCIe RC port probe can be delayed. */
 #define DEFAULT_RC_DELAY	10
 
+/* The PCI I/O space size in each PCI domain. */
+#define IO_SPACE_SIZE		0x10000
+
 /* Array of the PCIe ports configuration info obtained from the BIB. */
 struct pcie_port_property pcie_ports[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 
@@ -421,6 +424,17 @@ out:
 		controller->index = i;
 		controller->ops = &tile_cfg_ops;
 
+		controller->io_space.start = PCIBIOS_MIN_IO +
+			(i * IO_SPACE_SIZE);
+		controller->io_space.end = controller->io_space.start +
+			IO_SPACE_SIZE - 1;
+		BUG_ON(controller->io_space.end > IO_SPACE_LIMIT);
+		controller->io_space.flags = IORESOURCE_IO;
+		snprintf(controller->io_space_name,
+			 sizeof(controller->io_space_name),
+			 "PCI I/O domain %d", i);
+		controller->io_space.name = controller->io_space_name;
+
 		/*
 		 * The PCI memory resource is located above the PA space.
 		 * For every host bridge, the BAR window or the MMIO aperture
@@ -861,17 +875,16 @@ int __init pcibios_init(void)
 		/*
 		 * The PCI memory resource is located above the PA space.
 		 * The memory range for the PCI root bus should not overlap
-		 * with the physical RAM
+		 * with the physical RAM.
 		 */
 		pci_add_resource_offset(&resources, &controller->mem_space,
 					controller->mem_offset);
-
+		pci_add_resource(&resources, &controller->io_space);
 		controller->first_busno = next_busno;
 		bus = pci_scan_root_bus(NULL, next_busno, controller->ops,
 					controller, &resources);
 		controller->root_bus = bus;
 		next_busno = bus->busn_res.end + 1;
-
 	}
 
 	/* Do machine dependent PCI interrupt routing */
@@ -915,9 +928,9 @@ int __init pcibios_init(void)
 				pci_controllers[i].mem_resources[0] =
 					*next_bus->resource[0];
 				pci_controllers[i].mem_resources[1] =
-					 *next_bus->resource[1];
+					*next_bus->resource[1];
 				pci_controllers[i].mem_resources[2] =
-					 *next_bus->resource[2];
+					*next_bus->resource[2];
 
 				break;
 			}
@@ -967,6 +980,39 @@ int __init pcibios_init(void)
 			continue;
 		}
 
+#ifdef CONFIG_TILE_PCI_IO
+		/*
+		 * Alloc a PIO region for PCI I/O space access for each RC port.
+		 */
+		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
+		if (ret < 0) {
+			pr_err("PCI: I/O PIO alloc failure on TRIO %d mac %d, "
+				"give up\n", controller->trio_index,
+				controller->mac);
+
+			continue;
+		}
+
+		controller->pio_io_index = ret;
+
+		/*
+		 * For PIO IO, the bus_address_hi parameter is hard-coded 0
+		 * because PCI I/O address space is 32-bit.
+		 */
+		ret = gxio_trio_init_pio_region_aux(trio_context,
+						    controller->pio_io_index,
+						    controller->mac,
+						    0,
+						    HV_TRIO_PIO_FLAG_IO_SPACE);
+		if (ret < 0) {
+			pr_err("PCI: I/O PIO init failure on TRIO %d mac %d, "
+				"give up\n", controller->trio_index,
+				controller->mac);
+
+			continue;
+		}
+#endif
+
 		/*
 		 * Configure a Mem-Map region for each memory controller so
 		 * that Linux can map all of its PA space to the PCI bus.
@@ -1052,8 +1098,7 @@ char *pcibios_setup(char *str)
 
 /*
  * Enable memory address decoding, as appropriate, for the
- * device described by the 'dev' struct. The I/O decoding
- * is disabled, though the TILE-Gx supports I/O addressing.
+ * device described by the 'dev' struct.
  *
  * This is called from the generic PCI layer, and can be called
  * for bridges or endpoints.
@@ -1134,10 +1179,77 @@ got_it:
 	 * We need to keep the PCI bus address's in-page offset in the VA.
 	 */
 	return iorpc_ioremap(trio_fd, offset, size) +
-		(phys_addr & (PAGE_SIZE - 1));
+		(start & (PAGE_SIZE - 1));
 }
 EXPORT_SYMBOL(ioremap);
 
+#ifdef CONFIG_TILE_PCI_IO
+/* Map a PCI I/O address into VA space. */
+void __iomem *ioport_map(unsigned long port, unsigned int size)
+{
+	struct pci_controller *controller = NULL;
+	resource_size_t bar_start;
+	resource_size_t bar_end;
+	resource_size_t offset;
+	resource_size_t start;
+	resource_size_t end;
+	int trio_fd;
+	int i;
+
+	start = port;
+	end = port + size - 1;
+
+	/*
+	 * In the following, each PCI controller's mem_resources[0]
+	 * represents its PCI I/O resource. By searching port in each
+	 * controller's mem_resources[0], we can determine the controller
+	 * that should accept the PCI I/O access.
+	 */
+
+	for (i = 0; i < num_rc_controllers; i++) {
+		/*
+		 * Skip controllers that are not properly initialized or
+		 * have down links.
+		 */
+		if (pci_controllers[i].root_bus == NULL)
+			continue;
+
+		bar_start = pci_controllers[i].mem_resources[0].start;
+		bar_end = pci_controllers[i].mem_resources[0].end;
+
+		if ((start >= bar_start) && (end <= bar_end)) {
+
+			controller = &pci_controllers[i];
+
+			goto got_it;
+		}
+	}
+
+	if (controller == NULL)
+		return NULL;
+
+got_it:
+	trio_fd = controller->trio->fd;
+
+	/* Convert the resource start to the bus address offset. */
+	port -= controller->io_space.start;
+
+	offset = HV_TRIO_PIO_OFFSET(controller->pio_io_index) + port;
+
+	/*
+	 * We need to keep the PCI bus address's in-page offset in the VA.
+	 */
+	return iorpc_ioremap(trio_fd, offset, size) + (port & (PAGE_SIZE - 1));
+}
+EXPORT_SYMBOL(ioport_map);
+
+void ioport_unmap(void __iomem *addr)
+{
+	iounmap(addr);
+}
+EXPORT_SYMBOL(ioport_unmap);
+#endif
+
 void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 {
 	iounmap(addr);
-- 
1.8.3.1

