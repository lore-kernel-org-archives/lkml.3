Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaGNOEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:04:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:31993 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755444AbaGNOEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:04:47 -0400
Date: Mon, 14 Jul 2014 15:04:35 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140714140435.GO26542@e103034-lin>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop>
 <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
 <20140711151304.GD3935@laptop>
 <CAKfTPtCL6mta75k9eoK724wCm7S3w7E+psa1XDrxhN1YVDONPw@mail.gmail.com>
 <20140711201238.GY20603@laptop.programming.kicks-ass.net>
 <20140714125529.GN26542@e103034-lin>
 <20140714132052.GY9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714132052.GY9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 02:20:52PM +0100, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 01:55:29PM +0100, Morten Rasmussen wrote:
> > On Fri, Jul 11, 2014 at 09:12:38PM +0100, Peter Zijlstra wrote:
> > > On Fri, Jul 11, 2014 at 07:39:29PM +0200, Vincent Guittot wrote:
> > > > In my mind, arch_scale_cpu_freq was intend to scale the capacity of
> > > > the CPU according to the current dvfs operating point.
> > > > As it's no more use anywhere now that we have arch_scale_cpu, we could
> > > > probably remove it .. and see when it will become used.
> > > 
> > > I probably should have written comments when I wrote that code, but it
> > > was meant to be used only where, as described above, we limit things.
> > > Ondemand and such, which will temporarily decrease freq, will ramp it up
> > > again at demand, and therefore lowering the capacity will skew things.
> > > 
> > > You'll put less load on because its run slower, and then you'll run it
> > > slower because there's less load on -> cyclic FAIL.
> > 
> > Agreed. We can't use a frequency scaled compute capacity for all
> > load-balancing decisions. However, IMHO, it would be useful to have know
> > the current compute capacity in addition to the max compute capacity
> > when considering energy costs. So we would have something like:
> > 
> > * capacity_max: cpu capacity at highest frequency.
> > 
> > * capacity_cur: cpu capacity at current frequency.
> > 
> > * capacity_avail: cpu capacity currently available. Basically
> >   capacity_cur taking rt, deadline, and irq accounting into account.
> > 
> > capacity_max should probably include rt, deadline, and irq accounting as
> > well. Or we need both?
> 
> I'm struggling to fully grasp your intent. We need DVFS like accounting
> for sure, and that means a current freq hook, but I'm not entirely sure
> how that relates to capacity.

We can abstract all the factors that affect current compute capacity
(frequency, P-states, big.LITTLE,...) in the scheduler by having
something like capacity_{cur,avail} to tell us how much capacity does a
particular cpu have in its current state. Assuming that implement scale
invariance for entity load tracking (we are working on that), we can
directly compare task utilization with compute capacity for balancing
decisions. For example, we can figure out how much spare capacity a cpu
has in its current state by simply:

spare_capacity(cpu) = capacity_avail(cpu) - \sum_{tasks(cpu)}^{t} util(t)

If you put more than spare_capacity(cpu) worth of task utilization on
the cpu, you will cause the cpu (and any affected cpus) to change
P-state and potentially be less energy-efficient.

Does that make any sense?

Instead of dealing with frequencies directly in the scheduler code, we
can abstract it by just having scalable compute capacity.

> 
> > Based on your description arch_scale_freq_capacity() can't be abused to
> > implement capacity_cur (and capacity_avail) unless it is repurposed.
> > Nobody seems to implement it. Otherwise we would need something similar
> > to update capacity_cur (and capacity_avail).
> 
> Yeah, I never got around to doing so. I started doing a APERF/MPERF SMT
> capacity thing for x86 but never finished that. The naive implementation
> suffered the same FAIL loop as above because APERF stops on idle. So
> when idle your capacity drops to nothing, leading to no new work,
> leading to more idle etc.
> 
> I never got around to fixing that -- adding an idle filter, and ever
> since things have somewhat bitrotted.

I see.

> 
> > As a side note, we can potentially get into a similar fail cycle already
> > due to the lack of scale invariance in the entity load tracking.
> 
> Yah, I think that got mentioned a long while ago.

It did :-)

> 
> > > > > In that same discussion ISTR a suggestion about adding avg_running time,
> > > > > as opposed to the current avg_runnable. The sum of avg_running should be
> > > > > much more accurate, and still react correctly to migrations.
> > > > 
> > > > I haven't look in details but I agree that avg_running would be much
> > > > more accurate than avg_runnable and should probably fit the
> > > > requirement. Does it means that we could re-add the avg_running (or
> > > > something similar) that has disappeared during the review of load avg
> > > > tracking patchset ?
> > > 
> > > Sure, I think we killed it there because there wasn't an actual use for
> > > it and I'm always in favour of stripping everything to their bare bones,
> > > esp big and complex things.
> > > 
> > > And then later, add things back once we have need for it.
> > 
> > I think it is a useful addition to the set of utilization metrics. I
> > don't think it is universally more accurate than runnable_avg. Actually
> > quite the opposite when the cpu is overloaded. But for partially loaded
> > cpus it is very useful if you don't want to factor in waiting time on
> > the rq.
> 
> Well, different things different names. Utilization as per literature is
> simply the fraction of CPU time actually used. In that sense running_avg
> is about right for that. Our current runnable_avg is entirely different
> (as I think we all agree by now).
> 
> But yes, for application the tipping point is u == 1, up until that
> point pure utilization makes sense, after that our runnable_avg makes
> more sense.

Agreed.

If you really care about latency/performance you might be interested in
comparing running_avg and runnable_avg even for u < 1. If the
running_avg/runnable_avg ratio is significantly less than one, tasks are
waiting on the rq to be scheduled.
