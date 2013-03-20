Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3CTWew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:34:52 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41883 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3CTWeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:34:50 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Lindgren <tony@atomide.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
Date: Wed, 20 Mar 2013 17:34:35 -0500
Message-Id: <1363818875-15978-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This converts arm and arm64 to use CLKSRC_OF DT based initialization for
the arch timer. A new function arch_timer_arch_init is added to allow for
arch specific setup.

This has a side effect of enabling sched_clock on omap5 and exynos5. There
should not be any reason not to use the arch timers for sched_clock.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-sh@vger.kernel.org
---
This is dependent on my CLKSRC_OF clean-up in arm-soc, my 64-bit sched_clock
support series, and Arnd's default machine descriptor patch (for default
clocksource_of_init call). This is only compile tested on arm.

The full series (including sp804 work) is available here:
git://sources.calxeda.com/kernel/linux.git arm-timers

Rob

 arch/arm/include/asm/arch_timer.h            |   13 +------------
 arch/arm/kernel/arch_timer.c                 |   17 +++--------------
 arch/arm/mach-exynos/mach-exynos5-dt.c       |    1 -
 arch/arm/mach-exynos/mct.c                   |    6 ------
 arch/arm/mach-highbank/highbank.c            |    5 +----
 arch/arm/mach-omap2/timer.c                  |    5 +----
 arch/arm/mach-shmobile/board-kzm9d.c         |    1 -
 arch/arm/mach-shmobile/include/mach/common.h |    1 -
 arch/arm/mach-shmobile/setup-emev2.c         |    1 -
 arch/arm/mach-shmobile/setup-r8a7740.c       |    1 -
 arch/arm/mach-shmobile/setup-sh7372.c        |    1 -
 arch/arm/mach-shmobile/setup-sh73a0.c        |    1 -
 arch/arm/mach-shmobile/timer.c               |    6 ------
 arch/arm/mach-vexpress/v2m.c                 |    7 ++-----
 arch/arm/mach-virt/virt.c                    |    9 ---------
 arch/arm64/include/asm/arch_timer.h          |    5 +++++
 arch/arm64/kernel/time.c                     |    6 ++++--
 drivers/clocksource/Kconfig                  |    1 +
 drivers/clocksource/arm_arch_timer.c         |   22 ++++++----------------
 include/clocksource/arm_arch_timer.h         |    6 ------
 20 files changed, 24 insertions(+), 91 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 7ade91d..7c1bfc0 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -10,8 +10,7 @@
 #include <clocksource/arm_arch_timer.h>
 
 #ifdef CONFIG_ARM_ARCH_TIMER
-int arch_timer_of_register(void);
-int arch_timer_sched_clock_init(void);
+int arch_timer_arch_init(void);
 
 /*
  * These register accessors are marked inline so the compiler can
@@ -110,16 +109,6 @@ static inline void __cpuinit arch_counter_set_user_access(void)
 
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
-#else
-static inline int arch_timer_of_register(void)
-{
-	return -ENXIO;
-}
-
-static inline int arch_timer_sched_clock_init(void)
-{
-	return -ENXIO;
-}
 #endif
 
 #endif
diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index d813ae6..d0b59bc 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -32,24 +32,13 @@ static void __init arch_timer_delay_timer_register(void)
 	register_current_timer_delay(&arch_delay_timer);
 }
 
-int __init arch_timer_of_register(void)
-{
-	int ret;
-
-	ret = arch_timer_init();
-	if (ret)
-		return ret;
-
-	arch_timer_delay_timer_register();
-
-	return 0;
-}
-
-int __init arch_timer_sched_clock_init(void)
+int __init arch_timer_arch_init(void)
 {
 	if (arch_timer_get_rate() == 0)
 		return -ENXIO;
 
+	arch_timer_delay_timer_register();
+
 	setup_sched_clock_64(arch_timer_read_counter, arch_timer_get_rate());
 	return 0;
 }
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index acaeb14..4d97b43 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -216,7 +216,6 @@ DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	.map_io		= exynos5_dt_map_io,
 	.init_machine	= exynos5_dt_machine_init,
 	.init_late	= exynos_init_late,
-	.init_time	= exynos4_timer_init,
 	.dt_compat	= exynos5_dt_compat,
 	.restart        = exynos5_restart,
 	.reserve	= exynos5_reserve,
diff --git a/arch/arm/mach-exynos/mct.c b/arch/arm/mach-exynos/mct.c
index c9d6650..04aff6a 100644
--- a/arch/arm/mach-exynos/mct.c
+++ b/arch/arm/mach-exynos/mct.c
@@ -21,7 +21,6 @@
 #include <linux/percpu.h>
 #include <linux/of.h>
 
-#include <asm/arch_timer.h>
 #include <asm/localtimer.h>
 
 #include <plat/cpu.h>
@@ -469,11 +468,6 @@ static void __init exynos4_timer_resources(void)
 
 void __init exynos4_timer_init(void)
 {
-	if (soc_is_exynos5440()) {
-		arch_timer_of_register();
-		return;
-	}
-
 	if ((soc_is_exynos4210()) || (soc_is_exynos5250()))
 		mct_int_type = MCT_INT_SPI;
 	else
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 76c1170..758150e 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -15,6 +15,7 @@
  */
 #include <linux/clk.h>
 #include <linux/clkdev.h>
