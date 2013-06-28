Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3F1ROr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:14:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45171 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3F1ROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:14:45 -0400
Date: Fri, 28 Jun 2013 22:44:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628171427.GO8362@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130628090447.GD28407@twins.programming.kicks-ass.net>
 <20130628100723.GC8362@linux.vnet.ibm.com>
 <20130628135114.GY1875@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130628135114.GY1875@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062817-7282-0000-0000-000018C435ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yes, I understand that numa should have more priority over cache.
> > But the schedstats will not be updated about whether the task was hot or
> > cold.
> > 
> > So lets say the task was cache hot but numa wants it to move, then we
> > should certainly move it but we should update the schedstats to mention that we
> > moved a cache hot task.
> > 
> > Something akin to this.
> > 
> > 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
> > 	if (tsk_cache_hot) {
> > 		if (migrate_improves_locality(p, env) || 
> > 		 	(env->sd->nr_balance_failed > env->sd->cache_nice_tries)) {
> > #ifdef CONFIG_SCHEDSTATS
> > 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
> > 			schedstat_inc(p, se.statistics.nr_forced_migrations);
> > #endif
> > 			return 1;
> > 		}
> > 		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
> > 		return 0;
> > 	}
> > 	return 1;
> > 
> 
> Thanks. Is this acceptable?
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b3848e0..c3a153e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4088,8 +4088,13 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
>  	 * 3) too many balance attempts have failed.
>  	 */
> 
> -	if (migrate_improves_locality(p, env))
> +	if (migrate_improves_locality(p, env)) {
> +#ifdef CONFIG_SCHEDSTATS
> +		schedstat_inc(env->sd, lb_hot_gained[env->idle]);
> +		schedstat_inc(p, se.statistics.nr_forced_migrations);
> +#endif
>  		return 1;
> +	}
> 

In this case, we account even cache cold threads as _cache hot_ in
schedstats.

We need the task_hot() call to determine if task is cache hot or not.
So the migrate_improves_locality(), I think should be called within the
tsk_cache_hot check.

Do you have issues with the above snippet that I posted earlier?

>  	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
>  	if (!tsk_cache_hot)
> 
> -- 
> Mel Gorman
> SUSE Labs
> 

-- 
Thanks and Regards
Srikar Dronamraju

