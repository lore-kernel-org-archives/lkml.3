Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaDDCSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 22:18:00 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41286 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaDDCRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 22:17:48 -0400
From: Alex Elder <elder@linaro.org>
To: mporter@linaro.org, bcm@fixthebug.org, devicetree@vger.kernel.org,
        arnd@arndb.de, sboyd@codeaurora.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: add SMP support for Broadcom mobile SoCs
Date: Thu,  3 Apr 2014 21:18:08 -0500
Message-Id: <1396577891-2713-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396577891-2713-1-git-send-email-elder@linaro.org>
References: <1396577891-2713-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds SMP support for BCM281XX and BCM21664 family SoCs.

This feature is controlled with a distinct config option such that a
SMP-enabled multi-v7 binary can be configured to run these SoCs in
uniprocessor mode.  Since this SMP functionality is used for
multiple Broadcom mobile chip families the config option is called
ARCH_BCM_MOBILE_SMP (for lack of a better name).

On SoCs of this type, the secondary core is not held in reset on
power-on.  Instead it loops in a ROM-based holding pen.  To release
it, one must write into a special register a jump address whose
low-order bits have been replaced with a secondary core's id, then
trigger an event with SEV.  On receipt of an event, the ROM code
will examine the register's contents, and if the low-order bits
match its cpu id, it will clear them and write the value back to the
register just prior to jumping to the address specified.

The location of the special register is defined in the device tree
using a "secondary-boot-reg" property in a node whose "enable-method"
matches.

Derived from code originally provided by Ray Jui <rjui@broadcom.com>

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-bcm/Kconfig   |   18 +++-
 arch/arm/mach-bcm/Makefile  |    5 +-
 arch/arm/mach-bcm/platsmp.c |  194 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-bcm/platsmp.c

diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 183fdef..863c623 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -14,7 +14,6 @@ config ARCH_BCM_MOBILE
 	depends on MMU
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_ERRATA_754322
-	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
 	select GPIO_BCM_KONA
 	select TICK_ONESHOT
@@ -31,18 +30,31 @@ menu "Broadcom Mobile SoC Selection"
 config ARCH_BCM_281XX
 	bool "Broadcom BCM281XX SoC family"
 	default y
+	select HAVE_SMP
 	help
-	  Enable support for the the BCM281XX family, which includes
+	  Enable support for the BCM281XX family, which includes
 	  BCM11130, BCM11140, BCM11351, BCM28145 and BCM28155
 	  variants.
 
 config ARCH_BCM_21664
 	bool "Broadcom BCM21664 SoC family"
 	default y
+	select HAVE_SMP
 	help
-	  Enable support for the the BCM21664 family, which includes
+	  Enable support for the BCM21664 family, which includes
 	  BCM21663 and BCM21664 variants.
 
+config ARCH_BCM_MOBILE_SMP
+	bool "Broadcom mobile SoC SMP support"
+	depends on (ARCH_BCM_281XX || ARCH_BCM_21664) && SMP
+	default y
+	select HAVE_ARM_SCU
+	select ARM_ERRATA_764369
+	help
+	  SMP support for the BCM281XX and BCM21664 SoC families.
+	  Provided as an option so SMP support for SoCs of this type
+	  can be disabled for an SMP-enabled kernel.
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index b2279e3..929579f 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -15,7 +15,10 @@ obj-$(CONFIG_ARCH_BCM_281XX)	+= board_bcm281xx.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 
 # BCM21664
-obj-$(CONFIG_ARCH_BCM_21664)	+= board_bcm21664.o
+obj-$(CONFIG_ARCH_BCM_21664)	:= board_bcm21664.o
+
+# BCM281XX and BCM21664 SMP support
+obj-$(CONFIG_ARCH_BCM_MOBILE_SMP) += platsmp.o
 
 # BCM281XX and BCM21664 L2 cache control
 obj-$(CONFIG_ARCH_BCM_MOBILE)	+= bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
