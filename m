Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CRUse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:48:34 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:59630 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3CRUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <1363636794.15703.32@driftwood>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	<1363636794.15703.32@driftwood>
Date: Mon, 18 Mar 2013 21:48:31 +0100
Message-ID: <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
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
> On 03/18/2013 01:46:32 PM, Frederic Weisbecker wrote:
>> I really think we want to keep all the detailed explanations from
>> Paul's doc. What we need is not a quick reference but a very detailed
>> documentation.
>
>
> It's much _longer_, I'm not sure it contains significantly more information.
> ("Using more power will shorten battery life" is a nice observation, but is
> it specific to your subsystem? I dunno, maybe it's a personal idiosyncrasy,
> but I tend to think that people start with use cases and need to find
> infrastructure. The other direction seems less interesting somehow. Like a
> pan with a picture on the front of what you might want to bake with it.)

People start with a usecase, find an infrastructure and finally its
documentation that tell them the tradeoffs, constraints, possible
enhancements. Yes both directions are valuable.

Another point in favor of taking that direction: consider LB_BIAS. Do
you know what it's all about? Me neither. Too bad there is no
documentation. Obscure kernel code make kernel hacking closer to
reverse engineering. As the kernel grows in complexity, this all will
have some interesting effect in the future. And I'm just rephrasing
what people like Andrew already started to say a few years ago.

Addition of detailed documentation of core (and even less core) kernel
code is hardly arguable.

>> >> +1.     It increases the number of instructions executed on the path
>> >> +       to and from the idle loop.
>> >
>> >
>> > This detail didn't get mentioned in my summary.
>>
>> And it's an important point.
>
>
> I mentioned increased latency coming out of idle. Increased latency going
> _to_ idle is an important point? (And pretty much _every_ kconfig option has
> ramifications at that level which realtime people tend to want to bench.)

Yeah, increased latency in going to idle has consequences in term of
energy saving, latency and throughput.

>
> Also, I mentioned this one because all the other details I deleted pretty
> much _did_ get taken into account in my summary.

Certainly not with the same level of detail.

>
>> >> +5.     The LB_BIAS scheduler feature is disabled by adaptive ticks.
>> >
>> >
>> > I have no idea what that one is, my summary didn't mention it.
>>
>> Nobody seem to know what that thing is, except probably the scheduler
>> warlocks :o)
>> All I know is that it's hard to implement without the tick. So I
>> disabled it in my tree.
>
>
> Is it also an important point?

Yes, users must be informed about limitations.

>
>> >> +o      At least one CPU must keep the scheduling-clock interrupt going
>> >> +       in order to support accurate timekeeping.
>> >
>> >
>> > How? You never said how to tell a processor _not_ to suppress interrupts
>> > when CONFIG_THE_OTHER_HALF_OF_NOHZ is enabled.
>>
>> Ah indeed it would be nice to point out that there must be an online
>> CPU outside the value range of the nohz_mask=  boot parameter.
>
>
> There's a nohz_mask boot parameter?

Yeah we need to document that too.

>
>> > I take it the problem is the value in the sysenter page won't get
>> > updated,
>> > so gettimeofday() will see a stale value until the CPU hog stops
>> > suppressing interrupts? I thought the first half of NOHZ had a way of
>> > dealing with that many moons ago? (Did sysenter cause a regression?)
>>
>> With CONFIG_NO_HZ, there is always a tick running that updates GTOD
>> and jiffies as long as there is non-idle CPU. If every CPUs are idle
>> and one suddenly wakes up, GTOD and jiffies values are caught up.
>>
>> With full dynticks we have a new problem: there can be a CPU using
>> jiffies of GTOD without running the tick (we are not idle so there can
>> be such users). So there must a ticking CPU somewhere.
>
>
> I.E. because gettimeofday() just checks a memory location without requiring
> a kernel transition, there's no opportunity for the kernel to trigger and
> run catch-up code.

Isn't that value updated by the kernel?

>
> So you'd need a timer to remove the read flag on the page containing the
> jiffies value after it was considered sufficiently stale, and then have the
> page fault update the value restore the read flag and reset the timer to
> switch it off again, and then just tell CPU-intensive code that wanted to
> take advantage of running uninterrupted not to mess with jiffies unless they
> wanted to trigger interrupts to keep it current.

I fear making the jiffies read faultable is not something we can
afford. That means there will be several places where we couldn't use
it. And there would be some performance issues. Also such a timer
defeats the initial purpose of reducing timers interrupts.

GTOD is another issue but page faults would be a performance problem
as well. And timer too.

>
> By the way, I find this "full" name strange if you yourself have a list of
> more cases where ticks could be dropped, but which you haven't implemented
> yet.

Yeah. Full dynticks works because it suggest tick periods are
dynamics. But full tickless or full nohz is not true. Some renaming
are on the work anyway.

> The system being entirely idle means unnecessary ticks can be dropped.
> The system having no scheduling decisions to make on a processor also means
> unnecessary ticks can be dropped. But there are two config options and they
> get treated as entirely different subsystems...

No they share a lot of common infrastructure. Also full dynticks
depends on dynticks-idle.

> I suppose one of them having a bucket of workarounds and caveats is the
> reason? One is just "let the system behave more efficiently, only reason
> it's a config option is increased latency waking up from idle can annoy the
> realtime guys". The second is "let the system behave more efficiently in a
> way that opens up a bunch of sharp edges and requires extensive
> micromanagement". But those sharp edges seem more "unfinished" than really a
> design limitation...

The reason of having a seperate Kconfig for the new feature is because
it adds some overhead even in the off-case.
