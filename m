Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaI2AYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41456 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaI2AYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:24:01 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] clocksource: cadence_ttc: Add support for 32bit mode
Date: Mon, 29 Sep 2014 02:23:42 +0200
Message-Id: <1411950226-21598-9-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

New TTCs support 32bit mode. Older versions support
only 16bit modes. Keep 16bit mode as default
and 32bit optional.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/cadence_ttc_timer.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 7a08811..510c8a1 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -25,7 +25,7 @@
 #include <linux/sched_clock.h>
 
 /*
- * This driver configures the 2 16-bit count-up timers as follows:
+ * This driver configures the 2 16/32-bit count-up timers as follows:
  *
  * T1: Timer 1, clocksource for generic timekeeping
  * T2: Timer 2, clockevent source for hrtimers
@@ -321,7 +321,8 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
+static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base,
+					 u32 timer_width)
 {
 	struct ttc_timer_clocksource *ttccs;
 	int err;
@@ -351,7 +352,7 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	ttccs->cs.name = "ttc_clocksource";
 	ttccs->cs.rating = 200;
 	ttccs->cs.read = __ttc_clocksource_read;
-	ttccs->cs.mask = CLOCKSOURCE_MASK(16);
+	ttccs->cs.mask = CLOCKSOURCE_MASK(timer_width);
 	ttccs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
 
 	/*
@@ -372,7 +373,8 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	}
 
 	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
-	sched_clock_register(ttc_sched_clock_read, 16, ttccs->ttc.freq / PRESCALE);
+	sched_clock_register(ttc_sched_clock_read, timer_width,
+			     ttccs->ttc.freq / PRESCALE);
 }
 
 static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
@@ -467,6 +469,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 	struct clk *clk_cs, *clk_ce;
 	static int initialized;
 	int clksel;
+	u32 timer_width = 16;
 
 	if (initialized)
 		return;
@@ -490,6 +493,8 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
+	of_property_read_u32(timer, "timer-width", &timer_width);
+
 	clksel = readl_relaxed(timer_baseaddr + TTC_CLK_CNTRL_OFFSET);
 	clksel = !!(clksel & TTC_CLK_CNTRL_CSRC_MASK);
 	clk_cs = of_clk_get(timer, clksel);
@@ -506,7 +511,7 @@ static void __init ttc_timer_init(struct device_node *timer)
 		BUG();
 	}
 
-	ttc_setup_clocksource(clk_cs, timer_baseaddr);
+	ttc_setup_clocksource(clk_cs, timer_baseaddr, timer_width);
 	ttc_setup_clockevent(clk_ce, timer_baseaddr + 4, irq);
 
 	pr_info("%s #0 at %p, irq=%d\n", timer->name, timer_baseaddr, irq);
-- 
1.9.1

