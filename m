Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3CRSqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:46:36 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52267 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3CRSqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <1363630390.15703.31@driftwood>
References: <20130318162942.GA9359@linux.vnet.ibm.com>
	<1363630390.15703.31@driftwood>
Date: Mon, 18 Mar 2013 19:46:32 +0100
Message-ID: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
Subject: Re: [PATCH] nohz1: Documentation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, rostedt@goodmis.org, zhong@linux.vnet.ibm.com,
        khilman@linaro.org, geoff@infradead.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18 Rob Landley <rob@landley.net>:
> On 03/18/2013 11:29:42 AM, Paul E. McKenney wrote:
> And really seems like it's kconfig help text?

It's more exhaustive than a Kconfig help. A Kconfig help text should
have the level of detail that describe the purpose and impact of a
feature, as well as some quick reference/pointer to the interface.

Deeper explanation which include implementation internals, finegrained
constraints, TODO list, detailed interface are better here.

>   The CONFIG_NO_HZ=y and CONFIG_NO_HZ_FULL=y options cause the kernel
>   to (respectively) avoid sending scheduling-clock interrupts to idle
>   processors, or to processors with only a single single runnable task.
>   You can disable this at boot time with kernel parameter "nohz=off".
>
>   This reduces power consumption by allowing processors to suspend more
>   deeply for longer periods, and can also improve some computationally
>   intensive workloads. The downside is coming out of a deeper sleep can
>   reduce realtime response to wakeup events.
>
>   This is split into two config options because the second isn't quite
>   finished and won't reliably deliver posix timer interrupts, perf
>   events, or do as well on CPU load balancing. The CONFIG_RCU_FAST_NO_HZ
>   option enables a workaround to force tick delivery every 4 jiffies to
>   handle RCU events. See the CONFIG_RCU_NOCB_CPU option for a different
>   workaround.

I really think we want to keep all the detailed explanations from
Paul's doc. What we need is not a quick reference but a very detailed
documentation.

>
>> +1.     It increases the number of instructions executed on the path
>> +       to and from the idle loop.
>
>
> This detail didn't get mentioned in my summary.

And it's an important point.

>
>
>> +5.     The LB_BIAS scheduler feature is disabled by adaptive ticks.
>
>
> I have no idea what that one is, my summary didn't mention it.

Nobody seem to know what that thing is, except probably the scheduler
warlocks :o)
All I know is that it's hard to implement without the tick. So I
disabled it in my tree.

>> +o      Some sources of OS jitter can currently be eliminated only by
>> +       constraining the workload.  For example, the only way to eliminate
>> +       OS jitter due to global TLB shootdowns is to avoid the unmapping
>> +       operations (such as kernel module unload operations) that result
>> +       in these shootdowns.  For another example, page faults and TLB
>> +       misses can be reduced (and in some cases eliminated) by using
>> +       huge pages and by constraining the amount of memory used by the
>> +       application.
>
>
> If you want to write a doc on reducing system jitter, go for it. This is
> a topic transition near the end of a document.
>
>
>> +o      At least one CPU must keep the scheduling-clock interrupt going
>> +       in order to support accurate timekeeping.
>
>
> How? You never said how to tell a processor _not_ to suppress interrupts
> when CONFIG_THE_OTHER_HALF_OF_NOHZ is enabled.

Ah indeed it would be nice to point out that there must be an online
CPU outside the value range of the nohz_mask=  boot parameter.

> I take it the problem is the value in the sysenter page won't get updated,
> so gettimeofday() will see a stale value until the CPU hog stops
> suppressing interrupts? I thought the first half of NOHZ had a way of
> dealing with that many moons ago? (Did sysenter cause a regression?)

With CONFIG_NO_HZ, there is always a tick running that updates GTOD
and jiffies as long as there is non-idle CPU. If every CPUs are idle
and one suddenly wakes up, GTOD and jiffies values are caught up.

With full dynticks we have a new problem: there can be a CPU using
jiffies of GTOD without running the tick (we are not idle so there can
be such users). So there must a ticking CPU somewhere.

> Rob
