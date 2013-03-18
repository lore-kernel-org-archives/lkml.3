Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3CRQbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:31:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56279 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab3CRQbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:31:19 -0400
Date: Mon, 18 Mar 2013 09:29:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org, rostedt@goodmis.org,
        zhong@linux.vnet.ibm.com, khilman@linaro.org, geoff@infradead.org,
        tglx@linutronix.de
Subject: [PATCH] nohz1: Documentation
Message-ID: <20130318162942.GA9359@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031816-9360-0000-0000-0000115ECF14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First attempt at documentation for adaptive ticks.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

nohz1: Documentation

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
new file mode 100644
index 0000000..7279109
--- /dev/null
+++ b/Documentation/timers/NO_HZ.txt
@@ -0,0 +1,200 @@
+		NO_HZ: Reducing Scheduling-Clock Ticks
+
+
+This document covers kernel configuration variables used to reduce
+the number of scheduling-clock interrupts.  These reductions can be
+helpful in improving energy efficiency and in reducing "OS jitter",
+the latter being very important for some types of computationally
+intensive high-performance computing (HPC) applications and for real-time
+applications.
+
+Within the Linux kernel, there are two major aspects of scheduling-clock
+interrupt reduction:
+
+1.	Idle CPUs.
+
+2.	CPUs having only one runnable task.
+
+These two cases are described in the following sections.
+
+
+IDLE CPUs
+
+If a CPU is idle, there is little point in sending it a scheduling-clock
+interrupt.  After all, the primary purpose of a scheduling-clock interrupt
+is to force a busy CPU to shift its attention among multiple duties,
+but an idle CPU by definition has no duties to shift its attention among.
+
+The CONFIG_NO_HZ=y Kconfig option causes the kernel to avoid sending
+scheduling-clock interrupts to idle CPUs, which is critically important
+both to battery-powered devices and to highly virtualized mainframes.
+A battery-powered device running a CONFIG_NO_HZ=n kernel would drain its
+battery very quickly, easily 2-3x as fast as would the same device running
+a CONFIG_NO_HZ=n kernel.  A mainframe running 1,500 OS instances could
+easily find that half of its CPU time was consumed by scheduling-clock
+interrupts.  In these situations, there is therefore strong motivation
+to avoid sending scheduling-clock interrupts to idle CPUs.  That said,
+dyntick-idle mode is not free:
+
+1.	It increases the number of instructions executed on the path
+	to and from the idle loop.
+
+2.	Many architectures will place dyntick-idle CPUs into deep sleep
+	states, which further degrades from-idle transition latencies.
+
+Therefore, systems with aggressive real-time response constraints
+often run CONFIG_NO_HZ=n kernels in order to avoid degrading from-idle
+transition latencies.
+
+An idle CPU that is not receiving scheduling-clock interrupts is said to
+be "dyntick-idle", "in dyntick-idle mode", "in nohz mode", or "running
+tickless".  The remainder of this document will use "dyntick-idle mode".
+
+There is also a boot parameter "nohz=" that can be used to disable
+dyntick-idle mode in CONFIG_NO_HZ=y kernels by specifying "nohz=off".
+By default, CONFIG_NO_HZ=y kernels boot with "nohz=on", enabling
+dyntick-idle mode.
+
+
+CPUs WITH ONLY ONE RUNNABLE TASK
+
+If a CPU has only one runnable task, there is again little point in
+sending it a scheduling-clock interrupt.  Recall that the primary
+purpose of a scheduling-clock interrupt is to force a busy CPU to
+shift its attention among many things requiring its attention -- and
+there is nowhere else for a CPU with but one runnable task to shift its
+attention to.
+
+The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to avoid
+sending scheduling-clock interrupts to CPUs with a single runnable task.
+This is important for applications with aggressive real-time response
+constraints because it allows them to improve their worst-case response
+times by the maximum duration of a scheduling-clock interrupt.  It is also
+important for computationally intensive iterative workloads with short
+iterations:  If any CPU is delayed during a given iteration, all the
+other CPUs will be forced to wait idle while the delayed CPU finished.
+Thus, the delay is multiplied by one less than the number of CPUs.
+In these situations, there is again strong motivation to avoid sending
+scheduling-clock interrupts to CPUs that have but one runnable task that
+is executing in user mode.
+
+Note that if a given CPU is in adaptive-ticks mode while executing in
+user mode, transitioning to kernel mode does not automatically force
+that CPU out of adaptive-ticks mode.  The CPU will exit adaptive-ticks
+mode only if needed, for example, if that CPU enqueues an RCU callback.
+
+Just as with dyntick-idle mode, the benefits of adaptive-tick mode do
+not come for free:
+
+1.	The user/kernel transitions are slightly more expensive due
+	to the need to inform kernel subsystems (such as RCU) about
+	the change in mode.
+
+2.	POSIX CPU timers on adaptive-tick CPUs may fire late (or even
+	not at all) because they currently rely on scheduling-tick
+	interrupts.  This will likely be fixed in one of two ways: (1)
+	Prevent CPUs with POSIX CPU timers from entering adaptive-tick
+	mode, or (2) Use hrtimers or other adaptive-ticks-immune mechanism
+	to cause the POSIX CPU timer to fire properly.
+
+3.	If there are more perf events pending than the hardware can
+	accommodate, they are normally round-robined so as to collect
+	all of them over time.  Adaptive-tick mode may prevent this
+	round-robining from happening.  This will likely be fixed by
+	preventing CPUs with large numbers of perf events pending from
+	entering adaptive-tick mode.
+
+4.	Scheduler statistics for adaptive-idle CPUs may be computed
+	slightly differently than those for non-adaptive-idle CPUs.
+	This may in turn perturb load-balancing of real-time tasks.
+
+5.	The LB_BIAS scheduler feature is disabled by adaptive ticks.
+
+Although improvements are expected over time, adaptive ticks is quite
+useful for many types of real-time and compute-intensive applications.
+However, the drawbacks listed above mean that adaptive ticks should not
+be enabled by default across the board at the current time.
+
+
+RCU IMPLICATIONS
+
+There are situations in which idle CPUs cannot be permitted to
+enter either dyntick-idle mode or adaptive-tick mode, the most
+familiar being the case where that CPU has RCU callbacks pending.
+
+The CONFIG_RCU_FAST_NO_HZ=y Kconfig option may be used to cause such
+CPUs to enter dyntick-idle mode or adaptive-tick mode anyway, though a
+timer will awaken these CPUs every four jiffies in order to ensure that
+the RCU callbacks are processed in a timely fashion.
+
+Another approach is to offload RCU callback processing to "rcuo" kthreads
+using the CONFIG_RCU_NOCB_CPU=y.  The specific CPUs to offload may be
+selected via several methods:
+
+1.	The "rcu_nocbs=" kernel boot parameter, which takes a comma-separated
+	list of CPUs and CPU ranges, for example, "1,3-5" selects CPUs 1,
+	3, 4, and 5.
+
+2.	The RCU_NOCB_CPU_ZERO=y Kconfig option, which causes CPU 0 to
+	be offloaded.  This is the build-time equivalent of "rcu_nocbs=0".
+
+3.	The RCU_NOCB_CPU_ALL=y Kconfig option, which causes all CPUs
+	to be offloaded.  On a 16-CPU system, this is equivalent to
+	"rcu_nocbs=0-15".
+
+The offloaded CPUs never have RCU callbacks queued, and therefore RCU
+never prevents offloaded CPUs from entering either dyntick-idle mode or
+adaptive-tick mode.  That said, note that it is up to userspace to
+pin the "rcuo" kthreads to specific CPUs if desired.  Otherwise, the
+scheduler will decide where to run them, which might or might not be
+where you want them to run.
+
+
+KNOWN ISSUES
+
+o	Dyntick-idle slows transitions to and from idle slightly.
+	In practice, this has not been a problem except for the most
+	aggressive real-time workloads, which have the option of disabling
+	dyntick-idle mode, an option that most of them take.
+
+o	Adaptive-ticks slows user/kernel transitions slightly.
+	This is not expected to be a problem for computational-intensive
+	workloads, which have few such transitions.  Careful benchmarking
+	will be required to determine whether or not other workloads
+	are significantly affected by this effect.
+
+o	Adaptive-ticks does not do anything unless there is only one
+	runnable task for a given CPU, even though there are a number
+	of other situations where the scheduling-clock tick is not
+	needed.  To give but one example, consider a CPU that has one
+	runnable high-priority SCHED_FIFO task and an arbitrary number
+	of low-priority SCHED_OTHER tasks.  In this case, the CPU is
+	required to run the SCHED_FIFO task until either it blocks or
+	some other higher-priority task awakens on (or is assigned to)
+	this CPU, so there is no point in sending a scheduling-clock
+	interrupt to this CPU.
+
+	Better handling of these sorts of situations is future work.
+
+o	A reboot is required to reconfigure both adaptive idle and RCU
+	callback offloading.  Runtime reconfiguration could be provided
+	if needed, however, due to the complexity of reconfiguring RCU
+	at runtime, there would need to be an earthshakingly good reason.
+	Especially given the option of simply offloading RCU callbacks
+	from all CPUs.
+
+o	Additional configuration is required to deal with other sources
+	of OS jitter, including interrupts and system-utility tasks
+	and processes.
+
+o	Some sources of OS jitter can currently be eliminated only by
+	constraining the workload.  For example, the only way to eliminate
+	OS jitter due to global TLB shootdowns is to avoid the unmapping
+	operations (such as kernel module unload operations) that result
+	in these shootdowns.  For another example, page faults and TLB
+	misses can be reduced (and in some cases eliminated) by using
+	huge pages and by constraining the amount of memory used by the
+	application.
+
+o	At least one CPU must keep the scheduling-clock interrupt going
+	in order to support accurate timekeeping.