+#include <linux/clocksource.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/irq.h>
@@ -28,7 +29,6 @@
 #include <linux/amba/bus.h>
 #include <linux/clk-provider.h>
 
-#include <asm/arch_timer.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/smp_plat.h>
@@ -118,9 +118,6 @@ static void __init highbank_timer_init(void)
 	sp804_clocksource_and_sched_clock_init(timer_base + 0x20, "timer1");
 	sp804_clockevents_init(timer_base, irq, "timer0");
 
-	arch_timer_of_register();
-	arch_timer_sched_clock_init();
-
 	clocksource_of_init();
 }
 
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 4fd8025..7dd6453 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -46,7 +46,6 @@
 #include <asm/smp_twd.h>
 #include <asm/sched_clock.h>
 
-#include <asm/arch_timer.h>
 #include "omap_hwmod.h"
 #include "omap_device.h"
 #include <plat/counter-32k.h>
@@ -624,9 +623,7 @@ void __init omap5_realtime_timer_init(void)
 	omap5_sync32k_timer_init();
 	realtime_counter_init();
 
-	err = arch_timer_of_register();
-	if (err)
-		pr_err("%s: arch_timer_register failed %d\n", __func__, err);
+        clocksource_of_init();
 }
 #endif /* CONFIG_SOC_OMAP5 */
 
diff --git a/arch/arm/mach-shmobile/board-kzm9d.c b/arch/arm/mach-shmobile/board-kzm9d.c
index c254782..c016ccd 100644
--- a/arch/arm/mach-shmobile/board-kzm9d.c
+++ b/arch/arm/mach-shmobile/board-kzm9d.c
@@ -90,6 +90,5 @@ DT_MACHINE_START(KZM9D_DT, "kzm9d")
 	.init_irq	= emev2_init_irq,
 	.init_machine	= kzm9d_add_standard_devices,
 	.init_late	= shmobile_init_late,
-	.init_time	= shmobile_timer_init,
 	.dt_compat	= kzm9d_boards_compat_dt,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/include/mach/common.h b/arch/arm/mach-shmobile/include/mach/common.h
index e48606d..5efc0f0 100644
--- a/arch/arm/mach-shmobile/include/mach/common.h
+++ b/arch/arm/mach-shmobile/include/mach/common.h
@@ -2,7 +2,6 @@
 #define __ARCH_MACH_COMMON_H
 
 extern void shmobile_earlytimer_init(void);
-extern void shmobile_timer_init(void);
 extern void shmobile_setup_delay(unsigned int max_cpu_core_mhz,
 			 unsigned int mult, unsigned int div);
 struct twd_local_timer;
diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
index 47662a5..4e38a66 100644
--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -456,7 +456,6 @@ DT_MACHINE_START(EMEV2_DT, "Generic Emma Mobile EV2 (Flattened Device Tree)")
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= irqchip_init,
 	.init_machine	= emev2_add_standard_devices_dt,
-	.init_time	= shmobile_timer_init,
 	.dt_compat	= emev2_boards_compat_dt,
 MACHINE_END
 
diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 8b85d4d..104b474 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -906,7 +906,6 @@ DT_MACHINE_START(R8A7740_DT, "Generic R8A7740 (Flattened Device Tree)")
 	.init_irq	= r8a7740_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= r8a7740_add_standard_devices_dt,
-	.init_time	= shmobile_timer_init,
 	.dt_compat	= r8a7740_boards_compat_dt,
 MACHINE_END
 
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 59c7146..5502d62 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1175,7 +1175,6 @@ DT_MACHINE_START(SH7372_DT, "Generic SH7372 (Flattened Device Tree)")
 	.init_irq	= sh7372_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= sh7372_add_standard_devices_dt,
-	.init_time	= shmobile_timer_init,
 	.dt_compat	= sh7372_boards_compat_dt,
 MACHINE_END
 
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index bdab575..ea66316 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -923,7 +923,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= sh73a0_init_irq_dt,
 	.init_machine	= sh73a0_add_standard_devices_dt,
-	.init_time	= shmobile_timer_init,
 	.dt_compat	= sh73a0_boards_compat_dt,
 MACHINE_END
 #endif /* CONFIG_USE_OF */
diff --git a/arch/arm/mach-shmobile/timer.c b/arch/arm/mach-shmobile/timer.c
index 3d16d4d..add2f15 100644
--- a/arch/arm/mach-shmobile/timer.c
+++ b/arch/arm/mach-shmobile/timer.c
@@ -60,9 +60,3 @@ void __init shmobile_earlytimer_init(void)
 {
 	late_time_init = shmobile_late_time_init;
 }
-
-void __init shmobile_timer_init(void)
-{
-	arch_timer_of_register();
-	arch_timer_sched_clock_init();
-}
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index d0ad789..6215717 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -1,6 +1,7 @@
 /*
  * Versatile Express V2M Motherboard Support
  */
