Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3F1JE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:04:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3F1JE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:04:57 -0400
Date: Fri, 28 Jun 2013 11:04:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628090447.GD28407@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-6-git-send-email-mgorman@suse.de>
 <20130628081120.GE17195@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628081120.GE17195@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:41:20PM +0530, Srikar Dronamraju wrote:

Please trim your replies.

> > +/* Returns true if the destination node has incurred more faults */
> > +static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
> > +{
> > +	int src_nid, dst_nid;
> > +
> > +	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
> > +		return false;
> > +
> > +	src_nid = cpu_to_node(env->src_cpu);
> > +	dst_nid = cpu_to_node(env->dst_cpu);
> > +
> > +	if (src_nid == dst_nid)
> > +		return false;
> > +
> > +	if (p->numa_migrate_seq < sysctl_numa_balancing_settle_count &&
> 
> Lets say even if the numa_migrate_seq is greater than settle_count but running
> on a wrong node, then shouldnt this be taken as a good opportunity to 
> move the task?

I think that's what its doing; so this stmt says; if seq is large and
we're trying to move to the 'right' node; move it noaw.

> > +	    p->numa_preferred_nid == dst_nid)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +
> >  /*
> >   * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
> >   */
> > @@ -3945,10 +3977,14 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
> >  
> >  	/*
> >  	 * Aggressive migration if:
> > -	 * 1) task is cache cold, or
> > -	 * 2) too many balance attempts have failed.
> > +	 * 1) destination numa is preferred
> > +	 * 2) task is cache cold, or
> > +	 * 3) too many balance attempts have failed.
> >  	 */
> >  
> > +	if (migrate_improves_locality(p, env))
> > +		return 1;
> 
> Shouldnt this be under tsk_cache_hot check?
> 
> If the task is cache hot, then we would have to update the corresponding  schedstat
> metrics.

No; you want migrate_degrades_locality() to be like task_hot(). You want
to _always_ migrate tasks towards better locality irrespective of local
cache hotness.
