Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3LQNw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:52:29 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47249 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3LQNwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:52:25 -0500
Date: Tue, 17 Dec 2013 14:52:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20131217135221.GA29636@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   # HEAD: 5d5119a476f77b57381ddd66d4f7034a5447480b Merge branch 'clockevents/fixes' of git://git.linaro.org/people/daniel.lezcano/linux into timers/urgent

Five self-contained fixlets:

 - fix clocksource driver build bug
 - fix two sched_clock() bugs triggering on specific hardware
 - fix devicetree enumeration bug affecting specific hardware
 - fix irq handler registration race resulting in boot crash
 - fix device node refcount bug

 Thanks,

	Ingo

------------------>
Axel Lin (1):
      clocksource: time-efm32: Select CLKSRC_MMIO

Dinh Nguyen (2):
      clocksource: dw_apb_timer_of: Fix read_sched_clock
      clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"

Ezequiel Garcia (1):
      clocksource: armada-370-xp: Register sched_clock after the counter reset

Marc Zyngier (1):
      clocksource: sunxi: Stop timer from ticking before enabling interrupts

Thierry Reding (1):
      clocksource: clksrc-of: Do not drop unheld reference on device node


 drivers/clocksource/Kconfig              |  1 +
 drivers/clocksource/clksrc-of.c          |  1 -
 drivers/clocksource/dw_apb_timer_of.c    |  7 ++++---
 drivers/clocksource/sun4i_timer.c        |  3 +++
 drivers/clocksource/time-armada-370-xp.c | 10 +++++-----
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 5c07a56..634c4d6 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -75,6 +75,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
 config CLKSRC_EFM32
 	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
 	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
+	select CLKSRC_MMIO
 	default ARCH_EFM32
 	help
 	  Support to use the timers of EFM32 SoCs as clock source and clock
diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 35639cf4..b9ddd9e 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -35,6 +35,5 @@ void __init clocksource_of_init(void)
 
 		init_func = match->data;
 		init_func(np);
-		of_node_put(np);
 	}
 }
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 45ba8ae..2a2ea27 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -108,12 +108,11 @@ static void __init add_clocksource(struct device_node *source_timer)
 
 static u64 read_sched_clock(void)
 {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base);
 }
 
 static const struct of_device_id sptimer_ids[] __initconst = {
 	{ .compatible = "picochip,pc3x2-rtc" },
-	{ .compatible = "snps,dw-apb-timer-sp" },
 	{ /* Sentinel */ },
 };
 
@@ -151,4 +150,6 @@ static void __init dw_apb_timer_init(struct device_node *timer)
 	num_called++;
 }
 CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
-CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_osc, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_sp, "snps,dw-apb-timer-sp", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer", dw_apb_timer_init);
diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 2fb4695..a4f6119 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -179,6 +179,9 @@ static void __init sun4i_timer_init(struct device_node *node)
 	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
 	       timer_base + TIMER_CTL_REG(0));
 
+	/* Make sure timer is stopped before playing with interrupts */
+	sun4i_clkevt_time_stop(0);
+
 	ret = setup_irq(irq, &sun4i_timer_irq);
 	if (ret)
 		pr_warn("failed to setup irq %d\n", irq);
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index d8e47e5..4e7f680 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -256,11 +256,6 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	ticks_per_jiffy = (timer_clk + HZ / 2) / HZ;
 
 	/*
-	 * Set scale and timer for sched_clock.
-	 */
-	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
-
-	/*
 	 * Setup free-running clocksource timer (interrupts
 	 * disabled).
 	 */
@@ -270,6 +265,11 @@ static void __init armada_370_xp_timer_common_init(struct device_node *np)
 	timer_ctrl_clrset(0, TIMER0_EN | TIMER0_RELOAD_EN |
 			     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
 
+	/*
+	 * Set scale and timer for sched_clock.
+	 */
+	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
+
 	clocksource_mmio_init(timer_base + TIMER0_VAL_OFF,
 			      "armada_370_xp_clocksource",
 			      timer_clk, 300, 32, clocksource_mmio_readl_down);
