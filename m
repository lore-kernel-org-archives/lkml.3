Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaIZJiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:38:11 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37807 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaIZJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:38:09 -0400
Date: Fri, 26 Sep 2014 10:38:32 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20140926093832.GY23693@e103034-lin>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com>
 <20140925172343.GX23693@e103034-lin>
 <CAKfTPtDWyf_Y0Ga2D_i7QFEddfif7h+E+xZjK6iau7-6ngSrzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDWyf_Y0Ga2D_i7QFEddfif7h+E+xZjK6iau7-6ngSrzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 08:36:53AM +0100, Vincent Guittot wrote:
> On 25 September 2014 19:23, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> 
> [snip]
> 
> >> >         /* Remainder of delta accrued against u_0` */
> >> >         if (runnable)
> >> > -               sa->runnable_avg_sum += delta;
> >> > +               sa->runnable_avg_sum += (delta * scale_cap)
> >> > +                               >> SCHED_CAPACITY_SHIFT;
> >>
> >> If we take the example of an always running task, its runnable_avg_sum
> >> should stay at the LOAD_AVG_MAX value whatever the frequency of the
> >> CPU on which it runs. But your change links the max value of
> >> runnable_avg_sum with the current frequency of the CPU so an always
> >> running task will have a load contribution of 25%
> >> your proposed scaling is fine with usage_avg_sum which reflects the
> >> effective running time on the CPU but the runnable_avg_sum should be
> >> able to reach LOAD_AVG_MAX whatever the current frequency is
> >
> > I don't think it makes sense to scale one metric and not the other. You
> > will end up with two very different (potentially opposite) views of the
> 
> you have missed my point, i fully agree that scaling in-variance is a
> good enhancement but IIUC your patchset doesn't solve the whole
> problem.
> 
> Let me try to explain with examples :
> - A task with a load of 10% on a CPU at max frequency will keep a load
> of  10% if the frequency of the CPU is divided by 2 which is fine

Yes.

> - But an always running task with a load of 100% on a CPU at max
> frequency will have a load of 50% if the frequency of the CPU is
> divided by 2 which is not what we want; the load of such task should
> stay at 100%

I think that is fine too and that is intentional. We can't say anything
about the load/utilization of an always running no matter what cpu and
at what frequency it is running. As soon as the tracked load/utilization
indicates always running, we don't know how much load/utilization it
will cause on a faster cpu. However, if it is 99.9% we are fine (well,
we do probably want some bigger margin). As I see it, always running
tasks must be treated specially. We can easily figure out which tasks
are always running by comparing the scale load divided by
se->load.weight to the current compute capacity on the cpu it is running
on. If they are equal (or close), the task is always running. If we
migrate it to a different cpu we should take into account that its load
might increase if it gets more cycles to spend. You could even do
something like:

unsigned long migration_load(sched_entity *se) {
	if (se->avg.load_avg_contrib >=
		current_capacity(cpu_of(se)) * se->load.weight)
		return se->load.weight;
	return se->avg.load_avg_contrib;
}

for use when moving tasks between cpus when the source cpu is fully
loaded at its current capacity. The task load is actually 100% relative
to the current compute capacity of the task cpu, but not compared to the
fastest cpu in the system.

As I said in my previous reply, this isn't covered yet by this patch
set. It is of course necessary to go through the load-balancing
conditions to see where/if modifications are needed to do the right
thing for scale-invariant load.

> - if we have 2 identical always running tasks on CPUs with different
> frequency, their load will be different

Yes, in terms of absolute load and it is only the case for always
running tasks. However, they would both have a load equal to the cpu
capacity divided by se->avg.load_avg_contrib, so we can easily identify
them.

> So your patchset adds scaling invariance for small tasks but add some
> scaling variances for heavy tasks

For always running tasks, yes, but I don't see how we can avoid treating
them specially anyway as we don't know anything about their true load.
That doesn't change by changing how we scale their load.

Better suggestions are of course welcome :)

Morten
