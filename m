Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaJMUMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:12:50 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37045 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbaJMUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:12:12 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
Date: Mon, 13 Oct 2014 13:12:00 -0700
Message-Id: <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add basic rk3288 smp support.

Only cortex-A9 need invalid L1, A7/A12/A15/A17 should not invalid L1, since
for A7/A12/A15, the invalidation would be taken as clean and invalidate.

If you use the software manual invalidation instead of hardware invalidation
(assert l1/l2rstdisable during reset) after reset, there is tiny change that
some cachelines would be in dirty and valid state after reset(since the ram
content would be random value after reset), then the unexpected clean might
lead to system crash.

It is a known issue for the A12/A17 MPCore multiprocessor that the active
processors might be stalled when the individual processor is powered down,
we can avoid this prolbem by softreset the processor before power it down.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v4:
- merge patch "fix up rk3288 smp cpu hotplug" into this patch

Changes in v3:
- use one ops and secondary_starup for all rockchip SOCs
- pick back the power domain operation for cpu hotplug

Changes in v2:
- use rk3288_boot_secondary instead ofsmp_boot_secondary
- discards the power domain operation
- handle the per cpu starup when actived by 'sev'

 arch/arm/mach-rockchip/headsmp.S |   5 +-
 arch/arm/mach-rockchip/platsmp.c | 120 +++++++++++++++++++++++++++++++--------
 2 files changed, 100 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-rockchip/headsmp.S b/arch/arm/mach-rockchip/headsmp.S
index 73206e3..46c22de 100644
--- a/arch/arm/mach-rockchip/headsmp.S
+++ b/arch/arm/mach-rockchip/headsmp.S
@@ -16,7 +16,10 @@
 #include <linux/init.h>
 
 ENTRY(rockchip_secondary_startup)
-	bl	v7_invalidate_l1
+	mrc	p15, 0, r0, c0, c0, 0	@ read main ID register
+	ldr	r1, =0x00000c09		@ Cortex-A9 primary part number
+	teq	r0, r1
+	beq	v7_invalidate_l1
 	b	secondary_startup
 ENDPROC(rockchip_secondary_startup)
 
diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index 57b53b3..866579e 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -22,6 +22,8 @@
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
 
+#include <linux/reset.h>
+#include <linux/cpu.h>
 #include <asm/cacheflush.h>
 #include <asm/cp15.h>
 #include <asm/smp_scu.h>
@@ -53,11 +55,47 @@ static int pmu_power_domain_is_on(int pd)
 	return !(val & BIT(pd));
 }
 
