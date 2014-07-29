Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaG2MMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:12:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaG2MMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:12:47 -0400
Date: Tue, 29 Jul 2014 14:12:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
Message-ID: <20140729121237.GY3935@laptop>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-8-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406569056-30217-8-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:37:33PM +0200, Frederic Weisbecker wrote:
> The timekeeper gets initialized to the value of the CPU where the
> first clockevent device is setup. This works well because the timekeeper
> can be any online CPU in most configs.
> 
> Full dynticks has its own requirement though and needs the timekeeper
> to always be 0. And this requirement seem to accomodate pretty well with
> the above described boot timekeeper setting because the first clockevent
> device happens to be initialized, most of the time, on the boot CPU
> (which should be CPU 0).

This isn't true in general, Voyager (which we dropped support for iirc)
had a boot cpu != 0, and I think there's ARM platforms where the same
can be true.

> However there is no mention of such a guarantee anywhere. This assumption
> might well be defeated on some corner case now or in the future.

Right..

> So lets wipe out the FUD and force tick_do_timer_cpu to CPU 0 on boot
> when full dynticks is used.
> 
> This way we can even remove some corner case code that handled scenarios
> where all clockevent devices were setup on full dynticks CPUs.

> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index 0a0608e..cb57bce 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -179,10 +179,10 @@ static void tick_setup_device(struct tick_device *td,
>  		 * this cpu:
>  		 */
>  		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
> -			if (!tick_nohz_full_cpu(cpu))
> -				tick_do_timer_cpu = cpu;
> +			if (tick_nohz_full_enabled())
> +				tick_do_timer_cpu = TICK_DO_TIMER_DEFAULT;
>  			else
> -				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
> +				tick_do_timer_cpu = cpu;
>  			tick_next_period = ktime_get();
>  			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
>  		}

So from what I can tell this code can get called before SMP setup, which
would mean we could get here before CPU0 is online?
