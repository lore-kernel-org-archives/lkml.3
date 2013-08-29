Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3H2RzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:55:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48922 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3H2RzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:55:13 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC] clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
Date: Thu, 29 Aug 2013 10:55:03 -0700
Message-Id: <1377798903-29211-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The currently used method adjusting the clocksource to a changing input
frequency will not work on kernels from 3.11 on.
The new approach is to keep the timer frequency as constant as possible.
I.e.
 - due to the TTC's prescaler limitations, allow frequency changes
   only if the frequency scales by a power of 2
 - adjust the counter's divider on the fly when a frequency change
   occurs

When suspending though, the driver should not prevent rate changes in
order to allow the system to enter its low power state. For that
reason a PM notifier is added so rate changes can be ignored during
suspend/resume.

Since time will pass between the actual change in HW of the input
clock and until SW and the TTC catch up, we sacrifice accuracy -
compared to an actually constant clock source.
Also we limit cpufreq to scale by certain factors only.
But we may keep the time base somewhat constant, so that sleep() & co
keep working as expected, while supporting cpufreq and suspend.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
The notifiers do always trigger, even when the TTC is not the current
clocksource. Is there a good way to prevent this?

 drivers/clocksource/cadence_ttc_timer.c | 141 +++++++++++++++++++++++++++-----
 1 file changed, 121 insertions(+), 20 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4b..1719b6c 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -22,6 +22,7 @@
 #include <linux/of_irq.h>
 #include <linux/slab.h>
 #include <linux/sched_clock.h>
+#include <linux/suspend.h>
 
 /*
  * This driver configures the 2 16-bit count-up timers as follows:
@@ -52,6 +53,8 @@
 #define TTC_CNT_CNTRL_DISABLE_MASK	0x1
 
 #define TTC_CLK_CNTRL_CSRC_MASK		(1 << 5)	/* clock source */
+#define TTC_CLK_CNTRL_PSV_MASK		0x1e
+#define TTC_CLK_CNTRL_PSV_SHIFT		1
 
 /*
  * Setup the timers to use pre-scaling, using a fixed value for now that will
@@ -63,6 +66,8 @@
 #define CLK_CNTRL_PRESCALE_EN	1
 #define CNT_CNTRL_RESET		(1 << 4)
 
+#define MAX_F_ERR 50
+
 /**
  * struct ttc_timer - This definition defines local timer structure
  *
@@ -80,8 +85,13 @@ struct ttc_timer {
 		container_of(x, struct ttc_timer, clk_rate_change_nb)
 
 struct ttc_timer_clocksource {
+	int			scale_dir;
+	u32			scale_clk_ctrl_reg_old;
+	u32			scale_clk_ctrl_reg_new;
+	int			suspending;
 	struct ttc_timer	ttc;
 	struct clocksource	cs;
+	struct notifier_block	suspend_nb;
 };
 
 #define to_ttc_timer_clksrc(x) \
@@ -227,33 +237,120 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 	struct ttc_timer_clocksource *ttccs = container_of(ttc,
 			struct ttc_timer_clocksource, ttc);
 
+	if (ttccs->suspending)
+		return NOTIFY_OK;
+
 	switch (event) {
-	case POST_RATE_CHANGE:
+	case PRE_RATE_CHANGE:
+	{
+		u32 psv;
+		unsigned long factor, rate_low, rate_high;
+
+		if (ndata->new_rate == ndata->old_rate) {
+			ttccs->scale_dir = 0;
+			return NOTIFY_OK;
+		}
+
+		if (ndata->new_rate > ndata->old_rate) {
+			factor = DIV_ROUND_CLOSEST(ndata->new_rate,
+					ndata->old_rate);
+			ttccs->scale_dir = 1;
+			rate_low = ndata->old_rate;
+			rate_high = ndata->new_rate;
+		} else {
+			factor = DIV_ROUND_CLOSEST(ndata->old_rate,
+					ndata->new_rate);
+			ttccs->scale_dir = -1;
+			rate_low = ndata->new_rate;
+			rate_high = ndata->old_rate;
+		}
+
+		if (!is_power_of_2(factor))
+				return NOTIFY_BAD;
+
+		if (abs(rate_high - (factor * rate_low)) > MAX_F_ERR)
+			return NOTIFY_BAD;
+
+		factor = __ilog2_u32(factor);
+
 		/*
-		 * Do whatever is necessary to maintain a proper time base
-		 *
-		 * I cannot find a way to adjust the currently used clocksource
-		 * to the new frequency. __clocksource_updatefreq_hz() sounds
-		 * good, but does not work. Not sure what's that missing.
-		 *
-		 * This approach works, but triggers two clocksource switches.
-		 * The first after unregister to clocksource jiffies. And
-		 * another one after the register to the newly registered timer.
-		 *
-		 * Alternatively we could 'waste' another HW timer to ping pong
-		 * between clock sources. That would also use one register and
-		 * one unregister call, but only trigger one clocksource switch
-		 * for the cost of another HW timer used by the OS.
+		 * store timer clock ctrl register so we can restore it in case
+		 * of an abort.
 		 */
