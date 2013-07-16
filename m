Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3GPIXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:23:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3GPIXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:23:49 -0400
Date: Tue, 16 Jul 2013 09:23:42 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] sched: Avoid overloading CPUs on a preferred NUMA
 node
Message-ID: <20130716082342.GF5055@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-17-git-send-email-mgorman@suse.de>
 <20130715200321.GN17211@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130715200321.GN17211@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:03:21PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 15, 2013 at 04:20:18PM +0100, Mel Gorman wrote:
> > ---
> >  kernel/sched/fair.c | 105 +++++++++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 83 insertions(+), 22 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 3f0519c..8ee1c8e 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -846,29 +846,92 @@ static inline int task_faults_idx(int nid, int priv)
> >  	return 2 * nid + priv;
> >  }
> >  
> > -static unsigned long weighted_cpuload(const int cpu);
> > +static unsigned long source_load(int cpu, int type);
> > +static unsigned long target_load(int cpu, int type);
> > +static unsigned long power_of(int cpu);
> > +static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
> > +
> > +static int task_numa_find_cpu(struct task_struct *p, int nid)
> > +{
> > +	int node_cpu = cpumask_first(cpumask_of_node(nid));
> > +	int cpu, src_cpu = task_cpu(p), dst_cpu = src_cpu;
> > +	unsigned long src_load, dst_load;
> > +	unsigned long min_load = ULONG_MAX;
> > +	struct task_group *tg = task_group(p);
> > +	s64 src_eff_load, dst_eff_load;
> > +	struct sched_domain *sd;
> > +	unsigned long weight;
> > +	bool balanced;
> > +	int imbalance_pct, idx = -1;
> >  
> > +	/* No harm being optimistic */
> > +	if (idle_cpu(node_cpu))
> > +		return node_cpu;
> >  
> > +	/*
> > +	 * Find the lowest common scheduling domain covering the nodes of both
> > +	 * the CPU the task is currently running on and the target NUMA node.
> > +	 */
> > +	rcu_read_lock();
> > +	for_each_domain(src_cpu, sd) {
> > +		if (cpumask_test_cpu(node_cpu, sched_domain_span(sd))) {
> > +			/*
> > +			 * busy_idx is used for the load decision as it is the
> > +			 * same index used by the regular load balancer for an
> > +			 * active cpu.
> > +			 */
> > +			idx = sd->busy_idx;
> > +			imbalance_pct = sd->imbalance_pct;
> > +			break;
> > +		}
> > +	}
> > +	rcu_read_unlock();
> >  
> > +	if (WARN_ON_ONCE(idx == -1))
> > +		return src_cpu;
> >  
> > +	/*
> > +	 * XXX the below is mostly nicked from wake_affine(); we should
> > +	 * see about sharing a bit if at all possible; also it might want
> > +	 * some per entity weight love.
> > +	 */
> > +	weight = p->se.load.weight;
> >  
> > +	src_load = source_load(src_cpu, idx);
> > +
> > +	src_eff_load = 100 + (imbalance_pct - 100) / 2;
> > +	src_eff_load *= power_of(src_cpu);
> > +	src_eff_load *= src_load + effective_load(tg, src_cpu, -weight, -weight);
> 
> So did you try with this effective_load() term 'missing'?
> 

Yes, it performed worse in tests. Looking at it, I figured that it would
have to perform worse unless effective_load regularly returns negative
values.

-- 
Mel Gorman
SUSE Labs
