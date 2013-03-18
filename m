Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3CRWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:25:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37495 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3CRWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:25:54 -0400
Date: Mon, 18 Mar 2013 15:25:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, rostedt@goodmis.org, zhong@linux.vnet.ibm.com,
        khilman@linaro.org, geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
Message-ID: <20130318222548.GG3656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
 <1363636794.15703.32@driftwood>
 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031822-2398-0000-0000-00001251AF68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 09:48:31PM +0100, Frederic Weisbecker wrote:
> 2013/3/18 Rob Landley <rob@landley.net>:
> > On 03/18/2013 01:46:32 PM, Frederic Weisbecker wrote:

[ . . . ]

> >> >> +o      At least one CPU must keep the scheduling-clock interrupt going
> >> >> +       in order to support accurate timekeeping.
> >> >
> >> >
> >> > How? You never said how to tell a processor _not_ to suppress interrupts
> >> > when CONFIG_THE_OTHER_HALF_OF_NOHZ is enabled.
> >>
> >> Ah indeed it would be nice to point out that there must be an online
> >> CPU outside the value range of the nohz_mask=  boot parameter.
> >
> >
> > There's a nohz_mask boot parameter?
> 
> Yeah we need to document that too.

Good catch both of you, fixed!

[ . . . ]

> > The system being entirely idle means unnecessary ticks can be dropped.
> > The system having no scheduling decisions to make on a processor also means
> > unnecessary ticks can be dropped. But there are two config options and they
> > get treated as entirely different subsystems...
> 
> No they share a lot of common infrastructure. Also full dynticks
> depends on dynticks-idle.

Good point, added this.

> > I suppose one of them having a bucket of workarounds and caveats is the
> > reason? One is just "let the system behave more efficiently, only reason
> > it's a config option is increased latency waking up from idle can annoy the
> > realtime guys". The second is "let the system behave more efficiently in a
> > way that opens up a bunch of sharp edges and requires extensive
> > micromanagement". But those sharp edges seem more "unfinished" than really a
> > design limitation...
> 
> The reason of having a seperate Kconfig for the new feature is because
> it adds some overhead even in the off-case.

Good point, added words stating that all of the costs of CONFIG_NO_HZ
are also incurred by CONFIG_NO_HZ_FULL.

Rob also noted that the presentation of the NOCB Kconfig options and boot
parameters was confusing, so I reworked this to put the Kconfig options
first (build then boot!) and to indicate that the RCU_NOCB_CPU_NONE,
RCU_NOCB_CPU_ZERO, and RCU_NOCB_CPU_ALL options are mutually exclusive.

Rob also noted that the current draft is wordy, which I will address
in a later draft.

							Thanx, Paul

------------------------------------------------------------------------

		NO_HZ: Reducing Scheduling-Clock Ticks


This document covers Kconfig options and boot parameters used to reduce
the number of scheduling-clock interrupts.  These reductions can be
helpful in improving energy efficiency and in reducing "OS jitter",
the latter being very important for some types of computationally
intensive high-performance computing (HPC) applications and for real-time
applications.

Within the Linux kernel, there are two major aspects of scheduling-clock
interrupt reduction:

1.	Idle CPUs.

2.	CPUs having only one runnable task.

These two cases are described in the following sections.


IDLE CPUs

If a CPU is idle, there is little point in sending it a scheduling-clock
interrupt.  After all, the primary purpose of a scheduling-clock interrupt
is to force a busy CPU to shift its attention among multiple duties,
but an idle CPU by definition has no duties to shift its attention among.

The CONFIG_NO_HZ=y Kconfig option causes the kernel to avoid sending
scheduling-clock interrupts to idle CPUs, which is critically important
both to battery-powered devices and to highly virtualized mainframes.
A battery-powered device running a CONFIG_NO_HZ=n kernel would drain its
battery very quickly, easily 2-3x as fast as would the same device running
a CONFIG_NO_HZ=n kernel.  A mainframe running 1,500 OS instances could
easily find that half of its CPU time was consumed by scheduling-clock
interrupts.  In these situations, there is therefore strong motivation
to avoid sending scheduling-clock interrupts to idle CPUs.  That said,
dyntick-idle mode is not free:

