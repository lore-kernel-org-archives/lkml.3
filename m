Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbaAXFVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:21:16 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:52495 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAXFVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140123145842.GD13345@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115171704.GB21574@localhost.localdomain>
	<CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
	<alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
	<CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
	<20140120155145.GB9436@localhost.localdomain>
	<CAKohpom8av7A1wwcdOr5+LpHz--P+s9m_gR_9B+Aa4fpwkN7uQ@mail.gmail.com>
	<20140123145842.GD13345@localhost.localdomain>
Date: Fri, 24 Jan 2014 10:51:14 +0530
Message-ID: <CAKohpok5AObcFbOmLYGT-KkjhVHUiLRZ=AYqofYk59_sVneSjA@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2014 20:28, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Jan 21, 2014 at 04:03:53PM +0530, Viresh Kumar wrote:

>> So, the main problem in my case was caused by this:
>>
>>            <...>-2147  [001] d..2   302.573881: hrtimer_start:
>> hrtimer=c172aa50 function=tick_sched_timer expires=602075000000
>> softexpires=602075000000
>>
>> I have mentioned this earlier when I sent you attachments. I think
>> this is somehow
>> tied with the NO_HZ_FULL stuff? As the timer is queued for 300 seconds after
>> current time.
>>
>> How to get this out?
>
> So it's scheduled away 300 seconds later. It might be a pending timer_list. Enabling the
> timer tracepoints may give you some clues.

Trace was done with that enabled. /proc/timer_list confirms that a hrtimer
is queued for 300 seconds later for tick_sched_timer. And so I assumed
this is part of the current NO_HZ_FULL implementation.

Just to confirm, when we decide that a CPU is running a single task and so
can enter tickless mode, do we queue this tick_sched_timer for 300 seconds
ahead of time? If not, then who is doing this :)

>> Which CPUs are housekeeping CPUs? How do we declare them?
>
> It's not yet implemented, but it's an idea (partly from Thomas) of something we can do to
> define some general policy on various periodic/async work affinity to enforce isolation.
>
> The basic idea is to define the CPU handling the timekeeping duty to be the housekeeping
> CPU. Given that CPU must keep a periodic tick, lets move all the unbound timers and
> workqueues there. And also try to move some CPU affine work as well. For example
> we could handle the scheduler tick of the full dynticks CPUs into that housekeeping
> CPU, at a low freqency. This way we could remove that 1 second scheduler tick max deferment
> per CPU. It may be an overkill though to run all the scheduler ticks on a single CPU so there
> may be other ways to cope with that.
>
> And I would like to keep that housekeeping notion flexible enough to be extendable on more
> than one CPU, as I heard that some people plan to reserve one CPU per node on big
> NUMA machines for such a purpose. So that could be a cpumask, augmented with an infrastructure.
>
> Of course, if some people help contributing in this area, some things may eventually move foward
> on the support of CPU isolation. I can't do that all alone, at least not quickly, given all the
> things already pending in my queue (fix buggy nohz iowait accounting, support RCU full sysidle detection,
> apply AMD range breakpoints patches, further cleanup posix cpu timers, etc...).

I see. As I am currently working on the isolation stuff which is very
much required
for my usecase, I will try to do that as the second step of my work.
The first one
stays something like a cpuset.quiesce option that PeterZ suggested.

Any pointers of earlier discussion on this topic would be helpful to
start working on
this..
