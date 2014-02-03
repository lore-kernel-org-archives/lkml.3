Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaBCSoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:44:22 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52854 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751686AbaBCSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:44:19 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] arm64: Add architecture support for PCI
Date: Mon,  3 Feb 2014 18:43:48 +0000
Message-Id: <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic host bridge functions to provide support for
PCI Express on arm64. There is no support for ISA memory.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm64/Kconfig            |  17 +++++++
 arch/arm64/include/asm/Kbuild |   1 +
 arch/arm64/include/asm/io.h   |   4 ++
 arch/arm64/include/asm/pci.h  |  35 +++++++++++++
 arch/arm64/kernel/Makefile    |   1 +
 arch/arm64/kernel/pci.c       | 112 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 170 insertions(+)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f8e5ee6..48fdd69 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -133,6 +133,23 @@ menu "Bus support"
 config ARM_AMBA
 	bool
 
+config PCI
+	bool "PCI support"
+	help
+	  This feature enables support for PCIe bus system. If you say Y
+	  here, the kernel will include drivers and infrastructure code
+	  to support PCIe bus devices.
+
+config PCI_DOMAINS
+	def_bool PCI
+
+config PCI_SYSCALL
+	def_bool PCI
+
+source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
+source "drivers/pci/hotplug/Kconfig"
+
 endmenu
 
 menu "Kernel Features"
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 71c53ec..46924bc 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -26,6 +26,7 @@ generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += pci.h
+generic-y += pci-bridge.h
 generic-y += poll.h
 generic-y += posix_types.h
 generic-y += resource.h
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4cc813e..ce5bad2 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -120,9 +120,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 /*
  *  I/O port access primitives.
  */
+#define arch_has_dev_port()	(0)
 #define IO_SPACE_LIMIT		0xffff
 #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_2M))
 
+#define ioport_map(port, nr)	(PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
+#define ioport_unmap(addr)
+
 static inline u8 inb(unsigned long addr)
 {
 	return readb(addr + PCI_IOBASE);
diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..dd084a3
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,35 @@
+#ifndef __ASM_PCI_H
+#define __ASM_PCI_H
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/io.h>
+#include <asm-generic/pci-bridge.h>
+#include <asm-generic/pci-dma-compat.h>
+
+#define PCIBIOS_MIN_IO		0
+#define PCIBIOS_MIN_MEM		0
+
+/*
+ * Set to 1 if the kernel should re-assign all PCI bus numbers
+ */
+#define pcibios_assign_all_busses() \
+	(pci_has_flag(PCI_REASSIGN_ALL_BUS))
+
+/*
+ * PCI address space differs from physical memory address space
+ */
+#define PCI_DMA_BUS_IS_PHYS	(0)
+
+extern int isa_dma_bridge_buggy;
+
+extern int pci_domain_nr(struct pci_bus *bus);
+extern int pci_proc_domain(struct pci_bus *bus);
+
+extern int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr);
+
+#endif  /* __KERNEL__ */
+#endif  /* __ASM_PCI_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2d7fcc1..8cfec47 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -21,6 +21,7 @@ arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_SCHED_HMP)		+= sched_hmp.o
+arm64-obj-$(CONFIG_PCI)			+= pci.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
new file mode 100644
index 0000000..7b652cf
--- /dev/null
+++ b/arch/arm64/kernel/pci.c
@@ -0,0 +1,112 @@
+/*
+ * Code borrowed from powerpc/kernel/pci-common.c
+ *
+ * Copyright (C) 2003 Anton Blanchard <anton@au.ibm.com>, IBM
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/of_pci.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+
+#include <asm/pci-bridge.h>
+
+
+/*
+ * Return the domain number for this bus
+ */
+int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_host_bridge *bridge = to_pci_host_bridge(bus->bridge);
+
+	if (bridge)
+		return bridge->domain_nr;
+
+	return 0;
+}
+
+int pci_proc_domain(struct pci_bus *bus)
+{
+	return pci_domain_nr(bus);
+}
+
+/*
+ * Called after each bus is probed, but before its children are examined
+ */
+void pcibios_fixup_bus(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+	struct resource *res;
+	int i;
+
+	if (bus->self != NULL) {
+		pci_read_bridge_bases(bus);
+
+		pci_bus_for_each_resource(bus, res, i) {
+			if (!res || !res->flags || res->parent)
+				continue;
+
+			/*
+			 * If we are going to reassign everything, we can
+			 * shrink the P2P resource to have zero size to
+			 * save space
+			 */
+			if (pci_has_flag(PCI_REASSIGN_ALL_RSRC)) {
+				res->flags |= IORESOURCE_UNSET;
+				res->start = 0;
+				res->end = -1;
+				continue;
+			}
+		}
+	}
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		/* Ignore fully discovered devices */
+		if (dev->is_added)
+			continue;
+
+		set_dev_node(&dev->dev, pcibus_to_node(dev->bus));
+
+		/* Read default IRQs and fixup if necessary */
+		dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
+	}
+}
+EXPORT_SYMBOL(pcibios_fixup_bus);
+
+/*
+ * We don't have to worry about legacy ISA devices, so nothing to do here
+ */
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
+				resource_size_t size, resource_size_t align)
+{
+	return ALIGN(res->start, align);
+}
+EXPORT_SYMBOL(pcibios_align_resource);
+
+int pcibios_enable_device(struct pci_dev *dev, int mask)
+{
+	return pci_enable_resources(dev, mask);
+}
+
+void pcibios_fixup_bridge_ranges(struct list_head *resources)
+{
+}
+
+int pci_ioremap_io(unsigned int offset, phys_addr_t phys_addr)
+{
+	BUG_ON(offset + SZ_64K - 1 > IO_SPACE_LIMIT);
+
+	return ioremap_page_range((unsigned long)PCI_IOBASE + offset,
+				(unsigned long)PCI_IOBASE + offset + SZ_64K,
+				phys_addr,
+				__pgprot(PROT_DEVICE_nGnRE));
+}
-- 
1.8.5.3

