Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaLAIw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:52:58 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58525 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbaLAIwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:52:55 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org
Cc: mturquette@linaro.org, Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Tony Xie <xxx@rock-chips.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 1/4] ARM: rockchip: add suspend and resume for RK3288
Date: Mon,  1 Dec 2014 16:52:17 +0800
Message-Id: <1417423940-1669-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a basic version of suspend and resume for rockchip,
it only support RK3288 now.

Signed-off-by: Tony Xie <xxx@rock-chips.com>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>

---

Changes in v10: None
Changes in v9:
- fold Doug's patches
- modify some print log

Changes in v8:
- use enum for define sleep mode
- move rk3288_config_bootdata to the front of sram memcpy

Changes in v7:
- get rid all of unused code

Changes in v6:
- get rid of the save/restore of SRAM
- doing the copy of resume code once at init time
- remove ROCKCHIP_ARM_OFF_LOGIC_DEEP from rk3288_fill_in_bootram
- add of_platform_populate in rockchip_dt_init

Changes in v5:
- use rk3288_bootram_sz for memcpy size
- fixed error of sram save and restore

Changes in v4:
- remove grf regmap

Changes in v3:
- move the pinmux of gpio6_c6 save and restore to pinctrl-rockchip

Changes in v2:
- add the regulator calls in prepare and finish.
- add the pinmux of gpio6_c6 save and restore

 arch/arm/mach-rockchip/Makefile   |   1 +
 arch/arm/mach-rockchip/pm.c       | 260 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-rockchip/pm.h       |  99 +++++++++++++++
 arch/arm/mach-rockchip/rockchip.c |   2 +
 arch/arm/mach-rockchip/sleep.S    |  73 +++++++++++
 5 files changed, 435 insertions(+)
 create mode 100644 arch/arm/mach-rockchip/pm.c
 create mode 100644 arch/arm/mach-rockchip/pm.h
 create mode 100644 arch/arm/mach-rockchip/sleep.S

diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
index b29d8ea..5c3a9b2 100644
--- a/arch/arm/mach-rockchip/Makefile
+++ b/arch/arm/mach-rockchip/Makefile
@@ -1,4 +1,5 @@
 CFLAGS_platsmp.o := -march=armv7-a
 
 obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
