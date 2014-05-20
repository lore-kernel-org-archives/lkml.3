Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaETTIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:08:38 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56069 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaETTIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:08:36 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
References: <87mwej0yja.wl%klamm@yandex-team.ru>
	<xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<87lhu215ky.wl%klamm@yandex-team.ru>
	<20140519103247.GX30445@twins.programming.kicks-ass.net>
	<xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<20140520131526.GE11096@twins.programming.kicks-ass.net>
Date: Tue, 20 May 2014 12:08:34 -0700
In-Reply-To: <20140520131526.GE11096@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 20 May 2014 15:15:26 +0200")
Message-ID: <xm2638g42rpp.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, May 19, 2014 at 10:30:05AM -0700, bsegall@google.com wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> > On Fri, May 16, 2014 at 12:38:21PM +0400, Roman Gushchin wrote:
>> >
>> >> I still think, there is a deadlock. I'll try to explain.
>> >> Three CPUs must be involved:
>> >> CPU0				CPU1				CPU2
>> >> take rq->lock			period timer fired		
>> >> ...				take cfs_b lock
>> >> ...				...				tg_set_cfs_bandwidth()
>> >> throttle_cfs_rq()		release cfs_b lock		take cfs_b lock
>> >> ...				distribute_cfs_runtime()	timer_active = 0
>> >> take cfs_b->lock		wait for rq->lock		...
>> >> __start_cfs_bandwidth()	
>> >> {wait for timer callback
>> >>  break if timer_active == 1}
>> >> 
>> >> So, CPU0 and CPU1 are deadlocked.
>> >
>> > OK, so can someone explain this ->timer_active thing? esp. what's the
>> > 'obvious' difference with hrtimer_active()?
>> 
>> timer_active is only changed or checked under cfs_b lock, so that we can
>> be certain that the timer is active whenever runtime isn't full. We
>> can't use hrtimer_active because the timer might have unlocked the cfs_b
>> on another cpu and be about to return HRTIMER_NORESTART.
>
> The more I look at that code the more I'm convinced its crack, that
> entire __start_cfs_bandwidth() thing is brain melting, we don't need to
> cancel a timer before starting it, *hrtimer_start*() will happily remove
> the timer for you if its still enqueued.
>
> Removing that, removes a big part of the problem, no more ugly cancel
> loop to get stuck in.
>
> So now, if I understood you right, the entire reason you have this
> cfs_b->lock guarded ->timer_active nonsense is to make sure we don't
> accidentally loose the timer.
>
> It appears to me that it should be possible to guarantee that same by
> unconditionally (re)starting the timer when !queued. Because regardless
> what hrtimer::function will return, if we beat it to (re)enqueue the
> timer, it doesn't matter.
>
> Which leads us to what I think is a BUG in the current hrtimer code (and
> one wonders why we never hit that), because we drop the cpu_base->lock
> over calling hrtimer::function, hrtimer_start_range_ns() can in fact
> come in and (re)enqueue the timer, if hrtimer::function then returns
> HRTIMER_RESTART, we'll hit that BUG_ON() before trying to enqueue the
> timer once more.

Yeah, I believe the whole timer_active/cancel-before-start was to not
lose the timer while still avoiding the HRTIMER_RESTART/hrtimer_start
race. I'm not sure what, if anything, all the other ~35 users of
HRTIMER_RESTART do about this. At least some do hrtimer_cancel();
hrtimer_start(); though.

>
> So I _think_ something like the below would actually solve all the
> problems, no?
>
> Completely untested... does anybody have a 'useful' test case for this
> bw stuff?

