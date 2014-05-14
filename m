Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaENSih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:38:37 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:44647 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaENSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:38:35 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH v3 1/6] ARM: Add platform support for LSI AXM55xx SoC
Date: Wed, 14 May 2014 20:37:56 +0200
Message-Id: <f9d39b12681236f8eeb2819db77f99f4960480f1.1400072260.git.anders.berg@avagotech.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1400072260.git.anders.berg@avagotech.com>
References: <cover.1400072260.git.anders.berg@avagotech.com>
In-Reply-To: <cover.1400072260.git.anders.berg@avagotech.com>
References: <cover.1400072260.git.anders.berg@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Berg <anders.berg@lsi.com>

The AXM55xx family consists of devices that may contain up to 16 ARM Cortex-A15
cores (in a 4x4 cluster configuration). The cores within each cluster share an
L2 cache, and the clusters are connected to each other via a CCN-504 cache
coherent interconnect.

This machine requires CONFIG_ARM_LPAE enabled as all peripherals are located
above 4GB in the memory map.

Signed-off-by: Anders Berg <anders.berg@lsi.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/devicetree/bindings/arm/axxia.txt | 12 ++++
 arch/arm/Kconfig                                |  2 +
 arch/arm/Makefile                               |  2 +
 arch/arm/mach-axxia/Kconfig                     | 16 +++++
 arch/arm/mach-axxia/Makefile                    |  2 +
 arch/arm/mach-axxia/axxia.c                     | 28 ++++++++
 arch/arm/mach-axxia/platsmp.c                   | 89 +++++++++++++++++++++++++
 7 files changed, 151 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/axxia.txt
 create mode 100644 arch/arm/mach-axxia/Kconfig
 create mode 100644 arch/arm/mach-axxia/Makefile
 create mode 100644 arch/arm/mach-axxia/axxia.c
 create mode 100644 arch/arm/mach-axxia/platsmp.c

diff --git a/Documentation/devicetree/bindings/arm/axxia.txt b/Documentation/devicetree/bindings/arm/axxia.txt
new file mode 100644
index 0000000..7b4ef9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/axxia.txt
@@ -0,0 +1,12 @@
+Axxia AXM55xx device tree bindings
+
+Boards using the AXM55xx SoC need to have the following properties:
+
+Required root node property:
+
+  - compatible = "lsi,axm5516"
+
+Boards:
+
+  LSI AXM5516 Validation board (Amarillo)
+	compatible = "lsi,axm5516-amarillo", "lsi,axm5516"
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db3c541..5dba814 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -951,6 +951,8 @@ source "arch/arm/mach-mvebu/Kconfig"
 
 source "arch/arm/mach-at91/Kconfig"
 
+source "arch/arm/mach-axxia/Kconfig"
+
 source "arch/arm/mach-bcm/Kconfig"
 
 source "arch/arm/mach-berlin/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 41c1931..6721fab 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -138,10 +138,12 @@ endif
 textofs-$(CONFIG_ARCH_MSM7X30) := 0x00208000
 textofs-$(CONFIG_ARCH_MSM8X60) := 0x00208000
 textofs-$(CONFIG_ARCH_MSM8960) := 0x00208000
+textofs-$(CONFIG_ARCH_AXXIA) := 0x00308000
 
 # Machine directory name.  This list is sorted alphanumerically
 # by CONFIG_* macro name.
 machine-$(CONFIG_ARCH_AT91)		+= at91
+machine-$(CONFIG_ARCH_AXXIA)		+= axxia
 machine-$(CONFIG_ARCH_BCM)		+= bcm
 machine-$(CONFIG_ARCH_BERLIN)		+= berlin
 machine-$(CONFIG_ARCH_CLPS711X)		+= clps711x
