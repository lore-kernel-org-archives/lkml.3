Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3FLRdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:33:03 -0400
Received: from mail.lang.hm ([64.81.33.126]:46077 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab3FLRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:33:01 -0400
Date: Wed, 12 Jun 2013 09:30:12 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
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
In-Reply-To: <51B84461.9080901@linaro.org>
Message-ID: <alpine.DEB.2.02.1306120923050.5954@nftneq.ynat.uz>
References: <20130530134718.GB32728@e103034-lin> <51B221AF.9070906@linux.vnet.ibm.com> <20130608112801.GA8120@MacBook-Pro.local> <1834293.MlyIaiESPL@vostro.rjw.lan> <51B3F99A.4000101@linux.vnet.ibm.com> <51B5FE02.7040607@linaro.org>
 <alpine.DEB.2.02.1306111722470.24968@nftneq.ynat.uz> <51B84461.9080901@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Daniel Lezcano wrote:

>> On Mon, 10 Jun 2013, Daniel Lezcano wrote:
>>
>>> Some SoC can have a cluster of cpus sharing some resources, eg cache, so
>>> they must enter the same state at the same moment. Beside the
>>> synchronization mechanisms, that adds a dependency with the next event.
>>> For example, the u8500 board has a couple of cpus. In order to make them
>>> to enter in retention, both must enter the same state, but not necessary
>>> at the same moment. The first cpu will wait in WFI and the second one
>>> will initiate the retention mode when entering to this state.
>>> Unfortunately, some time could have passed while the second cpu entered
>>> this state and the next event for the first cpu could be too close, thus
>>> violating the criteria of the governor when it choose this state for the
>>> second cpu.
>>>
>>> Also the latencies could change with the frequencies, so there is a
>>> dependency with cpufreq, the lesser the frequency is, the higher the
>>> latency is. If the scheduler takes the decision to go to a specific
>>> state assuming the exit latency is a given duration, if the frequency
>>> decrease, this exit latency could increase also and lead the system to
>>> be less responsive.
>>>
>>> I don't know, how were made the latencies computation (eg. worst case,
>>> taken with the lower frequency or not) but we have just one set of
>>> values. That should happen with the current code.
>>>
>>> Another point is the timer allowing to detect bad decision and go to a
>>> deep idle state. With the cluster dependency described above, we may
>>> wake up a particular cpu, which turns on the cluster and make the entire
>>> cluster to wake up in order to enter a deeper state, which could fail
>>> because of the other cpu may not fulfill the constraint at this moment.
>>
>> Nobody is saying that this sort of thing should be in the fastpath of
>> the scheduler.
>>
>> But if the scheduler has a table that tells it the possible states, and
>> the cost to get from the current state to each of these states (and to
>> get back and/or wake up to full power), then the scheduler can make the
>> decision on what to do, invoke a routine to make the change (and in the
>> meantime, not be fighting the change by trying to schedule processes on
>> a core that's about to be powered off), and then when the change
>> happens, the scheduler will have a new version of the table of possible
>> states and costs
>>
>> This isn't in the fastpath, it's in the rebalancing logic.
>
> As Arjan mentionned it is not as simple as this.
>
> We want the scheduler to take some decisions with the knowledge of idle
> latencies. In other words move the governor logic into the scheduler.
>
> The scheduler can take decision and the backend driver provides the
> interface to go to the idle state.
>
> But unfortunately each hardware is behaving in different ways and
> describing such behaviors will help to find the correct design, I am not
> raising a lot of issues but just trying to enumerate the constraints we
> have.
>
> What is the correct decision when a lot of pm blocks are tied together
> and the
>
> In the example given by Arjan, the frequencies could be per cluster,
> hence decreasing the frequency for a core will decrease the frequency of
> the other core. So if the scheduler takes the decision to put one core
> into a specific idle state, regarding the target residency and the exit
> latency when the frequency is at max (the other core is doing
> something), and then the frequency decrease, the exit latency may
> increase in this case and the idle cpu will take more time to exit the
> idle state than expected thus adding latency to the system.
>
> What would be the correct decision in this case ? Wake up the idle cpu
> when the frequency change to re-evaluate an idle state ? Provide idle
> latencies for the min freq only ? Or is it acceptable to have such
> latency added when the frequency decrease ?
>
> Also, an interesting question is how do we get these latencies ?
>
> They are all written in the c-state tables but we don't know the
> accuracy of these values ? Were they measured with freq max / min ?
>
> Were they measured with a driver powering down the peripherals or without ?
>
> For the embedded systems, we may have different implementations and
> maybe different latencies. Would be makes sense to pass these values
> through a device tree and let the SoC vendor to specify the right values
> ? (IMHO, only the SoC vendor can do a correct measurement with an
> oscilloscope).
>
> I know there are lot of questions :)

well, I have two immediate reactions.

First, use the values provided by the vendor, if they are wrong performance is 
not optimum and people will pick a different vendor (so they have an incentive 
to be right :-)

Second, "measure them" :-)

have the device tree enumerate the modes of operation, but then at bootup, run 
through a series of tests to bounce between the different modes and measure how 
long it takes to move back and forth. If the system can't measure the difference 
against it's clocks, then the user isn't going to see the difference either, so 
there's no need to be as accurate as a lab bench with a scope. What matters is 
how much work can end up getting done for the user, not the number of 
nanoseconds between voltage changes (the latter will affect the former, but it's 
the former that you really care about)

remember, perfect is the enemy of good enough. you don't have to have a perfect 
mapping of every possible change, you just need to be close enough to make 
reasonable decisions. You can't really predict the future anyway, so you are 
making a guess at what the load on the system is going to be in the future. 
Sometimes you will guess wrong no matter how accurate your latency measurements 
are. You have to accept that, and once you accept that, the severity of being 
wrong in some corner cases become less significant.

David Lang
