Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaBRUT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:19:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:45554 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaBRUT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:19:56 -0500
Date: Tue, 18 Feb 2014 21:20:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH] sched_clock: Prevent callers from seeing half-updated
 data
In-Reply-To: <1392662736-7803-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.02.1402182119500.4468@ionos.tec.linutronix.de>
References: <1392662736-7803-1-git-send-email-john.stultz@linaro.org> <1392662736-7803-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, John Stultz wrote:

> From: Stephen Boyd <sboyd@codeaurora.org>
> 
> The generic sched_clock registration function was previously
> done lockless, due to the fact that it was expected to be called
> only once. However, now there are systems that may register
> multiple sched_clock sources, for which the lack of locking has
> casued problems:
> 
> If two sched_clock sources are registered we may end up in a
> situation where a call to sched_clock() may be accessing the
> epoch cycle count for the old counter and the cycle count for the
> new counter. This can lead to confusing results where
> sched_clock() values jump and then are reset to 0 (due to the way
> the registration function forces the epoch_ns to be 0).
> 
> Fix this by reorganizing the registration function to hold the
> seqlock for as short a time as possible while we update the
> clock_data structure for a new counter. We also put any
> accumulated time into epoch_ns instead of resetting the time to
> 0 so that the clock doesn't reset after each successful
> registration.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>

Peter ???

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Josh Cartwright <joshc@codeaurora.org>
> Reported-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> [jstultz: Added extra context to the commit message]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/sched_clock.c | 46 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> index 0abb364..4d23dc4 100644
> --- a/kernel/time/sched_clock.c
> +++ b/kernel/time/sched_clock.c
> @@ -116,20 +116,42 @@ static enum hrtimer_restart sched_clock_poll(struct hrtimer *hrt)
>  void __init sched_clock_register(u64 (*read)(void), int bits,
>  				 unsigned long rate)
>  {
> +	u64 res, wrap, new_mask, new_epoch, cyc, ns;
> +	u32 new_mult, new_shift;
> +	ktime_t new_wrap_kt;
>  	unsigned long r;
> -	u64 res, wrap;
>  	char r_unit;
>  
>  	if (cd.rate > rate)
>  		return;
>  
>  	WARN_ON(!irqs_disabled());
> -	read_sched_clock = read;
> -	sched_clock_mask = CLOCKSOURCE_MASK(bits);
> -	cd.rate = rate;
>  
>  	/* calculate the mult/shift to convert counter ticks to ns. */
> -	clocks_calc_mult_shift(&cd.mult, &cd.shift, rate, NSEC_PER_SEC, 3600);
> +	clocks_calc_mult_shift(&new_mult, &new_shift, rate, NSEC_PER_SEC, 3600);
> +
> +	new_mask = CLOCKSOURCE_MASK(bits);
> +
> +	/* calculate how many ns until we wrap */
> +	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
> +	new_wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
> +
> +	/* update epoch for new counter and update epoch_ns from old counter*/
> +	new_epoch = read();
> +	cyc = read_sched_clock();
> +	ns = cd.epoch_ns + cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
> +			  cd.mult, cd.shift);
> +
> +	raw_write_seqcount_begin(&cd.seq);
> +	read_sched_clock = read;
> +	sched_clock_mask = new_mask;
> +	cd.rate = rate;
> +	cd.wrap_kt = new_wrap_kt;
> +	cd.mult = new_mult;
> +	cd.shift = new_shift;
> +	cd.epoch_cyc = new_epoch;
> +	cd.epoch_ns = ns;
> +	raw_write_seqcount_end(&cd.seq);
>  
>  	r = rate;
>  	if (r >= 4000000) {
> @@ -141,22 +163,12 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
>  	} else
>  		r_unit = ' ';
>  
> -	/* calculate how many ns until we wrap */
> -	wrap = clocks_calc_max_nsecs(cd.mult, cd.shift, 0, sched_clock_mask);
> -	cd.wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
> -
>  	/* calculate the ns resolution of this counter */
> -	res = cyc_to_ns(1ULL, cd.mult, cd.shift);
> +	res = cyc_to_ns(1ULL, new_mult, new_shift);
> +
>  	pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns, wraps every %lluns\n",
>  		bits, r, r_unit, res, wrap);
>  
> -	update_sched_clock();
> -
> -	/*
> -	 * Ensure that sched_clock() starts off at 0ns
> -	 */
> -	cd.epoch_ns = 0;
> -
>  	/* Enable IRQ time accounting if we have a fast enough sched_clock */
>  	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
>  		enable_sched_clock_irqtime();
> -- 
> 1.8.3.2
> 
> 
