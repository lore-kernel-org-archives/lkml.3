Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3H2Rxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:53:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64364 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3H2Rxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:53:40 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 1/3] clocksource/cadence_ttc: Remove clocksource clock notifier
Date: Thu, 29 Aug 2013 10:53:08 -0700
Message-Id: <1377798790-28927-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1377798790-28927-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the clocksource related clock notifier which tries to update the
clocksource frequency in case the timer's input frequency changes.
The notifier's approach - unregistering and re-registering the clocksource
with the new frequency - is destined to fail, if the TTC is the only
available HR clocksource.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 44 ---------------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4b..99ec898 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -219,43 +219,6 @@ static void ttc_set_mode(enum clock_event_mode mode,
 	}
 }
 
-static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
-		unsigned long event, void *data)
-{
-	struct clk_notifier_data *ndata = data;
-	struct ttc_timer *ttc = to_ttc_timer(nb);
-	struct ttc_timer_clocksource *ttccs = container_of(ttc,
-			struct ttc_timer_clocksource, ttc);
-
-	switch (event) {
-	case POST_RATE_CHANGE:
-		/*
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
-		 */
-		clocksource_unregister(&ttccs->cs);
-		clocksource_register_hz(&ttccs->cs,
-				ndata->new_rate / PRESCALE);
-		/* fall through */
-	case PRE_RATE_CHANGE:
-	case ABORT_RATE_CHANGE:
-	default:
-		return NOTIFY_DONE;
-	}
-}
-
 static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 {
 	struct ttc_timer_clocksource *ttccs;
@@ -273,13 +236,6 @@ static void __init ttc_setup_clocksource(struct clk *clk, void __iomem *base)
 		return;
 	}
 
-	ttccs->ttc.clk_rate_change_nb.notifier_call =
-		ttc_rate_change_clocksource_cb;
-	ttccs->ttc.clk_rate_change_nb.next = NULL;
-	if (clk_notifier_register(ttccs->ttc.clk,
-				&ttccs->ttc.clk_rate_change_nb))
-		pr_warn("Unable to register clock notifier.\n");
-
 	ttccs->ttc.base_addr = base;
 	ttccs->cs.name = "ttc_clocksource";
 	ttccs->cs.rating = 200;
-- 
1.8.4

