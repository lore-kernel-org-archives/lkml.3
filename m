Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3FIDob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 23:44:31 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50939 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3FIDo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 23:44:28 -0400
Message-ID: <51B3F99A.4000101@linux.vnet.ibm.com>
Date: Sun, 09 Jun 2013 09:12:18 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
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
References: <20130530134718.GB32728@e103034-lin> <51B221AF.9070906@linux.vnet.ibm.com> <20130608112801.GA8120@MacBook-Pro.local> <1834293.MlyIaiESPL@vostro.rjw.lan>
In-Reply-To: <1834293.MlyIaiESPL@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060903-9574-0000-0000-0000083704C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 06/08/2013 07:32 PM, Rafael J. Wysocki wrote:
> On Saturday, June 08, 2013 12:28:04 PM Catalin Marinas wrote:
>> On Fri, Jun 07, 2013 at 07:08:47PM +0100, Preeti U Murthy wrote:
>>> On 06/07/2013 08:21 PM, Catalin Marinas wrote:
>>>> I think you are missing Ingo's point. It's not about the scheduler
>>>> complying with decisions made by various governors in the kernel
>>>> (which may or may not have enough information) but rather the
>>>> scheduler being in a better position for making such decisions.
>>>
>>> My mail pointed out that I disagree with this design ("the scheduler
>>> being in a better position for making such decisions").
>>> I think it should be a 2 way co-operation. I have elaborated below.
> 
> I agree with that.
> 
>>>> Take the cpuidle example, it uses the load average of the CPUs,
>>>> however this load average is currently controlled by the scheduler
>>>> (load balance). Rather than using a load average that degrades over
>>>> time and gradually putting the CPU into deeper sleep states, the
>>>> scheduler could predict more accurately that a run-queue won't have
>>>> any work over the next x ms and ask for a deeper sleep state from the
>>>> beginning.
>>>
>>> How will the scheduler know that there will not be work in the near
>>> future? How will the scheduler ask for a deeper sleep state?
>>>
>>> My answer to the above two questions are, the scheduler cannot know how
>>> much work will come up. All it knows is the current load of the
>>> runqueues and the nature of the task (thanks to the PJT's metric). It
>>> can then match the task load to the cpu capacity and schedule the tasks
>>> on the appropriate cpus.
>>
>> The scheduler can decide to load a single CPU or cluster and let the
>> others idle. If the total CPU load can fit into a smaller number of CPUs
>> it could as well tell cpuidle to go into deeper state from the
>> beginning as it moved all the tasks elsewhere.
> 
> So why can't it do that today?  What's the problem?

The reason that scheduler does not do it today is due to the
prefer_sibling logic. The tasks within a core get distributed across
cores if they are more than 1, since the cpu power of a core is not high
enough to handle more than one task.

However at a socket level/ MC level (cluster at a low level), there can
be as many tasks as there are cores because the socket has enough CPU
capacity to handle them. But the prefer_sibling logic moves tasks across
socket/MC level domains even when load<=domain_capacity.

I think the reason why the prefer_sibling logic was introduced, is that
scheduler looks at spreading tasks across all the resources it has. It
believes keeping tasks within a cluster/socket level domain would mean
tasks are being throttled by having access to only the cluster/socket
level resources. Which is why it spreads.

The prefer_sibling logic is nothing but a flag set at domain level to
communicate to the scheduler that load should be spread across the
groups of this domain. In the above example across sockets/clusters.

But I think it is time we take another look at the prefer_sibling logic
and decide on its worthiness.

> 
>> Regarding future work, neither cpuidle nor the scheduler know this but
>> the scheduler would make a better prediction, for example by tracking
>> task periodicity.
> 
> Well, basically, two pieces of information are needed to make target idle
> state selections: (1) when the CPU (core or package) is going to be used
> next time and (2) how much latency for going back to the non-idle state
> can be tolerated.  While the scheduler knows (1) to some extent (arguably,
> it generally cannot predict when hardware interrupts are going to occur),
> I'm not really sure about (2).
> 
>>> As a consequence, it leaves certain cpus idle. The load of these cpus
>>> degrade. It is via this load that the scheduler asks for a deeper sleep
>>> state. Right here we have scheduler talking to the cpuidle governor.
>>
>> So we agree that the scheduler _tells_ the cpuidle governor when to go
>> idle (but not how deep).
> 
> It does indicate to cpuidle how deep it can go, however, by providing it with
> the information about when the CPU is going to be used next time (from the
> scheduler's perspective).
> 
>> IOW, the scheduler drives the cpuidle decisions. Two problems: (1) the
>> cpuidle does not get enough information from the scheduler (arguably this
>> could be fixed)
> 
> OK, so what information is missing in your opinion?
> 
>> and (2) the scheduler does not have any information about the idle states
>> (power gating etc.) to make any informed decision on which/when CPUs should
>> go idle.
> 
> That's correct, which is a drawback.  However, on some systems it may never
> have that information (because hardware coordinates idle states in a way that
> is opaque to the OS - e.g. by autopromoting deeper states when idle for
> sufficiently long time) and on some systems that information may change over
> time (i.e. the availablility of specific idle states may depend on factors
> that aren't constant).
> 
> If you attempted to take all of the possible complications related to hardware
> designs in that area in the scheduler, you'd end up with completely
> unmaintainable piece of code.
> 
>> As you said, it is a non-optimal one-way communication but the solution
>> is not feedback loop from cpuidle into scheduler. It's like the
>> scheduler managed by chance to get the CPU into a deeper sleep state and
>> now you'd like the scheduler to get feedback form cpuidle and not
>> disturb that CPU anymore. That's the closed loop I disagree with. Could
>> the scheduler not make this informed decision before - it has this total
>> load, let's get this CPU into deeper sleep state?
> 
> No, it couldn't in general, for the above reasons.
> 
>>> I don't see what the problem is with the cpuidle governor waiting for
>>> the load to degrade before putting that cpu to sleep. In my opinion,
>>> putting a cpu to deeper sleep states should happen gradually.
> 
> If we know in advance that the CPU can be put into idle state Cn, there is no
> reason to put it into anything shallower than that.
> 
> On the other hand, if the CPU is in Cn already and there is a possibility to
> put it into a deeper low-power state (which we didn't know about before), it
> may make sense to promote it into that state (if that's safe) or even wake it
> up and idle it again.

Yes, sorry I said it wrong in the previous mail. Today the cpuidle
governor is capable of putting a CPU in idle state Cn directly, by
looking at various factors like the current load, next timer, history of
interrupts, exit latency of states. At the end of this evaluation it
puts it into idle state Cn.

Also it cares to check if its decision is right. This is with respect to
your statement "if there is a possibility to put it into deeper low
power state". It queues a timer at a time just after its predicted wake
up time before putting the cpu to idle state. If this time of wakeup
prediction is wrong, this timer triggers to wake up the cpu and the cpu
is hence put into a deeper sleep state.

> 
>>> This means time will tell the governors what kinds of workloads are running
>>> on the system. If the cpu is idle for long, it probably means that the system
>>> is less loaded and it makes sense to put the cpus to deeper sleep
>>> states. Of course there could be sporadic bursts or quieting down of
>>> tasks, but these are corner cases.
>>
>> It's nothing wrong with degrading given the information that cpuidle
>> currently has. It's a heuristics that worked ok so far and may continue
>> to do so. But see my comments above on why the scheduler could make more
>> informed decisions.
>>
>> We may not move all the power gating information to the scheduler but
>> maybe find a way to abstract this by giving more hints via the CPU and
>> cache topology. The cpuidle framework (it may not be much left of a
>> governor) would then take hints about estimated idle time and invoke the
>> low-level driver about the right C state.
> 
> Overall, it looks like it'd be better to split the governor "layer" between the
> scheduler and the idle driver with a well defined interface between them.  That
> interface needs to be general enough to be independent of the underlying
> hardware.
> 
> We need to determine what kinds of information should be passed both ways and
> how to represent it.

I agree with this design decision.

>>>> Of course, you could export more scheduler information to cpuidle,
>>>> various hooks (task wakeup etc.) but then we have another framework,
>>>> cpufreq. It also decides the CPU parameters (frequency) based on the
>>>> load controlled by the scheduler. Can cpufreq decide whether it's
>>>> better to keep the CPU at higher frequency so that it gets to idle
>>>> quicker and therefore deeper sleep states? I don't think it has enough
>>>> information because there are at least three deciding factors
>>>> (cpufreq, cpuidle and scheduler's load balancing) which are not
>>>> unified.
>>>
>>> Why not? When the cpu load is high, cpu frequency governor knows it has
>>> to boost the frequency of that CPU. The task gets over quickly, the CPU
>>> goes idle. Then the cpuidle governor kicks in to put the CPU to deeper
>>> sleep state gradually.
>>
>> The cpufreq governor boosts the frequency enough to cover the load,
>> which means reducing the idle time. It does not know whether it is
>> better to boost the frequency twice as high so that it gets to idle
>> quicker. You can change the governor's policy but does it have any
>> information from cpuidle?
> 
> Well, it may get that information directly from the hardware.  Actually,
> intel_pstate does that, but intel_pstate is the governor and the scaling
> driver combined.

To add to this, cpufreq currently functions in the below fashion. I am
talking of the on demand governor, since it is more relevant to our
discussion.

----stepped up frequency------
  ----threshold--------
      -----stepped down freq level1---
        -----stepped down freq level2---
          ---stepped down freq level3----

If the cpu idle time is below a threshold , it boosts the frequency to
one level above straight away and does not vary it any further. If the
cpu idle time is below a threshold there is a step down in frequency
levels by 5% of the current frequency at every sampling period, provided
the cpu behavior is constant.

I think we can improve this implementation by better interaction with
cpuidle and scheduler.

When it is stepping up frequency, it should do it in steps of frequency
being a *function of the current cpu load* also, or function of idle
time will also do.

When it is stepping down frequency, it should interact with cpuidle. It
should get from cpuidle information regarding the idle state that the
cpu is in.The reason is cpufrequency governor is aware of only the idle
time of the cpu, not the idle state it is in. If it gets to know that
the cpu is in a deep idle state, it could step down frequency levels to
leveln straight away. Just like cpuidle does to put cpus into state Cn.

Or an alternate option could be just like stepping up, make the stepping
down also a function of idle time. Perhaps
fn(|threshold-idle_time|).

Also one more point to note is that if cpuidle puts cpus into such idle
states that clock gate the cpus, then there is no need for cpufrequency
governor for that cpu. cpufreq can check with cpuidle on this front
before it queries a cpu.

> 
>>> Meanwhile the scheduler should ensure that the tasks are retained on
>>> that CPU,whose frequency is boosted and should not load balance it, so
>>> that they can get over quickly. This I think is what is missing. Again
>>> this comes down to the scheduler taking feedback from the CPU frequency
>>> governors which is not currently happening.
>>
>> Same loop again. The cpu load goes high because (a) there is more work,
>> possibly triggered by external events, and (b) the scheduler decided to
>> balance the CPUs in a certain way. As for cpuidle above, the scheduler
>> has direct influence on the cpufreq decisions. How would the scheduler
>> know which CPU not to balance against? Are CPUs in a cluster
>> synchronous? Is it better do let other CPU idle or more efficient to run
>> this cluster at half-speed?
>>
>> Let's say there is an increase in the load, does the scheduler wait
>> until cpufreq figures this out or tries to take the other CPUs out of
>> idle? Who's making this decision? That's currently a potentially
>> unstable loop.
> 
> Yes, it is and I don't think we currently have good answers here.

My answer to the above question is scheduler does not wait until cpufreq
figures it out. All that the scheduler cares about today is load
balancing. Spread the load and hope it finishes soon. There is a
possibility today that even before cpu frequency governor can boost the
frequency of cpu, the scheduler can spread the load.

As for the second question it will wakeup idle cpus if it must to load
balance.

It is a good question asked: "does the scheduler wait until cpufreq
figures it out." Currently the answer is no, it does not communicate
with cpu frequency at all (except through cpu power, but that is the
good part of the story, so I will not get there now). But maybe we
should change this. I think we can do so the following way.

When can a scheduler talk to cpu frequency? It can do so under the below
circumstances:

1. Load is too high across the systems, all cpus are loaded, no chance
of load balancing. Therefore ask cpu frequency governor to step up
frequency to get improve performance.

2. The scheduler finds out that if it has to load balance, it has to do
so on cpus which are in deep idle state( Currently this logic is not
present, but worth getting it in). It then decides to increase the
frequency of the already loaded cpus to improve performance. It calls
cpu freq governor.

3. The scheduler finds out that if it has to load balance, it has to do
so on a different power domain which is idle currently(shallow/deep). It
thinks the better of it and calls cpu frequency governor to boost the
frequency of the cpus in the current domain.

While 2 and 3 depend on scheduler having knowledge about idle states and
power domains, which it currently does not have, 1 can be achieved with
the current code. scheduler keeps track of failed ld balancing efforts
with lb_failed. If it finds that while load balancing from busy group
failed (lb_failed > 0), it can call cpu freq governor to step up the cpu
frequency of this busy cpu group, with gov_check_cpu() in cpufrequency
governor code.

> 
> The results of many measurements seem to indicate that it generally is better
> to do the work as quickly as possible and then go idle again, but there are
> costs associated with going back and forth from idle to non-idle etc.

I think we can even out the cost benefit of race to idle, by choosing to
do it wisely. Like for example if points 2 and 3 above are true (idle
cpus are in deep sleep states or need to ld balance on a different power
domain), then step up the frequency of the current working cpus and reap
its benefit.

> 
> The main problem with cpufreq that I personally have is that the governors
> carry out their own sampling with pretty much arbitrary resolution that may
> lead to suboptimal decisions.  It would be much better if the scheduler
> indicated when to *consider* the changing of CPU performance parameters (that
> may not be frequency alone and not even frequency at all in general), more or
> less the same way it tells cpuidle about idle CPUs, but I'm not sure if it
> should decide what performance points to run at.

Very true. See the points 1,2 and 3 above where I list out when
scheduler can call cpu frequency. Also an idea about how cpu frequency
governor can decide on the scaling frequency is stated above.

> 
>>>>> I would repeat here that today we interface cpuidle/cpufrequency
>>>>> policies with scheduler but not the other way around. They do their bit
>>>>> when a cpu is busy/idle. However scheduler does not see that somebody
>>>>> else is taking instructions from it and comes back to give different
>>>>> instructions!
>>>>
>>>> The key here is that cpuidle/cpufreq make their primary decision based
>>>> on something controlled by the scheduler: the CPU load (via run-queue
>>>> balancing). You would then like the scheduler take such decision back
>>>> into account. It just looks like a closed loop, possibly 'unstable' .
>>>
>>> Why? Why would you call a scheduler->cpuidle->cpufrequency interaction a
>>> closed loop and not the new_scheduler = scheduler+cpuidle+cpufrequency a
>>> closed loop? Here too the scheduler should be made well aware of the
>>> decisions it took in the past right?
>>
>> It's more like:
>>
>> scheduler -> cpuidle/cpufreq -> hardware operating point
>>    ^                                      |
>>    +--------------------------------------+
>>
>> You can argue that you can make an adaptive loop that works fine but
>> there are so many parameters that I don't see how it would work. The
>> patches so far don't seem to address this. Small task packing, while
>> useful, it's some heuristics just at the scheduler level.
> 
> I agree.
> 
>> With a combined decision maker, you aim to reduce this separate decision
>> process and feedback loop. Probably impossible to eliminate the loop
>> completely because of hardware latencies, PLLs, CPU frequency not always
>> the main factor, but you can make the loop more tolerant to
>> instabilities.
> 
> Well, in theory. :-)
> 
> Another question to ask is whether or not the structure of our software
> reflects the underlying problem.  I mean, on the one hand there is the
> scheduler that needs to optimally assign work items to computational units
> (hyperthreads, CPU cores, packages) and on the other hand there's hardware
> with different capabilities (idle states, performance points etc.).  Arguably,
> the scheduler internals cannot cover all of the differences between all of the
> existing types of hardware Linux can run on, so there needs to be a layer of
> code providing an interface between the scheduler and the hardware.  But that
> layer of code needs to be just *one*, so why do we have *two* different
> frameworks (cpuidle and cpufreq) that talk to the same hardware and kind of to
> the scheduler, but not to each other?
> 
> To me, the reason is history, and more precisely the fact that cpufreq had been
> there first, then came cpuidle and only then poeple started to realize that
> some scheduler tweaks may allow us to save energy without sacrificing too
> much performance.  However, it looks like there's time to go back and see how
> we can integrate all that.  And there's more, because we may need to take power
> budgets and thermal management into account as well (i.e. we may not be allowed
> to use full performance of the processors all the time because of some
> additional limitations) and the CPUs may be members of power domains, so what
> we can do with them may depend on the states of other devices.
> 
>>>> So I think we either (a) come up with 'clearer' separation of
>>>> responsibilities between scheduler and cpufreq/cpuidle 
>>>
>>> I agree with this. This is what I have been emphasizing, if we feel that
>>> the cpufrequency/ cpuidle subsystems are suboptimal in terms of the
>>> information that they use to make their decisions, let us improve them.
>>> But this will not yield us any improvement if the scheduler does not
>>> have enough information. And IMHO, the next fundamental information that
>>> the scheduler needs should come from cpufreq and cpuidle.
>>
>> What kind of information? Your suggestion that the scheduler should
>> avoid loading a CPU because it went idle is wrong IMHO. It went idle
>> because the scheduler decided this in first instance.
>>
>>> Then we should move onto supplying scheduler information from the power
>>> domain topology, thermal factors, user policies.
>>
>> I agree with this but at this point you get the scheduler to make more
>> informed decisions about task placement. It can then give more precise
>> hints to cpufreq/cpuidle like the predicted load and those frameworks
>> could become dumber in time, just complying with the requested
>> performance level (trying to break the loop above).
> 
> Well, there's nothing like "predicted load".  At best, we may be able to make
> more or less educated guesses about it, so in my opinion it is better to use
> the information about what happened in the past for making decisions regarding
> the current settings and re-adjust them over time as we get more information.

Agree with this as well. scheduler can at best supply information
regarding the historic load and hope that it is what defines the future
as well. Apart from this I dont know what other information scheduler
can supply cpuidle governor with.
> 
> So how much decision making regarding the idle state to put the given CPU into
> should be there in the scheduler?  I believe the only information coming out
> of the scheduler regarding that should be "OK, this CPU is now idle and I'll
> need it in X nanoseconds from now" plus possibly a hint about the wakeup
> latency tolerance (but those hints may come from other places too).  That said
> the decision *which* CPU should become idle at the moment very well may require
> some information about what options are available from the layer below (for
> example, "putting core X into idle for Y of time will save us Z energy" or
> something like that).

Agree. Except that the information should be "Ok , this CPU is now idle
and it has not done much work in the recent past,it is a 10% loaded CPU".

This can be said today using PJT's metric. It is now for the cpuidle
governor to decide the idle state to go to. Thats what happens today too.

> 
> And what about performance scaling?  Quite frankly, in my opinion that
> requires some more investigation, because there still are some open questions
> in that area.  To start with we can just continue using the current heuristics,
> but perhaps with the scheduler calling the scaling "governor" when it sees fit
> instead of that "governor" running kind of in parallel with it.

Exactly. How this can be done is elaborated above. This is one of the
key things we need today,IMHO.

> 
>>>> or (b) come up
>>>> with a unified load-balancing/cpufreq/cpuidle implementation as per
>>>> Ingo's request. The latter is harder but, with a good design, has
>>>> potentially a lot more benefits.
>>>>
>>>> A possible implementation for (a) is to let the scheduler focus on
>>>> performance load-balancing but control the balance ratio from a
>>>> cpufreq governor (via things like arch_scale_freq_power() or something
>>>> new). CPUfreq would not be concerned just with individual CPU
>>>> load/frequency but also making a decision on how tasks are balanced
>>>> between CPUs based on the overall load (e.g. four CPUs are enough for
>>>> the current load, I can shut the other four off by telling the
>>>> scheduler not to use them).
>>>>
>>>> As for Ingo's preferred solution (b), a proposal forward could be to
>>>> factor the load balancing out of kernel/sched/fair.c and provide an
>>>> abstract interface (like load_class?) for easier extending or
>>>> different policies (e.g. small task packing). 
>>>
>>>  Let me elaborate on the patches that have been posted so far on the
>>> power awareness of the scheduler. When we say *power aware scheduler*
>>> what exactly do we want it to do?
>>>
>>> In my opinion, we want it to *avoid touching idle cpus*, so as to keep
>>> them in that state longer and *keep more power domains idle*, so as to
>>> yield power savings with them turned off. The patches released so far
>>> are striving to do the latter. Correct me if I am wrong at this.
>>
>> Don't take me wrong, task packing to keep more power domains idle is
>> probably in the right direction but it may not address all issues. You
>> realised this is not enough since you are now asking for the scheduler
>> to take feedback from cpuidle. As I pointed out above, you try to create
>> a loop which may or may not work, especially given the wide variety of
>> hardware parameters.
>>
>>> Also
>>> feel free to point out any other expectation from the power aware
>>> scheduler if I am missing any.
>>
>> If the patches so far are enough and solved all the problems, you are
>> not missing any. Otherwise, please see my view above.
>>
>> Please define clearly what the scheduler, cpufreq, cpuidle should be
>> doing and what communication should happen between them.
>>
>>> If I have got Ingo's point right, the issues with them are that they are
>>> not taking a holistic approach to meet the said goal.
>>
>> Probably because scheduler changes, cpufreq and cpuidle are all trying
>> to address the same thing but independent of each other and possibly
>> conflicting.
>>
>>> Keeping more power
>>> domains idle (by packing tasks) would sound much better if the scheduler
>>> has taken all aspects of doing such a thing into account, like
>>>
>>> 1. How idle are the cpus, on the domain that it is packing
>>> 2. Can they go to turbo mode, because if they do,then we cant pack
>>> tasks. We would need certain cpus in that domain idle.
>>> 3. Are the domains in which we pack tasks power gated?
>>> 4. Will there be significant performance drop by packing? Meaning do the
>>> tasks share cpu resources? If they do there will be severe contention.
>>
>> So by this you add a lot more information about the power configuration
>> into the scheduler, getting it to make more informed decisions about
>> task scheduling. You may eventually reach a point where cpuidle governor
>> doesn't have much to do (which may be a good thing) and reach Ingo's
>> goal.
>>
>> That's why I suggested maybe starting to take the load balancing out of
>> fair.c and make it easily extensible (my opinion, the scheduler guys may
>> disagree). Then make it more aware of topology, power configuration so
>> that it makes the right task placement decision. You then get it to
>> tell cpufreq about the expected performance requirements (frequency
>> decided by cpufreq) and cpuidle about how long it could be idle for (you
>> detect a periodic task every 1ms, or you don't have any at all because
>> they were migrated, the right C state being decided by the governor).
> 
> There is another angle to look at that as I said somewhere above.
> 
> What if we could integrate cpuidle with cpufreq so that there is one code
> layer representing what the hardware can do to the scheduler?  What benefits
> can we get from that, if any?

We could debate on this point. I am a bit confused about this. As I see
it, there is no problem with keeping them separately. One, because of
code readability; it is easy to understand what are the different
parameters that the performance of CPU depends on, without needing to
dig through the code. Two, because cpu frequency kicks in during runtime
primarily and cpuidle during idle time of the cpu.

But this would also mean creating well defined interfaces between them.
Integrating cpufreq and cpuidle seems like a better argument to make due
to their common functionality at a higher level of talking to hardware
and tuning the performance parameters of cpu. But I disagree that
scheduler should be put into this common framework as well as it has
functionalities which are totally disjoint from what subsystems such as
cpuidle and cpufreq are intended to do.
> 
> Rafael
> 
> 

Regards
Preeti U Murthy

