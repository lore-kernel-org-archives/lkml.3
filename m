Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaE0MLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:11:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:53784 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaE0MLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:11:32 -0400
Date: Tue, 27 May 2014 14:11:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer fixes for 3.15
Message-ID: <alpine.DEB.2.02.1405271405010.21720@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Two small fixlets for ARM SoC clocksource drivers:

* Avoid calling functions which might sleep from interrupt [disabled]
  context in tcb_clksrc used on Atmel SoCs.

* Use irq_force_affinity() to pin the per cpu timer interrupt on a not
  yet online cpu in the SiRFprimaII driver.

Thanks,

	tglx

------------------>
David Jander (1):
      clocksource: tcb_clksrc: Make tc_mode interrupt safe

Zhiwu Song (1):
      clocksource: marco: Fix the affinity set for local timer of CPU1


 drivers/clocksource/tcb_clksrc.c  |    8 ++++----
 drivers/clocksource/timer-marco.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 00fdd11..a8d7ea1 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -100,7 +100,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 			|| tcd->clkevt.mode == CLOCK_EVT_MODE_ONESHOT) {
 		__raw_writel(0xff, regs + ATMEL_TC_REG(2, IDR));
 		__raw_writel(ATMEL_TC_CLKDIS, regs + ATMEL_TC_REG(2, CCR));
-		clk_disable_unprepare(tcd->clk);
+		clk_disable(tcd->clk);
 	}
 
 	switch (m) {
@@ -109,7 +109,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 	 * of oneshot, we get lower overhead and improved accuracy.
 	 */
 	case CLOCK_EVT_MODE_PERIODIC:
-		clk_prepare_enable(tcd->clk);
+		clk_enable(tcd->clk);
 
 		/* slow clock, count up to RC, then irq and restart */
 		__raw_writel(timer_clock
@@ -126,7 +126,7 @@ static void tc_mode(enum clock_event_mode m, struct clock_event_device *d)
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		clk_prepare_enable(tcd->clk);
+		clk_enable(tcd->clk);
 
 		/* slow clock, count up to RC, then irq and stop */
 		__raw_writel(timer_clock | ATMEL_TC_CPCSTOP
@@ -194,7 +194,7 @@ static int __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 	ret = clk_prepare_enable(t2_clk);
 	if (ret)
 		return ret;
-	clk_disable_unprepare(t2_clk);
+	clk_disable(t2_clk);
 
 	clkevt.regs = tc->regs;
 	clkevt.clk = t2_clk;
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index b52e1c0..7f5374d 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -199,7 +199,7 @@ static int sirfsoc_local_timer_setup(struct clock_event_device *ce)
 
 	action->dev_id = ce;
 	BUG_ON(setup_irq(ce->irq, action));
-	irq_set_affinity(action->irq, cpumask_of(cpu));
+	irq_force_affinity(action->irq, cpumask_of(cpu));
 
 	clockevents_register_device(ce);
 	return 0;
