Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaDOMSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:18:23 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:57359
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbaDOMO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:14:58 -0400
From: Anders Berg <anders.berg@lsi.com>
To: <arnd@arndb.de>, <olof@lixom.net>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <dbaryshkov@gmail.com>
CC: <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH 1/5] ARM: Add platform support for LSI AXM55xx SoC
Date: Tue, 15 Apr 2014 14:06:10 +0200
Message-ID: <80a2523d3e266ed12d5b70ac5518e963e47b27f4.1397552154.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1397552154.git.anders.berg@lsi.com>
References: <cover.1397552154.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA048.namprd07.prod.outlook.com (10.141.251.23) To
 BLUPR07MB370.namprd07.prod.outlook.com (10.141.26.147)
X-Forefront-PRVS: 0182DBBB05
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(199002)(189002)(19580395003)(89996001)(80976001)(81542001)(2201001)(87976001)(62966002)(87286001)(36756003)(76176999)(80022001)(20776003)(66066001)(47776003)(79102001)(50986999)(46102001)(77982001)(99396002)(53416003)(92726001)(74502001)(81342001)(76482001)(48376002)(83072002)(33646001)(4396001)(85852003)(83322001)(19580405001)(50466002)(86362001)(77156001)(93916002)(88136002)(50226001)(42186004)(74662001)(2004002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB370;H:swsaberg01.lsi.com;FPR:EA6FFD54.AE209F44.7FF69587.CEE4F313.20C61;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
 Documentation/devicetree/bindings/arm/axxia.txt    |  12 +
 .../devicetree/bindings/clock/clk-axxia.txt        |  88 +++++++
 arch/arm/Kconfig                                   |   2 +
 arch/arm/Makefile                                  |   2 +
 arch/arm/mach-axxia/Kconfig                        |  19 ++
 arch/arm/mach-axxia/Makefile                       |   2 +
 arch/arm/mach-axxia/Makefile.boot                  |   2 +
 arch/arm/mach-axxia/axxia.c                        | 117 +++++++++
 arch/arm/mach-axxia/axxia.h                        |  42 +++
 arch/arm/mach-axxia/headsmp.S                      |  44 ++++
 arch/arm/mach-axxia/platsmp.c                      | 183 ++++++++++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-axxia.c                            | 281 +++++++++++++++++++++
 13 files changed, 795 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/axxia.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-axxia.txt
 create mode 100644 arch/arm/mach-axxia/Kconfig
 create mode 100644 arch/arm/mach-axxia/Makefile
 create mode 100644 arch/arm/mach-axxia/Makefile.boot
 create mode 100644 arch/arm/mach-axxia/axxia.c
 create mode 100644 arch/arm/mach-axxia/axxia.h
 create mode 100644 arch/arm/mach-axxia/headsmp.S
 create mode 100644 arch/arm/mach-axxia/platsmp.c
 create mode 100644 drivers/clk/clk-axxia.c

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
diff --git a/Documentation/devicetree/bindings/clock/clk-axxia.txt b/Documentation/devicetree/bindings/clock/clk-axxia.txt
new file mode 100644
index 0000000..94eb840
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clk-axxia.txt
@@ -0,0 +1,88 @@
+* Axxia clock driver bindings
+
+This document contains bindings for the Axxia PLL, clock divider and mux. The
+binding uses the common clock binding found in:
+
+	Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+* Axxia PLL
+
+Required properties:
+- #clock-cells : shall be set to 0.
+- compatible : shall be "lsi,axxia-pll-clock"
+- clocks : parent clock phandle
+- reg - specifies PLL control registers
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clk_ref0: clk_ref0 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <125000000>;
+	};
+
+	clk_cpu_pll: clk_cpu_pll@2010022000 {
+		compatible = "lsi,axxia-pll-clock";
+		#clock-cells = <0>;
+		clocks = <&clk_ref0>;
+		clock-output-names = "clk_cpu_pll";
+		reg = <0x20 0x10022000 0 0x2c>;
+	};
+
+
+* Axxia clock divider
+
+Required properties:
+- #clock-cells : shall be set to 0.
+- compatible : shall be "lsi,axxia-div-clock"
+- clocks : parent clock phandle
+- reg - clock divider control register
+- lsi,bit-shift : bit position of the divider control field.
+- lsi,bit-mask : width of the divider control field.
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clk_cpu_div: cpu {
+		compatible = "lsi,axxia-div-clock";
+		#clock-cells = <0>;
+		clocks = <&clk_cpu_pll>;
+		clock-output-names = "clk_cpu_div";
+		reg = <0x20 0x10030008 0 0x4>;
+		lsi,bit-shift = <0>;
+		lsi,bit-width = <4>;
+	};
+
+
+* Axxia clock mux
+
+Required properties:
+- #clock-cells : shall be set to 0.
+- compatible : shall be "lsi,axxia-mux-clock"
+- clocks : phandle of parent clocks (max 4)
+- reg - clock divider control register
+- lsi,bit-shift : bit position of the divider control field.
+- lsi,bit-mask : width of the divider control field.
+
+Optional properties:
+- clock-output-names : From common clock binding.
+
+Example:
+
+	clk_cpu: clk_cpu0@2010030000 {
+		compatible = "lsi,axxia-mux-clock";
+		#clock-cells = <0>;
+		clocks = <&clk_ref0>,
+			 <&clk_cpu_pll>,
+			 <&clk_cpu_div>,
+			 <&clk_cpu_div>;
+		clock-output-names = "clk_cpu";
+		reg = <0x20 0x10030000 0 0x4>;
+		lsi,bit-shift = <0>;
+		lsi,bit-width = <2>;
+	};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1594945..ef87f59 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -934,6 +934,8 @@ source "arch/arm/mach-mvebu/Kconfig"
 
 source "arch/arm/mach-at91/Kconfig"
 
