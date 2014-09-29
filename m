Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaI2Od7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:33:59 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50560 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754245AbaI2ObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:11 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH v13 12/12] arm64: Add architectural support for PCI
Date: Mon, 29 Sep 2014 15:29:31 +0100
Message-Id: <1412000971-9242-13-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic PCI domain and OF functions to provide support for PCI
on arm64.

[bhelgaas: Change comments to use generic PCI, not just PCIe.  Nothing at
this level is PCIe-specific.]
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig               | 22 ++++++++++++-
 arch/arm64/include/asm/Kbuild    |  1 +
 arch/arm64/include/asm/io.h      |  3 +-
 arch/arm64/include/asm/pci.h     | 37 +++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h |  2 ++
 arch/arm64/kernel/Makefile       |  1 +
 arch/arm64/kernel/pci.c          | 70 ++++++++++++++++++++++++++++++++++++++++
 7 files changed, 134 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..bc97147 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -81,7 +81,7 @@ config MMU
 	def_bool y
 
 config NO_IOPORT_MAP
-	def_bool y
+	def_bool y if !PCI
 
 config STACKTRACE_SUPPORT
 	def_bool y
@@ -156,6 +156,26 @@ menu "Bus support"
 config ARM_AMBA
 	bool
 
+config PCI
+	bool "PCI support"
+	help
+	  This feature enables support for PCI bus system. If you say Y
+	  here, the kernel will include drivers and infrastructure code
+	  to support PCI bus devices.
+
+config PCI_DOMAINS
+	def_bool PCI
+
+config PCI_DOMAINS_GENERIC
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
index 0b3fcf8..07cb417 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -29,6 +29,7 @@ generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
 generic-y += pci.h
+generic-y += pci-bridge.h
 generic-y += poll.h
 generic-y += preempt.h
 generic-y += resource.h
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index e0ecdcf..f998d90 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -121,7 +121,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 /*
  *  I/O port access primitives.
  */
-#define IO_SPACE_LIMIT		0xffff
+#define arch_has_dev_port()	(1)
+#define IO_SPACE_LIMIT		(SZ_32M - 1)
 #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_32M))
 
 static inline u8 inb(unsigned long addr)
diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..872ba93
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,37 @@
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
+#define PCIBIOS_MIN_IO		0x1000
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
+#ifdef CONFIG_PCI
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return 1;
+}
+#endif  /* CONFIG_PCI */
+
+#endif  /* __KERNEL__ */
+#endif  /* __ASM_PCI_H */
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ffe1ba0..a968523 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -296,6 +296,8 @@ static inline int has_transparent_hugepage(void)
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRnE) | PTE_PXN | PTE_UXN)
 #define pgprot_writecombine(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
+#define pgprot_device(prot) \
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRE) | PTE_PXN | PTE_UXN)
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index df7ef87..1ed5a06 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -29,6 +29,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
+arm64-obj-$(CONFIG_PCI)			+= pci.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
new file mode 100644
index 0000000..ce5836c
--- /dev/null
+++ b/arch/arm64/kernel/pci.c
@@ -0,0 +1,70 @@
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
+/*
+ * Called after each bus is probed, but before its children are examined
+ */
+void pcibios_fixup_bus(struct pci_bus *bus)
+{
+	/* nothing to do, expected to be removed in the future */
+}
+
+/*
+ * We don't have to worry about legacy ISA devices, so nothing to do here
+ */
+resource_size_t pcibios_align_resource(void *data, const struct resource *res,
+				resource_size_t size, resource_size_t align)
+{
+	return res->start;
+}
+
+/*
+ * Try to assign the IRQ number from DT when adding a new device
+ */
+int pcibios_add_device(struct pci_dev *dev)
+{
+	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
+
+	return 0;
+}
+
+
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+static bool dt_domain_found = false;
+
+void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
+{
+	int domain = of_get_pci_domain_nr(parent->of_node);
+
+	if (domain >= 0) {
+		dt_domain_found = true;
+	} else if (dt_domain_found == true) {
+		dev_err(parent, "Node %s is missing \"linux,pci-domain\" property in DT\n",
+			parent->of_node->full_name);
+		return;
+	} else {
+		domain = pci_get_new_domain_nr();
+	}
+
+	bus->domain_nr = domain;
+}
+#endif
-- 
2.1.1

