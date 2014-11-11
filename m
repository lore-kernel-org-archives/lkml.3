Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaKKMnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:43:15 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63686 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:43:14 -0500
From: Barry Song <21cnbao@gmail.com>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Yanchang Li <yl22@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] clocksource: sirf: remove hard-coded clock rate
Date: Tue, 11 Nov 2014 20:42:52 +0800
Message-Id: <1415709772-2747-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanchang Li <yl22@csr.com>

customers might adjust the whole PLL and dividers according to different
user scenerios, and this causes the parent clock of sirf clocksource not
be divided exactly by current hard-coded 1MHz clock rate.
this patch removes the hard-coded rate and make clocksource drivers more
adaptive to external changes.

Signed-off-by: Yanchang Li <yl22@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
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
2.1.1

