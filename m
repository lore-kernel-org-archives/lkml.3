Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3GHIfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:35:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab3GHIfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:35:05 -0400
Date: Mon, 8 Jul 2013 09:34:57 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/15] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130708083457.GY1875@suse.de>
References: <1373065742-9753-1-git-send-email-mgorman@suse.de>
 <1373065742-9753-7-git-send-email-mgorman@suse.de>
 <20130706103813.GQ18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130706103813.GQ18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:38:13PM +0200, Peter Zijlstra wrote:
> On Sat, Jul 06, 2013 at 12:08:53AM +0100, Mel Gorman wrote:
> > +static int
> > +find_idlest_cpu_node(int this_cpu, int nid)
> > +{
> > +	unsigned long load, min_load = ULONG_MAX;
> > +	int i, idlest_cpu = this_cpu;
> > +
> > +	BUG_ON(cpu_to_node(this_cpu) == nid);
> > +
> > +	rcu_read_lock();
> > +	for_each_cpu(i, cpumask_of_node(nid)) {
> > +		load = weighted_cpuload(i);
> > +
> > +		if (load < min_load) {
> > +			/*
> > +			 * Kernel threads can be preempted. For others, do
> > +			 * not preempt if running on their preferred node
> > +			 * or pinned.
> > +			 */
> > +			struct task_struct *p = cpu_rq(i)->curr;
> > +			if ((p->flags & PF_KTHREAD) ||
> > +			    (p->numa_preferred_nid != nid && p->nr_cpus_allowed > 1)) {
> > +				min_load = load;
> > +				idlest_cpu = i;
> > +			}
> 
> So I really don't get this stuff.. if it is indeed the idlest cpu preempting
> others shouldn't matter. Also, migrating a task there doesn't actually mean it
> will get preempted either.
> 

At one point this was part of a patch that swapped tasks on the target
node where it really was preempting the running task as the comment
describes. Swapping was premature because it was not evaluating if the
swap would improve performance overall.  You're right, this check should
be removed entirely and it will be in the next update.

Thanks.

-- 
Mel Gorman
SUSE Labs
