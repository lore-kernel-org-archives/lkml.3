Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3F1KZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:25:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab3F1KZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:25:07 -0400
Date: Fri, 28 Jun 2013 12:24:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628102455.GE28407@twins.programming.kicks-ass.net>
References: <20130628090447.GD28407@twins.programming.kicks-ass.net>
 <20130628100723.GC8362@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628100723.GC8362@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 03:37:23PM +0530, Srikar Dronamraju wrote:
> > > > +
> > > > +
> > > >  /*
> > > >   * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
> > > >   */
> > > > @@ -3945,10 +3977,14 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
> > > >  
> > > >  	/*
> > > >  	 * Aggressive migration if:
> > > > -	 * 1) task is cache cold, or
> > > > -	 * 2) too many balance attempts have failed.
> > > > +	 * 1) destination numa is preferred
> > > > +	 * 2) task is cache cold, or
> > > > +	 * 3) too many balance attempts have failed.
> > > >  	 */
> > > >  
> > > > +	if (migrate_improves_locality(p, env))
> > > > +		return 1;
> > > 
> > > Shouldnt this be under tsk_cache_hot check?
> > > 
> > > If the task is cache hot, then we would have to update the corresponding  schedstat
> > > metrics.
> > 
> > No; you want migrate_degrades_locality() to be like task_hot(). You want
> > to _always_ migrate tasks towards better locality irrespective of local
> > cache hotness.
> > 
> 
> Yes, I understand that numa should have more priority over cache.
> But the schedstats will not be updated about whether the task was hot or
> cold.
> 
> So lets say the task was cache hot but numa wants it to move, then we
> should certainly move it but we should update the schedstats to mention that we
> moved a cache hot task.
> 
> Something akin to this.
> 
> 	tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
> 	if (tsk_cache_hot) {
> 		if (migrate_improves_locality(p, env) || 
> 		 	(env->sd->nr_balance_failed > env->sd->cache_nice_tries)) {
> #ifdef CONFIG_SCHEDSTATS
> 			schedstat_inc(env->sd, lb_hot_gained[env->idle]);
> 			schedstat_inc(p, se.statistics.nr_forced_migrations);
> #endif
> 			return 1;
> 		}
> 		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
> 		return 0;
> 	}
> 	return 1;

Ah right.. ok that might make sense.
