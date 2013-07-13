Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3GMLRZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:17:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:44371 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab3GMLRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:17:24 -0400
Date: Sat, 13 Jul 2013 13:17:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] scheduler updates for 3.11
Message-ID: <alpine.DEB.2.02.1307131315250.11918@ionos.tec.linutronix.de>
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

please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

 * Fix a potential deadlock versus hrtimers.

Thanks,

	tglx

------------------>
Peter Zijlstra (1):
      sched: Fix HRTICK


 kernel/sched/core.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9b1f2e5..0d8eb45 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -370,13 +370,6 @@ static struct rq *this_rq_lock(void)
 #ifdef CONFIG_SCHED_HRTICK
 /*
  * Use HR-timers to deliver accurate preemption points.
- *
- * Its all a bit involved since we cannot program an hrt while holding the
- * rq->lock. So what we do is store a state in in rq->hrtick_* and ask for a
- * reschedule event.
- *
- * When we get rescheduled we reprogram the hrtick_timer outside of the
- * rq->lock.
  */
 
 static void hrtick_clear(struct rq *rq)
@@ -404,6 +397,15 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 }
 
 #ifdef CONFIG_SMP
+
+static int __hrtick_restart(struct rq *rq)
+{
+	struct hrtimer *timer = &rq->hrtick_timer;
+	ktime_t time = hrtimer_get_softexpires(timer);
+
+	return __hrtimer_start_range_ns(timer, time, 0, HRTIMER_MODE_ABS_PINNED, 0);
+}
+
 /*
  * called from hardirq (IPI) context
  */
@@ -412,7 +414,7 @@ static void __hrtick_start(void *arg)
 	struct rq *rq = arg;
 
 	raw_spin_lock(&rq->lock);
-	hrtimer_restart(&rq->hrtick_timer);
+	__hrtick_restart(rq);
 	rq->hrtick_csd_pending = 0;
 	raw_spin_unlock(&rq->lock);
 }
@@ -430,7 +432,7 @@ void hrtick_start(struct rq *rq, u64 delay)
 	hrtimer_set_expires(timer, time);
 
 	if (rq == this_rq()) {
-		hrtimer_restart(timer);
+		__hrtick_restart(rq);
 	} else if (!rq->hrtick_csd_pending) {
 		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd, 0);
 		rq->hrtick_csd_pending = 1;
