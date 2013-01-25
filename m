Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3AYRdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:33:14 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:49191 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3AYRdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:33:06 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH v2 2/5] clocksource: time-armada-370-xp: add local timer support
Date: Fri, 25 Jan 2013 18:32:42 +0100
Message-Id: <1359135165-32108-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
References: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the SOCs Armada 370 and Armada XP, each CPU comes with two private
timers. This patch use the timer 0 of each CPU as local timer for the
clockevent if CONFIG_LOCAL_TIMER is selected. In the other case, use
only the private Timer 0 of CPU 0.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/clocksource/time-armada-370-xp.c |  150 ++++++++++++++++++++++--------
 1 file changed, 112 insertions(+), 38 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index a4605fd..47a6730 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -27,8 +27,10 @@
 #include <linux/of_address.h>
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <asm/sched_clock.h>
 
+#include <asm/sched_clock.h>
+#include <asm/localtimer.h>
+#include <linux/percpu.h>
 /*
  * Timer block registers.
  */
@@ -49,6 +51,7 @@
 #define TIMER1_RELOAD_OFF	0x0018
 #define TIMER1_VAL_OFF		0x001c
 
+#define LCL_TIMER_EVENTS_STATUS	0x0028
 /* Global timers are connected to the coherency fabric clock, and the
    below divider reduces their incrementing frequency. */
 #define TIMER_DIVIDER_SHIFT     5
@@ -57,14 +60,17 @@
 /*
  * SoC-specific data.
  */
-static void __iomem *timer_base;
-static int timer_irq;
+static void __iomem *timer_base, *local_base;
+static unsigned int timer_clk;
+static bool timer25Mhz = true;
 
 /*
  * Number of timer ticks per jiffy.
  */
 static u32 ticks_per_jiffy;
 