+struct reset_control *rockchip_get_core_reset(int cpu)
+{
+	struct device *dev = get_cpu_device(cpu);
+	struct device_node *np;
+
+	/* The cpu device is only available after the initial core bringup */
+	if (dev)
+		np = dev->of_node;
+	else
+		np = of_get_cpu_node(cpu, 0);
+
+	return of_reset_control_get(np, NULL);
+}
+
 static int pmu_set_power_domain(int pd, bool on)
 {
 	u32 val = (on) ? 0 : BIT(pd);
 	int ret;
 
+	/*
+	 * We need to soft reset the cpu when we turn off the cpu power domain,
+	 * or else the active processors might be stalled when the individual
+	 * processor is powered down.
+	 */
+	if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
+		struct reset_control *rstc = rockchip_get_core_reset(pd);
+
+		if (IS_ERR(rstc)) {
+			pr_err("%s: could not get reset control for core %d\n",
+			       __func__, pd);
+			return PTR_ERR(rstc);
+		}
+
+		if (on)
+			reset_control_deassert(rstc);
+		else
+			reset_control_assert(rstc);
+
+		reset_control_put(rstc);
+	}
+
 	ret = regmap_update_bits(pmu, PMU_PWRDN_CON, BIT(pd), val);
 	if (ret < 0) {
 		pr_err("%s: could not update power domain\n", __func__);
@@ -84,6 +122,8 @@ static int pmu_set_power_domain(int pd, bool on)
 static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
 					     struct task_struct *idle)
 {
+	int ret;
+
 	if (!sram_base_addr || !pmu) {
 		pr_err("%s: sram or pmu missing for cpu boot\n", __func__);
 		return -ENXIO;
@@ -96,7 +136,26 @@ static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
 	}
 
 	/* start the core */
-	return pmu_set_power_domain(0 + cpu, true);
+	ret = pmu_set_power_domain(0 + cpu, true);
+	if (ret < 0)
+		return ret;
+
+	if (read_cpuid_part() != ARM_CPU_PART_CORTEX_A9) {
+		/* We communicate with the bootrom to active the cpus other
+		 * than cpu0, after a blob of initialize code, they will
+		 * stay at wfe state, once they are actived, they will check
+		 * the mailbox:
+		 * sram_base_addr + 4: 0xdeadbeaf
+		 * sram_base_addr + 8: start address for pc
+		 * */
+		udelay(10);
+		writel(virt_to_phys(rockchip_secondary_startup),
+			sram_base_addr + 8);
+		writel(0xDEADBEAF, sram_base_addr + 4);
+		dsb_sev();
+	}
+
+	return 0;
 }
 
 /**
@@ -129,8 +188,6 @@ static int __init rockchip_smp_prepare_sram(struct device_node *node)
 		return -EINVAL;
 	}
 
-	sram_base_addr = of_iomap(node, 0);
-
 	/* set the boot function for the sram code */
 	rockchip_boot_fn = virt_to_phys(rockchip_secondary_startup);
 
@@ -204,40 +261,55 @@ static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
 	struct device_node *node;
 	unsigned int i;
 
-	node = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
-	if (!node) {
-		pr_err("%s: missing scu\n", __func__);
-		return;
-	}
-
-	scu_base_addr = of_iomap(node, 0);
-	if (!scu_base_addr) {
-		pr_err("%s: could not map scu registers\n", __func__);
-		return;
-	}
-
 	node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-smp-sram");
 	if (!node) {
 		pr_err("%s: could not find sram dt node\n", __func__);
 		return;
 	}
 
-	if (rockchip_smp_prepare_sram(node))
+	sram_base_addr = of_iomap(node, 0);
+	if (!sram_base_addr) {
+		pr_err("%s: could not map sram registers\n", __func__);
 		return;
+	}
 
 	if (rockchip_smp_prepare_pmu())
 		return;
 
-	/* enable the SCU power domain */
-	pmu_set_power_domain(PMU_PWRDN_SCU, true);
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		if (rockchip_smp_prepare_sram(node))
+			return;
 
-	/*
-	 * While the number of cpus is gathered from dt, also get the number
-	 * of cores from the scu to verify this value when booting the cores.
-	 */
-	ncores = scu_get_core_count(scu_base_addr);
+		/* enable the SCU power domain */
+		pmu_set_power_domain(PMU_PWRDN_SCU, true);
+
+		node = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
+		if (!node) {
+			pr_err("%s: missing scu\n", __func__);
+			return;
+		}
 
-	scu_enable(scu_base_addr);
+		scu_base_addr = of_iomap(node, 0);
+		if (!scu_base_addr) {
+			pr_err("%s: could not map scu registers\n", __func__);
+			return;
+		}
+
+		/*
+		 * While the number of cpus is gathered from dt, also get the
+		 * number of cores from the scu to verify this value when
+		 * booting the cores.
+		 */
+		ncores = scu_get_core_count(scu_base_addr);
+		pr_err("%s: ncores %d\n", __func__, ncores);
+
+		scu_enable(scu_base_addr);
+	} else {
+		unsigned int l2ctlr;
+
+		asm ("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
+		ncores = ((l2ctlr >> 24) & 0x3) + 1;
+	}
 
 	/* Make sure that all cores except the first are really off */
 	for (i = 1; i < ncores; i++)
-- 
1.9.1

