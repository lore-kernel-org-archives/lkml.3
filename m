Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab3K0BFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:05:24 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42967 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab3K0BFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:18 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 3/9] clocksource/cadence_ttc: Store timer frequency in driver data
Date: Tue, 26 Nov 2013 17:04:50 -0800
Message-Id: <1385514296-26702-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not allowed to call clk_get_rate() from interrupt context. To
avoid such calls the timer input frequency is stored in the driver's
data struct which makes it accessible to the driver in any context.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/cadence_ttc_timer.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4bc205..a92350b55d32 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -67,11 +67,13 @@
  * struct ttc_timer - This definition defines local timer structure
  *
  * @base_addr:	Base address of timer
+ * @freq:	Timer input clock frequency
  * @clk:	Associated clock source
  * @clk_rate_change_nb	Notifier block for clock rate changes
  */
 struct ttc_timer {
 	void __iomem *base_addr;
+	unsigned long freq;
 	struct clk *clk;
 	struct notifier_block clk_rate_change_nb;
 };
@@ -196,9 +198,8 @@ static void ttc_set_mode(enum clock_event_mode mode,
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		ttc_set_interval(timer,
-				DIV_ROUND_CLOSEST(clk_get_rate(ttce->ttc.clk),
-					PRESCALE * HZ));
+		ttc_set_interval(timer, DIV_ROUND_CLOSEST(ttce->ttc.freq,
+						PRESCALE * HZ));
 		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 	case CLOCK_EVT_MODE_UNUSED:
@@ -273,6 +274,8 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 		return;
 	}
 
+	ttccs->ttc.freq = clk_get_rate(ttccs->ttc.clk);
+
 	ttccs->ttc.clk_rate_change_nb.notifier_call =
 		ttc_rate_change_clocksource_cb;
 	ttccs->ttc.clk_rate_change_nb.next = NULL;
@@ -298,16 +301,14 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 	__raw_writel(CNT_CNTRL_RESET,
 		     ttccs->ttc.base_addr + TTC_CNT_CNTRL_OFFSET);
 
-	err = clocksource_register_hz(&ttccs->cs,
-			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
+	err = clocksource_register_hz(&ttccs->cs, ttccs->ttc.freq / PRESCALE);
 	if (WARN_ON(err)) {
 		kfree(ttccs);
 		return;
 	}
 
 	ttc_sched_clock_val_reg = base + TTC_COUNT_VAL_OFFSET;
-	setup_sched_clock(ttc_sched_clock_read, 16,
-			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
+	setup_sched_clock(ttc_sched_clock_read, 16, ttccs->ttc.freq / PRESCALE);
 }
 
 static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
@@ -334,6 +335,9 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
 				ndata->new_rate / PRESCALE);
 		local_irq_restore(flags);
 
+		/* update cached frequency */
+		ttc->freq = ndata->new_rate;
+
 		/* fall through */
 	}
 	case PRE_RATE_CHANGE:
@@ -367,6 +371,7 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	if (clk_notifier_register(ttcce->ttc.clk,
 				&ttcce->ttc.clk_rate_change_nb))
 		pr_warn("Unable to register clock notifier.\n");
+	ttcce->ttc.freq = clk_get_rate(ttcce->ttc.clk);
 
 	ttcce->ttc.base_addr = base;
 	ttcce->ce.name = "ttc_clockevent";
@@ -396,7 +401,7 @@ static void __init ttc_setup_clockevent(struct clk *clk,
 	}
 
 	clockevents_config_and_register(&ttcce->ce,
-			clk_get_rate(ttcce->ttc.clk) / PRESCALE, 1, 0xfffe);
+			ttcce->ttc.freq / PRESCALE, 1, 0xfffe);
 }
 
 /**
-- 
1.8.4.4

