Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaFDPxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:53:05 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:41087 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbaFDPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:53:03 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 11:53:03 EDT
X-Yandex-Uniq: 604b5804-69d3-41b5-ac89-2adcb95d532f
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Wed, 4 Jun 2014 19:47:45 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john.stultz@linaro.org, prarit@redhat.com, paul.gortmaker@windriver.com,
        juri.lelli@gmail.com, ddaney.cavm@gmail.com, mbohan@codeaurora.org,
        david.vrabel@citrix.com, david.engraf@sysgo.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are
 executed
Message-ID: <20140604154745.GE26511@stfomichev-desktop.yandex.net>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de>
 <20140319141615.GB11081@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319141615.GB11081@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, any estimate on when you'll be able to review this patch?
It's been almost 3 months since is sent it. Is there any particular
reason you don't want to pull it (because on my machines it's
been working fine without any issues)?

On Wed, Mar 19, 2014 at 06:16:15PM +0400, Stanislav Fomichev wrote:
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
> 
> The proposed fix runs expired timers first and only then tries to find
> next expiry time for all clocks.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  include/linux/hrtimer.h |  2 ++
>  kernel/hrtimer.c        | 41 +++++++++++++++++++++++++++++++----------
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index d19a5c2d2270..520a671f90ee 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -141,6 +141,7 @@ struct hrtimer_sleeper {
>   * @get_time:		function to retrieve the current time of the clock
>   * @softirq_time:	the time when running the hrtimer queue in the softirq
>   * @offset:		offset of this clock to the monotonic base
> + * @next:		time of the next event on this clock base
>   */
>  struct hrtimer_clock_base {
>  	struct hrtimer_cpu_base	*cpu_base;
> @@ -151,6 +152,7 @@ struct hrtimer_clock_base {
>  	ktime_t			(*get_time)(void);
>  	ktime_t			softirq_time;
>  	ktime_t			offset;
> +	ktime_t			next;
>  };
>  
>  enum  hrtimer_base_type {
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 09094361dce5..d284411e6dad 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -882,6 +882,8 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
>  static int enqueue_hrtimer(struct hrtimer *timer,
>  			   struct hrtimer_clock_base *base)
>  {
> +	ktime_t expires;
> +
>  	debug_activate(timer);
>  
>  	timerqueue_add(&base->active, &timer->node);
> @@ -893,6 +895,10 @@ static int enqueue_hrtimer(struct hrtimer *timer,
>  	 */
>  	timer->state |= HRTIMER_STATE_ENQUEUED;
>  
> +	expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
> +	if (ktime_compare(base->next, expires) > 0)
> +		base->next = expires;
> +
>  	return (&timer->node == base->active.next);
>  }
>  
> @@ -929,8 +935,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
>  		}
>  #endif
>  	}
> -	if (!timerqueue_getnext(&base->active))
> +	if (!timerqueue_getnext(&base->active)) {
>  		base->cpu_base->active_bases &= ~(1 << base->index);
> +		base->next = ktime_set(KTIME_SEC_MAX, 0);
> +	}
>  out:
>  	timer->state = newstate;
>  }
> @@ -1282,6 +1290,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>   */
>  void hrtimer_interrupt(struct clock_event_device *dev)
>  {
> +	struct hrtimer_clock_base *base;
>  	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>  	ktime_t expires_next, now, entry_time, delta;
>  	int i, retries = 0;
> @@ -1304,7 +1313,6 @@ retry:
>  	cpu_base->expires_next.tv64 = KTIME_MAX;
>  
>  	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> -		struct hrtimer_clock_base *base;
>  		struct timerqueue_node *node;
>  		ktime_t basenow;
>  
> @@ -1333,14 +1341,8 @@ retry:
>  			 */
>  
>  			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
> -				ktime_t expires;
> -
> -				expires = ktime_sub(hrtimer_get_expires(timer),
> -						    base->offset);
> -				if (expires.tv64 < 0)
> -					expires.tv64 = KTIME_MAX;
> -				if (expires.tv64 < expires_next.tv64)
> -					expires_next = expires;
> +				base->next = ktime_sub(hrtimer_get_expires(timer),
> +						       base->offset);
>  				break;
>  			}
>  
> @@ -1349,6 +1351,25 @@ retry:
>  	}
>  
>  	/*
> +	 * Because timer handler may add new timer on a different clock base,
> +	 * we need to find next expiry only after we execute all timers.
> +	 */
> +	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
> +		ktime_t expires;
> +
> +		if (!(cpu_base->active_bases & (1 << i)))
> +			continue;
> +
> +		base = cpu_base->clock_base + i;
> +		expires = base->next;
> +
> +		if (expires.tv64 < 0)
> +			expires.tv64 = KTIME_MAX;
> +		if (expires.tv64 < expires_next.tv64)
> +			expires_next = expires;
> +	}
> +
> +	/*
>  	 * Store the new expiry value so the migration code can verify
>  	 * against it.
>  	 */
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