+static struct clock_event_device __percpu **percpu_armada_370_xp_evt;
+
 static u32 notrace armada_370_xp_read_sched_clock(void)
 {
 	return ~readl(timer_base + TIMER0_VAL_OFF);
@@ -78,24 +84,23 @@ armada_370_xp_clkevt_next_event(unsigned long delta,
 				struct clock_event_device *dev)
 {
 	u32 u;
-
 	/*
 	 * Clear clockevent timer interrupt.
 	 */
-	writel(TIMER1_CLR_MASK, timer_base + TIMER_EVENTS_STATUS);
+	writel(TIMER0_CLR_MASK, local_base + LCL_TIMER_EVENTS_STATUS);
 
 	/*
 	 * Setup new clockevent timer value.
 	 */
-	writel(delta, timer_base + TIMER1_VAL_OFF);
+	writel(delta, local_base + TIMER0_VAL_OFF);
 
 	/*
 	 * Enable the timer.
 	 */
-	u = readl(timer_base + TIMER_CTRL_OFF);
-	u = ((u & ~TIMER1_RELOAD_EN) | TIMER1_EN |
-	     TIMER1_DIV(TIMER_DIVIDER_SHIFT));
-	writel(u, timer_base + TIMER_CTRL_OFF);
+	u = readl(local_base + TIMER_CTRL_OFF);
+	u = ((u & ~TIMER0_RELOAD_EN) | TIMER0_EN |
+	     TIMER0_DIV(TIMER_DIVIDER_SHIFT));
+	writel(u, local_base + TIMER_CTRL_OFF);
 
 	return 0;
 }
@@ -107,37 +112,38 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 	u32 u;
 
 	if (mode == CLOCK_EVT_MODE_PERIODIC) {
+
 		/*
 		 * Setup timer to fire at 1/HZ intervals.
 		 */
-		writel(ticks_per_jiffy - 1, timer_base + TIMER1_RELOAD_OFF);
-		writel(ticks_per_jiffy - 1, timer_base + TIMER1_VAL_OFF);
+		writel(ticks_per_jiffy - 1, local_base + TIMER0_RELOAD_OFF);
+		writel(ticks_per_jiffy - 1, local_base + TIMER0_VAL_OFF);
 
 		/*
 		 * Enable timer.
 		 */
-		u = readl(timer_base + TIMER_CTRL_OFF);
 
-		writel((u | TIMER1_EN | TIMER1_RELOAD_EN |
-			TIMER1_DIV(TIMER_DIVIDER_SHIFT)),
-		       timer_base + TIMER_CTRL_OFF);
+		u = readl(local_base + TIMER_CTRL_OFF);
+
+		writel((u | TIMER0_EN | TIMER0_RELOAD_EN |
+			TIMER0_DIV(TIMER_DIVIDER_SHIFT)),
+			local_base + TIMER_CTRL_OFF);
 	} else {
 		/*
 		 * Disable timer.
 		 */
-		u = readl(timer_base + TIMER_CTRL_OFF);
-		writel(u & ~TIMER1_EN, timer_base + TIMER_CTRL_OFF);
+		u = readl(local_base + TIMER_CTRL_OFF);
+		writel(u & ~TIMER0_EN, local_base + TIMER_CTRL_OFF);
 
 		/*
 		 * ACK pending timer interrupt.
 		 */
-		writel(TIMER1_CLR_MASK, timer_base + TIMER_EVENTS_STATUS);
-
+		writel(TIMER0_CLR_MASK, local_base + LCL_TIMER_EVENTS_STATUS);
 	}
 }
 
 static struct clock_event_device armada_370_xp_clkevt = {
-	.name		= "armada_370_xp_tick",
+	.name		= "armada_370_xp_per_cpu_tick",
 	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
 	.shift		= 32,
 	.rating		= 300,
@@ -150,32 +156,78 @@ static irqreturn_t armada_370_xp_timer_interrupt(int irq, void *dev_id)
 	/*
 	 * ACK timer interrupt and call event handler.
 	 */
+	struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
 
-	writel(TIMER1_CLR_MASK, timer_base + TIMER_EVENTS_STATUS);
-	armada_370_xp_clkevt.event_handler(&armada_370_xp_clkevt);
+	writel(TIMER0_CLR_MASK, local_base + LCL_TIMER_EVENTS_STATUS);
+	evt->event_handler(evt);
 
 	return IRQ_HANDLED;
 }
 
