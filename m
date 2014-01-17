Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaAQMdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:33:08 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:52252 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaAQMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:33:01 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Charles.Garcia-Tobin@arm.com, Hanjun Guo <hanjun.guo@linaro.org>,
        Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: [PATCH 04/20] ARM64 / ACPI: Introduce arm_core.c and its related head file
Date: Fri, 17 Jan 2014 20:24:58 +0800
Message-Id: <1389961514-13562-5-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce arm_core.c and its related head file, after this patch,
we can get ACPI tables from firmware on ARM64 now.

Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acpi.h |   57 +++++++++++
 arch/arm64/kernel/setup.c     |    6 ++
 drivers/acpi/Makefile         |    2 +
 drivers/acpi/plat/Makefile    |    1 +
 drivers/acpi/plat/arm-core.c  |  209 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 275 insertions(+)
 create mode 100644 drivers/acpi/plat/Makefile
 create mode 100644 drivers/acpi/plat/arm-core.c

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index cf19dc6..908d71b 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -19,6 +19,43 @@
 #ifndef _ASM_ARM64_ACPI_H
 #define _ASM_ARM64_ACPI_H
 
+#include <asm/cacheflush.h>
+
+#include <linux/init.h>
+
+#define COMPILER_DEPENDENT_INT64	s64
+#define COMPILER_DEPENDENT_UINT64	u64
+
+/*
+ * Calling conventions:
+ *
+ * ACPI_SYSTEM_XFACE        - Interfaces to host OS (handlers, threads)
+ * ACPI_EXTERNAL_XFACE      - External ACPI interfaces
+ * ACPI_INTERNAL_XFACE      - Internal ACPI interfaces
+ * ACPI_INTERNAL_VAR_XFACE  - Internal variable-parameter list interfaces
+ */
+#define ACPI_SYSTEM_XFACE
+#define ACPI_EXTERNAL_XFACE
+#define ACPI_INTERNAL_XFACE
+#define ACPI_INTERNAL_VAR_XFACE
+
+/* Asm macros */
+#define ACPI_FLUSH_CPU_CACHE() flush_cache_all()
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
 static inline bool arch_has_acpi_pdc(void)
 {
 	return false;	/* always false for now */
@@ -29,4 +66,24 @@ static inline void arch_acpi_set_pdc_bits(u32 *buf)
 	return;
 }
 
+static inline void acpi_noirq_set(void) { acpi_noirq = 1; }
+static inline void acpi_disable_pci(void)
+{
+	acpi_pci_disabled = 1;
+	acpi_noirq_set();
+}
+
+/* FIXME: this function should be moved to topology.h when it's ready */
+void arch_fix_phys_package_id(int num, u32 slot);
+
+/* temperally define -1 to make acpi core compilerable */
+#define cpu_physical_id(cpu) -1
+
+#else	/* !CONFIG_ACPI */
+#define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
+#define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
+#define acpi_pci_disabled 1	/* ACPI PCI sometimes enabled on ARM */
+#define acpi_strict 1		/* no ACPI spec workarounds on ARM */
+#endif
+
 #endif /*_ASM_ARM64_ACPI_H*/
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index bd9bbd0..2210353 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -41,6 +41,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
+#include <linux/acpi.h>
 
 #include <asm/cputype.h>
 #include <asm/elf.h>
@@ -225,6 +226,11 @@ void __init setup_arch(char **cmdline_p)
 
 	arm64_memblock_init();
 
+	/* Parse the ACPI tables for possible boot-time configuration */
+	acpi_boot_table_init();
+	early_acpi_boot_init();
+	acpi_boot_init();
+
 	paging_init();
 	request_standard_resources();
 
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index d8cebe3..9fbba50 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -83,3 +83,5 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
 obj-$(CONFIG_ACPI_APEI)		+= apei/
 
 obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
