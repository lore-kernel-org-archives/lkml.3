Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaF0Dv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:51:26 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54100 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaF0DvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:51:23 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, rric@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Charles.Garcia-Tobin@arm.com,
        lorenzo.pieralisi@arm.com, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 05/13] ARM64 / ACPI: Introduce arm-core.c and its related head file
Date: Fri, 27 Jun 2014 11:49:28 +0800
Message-Id: <1403840976-7456-6-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Stone <al.stone@linaro.org>

ACPI core need lots extern variables and functions which should
be provided by arch dependent code to make itself compilable. so
introduce arm-core.c and its related header file here, we need:
  - asm/acenv.h for arch specific ACPICA environments and
    implementation;
  - asm/acpi.h for arch specific variables and functions needed by
    ACPI driver core;
  - arm-core.c for ARM64 related ACPI implementation for ACPI driver
    core;

acpi_boot_table_init() will be called in setup_arch() before
paging_init(), so we should use eary_memremap() mechanism here
to get the RSDP and all the table pointers. with this patch,
we can get ACPI boot-time tables from firmware on ARM64.

Reviewed-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/include/asm/acenv.h |   18 +++++++
 arch/arm64/include/asm/acpi.h  |   49 ++++++++++++++++++
 arch/arm64/kernel/setup.c      |    4 ++
 drivers/acpi/Makefile          |    2 +
 drivers/acpi/plat/Makefile     |    1 +
 drivers/acpi/plat/arm-core.c   |  110 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 184 insertions(+)
 create mode 100644 arch/arm64/include/asm/acenv.h
 create mode 100644 arch/arm64/include/asm/acpi.h
 create mode 100644 drivers/acpi/plat/Makefile
 create mode 100644 drivers/acpi/plat/arm-core.c

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
index 0000000..3ea6b84
--- /dev/null
+++ b/arch/arm64/include/asm/acpi.h
@@ -0,0 +1,49 @@
+/*
+ *  Copyright (C) 2013-2014, Linaro Ltd.
+ *	Author: Al Stone <al.stone@linaro.org>
+ *	Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *	Author: Hanjun Guo <hanjun.guo@linaro.org>
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
+ * The ACPI processor driver for ACPI core code needs this macro.
+ * Temporarily define it to -1 so that the ACPI core can compile,
+ * but update it when we get the hardware ID from the MADT table.
+ */
+#define cpu_physical_id(cpu) -1
+
+static inline bool acpi_arch_is_smp(void)
+{
+	return 1;
+}
+
+#endif /* CONFIG_ACPI */
+
+#endif /*_ASM_ACPI_H*/
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
 
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index b638e95..c50ea88 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -86,3 +86,5 @@ obj-$(CONFIG_ACPI_PROCESSOR_AGGREGATOR) += acpi_pad.o
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
index 0000000..c6c7e03
--- /dev/null
+++ b/drivers/acpi/plat/arm-core.c
@@ -0,0 +1,110 @@
+/*
+ *  ARM/ARM64 Specific Low-Level ACPI Boot Support
+ *
+ *  Copyright (C) 2013-2014, Linaro Ltd.
+ *	Author: Al Stone <al.stone@linaro.org>
+ *	Author: Graeme Gregory <graeme.gregory@linaro.org>
+ *	Author: Hanjun Guo <hanjun.guo@linaro.org>
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
+enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PLATFORM;
+
+/*
+ * __acpi_map_table() will be called before page_init(), so early_ioremap()
+ * or early_memremap() should be called here.
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
+int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
+{
+	*irq = -1;
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
-- 
1.7.9.5

