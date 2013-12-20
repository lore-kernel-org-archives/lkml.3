Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3LTKqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:46:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:60163 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3LTKqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:46:02 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        =?UTF-8?q?Sami=20Pietik=C3=A4inen?= <Sami.Pietikainen@wapice.com>,
        tglx@linutronix.de, Benedikt Spranger <b.spranger@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] clocksource: TCLIB: Allow higher clock rates for clock events
Date: Fri, 20 Dec 2013 11:45:41 +0100
Message-Id: <1387536341-7452-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387536341-7452-1-git-send-email-bigeasy@linutronix.de>
References: <1387536341-7452-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benedikt Spranger <b.spranger@linutronix.de>

As default the TCLIB uses the 32KiHz base clock rate for clock events.
Add a compile time selection to allow higher clock resulution.

(fixed up by Sami Pietikäinen <Sami.Pietikainen@wapice.com> around v3.12)

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: update against v3.13-rc4]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/clocksource/tcb_clksrc.c | 37 ++++++++++++++++++++++---------------
 drivers/misc/Kconfig             | 12 ++++++++++--
 2 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 00fdd11..df62eaa 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -23,8 +23,7 @@
  *     this 32 bit free-running counter. the second channel is not used.
  *
  *   - The third channel may be used to provide a 16-bit clockevent
- *     source, used in either periodic or oneshot mode.  This runs
- *     at 32 KiHZ, and can handle delays of up to two seconds.
+ *     source, used in either periodic or oneshot mode.
  *
  * A boot clocksource and clockevent source are also currently needed,
  * unless the relevant platforms (ARM/AT91, AVR32/AT32) are changed so
@@ -74,6 +73,7 @@ static struct clocksource clksrc = {
 struct tc_clkevt_device {
 	struct clock_event_device	clkevt;
 	struct clk			*clk;
+	u32				freq;
 	void __iomem			*regs;
 };
 
@@ -82,13 +82,6 @@ static struct tc_clkevt_device *to_tc_clkevt(struct clock_event_device *clkevt)
 	return container_of(clkevt, struct tc_clkevt_device, clkevt);
 }
 
-/* For now, we always use the 32K clock ... this optimizes for NO_HZ,
- * because using one of the divided clocks would usually mean the
- * tick rate can never be less than several dozen Hz (vs 0.5 Hz).
- *
- * A divided clock could be good for high resolution timers, since
- * 30.5 usec resolution can seem "low".
- */
 static u32 timer_clock;
 
 static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
@@ -111,11 +104,12 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 	case CLOCK_EVT_MODE_PERIODIC:
 		clk_prepare_enable(tcd->clk);
 
-		/* slow clock, count up to RC, then irq and restart */
+		/* count up to RC, then irq and restart */
 		__raw_writel(timer_clock
 				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
 				regs + ATMEL_TC_REG(2, CMR));
-		__raw_writel((32768 + HZ/2) / HZ, tcaddr + ATMEL_TC_REG(2, RC));
+		__raw_writel((tcd->freq + HZ / 2) / HZ,
+				tcaddr + ATMEL_TC_REG(2, RC));
 
 		/* Enable clock and interrupts on RC compare */
 		__raw_writel(ATMEL_TC_CPCS, regs + ATMEL_TC_REG(2, IER));
@@ -128,7 +122,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 	case CLOCK_EVT_MODE_ONESHOT:
 		clk_prepare_enable(tcd->clk);
 
-		/* slow clock, count up to RC, then irq and stop */
+		/* count up to RC, then irq and stop */
 		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
 				| ATMEL_TC_WAVE | ATMEL_TC_WAVESEL_UP_AUTO,
 				regs + ATMEL_TC_REG(2, CMR));
@@ -157,8 +151,12 @@ static struct tc_clkevt_device clkevt = {
 		.name		= "tc_clkevt",
 		.features	= CLOCK_EVT_FEAT_PERIODIC
 					| CLOCK_EVT_FEAT_ONESHOT,
+#ifdef CONFIG_ATMEL_TCB_CLKSRC_USE_SLOW_CLOCK
 		/* Should be lower than at91rm9200's system timer */
 		.rating		= 125,
+#else
+		.rating		= 200,
+#endif
 		.set_next_event	= tc_next_event,
 		.set_mode	= tc_mode,
 	},
@@ -184,8 +182,9 @@ static struct irqaction tc_irqaction = {
 	.handler	= ch2_irq,
 };
 
-static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
+static int __init setup_clkevents(struct atmel_tc *tc, int divisor_idx)
 {
+	unsigned divisor = atmel_tc_divisors[divisor_idx];
 	int ret;
 	struct clk *t2_clk = tc->clk[2];
 	int irq = tc->irq[2];
@@ -200,7 +199,11 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 	clkevt.clk = t2_clk;
 	tc_irqaction.dev_id = &clkevt;
 
-	timer_clock = clk32k_divisor_idx;
+	timer_clock = divisor_idx;
+	if (!divisor)
+		clkevt.freq = 32768;
+	else
+		clkevt.freq = clk_get_rate(t2_clk) / divisor;
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
@@ -208,7 +211,7 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 	if (ret)
 		return ret;
 
-	clockevents_config_and_register(&clkevt.clkevt, 32768, 1, 0xffff);
+	clockevents_config_and_register(&clkevt.clkevt, clkevt.freq, 1, 0xffff);
 
 	return ret;
 }
@@ -345,7 +348,11 @@ static int __init tcb_clksrc_init(void)
 		goto err_disable_t1;
 
 	/* channel 2:  periodic and oneshot timer support */
+#ifdef CONFIG_ATMEL_TCB_CLKSRC_USE_SLOW_CLOCK
 	ret = setup_clkevents(tc, clk32k_divisor_idx);
+#else
+	ret = setup_clkevents(tc, best_divisor_idx);
+#endif
 	if (ret)
 		goto err_unregister_clksrc;
 
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a3e291d..4a7d7d6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -78,8 +78,7 @@ config ATMEL_TCB_CLKSRC
 	  are combined to make a single 32-bit timer.
 
 	  When GENERIC_CLOCKEVENTS is defined, the third timer channel
-	  may be used as a clock event device supporting oneshot mode
-	  (delays of up to two seconds) based on the 32 KiHz clock.
+	  may be used as a clock event device supporting oneshot mode.
 
 config ATMEL_TCB_CLKSRC_BLOCK
 	int
@@ -93,6 +92,15 @@ config ATMEL_TCB_CLKSRC_BLOCK
 	  TC can be used for other purposes, such as PWM generation and
 	  interval timing.
 
+config ATMEL_TCB_CLKSRC_USE_SLOW_CLOCK
+	bool "TC Block use 32 KiHz clock"
+	depends on ATMEL_TCB_CLKSRC
+	default y
+	help
+	  Select this to use 32 KiHz base clock rate as TC block clock
+	  source for clock events.
+
+
 config DUMMY_IRQ
 	tristate "Dummy IRQ handler"
 	default n
-- 
1.8.5.1