+#include <linux/clocksource.h>
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
@@ -23,7 +24,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/vexpress.h>
 
-#include <asm/arch_timer.h>
 #include <asm/mach-types.h>
 #include <asm/sizes.h>
 #include <asm/mach/arch.h>
@@ -446,10 +446,7 @@ static void __init v2m_dt_timer_init(void)
 				irq_of_parse_and_map(node, 0));
 	}
 
-	arch_timer_of_register();
-
-	if (arch_timer_sched_clock_init() != 0)
-		versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
+	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
 				24000000);
 }
 
diff --git a/arch/arm/mach-virt/virt.c b/arch/arm/mach-virt/virt.c
index 31666f6..adc0945 100644
--- a/arch/arm/mach-virt/virt.c
+++ b/arch/arm/mach-virt/virt.c
@@ -23,21 +23,13 @@
 #include <linux/of_platform.h>
 #include <linux/smp.h>
 
-#include <asm/arch_timer.h>
 #include <asm/mach/arch.h>
-#include <asm/mach/time.h>
 
 static void __init virt_init(void)
 {
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-static void __init virt_timer_init(void)
-{
-	WARN_ON(arch_timer_of_register() != 0);
-	WARN_ON(arch_timer_sched_clock_init() != 0);
-}
-
 static const char *virt_dt_match[] = {
 	"linux,dummy-virt",
 	NULL
@@ -47,7 +39,6 @@ extern struct smp_operations virt_smp_ops;
 
 DT_MACHINE_START(VIRT, "Dummy Virtual Machine")
 	.init_irq	= irqchip_init,
-	.init_time	= virt_timer_init,
 	.init_machine	= virt_init,
 	.smp		= smp_ops(virt_smp_ops),
 	.dt_compat	= virt_dt_match,
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 91e2a6a..bf6ab242 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -130,4 +130,9 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
+static inline int arch_timer_arch_init(void)
+{
+	return 0;
+}
+
 #endif
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index b0ef18d..a551f88 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -32,6 +32,7 @@
 #include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
+#include <linux/clocksource.h>
 
 #include <clocksource/arm_arch_timer.h>
 
@@ -77,10 +78,11 @@ void __init time_init(void)
 {
 	u32 arch_timer_rate;
 
-	if (arch_timer_init())
-		panic("Unable to initialise architected timer.\n");
+	clocksource_of_init();
 
 	arch_timer_rate = arch_timer_get_rate();
+	if (!arch_timer_rate)
+		panic("Unable to initialise architected timer.\n");
 
 	/* Cache the sched_clock multiplier to save a divide in the hot path. */
 	sched_clock_mult = NSEC_PER_SEC / arch_timer_rate;
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index e507ab7..d98e7e1 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -62,6 +62,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
 
 config ARM_ARCH_TIMER
 	bool
+	select CLKSRC_OF if OF
 
 config CLKSRC_METAG_GENERIC
 	def_bool y if METAG
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d7ad425..afb70aa 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -337,24 +337,11 @@ out:
 	return err;
 }
 
-static const struct of_device_id arch_timer_of_match[] __initconst = {
-	{ .compatible	= "arm,armv7-timer",	},
-	{ .compatible	= "arm,armv8-timer",	},
-	{},
-};
-
-int __init arch_timer_init(void)
+static void __init arch_timer_init(struct device_node *np)
 {
-	struct device_node *np;
 	u32 freq;
 	int i;
 
-	np = of_find_matching_node(NULL, arch_timer_of_match);
-	if (!np) {
-		pr_err("arch_timer: can't find DT node\n");
-		return -ENODEV;
-	}
-
 	/* Try to determine the frequency from the device tree or CNTFRQ */
 	if (!of_property_read_u32(np, "clock-frequency", &freq))
 		arch_timer_rate = freq;
@@ -378,7 +365,7 @@ int __init arch_timer_init(void)
 		if (!arch_timer_ppi[PHYS_SECURE_PPI] ||
 		    !arch_timer_ppi[PHYS_NONSECURE_PPI]) {
 			pr_warn("arch_timer: No interrupt available, giving up\n");
-			return -EINVAL;
+			return;
 		}
 	}
 
@@ -387,5 +374,8 @@ int __init arch_timer_init(void)
 	else
 		arch_timer_read_counter = arch_counter_get_cntpct;
 
-	return arch_timer_register();
+	arch_timer_register();
+	arch_timer_arch_init();
 }
+CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
+CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 2603267..e6c9c4c 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -31,18 +31,12 @@
 
 #ifdef CONFIG_ARM_ARCH_TIMER
 
-extern int arch_timer_init(void);
 extern u32 arch_timer_get_rate(void);
 extern u64 (*arch_timer_read_counter)(void);
 extern struct timecounter *arch_timer_get_timecounter(void);
 
 #else
 
-static inline int arch_timer_init(void)
-{
-	return -ENXIO;
-}
-
 static inline u32 arch_timer_get_rate(void)
 {
 	return 0;
-- 
1.7.10.4

