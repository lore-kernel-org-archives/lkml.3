Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab3GVRer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:34:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58351 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab3GVRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:34:45 -0400
Date: Mon, 22 Jul 2013 12:31:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
Message-ID: <20130722070144.GC5138@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1374220211.5447.9.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1374220211.5447.9.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072207-7606-0000-0000-00000D8A8104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e8b3350..da2cb3e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1348,6 +1348,8 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  		else
>  			update_avg(&rq->avg_idle, delta);
>  		rq->idle_stamp = 0;
> +
> +		rq->idle_duration = (rq->idle_duration + delta) / 2;

Cant we just use avg_idle instead of introducing idle_duration?

>  	}
>  #endif
>  }
> @@ -7027,6 +7029,7 @@ void __init sched_init(void)
>  		rq->online = 0;
>  		rq->idle_stamp = 0;
>  		rq->avg_idle = 2*sysctl_sched_migration_cost;
> +		rq->idle_duration = 0;
> 
>  		INIT_LIST_HEAD(&rq->cfs_tasks);
> 
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 75024a6..a3f062c 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -307,6 +307,7 @@ do {									\
>  	P(sched_goidle);
>  #ifdef CONFIG_SMP
>  	P64(avg_idle);
> +	P64(idle_duration);
>  #endif
> 
>  	P(ttwu_count);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c61a614..da7ddd6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5240,6 +5240,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	struct sched_domain *sd;
>  	int pulled_task = 0;
>  	unsigned long next_balance = jiffies + HZ;
> +	u64 cost = 0;
> +	u64 idle_duration = this_rq->idle_duration;
> 
>  	this_rq->idle_stamp = this_rq->clock;
> 
> @@ -5256,14 +5258,31 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	for_each_domain(this_cpu, sd) {
>  		unsigned long interval;
>  		int balance = 1;
> +		u64 this_domain_balance_cost = 0;
> +		u64 start_time;
> 
>  		if (!(sd->flags & SD_LOAD_BALANCE))
>  			continue;
> 
> +		/*
> +		 * If the time which this_cpu remains is not lot higher than the cost
> +		 * of attempt idle balancing within this domain, then stop searching.
> +		 */
> +		if (idle_duration / 10 < (sd->avg_idle_balance_cost + cost))
> +			break;
> +
>  		if (sd->flags & SD_BALANCE_NEWIDLE) {
> +			start_time = sched_clock_cpu(smp_processor_id());
> +
>  			/* If we've pulled tasks over stop searching: */
>  			pulled_task = load_balance(this_cpu, this_rq,
>  						   sd, CPU_NEWLY_IDLE, &balance);
> +
> +			this_domain_balance_cost = sched_clock_cpu(smp_processor_id()) - start_time;

Should we take the consideration of whether a idle_balance was
successful or not?

How about having a per-sched_domain counter. 
For every nth unsuccessful load balance, skip the n+1th idle
balance and reset the counter. Also reset the counter on every
successful idle load balance.

I am not sure whats a reasonable value for n can be, but may be we could
try with n=3.

Also have we checked the performance after adjusting the
sched_migration_cost tunable?

I guess, if we increase the sched_migration_cost, we should have lesser
newly idle balance requests. 

-- 
Thanks and Regards
Srikar Dronamraju

