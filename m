Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3LQXw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:52:56 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48436 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LQXwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:52:54 -0500
Date: Tue, 17 Dec 2013 15:52:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 07/13] sched: Enable IPI reception on timekeeper under
 nohz full system
Message-ID: <20131217235248.GJ19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-8-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387320692-28460-8-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121723-7164-0000-0000-00000458A992
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 11:51:26PM +0100, Frederic Weisbecker wrote:
> We need the default timekeeping CPU to be able to receive IPIs sent
> from full dynticks CPUs when they wake up from full system idle state.
> 
> Therefore we need an entrypoint from the scheduler IPI so that the
> need to poll on timekeeping duty is re-evaluated from irq_exit().
> 
> In order to achieve this, lets take the scheduler IPI everytime as long
> as there is at least one full dynticks CPU around. Full dynticks CPUs
> are interested too in taking scheduler IPIs to reevaluate their tick.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Alex Shi <alex.shi@linaro.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/sched/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e85cda2..f46a7bc 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1502,9 +1502,9 @@ void scheduler_ipi(void)
>  	if (tif_need_resched())
>  		set_preempt_need_resched();
> 
> -	if (llist_empty(&this_rq()->wake_list)
> -			&& !tick_nohz_full_cpu(smp_processor_id())
> -			&& !got_nohz_idle_kick())
> +	if (llist_empty(&this_rq()->wake_list) &&
> +	    !tick_nohz_full_enabled() &&
> +	    !got_nohz_idle_kick())
>  		return;

OK, this is what I was missing in my question about whether the
NO_HZ_FULL state was re-evaluated in the interrupt-return path.

						Thanx, Paul

>  	/*
> -- 
> 1.8.3.1
> 

