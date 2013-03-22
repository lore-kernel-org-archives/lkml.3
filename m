Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab3CVCbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:31:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33306 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3CVCbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:31:17 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=k73MykfMmY8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=TJ5gPuUbub8A:10 a=D19gQVrFAAAA:8 a=8T59DR07AAAA:8 a=2s8pXi9Qdxo8C54laDcA:9 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363919473.6345.88.camel@gandalf.local.home>
Subject: Re: PREEMPT_RT vs 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Ingo Molnar <mingo@elte.hu>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Thu, 21 Mar 2013 22:31:13 -0400
In-Reply-To: <1363914713.31336.191.camel@deadeye.wl.decadent.org.uk>
References: <1363914713.31336.191.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 01:11 +0000, Ben Hutchings wrote:
> Commit b22affe0aef4 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
> conflicts with the RT patches
> hrtimer-fixup-hrtimer-callback-changes-for-preempt-r.patch and
> peter_zijlstra-frob-hrtimer.patch, as they all change
> hrtimer_enqueue_reprogram().  It seems that the changes in the RT
> patches now belong in __hrtimer_start_range_ns().
> 
> Since I haven't seen any RT releases in a while, here's what I came up
> with for 3.2-rt:

Note, I posted a fix on Tuesday:

https://lkml.org/lkml/2013/3/19/369

I'm waiting for Thomas to give his OK on it before releasing the series.
He told me he'll have a look at it tomorrow. I've already ran the series
through all my tests, and will post it immediately after I get the OK.
Or if there's a issue I will have to fix it and rerun my tests.


