Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaLSNX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:23:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:34295 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaLSNXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:23:55 -0500
Date: Fri, 19 Dec 2014 14:23:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] NOHZ update for 3.19
Message-ID: <alpine.DEB.2.11.1412191415290.17382@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
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

Remove the call into the nohz idle code from the fake 'idle' thread in
the powerclamp driver along with the export of those functions which
was smuggeled in via the thermal tree. People have tried to hack
around it in the nohz core code, but it just violates all rightful
assumptions of that code about the only valid calling context
(i.e. the proper idle task).
The powerclamp trainwreck will still work, it just wont get the
benefit of long idle sleeps.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      tick/powerclamp: Remove tick_nohz_idle abuse


 drivers/thermal/intel_powerclamp.c | 2 --
 kernel/time/tick-sched.c           | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 95cb7fc20e17..6cb78497076a 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -435,7 +435,6 @@ static int clamp_thread(void *arg)
 		 * allowed. thus jiffies are updated properly.
 		 */
 		preempt_disable();
-		tick_nohz_idle_enter();
 		/* mwait until target jiffies is reached */
 		while (time_before(jiffies, target_jiffies)) {
 			unsigned long ecx = 1;
@@ -451,7 +450,6 @@ static int clamp_thread(void *arg)
 			start_critical_timings();
 			atomic_inc(&idle_wakeup_counter);
 		}
-		tick_nohz_idle_exit();
 		preempt_enable();
 	}
 	del_timer_sync(&wakeup_timer);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1f4356037a7d..ff3ec34702e8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -847,7 +847,6 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
 
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
@@ -974,7 +973,6 @@ void tick_nohz_idle_exit(void)
 
 	local_irq_enable();
 }
-EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
