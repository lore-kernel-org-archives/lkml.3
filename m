Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaILOBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:01:09 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52627 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaILOBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:01:04 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 04/18] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
Date: Fri, 12 Sep 2014 22:00:02 +0800
Message-Id: <1410530416-30200-5-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
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
  - asm/acenv.h for arch specific ACPICA environments and
    implementation, It is needed unconditionally by ACPI core;
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
 arch/arm64/include/asm/acenv.h |   18 +++++++++++
 arch/arm64/include/asm/acpi.h  |   45 ++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile     |    1 +
 arch/arm64/kernel/acpi.c       |   69 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c      |    4 +++
 5 files changed, 137 insertions(+)
 create mode 100644 arch/arm64/include/asm/acenv.h
 create mode 100644 arch/arm64/include/asm/acpi.h
 create mode 100644 arch/arm64/kernel/acpi.c

diff --git a/arch/arm64/include/asm/acenv.h b/arch/arm64/include/asm/acenv.h
new file mode 100644
index 0000000..b49166f
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
+/* It is required unconditionally by ACPI core, update it when needed. */
+
+#endif /* _ASM_ACENV_H */
diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
new file mode 100644
index 0000000..8b837ab
--- /dev/null
+++ b/arch/arm64/include/asm/acpi.h
@@ -0,0 +1,45 @@
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
+#define acpi_strict 1	/* No out-of-spec workarounds on ARM64 */
+extern int acpi_disabled;
+extern int acpi_noirq;
+extern int acpi_pci_disabled;
+
+static inline void disable_acpi(void)
+{
+	acpi_disabled = 1;
+	acpi_pci_disabled = 1;
+	acpi_noirq = 1;
+}
+
+/*
+ * It's used from ACPI core in kdump to boot UP system with SMP kernel,
+ * with this check the ACPI core will not override the CPU index
+ * obtained from GICC with 0 and not print some error message as well.
+ * Since MADT must provide at least one GICC structure for GIC
+ * initialization, CPU will be always available in MADT on ARM64.
+ */
+static inline bool acpi_has_cpu_in_madt(void)
+{
+	return true;
+}
+
+static inline void arch_fix_phys_package_id(int num, u32 slot) { }
+
+#endif /* CONFIG_ACPI */
+
+#endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index df7ef87..29ea7d6 100644
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
index 0000000..9252f72
--- /dev/null
+++ b/arch/arm64/kernel/acpi.c
@@ -0,0 +1,69 @@
+/*
+ *  ARM64 Specific Low-Level ACPI Boot Support
+ *
+ *  Copyright (C) 2013-2014, Linaro Ltd.
+ *	Author: Al Stone <al.stone@linaro.org>
+ *	Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *	Author: Hanjun Guo <hanjun.guo@linaro.org>
+ *	Author: Tomasz Nowicki <tomasz.nowicki@linaro.org>
+ *	Author: Naresh Bhat <naresh.bhat@linaro.org>
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
+int acpi_noirq;			/* skip ACPI IRQ initialization */
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
+	early_memunmap(map, size);
+}
+
+/*
+ * acpi_boot_table_init() called from setup_arch(), always.
+ *	1. find RSDP and get its address, and then find XSDT
+ *	2. extract all tables and checksums them all
+ *
+ * We can parse ACPI boot-time tables such as MADT after
+ * this function is called.
+ */
+void __init acpi_boot_table_init(void)
+{
+	/* If acpi_disabled, bail out */
+	if (acpi_disabled)
+		return;
+
+	/* Initialize the ACPI boot-time table parser. */
+	if (acpi_table_init())
+		disable_acpi();
+}
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 8f33f72..5b05227 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/efi.h>
+#include <linux/acpi.h>
 
 #include <asm/fixmap.h>
 #include <asm/cpu.h>
@@ -388,6 +389,9 @@ void __init setup_arch(char **cmdline_p)
 	efi_init();
 	arm64_memblock_init();
 
+	/* Parse the ACPI tables for possible boot-time configuration */
+	acpi_boot_table_init();
+
 	paging_init();
 	request_standard_resources();
 
-- 
1.7.9.5

