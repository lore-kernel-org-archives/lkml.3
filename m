Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbaGCV1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:27:41 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:54680 "HELO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753955AbaGCV1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:27:38 -0400
From: Tanmay Inamdar <tinamdar@apm.com>
To: linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: galak@codeaurora.org, liviu.dudau@arm.com,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH] arm64: PCI(e) arch support
Date: Thu,  3 Jul 2014 14:27:56 -0700
Message-Id: <1404422876-1160-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reposting on request of several people since previously posted one was
corrupted.

This patch adds the arch support for PCI(e) for arm64. The files
added or modified in this patch are based on PCI(e) support in
32bit arm.

Please note that this patch is just for the reference. Liviu Dudau from ARM
has posted his v8 series of patch to support PCIe in arm64.

The patch will apply against 3.13 Linux Kernel

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/arm64/Kconfig               |  19 ++
 arch/arm64/include/asm/dma.h     |  18 +
 arch/arm64/include/asm/io.h      |  19 +-
 arch/arm64/include/asm/pci.h     |  74 +++++
 arch/arm64/include/asm/pcibios.h |  98 ++++++
 arch/arm64/kernel/Makefile       |   1 +
 arch/arm64/kernel/pcibios.c      | 689 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/Makefile           |   2 +-
 arch/arm64/mm/iomap.c            |  31 ++
 arch/arm64/mm/ioremap.c          |  14 +
 drivers/pci/Makefile             |   1 +
 11 files changed, 964 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/dma.h
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/include/asm/pcibios.h
 create mode 100644 arch/arm64/kernel/pcibios.c
 create mode 100644 arch/arm64/mm/iomap.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d4dd22..f5e75d2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -113,6 +113,8 @@ config ARCH_VEXPRESS
 	  Express).
 
 config ARCH_XGENE
+	select PCI
+	select PCI_DOMAINS
 	bool "AppliedMicro X-Gene SOC Family"
 	help
 	  This enables support for AppliedMicro X-Gene SOC Family
@@ -124,6 +126,23 @@ menu "Bus support"
 config ARM_AMBA
 	bool
 
+config PCI
+	bool "PCI support"
+	help
+	  Find out whether you have a PCI motherboard. PCI is the name of a
+	  bus system, i.e. the way the CPU talks to the other stuff inside
+	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+	  VESA. If you have PCI, say Y, otherwise N.
+
+config PCI_DOMAINS
+	bool
+	depends on PCI
+
+config PCI_SYSCALL
+	def_bool PCI
+
+source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
 endmenu
 
 menu "Kernel Features"
diff --git a/arch/arm64/include/asm/dma.h b/arch/arm64/include/asm/dma.h
new file mode 100644
index 0000000..c597e2a
--- /dev/null
+++ b/arch/arm64/include/asm/dma.h
@@ -0,0 +1,18 @@
+/*
+ * Based on linux/arch/arm/include/asm/dma.h
+ */
+#ifndef __ASM_ARM_DMA_H
+#define __ASM_ARM_DMA_H
+
+/*
+ * This is the maximum virtual address which can be DMA'd from.
+ */
+#define MAX_DMA_ADDRESS	(~0ULL)
+
+#ifdef CONFIG_PCI
+extern int isa_dma_bridge_buggy;
+#else
+#define isa_dma_bridge_buggy    (0)
+#endif
+
+#endif /* __ASM_ARM_DMA_H */
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4cc813e..eb3ebe1 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -118,10 +118,27 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define writeq(v,c)		({ __iowmb(); writeq_relaxed((v),(c)); })
 
 /*
+ * A typesafe __io() helper
+ */
+static inline void __iomem *__typesafe_io(unsigned long addr)
+{
+	return (void __iomem *)addr;
+}
+
+/*
  *  I/O port access primitives.
  */
-#define IO_SPACE_LIMIT		0xffff
 #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_2M))
