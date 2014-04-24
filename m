Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaDXHPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:15:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDXHPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:15:54 -0400
Date: Thu, 24 Apr 2014 09:15:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
Message-ID: <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398303035-18255-4-git-send-email-jason.low2@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 06:30:35PM -0700, Jason Low wrote:
> It was found that when running some workloads (such as AIM7) on large systems
> with many cores, CPUs do not remain idle for long. Thus, tasks can
> wake/get enqueued while doing idle balancing.
> 
> In this patch, while traversing the domains in idle balance, in addition to
> checking for pulled_task, we add an extra check for this_rq->nr_running for
> determining if we should stop searching for tasks to pull. If there are
> runnable tasks on this rq, then we will stop traversing the domains. This
> reduces the chance that idle balance delays a task from running.
> 
> This patch resulted in approximately a 6% performance improvement when
> running a Java Server workload on an 8 socket machine.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/sched/fair.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3e3ffb8..232518c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6689,7 +6689,6 @@ static int idle_balance(struct rq *this_rq)
>  		if (sd->flags & SD_BALANCE_NEWIDLE) {
>  			t0 = sched_clock_cpu(this_cpu);
>  
> -			/* If we've pulled tasks over stop searching: */
>  			pulled_task = load_balance(this_cpu, this_rq,
>  						   sd, CPU_NEWLY_IDLE,
>  						   &continue_balancing);
> @@ -6704,7 +6703,12 @@ static int idle_balance(struct rq *this_rq)
>  		interval = msecs_to_jiffies(sd->balance_interval);
>  		if (time_after(next_balance, sd->last_balance + interval))
>  			next_balance = sd->last_balance + interval;
> -		if (pulled_task)
> +
> +		/*
> +		 * Stop searching for tasks to pull if there are
> +		 * now runnable tasks on this rq.
> +		 */
> +		if (pulled_task || this_rq->nr_running > 0)
>  			break;
>  	}
>  	rcu_read_unlock();

There's also the CONFIG_PREEMPT bit in move_tasks() does making that
unconditional also help such a workload?
