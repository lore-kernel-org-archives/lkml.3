Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbbA0OVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:21:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbbA0OVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:21:41 -0500
Date: Tue, 27 Jan 2015 15:21:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5/5] sched/rt: Optimize find_lowest_rq() to select a
 cache hot cpu
Message-ID: <20150127142136.GE21418@twins.programming.kicks-ass.net>
References: <1421642980-10045-1-git-send-email-pang.xunlei@linaro.org>
 <1421642980-10045-5-git-send-email-pang.xunlei@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421642980-10045-5-git-send-email-pang.xunlei@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 04:49:40AM +0000, Xunlei Pang wrote:
> In find_lowest_rq(), if we can't find a wake_affine cpu from
> sched_domain, then we can actually determine a cache hot cpu
> instead of simply calling "cpumask_any(lowest_mask)" which
> always returns the first cpu in the mask.
> 
> So, we can determine the cache hot cpu during the interation of
> sched_domain() in passing.

Steve, I'm not getting this. Why are we using WAKE_AFFINE here?



> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
> ---
>  kernel/sched/rt.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index d28cfa4..e6a42e6 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1535,6 +1535,7 @@ static int find_lowest_rq(struct task_struct *task)
>  	struct cpumask *lowest_mask = this_cpu_cpumask_var_ptr(local_cpu_mask);
>  	int this_cpu = smp_processor_id();
>  	int cpu      = task_cpu(task);
> +	int cachehot_cpu = nr_cpu_ids;
>  
>  	/* Make sure the mask is initialized first */
>  	if (unlikely(!lowest_mask))
> @@ -1566,8 +1567,12 @@ static int find_lowest_rq(struct task_struct *task)
>  
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
> +		if (cachehot_cpu >= nr_cpu_ids)
> +			cachehot_cpu = cpumask_first_and(lowest_mask,
> +						   sched_domain_span(sd));
> +
>  		if (sd->flags & SD_WAKE_AFFINE) {
> -			int best_cpu;
> +			int wakeaffine_cpu;
>  
>  			/*
>  			 * "this_cpu" is cheaper to preempt than a
> @@ -1579,16 +1584,20 @@ static int find_lowest_rq(struct task_struct *task)
>  				return this_cpu;
>  			}
>  
> -			best_cpu = cpumask_first_and(lowest_mask,
> +			wakeaffine_cpu = cpumask_first_and(lowest_mask,
>  						     sched_domain_span(sd));
> -			if (best_cpu < nr_cpu_ids) {
> +			if (wakeaffine_cpu < nr_cpu_ids) {
>  				rcu_read_unlock();
> -				return best_cpu;
> +				return wakeaffine_cpu;
>  			}
>  		}
>  	}
>  	rcu_read_unlock();
>  
> +	/* most likely cache-hot */
> +	if (cachehot_cpu < nr_cpu_ids)
> +		return cachehot_cpu;
> +
>  	/*
>  	 * And finally, if there were no matches within the domains
>  	 * just give the caller *something* to work with from the compatible
> -- 
> 1.9.1
> 
