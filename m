Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3CTXcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:32:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CTXcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:32:21 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=g1up7QdnZ3oA:10 a=J80Qe20qNJOvg1kfNnwA:9 a=QEXdDO2ut3YA:10 a=SHLZ9U9QGr4cuWNt:21 a=GbwwwWbCtjLjQTsS:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363822338.6345.33.camel@gandalf.local.home>
Subject: Re: [PATCH] nohz1: Documentation
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Date: Wed, 20 Mar 2013 19:32:18 -0400
In-Reply-To: <20130318222548.GG3656@linux.vnet.ibm.com>
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>
	 <1363636794.15703.32@driftwood>
	 <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>
	 <20130318222548.GG3656@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 15:25 -0700, Paul E. McKenney wrote:

> ------------------------------------------------------------------------
> 
> 		NO_HZ: Reducing Scheduling-Clock Ticks
> 
> 
> This document covers Kconfig options and boot parameters used to reduce
> the number of scheduling-clock interrupts.  These reductions can be
> helpful in improving energy efficiency and in reducing "OS jitter",
> the latter being very important for some types of computationally
> intensive high-performance computing (HPC) applications and for real-time
> applications.
> 
> Within the Linux kernel, there are two major aspects of scheduling-clock
> interrupt reduction:
> 
> 1.	Idle CPUs.
> 
> 2.	CPUs having only one runnable task.
> 
> These two cases are described in the following sections.
> 
> 
> IDLE CPUs
> 
> If a CPU is idle, there is little point in sending it a scheduling-clock
> interrupt.  After all, the primary purpose of a scheduling-clock interrupt
> is to force a busy CPU to shift its attention among multiple duties,
> but an idle CPU by definition has no duties to shift its attention among.
> 
> The CONFIG_NO_HZ=y Kconfig option causes the kernel to avoid sending
> scheduling-clock interrupts to idle CPUs, which is critically important
> both to battery-powered devices and to highly virtualized mainframes.
> A battery-powered device running a CONFIG_NO_HZ=n kernel would drain its
> battery very quickly, easily 2-3x as fast as would the same device running
> a CONFIG_NO_HZ=n kernel.  A mainframe running 1,500 OS instances could

So a device running CONFIG_NO_HZ=n would drain its battery 2-3x faster
than the
same device running CONFIG_NO_HZ=n ?

:-)

> easily find that half of its CPU time was consumed by scheduling-clock
> interrupts.  In these situations, there is therefore strong motivation
> to avoid sending scheduling-clock interrupts to idle CPUs.  That said,
> dyntick-idle mode is not free:
> 
> 1.	It increases the number of instructions executed on the path
> 	to and from the idle loop.
> 
> 2.	Many architectures will place dyntick-idle CPUs into deep sleep
> 	states, which further degrades from-idle transition latencies.
> 
> Therefore, systems with aggressive real-time response constraints
> often run CONFIG_NO_HZ=n kernels in order to avoid degrading from-idle
> transition latencies.
> 
> An idle CPU that is not receiving scheduling-clock interrupts is said to
> be "dyntick-idle", "in dyntick-idle mode", "in nohz mode", or "running
> tickless".  The remainder of this document will use "dyntick-idle mode".
> 
> There is also a boot parameter "nohz=" that can be used to disable
> dyntick-idle mode in CONFIG_NO_HZ=y kernels by specifying "nohz=off".
> By default, CONFIG_NO_HZ=y kernels boot with "nohz=on", enabling
> dyntick-idle mode.
> 
> 
> CPUs WITH ONLY ONE RUNNABLE TASK
> 
> If a CPU has only one runnable task, there is again little point in
> sending it a scheduling-clock interrupt.  Recall that the primary
> purpose of a scheduling-clock interrupt is to force a busy CPU to
> shift its attention among many things requiring its attention -- and
> there is nowhere else for a CPU with but one runnable task to shift its
> attention to.
> 
> The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to avoid
> sending scheduling-clock interrupts to CPUs with a single runnable task.
> This is important for applications with aggressive real-time response
> constraints because it allows them to improve their worst-case response
> times by the maximum duration of a scheduling-clock interrupt.  It is also
> important for computationally intensive iterative workloads with short
> iterations:  If any CPU is delayed during a given iteration, all the
> other CPUs will be forced to wait idle while the delayed CPU finished.
> Thus, the delay is multiplied by one less than the number of CPUs.
> In these situations, there is again strong motivation to avoid sending
> scheduling-clock interrupts to CPUs that have but one runnable task that
> is executing in user mode.
> 
> The "full_nohz=" boot parameter specifies which CPUs are to be
> adaptive-ticks CPUs.  For example, "full_nohz=1,6-8" says that CPUs 1,

