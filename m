Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3EELEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 07:04:01 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47433 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3EELD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 07:03:56 -0400
Date: Sun, 5 May 2013 13:03:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
Message-ID: <20130505110351.GA4768@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please consider pulling the latest timers-nohz-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus

   HEAD: 265f22a975c1e4cc3a4d1f94a3ec53ffbb6f5b9f sched: Keep at least 1 tick per second for active dynticks tasks

This tree from Frederic Weisbecker adds a new, (exciting! :-) core kernel 
feature to the timer and scheduler subsystems: 'full dynticks', or 
CONFIG_NO_HZ_FULL=y.

This feature extends the nohz variable-size timer tick feature from idle 
to busy CPUs (running at most one task) as well, potentially reducing the 
number of timer interrupts significantly.

This feature got motivated by real-time folks and the -rt tree, but the 
general utility and motivation of full-dynticks runs wider than that:

 - HPC workloads get faster: CPUs running a single task should be able to 
   utilize a maximum amount of CPU power. A periodic timer tick at HZ=1000 
   can cause a constant overhead of up to 1.0%. This feature removes that 
   overhead - and speeds up the system by 0.5%-1.0% on typical distro
   configs even on modern systems.

 - Real-time workload latency reduction: CPUs running critical tasks
   should experience as little jitter as possible. The last remaining 
   source of kernel-related jitter was the periodic timer tick.

 - A single task executing on a CPU is a pretty common situation, 
   especially with an increasing number of cores/CPUs, so this feature 
   helps desktop and mobile workloads as well.

The cost of the feature is mainly related to increased timer-reprogramming 
overhead when a CPU switches its tick period, and thus slightly longer 
to-idle and from-idle latency.

Configuration-wise a third mode of operation is added to the existing two 
NOHZ kconfig modes:

 - CONFIG_HZ_PERIODIC: [formerly !CONFIG_NO_HZ], now explicitly named as a
   config option. This is the traditional Linux periodic tick design: 
   there's a HZ tick going on all the time, regardless of whether a CPU is 
   idle or not.

 - CONFIG_NO_HZ_IDLE: [formerly CONFIG_NO_HZ=y], this turns off the 
   periodic tick when a CPU enters idle mode.

 - CONFIG_NO_HZ_FULL: this new mode, in addition to turning off the tick 
   when a CPU is idle, also slows the tick down to 1 Hz (one timer 
   interrupt per second) when only a single task is running on a CPU.

The .config behavior is compatible: existing !CONFIG_NO_HZ and 
CONFIG_NO_HZ=y settings get translated to the new values, without the user 
having to configure anything. CONFIG_NO_HZ_FULL is turned off by default.

This feature is based on a lot of infrastructure work that has been 
steadily going upstream in the last 2-3 cycles: related RCU support and 
non-periodic cputime support in particular is upstream already.

This tree adds the final pieces and activates the feature. The pull 
request is marked RFC because:

 - it's marked 64-bit only at the moment - the 32-bit support patch is 
   small but did not get ready in time.

 - it has a number of fresh commits that came in after the merge window. 
   The overwhelming majority of commits are from before the merge window,
   but still some aspects of the tree are fresh and so I marked it RFC.

 - it's a pretty wide-reaching feature with lots of effects - and while 
   the components have been in testing for some time, the full combination 
   is still not very widely used. That it's default-off should reduce its 
   regression abilities and obviously there are no known regressions with
   CONFIG_NO_HZ_FULL=y enabled either.

 - the feature is not completely idempotent: there is no 100% equivalent 
   replacement for a periodic scheduler/timer tick. In particular there's 
   ongoing work to map out and reduce its effects on scheduler 
   load-balancing and statistics. This should not impact correctness 
   though, there are no known regressions related to this feature at this 
   point.

 - it's a pretty ambitious feature that with time will likely be enabled 
   by most Linux distros, and we'd like you to make input on its
   design/implementation, if you dislike some aspect we missed. Without 
   flaming us to crisp! :-)

Future plans:

 - there's ongoing work to reduce 1Hz to 0Hz, to essentially shut
   off the periodic tick altogether when there's a single busy task on a 
   CPU. We'd first like 1 Hz to be exposed more widely before we go for
   the 0 Hz target though.

 - once we reach 0 Hz we can and remove the periodic tick assumption from
   nr_running>=2 as well, by essentially interrupting busy tasks only as
   frequently as the sched_latency constraints require us to do - once
   every 4-40 msecs, depending on nr_running.

I am personally leaning towards biting the bullet and doing this in v3.10, 
like the -rt tree this effort has been going on for too long - but the 
final word is up to you as usual.

More technical details can be found in Documentation/timers/NO_HZ.txt.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (34):
      nohz: Basic full dynticks interface
      nohz: Assign timekeeping duty to a CPU outside the full dynticks range
      nohz: Wake up full dynticks CPUs when a timer gets enqueued
      nohz: Unhide full dynticks feature from its dependencies
      nohz: Rename CONFIG_NO_HZ to CONFIG_NO_HZ_COMMON
      nohz: Pack nohz Kconfig option in a menu of choices
      nohz: Print final full dynticks CPUs range on boot
      nohz: Fix old dynticks idle Kconfig backward compatibility
      nohz: Switch from "extended nohz" to "full nohz" based naming
      nohz: Align periodic tick Kconfig with other choices' naming convention
      nohz: Improve a bit the full dynticks Kconfig documentation
      nohz: New APIs to re-evaluate the tick on full dynticks CPUs
      nohz: Force boot CPU outside full dynticks range
      nohz: Ensure full dynticks CPUs are RCU nocbs
      nohz: New option to default all CPUs in full dynticks range
      posix_timers: Kick full dynticks CPUs when a posix cpu timer is armed
      posix_timers: New API to prevent from stopping the tick when timers are running
      posix_timers: Fix pre-condition to stop the tick on full dynticks
      perf: Kick full dynticks CPU if events rotation is needed
      perf: New helper to prevent full dynticks CPUs from stopping tick
      sched: Kick full dynticks CPU that have more than one task enqueued.
      sched: New helper to prevent from stopping the tick in full dynticks
      nohz: Re-evaluate the tick from the scheduler IPI
      nohz: Implement full dynticks kick
      nohz: Prepare to stop the tick on irq exit
      nohz: Re-evaluate the tick for the new task after a context switch
      nohz: Disable the tick when irq resume in full dynticks CPU
      nohz: Select wide RCU nocb for full dynticks
      nohz: Add basic tracing
      nohz: Fix unavailable tick_stop tracepoint in dynticks idle
      nohz: Remove full dynticks' superfluous dependency on RCU tree
      nohz: Select VIRT_CPU_ACCOUNTING_GEN from full dynticks config
      rcu: Fix full dynticks' dependency on wide RCU nocb mode
      sched: Keep at least 1 tick per second for active dynticks tasks

Ingo Molnar (1):
      nohz: Reduce overhead under high-freq idling patterns

Kevin Hilman (1):
      cputime_nsecs: use math64.h for nsec resolution conversion helpers

Li Zhong (1):
      nohz: Protect smp_processor_id() in tick_nohz_task_switch()

Paul E. McKenney (2):
      rcu: Kick adaptive-ticks CPUs that are holding up RCU grace periods
      nohz_full: Add documentation.


 Documentation/RCU/stallwarn.txt         |   2 +-
 Documentation/cpu-freq/governors.txt    |   4 +-
 Documentation/kernel-parameters.txt     |   8 +
 Documentation/timers/NO_HZ.txt          | 273 +++++++++++++++++++++++++++++
 arch/um/include/shared/common-offsets.h |   4 +-
 arch/um/os-Linux/time.c                 |   2 +-
 include/asm-generic/cputime_nsecs.h     |  28 ++-
 include/linux/perf_event.h              |   6 +
 include/linux/posix-timers.h            |   2 +
 include/linux/rcupdate.h                |   7 +
 include/linux/sched.h                   |  19 +-
 include/linux/tick.h                    |  25 ++-
 include/trace/events/timer.h            |  21 +++
 init/Kconfig                            |  12 +-
 init/main.c                             |   1 +
 kernel/events/core.c                    |  17 +-
 kernel/hrtimer.c                        |   4 +-
 kernel/posix-cpu-timers.c               |  76 ++++++--
 kernel/rcutree.c                        |  16 +-
 kernel/rcutree.h                        |   2 +-
 kernel/rcutree_plugin.h                 |  29 +++-
 kernel/sched/core.c                     |  92 ++++++++--
 kernel/sched/fair.c                     |  10 +-
 kernel/sched/idle_task.c                |   1 +
 kernel/sched/sched.h                    |  25 ++-
 kernel/softirq.c                        |  19 +-
 kernel/time/Kconfig                     |  80 ++++++++-
 kernel/time/tick-broadcast.c            |   3 +-
 kernel/time/tick-common.c               |   5 +-
 kernel/time/tick-sched.c                | 296 ++++++++++++++++++++++++++++++--
 kernel/timer.c                          |  16 +-
 31 files changed, 988 insertions(+), 117 deletions(-)
 create mode 100644 Documentation/timers/NO_HZ.txt

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index e38b8df..8e9359d 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -191,7 +191,7 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
 o	A hardware or software issue shuts off the scheduler-clock
 	interrupt on a CPU that is not in dyntick-idle mode.  This
 	problem really has happened, and seems to be most likely to
