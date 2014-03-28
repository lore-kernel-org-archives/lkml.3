Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaC1LQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:16:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35401 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972AbaC1LO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:14:27 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/11] ARM: mvebu: Add the PMSU related part of the cpu idle functions
Date: Fri, 28 Mar 2014 12:13:28 +0100
Message-Id: <1396005211-15573-9-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
References: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu idle support will need to access to Power Management Service
Unit. This commit adds the architecture related functions that will be
used in the idle path of the cpuidle driver.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/pmsu.c | 132 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 131 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index db5011f98df3..968c8c02c126 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -24,9 +24,12 @@
 #include <linux/io.h>
 #include <linux/smp.h>
 #include <linux/resource.h>
+#include <asm/cacheflush.h>
+#include <asm/cp15.h>
 #include <asm/smp_plat.h>
+#include <asm/suspend.h>
+#include <asm/tlbflush.h>
 #include "common.h"
-#include "pmsu.h"
 
 static void __iomem *pmsu_mp_base;
 
@@ -34,12 +37,33 @@ static void __iomem *pmsu_mp_base;
 #define PMSU_REG_SIZE	    0x1000
 
 /* PMSU MP registers */
+#define PMSU_CONTROL_AND_CONFIG(cpu)	    ((cpu * 0x100) + 0x104)
+#define PMSU_CONTROL_AND_CONFIG_DFS_REQ		BIT(18)
+#define PMSU_CONTROL_AND_CONFIG_PWDDN_REQ	BIT(16)
+#define PMSU_CONTROL_AND_CONFIG_L2_PWDDN	BIT(20)
+
+#define PMSU_CPU_POWER_DOWN_CONTROL(cpu)    ((cpu * 0x100) + 0x108)
+
+#define PMSU_CPU_POWER_DOWN_DIS_SNP_Q_SKIP	BIT(0)
+
+#define PMSU_STATUS_AND_MASK(cpu)	    ((cpu * 0x100) + 0x10c)
+#define PMSU_STATUS_AND_MASK_CPU_IDLE_WAIT	BIT(16)
+#define PMSU_STATUS_AND_MASK_SNP_Q_EMPTY_WAIT	BIT(17)
+#define PMSU_STATUS_AND_MASK_IRQ_WAKEUP		BIT(20)
+#define PMSU_STATUS_AND_MASK_FIQ_WAKEUP		BIT(21)
+#define PMSU_STATUS_AND_MASK_DBG_WAKEUP		BIT(22)
+#define PMSU_STATUS_AND_MASK_IRQ_MASK		BIT(24)
+#define PMSU_STATUS_AND_MASK_FIQ_MASK		BIT(25)
+
 #define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu) ((cpu * 0x100) + 0x124)
 
 /* PMSU fabric registers */
 #define L2C_NFABRIC_PM_CTL		    0x4
 #define L2C_NFABRIC_PM_CTL_PWR_DOWN		BIT(20)
 
+extern void ll_disable_coherency(void);
+extern void ll_enable_coherency(void);
+
 static struct of_device_id of_pmsu_table[] = {
 	{ .compatible = "marvell,armada-370-pmsu", },
 	{ .compatible = "marvell,armada-370-xp-pmsu", },
@@ -133,4 +157,110 @@ static void armada_370_xp_pmsu_enable_l2_powerdown_onidle(void)
 	writel(reg, pmsu_mp_base + L2C_NFABRIC_PM_CTL);
 }
 