-		clocksource_unregister(&ttccs->cs);
-		clocksource_register_hz(&ttccs->cs,
-				ndata->new_rate / PRESCALE);
-		/* fall through */
-	case PRE_RATE_CHANGE:
+		ttccs->scale_clk_ctrl_reg_old =
+			__raw_readl(ttccs->ttc.base_addr +
+					TTC_CLK_CNTRL_OFFSET);
+
+		psv = (ttccs->scale_clk_ctrl_reg_old &
+				TTC_CLK_CNTRL_PSV_MASK) >>
+				TTC_CLK_CNTRL_PSV_SHIFT;
+		if (ttccs->scale_dir < 0)
+			psv -= factor;
+		else
+			psv += factor;
+
+		/* prescaler within legal range? */
+		if (psv & ~(TTC_CLK_CNTRL_PSV_MASK >> TTC_CLK_CNTRL_PSV_SHIFT))
+			return NOTIFY_BAD;
+
+		ttccs->scale_clk_ctrl_reg_new = ttccs->scale_clk_ctrl_reg_old &
+			~TTC_CLK_CNTRL_PSV_MASK;
+		ttccs->scale_clk_ctrl_reg_new |= psv << TTC_CLK_CNTRL_PSV_SHIFT;
+
+
+		/* scale down: adjust divider in post-change notification */
+		if (ttccs->scale_dir < 0)
+			return NOTIFY_DONE;
+
+		/* scale up: adjust divider now - before frequency change */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		break;
+	}
+	case POST_RATE_CHANGE:
+		/* scale up: pre-change notification did the adjustment */
+		if (ttccs->scale_dir >= 0)
+			return NOTIFY_OK;
+
+		/* scale down: adjust divider now - after frequency change */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		break;
+
 	case ABORT_RATE_CHANGE:
+		/* we have to undo the adjustment in case we scale up */
+		if (ttccs->scale_dir <= 0)
+			return NOTIFY_OK;
+
+		/* restore original register value */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_old,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		/* fall through */
 	default:
 		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_DONE;
+}
+
+static int ttc_suspend_notifier_cb(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	struct ttc_timer_clocksource *ttccs = container_of(nb,
+			struct ttc_timer_clocksource, suspend_nb);
+
+	switch (event) {
+	case PM_SUSPEND_PREPARE:
+		ttccs->suspending = 1;
+		break;
+	case PM_POST_SUSPEND:
+		ttccs->suspending = 0;
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
 }
 
 static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
@@ -280,6 +377,10 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 				&ttccs->ttc.clk_rate_change_nb))
 		pr_warn("Unable to register clock notifier.\n");
 
+	ttccs->suspend_nb.notifier_call = ttc_suspend_notifier_cb;
+	if (register_pm_notifier(&ttccs->suspend_nb))
+		pr_warn("Unable to register PM notifier.\n");
+
 	ttccs->ttc.base_addr = base;
 	ttccs->cs.name = "ttc_clocksource";
 	ttccs->cs.rating = 200;
-- 
1.8.4

