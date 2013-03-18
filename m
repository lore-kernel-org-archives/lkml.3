Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3CRUAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:00:01 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:40612 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3CRUAA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:00:00 -0400
Date: Mon, 18 Mar 2013 14:59:54 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] nohz1: Documentation
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, rostedt@goodmis.org, zhong@linux.vnet.ibm.com,
        khilman@linaro.org, geoff@infradead.org, tglx@linutronix.de
In-Reply-To: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	(from fweisbec@gmail.com on Mon Mar 18 13:46:32 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363636794.15703.32@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 01:46:32 PM, Frederic Weisbecker wrote:
> 2013/3/18 Rob Landley <rob@landley.net>:
> > On 03/18/2013 11:29:42 AM, Paul E. McKenney wrote:
> > And really seems like it's kconfig help text?
> 
> It's more exhaustive than a Kconfig help. A Kconfig help text should
> have the level of detail that describe the purpose and impact of a
> feature, as well as some quick reference/pointer to the interface.
> 
> Deeper explanation which include implementation internals, finegrained
> constraints, TODO list, detailed interface are better here.
...
> I really think we want to keep all the detailed explanations from
> Paul's doc. What we need is not a quick reference but a very detailed
> documentation.

It's much _longer_, I'm not sure it contains significantly more  
information. ("Using more power will shorten battery life" is a nice  
observation, but is it specific to your subsystem? I dunno, maybe it's  
a personal idiosyncrasy, but I tend to think that people start with use  
cases and need to find infrastructure. The other direction seems less  
interesting somehow. Like a pan with a picture on the front of what you  
might want to bake with it.)

> >> +1.     It increases the number of instructions executed on the  
> path
> >> +       to and from the idle loop.
> >
> >
> > This detail didn't get mentioned in my summary.
> 
> And it's an important point.

I mentioned increased latency coming out of idle. Increased latency  
going _to_ idle is an important point? (And pretty much _every_ kconfig  
option has ramifications at that level which realtime people tend to  
want to bench.)

Also, I mentioned this one because all the other details I deleted  
pretty much _did_ get taken into account in my summary.

> >> +5.     The LB_BIAS scheduler feature is disabled by adaptive  
> ticks.
> >
> >
> > I have no idea what that one is, my summary didn't mention it.
> 
> Nobody seem to know what that thing is, except probably the scheduler
> warlocks :o)
> All I know is that it's hard to implement without the tick. So I
> disabled it in my tree.

Is it also an important point?

> >> +o      At least one CPU must keep the scheduling-clock interrupt  
> going
> >> +       in order to support accurate timekeeping.
> >
> >
> > How? You never said how to tell a processor _not_ to suppress  
> interrupts
> > when CONFIG_THE_OTHER_HALF_OF_NOHZ is enabled.
> 
> Ah indeed it would be nice to point out that there must be an online
> CPU outside the value range of the nohz_mask=  boot parameter.

There's a nohz_mask boot parameter?

> > I take it the problem is the value in the sysenter page won't get  
> updated,
> > so gettimeofday() will see a stale value until the CPU hog stops
> > suppressing interrupts? I thought the first half of NOHZ had a way  
> of
> > dealing with that many moons ago? (Did sysenter cause a regression?)
> 
> With CONFIG_NO_HZ, there is always a tick running that updates GTOD
> and jiffies as long as there is non-idle CPU. If every CPUs are idle
> and one suddenly wakes up, GTOD and jiffies values are caught up.
> 
> With full dynticks we have a new problem: there can be a CPU using
> jiffies of GTOD without running the tick (we are not idle so there can
> be such users). So there must a ticking CPU somewhere.

I.E. because gettimeofday() just checks a memory location without  
requiring a kernel transition, there's no opportunity for the kernel to  
trigger and run catch-up code.

So you'd need a timer to remove the read flag on the page containing  
the jiffies value after it was considered sufficiently stale, and then  
have the page fault update the value restore the read flag and reset  
the timer to switch it off again, and then just tell CPU-intensive code  
that wanted to take advantage of running uninterrupted not to mess with  
jiffies unless they wanted to trigger interrupts to keep it current.

By the way, I find this "full" name strange if you yourself have a list  
of more cases where ticks could be dropped, but which you haven't  
implemented yet. The system being entirely idle means unnecessary ticks  
can be dropped. The system having no scheduling decisions to make on a  
processor also means unnecessary ticks can be dropped. But there are  
two config options and they get treated as entirely different  
subsystems...

I suppose one of them having a bucket of workarounds and caveats is the  
reason? One is just "let the system behave more efficiently, only  
reason it's a config option is increased latency waking up from idle  
can annoy the realtime guys". The second is "let the system behave more  
efficiently in a way that opens up a bunch of sharp edges and requires  
extensive micromanagement". But those sharp edges seem more  
"unfinished" than really a design limitation...

Rob