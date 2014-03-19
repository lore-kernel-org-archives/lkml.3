Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaCSK7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:59:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:60529 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbaCSK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:59:04 -0400
Date: Wed, 19 Mar 2014 11:59:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimers: calculate expires_next after all timers are
 executed
In-Reply-To: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
Message-ID: <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014, Stanislav Fomichev wrote:

> I think I'm hitting particularly subtle issue with NOHZ_IDLE kernel.
> 
> The sequence is as follows:
> - CPU enters idle, we disable tick
> - hrtimer interrupt fires (for hrtimer_wakeup)
> - for clock base #1 (REALTIME) we wake up SCHED_RT thread and
>   start RT period timer (from start_rt_bandwidth) for clock base #0 (MONOTONIC)
> - because we already checked expiry time for clock base #0
>   we end up programming wrong wake up time (minutes, from tick_sched_timer)
> - then, we exit idle loop and restart tick;
>   but because tick_sched_timer is not leftmost (the leftmost one
>   is RT period timer) we don't program it
> 
> So in the end, I see working CPU without tick interrupt.
> This eventually leads to RCU stall on that CPU: rcu_gp_kthread
> is not woken up because there is no tick (this is the reason
> I started digging this up).

Nice analysis!
 
> The proposed fix runs expired timers first and only then tries to find
> next expiry time for all clocks.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  kernel/hrtimer.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 09094361dce5..63805f9f9531 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1282,6 +1282,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>   */
>  void hrtimer_interrupt(struct clock_event_device *dev)
>  {
> +	struct hrtimer_clock_base *base;
> +	struct timerqueue_node *node;
> +	struct hrtimer *timer;
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>  	ktime_t expires_next, now, entry_time, delta;
>  	int i, retries = 0;
> @@ -1304,8 +1307,6 @@ retry:
>  	cpu_base->expires_next.tv64 = KTIME_MAX;
>  
>  	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> -		struct hrtimer_clock_base *base;
> -		struct timerqueue_node *node;
>  		ktime_t basenow;
>  
>  		if (!(cpu_base->active_bases & (1 << i)))
> @@ -1315,8 +1316,6 @@ retry:
>  		basenow = ktime_add(now, base->offset);
>  
>  		while ((node = timerqueue_getnext(&base->active))) {
> -			struct hrtimer *timer;
> -
>  			timer = container_of(node, struct hrtimer, node);
>  
>  			/*
> @@ -1332,22 +1331,33 @@ retry:
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
> +	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> +		ktime_t expires;
> +
> +		if (!(cpu_base->active_bases & (1 << i)))
> +			continue;
> +
> +		base = cpu_base->clock_base + i;
> +
> +		node = timerqueue_getnext(&base->active);
> +		if (!node)
> +			continue;
> +
> +		timer = container_of(node, struct hrtimer, node);
> +		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> +		if (expires.tv64 < 0)
> +			expires.tv64 = KTIME_MAX;
> +		if (expires.tv64 < expires_next.tv64)
> +			expires_next = expires;

Actually we should store the expiry time of the first timer in a base
in the base itself. That needs to be done at enqueue time and

> +			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer))
>  				break;

here right before we break out of handling the base. When the last
timer of the base goes away, set the value to KTIME_MAX.

If we store it with the base offset already applied

   base->next = ktime_sub(hrtimer_get_expires(timer), base->offset); 

then the loop to find the next expiry in the interrupt becomes trivial
and fast.

Thanks,

	tglx