+source "arch/arm/mach-axxia/Kconfig"
+
 source "arch/arm/mach-bcm/Kconfig"
 
 source "arch/arm/mach-bcm2835/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 08a9ef5..b034687 100644
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
 machine-$(CONFIG_ARCH_BCM2835)		+= bcm2835
 machine-$(CONFIG_ARCH_BERLIN)		+= berlin
diff --git a/arch/arm/mach-axxia/Kconfig b/arch/arm/mach-axxia/Kconfig
new file mode 100644
index 0000000..336426a
--- /dev/null
+++ b/arch/arm/mach-axxia/Kconfig
@@ -0,0 +1,19 @@
+config ARCH_AXXIA
+	bool "LSI Axxia platforms" if (ARCH_MULTI_V7 && ARM_LPAE)
+	select ARM_GIC
+	select HAVE_SMP
+	select MFD_SYSCON
+	select ARM_AMBA
+	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select HAVE_ARM_ARCH_TIMER
+	select ARM_TIMER_SP804
+	select ZONE_DMA
+	select ARCH_DMA_ADDR_T_64BIT
+	select ARCH_SUPPORTS_BIG_ENDIAN
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
+	help
+	  This enables support for the LSI Axxia devices.
+
+	  The LSI Axxia platforms require a Flattened Device Tree to be passed
+	  to the kernel.
diff --git a/arch/arm/mach-axxia/Makefile b/arch/arm/mach-axxia/Makefile
new file mode 100644
index 0000000..4daf118
--- /dev/null
+++ b/arch/arm/mach-axxia/Makefile
@@ -0,0 +1,2 @@
+obj-y				+= axxia.o
+obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
diff --git a/arch/arm/mach-axxia/Makefile.boot b/arch/arm/mach-axxia/Makefile.boot
new file mode 100644
index 0000000..b3c724e
--- /dev/null
+++ b/arch/arm/mach-axxia/Makefile.boot
@@ -0,0 +1,2 @@
+   zreladdr-y	+= 0x00308000
+params_phys-y	:= 0x00300100
diff --git a/arch/arm/mach-axxia/axxia.c b/arch/arm/mach-axxia/axxia.c
new file mode 100644
index 0000000..8d85926
--- /dev/null
+++ b/arch/arm/mach-axxia/axxia.c
@@ -0,0 +1,117 @@
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/amba/bus.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/of_platform.h>
+#include <linux/sizes.h>
+#include <asm/mach/arch.h>
+#include <asm/pmu.h>
+#include "axxia.h"
+
+/*
+ * The PMU IRQ lines of four cores are wired together into a single interrupt.
+ * Bounce the interrupt to other cores if it's not ours.
+ */
+static irqreturn_t axxia_pmu_handler(int irq, void *dev, irq_handler_t handler)
+{
+	irqreturn_t ret = handler(irq, dev);
+
+	if (ret == IRQ_NONE) {
+		int cpu = smp_processor_id();
+		int cluster = cpu / CORES_PER_CLUSTER;
+		int other;
+
+		/* Look until we find another cpu that's online. */
+		do {
+			other = (++cpu % CORES_PER_CLUSTER) +
+				(cluster * CORES_PER_CLUSTER);
+		} while (!cpu_online(other));
+
+		irq_set_affinity(irq, cpumask_of(other));
+	}
+
+	/*
+	 * We should be able to get away with the amount of IRQ_NONEs we give,
+	 * while still having the spurious IRQ detection code kick in if the
+	 * interrupt really starts hitting spuriously.
+	 */
+	return ret;
+}
+
+static struct arm_pmu_platdata pmu_pdata = {
+	.handle_irq = axxia_pmu_handler,
+};
+
+static struct of_dev_auxdata axxia_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("arm,cortex-a15-pmu", 0, "pmu", &pmu_pdata),
+	{}
+};
+
+
+static int
+axxia_bus_notifier(struct notifier_block *nb, unsigned long event, void *obj)
+{
+	struct device *dev = obj;
+
+	if (event != BUS_NOTIFY_ADD_DEVICE)
+		return NOTIFY_DONE;
+
+	if (!of_property_read_bool(dev->of_node, "dma-coherent"))
+		return NOTIFY_DONE;
+
+	set_dma_ops(dev, &arm_coherent_dma_ops);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block axxia_platform_nb = {
+	.notifier_call = axxia_bus_notifier,
+};
+
+static struct notifier_block axxia_amba_nb = {
+	.notifier_call = axxia_bus_notifier,
+};
+
+static void __init axxia_dt_init(void)
+{
+	bus_register_notifier(&platform_bus_type, &axxia_platform_nb);
+	bus_register_notifier(&amba_bustype, &axxia_amba_nb);
+
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     axxia_auxdata_lookup, NULL);
+}
+
+static const char *axxia_dt_match[] __initconst = {
+	"lsi,axm55xx",
+	"lsi,axm55xx-sim",
+	"lsi,axm55xx-emu",
+	NULL
+};
+
+DT_MACHINE_START(AXXIA_DT, "LSI Axxia AXM55XX")
+	.dt_compat	= axxia_dt_match,
+	.smp		= smp_ops(axxia_smp_ops),
+	.init_machine	= axxia_dt_init,
+MACHINE_END
diff --git a/arch/arm/mach-axxia/axxia.h b/arch/arm/mach-axxia/axxia.h
new file mode 100644
index 0000000..594dd97
--- /dev/null
+++ b/arch/arm/mach-axxia/axxia.h
@@ -0,0 +1,42 @@
+/*
+ * Prototypes for platform functions.
+ *
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __AXXIA_H
+#define __AXXIA_H
+
+#define CORES_PER_CLUSTER      4
+
+#define AXXIA_PERIPH_PHYS      0x2000000000ULL
+#define AXXIA_SYSCON_PHYS      0x2010030000ULL
+
+#if 0
+#define AXXIA_UART0_PHYS       0x2010080000ULL
+#define AXXIA_UART1_PHYS       0x2010081000ULL
+#define AXXIA_UART2_PHYS       0x2010082000ULL
+#define AXXIA_UART3_PHYS       0x2010083000ULL
+
+#ifdef CONFIG_DEBUG_LL
+#define AXXIA_DEBUG_UART_VIRT  0xf0080000
+#define AXXIA_DEBUG_UART_PHYS  AXXIA_UART0_PHYS
+#endif
+#endif
+
+void axxia_secondary_startup(void);
+
+extern struct smp_operations axxia_smp_ops;
+
+#endif
diff --git a/arch/arm/mach-axxia/headsmp.S b/arch/arm/mach-axxia/headsmp.S
new file mode 100644
index 0000000..296cc53
--- /dev/null
+++ b/arch/arm/mach-axxia/headsmp.S
@@ -0,0 +1,44 @@
+/*
+ *  linux/arch/arm/mach-axxia/headsmp.S
+ *
+ *  Cloned from linux/arch/arm/mach-realview/headsmp.S
+ *
+ *  Copyright (c) 2003 ARM Limited
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/assembler.h>
+
+/*
+ * Axxia specific entry point for secondary CPUs.  This provides
+ * a "holding pen" into which all secondary cores are held until we're
+ * ready for them to initialise.
+ */
+ENTRY(axxia_secondary_startup)
+ARM_BE8(setend	be)			/* go BE8 if entered LE */
+	mrc	p15, 0, r0, c0, c0, 5
+	bic	r0, #0xff000000
+	adr	r4, 2f
+	ldmia	r4, {r5, r6}
+	sub	r4, r4, r5
+	add	r6, r6, r4
+1:	ldr	r7, [r6]
+	cmp	r7, r0
+	wfene
+	bne	1b
+
+	/*
+	 * We've been released from the holding pen: secondary_stack
+	 * should now contain the SVC stack for this core
+	 */
+	b	secondary_startup
+ENDPROC(axxia_secondary_startup)
+
+	.align 2
+2:	.long	.
+	.long	pen_release
diff --git a/arch/arm/mach-axxia/platsmp.c b/arch/arm/mach-axxia/platsmp.c
new file mode 100644
index 0000000..fd7f507
--- /dev/null
+++ b/arch/arm/mach-axxia/platsmp.c
@@ -0,0 +1,183 @@
+/*
+ *  linux/arch/arm/mach-axxia/platsmp.c
+ *
+ *  Copyright (C) 2012 LSI Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/smp.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <asm/smp_plat.h>
+#include <asm/cacheflush.h>
+#include <asm/mach/map.h>
+#include <asm/virt.h>
+#include "axxia.h"
+
+static int wfe_fixup;
+
+/*
+ * Check if we need to enable cross-cluster SEV workaround for a bug in
+ * revision 1.0 silicon (which could cause event signals (from SEV instruction)
+ * to get lost between clusters). As a workaround, we set the bit 7 in CP15
+ * ACTLR (enable WFE as a no-operation) for each core.
+ */
+static void __init check_fixup_sev(void __iomem *syscon)
+{
+	u32 pfuse = readl(syscon + 0x34);
+	u32 chip_type = pfuse & 0x1f;
+	u32 chip_ver  = (pfuse >> 5) & 0x3f;
+
+	/* Set flag for secondary cores */
+	wfe_fixup = (chip_type == 0 || chip_type == 9) && (chip_ver == 0);
+	pr_info("axxia: Cross-cluster SEV fixup: %s\n", wfe_fixup ? "yes":"no");
+}
+
+static void __init do_fixup_sev(void)
+{
+	u32 tmp;
+
+	if (wfe_fixup) {
+		asm volatile("mrc\tp15, 0, %0, c1, c0, 1" : "=r"(tmp));
+		tmp |= (1<<7);
+		asm volatile("mcr\tp15, 0, %0, c1, c0, 1" : : "r"(tmp));
+		isb();
+	}
+}
+
+/*
+ * Write pen_release in a way that is guaranteed to be visible to all
+ * observers, irrespective of whether they're taking part in coherency
+ * or not.  This is necessary for the hotplug code to work reliably.
+ */
+static void write_pen_release(int val)
+{
+	pen_release = val;
+	/* Make sure this store is visible to other CPUs */
+	smp_wmb();
+	__cpuc_flush_dcache_area((void *)&pen_release, sizeof(pen_release));
+}
+
+/*
+ * Write the entry point of the routine that the secondary cores will execute
+ * once they are released from their "holding pen".
+ */
+static void write_release_addr(u32 release_phys)
+{
+	u32 *virt = (u32 *) phys_to_virt(release_phys);
+	writel_relaxed(virt_to_phys(axxia_secondary_startup), virt);
+	/* Make sure this store is visible to other CPUs */
+	smp_wmb();
+	__cpuc_flush_dcache_area(virt, sizeof(u32));
+}
+
+static void axxia_secondary_init(unsigned int cpu)
+{
+	/* Fixup for cross-cluster SEV */
+	do_fixup_sev();
+
+	/*
+	 * Let the primary processor know we're out of the
+	 * pen, then head off into the C entry point.
+	 */
+	write_pen_release(-1);
+}
+
+static int axxia_boot_secondary(unsigned int cpu,
+					  struct task_struct *idle)
+{
+	unsigned long timeout;
+
+	/* Release the specified core */
+	write_pen_release(cpu_logical_map(cpu));
+
+	/* Send a wakeup event to get the idled cpu out of WFE state */
+	dsb_sev();
+
+	/* Wait for so long, then give up if nothing happens ... */
+	timeout = jiffies + (1 * HZ);
+	while (time_before(jiffies, timeout)) {
+		/* Make sure stores to pen_release have completed */
+		smp_rmb();
+		if (pen_release == -1)
+			break;
+		udelay(1);
+	}
+
+	return pen_release != -1 ? -ENOSYS : 0;
+}
+
+static void __init axxia_smp_prepare_cpus(unsigned int max_cpus)
+{
+	void __iomem *syscon;
+	int cpu_count = 0;
+	int cpu;
+
+	syscon = ioremap(AXXIA_SYSCON_PHYS, SZ_64K);
+	if (WARN_ON(!syscon))
+		return;
+
+	check_fixup_sev(syscon);
+	do_fixup_sev();
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
+		/*
+		 * Release all physical cpus when not in hyp mode since we
+		 * might want to bring them online later.
+		 *
+		 * Also we need to get the execution into kernel code (it's
+		 * currently executing in u-boot).  u-boot releases the cores
+		 * from reset in hyp mode.
+		 */
+		if (!is_hyp_mode_available()) {
+			if (cpu != 0) {
+				u32 tmp = readl(syscon + 0x1010);
+				writel(0xab, syscon + 0x1000);
+				tmp &= ~(1 << cpu);
+				writel(tmp, syscon + 0x1010);
+			}
+		}
+
+		if (cpu_count < max_cpus) {
+			set_cpu_present(cpu, true);
+			cpu_count++;
+		}
+
+		/*
+		 * This is the entry point of the routine that the secondary
+		 * cores will execute once they are released from their
+		 * "holding pen".
+		 */
+		if (release_phys != 0)
+			write_release_addr(release_phys);
+	}
+
+	iounmap(syscon);
+}
+
+struct smp_operations axxia_smp_ops __initdata = {
+	.smp_prepare_cpus	= axxia_smp_prepare_cpus,
+	.smp_secondary_init	= axxia_secondary_init,
+	.smp_boot_secondary	= axxia_boot_secondary,
+};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index a367a98..18507ad 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
 # hardware specific clock types
 # please keep this section sorted lexicographically by file/directory path name
 obj-$(CONFIG_COMMON_CLK_AXI_CLKGEN)	+= clk-axi-clkgen.o