+obj-$(CONFIG_PM_SLEEP) += pm.o sleep.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
diff --git a/arch/arm/mach-rockchip/pm.c b/arch/arm/mach-rockchip/pm.c
new file mode 100644
index 0000000..50cb781
--- /dev/null
+++ b/arch/arm/mach-rockchip/pm.c
@@ -0,0 +1,260 @@
+/*
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ * Author: Tony Xie <tony.xie@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/regmap.h>
+#include <linux/suspend.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regulator/machine.h>
+
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+#include <asm/suspend.h>
+
+#include "pm.h"
+
+/* These enum are option of low power mode */
+enum {
+	ROCKCHIP_ARM_OFF_LOGIC_NORMAL = 0,
+	ROCKCHIP_ARM_OFF_LOGIC_DEEP = 1,
+};
+
+struct rockchip_pm_data {
+	const struct platform_suspend_ops *ops;
+	int (*init)(struct device_node *np);
+};
+
+static void __iomem *rk3288_bootram_base;
+static phys_addr_t rk3288_bootram_phy;
+
+static struct regmap *pmu_regmap;
+static struct regmap *sgrf_regmap;
+
+static u32 rk3288_pmu_pwr_mode_con;
+static u32 rk3288_sgrf_soc_con0;
+
+static inline u32 rk3288_l2_config(void)
+{
+	u32 l2ctlr;
+
+	asm("mrc p15, 1, %0, c9, c0, 2" : "=r" (l2ctlr));
+	return l2ctlr;
+}
+
+static void rk3288_config_bootdata(void)
+{
+	rkpm_bootdata_cpusp = rk3288_bootram_phy + (SZ_4K - 8);
+	rkpm_bootdata_cpu_code = virt_to_phys(cpu_resume);
+
+	rkpm_bootdata_l2ctlr_f  = 1;
+	rkpm_bootdata_l2ctlr = rk3288_l2_config();
+}
+
+static void rk3288_slp_mode_set(int level)
+{
+	u32 mode_set, mode_set1;
+
+	regmap_read(sgrf_regmap, RK3288_SGRF_SOC_CON0, &rk3288_sgrf_soc_con0);
+
+	regmap_read(pmu_regmap, RK3288_PMU_PWRMODE_CON,
+		    &rk3288_pmu_pwr_mode_con);
+
+	/* set bit 8 so that system will resume to FAST_BOOT_ADDR */
+	regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
+		     SGRF_FAST_BOOT_EN | SGRF_FAST_BOOT_EN_WRITE);
+
+	/* booting address of resuming system is from this register value */
+	regmap_write(sgrf_regmap, RK3288_SGRF_FAST_BOOT_ADDR,
+		     rk3288_bootram_phy);
+
+	regmap_write(pmu_regmap, RK3288_PMU_WAKEUP_CFG1,
+		     PMU_ARMINT_WAKEUP_EN);
+
+	mode_set = BIT(PMU_GLOBAL_INT_DISABLE) | BIT(PMU_L2FLUSH_EN) |
+		   BIT(PMU_SREF0_ENTER_EN) | BIT(PMU_SREF1_ENTER_EN) |
+		   BIT(PMU_DDR0_GATING_EN) | BIT(PMU_DDR1_GATING_EN) |
+		   BIT(PMU_PWR_MODE_EN) | BIT(PMU_CHIP_PD_EN) |
+		   BIT(PMU_SCU_EN);
+
+	mode_set1 = BIT(PMU_CLR_CORE) | BIT(PMU_CLR_CPUP);
+
+	if (level == ROCKCHIP_ARM_OFF_LOGIC_DEEP) {
+		/* arm off, logic deep sleep */
+		mode_set |= BIT(PMU_BUS_PD_EN) |
+			    BIT(PMU_DDR1IO_RET_EN) | BIT(PMU_DDR0IO_RET_EN) |
+			    BIT(PMU_OSC_24M_DIS) | BIT(PMU_PMU_USE_LF) |
+			    BIT(PMU_ALIVE_USE_LF) | BIT(PMU_PLL_PD_EN);
+
+		mode_set1 |= BIT(PMU_CLR_ALIVE) | BIT(PMU_CLR_BUS) |
+			     BIT(PMU_CLR_PERI) | BIT(PMU_CLR_DMA);
+	} else {
+		/*
+		 * arm off, logic normal
+		 * if pmu_clk_core_src_gate_en is not set,
+		 * wakeup will be error
+		 */
+		mode_set |= BIT(PMU_CLK_CORE_SRC_GATE_EN);
+	}
+
+	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON, mode_set);
+	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON1, mode_set1);
+}
+
+static void rk3288_slp_mode_set_resume(void)
+{
+	regmap_write(pmu_regmap, RK3288_PMU_PWRMODE_CON,
+		     rk3288_pmu_pwr_mode_con);
+
+	regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
+		     rk3288_sgrf_soc_con0 | SGRF_FAST_BOOT_EN_WRITE);
+}
+
+static int rockchip_lpmode_enter(unsigned long arg)
+{
+	flush_cache_all();
+
+	cpu_do_idle();
+
+	pr_err("%s: Failed to suspend\n", __func__);
+
+	return 1;
+}
+
+static int rk3288_suspend_enter(suspend_state_t state)
+{
+	local_fiq_disable();
+
+	rk3288_slp_mode_set(ROCKCHIP_ARM_OFF_LOGIC_NORMAL);
+
+	cpu_suspend(0, rockchip_lpmode_enter);
+
+	rk3288_slp_mode_set_resume();
+
+	local_fiq_enable();
+
+	return 0;
+}
+
+static int rk3288_suspend_prepare(void)
+{
+	return regulator_suspend_prepare(PM_SUSPEND_MEM);
+}
+
+static void rk3288_suspend_finish(void)
+{
+	if (regulator_suspend_finish())
+		pr_err("%s: Suspend finish failed\n", __func__);
+}
+
+static int rk3288_suspend_init(struct device_node *np)
+{
+	struct device_node *sram_np;
+	struct resource res;
+	int ret;
+
+	pmu_regmap = syscon_node_to_regmap(np);
+	if (IS_ERR(pmu_regmap)) {
+		pr_err("%s: could not find pmu regmap\n", __func__);
+		return PTR_ERR(pmu_regmap);
+	}
+
+	sgrf_regmap = syscon_regmap_lookup_by_compatible(
+				"rockchip,rk3288-sgrf");
+	if (IS_ERR(sgrf_regmap)) {
+		pr_err("%s: could not find sgrf regmap\n", __func__);
+		return PTR_ERR(pmu_regmap);
+	}
+
+	sram_np = of_find_compatible_node(NULL, NULL,
+					  "rockchip,rk3288-pmu-sram");
+	if (!sram_np) {
+		pr_err("%s: could not find bootram dt node\n", __func__);
+		return -ENODEV;
+	}
+
+	rk3288_bootram_base = of_iomap(sram_np, 0);
+	if (!rk3288_bootram_base) {
+		pr_err("%s: could not map bootram base\n", __func__);
+		return -ENOMEM;
+	}
+
+	ret = of_address_to_resource(sram_np, 0, &res);
+	if (ret) {
+		pr_err("%s: could not get bootram phy addr\n", __func__);
+		return ret;
+	}
+	rk3288_bootram_phy = res.start;
+
+	of_node_put(sram_np);
+
+	rk3288_config_bootdata();
+
+	/* copy resume code and data to bootsram */
+	memcpy(rk3288_bootram_base, rockchip_slp_cpu_resume,
+	       rk3288_bootram_sz);
+
+	return 0;
+}
+
+static const struct platform_suspend_ops rk3288_suspend_ops = {
+	.enter   = rk3288_suspend_enter,
+	.valid   = suspend_valid_only_mem,
+	.prepare = rk3288_suspend_prepare,
+	.finish  = rk3288_suspend_finish,
+};
+
+static const struct rockchip_pm_data rk3288_pm_data __initconst = {
+	.ops = &rk3288_suspend_ops,
+	.init = rk3288_suspend_init,
+};
+
+static const struct of_device_id rockchip_pmu_of_device_ids[] __initconst = {
+	{
+		.compatible = "rockchip,rk3288-pmu",
+		.data = &rk3288_pm_data,
+	},
+	{ /* sentinel */ },
+};
+
+void __init rockchip_suspend_init(void)
+{
+	const struct rockchip_pm_data *pm_data;
+	const struct of_device_id *match;
+	struct device_node *np;
+	int ret;
+
+	np = of_find_matching_node_and_match(NULL, rockchip_pmu_of_device_ids,
+					     &match);
+	if (!match) {
+		pr_err("Failed to find PMU node\n");
+		return;
+	}
+	pm_data = (struct rockchip_pm_data *) match->data;
+
+	if (pm_data->init) {
+		ret = pm_data->init(np);
+
+		if (ret) {
+			pr_err("%s: matches init error %d\n", __func__, ret);
+			return;
+		}
+	}
+
+	suspend_set_ops(pm_data->ops);
+}
diff --git a/arch/arm/mach-rockchip/pm.h b/arch/arm/mach-rockchip/pm.h
new file mode 100644
index 0000000..99722d0
--- /dev/null
+++ b/arch/arm/mach-rockchip/pm.h
@@ -0,0 +1,99 @@
+/*
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ * Author: Tony Xie <tony.xie@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __MACH_ROCKCHIP_PM_H
+#define __MACH_ROCKCHIP_PM_H
+
+extern unsigned long rkpm_bootdata_cpusp;
+extern unsigned long rkpm_bootdata_cpu_code;
+extern unsigned long rkpm_bootdata_l2ctlr_f;
+extern unsigned long rkpm_bootdata_l2ctlr;
+extern unsigned long rkpm_bootdata_ddr_code;
+extern unsigned long rkpm_bootdata_ddr_data;
+extern unsigned long rk3288_bootram_sz;
+
+void rockchip_slp_cpu_resume(void);
+void __init rockchip_suspend_init(void);
+
+/****** following is rk3288 defined **********/
+#define RK3288_PMU_WAKEUP_CFG0          0x00
+#define RK3288_PMU_WAKEUP_CFG1          0x04
+#define RK3288_PMU_PWRMODE_CON          0x18
+#define RK3288_PMU_OSC_CNT              0x20
+#define RK3288_PMU_PLL_CNT              0x24
+#define RK3288_PMU_STABL_CNT            0x28
+#define RK3288_PMU_DDR0IO_PWRON_CNT     0x2c
+#define RK3288_PMU_DDR1IO_PWRON_CNT     0x30
+#define RK3288_PMU_CORE_PWRDWN_CNT      0x34
+#define RK3288_PMU_CORE_PWRUP_CNT       0x38
+#define RK3288_PMU_GPU_PWRDWN_CNT       0x3c
+#define RK3288_PMU_GPU_PWRUP_CNT        0x40
+#define RK3288_PMU_WAKEUP_RST_CLR_CNT   0x44
+#define RK3288_PMU_PWRMODE_CON1         0x90
+
+#define RK3288_SGRF_SOC_CON0            (0x0000)
+#define RK3288_SGRF_FAST_BOOT_ADDR      (0x0120)
+#define SGRF_FAST_BOOT_EN		BIT(8)
+#define SGRF_FAST_BOOT_EN_WRITE		BIT(24)
+
+#define RK3288_CRU_MODE_CON (0x50)
+#define RK3288_CRU_SEL0_CON (0x60)
+#define RK3288_CRU_SEL1_CON (0x64)
+#define RK3288_CRU_SEL10_CON (0x88)
+#define RK3288_CRU_SEL33_CON (0xe4)
+#define RK3288_CRU_SEL37_CON (0xf4)
+
+/* PMU_WAKEUP_CFG1 bits */
+#define PMU_ARMINT_WAKEUP_EN BIT(0)
+
+enum rk3288_pwr_mode_con {
+	PMU_PWR_MODE_EN = 0,
+	PMU_CLK_CORE_SRC_GATE_EN,
+	PMU_GLOBAL_INT_DISABLE,
+	PMU_L2FLUSH_EN,
+	PMU_BUS_PD_EN,
+	PMU_A12_0_PD_EN,
+	PMU_SCU_EN,
+	PMU_PLL_PD_EN,
+	PMU_CHIP_PD_EN, /* POWER OFF PIN ENABLE */
+	PMU_PWROFF_COMB,
+	PMU_ALIVE_USE_LF,
+	PMU_PMU_USE_LF,
+	PMU_OSC_24M_DIS,
+	PMU_INPUT_CLAMP_EN,
+	PMU_WAKEUP_RESET_EN,
+	PMU_SREF0_ENTER_EN,
+	PMU_SREF1_ENTER_EN,
+	PMU_DDR0IO_RET_EN,
+	PMU_DDR1IO_RET_EN,
+	PMU_DDR0_GATING_EN,
+	PMU_DDR1_GATING_EN,
+	PMU_DDR0IO_RET_DE_REQ,
+	PMU_DDR1IO_RET_DE_REQ
+};
+
+enum rk3288_pwr_mode_con1 {
+	PMU_CLR_BUS = 0,
+	PMU_CLR_CORE,
+	PMU_CLR_CPUP,
+	PMU_CLR_ALIVE,
+	PMU_CLR_DMA,
+	PMU_CLR_PERI,
+	PMU_CLR_GPU,
+	PMU_CLR_VIDEO,
+	PMU_CLR_HEVC,
+	PMU_CLR_VIO,
+};
+
+#endif /* __MACH_ROCKCHIP_PM_H */
diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchip/rockchip.c
index d226b71..2b68a1a 100644
--- a/arch/arm/mach-rockchip/rockchip.c
+++ b/arch/arm/mach-rockchip/rockchip.c
@@ -23,9 +23,11 @@
 #include <asm/mach/map.h>
 #include <asm/hardware/cache-l2x0.h>
 #include "core.h"
