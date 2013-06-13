Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3FMEfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:35:11 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59764 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3FMEfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:35:07 -0400
Message-ID: <51B94B6D.5090604@linux.vnet.ibm.com>
Date: Thu, 13 Jun 2013 10:02:45 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        David Lang <david@lang.hm>, daniel.lezcano@linaro.org,
        Amit Kucheria <amit.kucheria@linaro.org>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: power-efficient scheduling design
References: <20130530134718.GB32728@e103034-lin> <1834293.MlyIaiESPL@vostro.rjw.lan> <51B3F99A.4000101@linux.vnet.ibm.com> <3381787.jv4tpnigj7@vostro.rjw.lan>
In-Reply-To: <3381787.jv4tpnigj7@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061304-6102-0000-0000-000003B02743
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/11/2013 06:20 AM, Rafael J. Wysocki wrote:
> 
> OK, so let's try to take one step more and think about what part should belong
> to the scheduler and what part should be taken care of by the "idle" driver.
> 
> Do you have any specific view on that?

I gave it some thought and went through Ingo's mail once again. I have
some view points which I have stated at the end of this mail.

>>>>>> Of course, you could export more scheduler information to cpuidle,
>>>>>> various hooks (task wakeup etc.) but then we have another framework,
>>>>>> cpufreq. It also decides the CPU parameters (frequency) based on the
>>>>>> load controlled by the scheduler. Can cpufreq decide whether it's
>>>>>> better to keep the CPU at higher frequency so that it gets to idle
>>>>>> quicker and therefore deeper sleep states? I don't think it has enough
>>>>>> information because there are at least three deciding factors
>>>>>> (cpufreq, cpuidle and scheduler's load balancing) which are not
>>>>>> unified.
>>>>>
>>>>> Why not? When the cpu load is high, cpu frequency governor knows it has
>>>>> to boost the frequency of that CPU. The task gets over quickly, the CPU
>>>>> goes idle. Then the cpuidle governor kicks in to put the CPU to deeper
>>>>> sleep state gradually.
>>>>
>>>> The cpufreq governor boosts the frequency enough to cover the load,
>>>> which means reducing the idle time. It does not know whether it is
>>>> better to boost the frequency twice as high so that it gets to idle
>>>> quicker. You can change the governor's policy but does it have any
>>>> information from cpuidle?
>>>
>>> Well, it may get that information directly from the hardware.  Actually,
>>> intel_pstate does that, but intel_pstate is the governor and the scaling
>>> driver combined.
>>
>> To add to this, cpufreq currently functions in the below fashion. I am
>> talking of the on demand governor, since it is more relevant to our
>> discussion.
>>
>> ----stepped up frequency------
>>   ----threshold--------
>>       -----stepped down freq level1---
>>         -----stepped down freq level2---
>>           ---stepped down freq level3----
>>
>> If the cpu idle time is below a threshold , it boosts the frequency to
> 
> Did you mean "above the threshold"?

No I meant "above". I am referring to the cpu *idle* time.

>> Also an idea about how cpu frequency governor can decide on the scaling
>> frequency is stated above.
> 
> Actaully, intel_pstate uses a PID controller for making those decisions and
> I think this may be just the right thing to do.

But don't you think we need to include the current cpu load during this
decision making as well? I mean a fn(idle_time) logic in cpu frequency
governor, which is currently absent. Today, it just checks if idle_time
< threshold, and sets one specific frequency. Of course the PID could
then make the decision about the frequencies which can be candidates for
scaling up, but cpu freq governor could decide which among these to pick
based on fn(idle_time) .

> 
> [...]
> 
>>>
>>> Well, there's nothing like "predicted load".  At best, we may be able to make
>>> more or less educated guesses about it, so in my opinion it is better to use
>>> the information about what happened in the past for making decisions regarding
>>> the current settings and re-adjust them over time as we get more information.
>>
>> Agree with this as well. scheduler can at best supply information
>> regarding the historic load and hope that it is what defines the future
>> as well. Apart from this I dont know what other information scheduler
>> can supply cpuidle governor with.
>>>
>>> So how much decision making regarding the idle state to put the given CPU into
>>> should be there in the scheduler?  I believe the only information coming out
>>> of the scheduler regarding that should be "OK, this CPU is now idle and I'll
>>> need it in X nanoseconds from now" plus possibly a hint about the wakeup
>>> latency tolerance (but those hints may come from other places too).  That said
>>> the decision *which* CPU should become idle at the moment very well may require
>>> some information about what options are available from the layer below (for
>>> example, "putting core X into idle for Y of time will save us Z energy" or
>>> something like that).
>>
>> Agree. Except that the information should be "Ok , this CPU is now idle
>> and it has not done much work in the recent past,it is a 10% loaded CPU".
> 
> And what would that be useful for to the "idle" layer?  What matters is the
> "I'll need it in X nanoseconds from now" part.
> 
> Yes, the load part would be interesting to the "frequency" layer.

>>> What if we could integrate cpuidle with cpufreq so that there is one code
>>> layer representing what the hardware can do to the scheduler?  What benefits
>>> can we get from that, if any?
>>
>> We could debate on this point. I am a bit confused about this. As I see
>> it, there is no problem with keeping them separately. One, because of
>> code readability; it is easy to understand what are the different
>> parameters that the performance of CPU depends on, without needing to
>> dig through the code. Two, because cpu frequency kicks in during runtime
>> primarily and cpuidle during idle time of the cpu.
> 
> That's a very useful observation.  Indeed, there's the "idle" part that needs
> to be invoked when the CPU goes idle (and it should decide what idle state to
> put that CPU into), and there's the "scaling" part that needs to be invoked
> when the CPU has work to do (and it should decide what performance point to
> put that CPU into).  The question is, though, if it's better to have two
> separate frameworks for those things (which is what we have today) or to make
> them two parts of the same framework (like two callbacks one of which will be
> executed for CPUs that have just become idle and the other will be invoked
> for CPUs that have just got work to do).
> 
>> But this would also mean creating well defined interfaces between them.
>> Integrating cpufreq and cpuidle seems like a better argument to make due
>> to their common functionality at a higher level of talking to hardware
>> and tuning the performance parameters of cpu. But I disagree that
>> scheduler should be put into this common framework as well as it has
>> functionalities which are totally disjoint from what subsystems such as
>> cpuidle and cpufreq are intended to do.
> 
> That's correct.  The role of the scheduler, in my opinion, may be to call the
> "idle" and "scaling" functions at the right time and to give them information
> needed to make optimal choices.

Having looked at the points being brought about in this discussion and
the mail that Ingo sent out regarding his view points, I have a few
points to make.

David Lezcano made a valid point when he stated that we need to
*move cpufrequency and cpuidle governor logic into scheduler while
retaining their driver functionality in those subsystems.*

It is true that I was strongly against moving the governor logic into
the scheduler, thinking it would be simpler to enhance the communication
interface between the scheduler and the governors.
But having given this some thought,I think this would mean greater scope
for loopholes.

Catalin pointed it out well with an example, when he said in one of his
mails that, assuming scheduler ends up telling cpu frequency governor
when to boost/lower the frequency and note that scheduler is not aware
of the user policies that have gone in to decide if cpu frequency
governor actually does what the scheduler is asking it to do.

And it is only cpu frequency governor who is aware of these user
policies and not scheduler. So how long should the scheduler wait for
cpu frequency governor to boost the frequency? What if the user has
selected a powersave mode, and the cpu frequency cannot rise any
further? That would mean cpu frequency governor telling scheduler that
it can't do what the scheduler is asking it to do.
This decision of scheduler then is a waste of time,since it gets
rejected by the cpufrequency governor and nothing comes of it.

Very clearly the scheduler not being aware of the user policy is a big
drawback; had it known the user policies before hand it would not even
have considered boosting the cpu frequency of the cpu in question.

This point that Ingo made is something we need to look hard at."Today
the power saving landscape is fragmented." The scheduler today does not
know what in the world is the end result of its decisions. cpuidle and
cpu frequency could take decisions that is totally counter intuitive to
the scheduler's. Improving the communication between them would surely
mean we export more and more information back and forth for better
communication, whose end result would probably be to merge the governor
and scheduler. If this vision that "they will eventually get so close,
that we will end up merging them", is agreed upon, then it might be best
to merge them right away without wasting effort into adding logic that
tries to communicate between them or even trying to separate the
functionalities between scheduler and governors.

I don't think removing certain scheduler functionalities and putting it
instead into governors is the right thing to do. Scheduler's functions
are tightly coupled with one another. Breaking one will in my opinion
break a lot of things.

There have been points brought out strongly about how the scheduler
should have global view of cores so that it knows the effect on a socket
when it decides on what to do with a core for instance. This could be
the next step in its enhancement. Taking up one of the examples that
Daniel brought out:" Putting one of the cpus to idle state could lower
the frequency of the socket,thus hampering the exit latency of this idle
state ". (Not the exact words, but this is the point.)

Notice how in the above,if a scheduler were to be able to understand the
above statement, it needs to first off be aware of the cpu frequency and
idle state details. *Therefore as a first step we need better knowledge
in scheduler before it makes global decisions*.

Also note a scheduler cannot under the above circumstances talk back and
forth to the governors to begin to learn about idle states and
frequencies at that point. This simply does not make sense.(True at this
point I am heavily contradicting my previous arguments :P. I felt that
the existing communication is good enough and all that was needed a few
more additions, but that does not seem to be the case. )

Arjan also pointed out how the a task running on a slower core, should
be charged less than when it runs on a faster core. Right here is a use
case for scheduler to be aware of the cpu frequency of a core, since
today it is the one which charges a task, but is not aware of what cpu
frequency it is running on.(It is aware of cpu frequency of core through
cpu power stats, but it uses it only for load balancing today and not
when it charges a task for its run time).

My suggestion at this point is :

1. Begin to move the cpuidle and cpufreq *governor* logic into the
scheduler little by little.

2. Scheduler is already aware of the topology details, maybe enhance
that as the next step.

At this point, we would have a scheduler well aware of the effect of its
load balancing decisions to some extent.

3. Add the logic for the scheduler to get a global view of the cpufreq
and idle.

4. Then get system user policies (powersave/performance) to alter
scheduler behavior accordingly.

At this point if we bring in today's patchsets (power aware scheduling
and packing tasks), they could fetch us their intended benefits pretty
much in most cases as against sporadic behaviour, because
the scheduler is aware of the whole picture and will do what these
patches command only if it is right till the point of idle states and
cpu frequencies and not just till load balancing.

I would appreciate all of yours feedback on the above. I think at this
point we are in a position to judge what would be the next move in this
direction and make that move soon.


Regards
Preeti U Murthy



