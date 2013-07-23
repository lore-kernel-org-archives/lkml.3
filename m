Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab3GWNxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237Ab3GWNxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:53:46 -0400
Date: Tue, 23 Jul 2013 09:53:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC -v3 2/2] watchdog: update watchdog_tresh properly
Message-ID: <20130723135334.GF126784@redhat.com>
References: <1374493502-31907-1-git-send-email-mhocko@suse.cz>
 <1374503566-2521-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374503566-2521-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 04:32:46PM +0200, Michal Hocko wrote:
> The nmi one is disabled and then reinitialized from scratch. This
> has an unpleasant side effect that the allocation of the new event might
> fail theoretically so the hard lockup detector would be disabled for
> such cpus. On the other hand such a memory allocation failure is very
> unlikely because the original event is deallocated right before.
> It would be much nicer if we just changed perf event period but there
> doesn't seem to be any API to do that right now.
> It is also unfortunate that perf_event_alloc uses GFP_KERNEL allocation
> unconditionally so we cannot use on_each_cpu() and do the same thing
> from the per-cpu context. The update from the current CPU should be
> safe because perf_event_disable removes the event atomically before
> it clears the per-cpu watchdog_ev so it cannot change anything under
> running handler feet.

I guess I don't have a problem with this.  I was hoping to have more
shared code with the regular stop/start routines but with the pmu bit
locking (to share pmus with oprofile), you really need to unregister
everything to stop the lockup detector.  This makes it a little too heavy
for a restart routine like this.

The only odd thing is I can't figure out which version you were using to
apply this patch.  I can't find old_thresh (though I understand the idea
of it).

Cheers,
Don

> 
> The hrtimer is simply restarted (thanks to Don Zickus who has pointed
> this out) if it is queued because we cannot rely it will fire&adopt
> to the new sampling period before a new nmi event triggers (when the
> treshold is decreased).
> 
> Changes since v1
> - restart hrtimer to ensure that hrtimer doesn't mess new nmi as pointed
>   out by Don Zickus
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  kernel/watchdog.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 2d64c02..eb4ebb5 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -486,7 +486,52 @@ static struct smp_hotplug_thread watchdog_threads = {
>  	.unpark			= watchdog_enable,
>  };
>  
> -static int watchdog_enable_all_cpus(void)
> +static void restart_watchdog_hrtimer(void *info)
> +{
> +	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
> +	int ret;
> +
> +	/*
> +	 * No need to cancel and restart hrtimer if it is currently executing
> +	 * because it will reprogram itself with the new period now.
> +	 * We should never see it unqueued here because we are running per-cpu
> +	 * with interrupts disabled.
> +	 */
> +	ret = hrtimer_try_to_cancel(hrtimer);
> +	if (ret == 1)
> +		hrtimer_start(hrtimer, ns_to_ktime(sample_period),
> +				HRTIMER_MODE_REL_PINNED);
> +}
> +
> +static void update_timers(int cpu)
> +{
> +	struct call_single_data data = {.func = restart_watchdog_hrtimer};
> +	/*
> +	 * Make sure that perf event counter will adopt to a new
> +	 * sampling period. Updating the sampling period directly would
> +	 * be much nicer but we do not have an API for that now so
> +	 * let's use a big hammer.
> +	 * Hrtimer will adopt the new period on the next tick but this
> +	 * might be late already so we have to restart the timer as well.
> +	 */
> +	watchdog_nmi_disable(cpu);
> +	__smp_call_function_single(cpu, &data, 1);
> +	watchdog_nmi_enable(cpu);
> +}
> +
> +static void update_timers_all_cpus(void)
> +{
> +	int cpu;
> +
> +	get_online_cpus();
> +	preempt_disable();
> +	for_each_online_cpu(cpu)
> +		update_timers(cpu);
> +	preempt_enable();
> +	put_online_cpus();
> +}
> +
> +static int watchdog_enable_all_cpus(bool sample_period_changed)
>  {
>  	int err = 0;
>  
> @@ -496,6 +541,8 @@ static int watchdog_enable_all_cpus(void)
>  			pr_err("Failed to create watchdog threads, disabled\n");
>  		else
>  			watchdog_running = 1;
> +	} else if (sample_period_changed) {
> +		update_timers_all_cpus();
>  	}
>  
>  	return err;
> @@ -537,7 +584,7 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>  	 * watchdog_*_all_cpus() function takes care of this.
>  	 */
>  	if (watchdog_user_enabled && watchdog_thresh)
> -		err = watchdog_enable_all_cpus();
> +		err = watchdog_enable_all_cpus(old_thresh != watchdog_thresh);
>  	else
>  		watchdog_disable_all_cpus();
>  
> @@ -565,5 +612,5 @@ void __init lockup_detector_init(void)
>  #endif
>  
>  	if (watchdog_user_enabled)
> -		watchdog_enable_all_cpus();
> +		watchdog_enable_all_cpus(false);
>  }
> -- 
> 1.8.3.2
> 