+
+obj-y				+= plat/
diff --git a/drivers/acpi/plat/Makefile b/drivers/acpi/plat/Makefile
new file mode 100644
index 0000000..46bc65e
--- /dev/null
+++ b/drivers/acpi/plat/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_ARM64)	+= arm-core.o
diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
new file mode 100644
index 0000000..162a1ab
--- /dev/null
+++ b/drivers/acpi/plat/arm-core.c
@@ -0,0 +1,209 @@
+/*
+ *  ARM/ARM64 Specific Low-Level ACPI Boot Support
+ *
+ *  Copyright (C) 2013, Al Stone <al.stone@linaro.org>
+ *  Copyright (C) 2013, Graeme Gregory <graeme.gregory@linaro.org>
+ *  Copyright (C) 2013, Hanjun Guo <hanjun.guo@linaro.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/cpumask.h>
+#include <linux/memblock.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/bootmem.h>
+#include <linux/smp.h>
+
+#include <asm/pgtable.h>
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
+#define PREFIX			"ACPI: "
+
+/* FIXME: this function should be moved to topology.c when it is ready */
+void arch_fix_phys_package_id(int num, u32 slot)
+{
+	return;
+}
+EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);
+
+enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PLATFORM;
+
+static unsigned int gsi_to_irq(unsigned int gsi)
+{
+	int irq = irq_create_mapping(NULL, gsi);
+
+	return irq;
+}
+
+/*
+ * __acpi_map_table() will be called before page_init(), so early_ioremap()
+ * or early_memremap() should be called here.
+ *
+ * FIXME: early_io/memremap()/early_iounmap() are not upstream yet on ARM64,
+ * just wait for Mark Salter's patchset accepted by mainline
+ */
+char *__init __acpi_map_table(unsigned long phys, unsigned long size)
+{
+	if (!phys || !size)
+		return NULL;
+
+	/*
+	 * temporarily use phys_to_virt(),
+	 * should be early_memremap(phys, size) here
+	 */
+	return phys_to_virt(phys);
+}
+
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+	if (!map || !size)
+		return;
+
+	/* should be early_iounmap(map, size); */
+	return;
+}
+
+int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
+{
+	*irq = gsi_to_irq(gsi);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
+
+/*
+ * success: return IRQ number (>0)
+ * failure: return =< 0
+ */
+int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
+{
+	return -1;
+}
+EXPORT_SYMBOL_GPL(acpi_register_gsi);
+
+void acpi_unregister_gsi(u32 gsi)
+{
+}
+EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
+
+static int __init acpi_parse_fadt(struct acpi_table_header *table)
+{
+	return 0;
+}
+
+static void __init early_acpi_process_madt(void)
+{
+	return;
+}
+
+static void __init acpi_process_madt(void)
+{
+	return;
+}
+
+/*
+ * acpi_boot_table_init() and acpi_boot_init()
+ *  called from setup_arch(), always.
+ *	1. checksums all tables
+ *	2. enumerates lapics
+ *	3. enumerates io-apics
+ *
+ * acpi_table_init() is separated to allow reading SRAT without
+ * other side effects.
+ */
+void __init acpi_boot_table_init(void)
+{
+	/*
+	 * If acpi_disabled, bail out
+	 */
+	if (acpi_disabled)
+		return;
+
+	/*
+	 * Initialize the ACPI boot-time table parser.
+	 */
+	if (acpi_table_init()) {
+		disable_acpi();
+		return;
+	}
+}
+
+int __init early_acpi_boot_init(void)
+{
+	/*
+	 * If acpi_disabled, bail out
+	 */
+	if (acpi_disabled)
+		return -ENODEV;
+
+	/*
+	 * Process the Multiple APIC Description Table (MADT), if present
+	 */
+	early_acpi_process_madt();
+
+	return 0;
+}
+
+int __init acpi_boot_init(void)
+{
+	/*
+	 * If acpi_disabled, bail out
+	 */
+	if (acpi_disabled)
+		return -ENODEV;
+
+	acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
+
+	/*
+	 * Process the Multiple APIC Description Table (MADT), if present
+	 */
+	acpi_process_madt();
+
+	return 0;
+}
+
+static int __init parse_acpi(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	/* "acpi=off" disables both ACPI table parsing and interpreter */
+	if (strcmp(arg, "off") == 0) {
+		disable_acpi();
+	}
+	/* acpi=strict disables out-of-spec workarounds */
+	else if (strcmp(arg, "strict") == 0) {
+		acpi_strict = 1;
+	}
+	return 0;
+}
+early_param("acpi", parse_acpi);
-- 
1.7.9.5

