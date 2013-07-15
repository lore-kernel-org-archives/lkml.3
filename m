Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3GOUhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:37:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:46474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab3GOUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:37:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,671,1367996400"; 
   d="scan'208";a="370670328"
Message-ID: <51E45D98.7040404@linux.intel.com>
Date: Mon, 15 Jul 2013 13:37:44 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130715195914.GC23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/2013 12:59 PM, Peter Zijlstra wrote:

>> this is where it gets complicated ;-( the race-to-idle depends on the type of
>> code that is running, if things are memory bound it's outright not true, but
>> for compute bound it often is.
>
> So you didn't actually answer the question about when you'd program a less than
> max P state. Your recommended interface also glaringly lacks the
> arch_please_go_slower_noaw() function.

an arch_you_may_go_slower_now() might make sense, sure.
(I am not aware of anything DEMANDING to go slower, unlike the go faster side of things)
I can see that be useful when you stop running that realtime task
or similar conditions.

Alternative would be to make the "go faster" side be a lease kind of thing
that you can later cancel.

> So you can program any P state; but the hardware is free do as it pleases but
> not slower than the lowest P state. So clearly the hardware is 'smart'.

any device on the market has some level of smarts there, just by virtue of dual core
and on board graphics. Even the ARM world has various smarts there (and will get more
no doubt over time)

> Going by your interface there's also not much influence as to where the 'power'
> goes; can we for example force the GPU to clock lower in order to 'free' up
> power for cores?

I would love that to be the case. And the GPU driver certainly has some knobs/influence
there. That being separate from CPU PM is one of the huge holes we have today
(much more so than the whole scheduler-vs-power thing)


> If we can, we should very much include that in the entire discussion.

absolute. Note that it's not an easy topic, as in... very much unsolved
anywhere and everywhere, and not for lack of trying.

>> What I would like to see is
>>
>> 1) Move the idle predictor logic into the scheduler, or at least a library
>>     (I'm not sure the scheduler can do better than the current code, but it might,
>>      and what menu does today is at least worth putting in some generic library)
>
> Right, so the idea is that these days we have much better task runtime
> behaviour tracking than we used to have and this might help. I also realize the
> idle guestimator uses more than just task activity, interrupt activity is also
> very important.

when I wrote that part of the menu governor, it was ALL about interrupts.
the task side is well known, at least in the short term, since we know
that that will come via a timer.
(I'm counting IPI's as interrupts here)

Now, the other half of this is the "how performance sensitive are we", and I sure
hope the scheduler has a better idea than the menu governor....


> Not sure calling it a generic library would be wise; that has such an optional
> sound to it. The thing we want to avoid is people brewing their own etc..

well, if it works well, people will use it.
if it sucks horribly, people won't and make something else...
... after which we turn that into the library function.
If the concepts and interfaces are at the right level, that can be done.

Especially for things like "when do we expect the next event to pull us out of idle",
that's a very generic concept that is not hardware dependent....


> Also, my interest in it is that the scheduler wants to use it; and when we go
> do power aware scheduling I feel it should live very near the scheduler if not
> in the scheduler for the simple reason that part of being power aware is trying
> to stay idle as long as possible; the idle guestimator is the measure of that.
>
> So in that sense they are closely related.

yeah as I said, I can see the point of turning this more generic.
I can even see the block layer or the GPU layer give input as well.