This is the first time you mention "adaptive-ticks". Probably should
define it before just using it, even though one should be able to figure
out what adaptive-ticks are, it does throw in a wrench when reading this
if you have no idea what an "adaptive-tick" is.


> 6, 7, and 8 are to be adaptive-ticks CPUs.  By default, no CPUs will
> be adaptive-ticks CPUs.  Not that you are prohibited from marking all
> of the CPUs as adaptive-tick CPUs:  At least one non-adaptive-tick CPU
> must remain online to handle timekeeping tasks in order to ensure that
> gettimeofday() returns sane values on adaptive-tick CPUs.
> 
> Note that if a given CPU is in adaptive-ticks mode while executing in
> user mode, transitioning to kernel mode does not automatically force
> that CPU out of adaptive-ticks mode.  The CPU will exit adaptive-ticks
> mode only if needed, for example, if that CPU enqueues an RCU callback.
> 
> Just as with dyntick-idle mode, the benefits of adaptive-tick mode do
> not come for free:
> 
> 1.	CONFIG_NO_HZ_FULL depends on CONFIG_NO_HZ, so you cannot run
> 	adaptive ticks without also running dyntick idle.  This dependency
> 	of CONFIG_NO_HZ_FULL on CONFIG_NO_HZ extends down into the
> 	implementation.  Therefore, all of the costs of CONFIG_NO_HZ
> 	are also incurred by CONFIG_NO_HZ_FULL.

Not a comment on this document, but on the implementation. As idle NO_HZ
can hurt RT, but RT would want to have full NO_HZ, it's a shame that you
can't have both (no idle but full). As we only care about not letting
the CPU go into deep sleep, I wonder if it wouldn't be too hard to add
something that keeps idle from going into nohz mode. Hmm, I think there
may be an option to keep the CPU from going too deep into sleep. That
may be a better approach.


> 
> 2.	The user/kernel transitions are slightly more expensive due
> 	to the need to inform kernel subsystems (such as RCU) about
> 	the change in mode.
> 
> 3.	POSIX CPU timers on adaptive-tick CPUs may fire late (or even
> 	not at all) because they currently rely on scheduling-tick
> 	interrupts.  This will likely be fixed in one of two ways: (1)
> 	Prevent CPUs with POSIX CPU timers from entering adaptive-tick
> 	mode, or (2) Use hrtimers or other adaptive-ticks-immune mechanism
> 	to cause the POSIX CPU timer to fire properly.
> 
> 4.	If there are more perf events pending than the hardware can
> 	accommodate, they are normally round-robined so as to collect
> 	all of them over time.  Adaptive-tick mode may prevent this
> 	round-robining from happening.  This will likely be fixed by
> 	preventing CPUs with large numbers of perf events pending from
> 	entering adaptive-tick mode.
> 
> 5.	Scheduler statistics for adaptive-idle CPUs may be computed
> 	slightly differently than those for non-adaptive-idle CPUs.
> 	This may in turn perturb load-balancing of real-time tasks.
> 
> 6.	The LB_BIAS scheduler feature is disabled by adaptive ticks.
> 
> Although improvements are expected over time, adaptive ticks is quite
> useful for many types of real-time and compute-intensive applications.
> However, the drawbacks listed above mean that adaptive ticks should not
> be enabled by default across the board at the current time.
> 
> 
> RCU IMPLICATIONS
> 
> There are situations in which idle CPUs cannot be permitted to
> enter either dyntick-idle mode or adaptive-tick mode, the most
> familiar being the case where that CPU has RCU callbacks pending.
> 
> The CONFIG_RCU_FAST_NO_HZ=y Kconfig option may be used to cause such
> CPUs to enter dyntick-idle mode or adaptive-tick mode anyway, though a
> timer will awaken these CPUs every four jiffies in order to ensure that
> the RCU callbacks are processed in a timely fashion.
> 
> Another approach is to offload RCU callback processing to "rcuo" kthreads
> using the CONFIG_RCU_NOCB_CPU=y.  The specific CPUs to offload may be
> selected via several methods:
> 
> 1.	One of three mutually exclusive Kconfig options specify a
> 	build-time default for the CPUs to offload:
> 
> 	a.	The RCU_NOCB_CPU_NONE=y Kconfig option results in
> 		no CPUs being offloaded.
> 
> 	b.	The RCU_NOCB_CPU_ZERO=y Kconfig option causes CPU 0 to
> 		be offloaded.
> 
> 	c.	The RCU_NOCB_CPU_ALL=y Kconfig option causes all CPUs
> 		to be offloaded.

