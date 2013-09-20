Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab3ITVDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:03:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:43862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3ITVDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:03:22 -0400
Date: Fri, 20 Sep 2013 23:03:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: RFC vmstat: On demand vmstat threads
In-Reply-To: <20130920164201.GB30381@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1309201930590.4089@ionos.tec.linutronix.de>
References: <00000140e9dfd6bd-40db3d4f-c1be-434f-8132-7820f81bb586-000000@email.amazonses.com> <CAOtvUMdfqyg80_9J8AnOaAdahuRYGC-bpemdo_oucDBPguXbVA@mail.gmail.com> <0000014109b8e5db-4b0f577e-c3b4-47fe-b7f2-0e5febbcc948-000000@email.amazonses.com>
 <20130918150659.5091a2c3ca94b99304427ec5@linux-foundation.org> <alpine.DEB.2.02.1309190033440.4089@ionos.tec.linutronix.de> <000001413796641f-017482d3-1194-499b-8f2a-d7686c1ae61f-000000@email.amazonses.com> <alpine.DEB.2.02.1309201238560.4089@ionos.tec.linutronix.de>
 <20130920164201.GB30381@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;3202;0cOn Fri, 20 Sep 2013, Frederic Weisbecker wrote:
> On Fri, Sep 20, 2013 at 12:41:02PM +0200, Thomas Gleixner wrote:
> > On Thu, 19 Sep 2013, Christoph Lameter wrote:
> > > On Thu, 19 Sep 2013, Thomas Gleixner wrote:
> > > 
> > > > The vmstat accounting is not the only thing which we want to delegate
> > > > to dedicated core(s) for the full NOHZ mode.
> > > >
> > > > So instead of playing broken games with explicitly not exposed core
> > > > code variables, we should implement a core code facility which is
> > > > aware of the NOHZ details and provides a sane way to delegate stuff to
> > > > a certain subset of CPUs.
> > > 
> > > I would be happy to use such a facility. Otherwise I would just be adding
> > > yet another kernel option or boot parameter I guess.
> > 
> > Uuurgh, no.
> > 
> > The whole delegation stuff is necessary not just for vmstat. We have
> > the same issue for scheduler stats and other parts of the kernel, so
> > we are better off in having a core facility to schedule such functions
> > in consistency with the current full NOHZ state.
> 
> Agreed.
> 
> So we have the choice between having this performed from callers in
> the kernel with functions that enforce the affinity of some
> asynchronous tasks, like "schedule_on_timekeeper()" or
> "schedule_on_housekeeers()" with workqueues for example.

Why do you need different targets?

> Or we can add interface to define the affinity of such things from
> userspace, at the ....

We already have the relevant information in the kernel. And it's not
too hard to come up with a rather simple and robust scheme for this.

For the following I use the terms enter/leave isolation mode in that
way:

    Enter/leave isolation mode is when the full NOHZ mode is
    enabled/disabled for a cpu, not when the CPU actually
    enters/leaves that state (i.e. single cpu bound userspace task).

So what you want is something like this:

int housekeeping_register(int (*cb)(struct cpumask *mask),
    			  unsinged period_ms, bool always);

cb: 	    the callback to execute. it processes the data for all cores
	    which are set in the cpumask handed in by the housekeeping
	    scheduler.

period_ms:  period of the callback, can be 0 for immediate
	    one time execution

always:     the always argument tells the core code whether to schedule
	    the callback unconditionally. If false it only schedules it
	    when the core enters isolation mode.

In the beginning we simply schedule the callbacks on each online cpu,
if the always bit is set. For the callbacks which are registered with
the always bit off, we schedule them only on entry into isolation
mode.

Now when a cpu becomes isolated we stop the callback scheduling on
that cpu and assign it to the cpu with the smallest NUMA
distance. So that cpu will process the data for itself and for the
newly isolated cpu.

When a cpu leaves isolation mode then it gets its housekeeping task
assigned back.

We need to be clever about the NOHZ idle interaction. If a cpu has
assigned more than its own data to process, then it shouldn't use a
deferrable timer. CPUs which only take care of their own data can use
a deferrable timer.

This works out of the box for stuff like vmstat, where the callback is
already done in a workqueue and we can register them with always =
true.

The scheduler stats are a slightly different beast, but it's not
rocket science to handle that.

We register the callback with always = false. So for a bog standard
system nothing happens, except the registering. Once the full NOHZ
mode is enabled on a cpu we schedule the work with a reasonable slow
period (e.g. 1 sec) on a non isolated cpu. That's where stuff gets
interesting.

On the isolated cpu we might still execute the scheduler tick because
we did not yet reach a condition to disable it. So we need to protect
the on cpu accounting against the scheduled one on the remote
cpu. Unfortunately that requires locking. The only reasonable lock
here is runqueue lock of the isolated cpu. Though this sounds worse
than it is. We take the cpu local rq lock from the tick anyway in
scheduler_tick(). So we can move the account_process_tick() call to
this code. Zero impact for the non isolated case.

In the isolated case we only might get contention, when the isolated
cpu was not yet able to disable the tick, but the remote update is
going to be slow anyway and that update can exit early when it notices
that the last on cpu update was less than a tick away.

Now if we run the remote update with a slow period (1 sec) there might
be some delay in the stats, but once the cpu vanished into user space
the while(1) mode we can really live with the slightly inaccurate
accumulation.

The only other issue might be posix cpu timers. For the start I really
would just ignore them. There are other means to watchdog a task
runtime, but we can extend the remote slow update scheme to posix cpu
timers as well if the need arises.

Thanks,

	tglx
