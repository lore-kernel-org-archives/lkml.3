Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3F1Rpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:45:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59047 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab3F1Rpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:45:34 -0400
Date: Fri, 28 Jun 2013 23:14:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628174445.GP8362@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130628090447.GD28407@twins.programming.kicks-ass.net>
 <20130628100723.GC8362@linux.vnet.ibm.com>
 <20130628135114.GY1875@suse.de>
 <20130628171427.GO8362@linux.vnet.ibm.com>
 <20130628173407.GC1875@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130628173407.GC1875@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13062817-5806-0000-0000-000021EB7914
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 
> > > -	if (migrate_improves_locality(p, env))
> > > +	if (migrate_improves_locality(p, env)) {
> > > +#ifdef CONFIG_SCHEDSTATS
> > > +		schedstat_inc(env->sd, lb_hot_gained[env->idle]);
> > > +		schedstat_inc(p, se.statistics.nr_forced_migrations);
> > > +#endif
> > >  		return 1;
> > > +	}
> > > 
> > 
> > In this case, we account even cache cold threads as _cache hot_ in
> > schedstats.
> > 
> > We need the task_hot() call to determine if task is cache hot or not.
> > So the migrate_improves_locality(), I think should be called within the
> > tsk_cache_hot check.
> > 
> > Do you have issues with the above snippet that I posted earlier?
> > 
> 
> The migrate_improves_locality call had already happened so it cannot be
> true after the tsk_cache_hot check is made so I was confused. If the call is
> moved within task cache hot then it changes the intent of the patch because

Yes,  I was suggesting moving it inside.

> cache hotness then trumps memory locality which is not intended. Memory
> locality is expected to trump cache hotness.
> 

But whether the memory locality trumps or the cache hotness, the result
would still be the same but a little concise code.

> How about this?
> 
>         tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
> 
>         if (migrate_improves_locality(p, env)) {
> #ifdef CONFIG_SCHEDSTATS
>                 if (tsk_cache_hot) {
>                         schedstat_inc(env->sd, lb_hot_gained[env->idle]);
>                         schedstat_inc(p, se.statistics.nr_forced_migrations);
>                 }
> #endif
>                 return 1;
>         }
> 
>         if (!tsk_cache_hot ||
>                 env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
> #ifdef CONFIG_SCHEDSTATS
>                 if (tsk_cache_hot) {
>                         schedstat_inc(env->sd, lb_hot_gained[env->idle]);
>                         schedstat_inc(p, se.statistics.nr_forced_migrations);
>                 }
> #endif
>                 return 1;
>         }

Yes, this looks fine to me.
> 

-- 
Thanks and Regards
Srikar Dronamraju