-	result in RCU CPU stall warnings for CONFIG_NO_HZ=n kernels.
+	result in RCU CPU stall warnings for CONFIG_NO_HZ_COMMON=n kernels.
 
 o	A bug in the RCU implementation.
 
diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index c7a2eb8..e3e5d9a 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -131,8 +131,8 @@ sampling_rate_min:
 The sampling rate is limited by the HW transition latency:
 transition_latency * 100
 Or by kernel restrictions:
-If CONFIG_NO_HZ is set, the limit is 10ms fixed.
-If CONFIG_NO_HZ is not set or nohz=off boot parameter is used, the
+If CONFIG_NO_HZ_COMMON is set, the limit is 10ms fixed.
+If CONFIG_NO_HZ_COMMON is not set or nohz=off boot parameter is used, the
 limits depend on the CONFIG_HZ option:
 HZ=1000: min=20000us  (20ms)
 HZ=250:  min=80000us  (80ms)
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index de12397..7d55ebb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1951,6 +1951,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Valid arguments: on, off
 			Default: on
 
+	nohz_full=	[KNL,BOOT]
+			In kernels built with CONFIG_NO_HZ_FULL=y, set
+			the specified list of CPUs whose tick will be stopped
+			whenever possible. The boot CPU will be forced outside
+			the range to maintain the timekeeping.
+			The CPUs in this range must also be included in the
+			rcu_nocbs= set.
+
 	noiotrap	[SH] Disables trapped I/O port accesses.
 
 	noirqdebug	[X86-32] Disables the code which attempts to detect and
diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
new file mode 100644
index 0000000..5b53220
--- /dev/null
+++ b/Documentation/timers/NO_HZ.txt
@@ -0,0 +1,273 @@
+		NO_HZ: Reducing Scheduling-Clock Ticks
+
+
+This document describes Kconfig options and boot parameters that can
+reduce the number of scheduling-clock interrupts, thereby improving energy
+efficiency and reducing OS jitter.  Reducing OS jitter is important for
+some types of computationally intensive high-performance computing (HPC)
+applications and for real-time applications.
+
+There are two main contexts in which the number of scheduling-clock
+interrupts can be reduced compared to the old-school approach of sending
+a scheduling-clock interrupt to all CPUs every jiffy whether they need
+it or not (CONFIG_HZ_PERIODIC=y or CONFIG_NO_HZ=n for older kernels):
+
+1.	Idle CPUs (CONFIG_NO_HZ_IDLE=y or CONFIG_NO_HZ=y for older kernels).
+
+2.	CPUs having only one runnable task (CONFIG_NO_HZ_FULL=y).
+
+These two cases are described in the following two sections, followed
+by a third section on RCU-specific considerations and a fourth and final
+section listing known issues.
+
+
+IDLE CPUs
+
+If a CPU is idle, there is little point in sending it a scheduling-clock
+interrupt.  After all, the primary purpose of a scheduling-clock interrupt
+is to force a busy CPU to shift its attention among multiple duties,
+and an idle CPU has no duties to shift its attention among.
+
+The CONFIG_NO_HZ_IDLE=y Kconfig option causes the kernel to avoid sending
+scheduling-clock interrupts to idle CPUs, which is critically important
+both to battery-powered devices and to highly virtualized mainframes.
+A battery-powered device running a CONFIG_HZ_PERIODIC=y kernel would
+drain its battery very quickly, easily 2-3 times as fast as would the
+same device running a CONFIG_NO_HZ_IDLE=y kernel.  A mainframe running
+1,500 OS instances might find that half of its CPU time was consumed by
+unnecessary scheduling-clock interrupts.  In these situations, there
+is strong motivation to avoid sending scheduling-clock interrupts to
+idle CPUs.  That said, dyntick-idle mode is not free:
+
+1.	It increases the number of instructions executed on the path
+	to and from the idle loop.
+
+2.	On many architectures, dyntick-idle mode also increases the
+	number of expensive clock-reprogramming operations.
+
+Therefore, systems with aggressive real-time response constraints often
+run CONFIG_HZ_PERIODIC=y kernels (or CONFIG_NO_HZ=n for older kernels)
+in order to avoid degrading from-idle transition latencies.
+
+An idle CPU that is not receiving scheduling-clock interrupts is said to
+be "dyntick-idle", "in dyntick-idle mode", "in nohz mode", or "running
+tickless".  The remainder of this document will use "dyntick-idle mode".
+
+There is also a boot parameter "nohz=" that can be used to disable
+dyntick-idle mode in CONFIG_NO_HZ_IDLE=y kernels by specifying "nohz=off".
+By default, CONFIG_NO_HZ_IDLE=y kernels boot with "nohz=on", enabling
+dyntick-idle mode.
+
+
+CPUs WITH ONLY ONE RUNNABLE TASK
+
+If a CPU has only one runnable task, there is little point in sending it
+a scheduling-clock interrupt because there is no other task to switch to.
+
+The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to avoid
+sending scheduling-clock interrupts to CPUs with a single runnable task,
+and such CPUs are said to be "adaptive-ticks CPUs".  This is important
+for applications with aggressive real-time response constraints because
+it allows them to improve their worst-case response times by the maximum
+duration of a scheduling-clock interrupt.  It is also important for
+computationally intensive short-iteration workloads:  If any CPU is
+delayed during a given iteration, all the other CPUs will be forced to
+wait idle while the delayed CPU finishes.  Thus, the delay is multiplied
+by one less than the number of CPUs.  In these situations, there is
+again strong motivation to avoid sending scheduling-clock interrupts.
+
+By default, no CPU will be an adaptive-ticks CPU.  The "nohz_full="
+boot parameter specifies the adaptive-ticks CPUs.  For example,
+"nohz_full=1,6-8" says that CPUs 1, 6, 7, and 8 are to be adaptive-ticks
+CPUs.  Note that you are prohibited from marking all of the CPUs as
+adaptive-tick CPUs:  At least one non-adaptive-tick CPU must remain
+online to handle timekeeping tasks in order to ensure that system calls
+like gettimeofday() returns accurate values on adaptive-tick CPUs.
+(This is not an issue for CONFIG_NO_HZ_IDLE=y because there are no
+running user processes to observe slight drifts in clock rate.)
+Therefore, the boot CPU is prohibited from entering adaptive-ticks
+mode.  Specifying a "nohz_full=" mask that includes the boot CPU will
+result in a boot-time error message, and the boot CPU will be removed
+from the mask.
+
+Alternatively, the CONFIG_NO_HZ_FULL_ALL=y Kconfig parameter specifies
+that all CPUs other than the boot CPU are adaptive-ticks CPUs.  This
+Kconfig parameter will be overridden by the "nohz_full=" boot parameter,
+so that if both the CONFIG_NO_HZ_FULL_ALL=y Kconfig parameter and
+the "nohz_full=1" boot parameter is specified, the boot parameter will
+prevail so that only CPU 1 will be an adaptive-ticks CPU.
+
+Finally, adaptive-ticks CPUs must have their RCU callbacks offloaded.
+This is covered in the "RCU IMPLICATIONS" section below.
+
+Normally, a CPU remains in adaptive-ticks mode as long as possible.
+In particular, transitioning to kernel mode does not automatically change
+the mode.  Instead, the CPU will exit adaptive-ticks mode only if needed,
+for example, if that CPU enqueues an RCU callback.
+
+Just as with dyntick-idle mode, the benefits of adaptive-tick mode do
+not come for free:
+
+1.	CONFIG_NO_HZ_FULL selects CONFIG_NO_HZ_COMMON, so you cannot run
+	adaptive ticks without also running dyntick idle.  This dependency
+	extends down into the implementation, so that all of the costs
+	of CONFIG_NO_HZ_IDLE are also incurred by CONFIG_NO_HZ_FULL.
+
+2.	The user/kernel transitions are slightly more expensive due
+	to the need to inform kernel subsystems (such as RCU) about
+	the change in mode.
+
+3.	POSIX CPU timers on adaptive-tick CPUs may miss their deadlines
+	(perhaps indefinitely) because they currently rely on
+	scheduling-tick interrupts.  This will likely be fixed in
+	one of two ways: (1) Prevent CPUs with POSIX CPU timers from
+	entering adaptive-tick mode, or (2) Use hrtimers or other
+	adaptive-ticks-immune mechanism to cause the POSIX CPU timer to
+	fire properly.
+
+4.	If there are more perf events pending than the hardware can
+	accommodate, they are normally round-robined so as to collect
+	all of them over time.  Adaptive-tick mode may prevent this
+	round-robining from happening.  This will likely be fixed by
+	preventing CPUs with large numbers of perf events pending from
+	entering adaptive-tick mode.
+
+5.	Scheduler statistics for adaptive-tick CPUs may be computed
+	slightly differently than those for non-adaptive-tick CPUs.
+	This might in turn perturb load-balancing of real-time tasks.
+
+6.	The LB_BIAS scheduler feature is disabled by adaptive ticks.
+
+Although improvements are expected over time, adaptive ticks is quite
+useful for many types of real-time and compute-intensive applications.
+However, the drawbacks listed above mean that adaptive ticks should not
+(yet) be enabled by default.
+
+
+RCU IMPLICATIONS
+
+There are situations in which idle CPUs cannot be permitted to
+enter either dyntick-idle mode or adaptive-tick mode, the most
+common being when that CPU has RCU callbacks pending.
+
+The CONFIG_RCU_FAST_NO_HZ=y Kconfig option may be used to cause such CPUs
+to enter dyntick-idle mode or adaptive-tick mode anyway.  In this case,
+a timer will awaken these CPUs every four jiffies in order to ensure
+that the RCU callbacks are processed in a timely fashion.
+
+Another approach is to offload RCU callback processing to "rcuo" kthreads
+using the CONFIG_RCU_NOCB_CPU=y Kconfig option.  The specific CPUs to
+offload may be selected via several methods:
+
+1.	One of three mutually exclusive Kconfig options specify a
+	build-time default for the CPUs to offload:
+
+	a.	The CONFIG_RCU_NOCB_CPU_NONE=y Kconfig option results in
+		no CPUs being offloaded.
+
+	b.	The CONFIG_RCU_NOCB_CPU_ZERO=y Kconfig option causes
+		CPU 0 to be offloaded.
+
+	c.	The CONFIG_RCU_NOCB_CPU_ALL=y Kconfig option causes all
+		CPUs to be offloaded.  Note that the callbacks will be
+		offloaded to "rcuo" kthreads, and that those kthreads
+		will in fact run on some CPU.  However, this approach
+		gives fine-grained control on exactly which CPUs the
+		callbacks run on, along with their scheduling priority
+		(including the default of SCHED_OTHER), and it further
+		allows this control to be varied dynamically at runtime.
+
+2.	The "rcu_nocbs=" kernel boot parameter, which takes a comma-separated
+	list of CPUs and CPU ranges, for example, "1,3-5" selects CPUs 1,
+	3, 4, and 5.  The specified CPUs will be offloaded in addition to
+	any CPUs specified as offloaded by CONFIG_RCU_NOCB_CPU_ZERO=y or
+	CONFIG_RCU_NOCB_CPU_ALL=y.  This means that the "rcu_nocbs=" boot
+	parameter has no effect for kernels built with RCU_NOCB_CPU_ALL=y.
+
+The offloaded CPUs will never queue RCU callbacks, and therefore RCU
+never prevents offloaded CPUs from entering either dyntick-idle mode
+or adaptive-tick mode.  That said, note that it is up to userspace to
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
+	dyntick-idle mode, an option that most of them take.  However,
+	some workloads will no doubt want to use adaptive ticks to
+	eliminate scheduling-clock interrupt latencies.  Here are some
+	options for these workloads:
+
+	a.	Use PMQOS from userspace to inform the kernel of your
+		latency requirements (preferred).
+
+	b.	On x86 systems, use the "idle=mwait" boot parameter.
+
+	c.	On x86 systems, use the "intel_idle.max_cstate=" to limit
+	`	the maximum C-state depth.
+
+	d.	On x86 systems, use the "idle=poll" boot parameter.
+		However, please note that use of this parameter can cause
+		your CPU to overheat, which may cause thermal throttling
+		to degrade your latencies -- and that this degradation can
+		be even worse than that of dyntick-idle.  Furthermore,
+		this parameter effectively disables Turbo Mode on Intel
+		CPUs, which can significantly reduce maximum performance.
+
+o	Adaptive-ticks slows user/kernel transitions slightly.
+	This is not expected to be a problem for computationally intensive
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
+	required to run the SCHED_FIFO task until it either blocks or
+	some other higher-priority task awakens on (or is assigned to)
+	this CPU, so there is no point in sending a scheduling-clock
+	interrupt to this CPU.	However, the current implementation
+	nevertheless sends scheduling-clock interrupts to CPUs having a
+	single runnable SCHED_FIFO task and multiple runnable SCHED_OTHER
+	tasks, even though these interrupts are unnecessary.
+
+	Better handling of these sorts of situations is future work.
+
+o	A reboot is required to reconfigure both adaptive idle and RCU
+	callback offloading.  Runtime reconfiguration could be provided
+	if needed, however, due to the complexity of reconfiguring RCU at
+	runtime, there would need to be an earthshakingly good reason.
+	Especially given that you have the straightforward option of
+	simply offloading RCU callbacks from all CPUs and pinning them
+	where you want them whenever you want them pinned.
+
+o	Additional configuration is required to deal with other sources
+	of OS jitter, including interrupts and system-utility tasks
+	and processes.  This configuration normally involves binding
+	interrupts and tasks to particular CPUs.
+
+o	Some sources of OS jitter can currently be eliminated only by
+	constraining the workload.  For example, the only way to eliminate
+	OS jitter due to global TLB shootdowns is to avoid the unmapping
+	operations (such as kernel module unload operations) that
+	result in these shootdowns.  For another example, page faults
+	and TLB misses can be reduced (and in some cases eliminated) by
+	using huge pages and by constraining the amount of memory used
+	by the application.  Pre-faulting the working set can also be
+	helpful, especially when combined with the mlock() and mlockall()
+	system calls.
+
+o	Unless all CPUs are idle, at least one CPU must keep the
+	scheduling-clock interrupt going in order to support accurate
+	timekeeping.
+
+o	If there are adaptive-ticks CPUs, there will be at least one
+	CPU keeping the scheduling-clock interrupt going, even if all
+	CPUs are otherwise idle.
diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index 2df313b..c923068 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -30,8 +30,8 @@ DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
 #ifdef CONFIG_PRINTK
 DEFINE(UML_CONFIG_PRINTK, CONFIG_PRINTK);
 #endif
-#ifdef CONFIG_NO_HZ
-DEFINE(UML_CONFIG_NO_HZ, CONFIG_NO_HZ);
+#ifdef CONFIG_NO_HZ_COMMON
+DEFINE(UML_CONFIG_NO_HZ_COMMON, CONFIG_NO_HZ_COMMON);
 #endif
 #ifdef CONFIG_UML_X86
 DEFINE(UML_CONFIG_UML_X86, CONFIG_UML_X86);
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index fac388c..e9824d5 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -79,7 +79,7 @@ long long os_nsecs(void)
 	return timeval_to_ns(&tv);
 }
 
-#ifdef UML_CONFIG_NO_HZ
+#ifdef UML_CONFIG_NO_HZ_COMMON
 static int after_sleep_interval(struct timespec *ts)
 {
 	return 0;
diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index a8ece9a..2c9e62c 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -16,21 +16,27 @@
 #ifndef _ASM_GENERIC_CPUTIME_NSECS_H
 #define _ASM_GENERIC_CPUTIME_NSECS_H
 
+#include <linux/math64.h>
+
 typedef u64 __nocast cputime_t;
 typedef u64 __nocast cputime64_t;
 
 #define cputime_one_jiffy		jiffies_to_cputime(1)
 
+#define cputime_div(__ct, divisor)  div_u64((__force u64)__ct, divisor)
+#define cputime_div_rem(__ct, divisor, remainder) \
+	div_u64_rem((__force u64)__ct, divisor, remainder);
+
 /*
  * Convert cputime <-> jiffies (HZ)
  */
 #define cputime_to_jiffies(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+	cputime_div(__ct, NSEC_PER_SEC / HZ)
 #define cputime_to_scaled(__ct)		(__ct)
 #define jiffies_to_cputime(__jif)	\
 	(__force cputime_t)((__jif) * (NSEC_PER_SEC / HZ))
 #define cputime64_to_jiffies64(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / HZ))
+	cputime_div(__ct, NSEC_PER_SEC / HZ)
 #define jiffies64_to_cputime64(__jif)	\
 	(__force cputime64_t)((__jif) * (NSEC_PER_SEC / HZ))
 
@@ -45,7 +51,7 @@ typedef u64 __nocast cputime64_t;
  * Convert cputime <-> microseconds
  */
 #define cputime_to_usecs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_USEC)
+	cputime_div(__ct, NSEC_PER_USEC)
 #define usecs_to_cputime(__usecs)	\
 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
 #define usecs_to_cputime64(__usecs)	\
@@ -55,7 +61,7 @@ typedef u64 __nocast cputime64_t;
  * Convert cputime <-> seconds
  */
 #define cputime_to_secs(__ct)		\
-	((__force u64)(__ct) / NSEC_PER_SEC)
+	cputime_div(__ct, NSEC_PER_SEC)
 #define secs_to_cputime(__secs)		\
 	(__force cputime_t)((__secs) * NSEC_PER_SEC)
 
@@ -69,8 +75,10 @@ static inline cputime_t timespec_to_cputime(const struct timespec *val)
 }
 static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 {
-	val->tv_sec  = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_nsec = (__force u64) ct % NSEC_PER_SEC;
+	u32 rem;
+
+	val->tv_sec = cputime_div_rem(ct, NSEC_PER_SEC, &rem);
+	val->tv_nsec = rem;
 }
 
 /*
@@ -83,15 +91,17 @@ static inline cputime_t timeval_to_cputime(const struct timeval *val)
 }
 static inline void cputime_to_timeval(const cputime_t ct, struct timeval *val)
 {
-	val->tv_sec = (__force u64) ct / NSEC_PER_SEC;
-	val->tv_usec = ((__force u64) ct % NSEC_PER_SEC) / NSEC_PER_USEC;
+	u32 rem;
+
+	val->tv_sec = cputime_div_rem(ct, NSEC_PER_SEC, &rem);
+	val->tv_usec = rem / NSEC_PER_USEC;
 }
 
 /*
  * Convert cputime <-> clock (USER_HZ)
  */
 #define cputime_to_clock_t(__ct)	\
-	((__force u64)(__ct) / (NSEC_PER_SEC / USER_HZ))
+	cputime_div(__ct, (NSEC_PER_SEC / USER_HZ))
 #define clock_t_to_cputime(__x)		\
 	(__force cputime_t)((__x) * (NSEC_PER_SEC / USER_HZ))
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e0373d2..f463a46 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -788,6 +788,12 @@ static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
 #endif
 
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_NO_HZ_FULL)
+extern bool perf_event_can_stop_tick(void);
+#else
+static inline bool perf_event_can_stop_tick(void)			{ return true; }
+#endif
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
 extern void perf_restore_debug_store(void);
 #else
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 042058f..3698d9d 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -122,6 +122,8 @@ void run_posix_cpu_timers(struct task_struct *task);
 void posix_cpu_timers_exit(struct task_struct *task);
 void posix_cpu_timers_exit_group(struct task_struct *task);
 
+bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk);
+
 void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval);
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9ed2c9a..4ccd68e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1000,4 +1000,11 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define kfree_rcu(ptr, rcu_head)					\
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
+#ifdef CONFIG_RCU_NOCB_CPU
+extern bool rcu_is_nocb_cpu(int cpu);
+#else
+static inline bool rcu_is_nocb_cpu(int cpu) { return false; }
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 981ab68..af008d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -231,7 +231,7 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
 extern int get_nohz_timer_target(void);
@@ -1762,13 +1762,13 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
 }
 #endif
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 void calc_load_enter_idle(void);
 void calc_load_exit_idle(void);
 #else
 static inline void calc_load_enter_idle(void) { }
 static inline void calc_load_exit_idle(void) { }
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 #ifndef CONFIG_CPUMASK_OFFSTACK
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
@@ -1854,10 +1854,17 @@ extern void idle_task_exit(void);
 static inline void idle_task_exit(void) {}
 #endif
 
-#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-extern void wake_up_idle_cpu(int cpu);
+#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
+extern void wake_up_nohz_cpu(int cpu);
 #else
-static inline void wake_up_idle_cpu(int cpu) { }
+static inline void wake_up_nohz_cpu(int cpu) { }
+#endif
+
+#ifdef CONFIG_NO_HZ_FULL
+extern bool sched_can_stop_tick(void);
+extern u64 scheduler_tick_max_deferment(void);
+#else
+static inline bool sched_can_stop_tick(void) { return false; }
 #endif
 
 #ifdef CONFIG_SCHED_AUTOGROUP
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 553272e..9180f4b 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -82,7 +82,7 @@ extern int tick_program_event(ktime_t expires, int force);
 extern void tick_setup_sched_timer(void);
 # endif
 
-# if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
+# if defined CONFIG_NO_HZ_COMMON || defined CONFIG_HIGH_RES_TIMERS
 extern void tick_cancel_sched_timer(int cpu);
 # else
 static inline void tick_cancel_sched_timer(int cpu) { }
@@ -123,7 +123,7 @@ static inline void tick_check_idle(int cpu) { }
 static inline int tick_oneshot_mode_active(void) { return 0; }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
-# ifdef CONFIG_NO_HZ
+# ifdef CONFIG_NO_HZ_COMMON
 DECLARE_PER_CPU(struct tick_sched, tick_cpu_sched);
 
 static inline int tick_nohz_tick_stopped(void)
@@ -138,7 +138,7 @@ extern ktime_t tick_nohz_get_sleep_length(void);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 
-# else /* !CONFIG_NO_HZ */
+# else /* !CONFIG_NO_HZ_COMMON */
 static inline int tick_nohz_tick_stopped(void)
 {
 	return 0;
@@ -155,7 +155,24 @@ static inline ktime_t tick_nohz_get_sleep_length(void)
 }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
-# endif /* !NO_HZ */
+# endif /* !CONFIG_NO_HZ_COMMON */
+
+#ifdef CONFIG_NO_HZ_FULL
+extern void tick_nohz_init(void);
+extern int tick_nohz_full_cpu(int cpu);
+extern void tick_nohz_full_check(void);
+extern void tick_nohz_full_kick(void);
+extern void tick_nohz_full_kick_all(void);
+extern void tick_nohz_task_switch(struct task_struct *tsk);
+#else
+static inline void tick_nohz_init(void) { }
+static inline int tick_nohz_full_cpu(int cpu) { return 0; }
+static inline void tick_nohz_full_check(void) { }
+static inline void tick_nohz_full_kick(void) { }
+static inline void tick_nohz_full_kick_all(void) { }
+static inline void tick_nohz_task_switch(struct task_struct *tsk) { }
+#endif
+
 
 # ifdef CONFIG_CPU_IDLE_GOV_MENU
 extern void menu_hrtimer_cancel(void);
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 425bcfe..e967dd8 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -323,6 +323,27 @@ TRACE_EVENT(itimer_expire,
 		  (int) __entry->pid, (unsigned long long)__entry->now)
 );
 
+#ifdef CONFIG_NO_HZ_COMMON
+TRACE_EVENT(tick_stop,
+
+	TP_PROTO(int success, char *error_msg),
+
+	TP_ARGS(success, error_msg),
+
+	TP_STRUCT__entry(
+		__field( int ,		success	)
+		__string( msg, 		error_msg )
+	),
+
+	TP_fast_assign(
+		__entry->success	= success;
+		__assign_str(msg, error_msg);
+	),
+
+	TP_printk("success=%s msg=%s",  __entry->success ? "yes" : "no", __get_str(msg))
+);
+#endif
+
 #endif /*  _TRACE_TIMER_H */
 
 /* This part must be outside protection */
diff --git a/init/Kconfig b/init/Kconfig
index 4367e13..b3fdf9a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -302,7 +302,7 @@ choice
 # Kind of a stub config for the pure tick based cputime accounting
 config TICK_CPU_ACCOUNTING
 	bool "Simple tick based cputime accounting"
-	depends on !S390
+	depends on !S390 && !NO_HZ_FULL
 	help
 	  This is the basic tick based cputime accounting that maintains
 	  statistics about user, system and idle time spent on per jiffies
@@ -312,7 +312,7 @@ config TICK_CPU_ACCOUNTING
 
 config VIRT_CPU_ACCOUNTING_NATIVE
 	bool "Deterministic task and CPU time accounting"
-	depends on HAVE_VIRT_CPU_ACCOUNTING
+	depends on HAVE_VIRT_CPU_ACCOUNTING && !NO_HZ_FULL
 	select VIRT_CPU_ACCOUNTING
 	help
 	  Select this option to enable more accurate task and CPU time
@@ -342,7 +342,7 @@ config VIRT_CPU_ACCOUNTING_GEN
 
 config IRQ_TIME_ACCOUNTING
 	bool "Fine granularity task level IRQ time accounting"
-	depends on HAVE_IRQ_TIME_ACCOUNTING
+	depends on HAVE_IRQ_TIME_ACCOUNTING && !NO_HZ_FULL
 	help
 	  Select this option to enable fine granularity task irq time
 	  accounting. This is done by reading a timestamp on each
@@ -576,7 +576,7 @@ config RCU_FANOUT_EXACT
 
 config RCU_FAST_NO_HZ
 	bool "Accelerate last non-dyntick-idle CPU's grace periods"
-	depends on NO_HZ && SMP
+	depends on NO_HZ_COMMON && SMP
 	default n
 	help
 	  This option permits CPUs to enter dynticks-idle state even if
@@ -687,7 +687,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU
+	depends on RCU_NOCB_CPU && !NO_HZ_FULL
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -695,7 +695,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU
+	depends on RCU_NOCB_CPU && !NO_HZ_FULL
 	help
 	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
 	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
diff --git a/init/main.c b/init/main.c
index 12c3669..1952bf2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -545,6 +545,7 @@ asmlinkage void __init start_kernel(void)
 	idr_init_cache();
 	perf_event_init();
 	rcu_init();
+	tick_nohz_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3820e3c..6b41c18 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -18,6 +18,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/tick.h>
 #include <linux/sysfs.h>
 #include <linux/dcache.h>
 #include <linux/percpu.h>
@@ -685,8 +686,12 @@ static void perf_pmu_rotate_start(struct pmu *pmu)
 
 	WARN_ON(!irqs_disabled());
 
-	if (list_empty(&cpuctx->rotation_list))
+	if (list_empty(&cpuctx->rotation_list)) {
+		int was_empty = list_empty(head);
 		list_add(&cpuctx->rotation_list, head);
+		if (was_empty)
+			tick_nohz_full_kick();
+	}
 }
 
 static void get_ctx(struct perf_event_context *ctx)
@@ -2591,6 +2596,16 @@ done:
 		list_del_init(&cpuctx->rotation_list);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+bool perf_event_can_stop_tick(void)
+{
+	if (list_empty(&__get_cpu_var(rotation_list)))
+		return true;
+	else
+		return false;
+}
+#endif
+
 void perf_event_task_tick(void)
 {
 	struct list_head *head = &__get_cpu_var(rotation_list);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 14be27f..abfd89d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -161,7 +161,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
  */
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
 		return get_nohz_timer_target();
 #endif
@@ -1107,7 +1107,7 @@ ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /**
  * hrtimer_get_next_event - get the time until next expiry event
  *
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8fd709c..42670e9 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -10,6 +10,8 @@
 #include <linux/kernel_stat.h>
 #include <trace/events/timer.h>
 #include <linux/random.h>
+#include <linux/tick.h>
+#include <linux/workqueue.h>
 
 /*
  * Called after updating RLIMIT_CPU to run cpu timer and update
@@ -153,6 +155,21 @@ static void bump_cpu_timer(struct k_itimer *timer,
 	}
 }
 
+/**
+ * task_cputime_zero - Check a task_cputime struct for all zero fields.
+ *
+ * @cputime:	The struct to compare.
+ *
+ * Checks @cputime to see if all fields are zero.  Returns true if all fields
+ * are zero, false if any field is nonzero.
+ */
+static inline int task_cputime_zero(const struct task_cputime *cputime)
+{
+	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
+		return 1;
+	return 0;
+}
+
 static inline cputime_t prof_ticks(struct task_struct *p)
 {
 	cputime_t utime, stime;
@@ -636,6 +653,37 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 	return 0;
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+static void nohz_kick_work_fn(struct work_struct *work)
+{
+	tick_nohz_full_kick_all();
+}
+
+static DECLARE_WORK(nohz_kick_work, nohz_kick_work_fn);
+
+/*
+ * We need the IPIs to be sent from sane process context.
+ * The posix cpu timers are always set with irqs disabled.
+ */
+static void posix_cpu_timer_kick_nohz(void)
+{
+	schedule_work(&nohz_kick_work);
+}
+
+bool posix_cpu_timers_can_stop_tick(struct task_struct *tsk)
+{
+	if (!task_cputime_zero(&tsk->cputime_expires))
+		return false;
+
+	if (tsk->signal->cputimer.running)
+		return false;
+
+	return true;
+}
+#else
+static inline void posix_cpu_timer_kick_nohz(void) { }
+#endif
+
 /*
  * Guts of sys_timer_settime for CPU timers.
  * This is called with the timer locked and interrupts disabled.
@@ -794,6 +842,8 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		sample_to_timespec(timer->it_clock,
 				   old_incr, &old->it_interval);
 	}
+	if (!ret)
+		posix_cpu_timer_kick_nohz();
 	return ret;
 }
 
@@ -1008,21 +1058,6 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 	}
 }
 
-/**
- * task_cputime_zero - Check a task_cputime struct for all zero fields.
- *
- * @cputime:	The struct to compare.
- *
- * Checks @cputime to see if all fields are zero.  Returns true if all fields
- * are zero, false if any field is nonzero.
- */
-static inline int task_cputime_zero(const struct task_cputime *cputime)
-{
-	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
-		return 1;
-	return 0;
-}
-
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1336,6 +1371,13 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 			cpu_timer_fire(timer);
 		spin_unlock(&timer->it_lock);
 	}
+
+	/*
+	 * In case some timers were rescheduled after the queue got emptied,
+	 * wake up full dynticks CPUs.
+	 */
+	if (tsk->signal->cputimer.running)
+		posix_cpu_timer_kick_nohz();
 }
 
 /*
@@ -1366,7 +1408,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		}
 
 		if (!*newval)
-			return;
+			goto out;
 		*newval += now.cpu;
 	}
 
@@ -1384,6 +1426,8 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			tsk->signal->cputime_expires.virt_exp = *newval;
 		break;
 	}
+out:
+	posix_cpu_timer_kick_nohz();
 }
 
 static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d853430..16ea679 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -799,6 +799,16 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 		rdp->offline_fqs++;
 		return 1;
 	}
+
+	/*
+	 * There is a possibility that a CPU in adaptive-ticks state
+	 * might run in the kernel with the scheduling-clock tick disabled
+	 * for an extended time period.  Invoke rcu_kick_nohz_cpu() to
+	 * force the CPU to restart the scheduling-clock tick in this
+	 * CPU is in this state.
+	 */
+	rcu_kick_nohz_cpu(rdp->cpu);
+
 	return 0;
 }
 
@@ -1820,7 +1830,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 			  struct rcu_node *rnp, struct rcu_data *rdp)
 {
 	/* No-CBs CPUs do not have orphanable callbacks. */
-	if (is_nocb_cpu(rdp->cpu))
+	if (rcu_is_nocb_cpu(rdp->cpu))
 		return;
 
 	/*
@@ -2892,10 +2902,10 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * corresponding CPU's preceding callbacks have been invoked.
 	 */
 	for_each_possible_cpu(cpu) {
-		if (!cpu_online(cpu) && !is_nocb_cpu(cpu))
+		if (!cpu_online(cpu) && !rcu_is_nocb_cpu(cpu))
 			continue;
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (is_nocb_cpu(cpu)) {
+		if (rcu_is_nocb_cpu(cpu)) {
 			_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
 					   rsp->n_barrier_done);
 			atomic_inc(&rsp->barrier_cpu_count);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 14ee407..da77a8f 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -530,13 +530,13 @@ static int rcu_nocb_needs_gp(struct rcu_state *rsp);
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
-static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
+static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index d084ae3..71bd733 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -28,6 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
+#include <linux/tick.h>
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -2052,7 +2053,7 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 }
 
 /* Is the specified CPU a no-CPUs CPU? */
-static bool is_nocb_cpu(int cpu)
+bool rcu_is_nocb_cpu(int cpu)
 {
 	if (have_rcu_nocb_mask)
 		return cpumask_test_cpu(cpu, rcu_nocb_mask);
@@ -2110,7 +2111,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
 
-	if (!is_nocb_cpu(rdp->cpu))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
@@ -2134,7 +2135,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	long qll = rsp->qlen_lazy;
 
 	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
-	if (!is_nocb_cpu(smp_processor_id()))
+	if (!rcu_is_nocb_cpu(smp_processor_id()))
 		return 0;
 	rsp->qlen = 0;
 	rsp->qlen_lazy = 0;
@@ -2306,11 +2307,6 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 {
 }
 
-static bool is_nocb_cpu(int cpu)
-{
-	return false;
-}
-
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy)
 {
@@ -2337,3 +2333,20 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 }
 
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+
+/*
+ * An adaptive-ticks CPU can potentially execute in kernel mode for an
+ * arbitrarily long period of time with the scheduling-clock tick turned
+ * off.  RCU will be paying attention to this CPU because it is in the
+ * kernel, but the CPU cannot be guaranteed to be executing the RCU state
+ * machine because the scheduling-clock tick has been disabled.  Therefore,
+ * if an adaptive-ticks CPU is failing to respond to the current grace
+ * period and has not be idle from an RCU perspective, kick it.
+ */
+static void rcu_kick_nohz_cpu(int cpu)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(cpu))
+		smp_send_reschedule(cpu);
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c70a881..3bdf986 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -544,7 +544,7 @@ void resched_cpu(int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
  * from an idle cpu.  This is good for power-savings.
@@ -582,7 +582,7 @@ unlock:
  * account when the CPU goes back to idle and evaluates the timer
  * wheel for the next timer event.
  */
-void wake_up_idle_cpu(int cpu)
+static void wake_up_idle_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
@@ -612,20 +612,56 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static bool wake_up_full_nohz_cpu(int cpu)
+{
+	if (tick_nohz_full_cpu(cpu)) {
+		if (cpu != smp_processor_id() ||
+		    tick_nohz_tick_stopped())
+			smp_send_reschedule(cpu);
+		return true;
+	}
+
+	return false;
+}
+
+void wake_up_nohz_cpu(int cpu)
+{
+	if (!wake_up_full_nohz_cpu(cpu))
+		wake_up_idle_cpu(cpu);
+}
+
 static inline bool got_nohz_idle_kick(void)
 {
 	int cpu = smp_processor_id();
 	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
 }
 
-#else /* CONFIG_NO_HZ */
+#else /* CONFIG_NO_HZ_COMMON */
 
 static inline bool got_nohz_idle_kick(void)
 {
 	return false;
 }
 
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
+
+#ifdef CONFIG_NO_HZ_FULL
+bool sched_can_stop_tick(void)
+{
+       struct rq *rq;
+
+       rq = this_rq();
+
+       /* Make sure rq->nr_running update is visible after the IPI */
+       smp_rmb();
+
+       /* More than one running task need preemption */
+       if (rq->nr_running > 1)
+               return false;
+
+       return true;
+}
+#endif /* CONFIG_NO_HZ_FULL */
 
 void sched_avg_update(struct rq *rq)
 {
@@ -1357,7 +1393,8 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
+	    && !tick_nohz_full_cpu(smp_processor_id()))
 		return;
 
 	/*
@@ -1374,6 +1411,7 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
+	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
@@ -1855,6 +1893,8 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+
+	tick_nohz_task_switch(current);
 }
 
 #ifdef CONFIG_SMP
@@ -2118,7 +2158,7 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 	return load >> FSHIFT;
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * Handle NO_HZ for the global load-average.
  *
@@ -2344,12 +2384,12 @@ static void calc_global_nohz(void)
 	smp_wmb();
 	calc_load_idx++;
 }
-#else /* !CONFIG_NO_HZ */
+#else /* !CONFIG_NO_HZ_COMMON */
 
 static inline long calc_load_fold_idle(void) { return 0; }
 static inline void calc_global_nohz(void) { }
 
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
@@ -2509,7 +2549,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	sched_avg_update(this_rq);
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * There is no sane way to deal with nohz on smp when using jiffies because the
  * cpu doing the jiffies update might drift wrt the cpu doing the jiffy reading
@@ -2569,7 +2609,7 @@ void update_cpu_load_nohz(void)
 	}
 	raw_spin_unlock(&this_rq->lock);
 }
-#endif /* CONFIG_NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from scheduler_tick()
@@ -2696,7 +2736,34 @@ void scheduler_tick(void)
 	rq->idle_balance = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
+	rq_last_tick_reset(rq);
+}
+
+#ifdef CONFIG_NO_HZ_FULL
+/**
+ * scheduler_tick_max_deferment
+ *
+ * Keep at least one tick per second when a single
+ * active task is running because the scheduler doesn't
+ * yet completely support full dynticks environment.
+ *
+ * This makes sure that uptime, CFS vruntime, load
+ * balancing, etc... continue to move forward, even
+ * with a very low granularity.
+ */
+u64 scheduler_tick_max_deferment(void)
+{
+	struct rq *rq = this_rq();
+	unsigned long next, now = ACCESS_ONCE(jiffies);
+
+	next = rq->last_sched_tick + HZ;
+
+	if (time_before_eq(next, now))
+		return 0;
+
+	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
 }
+#endif
 
 notrace unsigned long get_parent_ip(unsigned long addr)
 {
@@ -6950,9 +7017,12 @@ void __init sched_init(void)
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
 		rq_attach_root(rq, &def_root_domain);
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 		rq->nohz_flags = 0;
 #endif
+#ifdef CONFIG_NO_HZ_FULL
+		rq->last_sched_tick = 0;
+#endif
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8bf7081..c61a614 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5355,7 +5355,7 @@ out_unlock:
 	return 0;
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * idle load balancing details
  * - When one of the busy CPUs notice that there may be an idle rebalancing
@@ -5572,9 +5572,9 @@ out:
 		rq->next_balance = next_balance;
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
- * In CONFIG_NO_HZ case, the idle balance kickee will do the
+ * In CONFIG_NO_HZ_COMMON case, the idle balance kickee will do the
  * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
 static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
@@ -5717,7 +5717,7 @@ void trigger_load_balance(struct rq *rq, int cpu)
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
 		nohz_balancer_kick(cpu);
 #endif
@@ -6187,7 +6187,7 @@ __init void init_sched_fair_class(void)
 #ifdef CONFIG_SMP
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b8ce773..d8da010 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -17,6 +17,7 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
 {
 	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
 }
 
 static void post_schedule_idle(struct rq *rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4c225c4..ce39224 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -5,6 +5,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
+#include <linux/tick.h>
 
 #include "cpupri.h"
 #include "cpuacct.h"
@@ -405,10 +406,13 @@ struct rq {
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	u64 nohz_stamp;
 	unsigned long nohz_flags;
 #endif
+#ifdef CONFIG_NO_HZ_FULL
+	unsigned long last_sched_tick;
+#endif
 	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
@@ -1072,6 +1076,16 @@ static inline u64 steal_ticks(u64 steal)
 static inline void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
+
+#ifdef CONFIG_NO_HZ_FULL
+	if (rq->nr_running == 2) {
+		if (tick_nohz_full_cpu(rq->cpu)) {
+			/* Order rq->nr_running write against the IPI */
+			smp_wmb();
+			smp_send_reschedule(rq->cpu);
+		}
+       }
+#endif
 }
 
 static inline void dec_nr_running(struct rq *rq)
@@ -1079,6 +1093,13 @@ static inline void dec_nr_running(struct rq *rq)
 	rq->nr_running--;
 }
 
+static inline void rq_last_tick_reset(struct rq *rq)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	rq->last_sched_tick = jiffies;
+#endif
+}
+
 extern void update_rq_clock(struct rq *rq);
 
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
@@ -1299,7 +1320,7 @@ extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 enum rq_nohz_flag_bits {
 	NOHZ_TICK_STOPPED,
 	NOHZ_BALANCE_KICK,
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 14d7758..51a09d5 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -329,6 +329,19 @@ static inline void invoke_softirq(void)
 		wakeup_softirqd();
 }
 
+static inline void tick_irq_exit(void)
+{
+#ifdef CONFIG_NO_HZ_COMMON
+	int cpu = smp_processor_id();
+
+	/* Make sure that timer wheel updates are propagated */
+	if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
+		if (!in_interrupt())
+			tick_nohz_irq_exit();
+	}
+#endif
+}
+
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
  */
@@ -346,11 +359,7 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-#ifdef CONFIG_NO_HZ
-	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
-		tick_nohz_irq_exit();
-#endif
+	tick_irq_exit();
 	rcu_irq_exit();
 }
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 24510d8..e4c07b0 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -64,20 +64,88 @@ config GENERIC_CMOS_UPDATE
 if GENERIC_CLOCKEVENTS
 menu "Timers subsystem"
 
-# Core internal switch. Selected by NO_HZ / HIGH_RES_TIMERS. This is
+# Core internal switch. Selected by NO_HZ_COMMON / HIGH_RES_TIMERS. This is
 # only related to the tick functionality. Oneshot clockevent devices
 # are supported independ of this.
 config TICK_ONESHOT
 	bool
 
-config NO_HZ
-	bool "Tickless System (Dynamic Ticks)"
+config NO_HZ_COMMON
+	bool
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
+
+choice
+	prompt "Timer tick handling"
+	default NO_HZ_IDLE if NO_HZ
+
+config HZ_PERIODIC
+	bool "Periodic timer ticks (constant rate, no dynticks)"
+	help
+	  This option keeps the tick running periodically at a constant
+	  rate, even when the CPU doesn't need it.
+
+config NO_HZ_IDLE
+	bool "Idle dynticks system (tickless idle)"
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+	select NO_HZ_COMMON
+	help
+	  This option enables a tickless idle system: timer interrupts
+	  will only trigger on an as-needed basis when the system is idle.
+	  This is usually interesting for energy saving.
+
+	  Most of the time you want to say Y here.
+
+config NO_HZ_FULL
+	bool "Full dynticks system (tickless)"
+	# NO_HZ_COMMON dependency
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
+	# We need at least one periodic CPU for timekeeping
+	depends on SMP
+	# RCU_USER_QS dependency
+	depends on HAVE_CONTEXT_TRACKING
+	# VIRT_CPU_ACCOUNTING_GEN dependency
+	depends on 64BIT
+	select NO_HZ_COMMON
+	select RCU_USER_QS
+	select RCU_NOCB_CPU
+	select VIRT_CPU_ACCOUNTING_GEN
+	select CONTEXT_TRACKING_FORCE
+	select IRQ_WORK
+	help
+	 Adaptively try to shutdown the tick whenever possible, even when
+	 the CPU is running tasks. Typically this requires running a single
+	 task on the CPU. Chances for running tickless are maximized when
+	 the task mostly runs in userspace and has few kernel activity.
+
+	 You need to fill up the nohz_full boot parameter with the
+	 desired range of dynticks CPUs.
+
+	 This is implemented at the expense of some overhead in user <-> kernel
+	 transitions: syscalls, exceptions and interrupts. Even when it's
+	 dynamically off.
+
+	 Say N.
+
+endchoice
+
+config NO_HZ_FULL_ALL
+       bool "Full dynticks system on all CPUs by default"
+       depends on NO_HZ_FULL
+       help
+         If the user doesn't pass the nohz_full boot option to
+	 define the range of full dynticks CPUs, consider that all
+	 CPUs in the system are full dynticks by default.
+	 Note the boot CPU will still be kept outside the range to
+	 handle the timekeeping duty.
+
+config NO_HZ
+	bool "Old Idle dynticks config"
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	help
-	  This option enables a tickless system: timer interrupts will
-	  only trigger on an as-needed basis both when the system is
-	  busy and when the system is idle.
+	  This is the old config entry that enables dynticks idle.
+	  We keep it around for a little while to enforce backward
+	  compatibility with older config files.
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7f32fe0..40c1050 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -574,7 +574,8 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
 		/* Take the do_timer update */
-		tick_do_timer_cpu = cpu;
+		if (!tick_nohz_full_cpu(cpu))
+			tick_do_timer_cpu = cpu;
 
 		/*
 		 * We must be careful here. There might be other CPUs
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..83f2bd9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -163,7 +163,10 @@ static void tick_setup_device(struct tick_device *td,
 		 * this cpu:
 		 */
 		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
-			tick_do_timer_cpu = cpu;
+			if (!tick_nohz_full_cpu(cpu))
+				tick_do_timer_cpu = cpu;
+			else
+				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 			tick_next_period = ktime_get();
 			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
 		}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a19a399..07929c6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,11 +21,15 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
+#include <linux/posix-timers.h>
+#include <linux/perf_event.h>
 
 #include <asm/irq_regs.h>
 
 #include "tick-internal.h"
 
+#include <trace/events/timer.h>
+
 /*
  * Per cpu nohz control structure
  */
@@ -104,7 +108,7 @@ static void tick_sched_do_timer(ktime_t now)
 {
 	int cpu = smp_processor_id();
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	/*
 	 * Check if the do_timer duty was dropped. We don't care about
 	 * concurrency: This happens only when the cpu in charge went
@@ -112,7 +116,8 @@ static void tick_sched_do_timer(ktime_t now)
 	 * this duty, then the jiffies update is still serialized by
 	 * jiffies_lock.
 	 */
-	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
+	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+	    && !tick_nohz_full_cpu(cpu))
 		tick_do_timer_cpu = cpu;
 #endif
 
@@ -123,7 +128,7 @@ static void tick_sched_do_timer(ktime_t now)
 
 static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 {
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
 	 * the watchdog as we might not schedule for a really long
@@ -142,10 +147,226 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 	profile_tick(CPU_PROFILING);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+static cpumask_var_t nohz_full_mask;
+bool have_nohz_full_mask;
+
+static bool can_stop_full_tick(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (!sched_can_stop_tick()) {
+		trace_tick_stop(0, "more than 1 task in runqueue\n");
+		return false;
+	}
+
+	if (!posix_cpu_timers_can_stop_tick(current)) {
+		trace_tick_stop(0, "posix timers running\n");
+		return false;
+	}
+
+	if (!perf_event_can_stop_tick()) {
+		trace_tick_stop(0, "perf events running\n");
+		return false;
+	}
+
+	/* sched_clock_tick() needs us? */
+#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
+	/*
+	 * TODO: kick full dynticks CPUs when
+	 * sched_clock_stable is set.
+	 */
+	if (!sched_clock_stable) {
+		trace_tick_stop(0, "unstable sched clock\n");
+		return false;
+	}
+#endif
+
+	return true;
+}
+
+static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now);
+
+/*
+ * Re-evaluate the need for the tick on the current CPU
+ * and restart it if necessary.
+ */
+void tick_nohz_full_check(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (tick_nohz_full_cpu(smp_processor_id())) {
+		if (ts->tick_stopped && !is_idle_task(current)) {
+			if (!can_stop_full_tick())
+				tick_nohz_restart_sched_tick(ts, ktime_get());
+		}
+	}
+}
+
+static void nohz_full_kick_work_func(struct irq_work *work)
+{
+	tick_nohz_full_check();
+}
+
+static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
+	.func = nohz_full_kick_work_func,
+};
+
+/*
+ * Kick the current CPU if it's full dynticks in order to force it to
+ * re-evaluate its dependency on the tick and restart it if necessary.
+ */
+void tick_nohz_full_kick(void)
+{
+	if (tick_nohz_full_cpu(smp_processor_id()))
+		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+}
+
+static void nohz_full_kick_ipi(void *info)
+{
+	tick_nohz_full_check();
+}
+
+/*
+ * Kick all full dynticks CPUs in order to force these to re-evaluate
+ * their dependency on the tick and restart it if necessary.
+ */
+void tick_nohz_full_kick_all(void)
+{
+	if (!have_nohz_full_mask)
+		return;
+
+	preempt_disable();
+	smp_call_function_many(nohz_full_mask,
+			       nohz_full_kick_ipi, NULL, false);
+	preempt_enable();
+}
+
+/*
+ * Re-evaluate the need for the tick as we switch the current task.
+ * It might need the tick due to per task/process properties:
+ * perf events, posix cpu timers, ...
+ */
+void tick_nohz_task_switch(struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (!tick_nohz_full_cpu(smp_processor_id()))
+		goto out;
+
+	if (tick_nohz_tick_stopped() && !can_stop_full_tick())
+		tick_nohz_full_kick();
+
+out:
+	local_irq_restore(flags);
+}
+
+int tick_nohz_full_cpu(int cpu)
+{
+	if (!have_nohz_full_mask)
+		return 0;
+
+	return cpumask_test_cpu(cpu, nohz_full_mask);
+}
+
+/* Parse the boot-time nohz CPU list from the kernel parameters. */
+static int __init tick_nohz_full_setup(char *str)
+{
+	int cpu;
+
+	alloc_bootmem_cpumask_var(&nohz_full_mask);
+	if (cpulist_parse(str, nohz_full_mask) < 0) {
+		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
+		return 1;
+	}
+
+	cpu = smp_processor_id();
+	if (cpumask_test_cpu(cpu, nohz_full_mask)) {
+		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		cpumask_clear_cpu(cpu, nohz_full_mask);
+	}
+	have_nohz_full_mask = true;
+
+	return 1;
+}
+__setup("nohz_full=", tick_nohz_full_setup);
+
+static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
+						 unsigned long action,
+						 void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_DOWN_PREPARE:
+		/*
+		 * If we handle the timekeeping duty for full dynticks CPUs,
+		 * we can't safely shutdown that CPU.
+		 */
+		if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
+			return -EINVAL;
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+/*
+ * Worst case string length in chunks of CPU range seems 2 steps
+ * separations: 0,2,4,6,...
+ * This is NR_CPUS + sizeof('\0')
+ */
+static char __initdata nohz_full_buf[NR_CPUS + 1];
+
+static int tick_nohz_init_all(void)
+{
+	int err = -1;
+
+#ifdef CONFIG_NO_HZ_FULL_ALL
+	if (!alloc_cpumask_var(&nohz_full_mask, GFP_KERNEL)) {
+		pr_err("NO_HZ: Can't allocate full dynticks cpumask\n");
+		return err;
+	}
+	err = 0;
+	cpumask_setall(nohz_full_mask);
+	cpumask_clear_cpu(smp_processor_id(), nohz_full_mask);
+	have_nohz_full_mask = true;
+#endif
+	return err;
+}
+
+void __init tick_nohz_init(void)
+{
+	int cpu;
+
+	if (!have_nohz_full_mask) {
+		if (tick_nohz_init_all() < 0)
+			return;
+	}
+
+	cpu_notifier(tick_nohz_cpu_down_callback, 0);
+
+	/* Make sure full dynticks CPU are also RCU nocbs */
+	for_each_cpu(cpu, nohz_full_mask) {
+		if (!rcu_is_nocb_cpu(cpu)) {
+			pr_warning("NO_HZ: CPU %d is not RCU nocb: "
+				   "cleared from nohz_full range", cpu);
+			cpumask_clear_cpu(cpu, nohz_full_mask);
+		}
+	}
+
+	cpulist_scnprintf(nohz_full_buf, sizeof(nohz_full_buf), nohz_full_mask);
+	pr_info("NO_HZ: Full dynticks CPUs: %s.\n", nohz_full_buf);
+}
+#else
+#define have_nohz_full_mask (0)
+#endif
+
 /*
  * NOHZ - aka dynamic tick functionality
  */
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * NO HZ enabled ?
  */
@@ -345,11 +566,12 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 			delta_jiffies = rcu_delta_jiffies;
 		}
 	}
+
 	/*
-	 * Do not stop the tick, if we are only one off
-	 * or if the cpu is required for rcu
+	 * Do not stop the tick, if we are only one off (or less)
+	 * or if the cpu is required for RCU:
 	 */
-	if (!ts->tick_stopped && delta_jiffies == 1)
+	if (!ts->tick_stopped && delta_jiffies <= 1)
 		goto out;
 
 	/* Schedule the tick, if we are at least one jiffie off */
@@ -378,6 +600,13 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 			time_delta = KTIME_MAX;
 		}
 
+#ifdef CONFIG_NO_HZ_FULL
+		if (!ts->inidle) {
+			time_delta = min(time_delta,
+					 scheduler_tick_max_deferment());
+		}
+#endif
+
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
@@ -421,6 +650,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
+			trace_tick_stop(1, " ");
 		}
 
 		/*
@@ -457,6 +687,24 @@ out:
 	return ret;
 }
 
+static void tick_nohz_full_stop_tick(struct tick_sched *ts)
+{
+#ifdef CONFIG_NO_HZ_FULL
+       int cpu = smp_processor_id();
+
+       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+               return;
+
+       if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
+	       return;
+
+       if (!can_stop_full_tick())
+               return;
+
+       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+#endif
+}
+
 static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 {
 	/*
@@ -489,6 +737,21 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
+	if (have_nohz_full_mask) {
+		/*
+		 * Keep the tick alive to guarantee timekeeping progression
+		 * if there are full dynticks CPUs around
+		 */
+		if (tick_do_timer_cpu == cpu)
+			return false;
+		/*
+		 * Boot safety: make sure the timekeeping duty has been
+		 * assigned before entering dyntick-idle mode,
+		 */
+		if (tick_do_timer_cpu == TICK_DO_TIMER_NONE)
+			return false;
+	}
+
 	return true;
 }
 
@@ -568,12 +831,13 @@ void tick_nohz_irq_exit(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 
-	if (!ts->inidle)
-		return;
-
-	/* Cancel the timer because CPU already waken up from the C-states*/
-	menu_hrtimer_cancel();
-	__tick_nohz_idle_enter(ts);
+	if (ts->inidle) {
+		/* Cancel the timer because CPU already waken up from the C-states*/
+		menu_hrtimer_cancel();
+		__tick_nohz_idle_enter(ts);
+	} else {
+		tick_nohz_full_stop_tick(ts);
+	}
 }
 
 /**
@@ -802,7 +1066,7 @@ static inline void tick_check_nohz(int cpu)
 static inline void tick_nohz_switch_to_nohz(void) { }
 static inline void tick_check_nohz(int cpu) { }
 
-#endif /* NO_HZ */
+#endif /* CONFIG_NO_HZ_COMMON */
 
 /*
  * Called from irq_enter to notify about the possible interruption of idle()
@@ -887,14 +1151,14 @@ void tick_setup_sched_timer(void)
 		now = ktime_get();
 	}
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 	if (tick_nohz_enabled)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
 
-#if defined CONFIG_NO_HZ || defined CONFIG_HIGH_RES_TIMERS
+#if defined CONFIG_NO_HZ_COMMON || defined CONFIG_HIGH_RES_TIMERS
 void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
diff --git a/kernel/timer.c b/kernel/timer.c
index dbf7a78..1b7489f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -738,7 +738,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	cpu = smp_processor_id();
 
-#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+#if defined(CONFIG_NO_HZ_COMMON) && defined(CONFIG_SMP)
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
 		cpu = get_nohz_timer_target();
 #endif
@@ -930,14 +930,14 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	debug_activate(timer, timer->expires);
 	internal_add_timer(base, timer);
 	/*
-	 * Check whether the other CPU is idle and needs to be
-	 * triggered to reevaluate the timer wheel when nohz is
-	 * active. We are protected against the other CPU fiddling
+	 * Check whether the other CPU is in dynticks mode and needs
+	 * to be triggered to reevaluate the timer wheel.
+	 * We are protected against the other CPU fiddling
 	 * with the timer by holding the timer base lock. This also
-	 * makes sure that a CPU on the way to idle can not evaluate
-	 * the timer wheel.
+	 * makes sure that a CPU on the way to stop its tick can not
+	 * evaluate the timer wheel.
 	 */
-	wake_up_idle_cpu(cpu);
+	wake_up_nohz_cpu(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
@@ -1188,7 +1188,7 @@ static inline void __run_timers(struct tvec_base *base)
 	spin_unlock_irq(&base->lock);
 }
 
-#ifdef CONFIG_NO_HZ
+#ifdef CONFIG_NO_HZ_COMMON
 /*
  * Find out when the next timer event is due to happen. This
  * is used on S/390 to stop all activity when a CPU is idle.
