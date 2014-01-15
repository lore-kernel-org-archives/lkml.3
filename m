Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaAOVo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:44:28 -0500
Received: from gloria.sntech.de ([95.129.55.99]:40057 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaAOVoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:44:25 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: arm@kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH v6 6/6] ARM: rockchip: add smp bringup code
Date: Wed, 15 Jan 2014 22:43:53 +0100
Message-ID: <4191077.93tRRdBt5E@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <27256277.YJ687suYy5@phil>
References: <27256277.YJ687suYy5@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the necessary smp-operations and startup code to use
additional cores on Rockchip SoCs.

We currently hog the power management unit in the smp code, as it is
necessary to control the power to the cpu core and nothing else is
currently using it, so a generic implementation can be done later.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
---
 arch/arm/mach-rockchip/Makefile   |    1 +
 arch/arm/mach-rockchip/core.h     |   22 ++++
 arch/arm/mach-rockchip/headsmp.S  |   30 ++++++
 arch/arm/mach-rockchip/platsmp.c  |  208 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-rockchip/rockchip.c |    2 +
 5 files changed, 263 insertions(+)
 create mode 100644 arch/arm/mach-rockchip/core.h
 create mode 100644 arch/arm/mach-rockchip/headsmp.S
 create mode 100644 arch/arm/mach-rockchip/platsmp.c

diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
index 1547d4f..4377a14 100644
--- a/arch/arm/mach-rockchip/Makefile
+++ b/arch/arm/mach-rockchip/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
+obj-$(CONFIG_SMP) += headsmp.o platsmp.o
diff --git a/arch/arm/mach-rockchip/core.h b/arch/arm/mach-rockchip/core.h
new file mode 100644
index 0000000..e2e7c9d
--- /dev/null
+++ b/arch/arm/mach-rockchip/core.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
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
+
+extern char rockchip_secondary_trampoline;
+extern char rockchip_secondary_trampoline_end;
+
+extern unsigned long rockchip_boot_fn;
+extern void rockchip_secondary_startup(void);
+
+extern struct smp_operations rockchip_smp_ops;
diff --git a/arch/arm/mach-rockchip/headsmp.S b/arch/arm/mach-rockchip/headsmp.S
new file mode 100644
index 0000000..73206e3
--- /dev/null
+++ b/arch/arm/mach-rockchip/headsmp.S
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
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
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+ENTRY(rockchip_secondary_startup)
+	bl	v7_invalidate_l1
+	b	secondary_startup
+ENDPROC(rockchip_secondary_startup)
+
+ENTRY(rockchip_secondary_trampoline)
+	ldr	pc, 1f
+ENDPROC(rockchip_secondary_trampoline)
+	.globl	rockchip_boot_fn
+rockchip_boot_fn:
+1:	.space	4
+
+ENTRY(rockchip_secondary_trampoline_end)
diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
new file mode 100644
index 0000000..3459b17
--- /dev/null
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
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
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include <asm/cacheflush.h>
+#include <asm/smp_scu.h>
+#include <asm/smp_plat.h>
+#include <asm/mach/map.h>
+
+#include "core.h"
+
+static void __iomem *scu_base_addr;
+static void __iomem *sram_base_addr;
+static int ncores;
+
+#define PMU_PWRDN_CON		0x08
+#define PMU_PWRDN_ST		0x0c
+
+#define PMU_PWRDN_SCU		4
+
+static void __iomem *pmu_base_addr;
+
+static inline bool pmu_power_domain_is_on(int pd)
+{
+	return !(readl_relaxed(pmu_base_addr + PMU_PWRDN_ST) & BIT(pd));
+}
+
+static void pmu_set_power_domain(int pd, bool on)
+{
+	u32 val = readl_relaxed(pmu_base_addr + PMU_PWRDN_CON);
+	if (on)
+		val &= ~BIT(pd);
+	else
+		val |=  BIT(pd);
+	writel(val, pmu_base_addr + PMU_PWRDN_CON);
+
+	while (pmu_power_domain_is_on(pd) != on) { }
+}
+
+/*
+ * Handling of CPU cores
+ */
+
+static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
+					     struct task_struct *idle)
+{
+	if (!sram_base_addr || !pmu_base_addr) {
+		pr_err("%s: sram or pmu missing for cpu boot\n", __func__);
+		return -ENXIO;
+	}
+
+	if (cpu >= ncores) {
+		pr_err("%s: cpu %d outside maximum number of cpus %d\n",
+							__func__, cpu, ncores);
+		return -ENXIO;
+	}
+
+	/* start the core */
+	pmu_set_power_domain(0 + cpu, true);
+
+	return 0;
+}
+
+/**
+ * rockchip_smp_prepare_sram - populate necessary sram block
+ * Starting cores execute the code residing at the start of the on-chip sram
+ * after power-on. Therefore make sure, this sram region is reserved and
+ * big enough. After this check, copy the trampoline code that directs the
+ * core to the real startup code in ram into the sram-region.
+ * @node: mmio-sram device node
+ */
+static int __init rockchip_smp_prepare_sram(struct device_node *node)
+{
+	unsigned int trampoline_sz = &rockchip_secondary_trampoline_end -
+					    &rockchip_secondary_trampoline;
+	const __be32 *reserved_list = NULL;
+	int reserved_size;
+	int rstart = -1;
+	unsigned int rsize;
+	unsigned int i;
+
+	reserved_list = of_get_property(node, "mmio-sram-reserved",
+					&reserved_size);
+	if (!reserved_list) {
+		pr_err("%s: wrong number of arguments in mmio-sram-reserved\n",
+		       __func__);
+		return -ENOENT;
+	}
+
+	reserved_size /= sizeof(*reserved_list);
+	if (!reserved_size || reserved_size % 2) {
+		pr_err("%s: wrong number of arguments in mmio-sram-reserved\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < reserved_size; i += 2) {
+		/* get the next reserved block */
+		rstart = be32_to_cpu(*reserved_list++);
+		rsize = be32_to_cpu(*reserved_list++);
+
+		if (!rstart)
+			break;
+	}
+
+	if (rstart) {
+		pr_err("%s: start of sram is not reserved from mmio-sram\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	if (rsize < trampoline_sz) {
+		pr_err("%s: reserved block with size 0x%x is to small for trampoline size 0x%x\n",
+		       __func__, rsize, trampoline_sz);
+		return -EINVAL;
+	}
+
+	sram_base_addr = of_iomap(node, 0);
+
+	/* set the boot function for the sram code */
+	rockchip_boot_fn = virt_to_phys(rockchip_secondary_startup);
+
+	/* copy the trampoline to sram, that runs during startup of the core */
+	memcpy(sram_base_addr, &rockchip_secondary_trampoline, trampoline_sz);
+	flush_cache_all();
+	outer_clean_range(0, trampoline_sz);
+
+	dsb_sev();
+
+	return 0;
+}
+
+static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
+{
+	struct device_node *node;
+	unsigned int i;
+
+	node = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
+	if (!node) {
+		pr_err("%s: missing scu\n", __func__);
+		return;
+	}
+
+	scu_base_addr = of_iomap(node, 0);
+	if (!scu_base_addr) {
+		pr_err("%s: could not map scu registers\n", __func__);
+		return;
+	}
+
+	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-sram");
+	if (!node) {
+		pr_err("%s: could not find sram dt node\n", __func__);
+		return;
+	}
+
+	if (rockchip_smp_prepare_sram(node))
+		return;
+
+	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-pmu");
+	if (!node) {
+		pr_err("%s: could not find sram dt node\n", __func__);
+		return;
+	}
+
+	pmu_base_addr = of_iomap(node, 0);
+	if (!pmu_base_addr) {
+		pr_err("%s: could not map pmu registers\n", __func__);
+		return;
+	}
+
+	/* enable the SCU power domain */
+	pmu_set_power_domain(PMU_PWRDN_SCU, true);
+
+	/*
+	 * While the number of cpus is gathered from dt, also get the number
+	 * of cores from the scu to verify this value when booting the cores.
+	 */
+	ncores = scu_get_core_count(scu_base_addr);
+
+	scu_enable(scu_base_addr);
+
+	/* Make sure that all cores except the first are really off */
+	for (i = 1; i < ncores; i++)
+		pmu_set_power_domain(0 + i, false);
+}
+
+struct smp_operations rockchip_smp_ops __initdata = {
+	.smp_prepare_cpus	= rockchip_smp_prepare_cpus,
+	.smp_boot_secondary	= rockchip_boot_secondary,
+};
diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchip/rockchip.c
index 82c0b07..d211d6f 100644
--- a/arch/arm/mach-rockchip/rockchip.c
+++ b/arch/arm/mach-rockchip/rockchip.c
@@ -22,6 +22,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/hardware/cache-l2x0.h>
+#include "core.h"
 
 static void __init rockchip_dt_init(void)
 {
@@ -38,6 +39,7 @@ static const char * const rockchip_board_dt_compat[] = {
 };
 
 DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
+	.smp		= smp_ops(rockchip_smp_ops),
 	.init_machine	= rockchip_dt_init,
 	.dt_compat	= rockchip_board_dt_compat,
 MACHINE_END
-- 
1.7.10.4


