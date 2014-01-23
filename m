Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaAWO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:58:49 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55874 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaAWO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:58:48 -0500
Date: Thu, 23 Jan 2014 15:58:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140123145842.GD13345@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
 <20140115171704.GB21574@localhost.localdomain>
 <CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
 <alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
 <CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
 <20140120155145.GB9436@localhost.localdomain>
 <CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:03:53PM +0530, Viresh Kumar wrote:
> On 20 January 2014 21:21, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > I fear you can't. If you schedule a timer in 4 seconds away and your clockdevice
> > can only count up to 2 seconds, you can't help much the interrupt in the middle to
> > cope with the overflow.
> >
> > So you need to act on the source of the timer:
> >
> > * identify what cause this timer
> > * try to turn that feature off
> > * if you can't then move the timer to the housekeeping CPU
> 
> So, the main problem in my case was caused by this:
> 
>            <...>-2147  [001] d..2   302.573881: hrtimer_start:
> hrtimer=c172aa50 function=tick_sched_timer expires=602075000000
> softexpires=602075000000
>
> I have mentioned this earlier when I sent you attachments. I think
> this is somehow
> tied with the NO_HZ_FULL stuff? As the timer is queued for 300 seconds after
> current time.
> 
> How to get this out?

So it's scheduled away 300 seconds later. It might be a pending timer_list. Enabling the
timer tracepoints may give you some clues.

> 
> > I'll have a look into the latter point to affine global timers to the
> > housekeeping CPU. Per cpu timers need more inspection though. Either we rework
> > them to be possibly handled by remote/housekeeping CPUs, or we let the associate feature
> > to be turned off. All in one it's a case by case work.
> 
> Which CPUs are housekeeping CPUs? How do we declare them?

It's not yet implemented, but it's an idea (partly from Thomas) of something we can do to
define some general policy on various periodic/async work affinity to enforce isolation.

The basic idea is to define the CPU handling the timekeeping duty to be the housekeeping
CPU. Given that CPU must keep a periodic tick, lets move all the unbound timers and
workqueues there. And also try to move some CPU affine work as well. For example
we could handle the scheduler tick of the full dynticks CPUs into that housekeeping
CPU, at a low freqency. This way we could remove that 1 second scheduler tick max deferment
per CPU. It may be an overkill though to run all the scheduler ticks on a single CPU so there
may be other ways to cope with that.

And I would like to keep that housekeeping notion flexible enough to be extendable on more
than one CPU, as I heard that some people plan to reserve one CPU per node on big
NUMA machines for such a purpose. So that could be a cpumask, augmented with an infrastructure.

Of course, if some people help contributing in this area, some things may eventually move foward
on the support of CPU isolation. I can't do that all alone, at least not quickly, given all the
things already pending in my queue (fix buggy nohz iowait accounting, support RCU full sysidle detection,
apply AMD range breakpoints patches, further cleanup posix cpu timers, etc...).

Thanks.
