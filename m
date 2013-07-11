Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3GKMxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:53:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3GKMxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:53:06 -0400
Date: Thu, 11 Jul 2013 13:53:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/16] sched: Select a preferred node with the most numa
 hinting faults
Message-ID: <20130711125303.GB2355@suse.de>
References: <1373536020-2799-1-git-send-email-mgorman@suse.de>
 <1373536020-2799-6-git-send-email-mgorman@suse.de>
 <20130711112359.GG25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130711112359.GG25631@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 01:23:59PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 11, 2013 at 10:46:49AM +0100, Mel Gorman wrote:
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1593,6 +1593,7 @@ static void __sched_fork(struct task_struct *p)
> >  	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
> >  	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
> >  	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
> > +	p->numa_preferred_nid = -1;
> 
> (1)
> 
> >  	p->numa_work.next = &p->numa_work;
> >  	p->numa_faults = NULL;
> >  #endif /* CONFIG_NUMA_BALANCING */
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 904fd6f..c0bee41 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -793,7 +793,8 @@ unsigned int sysctl_numa_balancing_scan_delay = 1000;
> >  
> >  static void task_numa_placement(struct task_struct *p)
> >  {
> > -	int seq;
> > +	int seq, nid, max_nid = 0;
> 
> Should you not start with max_nid = -1?
> 

For consistency, yes.

> > +	unsigned long max_faults = 0;
> >  
> >  	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
> >  		return;
> > @@ -802,7 +803,19 @@ static void task_numa_placement(struct task_struct *p)
> >  		return;
> >  	p->numa_scan_seq = seq;
> >  
> > -	/* FIXME: Scheduling placement policy hints go here */
> > +	/* Find the node with the highest number of faults */
> > +	for (nid = 0; nid < nr_node_ids; nid++) {
> > +		unsigned long faults = p->numa_faults[nid];
> > +		p->numa_faults[nid] >>= 1;
> > +		if (faults > max_faults) {
> > +			max_faults = faults;
> > +			max_nid = nid;
> > +		}
> > +	}
> > +
> 
> It is rather unlikely; but suppose the entire ->numa_faults[] array is 0, you'd
> somehow end up selecting max_nid := 0. Which seems inconsistent with \1.
> 

This happens more often than you might imagine due to THP false sharing
getting count as shared. If the entire numa_faults[] array is 0 then
max_faults == 0 and it will not update preferred_nid due to the
"max_faults" check below.

> > +	/* Update the tasks preferred node if necessary */
> > +	if (max_faults && max_nid != p->numa_preferred_nid)
> > +		p->numa_preferred_nid = max_nid;
> >  }
> >  

-- 
Mel Gorman
SUSE Labs
