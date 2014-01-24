Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaAXI3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:29:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52023 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaAXI3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:29:31 -0500
Message-ID: <1390552152.6504.37.camel@marge.simpson.net>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Mike Galbraith <bitbucket@online.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Date: Fri, 24 Jan 2014 09:29:12 +0100
In-Reply-To: <CAKohpok5AObcFbOmLYGT-KkjhVHUiLRZ=AYqofYk59_sVneSjA@mail.gmail.com>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	 <20140115171704.GB21574@localhost.localdomain>
	 <CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
	 <alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
	 <CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
	 <20140120155145.GB9436@localhost.localdomain>
	 <CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
	 <20140123145842.GD13345@localhost.localdomain>
	 <CAKohpok5AObcFbOmLYGT-KkjhVHUiLRZ=AYqofYk59_sVneSjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KKzljo/pRNRMrbbjGgD01jf4oXfgki9t5td1lsIq/fr
 th44QZ3gpyoLBNaQWyLN0jbfyy1udWUSHwYkCiF69ALHEpihCq
 qFJEOcHohc0bHaDDalrVxr+SOmDPeHWwEziTYOZvm47I46wtvQ
 z+DWktk86NGw3I6P0gY5chzJWUnjCnTeDM597Ufo8G4HHGUk3v
 fofHEewOo7k/ScOXOaR87RdTFd605vFf3CbygcUsKHaEwEMSL0
 Oi0TJxOxbLDGc2NDN78U3S98L9F2UBjdsekOkikz0cjuQIB3R8
 jtB3XeMPgtJ5LXCD62kogjWqScPdFD5Q+f83a9+/39+9zGxq+z
 HVhi6v0zPEX6DHIplBbcJKhHPpcwNk/dlaDc6E+l72XPOVcJGI
 u+vPHeyAkLFrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-24 at 10:51 +0530, Viresh Kumar wrote: 
> On 23 January 2014 20:28, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, Jan 21, 2014 at 04:03:53PM +0530, Viresh Kumar wrote:
> 
> >> So, the main problem in my case was caused by this:
> >>
> >>            <...>-2147  [001] d..2   302.573881: hrtimer_start:
> >> hrtimer=c172aa50 function=tick_sched_timer expires=602075000000
> >> softexpires=602075000000
> >>
> >> I have mentioned this earlier when I sent you attachments. I think
> >> this is somehow
> >> tied with the NO_HZ_FULL stuff? As the timer is queued for 300 seconds after
> >> current time.
> >>
> >> How to get this out?
> >
> > So it's scheduled away 300 seconds later. It might be a pending timer_list. Enabling the
> > timer tracepoints may give you some clues.
> 
> Trace was done with that enabled. /proc/timer_list confirms that a hrtimer
> is queued for 300 seconds later for tick_sched_timer. And so I assumed
> this is part of the current NO_HZ_FULL implementation.
> 
> Just to confirm, when we decide that a CPU is running a single task and so
> can enter tickless mode, do we queue this tick_sched_timer for 300 seconds
> ahead of time? If not, then who is doing this :)
> 
> >> Which CPUs are housekeeping CPUs? How do we declare them?
> >
> > It's not yet implemented, but it's an idea (partly from Thomas) of something we can do to
> > define some general policy on various periodic/async work affinity to enforce isolation.
> >
> > The basic idea is to define the CPU handling the timekeeping duty to be the housekeeping
> > CPU. Given that CPU must keep a periodic tick, lets move all the unbound timers and
> > workqueues there. And also try to move some CPU affine work as well. For example
> > we could handle the scheduler tick of the full dynticks CPUs into that housekeeping
> > CPU, at a low freqency. This way we could remove that 1 second scheduler tick max deferment
> > per CPU. It may be an overkill though to run all the scheduler ticks on a single CPU so there
> > may be other ways to cope with that.
> >
> > And I would like to keep that housekeeping notion flexible enough to be extendable on more
> > than one CPU, as I heard that some people plan to reserve one CPU per node on big
> > NUMA machines for such a purpose. So that could be a cpumask, augmented with an infrastructure.
> >
> > Of course, if some people help contributing in this area, some things may eventually move foward
> > on the support of CPU isolation. I can't do that all alone, at least not quickly, given all the
> > things already pending in my queue (fix buggy nohz iowait accounting, support RCU full sysidle detection,
> > apply AMD range breakpoints patches, further cleanup posix cpu timers, etc...).
> 
> I see. As I am currently working on the isolation stuff which is very
> much required
> for my usecase, I will try to do that as the second step of my work.
> The first one
> stays something like a cpuset.quiesce option that PeterZ suggested.
> 
> Any pointers of earlier discussion on this topic would be helpful to
> start working on
> this..

All of that nohz_full stuff would be a lot more usable if it were
dynamic via cpusets.  As the thing sits, if you need a small group of
tickless cores once in a while, you have to eat a truckload of overhead
and zillion threads always.  The price is high.

I have a little hack for my -rt kernel that allows the user to turn the
tick on/off (and cpupri) on a per fully isolated set basis, because
jitter is lower with the tick than with nohz doing it's thing.  With
that, you can set up whatever portion of box to meet your needs on the
fly.  When you need very low jitter, turn all load balancing off in your
critical set, turn nohz off, turn rt load balancing off, and 80 core
boxen become usable for cool zillion dollar realtime video games.. box
becomes a militarized playstation.

Doing the same with nohz_full would be a _lot_ harder (my hacks are
trivial), but would be a lot more attractive to users than always eating
the high nohz_full cost whether using it or not.  Poke buttons, threads
are born or die, patch in/out expensive accounting goop and whatnot,
play evil high speed stock market bandit, or whatever else, at the poke
of couple buttons.

-Mike