+#include "pm.h"
 
 static void __init rockchip_dt_init(void)
 {
+	rockchip_suspend_init();
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 	platform_device_register_simple("cpufreq-dt", 0, NULL, 0);
 }
diff --git a/arch/arm/mach-rockchip/sleep.S b/arch/arm/mach-rockchip/sleep.S
new file mode 100644
index 0000000..2eec9a3
--- /dev/null
+++ b/arch/arm/mach-rockchip/sleep.S
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ * Author: Tony Xie <tony.xie@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/memory.h>
+
+.data
+/*
+ * this code will be copied from
+ * ddr to sram for system resumeing.
+ * so it is ".data section".
+ */
+.align
+
+ENTRY(rockchip_slp_cpu_resume)
+	setmode	PSR_I_BIT | PSR_F_BIT | SVC_MODE, r1  @ set svc, irqs off
+	mrc	p15, 0, r1, c0, c0, 5
+	and	r1, r1, #0xf
+	cmp	r1, #0
+	/* olny cpu0 can continue to run, the others is halt here */
+	beq	cpu0run
+secondary_loop:
+	wfe
+	b	secondary_loop
+cpu0run:
+	ldr	r3, rkpm_bootdata_l2ctlr_f
+	cmp	r3, #0
+	beq	sp_set
+	ldr	r3, rkpm_bootdata_l2ctlr
+	mcr	p15, 1, r3, c9, c0, 2
+sp_set:
+	ldr	sp, rkpm_bootdata_cpusp
+	ldr	r1, rkpm_bootdata_cpu_code
+	bx	r1
+ENDPROC(rockchip_slp_cpu_resume)
+
+/* Parameters filled in by the kernel */
+
+/* Flag for whether to restore L2CTLR on resume */
+	.global rkpm_bootdata_l2ctlr_f
+rkpm_bootdata_l2ctlr_f:
+	.long 0
+
+/* Saved L2CTLR to restore on resume */
+	.global rkpm_bootdata_l2ctlr
+rkpm_bootdata_l2ctlr:
+	.long 0
+
+/* CPU resume SP addr */
+	.globl rkpm_bootdata_cpusp
+rkpm_bootdata_cpusp:
+	.long 0
+
+/* CPU resume function (physical address) */
+	.globl rkpm_bootdata_cpu_code
+rkpm_bootdata_cpu_code:
+	.long 0
+
+ENTRY(rk3288_bootram_sz)
+        .word   . - rockchip_slp_cpu_resume
-- 
1.9.1

