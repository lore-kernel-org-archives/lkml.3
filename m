Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaG3COb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:14:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:59398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbaG3CO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 22:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,761,1400050800"; 
   d="scan'208";a="551025793"
Date: Wed, 30 Jul 2014 10:14:25 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140730021425.GA25023@aaronlu.sh.intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140729081712.GS20603@laptop.programming.kicks-ass.net>
 <20140729160437.4561742f@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729160437.4561742f@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 04:04:37PM -0400, Rik van Riel wrote:
> On Tue, 29 Jul 2014 10:17:12 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > +#define NUMA_SCALE 1000
> > > +#define NUMA_MOVE_THRESH 50
> > 
> > Please make that 1024, there's no reason not to use power of two here.
> > This base 10 factor thing annoyed me no end already, its time for it to
> > die.
> 
> That's easy enough.  However, it would be good to know whether
> this actually helps with the regression Aaron found :)

Sorry for the delay.

I applied the last patch and queued the hackbench job to the ivb42 test
machine for it to run 5 times, and here is the result(regarding the
proc-vmstat.numa_hint_faults_local field):
173565
201262
192317
198342
198595
avg:
192816

It seems it is still very big than previous kernels.

BTW, to highlight changes, we only include metrics that have changed a
lot in the report, which means, for metrics that don't show in the
report, it means it doesn't change much. But just in case, here is the
throughput metric regarding commit a43455a1d(compared to its parent):

ebe06187bf2aec1   a43455a1d572daf7b730fe12e  
---------------   -------------------------  
118881 ~ 0%            +1.2%    120325 ~ 0% ivb42/hackbench/50%-threads-pipe
 78410 ~ 0%            +0.6%     78857 ~ 0% lkp-snb01/hackbench/50%-threads-socket
197292 ~ 0%            +1.0%    199182 ~ 0% TOTAL hackbench.throughput

Feel free to let me know if you need more information.

Thanks,
Aaron

> 
> ---8<---
> 
> Subject: sched,numa: prevent task moves with marginal benefit
> 
> Commit a43455a1d57 makes task_numa_migrate() always check the
> preferred node for task placement. This is causing a performance
> regression with hackbench, as well as SPECjbb2005.
> 
> Tracing task_numa_compare() with a single instance of SPECjbb2005
> on a 4 node system, I have seen several thread swaps with tiny
> improvements. 
> 
> It appears that the hysteresis code that was added to task_numa_compare
> is not doing what we needed it to do, and a simple threshold could be
> better.
> 
> Aaron, does this patch help, or am I barking up the wrong tree?
> 
> Reported-by: Aaron Lu <aaron.lu@intel.com>
> Reported-by: Jirka Hladky <jhladky@redhat.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4f5e3c2..9bd283b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -924,10 +924,12 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
>  
>  /*
>   * These return the fraction of accesses done by a particular task, or
> - * task group, on a particular numa node.  The group weight is given a
> - * larger multiplier, in order to group tasks together that are almost
> - * evenly spread out between numa nodes.
> + * task group, on a particular numa node.  The NUMA move threshold
> + * prevents task moves with marginal improvement, and is set to 5%.
>   */
> +#define NUMA_SCALE 1024
> +#define NUMA_MOVE_THRESH (5 * NUMA_SCALE / 100)
> +
>  static inline unsigned long task_weight(struct task_struct *p, int nid)
>  {
>  	unsigned long total_faults;
> @@ -940,7 +942,7 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
>  	if (!total_faults)
>  		return 0;
>  
> -	return 1000 * task_faults(p, nid) / total_faults;
> +	return NUMA_SCALE * task_faults(p, nid) / total_faults;
>  }
>  
>  static inline unsigned long group_weight(struct task_struct *p, int nid)
> @@ -948,7 +950,7 @@ static inline unsigned long group_weight(struct task_struct *p, int nid)
>  	if (!p->numa_group || !p->numa_group->total_faults)
>  		return 0;
>  
> -	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
> +	return NUMA_SCALE * group_faults(p, nid) / p->numa_group->total_faults;
>  }
>  
>  bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
> @@ -1181,11 +1183,11 @@ static void task_numa_compare(struct task_numa_env *env,
>  			imp = taskimp + task_weight(cur, env->src_nid) -
>  			      task_weight(cur, env->dst_nid);
>  			/*
> -			 * Add some hysteresis to prevent swapping the
> -			 * tasks within a group over tiny differences.
> +			 * Do not swap tasks within a group around unless
> +			 * there is a significant improvement.
>  			 */
> -			if (cur->numa_group)
> -				imp -= imp/16;
> +			if (cur->numa_group && imp < NUMA_MOVE_THRESH)
> +				goto unlock;
>  		} else {
>  			/*
>  			 * Compare the group weights. If a task is all by
> @@ -1205,6 +1207,10 @@ static void task_numa_compare(struct task_numa_env *env,
>  		goto unlock;
>  
>  	if (!cur) {
> +		/* Only move if there is a significant improvement. */
> +		if (imp < NUMA_MOVE_THRESH)
> +			goto unlock;
> +
>  		/* Is there capacity at our destination? */
>  		if (env->src_stats.has_free_capacity &&
>  		    !env->dst_stats.has_free_capacity)
> 
