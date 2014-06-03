Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbaFCRQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:16:41 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44271 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932560AbaFCRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:16:39 -0400
Date: Tue, 3 Jun 2014 18:16:28 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603171628.GE29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <20140603154058.GY30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603154058.GY30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:40:58PM +0100, Peter Zijlstra wrote:
> On Wed, May 28, 2014 at 01:10:01PM +0100, Morten Rasmussen wrote:
> > The rq runnable_avg_{sum, period} give a very long term view of the cpu
> > utilization (I will use the term utilization instead of activity as I
> > think that is what we are talking about here). IMHO, it is too slow to
> > be used as basis for load balancing decisions. I think that was also
> > agreed upon in the last discussion related to this topic [1].
> > 
> > The basic problem is that worst case: sum starting from 0 and period
> > already at LOAD_AVG_MAX = 47742, it takes LOAD_AVG_MAX_N = 345 periods
> > (ms) for sum to reach 47742. In other words, the cpu might have been
> > fully utilized for 345 ms before it is considered fully utilized.
> > Periodic load-balancing happens much more frequently than that.
> 
> Like said earlier the 94% mark is actually hit much sooner, but yes,
> likely still too slow.
> 
> 50% at 32 ms, 75% at 64 ms, 87.5% at 96 ms, etc..

Agreed.

> 
> > Also, if load-balancing actually moves tasks around it may take quite a
> > while before runnable_avg_sum actually reflects this change. The next
> > periodic load-balance is likely to happen before runnable_avg_sum has
> > reflected the result of the previous periodic load-balance.
> > 
> > To avoid these problems, we need to base utilization on a metric which
> > is updated instantaneously when we add/remove tasks to a cpu (or a least
> > fast enough that we don't see the above problems).
> 
> So the per-task-load-tracking stuff already does that. It updates the
> per-cpu load metrics on migration. See {de,en}queue_entity_load_avg().

I think there is some confusion here. There are two per-cpu load metrics
that tracks differently.

The cfs.runnable_load_avg is basically the sum of the load contributions
of the tasks on the cfs rq. The sum gets updated whenever tasks are
{en,de}queued by adding/subtracting the load contribution of the task
being added/removed. That is the one you are referring to.

The rq runnable_avg_sum (actually rq->avg.runnable_avg_{sum, period}) is
tracking whether the cpu has something to do or not. It doesn't matter
many tasks are runnable or what their load is. It is updated in
update_rq_runnable_avg(). It increases when rq->nr_running > 0 and
decays if not. It also takes time spent running rt tasks into account in
idle_{enter, exit}_fair(). So if you remove tasks from the rq, this
metric will start decaying and eventually get to 0, unlike the
cfs.runnable_load_avg where the task load contribution subtracted every
time a task is removed. The rq runnable_avg_sum is the one being used in
this patch set.

Ben, pjt, please correct me if I'm wrong.

> And keeping an unweighted per-cpu variant isn't that much more work.

Agreed.

> 
> > In the previous
> > discussion [1] it was suggested that a sum of unweighted task
> > runnable_avg_{sum,period} ratio instead. That is, an unweighted
> > equivalent to weighted_cpuload(). That isn't a perfect solution either.
> > It is fine as long as the cpus are not fully utilized, but when they are
> > we need to use weighted_cpuload() to preserve smp_nice. What to do
> > around the tipping point needs more thought, but I think that is
> > currently the best proposal for a solution for task and cpu utilization.
> 
> I'm not too worried about the tipping point, per task runnable figures
> of an overloaded cpu are higher, so migration between an overloaded cpu
> and an underloaded cpu are going to be tricky no matter what we do.

Yes, agreed. I just got the impression that you were concerned about
smp_nice last time we discussed this.

> > rq runnable_avg_sum is useful for decisions where we need a longer term
> > view of the cpu utilization, but I don't see how we can use as cpu
> > utilization metric for load-balancing decisions at wakeup or
> > periodically.
> 
> So keeping one with a faster decay would add extra per-task storage. But
> would be possible..

I have had that thought when we discussed potential replacements for
cpu_load[]. It will require some messing around with the nicely
optimized load tracking maths if we want to have load tracking with a
different y-coefficient.

