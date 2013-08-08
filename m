Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab3HHHci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:32:38 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57552 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3HHHch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:32:37 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable reprogramming in remove_hrtimer
From: "ethan.zhao" <ethan.kernel@gmail.com>
In-Reply-To: <20130729115701.GD3008@twins.programming.kicks-ass.net>
Date: Thu, 8 Aug 2013 15:32:12 +0800
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        yinghai@kernel.org, joe.jin@oracle.com
Content-Transfer-Encoding: 8BIT
Message-Id: <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com> <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de> <20130729115701.GD3008@twins.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 3.11-rc3 With peter's patch and disable C-state in BIOS, got 1 second better performance !
[root@localhost ~]# time ./pip1m

real	0m4.399s
user	0m0.092s
sys	0m2.775s
[root@localhost ~]# time ./pip1m

real	0m4.352s
user	0m0.099s
sys	0m2.751s
[root@localhost ~]# time ./pip1m

real	0m4.328s
user	0m0.102s
sys	0m2.731s

Compared with default kernel 3.11-rc3 and disable C-states in BIOS, test case 4
4. Disable C1E C3 C6 C-states and SpeedStep in BIOS, default configuration of kernel 3.11-rc3.
[root@localhost ~]# time ./pip1m

real	0m5.371s
user	0m0.102s
sys	0m3.253s
[root@localhost ~]# time ./pip1m

real	0m5.329s
user	0m0.075s
sys	0m3.254s
 

That is great improvement, So it is worth to merge. 


Thanks
Ethan

 

ÔÚ 2013-7-29£¬ÏÂÎç7:57£¬Peter Zijlstra <peterz@infradead.org> Ð´µÀ£º
> 
> So aside from the complete mess posted; how about something like this?
> 
> *completely untested etc..*
> 
> ---
> include/linux/hrtimer.h |  5 +++++
> kernel/hrtimer.c        | 60 +++++++++++++++++++++++--------------------------
> 2 files changed, 33 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index d19a5c2..f2bcb9c 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -185,6 +185,7 @@ struct hrtimer_cpu_base {
> 	ktime_t				expires_next;
> 	int				hres_active;
> 	int				hang_detected;
> +	int				timers_removed;
> 	unsigned long			nr_events;
> 	unsigned long			nr_retries;
> 	unsigned long			nr_hangs;
> @@ -261,6 +262,8 @@ static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
> #ifdef CONFIG_HIGH_RES_TIMERS
> struct clock_event_device;
> 
> +extern void hrtimer_enter_idle(void);
> +
> extern void hrtimer_interrupt(struct clock_event_device *dev);
> 
> /*
> @@ -296,6 +299,8 @@ extern void clock_was_set_delayed(void);
> # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
> # define KTIME_MONOTONIC_RES	KTIME_LOW_RES
> 
> +static inline void hrtimer_enter_idle(void) { }
> +
> static inline void hrtimer_peek_ahead_timers(void) { }
> 
> /*
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index f0f4fe2..ffb16d3 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -673,6 +673,27 @@ static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
> 	return ktime_get_update_offsets(offs_real, offs_boot, offs_tai);
> }
> 
> +static void __hrtimer_reprogram_all(struct hrtimer_cpu_base *base)
> +{
> +	if (!hrtimer_hres_active())
> +		return;
> +
> +	raw_spin_lock(&base->lock);
> +	hrtimer_update_base(base);
> +	hrtimer_force_reprogram(base, 0);
> +	raw_spin_unlock(&base->lock);
> +}
> +
> +void hrtimer_enter_idle(void)
> +{
> +	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
> +
> +	if (base->timers_removed) {
> +		base->timers_removed = 0;
> +		__hrtimer_reprogramm_all(base);
> +	}
> +}
> +
> /*
>  * Retrigger next event is called after clock was set
>  *
> @@ -682,13 +703,7 @@ static void retrigger_next_event(void *arg)
> {
> 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
> 
> -	if (!hrtimer_hres_active())
> -		return;
> -
> -	raw_spin_lock(&base->lock);
> -	hrtimer_update_base(base);
> -	hrtimer_force_reprogram(base, 0);
> -	raw_spin_unlock(&base->lock);
> +	__hrtimer_reprogram_all(base);
> }
> 
> /*
> @@ -907,7 +922,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
>  */
> static void __remove_hrtimer(struct hrtimer *timer,
> 			     struct hrtimer_clock_base *base,
> -			     unsigned long newstate, int reprogram)
> +			     unsigned long newstate)
> {
> 	struct timerqueue_node *next_timer;
> 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
> @@ -915,19 +930,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
> 
> 	next_timer = timerqueue_getnext(&base->active);
> 	timerqueue_del(&base->active, &timer->node);
> -	if (&timer->node == next_timer) {
> #ifdef CONFIG_HIGH_RES_TIMERS
> -		/* Reprogram the clock event device. if enabled */
> -		if (reprogram && hrtimer_hres_active()) {
> -			ktime_t expires;
> -
> -			expires = ktime_sub(hrtimer_get_expires(timer),
> -					    base->offset);
> -			if (base->cpu_base->expires_next.tv64 == expires.tv64)
> -				hrtimer_force_reprogram(base->cpu_base, 1);
> -		}
> +	if (hrtimer_hres_active() && &timer->node == next_timer)
> +		base->cpu_base->timers_removed++;
> #endif
> -	}
> 	if (!timerqueue_getnext(&base->active))
> 		base->cpu_base->active_bases &= ~(1 << base->index);
> out:
> @@ -942,26 +948,16 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
> {
> 	if (hrtimer_is_queued(timer)) {
> 		unsigned long state;
> -		int reprogram;
> 
> -		/*
> -		 * Remove the timer and force reprogramming when high
> -		 * resolution mode is active and the timer is on the current
> -		 * CPU. If we remove a timer on another CPU, reprogramming is
> -		 * skipped. The interrupt event on this CPU is fired and
> -		 * reprogramming happens in the interrupt handler. This is a
> -		 * rare case and less expensive than a smp call.
> -		 */
> 		debug_deactivate(timer);
> 		timer_stats_hrtimer_clear_start_info(timer);
> -		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
> 		/*
> 		 * We must preserve the CALLBACK state flag here,
> 		 * otherwise we could move the timer base in
> 		 * switch_hrtimer_base.
> 		 */
> 		state = timer->state & HRTIMER_STATE_CALLBACK;
> -		__remove_hrtimer(timer, base, state, reprogram);
> +		__remove_hrtimer(timer, base, state);
> 		return 1;
> 	}
> 	return 0;
> @@ -1243,7 +1239,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
> 	WARN_ON(!irqs_disabled());
> 
> 	debug_deactivate(timer);
> -	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
> +	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
> 	timer_stats_account_hrtimer(timer);
> 	fn = timer->function;
> 
> @@ -1690,7 +1686,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
> 		 * timer could be seen as !active and just vanish away
> 		 * under us on another CPU
> 		 */
> -		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
> +		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE);
> 		timer->base = new_base;
> 		/*
> 		 * Enqueue the timers on the new cpu. This does not