+#if defined(CONFIG_PCI)
+#define IO_SPACE_LIMIT  ((resource_size_t)0xffffffff)
+#define __io(a)         __typesafe_io((unsigned long)PCI_IOBASE + \
+				      ((a) & IO_SPACE_LIMIT))
+#else
+#define __io(a)         __typesafe_io((a) & IO_SPACE_LIMIT)
+#endif
+extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomem *addr);
+extern int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr);
 
 static inline u8 inb(unsigned long addr)
 {
diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..2233651
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,74 @@
+/*
+ * Based on arch/arm/include/asm/pci.h
+ */
+#ifndef ASMARM_PCI_H
+#define ASMARM_PCI_H
+
+#ifdef __KERNEL__
+#include <asm-generic/pci-dma-compat.h>
+#include <asm-generic/pci-bridge.h>
+
+#include <asm/pcibios.h>	/* for pci_sys_data */
+
+extern unsigned long pcibios_min_io;
+#define PCIBIOS_MIN_IO pcibios_min_io
+extern unsigned long pcibios_min_mem;
+#define PCIBIOS_MIN_MEM pcibios_min_mem
+
+static inline int pcibios_assign_all_busses(void)
+{
+	return pci_has_flag(PCI_REASSIGN_ALL_RSRC);
+}
+
+#ifdef CONFIG_PCI_DOMAINS
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_sys_data *root = bus->sysdata;
+
+	return root->domain;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+#endif /* CONFIG_PCI_DOMAINS */
+
+static inline void pcibios_penalize_isa_irq(int irq, int active)
+{
+	/* We don't do dynamic PCI IRQ allocation */
+}
+
+/*
+ * The PCI address space does equal the physical memory address space.
+ * The networking and block device layers use this boolean for bounce
+ * buffer decisions.
+ */
+#define PCI_DMA_BUS_IS_PHYS     (1)
+
+#ifdef CONFIG_PCI
+static inline void pci_dma_burst_advice(struct pci_dev *pdev,
+					enum pci_dma_burst_strategy *strat,
+					unsigned long *strategy_parameter)
+{
+	*strat = PCI_DMA_BURST_INFINITY;
+	*strategy_parameter = ~0UL;
+}
+#endif
+
+#define HAVE_PCI_MMAP
+extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+			       enum pci_mmap_state mmap_state,
+			       int write_combine);
+
+/*
+ * Dummy implementation; always return 0.
+ */
+static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
+{
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif
diff --git a/arch/arm64/include/asm/pcibios.h b/arch/arm64/include/asm/pcibios.h
new file mode 100644
index 0000000..4eda8e2
--- /dev/null
+++ b/arch/arm64/include/asm/pcibios.h
@@ -0,0 +1,98 @@
+/*
+ *  Based on arch/arm/include/asm/mach/pci.h
+ *
+ *  Copyright (C) 2000 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_PCIBIOS_H
+#define __ASM_PCIBIOS_H
+
+#include <linux/ioport.h>
+
+struct pci_sys_data;
+struct pci_ops;
+struct pci_bus;
+struct device;
+
+struct hw_pci {
+#ifdef CONFIG_PCI_DOMAINS
+	int domain;
+#endif
+	struct pci_ops *ops;
+	int nr_controllers;
+	void **private_data;
+	int (*setup) (int nr, struct pci_sys_data *);
+	struct pci_bus *(*scan) (int nr, struct pci_sys_data *);
+	void (*preinit) (void);
+	void (*postinit) (void);
+	 u8(*swizzle) (struct pci_dev *dev, u8 *pin);
+	int (*map_irq) (const struct pci_dev *dev, u8 slot, u8 pin);
+	 resource_size_t(*align_resource) (struct pci_dev *dev,
+					   const struct resource *res,
+					   resource_size_t start,
+					   resource_size_t size,
+					   resource_size_t align);
+	void (*add_bus) (struct pci_bus *bus);
+	void (*remove_bus) (struct pci_bus *bus);
+};
+
+/*
+ * Per-controller structure
+ */
+struct pci_sys_data {
+#ifdef CONFIG_PCI_DOMAINS
+	int domain;
+#endif
+	struct list_head node;
+	int busnr;		/* primary bus number                   */
+	u64 mem_offset;		/* bus->cpu memory mapping offset       */
+	unsigned long io_offset;	/* bus->cpu IO mapping offset   */
+	struct pci_bus *bus;	/* PCI bus                              */
+	struct list_head resources;	/* root bus resources (apertures) */
+	struct resource io_res;
+	char io_res_name[12];
+	/* Bridge swizzling                     */
+	 u8(*swizzle) (struct pci_dev *, u8 *);
+	/* IRQ mapping                          */
+	int (*map_irq) (const struct pci_dev *, u8, u8);
+	/* Resource alignement requirements     */
+	 resource_size_t(*align_resource) (struct pci_dev *dev,
+					   const struct resource *res,
+					   resource_size_t start,
+					   resource_size_t size,
+					   resource_size_t align);
+	void (*add_bus) (struct pci_bus *bus);
+	void (*remove_bus) (struct pci_bus *bus);
+	void *private_data;	/* platform controller private data     */
+};
+
+/*
+ * Call this with your hw_pci struct to initialise the PCI system.
+ */
+void pci_common_init_dev(struct device *, struct hw_pci *);
+
+/*
+ * Compatibility wrapper for older platforms that do not care about
+ * passing the parent device.
+ */
+static inline void pci_common_init(struct hw_pci *hw)
+{
+	pci_common_init_dev(NULL, hw);
+}
+
+/*
+ * Setup early fixed I/O mapping.
+ */
+#if defined(CONFIG_PCI)
+extern void pci_map_io_early(unsigned long pfn);
+#else
+static inline void pci_map_io_early(unsigned long pfn)
+{
+}
+#endif
+
+#endif /* __ASM_PCIBIOS_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 5ba2fd4..9e9c208 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -19,6 +19,7 @@ arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
+obj-$(CONFIG_PCI)			+= pcibios.o
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
diff --git a/arch/arm64/kernel/pcibios.c b/arch/arm64/kernel/pcibios.c
new file mode 100644
index 0000000..810a408
--- /dev/null
+++ b/arch/arm64/kernel/pcibios.c
@@ -0,0 +1,689 @@
+/*
+ *  Based on linux/arch/arm/kernel/bios32.c
+ *
+ *  PCI bios-type initialisation for PCI machines
+ *
+ *  Bits taken from various places.
+ */
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+
+static int debug_pci;
+
+/*
+ * We can't use pci_find_device() here since we are
+ * called from interrupt context.
+ */
+static void pcibios_bus_report_status(struct pci_bus *bus, u_int status_mask,
+				      int warn)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u16 status;
+
+		/*
+		 * ignore host bridge - we handle
+		 * that separately
+		 */
+		if (dev->bus->number == 0 && dev->devfn == 0)
+			continue;
+
+		pci_read_config_word(dev, PCI_STATUS, &status);
+		if (status == 0xffff)
+			continue;
+
+		if ((status & status_mask) == 0)
+			continue;
+
+		/* clear the status errors */
+		pci_write_config_word(dev, PCI_STATUS, status & status_mask);
+
+		if (warn)
+			printk("(%s: %04X) ", pci_name(dev), status);
+	}
+
+	list_for_each_entry(dev, &bus->devices, bus_list)
+	    if (dev->subordinate)
+		pcibios_bus_report_status(dev->subordinate, status_mask, warn);
+}
+
+void pcibios_report_status(u_int status_mask, int warn)
+{
+	struct list_head *l;
+
+	list_for_each(l, &pci_root_buses) {
+		struct pci_bus *bus = pci_bus_b(l);
+
+		pcibios_bus_report_status(bus, status_mask, warn);
+	}
+}
+
+/*
+ * We don't use this to fix the device, but initialisation of it.
+ * It's not the correct use for this, but it works.
+ * Note that the arbiter/ISA bridge appears to be buggy, specifically in
+ * the following area:
+ * 1. park on CPU
+ * 2. ISA bridge ping-pong
+ * 3. ISA bridge master handling of target RETRY
+ *
+ * Bug 3 is responsible for the sound DMA grinding to a halt.  We now
+ * live with bug 2.
+ */
+static void pci_fixup_83c553(struct pci_dev *dev)
+{
+	/*
+	 * Set memory region to start at address 0, and enable IO
+	 */
+	pci_write_config_dword(dev, PCI_BASE_ADDRESS_0,
+			       PCI_BASE_ADDRESS_SPACE_MEMORY);
+	pci_write_config_word(dev, PCI_COMMAND, PCI_COMMAND_IO);
+
+	dev->resource[0].end -= dev->resource[0].start;
+	dev->resource[0].start = 0;
+
+	/*
+	 * All memory requests from ISA to be channelled to PCI
+	 */
+	pci_write_config_byte(dev, 0x48, 0xff);
+
+	/*
+	 * Enable ping-pong on bus master to ISA bridge transactions.
+	 * This improves the sound DMA substantially.  The fixed
+	 * priority arbiter also helps (see below).
+	 */
+	pci_write_config_byte(dev, 0x42, 0x01);
+
+	/*
+	 * Enable PCI retry
+	 */
+	pci_write_config_byte(dev, 0x40, 0x22);
+
+	/*
+	 * We used to set the arbiter to "park on last master" (bit
+	 * 1 set), but unfortunately the CyberPro does not park the
+	 * bus.  We must therefore park on CPU.  Unfortunately, this
+	 * may trigger yet another bug in the 553.
+	 */
+	pci_write_config_byte(dev, 0x83, 0x02);
+
+	/*
+	 * Make the ISA DMA request lowest priority, and disable
+	 * rotating priorities completely.
+	 */
+	pci_write_config_byte(dev, 0x80, 0x11);
+	pci_write_config_byte(dev, 0x81, 0x00);
+
+	/*
+	 * Route INTA input to IRQ 11, and set IRQ11 to be level
+	 * sensitive.
+	 */
+	pci_write_config_word(dev, 0x44, 0xb000);
+	outb(0x08, 0x4d1);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_83C553,
+			 pci_fixup_83c553);
+
+static void pci_fixup_unassign(struct pci_dev *dev)
+{
+	dev->resource[0].end -= dev->resource[0].start;
+	dev->resource[0].start = 0;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WINBOND2, PCI_DEVICE_ID_WINBOND2_89C940F,
+			 pci_fixup_unassign);
+
+/*
+ * Prevent the PCI layer from seeing the resources allocated to this device
+ * if it is the host bridge by marking it as such.  These resources are of
+ * no consequence to the PCI layer (they are handled elsewhere).
+ */
+static void pci_fixup_dec21285(struct pci_dev *dev)
+{
+	int i;
+
+	if (dev->devfn == 0) {
+		dev->class &= 0xff;
+		dev->class |= PCI_CLASS_BRIDGE_HOST << 8;
+		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+			dev->resource[i].start = 0;
+			dev->resource[i].end = 0;
+			dev->resource[i].flags = 0;
+		}
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_DEC, PCI_DEVICE_ID_DEC_21285,
+			 pci_fixup_dec21285);
+
+/*
+ * PCI IDE controllers use non-standard I/O port decoding, respect it.
+ */
+static void pci_fixup_ide_bases(struct pci_dev *dev)
+{
+	struct resource *r;
+	int i;
+
+	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
+		return;
+
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		r = dev->resource + i;
+		if ((r->start & ~0x80) == 0x374) {
+			r->start |= 2;
+			r->end = r->start;
+		}
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_ide_bases);
+
+/*
+ * Put the DEC21142 to sleep
+ */
+static void pci_fixup_dec21142(struct pci_dev *dev)
+{
+	pci_write_config_dword(dev, 0x40, 0x80000000);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_DEC, PCI_DEVICE_ID_DEC_21142,
+			 pci_fixup_dec21142);
+
+/*
+ * The CY82C693 needs some rather major fixups to ensure that it does
+ * the right thing.  Idea from the Alpha people, with a few additions.
+ *
+ * We ensure that the IDE base registers are set to 1f0/3f4 for the
+ * primary bus, and 170/374 for the secondary bus.  Also, hide them
+ * from the PCI subsystem view as well so we won't try to perform
+ * our own auto-configuration on them.
+ *
+ * In addition, we ensure that the PCI IDE interrupts are routed to
+ * IRQ 14 and IRQ 15 respectively.
+ *
+ * The above gets us to a point where the IDE on this device is
+ * functional.  However, The CY82C693U _does not work_ in bus
+ * master mode without locking the PCI bus solid.
+ */
+static void pci_fixup_cy82c693(struct pci_dev *dev)
+{
+	if ((dev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
+		u32 base0, base1;
+
+		if (dev->class & 0x80) {	/* primary */
+			base0 = 0x1f0;
+			base1 = 0x3f4;
+		} else {	/* secondary */
+			base0 = 0x170;
+			base1 = 0x374;
+		}
+
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0,
+				       base0 | PCI_BASE_ADDRESS_SPACE_IO);
+		pci_write_config_dword(dev, PCI_BASE_ADDRESS_1,
+				       base1 | PCI_BASE_ADDRESS_SPACE_IO);
+
+		dev->resource[0].start = 0;
+		dev->resource[0].end = 0;
+		dev->resource[0].flags = 0;
+
+		dev->resource[1].start = 0;
+		dev->resource[1].end = 0;
+		dev->resource[1].flags = 0;
+	} else if (PCI_FUNC(dev->devfn) == 0) {
+		/*
+		 * Setup IDE IRQ routing.
+		 */
+		pci_write_config_byte(dev, 0x4b, 14);
+		pci_write_config_byte(dev, 0x4c, 15);
+
+		/*
+		 * Disable FREQACK handshake, enable USB.
+		 */
+		pci_write_config_byte(dev, 0x4d, 0x41);
+
+		/*
+		 * Enable PCI retry, and PCI post-write buffer.
+		 */
+		pci_write_config_byte(dev, 0x44, 0x17);
+
+		/*
+		 * Enable ISA master and DMA post write buffering.
+		 */
+		pci_write_config_byte(dev, 0x45, 0x03);
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CONTAQ, PCI_DEVICE_ID_CONTAQ_82C693,
+			 pci_fixup_cy82c693);
+
+static void pci_fixup_it8152(struct pci_dev *dev)
+{
+	int i;
+	/* fixup for ITE 8152 devices */
+	/* FIXME: add defines for class 0x68000 and 0x80103 */
+	if ((dev->class >> 8) == PCI_CLASS_BRIDGE_HOST ||
+	    dev->class == 0x68000 || dev->class == 0x80103) {
+		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+			dev->resource[i].start = 0;
+			dev->resource[i].end = 0;
+			dev->resource[i].flags = 0;
+		}
+	}
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ITE, PCI_DEVICE_ID_ITE_8152,
+			 pci_fixup_it8152);
+
+/*
+ * If the bus contains any of these devices, then we must not turn on
+ * parity checking of any kind.  Currently this is CyberPro 20x0 only.
+ */
+static inline int pdev_bad_for_parity(struct pci_dev *dev)
+{
+	return ((dev->vendor == PCI_VENDOR_ID_INTERG &&
+		 (dev->device == PCI_DEVICE_ID_INTERG_2000 ||
+		  dev->device == PCI_DEVICE_ID_INTERG_2010)) ||
+		(dev->vendor == PCI_VENDOR_ID_ITE &&
+		 dev->device == PCI_DEVICE_ID_ITE_8152));
+
+}
+
+/*
+ * pcibios_fixup_bus - Called after each bus is probed,
+ * but before its children are examined.
+ */
+void pcibios_fixup_bus(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+	u16 features =
+	    PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FAST_BACK;
+
+	/*
+	 * Walk the devices on this bus, working out what we can
+	 * and can't support.
+	 */
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u16 status;
+
+		pci_read_config_word(dev, PCI_STATUS, &status);
+
+		/*
+		 * If any device on this bus does not support fast back
+		 * to back transfers, then the bus as a whole is not able
+		 * to support them.  Having fast back to back transfers
+		 * on saves us one PCI cycle per transaction.
+		 */
+		if (!(status & PCI_STATUS_FAST_BACK))
+			features &= ~PCI_COMMAND_FAST_BACK;
+
+		if (pdev_bad_for_parity(dev))
+			features &= ~(PCI_COMMAND_SERR | PCI_COMMAND_PARITY);
+
+		switch (dev->class >> 8) {
+		case PCI_CLASS_BRIDGE_PCI:
+			pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &status);
+			status |=
+			    PCI_BRIDGE_CTL_PARITY | PCI_BRIDGE_CTL_MASTER_ABORT;
+			status &=
+			    ~(PCI_BRIDGE_CTL_BUS_RESET |
+			      PCI_BRIDGE_CTL_FAST_BACK);
+			pci_write_config_word(dev, PCI_BRIDGE_CONTROL, status);
+			break;
+
+		case PCI_CLASS_BRIDGE_CARDBUS:
+			pci_read_config_word(dev, PCI_CB_BRIDGE_CONTROL,
+					     &status);
+			status |=
+			    PCI_CB_BRIDGE_CTL_PARITY |
+			    PCI_CB_BRIDGE_CTL_MASTER_ABORT;
+			pci_write_config_word(dev, PCI_CB_BRIDGE_CONTROL,
+					      status);
+			break;
+		}
+	}
+
+	/*
+	 * Now walk the devices again, this time setting them up.
+	 */
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u16 cmd;
+
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		cmd |= features;
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+
+		pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE,
+				      L1_CACHE_BYTES >> 2);
+	}
+
+	/*
+	 * Propagate the flags to the PCI bridge.
+	 */
+	if (bus->self && bus->self->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+		if (features & PCI_COMMAND_FAST_BACK)
+			bus->bridge_ctl |= PCI_BRIDGE_CTL_FAST_BACK;
+		if (features & PCI_COMMAND_PARITY)
+			bus->bridge_ctl |= PCI_BRIDGE_CTL_PARITY;
+	}
+
+	/*
+	 * Report what we did for this bus
+	 */
+	printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
+	       bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
+}
+EXPORT_SYMBOL(pcibios_fixup_bus);
+
+void pcibios_add_bus(struct pci_bus *bus)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	if (sys->add_bus)
+		sys->add_bus(bus);
+}
+
+void pcibios_remove_bus(struct pci_bus *bus)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	if (sys->remove_bus)
+		sys->remove_bus(bus);
+}
+
+/*
+ * Swizzle the device pin each time we cross a bridge.  If a platform does
+ * not provide a swizzle function, we perform the standard PCI swizzling.
+ *
+ * The default swizzling walks up the bus tree one level at a time, applying
+ * the standard swizzle function at each step, stopping when it finds the PCI
+ * root bus.  This will return the slot number of the bridge device on the
+ * root bus and the interrupt pin on that device which should correspond
+ * with the downstream device interrupt.
+ *
+ * Platforms may override this, in which case the slot and pin returned
+ * depend entirely on the platform code.  However, please note that the
+ * PCI standard swizzle is implemented on plug-in cards and Cardbus based
+ * PCI extenders, so it can not be ignored.
+ */
+static u8 pcibios_swizzle(struct pci_dev *dev, u8 *pin)
+{
+	struct pci_sys_data *sys = dev->sysdata;
+	int slot, oldpin = *pin;
+
+	if (sys->swizzle)
+		slot = sys->swizzle(dev, pin);
+	else
+		slot = pci_common_swizzle(dev, pin);
+
+	if (debug_pci)
+		printk("PCI: %s swizzling pin %d => pin %d slot %d\n",
+			pci_name(dev), oldpin, *pin, slot);
+
+	return slot;
+}
+
+/*
+ * Map a slot/pin to an IRQ.
+ */
+static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+{
+	struct pci_sys_data *sys = dev->sysdata;
+	int irq = -1;
+
+	if (sys->map_irq)
+		irq = sys->map_irq(dev, slot, pin);
+
+	if (debug_pci)
+		printk("PCI: %s mapping slot %d pin %d => irq %d\n",
+			pci_name(dev), slot, pin, irq);
+
+	return irq;
+}
+
+static int pcibios_init_resources(int busnr, struct pci_sys_data *sys)
+{
+	int ret;
+	struct pci_host_bridge_window *window;
+
+	if (list_empty(&sys->resources)) {
+		pci_add_resource_offset(&sys->resources,
+					&iomem_resource, sys->mem_offset);
+	}
+
+	list_for_each_entry(window, &sys->resources, list) {
+		if (resource_type(window->res) == IORESOURCE_IO)
+			return 0;
+	}
+
+	sys->io_res.start = (busnr * SZ_64K) ? : pcibios_min_io;
+	sys->io_res.end = (busnr + 1) * SZ_64K - 1;
+	sys->io_res.flags = IORESOURCE_IO;
+	sys->io_res.name = sys->io_res_name;
+	sprintf(sys->io_res_name, "PCI%d I/O", busnr);
+
+	ret = request_resource(&ioport_resource, &sys->io_res);
+	if (ret) {
+		pr_err("PCI: unable to allocate I/O port region (%d)\n", ret);
+		return ret;
+	}
+	pci_add_resource_offset(&sys->resources, &sys->io_res, sys->io_offset);
+
+	return 0;
+}
+
+static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
+			    struct list_head *head)
+{
+	struct pci_sys_data *sys = NULL;
+	int ret;
+	int nr, busnr;
+
+	for (nr = busnr = 0; nr < hw->nr_controllers; nr++) {
+		sys = kzalloc(sizeof(struct pci_sys_data), GFP_KERNEL);
+		if (!sys)
+			panic("PCI: unable to allocate sys data!");
+
+#ifdef CONFIG_PCI_DOMAINS
+		sys->domain = hw->domain;
+#endif
+		sys->busnr = busnr;
+		sys->swizzle = hw->swizzle;
+		sys->map_irq = hw->map_irq;
+		sys->align_resource = hw->align_resource;
+		sys->add_bus = hw->add_bus;
+		sys->remove_bus = hw->remove_bus;
+		INIT_LIST_HEAD(&sys->resources);
+
+		if (hw->private_data)
+			sys->private_data = hw->private_data[nr];
+
+		ret = hw->setup(nr, sys);
+
+		if (ret > 0) {
+			ret = pcibios_init_resources(nr, sys);
+			if (ret) {
+				kfree(sys);
+				break;
+			}
+
+			if (hw->scan)
+				sys->bus = hw->scan(nr, sys);
+			else
+				sys->bus = pci_scan_root_bus(parent, sys->busnr,
+							     hw->ops, sys,
+							     &sys->resources);
+
+			if (!sys->bus)
+				panic("PCI: unable to scan bus!");
+
+			busnr = sys->bus->busn_res.end + 1;
+
+			list_add(&sys->node, head);
+		} else {
+			kfree(sys);
+			if (ret < 0)
+				break;
+		}
+	}
+}
+
+void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
+{
+	struct pci_sys_data *sys;
+	LIST_HEAD(head);
+
+	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
+	if (hw->preinit)
+		hw->preinit();
+	pcibios_init_hw(parent, hw, &head);
+	if (hw->postinit)
+		hw->postinit();
+
+	pci_fixup_irqs(pcibios_swizzle, pcibios_map_irq);
+
+	list_for_each_entry(sys, &head, node) {
+		struct pci_bus *bus = sys->bus;
+
+		if (!pci_has_flag(PCI_PROBE_ONLY)) {
+			/*
+			 * Size the bridge windows.
+			 */
+			pci_bus_size_bridges(bus);
+
+			/*
+			 * Assign resources.
+			 */
+			pci_bus_assign_resources(bus);
+		}
+
+		/*
+		 * Tell drivers about devices found.
+		 */
+		pci_bus_add_devices(bus);
+	}
+}
+
+#ifndef CONFIG_PCI_HOST_ITE8152
+void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+#endif
+
+char *__init pcibios_setup(char *str)
+{
+	if (!strcmp(str, "debug")) {
+		debug_pci = 1;
+		return NULL;
+	} else if (!strcmp(str, "firmware")) {
+		pci_add_flags(PCI_PROBE_ONLY);
+		return NULL;
+	}
+	return str;
+}
+
+/*
+ * From arch/i386/kernel/pci-i386.c:
+ *
+ * We need to avoid collisions with `mirrored' VGA ports
+ * and other strange ISA hardware, so we always want the
+ * addresses to be allocated in the 0x000-0x0ff region
+ * modulo 0x400.
+ *
+ * Why? Because some silly external IO cards only decode
+ * the low 10 bits of the IO address. The 0x00-0xff region
+ * is reserved for motherboard devices that decode all 16
+ * bits, so it's ok to allocate at, say, 0x2800-0x28ff,
+ * but we want to try to avoid allocating at 0x2900-0x2bff
+ * which might be mirrored at 0x0100-0x03ff..
+ */
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
+				       resource_size_t size,
+				       resource_size_t align)
+{
+	struct pci_dev *dev = data;
+	struct pci_sys_data *sys = dev->sysdata;
+	resource_size_t start = res->start;
+
+	if (res->flags & IORESOURCE_IO && start & 0x300)
+		start = (start + 0x3ff) & ~0x3ff;
+
+	start = (start + align - 1) & ~(align - 1);
+
+	if (sys->align_resource)
+		return sys->align_resource(dev, res, start, size, align);
+
+	return start;
+}
+
+/**
+ * pcibios_enable_device - Enable I/O and memory.
+ * @dev: PCI device to be enabled
+ */
+int pcibios_enable_device(struct pci_dev *dev, int mask)
+{
+	u16 cmd, old_cmd;
+	int idx;
+	struct resource *r;
+
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	old_cmd = cmd;
+	for (idx = 0; idx < 6; idx++) {
+		/* Only set up the requested stuff */
+		if (!(mask & (1 << idx)))
+			continue;
+
+		r = dev->resource + idx;
+		if (!r->start && r->end) {
+			printk(KERN_ERR "PCI: Device %s not available because"
+				" of resource collisions\n", pci_name(dev));
+			return -EINVAL;
+		}
+		if (r->flags & IORESOURCE_IO)
+			cmd |= PCI_COMMAND_IO;
+		if (r->flags & IORESOURCE_MEM)
+			cmd |= PCI_COMMAND_MEMORY;
+	}
+
+	/*
+	 * Bridges (eg, cardbus bridges) need to be fully enabled
+	 */
+	if ((dev->class >> 16) == PCI_BASE_CLASS_BRIDGE)
+		cmd |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY;
+
+	if (cmd != old_cmd) {
+		printk("PCI: enabling device %s (%04x -> %04x)\n",
+		       pci_name(dev), old_cmd, cmd);
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	}
+	return 0;
+}
+
+int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
+			enum pci_mmap_state mmap_state, int write_combine)
+{
+	struct pci_sys_data *root = dev->sysdata;
+	unsigned long phys;
+
+	if (mmap_state == pci_mmap_io)
+		return -EINVAL;
+	else
+		phys = vma->vm_pgoff + (root->mem_offset >> PAGE_SHIFT);
+
+	/*
+	 * Mark this as IO
+	 */
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (remap_pfn_range(vma, vma->vm_start, phys,
+			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index b51d364..83edc92 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -1,5 +1,5 @@
 obj-y				:= dma-mapping.o extable.o fault.o init.o \
 				   cache.o copypage.o flush.o \
-				   ioremap.o mmap.o pgd.o mmu.o \
+				   ioremap.o iomap.o mmap.o pgd.o mmu.o \
 				   context.o tlb.o proc.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/arch/arm64/mm/iomap.c b/arch/arm64/mm/iomap.c
new file mode 100644
index 0000000..42585c6
--- /dev/null
+++ b/arch/arm64/mm/iomap.c
@@ -0,0 +1,31 @@
+/*
+ *  Based on linux/arch/arm/mm/iomap.c
+ *
+ * Map IO port and PCI memory spaces so that {read,write}[bwl] can
+ * be used to access this memory.
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+
+#ifdef __io
+void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return __io(port);
+}
+EXPORT_SYMBOL(ioport_map);
+
+void ioport_unmap(void __iomem *addr)
+{
+}
+EXPORT_SYMBOL(ioport_unmap);
+#endif
+
+#ifdef CONFIG_PCI
+unsigned long pcibios_min_io = 0x1000;
+EXPORT_SYMBOL(pcibios_min_io);
+
+unsigned long pcibios_min_mem = 0x01000000;
+EXPORT_SYMBOL(pcibios_min_mem);
+#endif
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 2bb1d58..0c4eeca 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -98,3 +98,17 @@ void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
 				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_cache);
+
+#ifdef CONFIG_PCI
+int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr)
+{
+	BUG_ON(offset + SZ_64K > IO_SPACE_LIMIT);
+
+	return ioremap_page_range((unsigned long)PCI_IOBASE + offset,
+				  (unsigned long)PCI_IOBASE + offset + SZ_64K,
+				  phys_addr,
+				  __pgprot(PROT_NORMAL_NC));
+}
+EXPORT_SYMBOL_GPL(pci_ioremap_io);
+#endif
+
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 6ebf5bf..0f3f821 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_MICROBLAZE) += setup-bus.o
 obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
 obj-$(CONFIG_SPARC_LEON) += setup-bus.o setup-irq.o
 obj-$(CONFIG_M68K) += setup-bus.o setup-irq.o
+obj-$(CONFIG_ARM64) += setup-bus.o setup-irq.o
 
 #
 # ACPI Related PCI FW Functions
-- 
1.9.1

