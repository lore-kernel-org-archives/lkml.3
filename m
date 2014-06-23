Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaFWJme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:42:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaFWJmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:42:32 -0400
Date: Mon, 23 Jun 2014 11:42:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140623094214.GR19860@laptop.programming.kicks-ass.net>
References: <20140515115751.GK30445@twins.programming.kicks-ass.net>
 <5375768F.1010000@linux.vnet.ibm.com>
 <1400208690.7133.11.camel@marge.simpson.net>
 <53759303.40409@linux.vnet.ibm.com>
 <20140516075421.GL11096@twins.programming.kicks-ass.net>
 <5396C82C.6060101@linux.vnet.ibm.com>
 <20140610121222.GE6758@twins.programming.kicks-ass.net>
 <5397F396.2060801@linux.vnet.ibm.com>
 <20140611082433.GH3213@twins.programming.kicks-ass.net>
 <53981EE5.5080903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53981EE5.5080903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 05:18:29PM +0800, Michael wang wrote:
> On 06/11/2014 04:24 PM, Peter Zijlstra wrote:
> [snip]
> >>
> >> IMHO, when we put tasks one group deeper, in other word the totally
> >> weight of these tasks is 1024 (prev is 3072), the load become more
> >> balancing in root, which make bl-routine consider the system is
> >> balanced, which make we migrate less in lb-routine.
> > 
> > But how? The absolute value (1024 vs 3072) is of no effect to the
> > imbalance, the imbalance is computed from relative differences between
> > cpus.
> 
> Ok, forgive me for the confusion, please allow me to explain things
> again, for gathered cases like:
> 
> 		cpu 0		cpu 1
> 
> 		dbench		task_sys
> 		dbench		task_sys
> 		dbench
> 		dbench
> 		dbench
> 		dbench
> 		task_sys
> 		task_sys

It might help if you prefix each task with the cgroup they're in; but I
think I get it, its like:

	cpu0

	A/dbench
	A/dbench
	A/dbench
	A/dbench
	A/dbench
	A/dbench
	/task_sys
	/task_sys

> task_sys is other tasks belong to root which is nice 0, so when dbench
> in l1:
> 
> 		cpu 0			cpu 1
> 	load	1024 + 1024*2		1024*2
> 
> 		3072: 2048	imbalance %150
> 
> now when they belong to l2:

That would be:

	cpu0

	A/B/dbench
	A/B/dbench
	A/B/dbench
	A/B/dbench
	A/B/dbench
	A/B/dbench
	/task_sys
	/task_sys

Right?

> 		cpu 0			cpu 1
> 	load	1024/3 + 1024*2		1024*2
> 
> 		2389 : 2048	imbalance %116

Which should still end up with 3072, because A is still 1024 in total,
and all its member tasks run on the one CPU.

> And it could be even less during my testing...

Well, yes, up to 1024/nr_cpus I imagine.

> This is just try to explain that when 'group_load : rq_load' become
> lower, it's influence to 'rq_load' become lower too, and if the system
> is balanced with only 'rq_load' there, it will be considered still
> balanced even 'group_load' gathered on one cpu.
> 
> Please let me know if I missed something here...

Yeah, what other tasks are these task_sys things? workqueue crap?

> >> Exactly, however, when group is deep, the chance of it to make root
> >> imbalance reduced, in good case, gathered on cpu means 1024 load, while
> >> in bad case it dropped to 1024/3 ideally, that make it harder to trigger
> >> imbalance and gain help from the routine, please note that although
> >> dbench and stress are the only workload in system, there are still other
> >> tasks serve for the system need to be wakeup (some very actively since
> >> the dbench...), compared to them, deep group load means nothing...
> > 
> > What tasks are these? And is it their interference that disturbs
> > load-balancing?
> 
> These are dbench and stress with less root-load when put into l2-groups,
> that make it harder to trigger root-group imbalance like in the case above.

You're still not making sense here.. without the task_sys thingies in
you get something like:

 cpu0		cpu1

 A/dbench	A/dbench
 B/stress	B/stress

And the total loads are: 512+512 vs 512+512.

> > Same with l2, total weight of 1024, giving a per task weight of ~56 and
> > a per-cpu weight of ~85, which is again significant.
> 
> We have other tasks which has to running in the system, in order to
> serve dbench and others, and that also the case in real world, dbench
> and stress are not the only tasks on rq time to time.
> 
> May be we could focus on the case above and see if it could make things
> more clear firstly?

Well, this all smells like you need some cgroup affinity for whatever
system tasks are running. Not fuck up the scheduler for no sane reason.
