Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaFVNg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 09:36:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:38572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaFVNg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 09:36:57 -0400
Date: Sun, 22 Jun 2014 15:36:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 4/5] hrtimer: Kick lowres dynticks targets on timer
 enqueue
In-Reply-To: <1403393357-2070-5-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.10.1406221533300.5170@nanos>
References: <1403393357-2070-1-git-send-email-fweisbec@gmail.com> <1403393357-2070-5-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2014, Frederic Weisbecker wrote:
> From: Viresh Kumar <viresh.kumar@linaro.org>
> 
> In lowres mode, hrtimers are serviced by the tick instead of a clock
> event. It works well as long as the tick stays periodic but we must also
> make sure that the hrtimers are serviced in dynticks mode targets,
> pretty much like timer list timers do.
> 
> Note that all dynticks modes are concerned: get_nohz_timer_target()
> tries not to return remote idle CPUs but there is nothing to prevent
> the elected target from entering dynticks idle mode until we lock its
> base. It's also prefectly legal to enqueue hrtimers on full dynticks CPU.
> 
> So there are two requirements to correctly handle dynticks:
> 
> 1) On target's tick stop time, we must not delay the next tick further
>    the next hrtimer.
> 
> 2) On hrtimer queue time. If the tick of the target is stopped, we must
>    wake up that CPU such that it sees the new hrtimer and recalculate
>    the next tick accordingly.
> 
> The point 1 is well handled currently through get_nohz_timer_interrupt() and
> cmp_next_hrtimer_event().
> 
> But the point 2 isn't handled at all.
> 
> Fixing this is easy though as we have the necessary API ready for that.
> All we need is to call wake_up_nohz_cpu() on a target when a newly
> enqueued hrtimer requires tick rescheduling, like timer list timer do.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/hrtimer.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 0e32d4e..5f30917 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1013,14 +1013,25 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
>  
>  	leftmost = enqueue_hrtimer(timer, new_base);
>  
> -	/*
> -	 * Only allow reprogramming if the new base is on this CPU.
> -	 * (it might still be on another CPU if the timer was pending)
> -	 *
> -	 * XXX send_remote_softirq() ?
> -	 */
> -	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
> -		&& hrtimer_enqueue_reprogram(timer, new_base)) {
> +	if (!leftmost) {
> +		unlock_hrtimer_base(timer, &flags);
> +		return ret;
> +	}
> +
> +	if (!hrtimer_is_hres_active(timer)) {
> +		/*
> +		 * Kick to reschedule the next tick to handle the new timer
> +		 * on dynticks target.
> +		 */
> +		wake_up_nohz_cpu(base->cpu_base->cpu);

The timer is queued on new_base not on base. 

Thanks,

	tglx
