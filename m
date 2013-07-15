Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3GOHxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:53:42 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52905 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3GOHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130713102350.GA8067@MacBook-Pro.local>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
	<20130713064909.GW25631@dyad.programming.kicks-ass.net>
	<20130713102350.GA8067@MacBook-Pro.local>
Date: Mon, 15 Jul 2013 09:53:39 +0200
Message-ID: <CAKfTPtDux60+o9iCh=+QOq_6OJydaGT3H1M2j7MPDk=uoeQB1Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 July 2013 12:23, Catalin Marinas <catalin.marinas@arm.com> wrote:
> Hi Peter,
>
> (Morten's away for a week, I'll try cover some bits in the meantime)
>
> On Sat, Jul 13, 2013 at 07:49:09AM +0100, Peter Zijlstra wrote:
>> On Tue, Jul 09, 2013 at 04:55:29PM +0100, Morten Rasmussen wrote:
>> > This patch set is an initial prototype aiming at the overall power-aware
>> > scheduler design proposal that I previously described
>> > <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
>> >
>> > The patch set introduces a cpu capacity managing 'power scheduler' which lives
>> > by the side of the existing (process) scheduler. Its role is to monitor the
>> > system load and decide which cpus that should be available to the process
>> > scheduler.
>>
>> Hmm...
>>
>> This looks like a userspace hotplug deamon approach lifted to kernel space :/
>
> The difference is that this is faster. We even had hotplug in mind some
> years ago for big.LITTLE but it wouldn't give the performance we need
> (hotplug is incredibly slow even if driven from the kernel).
>
>> How about instead of layering over the load-balancer to constrain its behaviour
>> you change the behaviour to not need constraint? Fix it so it does the right
>> thing, instead of limiting it.
>>
>> I don't think its _that_ hard to make the balancer do packing over spreading.
>> The power balance code removed in 8e7fbcbc had things like that (although it
>> was broken). And I'm sure I've seen patches over the years that did similar
>> things. Didn't Vincent and Alex also do things like that?
>>
>> We should take the good bits from all that and make something of it. And I
>> think its easier now that we have the per task and per rq utilization numbers
>> [1].
>
> That's what we've been pushing for. From a big.LITTLE perspective, I
> would probably vote for Vincent's patches but I guess we could probably
> adapt any of the other options.
>
> But then we got Ingo NAK'ing all these approaches. Taking the best bits
> from the current load balancing patches would create yet another set of
> patches which don't fall under Ingo's requirements (at least as I
> understand them).

In fact we are currently updating our patchset based on Ingo's
feedback. The move of cpuidle and cpufreq statistic was planned to
appear later in our dev but we are now integrating it based in Ingo's
request. We start with cpuidle statistics and are moving it into the
scheduler. In addition, we want to integrate the current C-state of a
core in the wake up decision.

>
>> Just start by changing the balancer to pack instead of spread. Once that works,
>> see where the two modes diverge and put a knob in.
>
> That's the approach we've had so far (not sure about the knob). But it
> doesn't solve Ingo's complain about fragmentation between scheduler,
> cpufreq and cpuidle policies.
>
>> Then worry about power thingies.
>
> To quote Ingo: "To create a new low level idle driver mechanism the
> scheduler could use and integrate proper power saving / idle policy into
> the scheduler."
>
> That's unless we all agree (including Ingo) that the above requirement
> is orthogonal to task packing and, as a *separate* project, we look at
> better integrating the cpufreq/cpuidle with the scheduler, possibly with
> a new driver model and governors as libraries used by such drivers. In
> which case the current packing patches shouldn't be NAK'ed but reviewed
> so that they can be improved further or rewritten.
>
>> The integration of cpuidle and cpufreq should start by unifying all the
>> statistics stuff. For cpuidle we need to pull in the per-cpu idle time
>> guestimator. For cpufreq the per-cpu usage stuff -- which we already have in
>> the scheduler these days!
>>
>> Once we have all the statistics in place, its also easier to see what we can do
>> with them and what might be missing.
>>
>> At this point mandate that policy drivers may not do any statistics gathering
>> of their own. If they feel the need to do so, we're missing something and
>> that's not right.
>
> I agree in general but there is the intel_pstate.c driver which has it's
> own separate statistics that the scheduler does not track. We could move
> to invariant task load tracking which uses aperf/mperf (and could do
> similar things with perf counters on ARM). As I understand from Arjan,
> the new pstate driver will be different, so we don't know exactly what
> it requires.
>
>> I'm not entirely sold on differentiating between short running and other tasks
>> either. Although I suppose I see where that comes from. A task that would run
>> 50% on a big core would unlikely be qualified as small, however if it would
>> require 85% of a small core and there's room on the small cores its a good move
>> to run it there.
>>
>> So where's the limit for being small? It seems like an artificial limit and
>> such should be avoided where possible.
>
> I agree. With Morten's approach, it doesn't care about how small a task
> is but rather when a CPU (or cluster) is loaded to a certain threshold,
> just spread tasks to the next. I think small task threshold on its own
> doesn't make much sense if you have lots of such 'small' tasks, so you
> need a view of the overall load or a more dynamic threshold.
>
> --
> Catalin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
