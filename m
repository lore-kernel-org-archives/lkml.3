Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbaGXNAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:00:55 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58054 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971AbaGXNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:00:53 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 01/19] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
Date: Thu, 24 Jul 2014 21:00:07 +0800
Message-Id: <1406206825-15590-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Stone <al.stone@linaro.org>

As we want to get ACPI tables to parse and then use the information
for system initialization, we should get the RSDP (Root System
Description Pointer) first, it then locates Extended Root Description
Table (XSDT) which contains all the 64-bit physical address that
pointer to other boot-time tables.

Introduce acpi.c and its related head file in this patch to provide
fundamental needs of extern variables and functions for ACPI core,
and then get boot-time tables as needed.
  - asm/cpu.h need for ACPI core and will be updated in the future to
    add definitions for arch_(un)register_cpu which are required for
    ACPI based physical CPU hotplug;
  - asm/acenv.h for arch specific ACPICA environments and
    implementation;
  - asm/acpi.h for arch specific variables and functions needed by
    ACPI driver core;
  - acpi.c for ARM64 related ACPI implementation for ACPI driver
    core;

acpi_boot_table_init() is introduced to get RSDP and boot-time tables,
it will be called in setup_arch() before paging_init(), so we should
use eary_memremap() mechanism here to get the RSDP and all the table
pointers.

Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acenv.h |   18 ++++++++++
 arch/arm64/include/asm/acpi.h  |   41 ++++++++++++++++++++++
 arch/arm64/include/asm/cpu.h   |   11 ++++++
 arch/arm64/kernel/Makefile     |    1 +
 arch/arm64/kernel/acpi.c       |   76 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c      |    4 +++
 6 files changed, 151 insertions(+)
 create mode 100644 arch/arm64/include/asm/acenv.h
 create mode 100644 arch/arm64/include/asm/acpi.h
 create mode 100644 arch/arm64/include/asm/cpu.h
 create mode 100644 arch/arm64/kernel/acpi.c

diff --git a/arch/arm64/include/asm/acenv.h b/arch/arm64/include/asm/acenv.h
new file mode 100644
index 0000000..3899ee6
--- /dev/null
+++ b/arch/arm64/include/asm/acenv.h
@@ -0,0 +1,18 @@
+/*
+ * ARM64 specific ACPICA environments and implementation
+ *
+ * Copyright (C) 2014, Linaro Ltd.
+ *   Author: Hanjun Guo <hanjun.guo@linaro.org>
+ *   Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ACENV_H
+#define _ASM_ACENV_H
+
+#define ACPI_FLUSH_CPU_CACHE() WARN_ONCE(1, "Not currently supported on ARM64")
+
+#endif /* _ASM_ACENV_H */
diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
new file mode 100644
index 0000000..e8581ea
--- /dev/null
+++ b/arch/arm64/include/asm/acpi.h
@@ -0,0 +1,41 @@
+/*
+ *  Copyright (C) 2013-2014, Linaro Ltd.
+ *	Author: Al Stone <al.stone@linaro.org>
+ *	Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *	Author: Hanjun Guo <hanjun.guo@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation;
+ */
+
+#ifndef _ASM_ACPI_H
+#define _ASM_ACPI_H
+
+/* Basic configuration for ACPI */
+#ifdef	CONFIG_ACPI
+extern int acpi_disabled;
+extern int acpi_noirq;
+extern int acpi_pci_disabled;
+extern int acpi_strict;
+
+static inline void disable_acpi(void)
+{
+	acpi_disabled = 1;
+	acpi_pci_disabled = 1;
+	acpi_noirq = 1;
+}
+
+/*
+ * MADT must provide at least one GICC structure
+ * for GIC initialization, so CPU will be
+ * always available in MADT on ARM64
+ */
+static inline bool acpi_has_cpu_in_madt(void)
+{
+	return 1;
+}
+
+#endif /* CONFIG_ACPI */
+
+#endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
new file mode 100644
index 0000000..cee7d3f
--- /dev/null
+++ b/arch/arm64/include/asm/cpu.h
@@ -0,0 +1,11 @@
+/*
+ *  Copyright (C) 2013-2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_CPU_H
+#define __ASM_CPU_H
+
+#endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cdaedad..b568c26 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -29,6 +29,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
+arm64-obj-$(CONFIG_ACPI)		+= acpi.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
new file mode 100644
index 0000000..c62fce6
--- /dev/null
+++ b/arch/arm64/kernel/acpi.c
@@ -0,0 +1,76 @@
+/*
+ *  ARM64 Specific Low-Level ACPI Boot Support
+ *
+ *  Copyright (C) 2013-2014, Linaro Ltd.
+ *	Author: Al Stone <al.stone@linaro.org>
+ *	Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *	Author: Hanjun Guo <hanjun.guo@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/cpumask.h>
+#include <linux/memblock.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/bootmem.h>
+#include <linux/smp.h>
+
+/*
+ * We never plan to use RSDT on arm/arm64 as its deprecated in spec but this
+ * variable is still required by the ACPI core
+ */
+u32 acpi_rsdt_forced;
+
+int acpi_noirq;			/* skip ACPI IRQ initialization */
+int acpi_strict;
+int acpi_disabled;
+EXPORT_SYMBOL(acpi_disabled);
+
+int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
+EXPORT_SYMBOL(acpi_pci_disabled);
+
+/*
+ * __acpi_map_table() will be called before page_init(), so early_ioremap()
+ * or early_memremap() should be called here to for ACPI table mapping.
+ */
+char *__init __acpi_map_table(unsigned long phys, unsigned long size)
+{
+	if (!phys || !size)
+		return NULL;
+
+	return early_memremap(phys, size);
+}
+
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+	if (!map || !size)
+		return;
+
+	early_iounmap(map, size);
+}
+
+/*
+ * acpi_boot_table_init() called from setup_arch(), always.
+ *	1. find RSDP and get its address, and then find XSDT
+ *	2. extract all tables and checksums them all
+ *
+ * We can parse ACPI boot-time tables such as FADT, MADT after
+ * this function is called.
+ */
+void __init acpi_boot_table_init(void)
+{
+	/* If acpi_disabled, bail out */
+	if (acpi_disabled)
+		return;
+
+	/* Initialize the ACPI boot-time table parser. */
+	if (acpi_table_init()) {
+		disable_acpi();
+		return;
+	}
+}
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 46d1125..9dedb0b 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/efi.h>
+#include <linux/acpi.h>
 
 #include <asm/fixmap.h>
 #include <asm/cputype.h>
@@ -385,6 +386,9 @@ void __init setup_arch(char **cmdline_p)
 	efi_init();
 	arm64_memblock_init();
 
+	/* Parse the ACPI tables for possible boot-time configuration */
+	acpi_boot_table_init();
+
 	paging_init();
 	request_standard_resources();
 
-- 
1.7.9.5

