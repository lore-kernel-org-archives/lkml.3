Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaAOS1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:27:23 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49637 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaAOS1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:27:21 -0500
Date: Wed, 15 Jan 2014 19:27:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fix
Message-ID: <20140115182717.GA23169@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   # HEAD: e59da0aedb573a347fa501fa63d3ff5055aa1bc7 Merge branch 'clockevents/3.13-fixes' of git://git.linaro.org/people/daniel.lezcano/linux into timers/urgent

It contains a crash fix for the ARM Cadence TTC clock driver.

 Thanks,

	Ingo

------------------>
Soren Brinkmann (1):
      clocksource: cadence_ttc: Fix mutex taken inside interrupt context


 drivers/clocksource/cadence_ttc_timer.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index b2bb3a4b..a92350b 100644
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
