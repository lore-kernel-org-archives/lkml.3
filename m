Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3GPSoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:44:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:26711 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766Ab3GPSoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="346584862"
Message-ID: <51E5947F.4090109@linux.intel.com>
Date: Tue, 16 Jul 2013 11:44:15 -0700
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
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45E8B.705@linux.intel.com> <20130715210650.GF23818@dyad.programming.kicks-ass.net> <20130715211230.GG23818@dyad.programming.kicks-ass.net> <51E47D30.5030203@linux.intel.com> <20130716173848.GA22795@dyad.programming.kicks-ass.net>
In-Reply-To: <20130716173848.GA22795@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2013 10:38 AM, Peter Zijlstra wrote:
> On Mon, Jul 15, 2013 at 03:52:32PM -0700, Arjan van de Ven wrote:
>
>> yeah ondemand does this, but ondemand is actually a pretty bad governor.
>> not because of the sampling, but because of its algorithm.
>
> Is it good for any class of hardware still out there? Or should the thing be
> shot in the head?

for Intel, it's not too bad for anything predating Nehalem.


> You saying AMD patched the thing makes me confused; why would they patch a
> piece of crap?

it's still an improvement over something that's in use ;-)

>
>> HOWEVER, on modern CPUs, even many of the ARM ones, the frequency
>> when you're idle is zero anyway regardless of what you as OS ask for.
>
> Right, entire cores are power gated.
>
> So power wise the voltage you run at is important; so for hardware where lower
> frequencies allow lower voltage, does it still make sense to run the lowest
> possible voltage such that there is still some idle time?
>
> Or is the fact that you're running so much longer negating the power save from
> the lower voltage?

the race-to-idle argument again ;-)

>
>> Every 10 (or 100) milliseconds, ondemand makes a new P state decision.
>> It does this by asking the scheduler the time used, does a delta and
>> ends up at a utilization %age which then goes into a formula.
>> It's not that ondemand samples inbetween decision moments to see if the system
>> is busy or not; the microaccounting that the scheduler does is used instead,
>> and only at decision moments.
>
> OK.. So up to now you've mostly said what you want of the scheduler to make a
> better governor for the new Intel chips.
>
> However a power aware scheduler/balancer needs to interact with the policy as a
> whole; and I got confused by the fact that you never talked about
> raising/lowering speeds. As said there's already a very 'fine' problem where
> the cpufreq interacts with the utilization/runnable accounting we now do.

the interaction is "using the scheduler data using the scheduler provided function".

So I don't just want something that makes sense for todays Intel ;-)
We need something that has an interface that makes sense, where the things
that vary between chip generations/vendors are on the driver side
of the interface, and the things that are generic concepts or generically
enough useful are on the core side of the interface. Hardware has changed,
and hardware will be changing for all vendors for as far as we can even see
into the future, since power matters in the market a lot.
This means we need a level of interface that has some chance of being useful
for at least a while.

What frequency to run at is for me clearly a driver side thing since what
goes into choosing a P state that may translate into a frequency is a hardware
specific choice; the translation from "I need at least this much performance
and be power efficient at that" to a hardware register write is very hardware specific.

Things like "I need more compute capacity" or "This is very performance critical" or
"This is very latency critical" are a generic concepts.
As is "behavior is now changed a lot in <this direction>" as a callback kind of thing.
(just as "I no longer need it" is a generic concept to complement the first one)

The scheduler already has the utilization interfaces that are high enough level
for those who want to use utilization on the driver side to guide their hw decisions
(ondemand does not keep its own utilization, it uses straight scheduler data
for that); the very thin layer that ondemand and co add on top is the
percentage = (usage_at_time_b - usage_at_time_a) / (elapsed time) * 100%
formula so that they can do this over the interval of their choosing.
You can argue that the scheduler can do this; that's for me a small detail that we could
do either way; it's not anything relevant in the big picture.
With intervals being quite variable it might make sense to keep it on the driver side
just because its hard to put this one formula into a nice interface.







