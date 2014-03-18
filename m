Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaCRPoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:44:20 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47453 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCRPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:44:19 -0400
Date: Tue, 18 Mar 2014 16:44:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org
Subject: Re: [PATCH] timer: remove code redundancy while calling
 get_nohz_timer_target()
Message-ID: <20140318154412.GA769@localhost.localdomain>
References: <1e1b53537217d58d48c2d7a222a9c3ac47d5b64c.1395140107.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e1b53537217d58d48c2d7a222a9c3ac47d5b64c.1395140107.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 04:26:07PM +0530, Viresh Kumar wrote:
> There are only two users of get_nohz_timer_target(): timer and hrtimer. Both
> call it under same circumstances, i.e.
> 
> 	#ifdef CONFIG_NO_HZ_COMMON
> 	       if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
> 	               return get_nohz_timer_target();
> 	#endif
> 
> So, it makes more sense to get all this as part of get_nohz_timer_target()
> instead of duplicating code at two places. For this another parameter is
> required to be passed to this routine, pinned.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  include/linux/sched.h |  6 +++++-
>  kernel/hrtimer.c      | 15 +--------------
>  kernel/sched/core.c   |  5 ++++-
>  kernel/timer.c        |  7 +------
>  4 files changed, 11 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 6dbb9e5..9819f93 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -299,10 +299,14 @@ extern int runqueue_is_locked(int cpu);
>  #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
>  extern void nohz_balance_enter_idle(int cpu);
>  extern void set_cpu_sd_state_idle(void);
> -extern int get_nohz_timer_target(void);
> +extern int get_nohz_timer_target(int pinned);
>  #else
>  static inline void nohz_balance_enter_idle(int cpu) { }
>  static inline void set_cpu_sd_state_idle(void) { }
> +static inline int get_nohz_timer_target(int pinned)
> +{
> +	return smp_processor_id();
> +}
>  #endif
>  
>  /*
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index f60dce8..7eef615 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -168,19 +168,6 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
>  	}
>  }
>  
> -
> -/*
> - * Get the preferred target CPU for NOHZ
> - */
> -static int hrtimer_get_target(int this_cpu, int pinned)
> -{
> -#ifdef CONFIG_NO_HZ_COMMON
> -	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
> -		return get_nohz_timer_target();
> -#endif
> -	return this_cpu;
> -}
> -
>  /*
>   * With HIGHRES=y we do not migrate the timer when it is expiring
>   * before the next event on the target cpu because we cannot reprogram
> @@ -214,7 +201,7 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
>  	struct hrtimer_clock_base *new_base;
>  	struct hrtimer_cpu_base *new_cpu_base;
>  	int this_cpu = smp_processor_id();
> -	int cpu = hrtimer_get_target(this_cpu, pinned);
> +	int cpu = get_nohz_timer_target(pinned);
>  	int basenum = base->index;
>  
>  again:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 6fde755..a58e24d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -556,12 +556,15 @@ void resched_cpu(int cpu)
>   * selecting an idle cpu will add more delays to the timers than intended
>   * (as that cpu's timer base may not be uptodate wrt jiffies etc).
>   */
> -int get_nohz_timer_target(void)
> +int get_nohz_timer_target(int pinned)
>  {
>  	int cpu = smp_processor_id();
>  	int i;
>  	struct sched_domain *sd;
>  
> +	if (pinned || !get_sysctl_timer_migration() || !idle_cpu(cpu))
> +		return cpu;

Maybe the pinned part should stay a caller detail. Although I don't really mind.

The patch looks good!

Thanks.

> +
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
>  		for_each_cpu(i, sched_domain_span(sd)) {
> diff --git a/kernel/timer.c b/kernel/timer.c
> index e6868bf..2cf8616 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -760,12 +760,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
>  
>  	debug_activate(timer, expires);
>  
> -	cpu = smp_processor_id();
> -
> -#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
> -	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
> -		cpu = get_nohz_timer_target();
> -#endif
> +	cpu = get_nohz_timer_target(pinned);
>  	new_base = per_cpu(tvec_bases, cpu);
>  
>  	if (base != new_base) {
> -- 
> 1.7.12.rc2.18.g61b472e
> 