1.	It increases the number of instructions executed on the path
	to and from the idle loop.

2.	Many architectures will place dyntick-idle CPUs into deep sleep
	states, which further degrades from-idle transition latencies.

Therefore, systems with aggressive real-time response constraints
often run CONFIG_NO_HZ=n kernels in order to avoid degrading from-idle
transition latencies.

An idle CPU that is not receiving scheduling-clock interrupts is said to
be "dyntick-idle", "in dyntick-idle mode", "in nohz mode", or "running
tickless".  The remainder of this document will use "dyntick-idle mode".

There is also a boot parameter "nohz=" that can be used to disable
dyntick-idle mode in CONFIG_NO_HZ=y kernels by specifying "nohz=off".
By default, CONFIG_NO_HZ=y kernels boot with "nohz=on", enabling
dyntick-idle mode.


CPUs WITH ONLY ONE RUNNABLE TASK

If a CPU has only one runnable task, there is again little point in
sending it a scheduling-clock interrupt.  Recall that the primary
purpose of a scheduling-clock interrupt is to force a busy CPU to
shift its attention among many things requiring its attention -- and
there is nowhere else for a CPU with but one runnable task to shift its
attention to.

The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to avoid
sending scheduling-clock interrupts to CPUs with a single runnable task.
This is important for applications with aggressive real-time response
constraints because it allows them to improve their worst-case response
times by the maximum duration of a scheduling-clock interrupt.  It is also
important for computationally intensive iterative workloads with short
iterations:  If any CPU is delayed during a given iteration, all the
other CPUs will be forced to wait idle while the delayed CPU finished.
Thus, the delay is multiplied by one less than the number of CPUs.
In these situations, there is again strong motivation to avoid sending
scheduling-clock interrupts to CPUs that have but one runnable task that
is executing in user mode.

The "full_nohz=" boot parameter specifies which CPUs are to be
adaptive-ticks CPUs.  For example, "full_nohz=1,6-8" says that CPUs 1,
6, 7, and 8 are to be adaptive-ticks CPUs.  By default, no CPUs will
be adaptive-ticks CPUs.  Not that you are prohibited from marking all
of the CPUs as adaptive-tick CPUs:  At least one non-adaptive-tick CPU
must remain online to handle timekeeping tasks in order to ensure that
gettimeofday() returns sane values on adaptive-tick CPUs.

Note that if a given CPU is in adaptive-ticks mode while executing in
user mode, transitioning to kernel mode does not automatically force
that CPU out of adaptive-ticks mode.  The CPU will exit adaptive-ticks
mode only if needed, for example, if that CPU enqueues an RCU callback.

Just as with dyntick-idle mode, the benefits of adaptive-tick mode do
not come for free:

1.	CONFIG_NO_HZ_FULL depends on CONFIG_NO_HZ, so you cannot run
	adaptive ticks without also running dyntick idle.  This dependency
	of CONFIG_NO_HZ_FULL on CONFIG_NO_HZ extends down into the
	implementation.  Therefore, all of the costs of CONFIG_NO_HZ
	are also incurred by CONFIG_NO_HZ_FULL.

2.	The user/kernel transitions are slightly more expensive due
	to the need to inform kernel subsystems (such as RCU) about
	the change in mode.

3.	POSIX CPU timers on adaptive-tick CPUs may fire late (or even
	not at all) because they currently rely on scheduling-tick
	interrupts.  This will likely be fixed in one of two ways: (1)
	Prevent CPUs with POSIX CPU timers from entering adaptive-tick
	mode, or (2) Use hrtimers or other adaptive-ticks-immune mechanism
	to cause the POSIX CPU timer to fire properly.

4.	If there are more perf events pending than the hardware can
	accommodate, they are normally round-robined so as to collect
	all of them over time.  Adaptive-tick mode may prevent this
	round-robining from happening.  This will likely be fixed by
	preventing CPUs with large numbers of perf events pending from
	entering adaptive-tick mode.

5.	Scheduler statistics for adaptive-idle CPUs may be computed
	slightly differently than those for non-adaptive-idle CPUs.
	This may in turn perturb load-balancing of real-time tasks.

6.	The LB_BIAS scheduler feature is disabled by adaptive ticks.