+static void armada_370_xp_cpu_resume(void)
+{
+	asm volatile("bl    ll_add_cpu_to_smp_group\n\t"
+		     "bl    ll_enable_coherency\n\t"
+		     "b	    cpu_resume\n\t");
+}
+
+/* No locking is needed because we only access per-CPU registers */
+void armada_370_xp_pmsu_idle_prepare(bool deepidle)
+{
+	unsigned int hw_cpu = cpu_logical_map(smp_processor_id());
+	u32 reg;
+
+	if (pmsu_mp_base == NULL)
+		return;
+
+	/*
+	 * Adjust the PMSU configuration to wait for WFI signal, enable
+	 * IRQ and FIQ as wakeup events, set wait for snoop queue empty
+	 * indication and mask IRQ and FIQ from CPU
+	 */
+	reg = readl(pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
+	reg |= PMSU_STATUS_AND_MASK_CPU_IDLE_WAIT    |
+	       PMSU_STATUS_AND_MASK_IRQ_WAKEUP       |
+	       PMSU_STATUS_AND_MASK_FIQ_WAKEUP       |
+	       PMSU_STATUS_AND_MASK_SNP_Q_EMPTY_WAIT |
+	       PMSU_STATUS_AND_MASK_IRQ_MASK         |
+	       PMSU_STATUS_AND_MASK_FIQ_MASK;
+	writel(reg, pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
+
+	reg = readl(pmsu_mp_base + PMSU_CONTROL_AND_CONFIG(hw_cpu));
+	/* ask HW to power down the L2 Cache if needed */
+	if (deepidle)
+		reg |= PMSU_CONTROL_AND_CONFIG_L2_PWDDN;
+
+	/* request power down */
+	reg |= PMSU_CONTROL_AND_CONFIG_PWDDN_REQ;
+	writel(reg, pmsu_mp_base + PMSU_CONTROL_AND_CONFIG(hw_cpu));
+
+	/* Disable snoop disable by HW - SW is taking care of it */
+	reg = readl(pmsu_mp_base + PMSU_CPU_POWER_DOWN_CONTROL(hw_cpu));
+	reg |= PMSU_CPU_POWER_DOWN_DIS_SNP_Q_SKIP;
+	writel(reg, pmsu_mp_base + PMSU_CPU_POWER_DOWN_CONTROL(hw_cpu));
+}
+
+static noinline int do_armada_370_xp_cpu_suspend(unsigned long deepidle)
+{
+	armada_370_xp_pmsu_idle_prepare(deepidle);
+
+	v7_exit_coherency_flush(all);
+
+	ll_disable_coherency();
+
+	dsb();
+
+	wfi();
+
+	/* If we are here, wfi failed. As processors run out of
+	 * coherency for some time, tlbs might be stale, so flush them
+	 */
+	local_flush_tlb_all();
+
+	ll_enable_coherency();
+
+	/* Test the CR_C bit and set it if it was cleared */
+	asm volatile(
+	"mrc	p15, 0, %0, c1, c0, 0 \n\t"
+	"tst	%0, #(1 << 2) \n\t"
+	"orreq	%0, %0, #(1 << 2) \n\t"
+	"mcreq	p15, 0, %0, c1, c0, 0 \n\t"
+	"isb	"
+	: : "r" (0));
+
+	pr_warn("Failed to suspend the system\n");
+
+	return 0;
+}
+
+static int armada_370_xp_cpu_suspend(unsigned long deepidle)
+{
+	return cpu_suspend(deepidle, do_armada_370_xp_cpu_suspend);
+}
+
+/* No locking is needed because we only access per-CPU registers */
+static noinline void armada_370_xp_pmsu_idle_restore(void)
+{
+	unsigned int hw_cpu = cpu_logical_map(smp_processor_id());
+	u32 reg;
+
+	if (pmsu_mp_base == NULL)
+		return;
+
+	/* cancel ask HW to power down the L2 Cache if possible */
+	reg = readl(pmsu_mp_base + PMSU_CONTROL_AND_CONFIG(hw_cpu));
+	reg &= ~PMSU_CONTROL_AND_CONFIG_L2_PWDDN;
+	writel(reg, pmsu_mp_base + PMSU_CONTROL_AND_CONFIG(hw_cpu));
+
+	/* cancel Enable wakeup events and mask interrupts */
+	reg = readl(pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
+	reg &= ~(PMSU_STATUS_AND_MASK_IRQ_WAKEUP | PMSU_STATUS_AND_MASK_FIQ_WAKEUP);
+	reg &= ~PMSU_STATUS_AND_MASK_CPU_IDLE_WAIT;
+	reg &= ~PMSU_STATUS_AND_MASK_SNP_Q_EMPTY_WAIT;
+	reg &= ~(PMSU_STATUS_AND_MASK_IRQ_MASK | PMSU_STATUS_AND_MASK_FIQ_MASK);
+	writel(reg, pmsu_mp_base + PMSU_STATUS_AND_MASK(hw_cpu));
+}
+
 early_initcall(armada_370_xp_pmsu_init);
-- 
1.8.1.2

