Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbaGASos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:44:48 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50183 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964814AbaGASop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:44:45 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] arm64: Add architectural support for PCI
Date: Tue,  1 Jul 2014 19:44:00 +0100
Message-Id: <1404240240-9856-2-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404240240-9856-1-git-send-email-Liviu.Dudau@arm.com>
References: <1404240240-9856-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic host bridge functions to provide support for
PCI Express on arm64.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 arch/arm64/Kconfig            | 19 ++++++++++++++++-
 arch/arm64/include/asm/Kbuild |  1 +
 arch/arm64/include/asm/io.h   |  3 ++-
 arch/arm64/include/asm/pci.h  | 49 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile    |  1 +
 arch/arm64/kernel/pci.c       | 38 +++++++++++++++++++++++++++++++++
 6 files changed, 109 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/pci.h
 create mode 100644 arch/arm64/kernel/pci.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a474de34..48ed631 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -75,7 +75,7 @@ config MMU
 	def_bool y
 
 config NO_IOPORT_MAP
-	def_bool y
+	def_bool y if !PCI
 
 config STACKTRACE_SUPPORT
 	def_bool y
@@ -150,6 +150,23 @@ menu "Bus support"
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
index e0ecdcf..dc34039 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -121,7 +121,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 /*
  *  I/O port access primitives.
  */
-#define IO_SPACE_LIMIT		0xffff
+#define arch_has_dev_port()	(1)
+#define IO_SPACE_LIMIT		0x1ffffff
 #define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_32M))
 
 static inline u8 inb(unsigned long addr)
diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
new file mode 100644
index 0000000..3f7856e
--- /dev/null
+++ b/arch/arm64/include/asm/pci.h
@@ -0,0 +1,49 @@
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
+struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus);
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
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
+
+	if (bridge)
+		return bridge->domain_nr;
+
+	return 0;
+}
+
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return 1;
+}
+#endif  /* CONFIG_PCI */
+
+#endif  /* __KERNEL__ */
+#endif  /* __ASM_PCI_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cdaedad..36b117a 100644
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
index 0000000..955d6d1
--- /dev/null
+++ b/arch/arm64/kernel/pci.c
@@ -0,0 +1,38 @@
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
-- 
2.0.0

