Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaLZXel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:34:41 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55531 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLZXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:34:37 -0500
Message-ID: <549DF089.5050201@codeaurora.org>
Date: Fri, 26 Dec 2014 15:34:33 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
CC: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers
 are executed
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru> <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de> <20140319141615.GB11081@stfomichev-desktop.yandex.net> <alpine.DEB.2.10.1406221417510.5170@nanos>
In-Reply-To: <alpine.DEB.2.10.1406221417510.5170@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2014 07:46 AM, Thomas Gleixner wrote:
>> +	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
>> +		ktime_t expires;
> So this adds the third incarnation of finding the next expiring timer
> to the code. Not really helpful.
>
> Untested patch which addresses the issues below.

We think we're running into the same issue that's fixed by this patch,
but the occurrence is very rare so reproducing is hard. Did this ever go
anywhere?

>
> -------------------->
>  include/linux/hrtimer.h |    2 
>  kernel/hrtimer.c        |  162 ++++++++++++++++++++++++++----------------------
>  2 files changed, 90 insertions(+), 74 deletions(-)
>
> Index: linux/include/linux/hrtimer.h
> ===================================================================
> --- linux.orig/include/linux/hrtimer.h
> +++ linux/include/linux/hrtimer.h
> @@ -141,6 +141,7 @@ struct hrtimer_sleeper {
>   * @get_time:		function to retrieve the current time of the clock
>   * @softirq_time:	the time when running the hrtimer queue in the softirq
>   * @offset:		offset of this clock to the monotonic base
> + * @expires_next:	absolute time of the next event on this clock base
>   */
>  struct hrtimer_clock_base {
>  	struct hrtimer_cpu_base	*cpu_base;
> @@ -151,6 +152,7 @@ struct hrtimer_clock_base {
>  	ktime_t			(*get_time)(void);
>  	ktime_t			softirq_time;
>  	ktime_t			offset;
> +	ktime_t			expires_next;
>  };
>  
>  enum  hrtimer_base_type {
> Index: linux/kernel/hrtimer.c
> ===================================================================
> --- linux.orig/kernel/hrtimer.c
> +++ linux/kernel/hrtimer.c
> @@ -494,6 +494,36 @@ static inline void debug_deactivate(stru
>  	trace_hrtimer_cancel(timer);
>  }
>  
> +/*
> + * Find the next expiring timer and return the expiry in absolute
> + * CLOCK_MONOTONIC time.
> + */
> +static ktime_t hrtimer_get_expires_next(struct hrtimer_cpu_base *cpu_base)
> +{
> +	ktime_t expires, expires_next = { .tv64 = KTIME_MAX };
> +	unsigned long idx, active = cpu_base->active_bases;
> +	struct hrtimer_clock_base *base;
> +
> +	while (active) {
> +		idx = __ffs(active);
> +		active &= ~(1UL << idx);
> +
> +		base = cpu_base->clock_base + idx;
> +		/* Adjust to CLOCK_MONOTONIC */
> +		expires = ktime_sub(base->expires_next, base->offset);
> +
> +		if (expires.tv64 < expires_next.tv64)
> +			expires_next = expires;
> +	}
> +	/*
> +	 * If clock_was_set() has changed base->offset the result
> +	 * might be negative. Fix it up to prevent a false positive in
> +	 * clockevents_program_event()
> +	 */
> +	expires.tv64 = 0;
> +	return expires_next.tv64 < 0 ? expires : expires_next;
> +}
> +
>  /* High resolution timer related functions */
>  #ifdef CONFIG_HIGH_RES_TIMERS
>  
> @@ -542,32 +572,7 @@ static inline int hrtimer_hres_active(vo
>  static void
>  hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
>  {
> -	int i;
> -	struct hrtimer_clock_base *base = cpu_base->clock_base;
> -	ktime_t expires, expires_next;
> -
> -	expires_next.tv64 = KTIME_MAX;
> -
> -	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
> -		struct hrtimer *timer;
> -		struct timerqueue_node *next;
> -
> -		next = timerqueue_getnext(&base->active);
> -		if (!next)
> -			continue;
> -		timer = container_of(next, struct hrtimer, node);
> -
> -		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> -		/*
> -		 * clock_was_set() has changed base->offset so the
> -		 * result might be negative. Fix it up to prevent a
> -		 * false positive in clockevents_program_event()
> -		 */
> -		if (expires.tv64 < 0)
> -			expires.tv64 = 0;
> -		if (expires.tv64 < expires_next.tv64)
> -			expires_next = expires;
> -	}
> +	ktime_t expires_next = hrtimer_get_expires_next(cpu_base);
>  
>  	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
>  		return;
> @@ -891,6 +896,8 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
>  static int enqueue_hrtimer(struct hrtimer *timer,
>  			   struct hrtimer_clock_base *base)
>  {
> +	int leftmost;
> +
>  	debug_activate(timer);
>  
>  	timerqueue_add(&base->active, &timer->node);
> @@ -902,7 +909,13 @@ static int enqueue_hrtimer(struct hrtime
>  	 */
>  	timer->state |= HRTIMER_STATE_ENQUEUED;
>  
> -	return (&timer->node == base->active.next);
> +	leftmost = &timer->node == base->active.next;
> +	/*
> +	 * If the new timer is the leftmost, update clock_base->expires_next.
> +	 */
> +	if (leftmost)
> +		base->expires_next = hrtimer_get_expires(timer);
> +	return leftmost;
>  }
>  
>  /*
> @@ -919,27 +932,45 @@ static void __remove_hrtimer(struct hrti
>  			     struct hrtimer_clock_base *base,
>  			     unsigned long newstate, int reprogram)
>  {
> -	struct timerqueue_node *next_timer;
> +	struct timerqueue_node *next;
> +	struct hrtimer *next_timer;
> +	bool first;
> +
>  	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
>  		goto out;
>  
> -	next_timer = timerqueue_getnext(&base->active);
> +	/*
> +	 * If this is not the first timer of the clock base, we just
> +	 * remove it. No updates, no reprogramming.
> +	 */
> +	first = timerqueue_getnext(&base->active) == &timer->node;
>  	timerqueue_del(&base->active, &timer->node);
> -	if (&timer->node == next_timer) {
> +	if (!first)
> +		goto out;
> +
> +	/*
> +	 * Update cpu base and clock base. This needs to be done
> +	 * before calling into hrtimer_force_reprogram() as that
> +	 * relies on active_bases and expires_next.
> +	 */
> +	next = timerqueue_getnext(&base->active);
> +	if (!next) {
> +		base->cpu_base->active_bases &= ~(1 << base->index);
> +		base->expires_next.tv64 = KTIME_MAX;
> +	} else {
> +		next_timer = container_of(next, struct hrtimer, node);
> +		base->expires_next = hrtimer_get_expires(next_timer);
> +	}
> +
>  #ifdef CONFIG_HIGH_RES_TIMERS
> -		/* Reprogram the clock event device. if enabled */
> -		if (reprogram && hrtimer_hres_active()) {
> -			ktime_t expires;
> -
> -			expires = ktime_sub(hrtimer_get_expires(timer),
> -					    base->offset);
> -			if (base->cpu_base->expires_next.tv64 == expires.tv64)
> -				hrtimer_force_reprogram(base->cpu_base, 1);
> -		}
> -#endif
> +	if (reprogram && hrtimer_hres_active()) {
> +		ktime_t expires;
> +
> +		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> +		if (base->cpu_base->expires_next.tv64 == expires.tv64)
> +			hrtimer_force_reprogram(base->cpu_base, 1);
>  	}
> -	if (!timerqueue_getnext(&base->active))
> -		base->cpu_base->active_bases &= ~(1 << base->index);
> +#endif
>  out:
>  	timer->state = newstate;
>  }
> @@ -1154,35 +1185,21 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
>  ktime_t hrtimer_get_next_event(void)
>  {
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
> -	struct hrtimer_clock_base *base = cpu_base->clock_base;
> -	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
> +	ktime_t next, delta = { .tv64 = KTIME_MAX };
>  	unsigned long flags;
> -	int i;
>  
>  	raw_spin_lock_irqsave(&cpu_base->lock, flags);
>  
>  	if (!hrtimer_hres_active()) {
> -		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
> -			struct hrtimer *timer;
> -			struct timerqueue_node *next;
> -
> -			next = timerqueue_getnext(&base->active);
> -			if (!next)
> -				continue;
> -
> -			timer = container_of(next, struct hrtimer, node);
> -			delta.tv64 = hrtimer_get_expires_tv64(timer);
> -			delta = ktime_sub(delta, base->get_time());
> -			if (delta.tv64 < mindelta.tv64)
> -				mindelta.tv64 = delta.tv64;
> -		}
> +		next = hrtimer_get_expires_next(cpu_base);
> +		delta = ktime_sub(next, ktime_get());
> +		if (delta.tv64 < 0)
> +			delta.tv64 = 0;
>  	}
>  
>  	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
>  
> -	if (mindelta.tv64 < 0)
> -		mindelta.tv64 = 0;
> -	return mindelta;
> +	return delta;
>  }
>  #endif
>  
> @@ -1292,6 +1309,7 @@ static void __run_hrtimer(struct hrtimer
>   */
>  void hrtimer_interrupt(struct clock_event_device *dev)
>  {
> +	struct hrtimer_clock_base *base;
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>  	ktime_t expires_next, now, entry_time, delta;
>  	int i, retries = 0;
> @@ -1303,7 +1321,6 @@ void hrtimer_interrupt(struct clock_even
>  	raw_spin_lock(&cpu_base->lock);
>  	entry_time = now = hrtimer_update_base(cpu_base);
>  retry:
> -	expires_next.tv64 = KTIME_MAX;
>  	/*
>  	 * We set expires_next to KTIME_MAX here with cpu_base->lock
>  	 * held to prevent that a timer is enqueued in our queue via
> @@ -1314,7 +1331,6 @@ retry:
>  	cpu_base->expires_next.tv64 = KTIME_MAX;
>  
>  	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> -		struct hrtimer_clock_base *base;
>  		struct timerqueue_node *node;
>  		ktime_t basenow;
>  
> @@ -1342,23 +1358,20 @@ retry:
>  			 * timer will have to trigger a wakeup anyway.
>  			 */
>  
> -			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
> -				ktime_t expires;
> -
> -				expires = ktime_sub(hrtimer_get_expires(timer),
> -						    base->offset);
> -				if (expires.tv64 < 0)
> -					expires.tv64 = KTIME_MAX;
> -				if (expires.tv64 < expires_next.tv64)
> -					expires_next = expires;
> +			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer))
>  				break;
> -			}
>  
>  			__run_hrtimer(timer, &basenow);
>  		}
>  	}
>  
>  	/*
> +	 * We might have dropped cpu_base->lock and the callbacks
> +	 * might have added timers. Find the timer which expires first.
> +	 */
> +	expires_next = hrtimer_get_expires_next(cpu_base);
> +
> +	/*
>  	 * Store the new expiry value so the migration code can verify
>  	 * against it.
>  	 */
> @@ -1678,6 +1691,7 @@ static void init_hrtimers_cpu(int cpu)
>  	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
>  		cpu_base->clock_base[i].cpu_base = cpu_base;
>  		timerqueue_init_head(&cpu_base->clock_base[i].active);
> +		cpu_base->clock_base[i].expires_next.tv64 = KTIME_MAX;
>  	}
>  
>  	hrtimer_init_hres(cpu_base);
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