diff --git a/arch/arm/mach-axxia/Kconfig b/arch/arm/mach-axxia/Kconfig
new file mode 100644
index 0000000..8be7e0a
--- /dev/null
+++ b/arch/arm/mach-axxia/Kconfig
@@ -0,0 +1,16 @@
+config ARCH_AXXIA
+	bool "LSI Axxia platforms" if (ARCH_MULTI_V7 && ARM_LPAE)
+	select ARCH_DMA_ADDR_T_64BIT
+	select ARM_AMBA
+	select ARM_GIC
+	select ARM_TIMER_SP804
+	select HAVE_ARM_ARCH_TIMER
+	select MFD_SYSCON
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
+	select ZONE_DMA
+	help
+	  This enables support for the LSI Axxia devices.
+
+	  The LSI Axxia platforms require a Flattened Device Tree to be passed
+	  to the kernel.
diff --git a/arch/arm/mach-axxia/Makefile b/arch/arm/mach-axxia/Makefile
new file mode 100644
index 0000000..ec4f68b
--- /dev/null
+++ b/arch/arm/mach-axxia/Makefile
@@ -0,0 +1,2 @@
+obj-y				+= axxia.o
+obj-$(CONFIG_SMP)		+= platsmp.o
diff --git a/arch/arm/mach-axxia/axxia.c b/arch/arm/mach-axxia/axxia.c
new file mode 100644
index 0000000..19e5a1d
--- /dev/null
+++ b/arch/arm/mach-axxia/axxia.c
@@ -0,0 +1,28 @@
+/*
+ * Support for the LSI Axxia SoC devices based on ARM cores.
+ *
+ * Copyright (C) 2012 LSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/init.h>
+#include <asm/mach/arch.h>
+
+static const char *axxia_dt_match[] __initconst = {
+	"lsi,axm5516",
+	"lsi,axm5516-sim",
+	"lsi,axm5516-emu",
+	NULL
+};
+
+DT_MACHINE_START(AXXIA_DT, "LSI Axxia AXM55XX")
+	.dt_compat = axxia_dt_match,
+MACHINE_END
diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
new file mode 100644
index 0000000..959d4df
--- /dev/null
+++ b/arch/arm/mach-axxia/platsmp.c
@@ -0,0 +1,89 @@
+/*
+ * linux/arch/arm/mach-axxia/platsmp.c
+ *
+ * Copyright (C) 2012 LSI Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/smp.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <asm/cacheflush.h>
+
+/* Syscon register offsets for releasing cores from reset */
+#define SC_CRIT_WRITE_KEY	0x1000
+#define SC_RST_CPU_HOLD		0x1010
+
+/*
+ * Write the kernel entry point for secondary CPUs to the specified address
+ */
+static void write_release_addr(u32 release_phys)
+{
+	u32 *virt = (u32 *) phys_to_virt(release_phys);
+	writel_relaxed(virt_to_phys(secondary_startup), virt);
+	/* Make sure this store is visible to other CPUs */
+	smp_wmb();
+	__cpuc_flush_dcache_area(virt, sizeof(u32));
+}
+
+static int axxia_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	struct device_node *syscon_np;
+	void __iomem *syscon;
+	u32 tmp;
+
+	syscon_np = of_find_compatible_node(NULL, NULL, "lsi,axxia-syscon");
+	if (!syscon_np)
+		return -ENOENT;
+
+	syscon = of_iomap(syscon_np, 0);
+	if (!syscon)
+		return -ENOMEM;
+
+	tmp = readl(syscon + SC_RST_CPU_HOLD);
+	writel(0xab, syscon + SC_CRIT_WRITE_KEY);
+	tmp &= ~(1 << cpu);
+	writel(tmp, syscon + SC_RST_CPU_HOLD);
+
+	return 0;
+}
+
+static void __init axxia_smp_prepare_cpus(unsigned int max_cpus)
+{
+	int cpu_count = 0;
+	int cpu;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs actually
+	 * populated at the present time.
+	 */
+	for_each_possible_cpu(cpu) {
+		struct device_node *np;
+		u32 release_phys;
+
+		np = of_get_cpu_node(cpu, NULL);
+		if (!np)
+			continue;
+		if (of_property_read_u32(np, "cpu-release-addr", &release_phys))
+			continue;
+
+		if (cpu_count < max_cpus) {
+			set_cpu_present(cpu, true);
+			cpu_count++;
+		}
+
+		if (release_phys != 0)
+			write_release_addr(release_phys);
+	}
+}
+
+static struct smp_operations axxia_smp_ops __initdata = {
+	.smp_prepare_cpus	= axxia_smp_prepare_cpus,
+	.smp_boot_secondary	= axxia_boot_secondary,
+};
+CPU_METHOD_OF_DECLARE(axxia_smp, "lsi,syscon-release", &axxia_smp_ops);
-- 
1.8.3.2

