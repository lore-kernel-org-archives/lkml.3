Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3CGAFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:05:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36444 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3CGAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:04:10 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27738012"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 09/10] clocksource: time-armada-370-xp: Divorce from local timer API
Date: Wed,  6 Mar 2013 16:04:05 -0800
Message-Id: <1362614646-24113-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the armada 370xp local timers from the local timer API.
This will allow us to remove ARM local timer support in the near
future and makes this driver multi-architecture friendly.

Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/time-armada-370-xp.c | 85 ++++++++++++++------------------
 1 file changed, 38 insertions(+), 47 deletions(-)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index efe4aef..ee2e50c5 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/clk.h>
+#include <linux/cpu.h>
 #include <linux/timer.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
@@ -31,7 +32,6 @@
 #include <linux/time-armada-370-xp.h>
 
 #include <asm/sched_clock.h>
-#include <asm/localtimer.h>
 /*
  * Timer block registers.
  */
@@ -70,7 +70,7 @@ static bool timer25Mhz = true;
  */
 static u32 ticks_per_jiffy;
 
-static struct clock_event_device __percpu **percpu_armada_370_xp_evt;
+static struct clock_event_device __percpu *armada_370_xp_evt;
 
 static u32 notrace armada_370_xp_read_sched_clock(void)
 {
@@ -143,14 +143,7 @@ armada_370_xp_clkevt_mode(enum clock_event_mode mode,
 	}
 }
 