Although improvements are expected over time, adaptive ticks is quite
useful for many types of real-time and compute-intensive applications.
However, the drawbacks listed above mean that adaptive ticks should not
be enabled by default across the board at the current time.


RCU IMPLICATIONS

There are situations in which idle CPUs cannot be permitted to
enter either dyntick-idle mode or adaptive-tick mode, the most
familiar being the case where that CPU has RCU callbacks pending.

The CONFIG_RCU_FAST_NO_HZ=y Kconfig option may be used to cause such
CPUs to enter dyntick-idle mode or adaptive-tick mode anyway, though a
timer will awaken these CPUs every four jiffies in order to ensure that
the RCU callbacks are processed in a timely fashion.

Another approach is to offload RCU callback processing to "rcuo" kthreads
using the CONFIG_RCU_NOCB_CPU=y.  The specific CPUs to offload may be
selected via several methods:

1.	One of three mutually exclusive Kconfig options specify a
	build-time default for the CPUs to offload:

	a.	The RCU_NOCB_CPU_NONE=y Kconfig option results in
		no CPUs being offloaded.

	b.	The RCU_NOCB_CPU_ZERO=y Kconfig option causes CPU 0 to
		be offloaded.

	c.	The RCU_NOCB_CPU_ALL=y Kconfig option causes all CPUs
		to be offloaded.

2.	The "rcu_nocbs=" kernel boot parameter, which takes a comma-separated
	list of CPUs and CPU ranges, for example, "1,3-5" selects CPUs 1,
	3, 4, and 5.  The specified CPUs will be offloaded in addition
	to any CPUs specified as offloaded by RCU_NOCB_CPU_ZERO or
	RCU_NOCB_CPU_ALL.

The offloaded CPUs never have RCU callbacks queued, and therefore RCU
never prevents offloaded CPUs from entering either dyntick-idle mode or
adaptive-tick mode.  That said, note that it is up to userspace to
pin the "rcuo" kthreads to specific CPUs if desired.  Otherwise, the
scheduler will decide where to run them, which might or might not be
where you want them to run.


KNOWN ISSUES

o	Dyntick-idle slows transitions to and from idle slightly.
	In practice, this has not been a problem except for the most
	aggressive real-time workloads, which have the option of disabling
	dyntick-idle mode, an option that most of them take.

o	Adaptive-ticks slows user/kernel transitions slightly.
	This is not expected to be a problem for computational-intensive
	workloads, which have few such transitions.  Careful benchmarking
	will be required to determine whether or not other workloads
	are significantly affected by this effect.

o	Adaptive-ticks does not do anything unless there is only one
	runnable task for a given CPU, even though there are a number
	of other situations where the scheduling-clock tick is not
	needed.  To give but one example, consider a CPU that has one
	runnable high-priority SCHED_FIFO task and an arbitrary number
	of low-priority SCHED_OTHER tasks.  In this case, the CPU is
	required to run the SCHED_FIFO task until either it blocks or
	some other higher-priority task awakens on (or is assigned to)
	this CPU, so there is no point in sending a scheduling-clock
	interrupt to this CPU.

	Better handling of these sorts of situations is future work.

o	A reboot is required to reconfigure both adaptive idle and RCU
	callback offloading.  Runtime reconfiguration could be provided
	if needed, however, due to the complexity of reconfiguring RCU
	at runtime, there would need to be an earthshakingly good reason.
	Especially given the option of simply offloading RCU callbacks
	from all CPUs.

o	Additional configuration is required to deal with other sources
	of OS jitter, including interrupts and system-utility tasks
	and processes.  This configuration normally involves binding
	interrupts and tasks to particular CPUs.

o	Some sources of OS jitter can currently be eliminated only by
	constraining the workload.  For example, the only way to eliminate
	OS jitter due to global TLB shootdowns is to avoid the unmapping
	operations (such as kernel module unload operations) that result
	in these shootdowns.  For another example, page faults and TLB
	misses can be reduced (and in some cases eliminated) by using
	huge pages and by constraining the amount of memory used by the
	application.

o	At least one CPU must keep the scheduling-clock interrupt going
	in order to support accurate timekeeping.

