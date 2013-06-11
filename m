Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3FKAlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 20:41:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52448 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753989Ab3FKAlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 20:41:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
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
        Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: power-efficient scheduling design
Date: Tue, 11 Jun 2013 02:50:53 +0200
Message-ID: <3381787.jv4tpnigj7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51B3F99A.4000101@linux.vnet.ibm.com>
References: <20130530134718.GB32728@e103034-lin> <1834293.MlyIaiESPL@vostro.rjw.lan> <51B3F99A.4000101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 09, 2013 09:12:18 AM Preeti U Murthy wrote:
> Hi Rafael,

Hi Preeti,

> On 06/08/2013 07:32 PM, Rafael J. Wysocki wrote:
> > On Saturday, June 08, 2013 12:28:04 PM Catalin Marinas wrote:
> >> On Fri, Jun 07, 2013 at 07:08:47PM +0100, Preeti U Murthy wrote:

[...]

> >> The scheduler can decide to load a single CPU or cluster and let the
> >> others idle. If the total CPU load can fit into a smaller number of CPUs
> >> it could as well tell cpuidle to go into deeper state from the
> >> beginning as it moved all the tasks elsewhere.
> > 
> > So why can't it do that today?  What's the problem?
> 
> The reason that scheduler does not do it today is due to the
> prefer_sibling logic. The tasks within a core get distributed across
> cores if they are more than 1, since the cpu power of a core is not high
> enough to handle more than one task.
> 
> However at a socket level/ MC level (cluster at a low level), there can
> be as many tasks as there are cores because the socket has enough CPU
> capacity to handle them. But the prefer_sibling logic moves tasks across
> socket/MC level domains even when load<=domain_capacity.
> 
> I think the reason why the prefer_sibling logic was introduced, is that
> scheduler looks at spreading tasks across all the resources it has. It
> believes keeping tasks within a cluster/socket level domain would mean
> tasks are being throttled by having access to only the cluster/socket
> level resources. Which is why it spreads.
> 
> The prefer_sibling logic is nothing but a flag set at domain level to
> communicate to the scheduler that load should be spread across the
> groups of this domain. In the above example across sockets/clusters.
> 
> But I think it is time we take another look at the prefer_sibling logic
> and decide on its worthiness.

Well, it does look like something that would be good to reconsider.

Some results indicate that for a given CPU package (cluster/socket) there
is a threshold number of tasks such that it is beneficial to pack tasks
into that package as long as the total number of tasks running on it does
not exceed that number.  It may be 1 (which is the value used currently with
prefer_sibling set if I understood what you said correctly), but it very
well may be 2 or more (depending on the hardware characteristics).

[...]