-static struct clock_event_device armada_370_xp_clkevt = {
-	.name		= "armada_370_xp_per_cpu_tick",
-	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
-	.shift		= 32,
-	.rating		= 300,
-	.set_next_event	= armada_370_xp_clkevt_next_event,
-	.set_mode	= armada_370_xp_clkevt_mode,
-};
+static int armada_370_xp_clkevt_irq;
 
 static irqreturn_t armada_370_xp_timer_interrupt(int irq, void *dev_id)
 {
@@ -173,42 +166,53 @@ static int __cpuinit armada_370_xp_timer_setup(struct clock_event_device *evt)
 	u32 u;
 	int cpu = smp_processor_id();
 
-	/* Use existing clock_event for cpu 0 */
-	if (!smp_processor_id())
-		return 0;
-
 	u = readl(local_base + TIMER_CTRL_OFF);
 	if (timer25Mhz)
 		writel(u | TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
 	else
 		writel(u & ~TIMER0_25MHZ, local_base + TIMER_CTRL_OFF);
 
-	evt->name		= armada_370_xp_clkevt.name;
-	evt->irq		= armada_370_xp_clkevt.irq;
-	evt->features		= armada_370_xp_clkevt.features;
-	evt->shift		= armada_370_xp_clkevt.shift;
-	evt->rating		= armada_370_xp_clkevt.rating,
+	evt->name		= "armada_370_xp_per_cpu_tick",
+	evt->features		= CLOCK_EVT_FEAT_ONESHOT |
+				  CLOCK_EVT_FEAT_PERIODIC;
+	evt->shift		= 32,
+	evt->rating		= 300,
 	evt->set_next_event	= armada_370_xp_clkevt_next_event,
 	evt->set_mode		= armada_370_xp_clkevt_mode,
+	evt->irq		= armada_370_xp_clkevt_irq;
 	evt->cpumask		= cpumask_of(cpu);
 
-	*__this_cpu_ptr(percpu_armada_370_xp_evt) = evt;
-
 	clockevents_config_and_register(evt, timer_clk, 1, 0xfffffffe);
 	enable_percpu_irq(evt->irq, 0);
 
 	return 0;
 }
 
-static void  armada_370_xp_timer_stop(struct clock_event_device *evt)
+static void __cpuinit armada_370_xp_timer_stop(struct clock_event_device *evt)
 {
 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
 	disable_percpu_irq(evt->irq);
 }
 
-static struct local_timer_ops armada_370_xp_local_timer_ops __cpuinitdata = {
-	.setup	= armada_370_xp_timer_setup,
-	.stop	=  armada_370_xp_timer_stop,
+static int __cpuinit armada_370_xp_timer_cpu_notify(struct notifier_block *self,
+					   unsigned long action, void *hcpu)
+{
+	struct clock_event_device *evt = this_cpu_ptr(armada_370_xp_evt);
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		armada_370_xp_timer_setup(evt);
+		break;
+	case CPU_DYING:
+		armada_370_xp_timer_stop(evt);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block armada_370_xp_timer_cpu_nb __cpuinitdata = {
+	.notifier_call = armada_370_xp_timer_cpu_notify,
 };
 
 void __init armada_370_xp_timer_init(void)
@@ -224,9 +228,6 @@ void __init armada_370_xp_timer_init(void)
 
 	if (of_find_property(np, "marvell,timer-25Mhz", NULL)) {
 		/* The fixed 25MHz timer is available so let's use it */
-		u = readl(local_base + TIMER_CTRL_OFF);
-		writel(u | TIMER0_25MHZ,
-		       local_base + TIMER_CTRL_OFF);
 		u = readl(timer_base + TIMER_CTRL_OFF);
 		writel(u | TIMER0_25MHZ,
 		       timer_base + TIMER_CTRL_OFF);
@@ -236,9 +237,6 @@ void __init armada_370_xp_timer_init(void)
 		struct clk *clk = of_clk_get(np, 0);
 		WARN_ON(IS_ERR(clk));
 		rate =  clk_get_rate(clk);
-		u = readl(local_base + TIMER_CTRL_OFF);
-		writel(u & ~(TIMER0_25MHZ),
-		       local_base + TIMER_CTRL_OFF);
 
 		u = readl(timer_base + TIMER_CTRL_OFF);
 		writel(u & ~(TIMER0_25MHZ),
@@ -252,7 +250,7 @@ void __init armada_370_xp_timer_init(void)
 	 * We use timer 0 as clocksource, and private(local) timer 0
 	 * for clockevents
 	 */
-	armada_370_xp_clkevt.irq = irq_of_parse_and_map(np, 4);
+	armada_370_xp_clkevt_irq = irq_of_parse_and_map(np, 4);
 
 	ticks_per_jiffy = (timer_clk + HZ / 2) / HZ;
 
@@ -277,26 +275,19 @@ void __init armada_370_xp_timer_init(void)
 			      "armada_370_xp_clocksource",
 			      timer_clk, 300, 32, clocksource_mmio_readl_down);
 
-	/* Register the clockevent on the private timer of CPU 0 */
-	armada_370_xp_clkevt.cpumask = cpumask_of(0);
-	clockevents_config_and_register(&armada_370_xp_clkevt,
-					timer_clk, 1, 0xfffffffe);
+	register_cpu_notifier(&armada_370_xp_timer_cpu_nb);
 
-	percpu_armada_370_xp_evt = alloc_percpu(struct clock_event_device *);
+	armada_370_xp_evt = alloc_percpu(struct clock_event_device);
 
 
 	/*
 	 * Setup clockevent timer (interrupt-driven).
 	 */
-	*__this_cpu_ptr(percpu_armada_370_xp_evt) = &armada_370_xp_clkevt;
-	res = request_percpu_irq(armada_370_xp_clkevt.irq,
+	res = request_percpu_irq(armada_370_xp_clkevt_irq,
 				armada_370_xp_timer_interrupt,
-				armada_370_xp_clkevt.name,
-				percpu_armada_370_xp_evt);
-	if (!res) {
-		enable_percpu_irq(armada_370_xp_clkevt.irq, 0);
-#ifdef CONFIG_LOCAL_TIMERS
-		local_timer_register(&armada_370_xp_local_timer_ops);
-#endif
-	}
+				"armada_370_xp_per_cpu_tick",
+				armada_370_xp_evt);
+	/* Immediately configure the timer on the boot CPU */
+	if (!res)
+		armada_370_xp_timer_setup(this_cpu_ptr(armada_370_xp_evt));
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