All CPUs don't have their RCU call backs on them? I'm a bit confused by
this. Or is it that the scheduler picks one CPU to do call backs? Does
this mean that to use rcu_ncbs= to be the only deciding factor, you
select RCU_NCB_CPU_NONE?

I think this needs to be explained better.

> 
> 2.	The "rcu_nocbs=" kernel boot parameter, which takes a comma-separated
> 	list of CPUs and CPU ranges, for example, "1,3-5" selects CPUs 1,
> 	3, 4, and 5.  The specified CPUs will be offloaded in addition
> 	to any CPUs specified as offloaded by RCU_NOCB_CPU_ZERO or
> 	RCU_NOCB_CPU_ALL.
> 
> The offloaded CPUs never have RCU callbacks queued, and therefore RCU
> never prevents offloaded CPUs from entering either dyntick-idle mode or
> adaptive-tick mode.  That said, note that it is up to userspace to
> pin the "rcuo" kthreads to specific CPUs if desired.  Otherwise, the
> scheduler will decide where to run them, which might or might not be
> where you want them to run.
> 
> 
> KNOWN ISSUES
> 
> o	Dyntick-idle slows transitions to and from idle slightly.
> 	In practice, this has not been a problem except for the most
> 	aggressive real-time workloads, which have the option of disabling
> 	dyntick-idle mode, an option that most of them take.
> 
> o	Adaptive-ticks slows user/kernel transitions slightly.
> 	This is not expected to be a problem for computational-intensive
> 	workloads, which have few such transitions.  Careful benchmarking
> 	will be required to determine whether or not other workloads
> 	are significantly affected by this effect.

It should be mentioned that only CPUs that are in adaptive-tick mode
have this issue. Other CPUs are still using the tick based accounting,
right?

> 
> o	Adaptive-ticks does not do anything unless there is only one
> 	runnable task for a given CPU, even though there are a number
> 	of other situations where the scheduling-clock tick is not
> 	needed.  To give but one example, consider a CPU that has one
> 	runnable high-priority SCHED_FIFO task and an arbitrary number
> 	of low-priority SCHED_OTHER tasks.  In this case, the CPU is
> 	required to run the SCHED_FIFO task until either it blocks or
> 	some other higher-priority task awakens on (or is assigned to)
> 	this CPU, so there is no point in sending a scheduling-clock
> 	interrupt to this CPU.

You should point out that the example does not enable adaptive-ticks.
That point is hinted at, but not really expressed. That is, perhaps end
the paragraph with: 

"Even though the SCHED_FIFO task is the only task running, because the
SCHED_OTHER tasks are queued on the CPU, it currently will not enter
adaptive tick mode."


> 
> 	Better handling of these sorts of situations is future work.
> 
> o	A reboot is required to reconfigure both adaptive idle and RCU
> 	callback offloading.  Runtime reconfiguration could be provided
> 	if needed, however, due to the complexity of reconfiguring RCU
> 	at runtime, there would need to be an earthshakingly good reason.
> 	Especially given the option of simply offloading RCU callbacks
> 	from all CPUs.

When you enable for all CPUs, how do you tell what CPUs you don't want
the scheduler to pick for off loading? I mean, if you pick all CPUs, can
you at run time pick which ones should always off load and which ones
shouldn't?

> 
> o	Additional configuration is required to deal with other sources
> 	of OS jitter, including interrupts and system-utility tasks
> 	and processes.  This configuration normally involves binding
> 	interrupts and tasks to particular CPUs.
> 
> o	Some sources of OS jitter can currently be eliminated only by
> 	constraining the workload.  For example, the only way to eliminate
> 	OS jitter due to global TLB shootdowns is to avoid the unmapping
> 	operations (such as kernel module unload operations) that result
> 	in these shootdowns.  For another example, page faults and TLB
> 	misses can be reduced (and in some cases eliminated) by using
> 	huge pages and by constraining the amount of memory used by the
> 	application.
> 
> o	At least one CPU must keep the scheduling-clock interrupt going
> 	in order to support accurate timekeeping.

Thanks for writing this up Paul!

-- Steve


