Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3FHL2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 07:28:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41154 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097Ab3FHL16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 07:27:58 -0400
Date: Sat, 8 Jun 2013 12:28:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: power-efficient scheduling design
Message-ID: <20130608112801.GA8120@MacBook-Pro.local>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <51B177AA.1000600@linux.vnet.ibm.com>
 <CAHkRjk5BzoyB0EPbKOU3UZ+zOkhb-u5Tf_pSgO-7JdjW=HCvgQ@mail.gmail.com>
 <51B221AF.9070906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B221AF.9070906@linux.vnet.ibm.com>
Thread-Topic: power-efficient scheduling design
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:08:47PM +0100, Preeti U Murthy wrote:
> On 06/07/2013 08:21 PM, Catalin Marinas wrote:
> > I think you are missing Ingo's point. It's not about the scheduler
> > complying with decisions made by various governors in the kernel
> > (which may or may not have enough information) but rather the
> > scheduler being in a better position for making such decisions.
> 
> My mail pointed out that I disagree with this design ("the scheduler
> being in a better position for making such decisions").
> I think it should be a 2 way co-operation. I have elaborated below.
> 
> > Take the cpuidle example, it uses the load average of the CPUs,
> > however this load average is currently controlled by the scheduler
> > (load balance). Rather than using a load average that degrades over
> > time and gradually putting the CPU into deeper sleep states, the
> > scheduler could predict more accurately that a run-queue won't have
> > any work over the next x ms and ask for a deeper sleep state from the
> > beginning.
> 
> How will the scheduler know that there will not be work in the near
> future? How will the scheduler ask for a deeper sleep state?
> 
> My answer to the above two questions are, the scheduler cannot know how
> much work will come up. All it knows is the current load of the
> runqueues and the nature of the task (thanks to the PJT's metric). It
> can then match the task load to the cpu capacity and schedule the tasks
> on the appropriate cpus.

The scheduler can decide to load a single CPU or cluster and let the
others idle. If the total CPU load can fit into a smaller number of CPUs
it could as well tell cpuidle to go into deeper state from the
beginning as it moved all the tasks elsewhere.

Regarding future work, neither cpuidle nor the scheduler know this but
the scheduler would make a better prediction, for example by tracking
task periodicity.

> As a consequence, it leaves certain cpus idle. The load of these cpus
> degrade. It is via this load that the scheduler asks for a deeper sleep
> state. Right here we have scheduler talking to the cpuidle governor.

So we agree that the scheduler _tells_ the cpuidle governor when to go
idle (but not how deep). IOW, the scheduler drives the cpuidle
decisions. Two problems: (1) the cpuidle does not get enough information
from the scheduler (arguably this could be fixed) and (2) the scheduler
does not have any information about the idle states (power gating etc.)
to make any informed decision on which/when CPUs should go idle.

As you said, it is a non-optimal one-way communication but the solution
is not feedback loop from cpuidle into scheduler. It's like the
scheduler managed by chance to get the CPU into a deeper sleep state and
now you'd like the scheduler to get feedback form cpuidle and not
disturb that CPU anymore. That's the closed loop I disagree with. Could
the scheduler not make this informed decision before - it has this total
load, let's get this CPU into deeper sleep state?

> I don't see what the problem is with the cpuidle governor waiting for
> the load to degrade before putting that cpu to sleep. In my opinion,
> putting a cpu to deeper sleep states should happen gradually. This means
> time will tell the governors what kinds of workloads are running on the
> system. If the cpu is idle for long, it probably means that the system
> is less loaded and it makes sense to put the cpus to deeper sleep
> states. Of course there could be sporadic bursts or quieting down of
> tasks, but these are corner cases.

It's nothing wrong with degrading given the information that cpuidle
currently has. It's a heuristics that worked ok so far and may continue
to do so. But see my comments above on why the scheduler could make more
informed decisions.

We may not move all the power gating information to the scheduler but
maybe find a way to abstract this by giving more hints via the CPU and
cache topology. The cpuidle framework (it may not be much left of a
governor) would then take hints about estimated idle time and invoke the
low-level driver about the right C state.

> > Of course, you could export more scheduler information to cpuidle,
> > various hooks (task wakeup etc.) but then we have another framework,
> > cpufreq. It also decides the CPU parameters (frequency) based on the
> > load controlled by the scheduler. Can cpufreq decide whether it's
> > better to keep the CPU at higher frequency so that it gets to idle
> > quicker and therefore deeper sleep states? I don't think it has enough
> > information because there are at least three deciding factors
> > (cpufreq, cpuidle and scheduler's load balancing) which are not
> > unified.
> 
> Why not? When the cpu load is high, cpu frequency governor knows it has
> to boost the frequency of that CPU. The task gets over quickly, the CPU
> goes idle. Then the cpuidle governor kicks in to put the CPU to deeper
> sleep state gradually.

The cpufreq governor boosts the frequency enough to cover the load,
which means reducing the idle time. It does not know whether it is
better to boost the frequency twice as high so that it gets to idle
quicker. You can change the governor's policy but does it have any
information from cpuidle?

> Meanwhile the scheduler should ensure that the tasks are retained on
> that CPU,whose frequency is boosted and should not load balance it, so
> that they can get over quickly. This I think is what is missing. Again
> this comes down to the scheduler taking feedback from the CPU frequency
> governors which is not currently happening.

Same loop again. The cpu load goes high because (a) there is more work,
possibly triggered by external events, and (b) the scheduler decided to
balance the CPUs in a certain way. As for cpuidle above, the scheduler
has direct influence on the cpufreq decisions. How would the scheduler
know which CPU not to balance against? Are CPUs in a cluster
synchronous? Is it better do let other CPU idle or more efficient to run
this cluster at half-speed?

Let's say there is an increase in the load, does the scheduler wait
until cpufreq figures this out or tries to take the other CPUs out of
idle? Who's making this decision? That's currently a potentially
unstable loop.

> >> I would repeat here that today we interface cpuidle/cpufrequency
> >> policies with scheduler but not the other way around. They do their bit
> >> when a cpu is busy/idle. However scheduler does not see that somebody
> >> else is taking instructions from it and comes back to give different
> >> instructions!
> > 
> > The key here is that cpuidle/cpufreq make their primary decision based
> > on something controlled by the scheduler: the CPU load (via run-queue
> > balancing). You would then like the scheduler take such decision back
> > into account. It just looks like a closed loop, possibly 'unstable' .
> 
> Why? Why would you call a scheduler->cpuidle->cpufrequency interaction a
> closed loop and not the new_scheduler = scheduler+cpuidle+cpufrequency a
> closed loop? Here too the scheduler should be made well aware of the
> decisions it took in the past right?

It's more like:

scheduler -> cpuidle/cpufreq -> hardware operating point
   ^                                      |
   +--------------------------------------+

You can argue that you can make an adaptive loop that works fine but
there are so many parameters that I don't see how it would work. The
patches so far don't seem to address this. Small task packing, while
useful, it's some heuristics just at the scheduler level.

With a combined decision maker, you aim to reduce this separate decision
process and feedback loop. Probably impossible to eliminate the loop
completely because of hardware latencies, PLLs, CPU frequency not always
the main factor, but you can make the loop more tolerant to
instabilities.

> > So I think we either (a) come up with 'clearer' separation of
> > responsibilities between scheduler and cpufreq/cpuidle 
> 
> I agree with this. This is what I have been emphasizing, if we feel that
> the cpufrequency/ cpuidle subsystems are suboptimal in terms of the
> information that they use to make their decisions, let us improve them.
> But this will not yield us any improvement if the scheduler does not
> have enough information. And IMHO, the next fundamental information that
> the scheduler needs should come from cpufreq and cpuidle.

What kind of information? Your suggestion that the scheduler should
avoid loading a CPU because it went idle is wrong IMHO. It went idle
because the scheduler decided this in first instance.

> Then we should move onto supplying scheduler information from the power
> domain topology, thermal factors, user policies.

I agree with this but at this point you get the scheduler to make more
informed decisions about task placement. It can then give more precise
hints to cpufreq/cpuidle like the predicted load and those frameworks
could become dumber in time, just complying with the requested
performance level (trying to break the loop above).

> > or (b) come up
> > with a unified load-balancing/cpufreq/cpuidle implementation as per
> > Ingo's request. The latter is harder but, with a good design, has
> > potentially a lot more benefits.
> > 
> > A possible implementation for (a) is to let the scheduler focus on
> > performance load-balancing but control the balance ratio from a
> > cpufreq governor (via things like arch_scale_freq_power() or something
> > new). CPUfreq would not be concerned just with individual CPU
> > load/frequency but also making a decision on how tasks are balanced
> > between CPUs based on the overall load (e.g. four CPUs are enough for
> > the current load, I can shut the other four off by telling the
> > scheduler not to use them).
> > 
> > As for Ingo's preferred solution (b), a proposal forward could be to
> > factor the load balancing out of kernel/sched/fair.c and provide an
> > abstract interface (like load_class?) for easier extending or
> > different policies (e.g. small task packing). 
> 
>  Let me elaborate on the patches that have been posted so far on the
> power awareness of the scheduler. When we say *power aware scheduler*
> what exactly do we want it to do?
> 
> In my opinion, we want it to *avoid touching idle cpus*, so as to keep
> them in that state longer and *keep more power domains idle*, so as to
> yield power savings with them turned off. The patches released so far
> are striving to do the latter. Correct me if I am wrong at this.

Don't take me wrong, task packing to keep more power domains idle is
probably in the right direction but it may not address all issues. You
realised this is not enough since you are now asking for the scheduler
to take feedback from cpuidle. As I pointed out above, you try to create
a loop which may or may not work, especially given the wide variety of
hardware parameters.

> Also
> feel free to point out any other expectation from the power aware
> scheduler if I am missing any.

If the patches so far are enough and solved all the problems, you are
not missing any. Otherwise, please see my view above.

Please define clearly what the scheduler, cpufreq, cpuidle should be
doing and what communication should happen between them.

> If I have got Ingo's point right, the issues with them are that they are
> not taking a holistic approach to meet the said goal.

Probably because scheduler changes, cpufreq and cpuidle are all trying
to address the same thing but independent of each other and possibly
conflicting.

> Keeping more power
> domains idle (by packing tasks) would sound much better if the scheduler
> has taken all aspects of doing such a thing into account, like
> 
> 1. How idle are the cpus, on the domain that it is packing
> 2. Can they go to turbo mode, because if they do,then we cant pack
> tasks. We would need certain cpus in that domain idle.
> 3. Are the domains in which we pack tasks power gated?
> 4. Will there be significant performance drop by packing? Meaning do the
> tasks share cpu resources? If they do there will be severe contention.

So by this you add a lot more information about the power configuration
into the scheduler, getting it to make more informed decisions about
task scheduling. You may eventually reach a point where cpuidle governor
doesn't have much to do (which may be a good thing) and reach Ingo's
goal.

That's why I suggested maybe starting to take the load balancing out of
fair.c and make it easily extensible (my opinion, the scheduler guys may
disagree). Then make it more aware of topology, power configuration so
that it makes the right task placement decision. You then get it to
tell cpufreq about the expected performance requirements (frequency
decided by cpufreq) and cpuidle about how long it could be idle for (you
detect a periodic task every 1ms, or you don't have any at all because
they were migrated, the right C state being decided by the governor).

Regards.

-- 
Catalin