>
>> 2) An interface between scheduler and P state code in the form of (and don't take the names as actual function names ;-)
>>      void arch_please_go_fastest(void);   /* or maybe int cpunr as argument, but that's harder to implement */
>
> Here again, the only thing this allows is max P state race for idle. Why would
> Intel still pretend to have P states if they're so useless and mean so little?

race-to-idle is not universal, it depends on what type of instructions are being executed
(memory versus compute) and slightly on the physics.
>
>>      int arch_can_you_go_faster(void);  /* if the scheduler would like to know this instead of load balancing .. unsure */
>
> You said Intel could not say if it were at the max P state; so how could it
> possibly answer this one?

we do know if we asked for max... since it was us asking.


>
>>      unsigned long arch_instructions_executed(void); /* like tsc, but on instructions, so the scheduler can account actual work done */
>
> To what purpose? People mostly still care about wall-time for things like
> response and such. Also, its not something most arch will be able to provide
> without sacrificing a PMU counter if they even have such a thing. Also not
> everybody is as 'fast' in reading PMU state as one would like.

well, right now for various scheduler priorities we use "time" as a metric for
timeslicing/etc without regard for the cpu performance at the time.
There likely is room for a different measure for "system capacity used"
that is a bit more finegrained than just time. Time is not bad,
and if there's no cheap special HW, it'll do... but I can see value for
doing something more advanced. Surely the big.little guys want this
(more than I'd want it)



>>
>>    the first one is for the scheduler to call when it sees a situation of "we
>>    care deeply about performance now" coming, for example near overload, or
>>    when a realtime (or otherwise high priority) task gets scheduled.  the
>>    second one I am dubious about, but maybe you have a use for it; some folks
>>    think that there is value in deciding to ramp up the performance rather
>>    than load balancing. For load balancing to an idle cpu, I don't see that
>>    value (in terms of power efficiency) but I do see a case where your 2 cores
>>    happen to be busy (some sort of thundering herd effect) but imbalanced; in
>>    that case going faster rather than rebalance... I can certainly see the
>>    point.
>
> (reformatted to 80 col text)
>
> The entire scheme seems to disregards everybody who doesn't have a 'smart'
> micro controller doing the P state management. Some people will have to
> actually control the cpufreq.

that is ok, but the whole point is to make that control part of the hardware
specific driver side. The interface from the scheduler should be generic
enough that you can plug in various hardware specific parts on the other side.
Most certainly different CPU chips will use different algorithms over time.
(and of course there will be a library of such algorithms so that not every
cpu vendor/implementation has to reinvent the wheel from scratch).

heck, Linus waaay back insisted on this for cpufreq, since the Transmeta
cpus at the time did most of this purely in "hardware".


>> 3) an interface from the C state hardware driver to the scheduler to say "oh
>> btw, the LLC got flushed, forget about past cache affinity". The C state
>> driver can sometimes know this.. and linux today tries to keep affinity
>> anyway while we could get more optimal by being allowed to balance more
>> freely
>
> This shouldn't be hard to implement at all.

great!
Do you think it's worth having on the scheduler side? E.g. does it give you
more freedom in placement?
It's not completely free to get (think "an MSR read") and
there's the interesting question if this would be a per cpu
or a global statement... but we can get this

And at least for client systems (read: relatively low core counts) the cache
will get flushed quite a lot on Intel.
(and then refilled quickly of course)

>> 4) this is the most important one, but like the hardest one: An interface
>> from the scheduler that says "we are performance sensitive now": void
>> arch_sched_performance_sensitive(int duration_ms);
>>
>>     I've put a duration as argument, rather than a "arch_no_longer_sensitive",
>>     to avoid for the scheduler to run some periodic timer/whatever to keep
>>     this; rather it is sort of a "lease", that the scheduler can renew as
>>     often as it wants; but it auto-expires eventually.
>>
>>     with this the hardware and/or hardware drivers can make a performance bias
>>     in their decisions based on what is actually the driving force behind both
>>     P and C state decisions: performance sensitivity.  (all this utilization
>>     stuff menu but also the P state drivers try to do is estimating how
>>     sensitive we are to performance, and if we're not sensitive, consider
>>     sacrificing some performance for power. Even with race-to-halt, sometimes
>>     sacrificing a little performance gives a power benefit at the top of the
>>     range)
>
> Right, trouble is of course we have nothing to base this on. Our task model
> completely lacks any clue for this. And the problem with introducing something
> like that would also be that I suspect that within a few years every single
> task on the system would find itself 'important'.

there are some clear cases we can do.
but yes it's hard.
BUT we try to do the same thing today implicitly. Basically "using cpu time" is
used as proxy for performance sensitive in the "ondemand" governor.


>> there is a time below which waking up a core (not hyperthread pair, that is
>> ALWAYS worth it since it's insanely cheap) is not worth it.  Think in the
>> order of "+/- 50 microseconds".
>
> OK.
>
>>> Also, most what you say for single socket systems; what does Intel want for
>>> multi-socket systems?
>>
>> for multisocket, rule number one is "don't screw up numa".
>> for tasks where numa matters, that's the top priority.
>
> OK, so again, make sure to get the work done as quickly as possible and go idle
> again.

it's more about "don't run inefficient".
If you run, say, 10% less efficient than you could, any power saving feature will
first need to make up those 10% before it starts winning.

A simple example would be bubble sort versus quicksort for a sizable data set.
If some theoretical CPU could run bubble sort instructions faster than quicksort instructions,
it's still a bad idea due to the general inefficiency of bubble sort.

Doing NUMA badly is not quite THAT bad, but still, it causes quite big inefficiencies
for tasks where NUMA matters... and winning that back in power tricks is going to be hard.



