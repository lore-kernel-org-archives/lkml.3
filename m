Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaDXKqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:46:13 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:40279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755560AbaDXKqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:46:08 -0400
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH v2 1/6] ARM: Add platform support for LSI AXM55xx SoC
Date: Thu, 24 Apr 2014 12:44:04 +0200
Message-ID: <6486d374332f66a0b8e00178cd5a58dc5996f18a.1398335771.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1398335771.git.anders.berg@lsi.com>
References: <cover.1398335771.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA040.namprd07.prod.outlook.com (10.141.251.15) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 01917B1794
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(189002)(199002)(80976001)(83322001)(19580405001)(50226001)(53416003)(31966008)(74662001)(19580395003)(99396002)(85852003)(77982001)(89996001)(47776003)(46102001)(83072002)(42186004)(79102001)(76482001)(20776003)(80022001)(66066001)(4396001)(74502001)(86362001)(93916002)(87286001)(88136002)(36756003)(50466002)(33646001)(87976001)(76176999)(77156001)(50986999)(81542001)(81342001)(62966002)(48376002)(92726001)(92566001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:swsaberg01.lsi.com;FPR:F85F7CD4.A8E89F45.4CF4BE8D.4FC71073.20600;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AXM55xx family consists of devices that may contain up to 16 ARM Cortex-A15
cores (in a 4x4 cluster configuration). The cores within each cluster share an
L2 cache, and the clusters are connected to each other via a CCN-504 cache
coherent interconnect.

This machine requires CONFIG_ARM_LPAE enabled as all peripherals are located
above 4GB in the memory map.

Signed-off-by: Anders Berg <anders.berg@lsi.com>
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
index b4935db..cc90841 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -953,6 +953,8 @@ source "arch/arm/mach-mvebu/Kconfig"
 
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
index 0000000..8c308fd
--- /dev/null
+++ b/arch/arm/mach-axxia/Kconfig
@@ -0,0 +1,16 @@
+config ARCH_AXXIA
+	bool "LSI Axxia platforms" if (ARCH_MULTI_V7 && ARM_LPAE)
+	select ARM_GIC
+	select MFD_SYSCON
+	select ARM_AMBA
+	select HAVE_ARM_ARCH_TIMER
+	select ARM_TIMER_SP804
+	select ZONE_DMA
+	select ARCH_DMA_ADDR_T_64BIT
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
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

