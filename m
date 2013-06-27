Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3F0KnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:43:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53704 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3F0KnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:43:15 -0400
Date: Thu, 27 Jun 2013 12:43:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130627104309.GQ28407@twins.programming.kicks-ass.net>
References: <51CA0622.8010105@gmail.com>
 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
 <51CA0980.8010409@gmail.com>
 <20130626070533.GA3601@dyad.programming.kicks-ass.net>
 <51CB1AE9.5090709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB1AE9.5090709@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
> On 6/26/13 1:05 AM, Peter Zijlstra wrote:
> >>What is the expectation that the feature provides? not a whole lot of
> >>documentation on it. I walked down the path wondering if it solved an odd
> >>problem we are seeing with the CFS in 2.6.27 kernel.
> >
> >Its supposed to use hrtimers for slice expiry instead of the regular tick.
> 
> So theoretically CPU bound tasks would get preempted sooner? That was my
> guess/hope anyways.

Doth the below worketh?

---
 kernel/sched/core.c | 20 +++++++++++---------
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