+obj-$(CONFIG_ARCH_AXXIA)		+= clk-axxia.o
 obj-$(CONFIG_ARCH_BCM2835)		+= clk-bcm2835.o
 obj-$(CONFIG_ARCH_EFM32)		+= clk-efm32gg.o
 obj-$(CONFIG_ARCH_HIGHBANK)		+= clk-highbank.o
diff --git a/drivers/clk/clk-axxia.c b/drivers/clk/clk-axxia.c
new file mode 100644
index 0000000..996b8f2
--- /dev/null
+++ b/drivers/clk/clk-axxia.c
@@ -0,0 +1,281 @@
+/*
+ * arch/arm/mach-axxia/clock.c
+ *
+ * Provides clock implementations for three different types of clock devices on
+ * the Axxia device: PLL clock, a clock divider and a clock mux.
+ *
+ * Copyright (C) 2012 LSI
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clk-provider.h>
+
+
+static void __iomem *
+parse_and_map_reg(struct device_node *node, u32 *shift, u32 *width)
+{
+	void __iomem *reg;
+
+	if (of_property_read_u32(node, "lsi,bit-shift", shift)) {
+		pr_err("%s: no 'lsi,bit-shift' property\n", node->name);
+		return NULL;
+	}
+
+	if (of_property_read_u32(node, "lsi,bit-width", width)) {
+		pr_err("%s: no 'lsi,bit-width' property\n", node->name);
+		return NULL;
+	}
+
+	reg = of_iomap(node, 0);
+	if (!reg)
+		pr_err("%s: failed to map register\n", node->name);
+
+	return reg;
+}
+
+/**
+ * struct axxia_pllclk - Axxia PLL generated clock.
+ * @hw: clk_hw for the PLL
+ * @regs: Pointer to control registers
+ */
+struct axxia_pllclk {
+	struct clk_hw hw;
+	void __iomem *regs;
+};
+
+#define to_axxia_pll(_hw) container_of(_hw, struct axxia_pllclk, hw)
+
+static unsigned long
+axxia_pllclk_recalc(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct axxia_pllclk *pll = to_axxia_pll(hw);
+	unsigned long rate, fbdiv, refdiv, postdiv;
+	u32 control;
+
+	control = readl(pll->regs);
+	postdiv = ((control >> 0) & 0xf) + 1;
+	fbdiv   = ((control >> 4) & 0xfff) + 3;
+	refdiv  = ((control >> 16) & 0x1f) + 1;
+	rate = (parent_rate / (refdiv * postdiv)) * fbdiv;
+
+	return rate;
+}
+
+static const struct clk_ops clk_pll_ops = {
+	.recalc_rate = axxia_pllclk_recalc,
+};
+
+static struct clk *
+register_axxia_pllclk(struct device *dev, const char *name,
+		      const char *parent_name, void __iomem *regs)
+{
+	struct clk_init_data init;
+	struct axxia_pllclk *pll;
+	struct clk *clk;
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	if (!pll)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &clk_pll_ops;
+	init.flags = 0;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	pll->regs = regs;
+	pll->hw.init = &init;
+
+	clk = clk_register(NULL, &pll->hw);
+	if (IS_ERR(clk))
+		kfree(pll);
+
+	return clk;
+}
+
+
+/**
+ * struct axxia_divclk - Axxia clock divider
+ * @hw: clk_hw for the divider
+ * @regs: Pointer to control registers
+ */
+struct axxia_divclk {
+	struct clk_hw hw;
+	void __iomem *regs;
+	int shift;
+	int width;
+};
+
+#define to_axxia_divclk(_hw) container_of(_hw, struct axxia_divclk, hw)
+
+static unsigned long
+axxia_divclk_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct axxia_divclk *divclk = to_axxia_divclk(hw);
+	u32 ctrl, div;
+
+	ctrl = readl(divclk->regs);
+	div = 1 + ((ctrl >> divclk->shift) & GENMASK(divclk->width-1, 0));
+
+	return parent_rate / div;
+}
+
+const struct clk_ops axxia_divclk_ops = {
+	.recalc_rate = axxia_divclk_recalc_rate,
+};
+
+static struct clk *
+register_axxia_divclk(struct device *dev, const char *name,
+		      const char *parent_name, void __iomem *regs,
+		      int shift, int width)
+{
+	struct axxia_divclk *div;
+	struct clk *clk;
+	struct clk_init_data init;
+
+	div = kzalloc(sizeof(struct axxia_divclk), GFP_KERNEL);
+	if (!div)
+		return ERR_PTR(-ENOMEM);
+
+	init.name = name;
+	init.ops = &axxia_divclk_ops;
+	init.flags = CLK_IS_BASIC;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	div->regs = regs;
+	div->shift = shift;
+	div->width = width;
+	div->hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(dev, &div->hw);
+	if (IS_ERR(clk))
+		kfree(div);
+
+	return clk;
+}
+
+/**
+ * axxia_pll_clk_init - Axxia PLL clock setup function
+ * @node: pointer to device tree node
+ */
+static void __init
+axxia_pll_clk_init(struct device_node *node)
+{
+	struct clk *clk;
+	const char *parent_name;
+	void __iomem *regs;
+	const char *clk_name = node->name;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+	if (!parent_name) {
+		pr_err("%s: no parent clock\n", node->name);
+		return;
+	}
+
+	regs = of_iomap(node, 0);
+	if (!regs) {
+		pr_err("%s: failed to map register\n", node->name);
+		return;
+	}
+
+	clk = register_axxia_pllclk(NULL, clk_name, parent_name, regs);
+	if (IS_ERR(clk)) {
+		pr_err("%s: register failed (%ld)\n", clk_name, PTR_ERR(clk));
+		iounmap(regs);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(axxia_pll_clk, "lsi,axxia-pll-clock", axxia_pll_clk_init);
+
+
+/**
+ * axxia_div_clk_init - Axxia clock divider setup function
+ * @node: device tree node for this clock
+ */
+static void __init
+axxia_div_clk_init(struct device_node *node)
+{
+	const char *parent_name;
+	void __iomem *reg;
+	u32 shift, width;
+	struct clk *clk;
+	const char *clk_name = node->name;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	parent_name = of_clk_get_parent_name(node, 0);
+	if (!parent_name) {
+		pr_err("%s: no parent clock\n", node->name);
+		return;
+	}
+
+	reg = parse_and_map_reg(node, &shift, &width);
+	if (!reg)
+		return;
+
+	clk = register_axxia_divclk(NULL, clk_name, parent_name, reg,
+				    shift, width);
+	if (IS_ERR(clk)) {
+		pr_err("%s: register failed (%ld)\n", clk_name, PTR_ERR(clk));
+		iounmap(reg);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(axxia_div_clk, "lsi,axxia-div-clock", axxia_div_clk_init);
+
+
+/**
+ * axxia_mux_clk_init - Clock mux setup function
+ * @node: device tree node for this clock
+ */
+static void __init
+axxia_mux_clk_init(struct device_node *node)
+{
+	void __iomem *reg;
+	struct clk *clk;
+	const char *parents[4];
+	int num_parents;
+	const char *clk_name = node->name;
+	u32 shift, width;
+	int i;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	for (i = 0; i < ARRAY_SIZE(parents); ++i) {
+		parents[i] = of_clk_get_parent_name(node, i);
+		if (!parents[i])
+			break;
+	}
+	num_parents = i;
+
+	reg = parse_and_map_reg(node, &shift, &width);
+	if (!reg)
+		return;
+
+	clk = clk_register_mux(NULL, clk_name, parents,
+			       num_parents, 0, reg, shift, width,
+			       CLK_MUX_READ_ONLY, NULL);
+	if (IS_ERR(clk)) {
+		pr_err("%s: register failed (%ld)\n", clk_name, PTR_ERR(clk));
+		iounmap(reg);
+		return;
+	}
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+CLK_OF_DECLARE(pll_mux_clock, "lsi,axxia-mux-clock", axxia_mux_clk_init);
-- 
1.8.3.2

