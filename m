Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaCKWlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:41:21 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39830 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbaCKWlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:14 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 14/17] clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
Date: Tue, 11 Mar 2014 23:40:50 +0100
Message-Id: <1394577653-8615-14-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>

The currently used method adjusting the clocksource to a changing input
frequency does not work on kernels from 3.11 on.
The new approach is to keep the timer frequency as constant as possible.
I.e.
 - due to the TTC's prescaler limitations, allow frequency changes
   only if the frequency scales by a power of 2
 - adjust the counter's divider on the fly when a frequency change
   occurs

This limits cpufreq to scale by certain factors only.
But we may keep the time base somewhat constant, so that sleep() & co
keep working as expected, while supporting cpufreq.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c |  104 +++++++++++++++++++++++++------
 1 file changed, 84 insertions(+), 20 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index f05b9fd..49fbe28 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
 #include <linux/of_address.h>
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
@@ -82,6 +87,8 @@ struct ttc_timer {
 		container_of(x, struct ttc_timer, clk_rate_change_nb)
 
 struct ttc_timer_clocksource {
+	u32			scale_clk_ctrl_reg_old;
+	u32			scale_clk_ctrl_reg_new;
 	struct ttc_timer	ttc;
 	struct clocksource	cs;
 };
@@ -229,32 +236,89 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
 			struct ttc_timer_clocksource, ttc);
 
 	switch (event) {
-	case POST_RATE_CHANGE:
+	case PRE_RATE_CHANGE:
+	{
+		u32 psv;
+		unsigned long factor, rate_low, rate_high;
+
+		if (ndata->new_rate > ndata->old_rate) {
+			factor = DIV_ROUND_CLOSEST(ndata->new_rate,
+					ndata->old_rate);
+			rate_low = ndata->old_rate;
+			rate_high = ndata->new_rate;
+		} else {
+			factor = DIV_ROUND_CLOSEST(ndata->old_rate,
+					ndata->new_rate);
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
+		if (ndata->new_rate < ndata->old_rate)
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
+		if (ndata->new_rate < ndata->old_rate)
+			return NOTIFY_DONE;
+
+		/* scale up: adjust divider now - before frequency change */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		break;
+	}
+	case POST_RATE_CHANGE:
+		/* scale up: pre-change notification did the adjustment */
+		if (ndata->new_rate > ndata->old_rate)
+			return NOTIFY_OK;
+
+		/* scale down: adjust divider now - after frequency change */
+		__raw_writel(ttccs->scale_clk_ctrl_reg_new,
+				ttccs->ttc.base_addr + TTC_CLK_CNTRL_OFFSET);
+		break;
+
 	case ABORT_RATE_CHANGE:
+		/* we have to undo the adjustment in case we scale up */
+		if (ndata->new_rate < ndata->old_rate)
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
 }
 
 static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
-- 
1.7.9.5