> 
> ---
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 3 Jul 2009 08:44:31 -0500
> Subject: hrtimer: fixup hrtimer callback changes for preempt-rt
> 
> In preempt-rt we can not call the callbacks which take sleeping locks
> from the timer interrupt context.
> 
> Bring back the softirq split for now, until we fixed the signal
> delivery problem for real.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> [bwh: Pull the changes to hrtimer_enqueue_reprogram() up into
>  __hrtimer_start_range_ns(), following changes in
>  commit b22affe0aef4 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
>  backported into 3.2.40]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -111,6 +111,8 @@ struct hrtimer {
>  	enum hrtimer_restart		(*function)(struct hrtimer *);
>  	struct hrtimer_clock_base	*base;
>  	unsigned long			state;
> +	struct list_head		cb_entry;
> +	int				irqsafe;
>  #ifdef CONFIG_TIMER_STATS
>  	int				start_pid;
>  	void				*start_site;
> @@ -147,6 +149,7 @@ struct hrtimer_clock_base {
>  	int			index;
>  	clockid_t		clockid;
>  	struct timerqueue_head	active;
> +	struct list_head	expired;
>  	ktime_t			resolution;
>  	ktime_t			(*get_time)(void);
>  	ktime_t			softirq_time;
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -589,8 +589,7 @@ static int hrtimer_reprogram(struct hrti
>  	 * When the callback is running, we do not reprogram the clock event
>  	 * device. The timer callback is either running on a different CPU or
>  	 * the callback is executed in the hrtimer_interrupt context. The
> -	 * reprogramming is handled either by the softirq, which called the
> -	 * callback or at the end of the hrtimer_interrupt.
> +	 * reprogramming is handled at the end of the hrtimer_interrupt.
>  	 */
>  	if (hrtimer_callback_running(timer))
>  		return 0;
> @@ -625,6 +624,9 @@ static int hrtimer_reprogram(struct hrti
>  	return res;
>  }
>  
> +static void __run_hrtimer(struct hrtimer *timer, ktime_t *now);
> +static int hrtimer_rt_defer(struct hrtimer *timer);
> +
>  /*
>   * Initialize the high resolution related parts of cpu_base
>   */
> @@ -730,6 +732,11 @@ static inline int hrtimer_enqueue_reprog
>  }
>  static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
>  static inline void retrigger_next_event(void *arg) { }
> +static inline int hrtimer_reprogram(struct hrtimer *timer,
> +				    struct hrtimer_clock_base *base)
> +{
> +	return 0;
> +}
>  
>  #endif /* CONFIG_HIGH_RES_TIMERS */
>  
> @@ -861,9 +868,9 @@ void hrtimer_wait_for_timer(const struct
>  {
>  	struct hrtimer_clock_base *base = timer->base;
>  
> -	if (base && base->cpu_base && !hrtimer_hres_active(base->cpu_base))
> +	if (base && base->cpu_base && !timer->irqsafe)
>  		wait_event(base->cpu_base->wait,
> -				!(timer->state & HRTIMER_STATE_CALLBACK));
> +			   !(timer->state & HRTIMER_STATE_CALLBACK));
>  }
>  
>  #else
> @@ -913,6 +920,11 @@ static void __remove_hrtimer(struct hrti
>  	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
>  		goto out;
>  
> +	if (unlikely(!list_empty(&timer->cb_entry))) {
> +		list_del_init(&timer->cb_entry);
> +		goto out;
> +	}
> +
>  	next_timer = timerqueue_getnext(&base->active);
>  	timerqueue_del(&base->active, &timer->node);
>  	if (&timer->node == next_timer) {
> @@ -1011,6 +1023,26 @@ int __hrtimer_start_range_ns(struct hrti
>  	 */
>  	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
>  		&& hrtimer_enqueue_reprogram(timer, new_base)) {
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +	again:

What kernel are you working with? I don't see anywhere the "again:"
within a PREEMPT_RT_BASE block.

> +		/*
> +		 * Move softirq based timers away from the rbtree in
> +		 * case it expired already. Otherwise we would have a
> +		 * stale base->first entry until the softirq runs.
> +		 */
> +		if (!hrtimer_rt_defer(timer)) {
> +			ktime_t now = ktime_get();
> +
> +			__run_hrtimer(timer, &now);
> +			/*
> +			 * __run_hrtimer might have requeued timer and
> +			 * it could be base->first again.
> +			 */
> +			if (&timer->node == new_base->active.next &&
> +			    hrtimer_enqueue_reprogram(timer, new_base))
> +				goto again;
> +		} else
> +#endif
>  		if (wakeup) {
>  			/*
>  			 * We need to drop cpu_base->lock to avoid a
> @@ -1188,6 +1220,7 @@ static void __hrtimer_init(struct hrtime
>  
>  	base = hrtimer_clockid_to_base(clock_id);
>  	timer->base = &cpu_base->clock_base[base];
> +	INIT_LIST_HEAD(&timer->cb_entry);
>  	timerqueue_init(&timer->node);
>  
>  #ifdef CONFIG_TIMER_STATS
> @@ -1271,10 +1304,118 @@ static void __run_hrtimer(struct hrtimer
>  	timer->state &= ~HRTIMER_STATE_CALLBACK;
>  }
>  
> -#ifdef CONFIG_HIGH_RES_TIMERS
> -
>  static enum hrtimer_restart hrtimer_wakeup(struct hrtimer *timer);
>  
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +static void hrtimer_rt_reprogram(int restart, struct hrtimer *timer,
> +				 struct hrtimer_clock_base *base)
> +{
> +	/*
> +	 * Note, we clear the callback flag before we requeue the
> +	 * timer otherwise we trigger the callback_running() check
> +	 * in hrtimer_reprogram().
> +	 */
> +	timer->state &= ~HRTIMER_STATE_CALLBACK;
> +
> +	if (restart != HRTIMER_NORESTART) {
> +		BUG_ON(hrtimer_active(timer));
> +		/*
> +		 * Enqueue the timer, if it's the leftmost timer then
> +		 * we need to reprogram it.
> +		 */
> +		if (!enqueue_hrtimer(timer, base))
> +			return;
> +
> +		if (hrtimer_reprogram(timer, base))
> +			goto requeue;
> +
> +	} else if (hrtimer_active(timer)) {
> +		/*
> +		 * If the timer was rearmed on another CPU, reprogram
> +		 * the event device.
> +		 */
> +		if (&timer->node == base->active.next &&
> +		    hrtimer_reprogram(timer, base))
> +			goto requeue;
> +	}
> +	return;
> +
> +requeue:
> +	/*
> +	 * Timer is expired. Thus move it from tree to pending list
> +	 * again.
> +	 */
> +	__remove_hrtimer(timer, base, timer->state, 0);
> +	list_add_tail(&timer->cb_entry, &base->expired);
> +}
> +
> +/*
> + * The changes in mainline which removed the callback modes from
> + * hrtimer are not yet working with -rt. The non wakeup_process()
> + * based callbacks which involve sleeping locks need to be treated
> + * seperately.
> + */
> +static void hrtimer_rt_run_pending(void)
> +{
> +	enum hrtimer_restart (*fn)(struct hrtimer *);
> +	struct hrtimer_cpu_base *cpu_base;
> +	struct hrtimer_clock_base *base;
> +	struct hrtimer *timer;
> +	int index, restart;
> +
> +	local_irq_disable();
> +	cpu_base = &per_cpu(hrtimer_bases, smp_processor_id());
> +
> +	raw_spin_lock(&cpu_base->lock);
> +
> +	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
> +		base = &cpu_base->clock_base[index];
> +
> +		while (!list_empty(&base->expired)) {
> +			timer = list_first_entry(&base->expired,
> +						 struct hrtimer, cb_entry);
> +
> +			/*
> +			 * Same as the above __run_hrtimer function
> +			 * just we run with interrupts enabled.
> +			 */
> +			debug_hrtimer_deactivate(timer);
> +			__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
> +			timer_stats_account_hrtimer(timer);
> +			fn = timer->function;
> +
> +			raw_spin_unlock_irq(&cpu_base->lock);
> +			restart = fn(timer);
> +			raw_spin_lock_irq(&cpu_base->lock);
> +
> +			hrtimer_rt_reprogram(restart, timer, base);
> +		}
> +	}
> +
> +	raw_spin_unlock_irq(&cpu_base->lock);
> +
> +	wake_up_timer_waiters(cpu_base);
> +}
> +
> +static int hrtimer_rt_defer(struct hrtimer *timer)
> +{
> +	if (timer->irqsafe)
> +		return 0;
> +
> +	__remove_hrtimer(timer, timer->base, timer->state, 0);
> +	list_add_tail(&timer->cb_entry, &timer->base->expired);
> +	return 1;
> +}
> +
> +#else
> +
> +static inline void hrtimer_rt_run_pending(void) { }
> +static inline int hrtimer_rt_defer(struct hrtimer *timer) { return 0; }
> +
> +#endif
> +
> +#ifdef CONFIG_HIGH_RES_TIMERS
> +
>  /*
>   * High resolution timer interrupt
>   * Called with interrupts disabled
> @@ -1283,7 +1424,7 @@ void hrtimer_interrupt(struct clock_even
>  {
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>  	ktime_t expires_next, now, entry_time, delta;
> -	int i, retries = 0;
> +	int i, retries = 0, raise = 0;
>  
>  	BUG_ON(!cpu_base->hres_active);
>  	cpu_base->nr_events++;
> @@ -1349,7 +1490,10 @@ retry:
>  				break;
>  			}
>  
> -			__run_hrtimer(timer, &basenow);
> +			if (!hrtimer_rt_defer(timer))
> +				__run_hrtimer(timer, &basenow);
> +			else
> +				raise = 1;
>  		}
>  	}
>  
> @@ -1364,6 +1508,10 @@ retry:
>  	if (expires_next.tv64 == KTIME_MAX ||
>  	    !tick_program_event(expires_next, 0)) {
>  		cpu_base->hang_detected = 0;
> +
> +		if (raise)
> +			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
> +
>  		return;
>  	}
>  
> @@ -1444,6 +1592,12 @@ void hrtimer_peek_ahead_timers(void)
>  	local_irq_restore(flags);
>  }
>  
> +#else /* CONFIG_HIGH_RES_TIMERS */
> +
> +static inline void __hrtimer_peek_ahead_timers(void) { }
> +
> +#endif	/* !CONFIG_HIGH_RES_TIMERS */
> +
>  static void run_hrtimer_softirq(struct softirq_action *h)
>  {
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
> @@ -1453,15 +1607,9 @@ static void run_hrtimer_softirq(struct s
>  		clock_was_set();
>  	}
>  
> -	hrtimer_peek_ahead_timers();
> +	hrtimer_rt_run_pending();
>  }
>  
> -#else /* CONFIG_HIGH_RES_TIMERS */
> -
> -static inline void __hrtimer_peek_ahead_timers(void) { }
> -
> -#endif	/* !CONFIG_HIGH_RES_TIMERS */
> -
>  /*
>   * Called from timer softirq every jiffy, expire hrtimers:
>   *
> @@ -1494,7 +1642,7 @@ void hrtimer_run_queues(void)
>  	struct timerqueue_node *node;
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>  	struct hrtimer_clock_base *base;
> -	int index, gettime = 1;
> +	int index, gettime = 1, raise = 0;
>  
>  	if (hrtimer_hres_active())
>  		return;
> @@ -1519,12 +1667,16 @@ void hrtimer_run_queues(void)
>  					hrtimer_get_expires_tv64(timer))
>  				break;
>  
> -			__run_hrtimer(timer, &base->softirq_time);
> +			if (!hrtimer_rt_defer(timer))
> +				__run_hrtimer(timer, &base->softirq_time);
> +			else
> +				raise = 1;
>  		}
>  		raw_spin_unlock(&cpu_base->lock);
>  	}
>  
> -	wake_up_timer_waiters(cpu_base);
> +	if (raise)
> +		raise_softirq_irqoff(HRTIMER_SOFTIRQ);
>  }
>  
>  /*
> @@ -1546,6 +1698,7 @@ static enum hrtimer_restart hrtimer_wake
>  void hrtimer_init_sleeper(struct hrtimer_sleeper *sl, struct task_struct *task)
>  {
>  	sl->timer.function = hrtimer_wakeup;
> +	sl->timer.irqsafe = 1;
>  	sl->task = task;
>  }
>  EXPORT_SYMBOL_GPL(hrtimer_init_sleeper);
> @@ -1684,6 +1837,7 @@ static void __cpuinit init_hrtimers_cpu(
>  	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
>  		cpu_base->clock_base[i].cpu_base = cpu_base;
>  		timerqueue_init_head(&cpu_base->clock_base[i].active);
> +		INIT_LIST_HEAD(&cpu_base->clock_base[i].expired);
>  	}
>  
>  	hrtimer_init_hres(cpu_base);
> @@ -1802,9 +1956,7 @@ void __init hrtimers_init(void)
>  	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
>  			  (void *)(long)smp_processor_id());
>  	register_cpu_notifier(&hrtimers_nb);
> -#ifdef CONFIG_HIGH_RES_TIMERS
>  	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
> -#endif
>  }
>  
>  /**
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -189,6 +189,7 @@ void init_rt_bandwidth(struct rt_bandwid
>  
>  	hrtimer_init(&rt_b->rt_period_timer,
>  			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	rt_b->rt_period_timer.irqsafe = 1;
>  	rt_b->rt_period_timer.function = sched_rt_period_timer;
>  }
>  
> @@ -1274,6 +1275,7 @@ static void init_rq_hrtick(struct rq *rq
>  
>  	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	rq->hrtick_timer.function = hrtick;
> +	rq->hrtick_timer.irqsafe = 1;
>  }
>  #else	/* CONFIG_SCHED_HRTICK */
>  static inline void hrtick_clear(struct rq *rq)
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -805,6 +805,7 @@ void tick_setup_sched_timer(void)
>  	 * Emulate tick processing via per-CPU hrtimers:
>  	 */
>  	hrtimer_init(&ts->sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
> +	ts->sched_timer.irqsafe = 1;
>  	ts->sched_timer.function = tick_sched_timer;
>  
>  	/* Get the next period (per cpu) */
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -436,6 +436,7 @@ static void watchdog_prepare_cpu(int cpu
>  	WARN_ON(per_cpu(softlockup_watchdog, cpu));
>  	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	hrtimer->function = watchdog_timer_fn;
> +	hrtimer->irqsafe = 1;
>  }
>  
>  static int watchdog_enable(int cpu)
> ---
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 12 Aug 2011 17:39:54 +0200
> Subject: hrtimer: Don't call the timer handler from hrtimer_start
> 
>  [<ffffffff812de4a9>] __delay+0xf/0x11
>  [<ffffffff812e36e9>] do_raw_spin_lock+0xd2/0x13c
>  [<ffffffff815028ee>] _raw_spin_lock+0x60/0x73              rt_b->rt_runtime_lock
>  [<ffffffff81068f68>] ? sched_rt_period_timer+0xad/0x281
>  [<ffffffff81068f68>] sched_rt_period_timer+0xad/0x281
>  [<ffffffff8109e5e1>] __run_hrtimer+0x1e4/0x347
>  [<ffffffff81068ebb>] ? enqueue_rt_entity+0x36/0x36
>  [<ffffffff8109f2b1>] __hrtimer_start_range_ns+0x2b5/0x40a  base->cpu_base->lock  (lock_hrtimer_base)
>  [<ffffffff81068b6f>] __enqueue_rt_entity+0x26f/0x2aa       rt_b->rt_runtime_lock (start_rt_bandwidth)
>  [<ffffffff81068ead>] enqueue_rt_entity+0x28/0x36
>  [<ffffffff81069355>] enqueue_task_rt+0x3d/0xb0
>  [<ffffffff810679d6>] enqueue_task+0x5d/0x64
>  [<ffffffff810714fc>] task_setprio+0x210/0x29c              rq->lock
>  [<ffffffff810b56cb>] __rt_mutex_adjust_prio+0x25/0x2a      p->pi_lock
>  [<ffffffff810b5d2c>] task_blocks_on_rt_mutex+0x196/0x20f
> 
> Instead make __hrtimer_start_range_ns() return -ETIME when the timer
> is in the past. Since body actually uses the hrtimer_start*() return
> value its pretty safe to wreck it.
> 
> Also, it will only ever return -ETIME for timer->irqsafe || !wakeup
> timers.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> [bwh: Pull the changes to hrtimer_enqueue_reprogram() up into
>  __hrtimer_start_range_ns(), following changes in
>  commit b22affe0aef4 'hrtimer: Prevent hrtimer_enqueue_reprogram race'
>  backported into 3.2.40]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1023,37 +1023,31 @@ int __hrtimer_start_range_ns(struct hrti
>  	 */
>  	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
>  		&& hrtimer_enqueue_reprogram(timer, new_base)) {
> -#ifdef CONFIG_PREEMPT_RT_BASE
> -	again:

Never mind, I see you applied two patches.

>  		/*
>  		 * Move softirq based timers away from the rbtree in
>  		 * case it expired already. Otherwise we would have a
>  		 * stale base->first entry until the softirq runs.
>  		 */
> -		if (!hrtimer_rt_defer(timer)) {
> -			ktime_t now = ktime_get();
> -
> -			__run_hrtimer(timer, &now);
> -			/*
> -			 * __run_hrtimer might have requeued timer and
> -			 * it could be base->first again.
> -			 */
> -			if (&timer->node == new_base->active.next &&
> -			    hrtimer_enqueue_reprogram(timer, new_base))
> -				goto again;
> -		} else
> +		if (wakeup
> +#ifdef CONFIG_PREEMPT_RT_BASE
> +		    && hrtimer_rt_defer(timer)
>  #endif

This is very similar to what I came up with.

> -		if (wakeup) {
> -			/*
> -			 * We need to drop cpu_base->lock to avoid a
> -			 * lock ordering issue vs. rq->lock.
> -			 */
> +		    ) {
>  			raw_spin_unlock(&new_base->cpu_base->lock);
>  			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
>  			local_irq_restore(flags);
> -			return ret;
> +			return 0;
>  		} else {
> -			__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
> +			ret = -ETIME;
> +
> +			/*
> +			 * In case we failed to reprogram the timer (mostly
> +			 * because out current timer is already elapsed),
> +			 * remove it again and report a failure. This avoids
> +			 * stale base->first entries.
> +			 */
> +			__remove_hrtimer(timer, new_base,
> +					timer->state & HRTIMER_STATE_CALLBACK, 0);

Yep, looks like we are on the right track  :-)

>  		}
>  	}
>  
> ---
> 
> Note, the #ifdef in the second patch can't be removed, as the !RT
> definition of hrtimer_rt_defer() returns 0 whereas we want it to be true
> here.  (At least, that seems to match the logic of the previous version
> of the patch.)

Yep. That's what I'm waiting to hear too.

-- Steve



