Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaHCLPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:15:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:51410 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaHCLPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:15:05 -0400
Date: Sun, 3 Aug 2014 13:14:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer fixes for 3.16
Message-ID: <alpine.DEB.2.10.1408031313020.4997@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
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

Two fixes in the timer area:
    * A long standing lock inversion due to a printk
    * Suspend related hrtimer corruption in sched_clock

Thanks,

	tglx

------------------>
Jan Kara (1):
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler locks

Stephen Boyd (1):
      sched_clock: Avoid corrupting hrtimer tree during suspend


 kernel/time/clockevents.c | 10 ++++++----
 kernel/time/sched_clock.c |  4 +++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index ad362c2..9c94c19 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -146,7 +146,8 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
 {
 	/* Nothing to do if we already reached the limit */
 	if (dev->min_delta_ns >= MIN_DELTA_LIMIT) {
-		printk(KERN_WARNING "CE: Reprogramming failure. Giving up\n");
+		printk_deferred(KERN_WARNING
+				"CE: Reprogramming failure. Giving up\n");
 		dev->next_event.tv64 = KTIME_MAX;
 		return -ETIME;
 	}
@@ -159,9 +160,10 @@ static int clockevents_increase_min_delta(struct clock_event_device *dev)
 	if (dev->min_delta_ns > MIN_DELTA_LIMIT)
 		dev->min_delta_ns = MIN_DELTA_LIMIT;
 
-	printk(KERN_WARNING "CE: %s increased min_delta_ns to %llu nsec\n",
-	       dev->name ? dev->name : "?",
-	       (unsigned long long) dev->min_delta_ns);
+	printk_deferred(KERN_WARNING
+			"CE: %s increased min_delta_ns to %llu nsec\n",
+			dev->name ? dev->name : "?",
+			(unsigned long long) dev->min_delta_ns);
 	return 0;
 }
 
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 445106d..01d2d15 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -191,7 +191,8 @@ void __init sched_clock_postinit(void)
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(&sched_clock_timer);
+	update_sched_clock();
+	hrtimer_cancel(&sched_clock_timer);
 	cd.suspended = true;
 	return 0;
 }
@@ -199,6 +200,7 @@ static int sched_clock_suspend(void)
 static void sched_clock_resume(void)
 {
 	cd.epoch_cyc = read_sched_clock();
+	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
 	cd.suspended = false;
 }
 
