Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaKZNIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:08:21 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46005 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKZNIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:08:20 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ezequiel.garcia@free-electrons.com, yl22@csr.com
Subject: [PATCH 1/4] clocksource: sirf: Remove hard-coded clock rate
Date: Wed, 26 Nov 2014 14:08:11 +0100
Message-Id: <1417007294-19869-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <5475D044.5060607@linaro.org>
References: <5475D044.5060607@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanchang Li <yl22@csr.com>

The customers may want to adjust the whole PLL and dividers according to
different user scenerios, and this causes the parent clock of sirf clocksource
not be divided exactly by the current hard-coded 1MHz clock rate.
This patch removes the hard-coded rate and makes the clocksource driver more
adaptive to the external changes.

Signed-off-by: Yanchang Li <yl22@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/timer-marco.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index caf7a20..361a789 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -20,8 +20,6 @@
 #include <linux/of_address.h>
 #include <linux/sched_clock.h>
 
-#define MARCO_CLOCK_FREQ 1000000
-
 #define SIRFSOC_TIMER_32COUNTER_0_CTRL			0x0000
 #define SIRFSOC_TIMER_32COUNTER_1_CTRL			0x0004
 #define SIRFSOC_TIMER_MATCH_0				0x0018
@@ -40,6 +38,8 @@
 
 #define SIRFSOC_TIMER_REG_CNT 6
 
+static unsigned long marco_timer_rate;
+
 static const u32 sirfsoc_timer_reg_list[SIRFSOC_TIMER_REG_CNT] = {
 	SIRFSOC_TIMER_WATCHDOG_EN,
 	SIRFSOC_TIMER_32COUNTER_0_CTRL,
@@ -195,7 +195,7 @@ static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
 	ce->rating = 200;
 	ce->set_mode = sirfsoc_timer_set_mode;
 	ce->set_next_event = sirfsoc_timer_set_next_event;
-	clockevents_calc_mult_shift(ce, MARCO_CLOCK_FREQ, 60);
+	clockevents_calc_mult_shift(ce, marco_timer_rate, 60);
 	ce->max_delta_ns = clockevent_delta2ns(-2, ce);
 	ce->min_delta_ns = clockevent_delta2ns(2, ce);
 	ce->cpumask = cpumask_of(cpu);
@@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
 /* initialize the kernel jiffy timer source */
 static void __init sirfsoc_marco_timer_init(struct device_node *np)
 {
-	unsigned long rate;
 	u32 timer_div;
 	struct clk *clk;
 
@@ -266,16 +265,12 @@ static void __init sirfsoc_marco_timer_init(struct device_node *np)
 
 	BUG_ON(clk_prepare_enable(clk));
 
-	rate = clk_get_rate(clk);
-
-	BUG_ON(rate < MARCO_CLOCK_FREQ);
-	BUG_ON(rate % MARCO_CLOCK_FREQ);
+	marco_timer_rate = clk_get_rate(clk);
 
-	/* Initialize the timer dividers */
-	timer_div = rate / MARCO_CLOCK_FREQ - 1;
-	writel_relaxed(timer_div << 16, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
-	writel_relaxed(timer_div << 16, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL);
-	writel_relaxed(timer_div << 16, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_1_CTRL);
+	/* timer dividers: 0, not divided */
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_0_CTRL);
+	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_32COUNTER_1_CTRL);
 
 	/* Initialize timer counters to 0 */
 	writel_relaxed(0, sirfsoc_timer_base + SIRFSOC_TIMER_64COUNTER_LOAD_LO);
@@ -288,7 +283,7 @@ static void __init sirfsoc_marco_timer_init(struct device_node *np)
 	/* Clear all interrupts */
 	writel_relaxed(0xFFFF, sirfsoc_timer_base + SIRFSOC_TIMER_INTR_STATUS);
 
-	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, MARCO_CLOCK_FREQ));
+	BUG_ON(clocksource_register_hz(&sirfsoc_clocksource, marco_timer_rate));
 
 	sirfsoc_clockevent_init();
 }
-- 
1.9.1