> > If we know in advance that the CPU can be put into idle state Cn, there is no
> > reason to put it into anything shallower than that.
> > 
> > On the other hand, if the CPU is in Cn already and there is a possibility to
> > put it into a deeper low-power state (which we didn't know about before), it
> > may make sense to promote it into that state (if that's safe) or even wake it
> > up and idle it again.
> 
> Yes, sorry I said it wrong in the previous mail. Today the cpuidle
> governor is capable of putting a CPU in idle state Cn directly, by
> looking at various factors like the current load, next timer, history of
> interrupts, exit latency of states. At the end of this evaluation it
> puts it into idle state Cn.
> 
> Also it cares to check if its decision is right. This is with respect to
> your statement "if there is a possibility to put it into deeper low
> power state". It queues a timer at a time just after its predicted wake
> up time before putting the cpu to idle state. If this time of wakeup
> prediction is wrong, this timer triggers to wake up the cpu and the cpu
> is hence put into a deeper sleep state.

So I don't think we need to modify that behavior. :-)

> >>> This means time will tell the governors what kinds of workloads are running
> >>> on the system. If the cpu is idle for long, it probably means that the system
> >>> is less loaded and it makes sense to put the cpus to deeper sleep
> >>> states. Of course there could be sporadic bursts or quieting down of
> >>> tasks, but these are corner cases.
> >>
> >> It's nothing wrong with degrading given the information that cpuidle
> >> currently has. It's a heuristics that worked ok so far and may continue
> >> to do so. But see my comments above on why the scheduler could make more
> >> informed decisions.
> >>
> >> We may not move all the power gating information to the scheduler but
> >> maybe find a way to abstract this by giving more hints via the CPU and
> >> cache topology. The cpuidle framework (it may not be much left of a
> >> governor) would then take hints about estimated idle time and invoke the
> >> low-level driver about the right C state.
> > 
> > Overall, it looks like it'd be better to split the governor "layer" between the
> > scheduler and the idle driver with a well defined interface between them.  That
> > interface needs to be general enough to be independent of the underlying
> > hardware.
> > 
> > We need to determine what kinds of information should be passed both ways and
> > how to represent it.
> 
> I agree with this design decision.

OK, so let's try to take one step more and think about what part should belong
to the scheduler and what part should be taken care of by the "idle" driver.

Do you have any specific view on that?

> >>>> Of course, you could export more scheduler information to cpuidle,
> >>>> various hooks (task wakeup etc.) but then we have another framework,
> >>>> cpufreq. It also decides the CPU parameters (frequency) based on the
> >>>> load controlled by the scheduler. Can cpufreq decide whether it's
> >>>> better to keep the CPU at higher frequency so that it gets to idle
> >>>> quicker and therefore deeper sleep states? I don't think it has enough
> >>>> information because there are at least three deciding factors
> >>>> (cpufreq, cpuidle and scheduler's load balancing) which are not
> >>>> unified.
> >>>
> >>> Why not? When the cpu load is high, cpu frequency governor knows it has
> >>> to boost the frequency of that CPU. The task gets over quickly, the CPU
> >>> goes idle. Then the cpuidle governor kicks in to put the CPU to deeper
> >>> sleep state gradually.
> >>
> >> The cpufreq governor boosts the frequency enough to cover the load,
> >> which means reducing the idle time. It does not know whether it is
> >> better to boost the frequency twice as high so that it gets to idle
> >> quicker. You can change the governor's policy but does it have any
> >> information from cpuidle?
> > 
> > Well, it may get that information directly from the hardware.  Actually,
> > intel_pstate does that, but intel_pstate is the governor and the scaling
> > driver combined.
> 
> To add to this, cpufreq currently functions in the below fashion. I am
> talking of the on demand governor, since it is more relevant to our
> discussion.
> 
> ----stepped up frequency------
>   ----threshold--------
>       -----stepped down freq level1---
>         -----stepped down freq level2---
>           ---stepped down freq level3----
> 
> If the cpu idle time is below a threshold , it boosts the frequency to

Did you mean "above the threshold"?

> one level above straight away and does not vary it any further. If the
> cpu idle time is below a threshold there is a step down in frequency
> levels by 5% of the current frequency at every sampling period, provided
> the cpu behavior is constant.
> 
> I think we can improve this implementation by better interaction with
> cpuidle and scheduler.
> 
> When it is stepping up frequency, it should do it in steps of frequency
> being a *function of the current cpu load* also, or function of idle
> time will also do.
> 
> When it is stepping down frequency, it should interact with cpuidle. It
> should get from cpuidle information regarding the idle state that the
> cpu is in.The reason is cpufrequency governor is aware of only the idle
> time of the cpu, not the idle state it is in. If it gets to know that
> the cpu is in a deep idle state, it could step down frequency levels to
> leveln straight away. Just like cpuidle does to put cpus into state Cn.
> 
> Or an alternate option could be just like stepping up, make the stepping
> down also a function of idle time. Perhaps
> fn(|threshold-idle_time|).
> 
> Also one more point to note is that if cpuidle puts cpus into such idle
> states that clock gate the cpus, then there is no need for cpufrequency
> governor for that cpu. cpufreq can check with cpuidle on this front
> before it queries a cpu.

cpufreq ondemand (or intel_pstate for that matter) doesn't touch idle CPUs,
because it uses deferrable timers.  It basically only handles CPUs that aren't
idle at the moment.

However, it doesn't exactly know when the given CPU stopped being idle, because
its sampling is not generally synchronized with the scheduler's operations.
That, among other things, is why I'm thinking that it might be better if the
scheduler told cpufreq (or intel_pstate) when to try to adjust frequencies so
that it doesn't need to sample by itself.

[...]

> >>
> >> Let's say there is an increase in the load, does the scheduler wait
> >> until cpufreq figures this out or tries to take the other CPUs out of
> >> idle? Who's making this decision? That's currently a potentially
> >> unstable loop.
> > 
> > Yes, it is and I don't think we currently have good answers here.
> 
> My answer to the above question is scheduler does not wait until cpufreq
> figures it out. All that the scheduler cares about today is load
> balancing. Spread the load and hope it finishes soon. There is a
> possibility today that even before cpu frequency governor can boost the
> frequency of cpu, the scheduler can spread the load.

That is a valid observation, but I wanted to say that we didn't really
understood how those things should be arranged.

> As for the second question it will wakeup idle cpus if it must to load
> balance.
> 
> It is a good question asked: "does the scheduler wait until cpufreq
> figures it out." Currently the answer is no, it does not communicate
> with cpu frequency at all (except through cpu power, but that is the
> good part of the story, so I will not get there now). But maybe we
> should change this. I think we can do so the following way.
> 
> When can a scheduler talk to cpu frequency? It can do so under the below
> circumstances:
> 
> 1. Load is too high across the systems, all cpus are loaded, no chance
> of load balancing. Therefore ask cpu frequency governor to step up
> frequency to get improve performance.
> 
> 2. The scheduler finds out that if it has to load balance, it has to do
> so on cpus which are in deep idle state( Currently this logic is not
> present, but worth getting it in). It then decides to increase the
> frequency of the already loaded cpus to improve performance. It calls
> cpu freq governor.
> 
> 3. The scheduler finds out that if it has to load balance, it has to do
> so on a different power domain which is idle currently(shallow/deep). It
> thinks the better of it and calls cpu frequency governor to boost the
> frequency of the cpus in the current domain.
> 
> While 2 and 3 depend on scheduler having knowledge about idle states and
> power domains, which it currently does not have, 1 can be achieved with
> the current code. scheduler keeps track of failed ld balancing efforts
> with lb_failed. If it finds that while load balancing from busy group
> failed (lb_failed > 0), it can call cpu freq governor to step up the cpu
> frequency of this busy cpu group, with gov_check_cpu() in cpufrequency
> governor code.

Well, if the model is that the scheduler tells cpufreq when to modify
frequencies, then it'll need to do that on a regular basis, like every time
a task is scheduled or similar.

> > The results of many measurements seem to indicate that it generally is better
> > to do the work as quickly as possible and then go idle again, but there are
> > costs associated with going back and forth from idle to non-idle etc.
> 
> I think we can even out the cost benefit of race to idle, by choosing to
> do it wisely. Like for example if points 2 and 3 above are true (idle
> cpus are in deep sleep states or need to ld balance on a different power
> domain), then step up the frequency of the current working cpus and reap
> its benefit.
> 
> > 
> > The main problem with cpufreq that I personally have is that the governors
> > carry out their own sampling with pretty much arbitrary resolution that may
> > lead to suboptimal decisions.  It would be much better if the scheduler
> > indicated when to *consider* the changing of CPU performance parameters (that
> > may not be frequency alone and not even frequency at all in general), more or
> > less the same way it tells cpuidle about idle CPUs, but I'm not sure if it
> > should decide what performance points to run at.
> 
> Very true. See the points 1,2 and 3 above where I list out when
> scheduler can call cpu frequency.

Well, as I said above, I think that'd need to be done more frequently.

> Also an idea about how cpu frequency governor can decide on the scaling
> frequency is stated above.

Actaully, intel_pstate uses a PID controller for making those decisions and
I think this may be just the right thing to do.

[...]

> > 
> > Well, there's nothing like "predicted load".  At best, we may be able to make
> > more or less educated guesses about it, so in my opinion it is better to use
> > the information about what happened in the past for making decisions regarding
> > the current settings and re-adjust them over time as we get more information.
> 
> Agree with this as well. scheduler can at best supply information
> regarding the historic load and hope that it is what defines the future
> as well. Apart from this I dont know what other information scheduler
> can supply cpuidle governor with.
> > 
> > So how much decision making regarding the idle state to put the given CPU into
> > should be there in the scheduler?  I believe the only information coming out
> > of the scheduler regarding that should be "OK, this CPU is now idle and I'll
> > need it in X nanoseconds from now" plus possibly a hint about the wakeup
> > latency tolerance (but those hints may come from other places too).  That said
> > the decision *which* CPU should become idle at the moment very well may require
> > some information about what options are available from the layer below (for
> > example, "putting core X into idle for Y of time will save us Z energy" or
> > something like that).
> 
> Agree. Except that the information should be "Ok , this CPU is now idle
> and it has not done much work in the recent past,it is a 10% loaded CPU".

And what would that be useful for to the "idle" layer?  What matters is the
"I'll need it in X nanoseconds from now" part.

Yes, the load part would be interesting to the "frequency" layer.

> This can be said today using PJT's metric. It is now for the cpuidle
> governor to decide the idle state to go to. Thats what happens today too.
> 
> > 
> > And what about performance scaling?  Quite frankly, in my opinion that
> > requires some more investigation, because there still are some open questions
> > in that area.  To start with we can just continue using the current heuristics,
> > but perhaps with the scheduler calling the scaling "governor" when it sees fit
> > instead of that "governor" running kind of in parallel with it.
> 
> Exactly. How this can be done is elaborated above. This is one of the
> key things we need today,IMHO.
> 
> > 

[...]

> > 
> > There is another angle to look at that as I said somewhere above.
> > 
> > What if we could integrate cpuidle with cpufreq so that there is one code
> > layer representing what the hardware can do to the scheduler?  What benefits
> > can we get from that, if any?
> 
> We could debate on this point. I am a bit confused about this. As I see
> it, there is no problem with keeping them separately. One, because of
> code readability; it is easy to understand what are the different
> parameters that the performance of CPU depends on, without needing to
> dig through the code. Two, because cpu frequency kicks in during runtime
> primarily and cpuidle during idle time of the cpu.

That's a very useful observation.  Indeed, there's the "idle" part that needs
to be invoked when the CPU goes idle (and it should decide what idle state to
put that CPU into), and there's the "scaling" part that needs to be invoked
when the CPU has work to do (and it should decide what performance point to
put that CPU into).  The question is, though, if it's better to have two
separate frameworks for those things (which is what we have today) or to make
them two parts of the same framework (like two callbacks one of which will be
executed for CPUs that have just become idle and the other will be invoked
for CPUs that have just got work to do).

> But this would also mean creating well defined interfaces between them.
> Integrating cpufreq and cpuidle seems like a better argument to make due
> to their common functionality at a higher level of talking to hardware
> and tuning the performance parameters of cpu. But I disagree that
> scheduler should be put into this common framework as well as it has
> functionalities which are totally disjoint from what subsystems such as
> cpuidle and cpufreq are intended to do.

That's correct.  The role of the scheduler, in my opinion, may be to call the
"idle" and "scaling" functions at the right time and to give them information
needed to make optimal choices.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
