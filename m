Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3JVTJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:09:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44533 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab3JVTJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:09:16 -0400
Message-ID: <5266CCE3.1090801@ti.com>
Date: Tue, 22 Oct 2013 22:07:15 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Kevin Hilman <khilman@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] ARM: OMAP4460: cpuidle: Extend PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD
 on cpuidle
References: <1382467484-16957-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1382467484-16957-1-git-send-email-grygorii.strashko@ti.com>
X-Forwarded-Message-Id: <1382467484-16957-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.172]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same workaround as ff999b8a0983ee15668394ed49e38d3568fc6859
"ARM: OMAP4460: Workaround for ROM bug because of CA9 r2pX GIC ..."
need to be applied not only when system is booting, but when MPUSS hits
OSWR state through CPUIdle too. Without this WA the same issue is
reproduced now on boards PandaES and Tablet/Blaze with SOM OMAP4460
when CONFIG_CPU_IDLE is enabled.
After MPUSS has enterred OSWR and waken up:
- GIC distributor became disabled forever
- scheduling is not performed any more

Cc: Kevin Hilman <khilman@linaro.org>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reported-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Changes in V2:
- get rid of using omap4_mpuss_read_prev_context_state();
- move call of gic_dist_enable() in omap-mpuss-lowpower.c
- add call of gic_timer_retrigger()

Based on: v3.12-rc5

 arch/arm/mach-omap2/common.h              |    1 +
 arch/arm/mach-omap2/cpuidle44xx.c         |   26 +++++++++++++++++++++-----
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |    3 +++
 arch/arm/mach-omap2/omap4-common.c        |    6 ++++++
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 4a5684b..c9b4bc3 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -232,6 +232,7 @@ static inline void __iomem *omap4_get_scu_base(void)
 
 extern void __init gic_init_irq(void);
 extern void gic_dist_disable(void);
+extern void gic_dist_enable(void);
 extern bool gic_dist_disabled(void);
 extern void gic_timer_retrigger(void);
 extern void omap_smc1(u32 fn, u32 arg);
diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index 4c8982a..4c158c8 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -80,6 +80,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 			int index)
 {
 	struct idle_statedata *cx = state_ptr + index;
+	u32 mpuss_can_lose_context = 0;
 
 	/*
 	 * CPU0 has to wait and stay ON until CPU1 is OFF state.
@@ -104,6 +105,9 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		}
 	}
 
+	mpuss_can_lose_context = (cx->mpu_state == PWRDM_POWER_RET) &&
+				 (cx->mpu_logic_state == PWRDM_POWER_OFF);
+
 	/*
 	 * Call idle CPU PM enter notifier chain so that
 	 * VFP and per CPU interrupt context is saved.
@@ -118,9 +122,8 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 		 * Call idle CPU cluster PM enter notifier chain
 		 * to save GIC and wakeupgen context.
 		 */
-		if ((cx->mpu_state == PWRDM_POWER_RET) &&
-			(cx->mpu_logic_state == PWRDM_POWER_OFF))
-				cpu_cluster_pm_enter();
+		if (mpuss_can_lose_context)
+			cpu_cluster_pm_enter();
 	}
 
 	omap4_enter_lowpower(dev->cpu, cx->cpu_state);
@@ -128,9 +131,23 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 
 	/* Wakeup CPU1 only if it is not offlined */
 	if (dev->cpu == 0 && cpumask_test_cpu(1, cpu_online_mask)) {
+
+		if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
+		    mpuss_can_lose_context)
+			gic_dist_disable();
+
 		clkdm_wakeup(cpu_clkdm[1]);
 		omap_set_pwrdm_state(cpu_pd[1], PWRDM_POWER_ON);
 		clkdm_allow_idle(cpu_clkdm[1]);
+
+		if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) &&
+		    mpuss_can_lose_context) {
+			while (gic_dist_disabled()) {
+				udelay(1);
+				cpu_relax();
+			}
+			gic_timer_retrigger();
+		}
 	}
 
 	/*
@@ -143,8 +160,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	 * Call idle CPU cluster PM exit notifier chain
 	 * to restore GIC and wakeupgen context.
 	 */
-	if (dev->cpu == 0 && (cx->mpu_state == PWRDM_POWER_RET) &&
-		(cx->mpu_logic_state == PWRDM_POWER_OFF))
+	if (dev->cpu == 0 && mpuss_can_lose_context)
 		cpu_cluster_pm_exit();
 
 fail:
diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index f991016..667915d 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -271,6 +271,9 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
 	else
 		omap_pm_ops.finish_suspend(save_state);
 
+	if (IS_PM44XX_ERRATUM(PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD) && cpu)
+		gic_dist_enable();
+
 	/*
 	 * Restore the CPUx power state to ON otherwise CPUx
 	 * power domain can transitions to programmed low power
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 5791143..3ad4a8c 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -128,6 +128,12 @@ void gic_dist_disable(void)
 		__raw_writel(0x0, gic_dist_base_addr + GIC_DIST_CTRL);
 }
 
+void gic_dist_enable(void)
+{
+	if (gic_dist_base_addr)
+		__raw_writel(0x1, gic_dist_base_addr + GIC_DIST_CTRL);
+}
+
 bool gic_dist_disabled(void)
 {
 	return !(__raw_readl(gic_dist_base_addr + GIC_DIST_CTRL) & 0x1);
-- 
1.7.9.5



