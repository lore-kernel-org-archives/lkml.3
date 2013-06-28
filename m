Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3F1NCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:02:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3F1NCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:02:16 -0400
Date: Fri, 28 Jun 2013 14:01:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130628130159.GW1875@suse.de>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-6-git-send-email-mgorman@suse.de>
 <20130627160127.GY28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130627160127.GY28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 06:01:27PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 26, 2013 at 03:38:04PM +0100, Mel Gorman wrote:
> > @@ -3897,6 +3907,28 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
> >  	return delta < (s64)sysctl_sched_migration_cost;
> >  }
> >  
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
> > +	    p->numa_preferred_nid == dst_nid)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> 
> This references ->numa_faults, which is declared under NUMA_BALANCING
> but lacks any such conditionality here.

Fixed.

-- 
Mel Gorman
SUSE Labs