diff --git a/arch/arm/mach-bcm/platsmp.c b/arch/arm/mach-bcm/platsmp.c
new file mode 100644
index 0000000..46a64f2
--- /dev/null
+++ b/arch/arm/mach-bcm/platsmp.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright (C) 2014 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/sched.h>
+
+#include <asm/smp.h>
+#include <asm/smp_plat.h>
+#include <asm/smp_scu.h>
+
+/* Size of mapped Cortex A9 SCU address space */
+#define SCU_SIZE        	0x58
+
+#define SECONDARY_TIMEOUT_NS	NSEC_PER_MSEC	/* 1 msec (in nanoseconds) */
+#define BOOT_ADDR_CPUID_MASK	0x3
+
+/* Name of device node property defining secondary boot register location */
+#define OF_SECONDARY_BOOT	"secondary-boot-reg"
+
+/* I/O address of register used to coordinate secondary core startup */
+static u32	secondary_boot;
+
+/*
+ * Enable the Cortex A9 Snoop Control Unit
+ *
+ * By the time this is called we already know there are multiple
+ * cores present.  We assume we're running on a Cortex A9 processor,
+ * so any trouble getting the base address register or getting the
+ * SCU base is a problem.
+ *
+ * Return 0 if successful or an error code otherwise.
+ */
+static int __init scu_a9_enable(void)
+{
+	unsigned long config_base;
+	void __iomem *scu_base;
+
+	if (!scu_a9_has_base()) {
+		pr_err("no configuration base address register!\n");
+		return -ENXIO;
+	}
+
+	/* Config base address register value is zero for uniprocessor */
+	config_base = scu_a9_get_base();
+	if (!config_base) {
+		pr_err("hardware reports only one core; disabling SMP\n");
+		return -ENOENT;
+	}
+
+	scu_base = ioremap((phys_addr_t)config_base, SCU_SIZE);
+	if (!scu_base) {
+		pr_err("failed to remap config base (%lu/%u) for SCU\n",
+			config_base, SCU_SIZE);
+		return -ENOMEM;
+	}
+
+	scu_enable(scu_base);
+
+	iounmap(scu_base);	/* That's the last we'll need of this */
+
+	return 0;
+}
+
+static void __init bcm_smp_prepare_cpus(unsigned int max_cpus)
+{
+	static cpumask_t only_cpu_0 = { CPU_BITS_CPU0 };
+	int ret;
+
+	/* Enable SCU on Cortex A9 based SoCs */
+	ret = scu_a9_enable();
+	if (!ret)
+		return;
+
+	/*
+	 * If we have a uniprocessor, make sure the CPU present map
+	 * reflects that.  Bail on any other failure to enable the SCU.
+	 */
+	if (ret == -ENOENT)
+		init_cpu_present(&only_cpu_0);
+	else
+		BUG();
+}
+
+/*
+ * Secondary startup method setup routine to extract the location of
+ * the secondary boot register from a "cpu" or "cpus" device tree
+ * node.  Only the first seen secondary boot register value is used;
+ * any others are ignored.  The secondary boot register value must be
+ * non-zero.
+ *
+ * Returns 0 if successful or an error code otherwise.
+ */
+static int __init of_enable_method_setup(struct device_node *node)
+{
+	int ret;
+
+	/* Ignore all but the first one specified */
+	if (secondary_boot)
+		return 0;
+
+	ret = of_property_read_u32(node, OF_SECONDARY_BOOT, &secondary_boot);
+	if (ret)
+		pr_err("%s: missing/invalid " OF_SECONDARY_BOOT " property\n",
+			node->name);
+
+	return ret;
+}
+
+/*
+ * The ROM code has the secondary cores looping, waiting for an event.
+ * When an event occurs each core examines the bottom two bits of the
+ * secondary boot register.  When a core finds those bits contain its
+ * own core id, it performs initialization, including computing its boot
+ * address by clearing the boot register value's bottom two bits.  The
+ * core signals that it is beginning its execution by writing its boot
+ * address back to the secondary boot register, and finally jumps to
+ * that address.
+ *
+ * So to start a core executing we need to:
+ * - Encode the (hardware) CPU id with the bottom bits of the secondary
+ *   start address.
+ * - Write that value into the secondary boot register.
+ * - Generate an event to wake up the secondary CPU(s).
+ * - Wait for the secondary boot register to be re-written, which
+ *   indicates the secondary core has started.
+ */
+static int bcm_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	void __iomem *boot_reg;
+	phys_addr_t boot_func;
+	u64 start_clock;
+	u32 cpu_id;
+	u32 boot_val;
+	bool timeout = false;
+
+	cpu_id = cpu_logical_map(cpu);
+	if (cpu_id & ~BOOT_ADDR_CPUID_MASK) {
+		pr_err("bad cpu id (%u > %u)\n", cpu_id, BOOT_ADDR_CPUID_MASK);
+		return -EINVAL;
+	}
+
+	if (!secondary_boot) {
+		pr_err("required secondary boot register not specified\n");
+		return -EINVAL;
+	}
+
+	boot_reg = ioremap_nocache((phys_addr_t)secondary_boot, sizeof(u32));
+	if (!boot_reg) {
+		pr_err("unable to map boot register for cpu %u\n", cpu_id);
+		return -ENOSYS;
+	}
+
+	boot_func = virt_to_phys(secondary_startup);
+	BUG_ON(boot_func & BOOT_ADDR_CPUID_MASK);
+	BUG_ON(boot_func > (phys_addr_t)U32_MAX);
+
+	boot_val = (u32)boot_func | cpu_id;
+	writel_relaxed(boot_val, boot_reg);
+
+	sev();
+
+	start_clock = local_clock();
+	while (!timeout && readl_relaxed(boot_reg) == boot_val)
+		timeout = local_clock() - start_clock > SECONDARY_TIMEOUT_NS;
+
+	iounmap(boot_reg);
+
+	if (!timeout)
+		return 0;
+
+	pr_err("timeout waiting for cpu %u to start\n", cpu_id);
+
+	return -ENOSYS;
+}
+
+static struct smp_operations bcm_smp_ops __initdata = {
+	.smp_prepare_cpus	= bcm_smp_prepare_cpus,
+	.smp_boot_secondary	= bcm_boot_secondary,
+};
+CPU_METHOD_OF_DECLARE_SETUP(bcm_smp_bcm281xx, "brcm,bcm11351-cpu-method",
+		&of_enable_method_setup, &bcm_smp_ops);
-- 
1.7.9.5