-static struct irqaction armada_370_xp_timer_irq = {
-	.name		= "armada_370_xp_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
-	.handler	= armada_370_xp_timer_interrupt
+/*
+ * Setup the local clock events for a CPU.
+ */
+static int __cpuinit armada_370_xp_timer_setup(struct clock_event_device *evt)
+{
+	u32 u;
+	int cpu = smp_processor_id();
+
+	/* Use existing clock_event for cpu 0 */
+	if (!smp_processor_id())
+		return 0;
+
+	u = readl(local_base + TIMER_CTRL_OFF);
+	if (timer25Mhz)
+		writel(u | TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
+	else
+		writel(u & ~TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
+
+	evt->name		= armada_370_xp_clkevt.name;
+	evt->irq		= armada_370_xp_clkevt.irq;
+	evt->features		= armada_370_xp_clkevt.features;
+	evt->shift		= armada_370_xp_clkevt.shift;
+	evt->rating		= armada_370_xp_clkevt.rating,
+	evt->set_next_event	= armada_370_xp_clkevt_next_event,
+	evt->set_mode		= armada_370_xp_clkevt_mode,
+	evt->cpumask		= cpumask_of(cpu);
+
+	*__this_cpu_ptr(percpu_armada_370_xp_evt) = evt;
+
+	clockevents_config_and_register(evt, timer_clk, 1, 0xfffffffe);
+	enable_percpu_irq(evt->irq, 0);
+
+	return 0;
+}
+
+static void  armada_370_xp_timer_stop(struct clock_event_device *evt)
+{
+	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+	disable_percpu_irq(evt->irq);
+}
+
+static struct local_timer_ops armada_370_xp_local_timer_ops __cpuinitdata = {
+	.setup	= armada_370_xp_timer_setup,
+	.stop	=  armada_370_xp_timer_stop,
 };
 
 void __init armada_370_xp_timer_init(void)
 {
 	u32 u;
 	struct device_node *np;
-	unsigned int timer_clk;
+	int res;
+
 	np = of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-timer");
 	timer_base = of_iomap(np, 0);
 	WARN_ON(!timer_base);
+	local_base = of_iomap(np, 1);
 
 	if (of_find_property(np, "marvell,timer-25Mhz", NULL)) {
 		/* The fixed 25MHz timer is available so let's use it */
+		u = readl(local_base + TIMER_CTRL_OFF);
+		writel(u | TIMER0_25MHZ,
+		       local_base + TIMER_CTRL_OFF);
 		u = readl(timer_base + TIMER_CTRL_OFF);
-		writel(u | TIMER0_25MHZ | TIMER1_25MHZ,
+		writel(u | TIMER0_25MHZ,
 		       timer_base + TIMER_CTRL_OFF);
 		timer_clk = 25000000;
 	} else {
@@ -183,15 +235,23 @@ void __init armada_370_xp_timer_init(void)
 		struct clk *clk = of_clk_get(np, 0);
 		WARN_ON(IS_ERR(clk));
 		rate =  clk_get_rate(clk);
+		u = readl(local_base + TIMER_CTRL_OFF);
+		writel(u & ~(TIMER0_25MHZ),
+		       local_base + TIMER_CTRL_OFF);
+
 		u = readl(timer_base + TIMER_CTRL_OFF);
-		writel(u & ~(TIMER0_25MHZ | TIMER1_25MHZ),
+		writel(u & ~(TIMER0_25MHZ),
 		       timer_base + TIMER_CTRL_OFF);
+
 		timer_clk = rate / TIMER_DIVIDER;
+		timer25Mhz = false;
 	}
 
-	/* We use timer 0 as clocksource, and timer 1 for
-	   clockevents */
-	timer_irq = irq_of_parse_and_map(np, 1);
+	/*
+	 * We use timer 0 as clocksource, and private(local) timer 0
+	 * for clockevents
+	 */
+	armada_370_xp_clkevt.irq = irq_of_parse_and_map(np, 4);
 
 	ticks_per_jiffy = (timer_clk + HZ / 2) / HZ;
 
@@ -216,12 +276,26 @@ void __init armada_370_xp_timer_init(void)
 			      "armada_370_xp_clocksource",
 			      timer_clk, 300, 32, clocksource_mmio_readl_down);
 
-	/*
-	 * Setup clockevent timer (interrupt-driven).
-	 */
-	setup_irq(timer_irq, &armada_370_xp_timer_irq);
+	/* Register the clockevent on the private timer of CPU 0 */
 	armada_370_xp_clkevt.cpumask = cpumask_of(0);
 	clockevents_config_and_register(&armada_370_xp_clkevt,
 					timer_clk, 1, 0xfffffffe);
-}
 
+	percpu_armada_370_xp_evt = alloc_percpu(struct clock_event_device *);
+
+
+	/*
+	 * Setup clockevent timer (interrupt-driven).
+	 */
+	*__this_cpu_ptr(percpu_armada_370_xp_evt) = &armada_370_xp_clkevt;
+	res = request_percpu_irq(armada_370_xp_clkevt.irq,
+				armada_370_xp_timer_interrupt,
+				armada_370_xp_clkevt.name,
+				percpu_armada_370_xp_evt);
+	if (!res) {
+		enable_percpu_irq(armada_370_xp_clkevt.irq, 0);
+#ifdef CONFIG_LOCAL_TIMERS
+		local_timer_register(&armada_370_xp_local_timer_ops);
+#endif
+	}
+}
-- 
1.7.9.5

