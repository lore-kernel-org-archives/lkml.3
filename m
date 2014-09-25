Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaIYRX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:23:27 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37465 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaIYRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:23:26 -0400
Date: Thu, 25 Sep 2014 18:23:43 +0100
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
Message-ID: <20140925172343.GX23693@e103034-lin>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 02:48:47PM +0100, Vincent Guittot wrote:
> On 22 September 2014 18:24, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> >
> > The per-entity load-tracking currently neither accounts for frequency
> > changes due to frequency scaling (cpufreq) nor for micro-architectural
> > differences between cpus (ARM big.LITTLE). Comparing tracked loads
> > between different cpus might therefore be quite misleading.
> >
> > This patch introduces a scale-invariance scaling factor to the
> > load-tracking computation that can be used to compensate for compute
> > capacity variations. The scaling factor is to be provided by the
> > architecture through an arch specific function. It may be as simple as:
> >
> >         current_freq(cpu) * SCHED_CAPACITY_SCALE / max_freq(cpu)
> >
> > If the architecture has more sophisticated ways of tracking compute
> > capacity, it can do so in its implementation. By default, no scaling is
> > applied.
> >
> > The patch is loosely based on a patch by Chris Redpath
> > <Chris.Redpath@arm.com>.
> >
> > cc: Paul Turner <pjt@google.com>
> > cc: Ben Segall <bsegall@google.com>
> >
> > Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> > Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> > ---
> >  kernel/sched/fair.c |   32 ++++++++++++++++++++++++++------
> >  1 file changed, 26 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 2a1e6ac..52abb3e 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -2267,6 +2267,8 @@ static u32 __compute_runnable_contrib(u64 n)
> >         return contrib + runnable_avg_yN_sum[n];
> >  }
> >
> > +unsigned long arch_scale_load_capacity(int cpu);
> 
> Why haven't you used arch_scale_freq_capacity which has a similar
> purpose in scaling the CPU capacity except the additional sched_domain
> pointer argument ?

To be honest I'm not happy with introducing another arch-function
either and I'm happy to change that. It wasn't really clear to me which
functions that would remain after your cpu_capacity rework patches, so I
added this one. Now that we have most of the patches for capacity
scaling and scale-invariant load-tracking on the table I think we have a
better chance of figuring out which ones are needed and exactly how they
are supposed to work.

arch_scale_load_capacity() compensates for both frequency scaling and
micro-architectural differences, while arch_scale_freq_capacity() only
for frequency. As long as we can use arch_scale_cpu_capacity() to
provide the micro-architecture scaling we can just do the scaling in two
operations rather than one similar to how it is done for capacity in
update_cpu_capacity(). I can fix that in the next version. It will cost
an extra function call and multiplication though.

To make sure that runnable_avg_{sum, period} are still bounded by
LOAD_AVG_MAX, arch_scale_{cpu,freq}_capacity() must both return a factor
in the range 0..SCHED_CAPACITY_SCALE.

> 
> > +
> >  /*
> >   * We can represent the historical contribution to runnable average as the
> >   * coefficients of a geometric series.  To do this we sub-divide our runnable
> > @@ -2295,13 +2297,14 @@ static u32 __compute_runnable_contrib(u64 n)
> >   *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
> >   *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
> >   */
> > -static __always_inline int __update_entity_runnable_avg(u64 now,
> > +static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
> >                                                         struct sched_avg *sa,
> >                                                         int runnable)
> >  {
> >         u64 delta, periods;
> >         u32 runnable_contrib;
> >         int delta_w, decayed = 0;
> > +       u32 scale_cap = arch_scale_load_capacity(cpu);
> >
> >         delta = now - sa->last_runnable_update;
> >         /*
> > @@ -2334,8 +2337,10 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
> >                  * period and accrue it.
> >                  */
> >                 delta_w = 1024 - delta_w;
> > +
> >                 if (runnable)
> > -                       sa->runnable_avg_sum += delta_w;
> > +                       sa->runnable_avg_sum += (delta_w * scale_cap)
> > +                                       >> SCHED_CAPACITY_SHIFT;
> >                 sa->runnable_avg_period += delta_w;
> >
> >                 delta -= delta_w;
> > @@ -2351,14 +2356,17 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
> >
> >                 /* Efficiently calculate \sum (1..n_period) 1024*y^i */
> >                 runnable_contrib = __compute_runnable_contrib(periods);
> > +
> >                 if (runnable)
> > -                       sa->runnable_avg_sum += runnable_contrib;
> > +                       sa->runnable_avg_sum += (runnable_contrib * scale_cap)
> > +                                               >> SCHED_CAPACITY_SHIFT;
> >                 sa->runnable_avg_period += runnable_contrib;
> >         }
> >
> >         /* Remainder of delta accrued against u_0` */
> >         if (runnable)
> > -               sa->runnable_avg_sum += delta;
> > +               sa->runnable_avg_sum += (delta * scale_cap)
> > +                               >> SCHED_CAPACITY_SHIFT;
> 
> If we take the example of an always running task, its runnable_avg_sum
> should stay at the LOAD_AVG_MAX value whatever the frequency of the
> CPU on which it runs. But your change links the max value of
> runnable_avg_sum with the current frequency of the CPU so an always
> running task will have a load contribution of 25%
> your proposed scaling is fine with usage_avg_sum which reflects the
> effective running time on the CPU but the runnable_avg_sum should be
> able to reach LOAD_AVG_MAX whatever the current frequency is

I don't think it makes sense to scale one metric and not the other. You
will end up with two very different (potentially opposite) views of the
cpu load/utilization situation in many scenarios. As I see it,
scale-invariance and load-balancing with scale-invariance present can be
done in two ways:

1. Leave runnable_avg_sum unscaled and scale running_avg_sum.
se->avg.load_avg_contrib will remain unscaled and so will
cfs_rq->runnable_load_avg, cfs_rq->blocked_load_avg, and
weighted_cpuload(). Essentially all the existing load-balancing code
will continue to use unscaled load. When we want to improve cpu
utilization and energy-awareness we will have to bypass most of this
code as it is likely to lead us on the wrong direction since it has a
potentially wrong view of the cpu load due to the lack of
scale-invariance.

2. Scale both runnable_avg_sum and running_avg_sum. All existing load
metrics including weighted_cpuload() are scaled and thus more accurate.
The difference between se->avg.load_avg_contrib and
se->avg.usage_avg_contrib is the priority scaling and whether or not
runqueue waiting time is counted. se->avg.load_avg_contrib can only
reach se->load.weight when running on the fastest cpu at the highest
frequency, but it is now scale-invariant so we have much better idea
about how much load we are pulling when load-balancing two cpus running
at different frequencies. The load-balance code-path still has to be
audited to see if anything blows up due to the scaling. I haven't
finished doing that yet. This patch set doesn't include patches to
address such issues (yet). IMHO, by scaling runnable_avg_sum we can more
easily make the existing load-balancing code do the right thing.

For both options we have to go through the existing load-balancing code
to either change it to use the scale-invariant metric (running_avg_sum)
when appropriate or to fix bits that don't work properly with a
scale-invariant runnable_avg_sum and reuse the existing code. I think
the latter is less intrusive, but I might be wrong.

Opinions?

Morten