[using the updated patch]:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4ea7b3f1a087..1f4602993d37 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -106,17 +106,17 @@ void __smp_mb__after_atomic(void)
>  EXPORT_SYMBOL(__smp_mb__after_atomic);
>  #endif
>  
> -void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
> +int start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
>  {
>  	unsigned long delta;
> -	ktime_t soft, hard, now;
> +	ktime_t soft, hard;
> +	int overruns = 0;
>  
>  	for (;;) {
> -		if (hrtimer_active(period_timer))
> +		if (hrtimer_is_queued(period_timer))
>  			break;
[...]
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 28ccf502c63c..11152b621a31 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3146,15 +3146,13 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
>  		amount = min_amount;
>  	else {
>  		/*
> -		 * If the bandwidth pool has become inactive, then at least one
> +		 * If we had overruns starting the timer, then at least one
>  		 * period must have elapsed since the last consumption.
>  		 * Refresh the global state and ensure bandwidth timer becomes
>  		 * active.
>  		 */
> -		if (!cfs_b->timer_active) {
> +		if (start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period))
>  			__refill_cfs_bandwidth_runtime(cfs_b);
> -			__start_cfs_bandwidth(cfs_b);
> -		}


So, this and the other changes will ensure that a period timer is always
queued. However, this also means that if we race so that we take
cfs_b->lock before the period timer, but late enough that the interrupt
has fired and we see !queued, we will hrtimer_forward the entire period
here. What assign_cfs_rq_runtime does is insufficient - it doesn't
unthrottle any other cfs_rqs, and since start_bandwidth_timer
hrtimer_forwarded the period away, neither will
(do_)sched_cfs_period_timer. (In addition throttle doesn't even do that,
but that's probably easy enough to fix)

I suppose we could check hrtimer_active and if so record any periods
start_bandwidth_timer used for sched_cfs_period_timer, which could then
force a do_sched_cfs_period_timer call. Perhaps something like this
(equally untested) patch on top of your patch.

One other possibly minor thing is that we are now possibly calling
hrtimer_start* more often, which is more expensive than just checking
timer_active. Since it's only if !queued though that seems just about as
good (it's also limited to 1/ms/cpu or so at that).

Anyway, patch:


---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f4f9857..122cdec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7779,11 +7779,8 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 
        __refill_cfs_bandwidth_runtime(cfs_b);
        /* restart the period timer (if active) to handle new period expiry */
-       if (runtime_enabled && cfs_b->timer_active) {
-               /* force a reprogram */
-               cfs_b->timer_active = 0;
+       if (runtime_enabled)
                __start_cfs_bandwidth(cfs_b);
-       }
        raw_spin_unlock_irq(&cfs_b->lock);
 
        for_each_possible_cpu(i) {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd528dc..eb80b7b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3177,7 +3177,7 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
                 * Refresh the global state and ensure bandwidth timer becomes
                 * active.
                 */
-               if (start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period))
+               if (__start_cfs_bandwidth(cfs_b->period_timer))
                        __refill_cfs_bandwidth_runtime(cfs_b);
 
                if (cfs_b->runtime > 0) {
@@ -3355,7 +3355,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
        cfs_rq->throttled_clock = rq_clock(rq);
        raw_spin_lock(&cfs_b->lock);
        list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
-       start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
+       __start_cfs_bandwidth(&cfs_b->period_timer, cfs_b->period);
        raw_spin_unlock(&cfs_b->lock);
 }
 
@@ -3718,6 +3718,22 @@ void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
        cfs_b->slack_timer.function = sched_cfs_slack_timer;
 }
 
+int __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+{
+       int was_active = hrtimer_active(&cfs_b->period_timer);
+       int overrun = start_bandwidth_timer(&cfs_b->period_timer,
+                                           cfs_b->period);
+
+       /*
+        * If our bandwidth was completely idle, we don't care about any periods
+        * during that idle time. Otherwise we may need to unthrottle on other
+        * cpus.
+        */
+       if (was_active)
+               cfs_b->stored_periods += overrun;
+       return overrun;
+}
+
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
        cfs_rq->runtime_enabled = 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 66b84f3..a3a4c35 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -187,7 +187,7 @@ struct cfs_bandwidth {
        s64 hierarchal_quota;
        u64 runtime_expires;
 
-       int idle;
+       int idle, stored_periods;
        struct hrtimer period_timer, slack_timer;
        struct list_head throttled_cfs_rq;
 
