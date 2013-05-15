Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab3EOTCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:02:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:58826 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab3EOTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:02:51 -0400
Date: Wed, 15 May 2013 21:02:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] core fixes for 3.10
Message-ID: <alpine.LFD.2.02.1305152059550.1388@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

Content:

   * Two fixlets for the fallout of the generic idle task conversion
   * Documentation update

Thanks,

	tglx

------------------>
Kevin Hilman (1):
      idle: Fix hlt/nohlt command-line handling in new generic idle

Paul E. McKenney (1):
      kthread: Document ways of reducing OS jitter due to per-CPU kthreads

Srivatsa S. Bhat (1):
      rcu/idle: Wrap cpu-idle poll mode within rcu_idle_enter/exit


 Documentation/kernel-per-CPU-kthreads.txt |  202 +++++++++++++++++++++++++++++
 arch/Kconfig                              |    3 +
 kernel/cpu/idle.c                         |    2 +
 3 files changed, 207 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/kernel-per-CPU-kthreads.txt

diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
new file mode 100644
index 0000000..cbf7ae4
--- /dev/null
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -0,0 +1,202 @@
+REDUCING OS JITTER DUE TO PER-CPU KTHREADS
+
+This document lists per-CPU kthreads in the Linux kernel and presents
+options to control their OS jitter.  Note that non-per-CPU kthreads are
+not listed here.  To reduce OS jitter from non-per-CPU kthreads, bind
+them to a "housekeeping" CPU dedicated to such work.
+
+
+REFERENCES
+
+o	Documentation/IRQ-affinity.txt:  Binding interrupts to sets of CPUs.
+
+o	Documentation/cgroups:  Using cgroups to bind tasks to sets of CPUs.
+
+o	man taskset:  Using the taskset command to bind tasks to sets
+	of CPUs.
+
+o	man sched_setaffinity:  Using the sched_setaffinity() system
+	call to bind tasks to sets of CPUs.
+
+o	/sys/devices/system/cpu/cpuN/online:  Control CPU N's hotplug state,
+	writing "0" to offline and "1" to online.
+
+o	In order to locate kernel-generated OS jitter on CPU N:
+
+		cd /sys/kernel/debug/tracing
+		echo 1 > max_graph_depth # Increase the "1" for more detail
+		echo function_graph > current_tracer
+		# run workload
+		cat per_cpu/cpuN/trace
+
+
+KTHREADS
+
+Name: ehca_comp/%u
+Purpose: Periodically process Infiniband-related work.
+To reduce its OS jitter, do any of the following:
+1.	Don't use eHCA Infiniband hardware, instead choosing hardware
+	that does not require per-CPU kthreads.  This will prevent these
+	kthreads from being created in the first place.  (This will
+	work for most people, as this hardware, though important, is
+	relatively old and is produced in relatively low unit volumes.)
+2.	Do all eHCA-Infiniband-related work on other CPUs, including
+	interrupts.
+3.	Rework the eHCA driver so that its per-CPU kthreads are
+	provisioned only on selected CPUs.
+
+
+Name: irq/%d-%s
+Purpose: Handle threaded interrupts.
+To reduce its OS jitter, do the following:
+1.	Use irq affinity to force the irq threads to execute on
+	some other CPU.
+
+Name: kcmtpd_ctr_%d
+Purpose: Handle Bluetooth work.
+To reduce its OS jitter, do one of the following:
+1.	Don't use Bluetooth, in which case these kthreads won't be
+	created in the first place.
+2.	Use irq affinity to force Bluetooth-related interrupts to
+	occur on some other CPU and furthermore initiate all
+	Bluetooth activity on some other CPU.
+
+Name: ksoftirqd/%u
+Purpose: Execute softirq handlers when threaded or when under heavy load.
+To reduce its OS jitter, each softirq vector must be handled
+separately as follows:
+TIMER_SOFTIRQ:  Do all of the following:
+1.	To the extent possible, keep the CPU out of the kernel when it
+	is non-idle, for example, by avoiding system calls and by forcing
+	both kernel threads and interrupts to execute elsewhere.
+2.	Build with CONFIG_HOTPLUG_CPU=y.  After boot completes, force
+	the CPU offline, then bring it back online.  This forces
+	recurring timers to migrate elsewhere.	If you are concerned
+	with multiple CPUs, force them all offline before bringing the
+	first one back online.  Once you have onlined the CPUs in question,
+	do not offline any other CPUs, because doing so could force the
+	timer back onto one of the CPUs in question.
+NET_TX_SOFTIRQ and NET_RX_SOFTIRQ:  Do all of the following:
+1.	Force networking interrupts onto other CPUs.
+2.	Initiate any network I/O on other CPUs.
+3.	Once your application has started, prevent CPU-hotplug operations
+	from being initiated from tasks that might run on the CPU to
+	be de-jittered.  (It is OK to force this CPU offline and then
+	bring it back online before you start your application.)
+BLOCK_SOFTIRQ:  Do all of the following:
+1.	Force block-device interrupts onto some other CPU.
+2.	Initiate any block I/O on other CPUs.
+3.	Once your application has started, prevent CPU-hotplug operations
+	from being initiated from tasks that might run on the CPU to
+	be de-jittered.  (It is OK to force this CPU offline and then
+	bring it back online before you start your application.)
+BLOCK_IOPOLL_SOFTIRQ:  Do all of the following:
+1.	Force block-device interrupts onto some other CPU.
+2.	Initiate any block I/O and block-I/O polling on other CPUs.
+3.	Once your application has started, prevent CPU-hotplug operations
+	from being initiated from tasks that might run on the CPU to
+	be de-jittered.  (It is OK to force this CPU offline and then
+	bring it back online before you start your application.)
+TASKLET_SOFTIRQ: Do one or more of the following:
+1.	Avoid use of drivers that use tasklets.  (Such drivers will contain
+	calls to things like tasklet_schedule().)
+2.	Convert all drivers that you must use from tasklets to workqueues.
+3.	Force interrupts for drivers using tasklets onto other CPUs,
+	and also do I/O involving these drivers on other CPUs.
+SCHED_SOFTIRQ: Do all of the following:
+1.	Avoid sending scheduler IPIs to the CPU to be de-jittered,
+	for example, ensure that at most one runnable kthread is present
+	on that CPU.  If a thread that expects to run on the de-jittered
+	CPU awakens, the scheduler will send an IPI that can result in
+	a subsequent SCHED_SOFTIRQ.
+2.	Build with CONFIG_RCU_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_ALL=y,
+	CONFIG_NO_HZ_FULL=y, and, in addition, ensure that the CPU
+	to be de-jittered is marked as an adaptive-ticks CPU using the
+	"nohz_full=" boot parameter.  This reduces the number of
+	scheduler-clock interrupts that the de-jittered CPU receives,
+	minimizing its chances of being selected to do the load balancing
+	work that runs in SCHED_SOFTIRQ context.
+3.	To the extent possible, keep the CPU out of the kernel when it
+	is non-idle, for example, by avoiding system calls and by
+	forcing both kernel threads and interrupts to execute elsewhere.
+	This further reduces the number of scheduler-clock interrupts
+	received by the de-jittered CPU.
+HRTIMER_SOFTIRQ:  Do all of the following:
+1.	To the extent possible, keep the CPU out of the kernel when it
+	is non-idle.  For example, avoid system calls and force both
+	kernel threads and interrupts to execute elsewhere.
+2.	Build with CONFIG_HOTPLUG_CPU=y.  Once boot completes, force the
+	CPU offline, then bring it back online.  This forces recurring
+	timers to migrate elsewhere.  If you are concerned with multiple
+	CPUs, force them all offline before bringing the first one
+	back online.  Once you have onlined the CPUs in question, do not
+	offline any other CPUs, because doing so could force the timer
+	back onto one of the CPUs in question.
+RCU_SOFTIRQ:  Do at least one of the following:
+1.	Offload callbacks and keep the CPU in either dyntick-idle or
+	adaptive-ticks state by doing all of the following:
+	a.	Build with CONFIG_RCU_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_ALL=y,
+		CONFIG_NO_HZ_FULL=y, and, in addition ensure that the CPU
+		to be de-jittered is marked as an adaptive-ticks CPU using
+		the "nohz_full=" boot parameter.  Bind the rcuo kthreads
+		to housekeeping CPUs, which can tolerate OS jitter.
+	b.	To the extent possible, keep the CPU out of the kernel
+		when it is non-idle, for example, by avoiding system
+		calls and by forcing both kernel threads and interrupts
+		to execute elsewhere.
+2.	Enable RCU to do its processing remotely via dyntick-idle by
+	doing all of the following:
+	a.	Build with CONFIG_NO_HZ=y and CONFIG_RCU_FAST_NO_HZ=y.
+	b.	Ensure that the CPU goes idle frequently, allowing other
+		CPUs to detect that it has passed through an RCU quiescent
+		state.	If the kernel is built with CONFIG_NO_HZ_FULL=y,
+		userspace execution also allows other CPUs to detect that
+		the CPU in question has passed through a quiescent state.
+	c.	To the extent possible, keep the CPU out of the kernel
+		when it is non-idle, for example, by avoiding system
+		calls and by forcing both kernel threads and interrupts
+		to execute elsewhere.
+
+Name: rcuc/%u
+Purpose: Execute RCU callbacks in CONFIG_RCU_BOOST=y kernels.
+To reduce its OS jitter, do at least one of the following:
+1.	Build the kernel with CONFIG_PREEMPT=n.  This prevents these
+	kthreads from being created in the first place, and also obviates
+	the need for RCU priority boosting.  This approach is feasible
+	for workloads that do not require high degrees of responsiveness.
+2.	Build the kernel with CONFIG_RCU_BOOST=n.  This prevents these
+	kthreads from being created in the first place.  This approach
+	is feasible only if your workload never requires RCU priority
+	boosting, for example, if you ensure frequent idle time on all
+	CPUs that might execute within the kernel.
+3.	Build with CONFIG_RCU_NOCB_CPU=y and CONFIG_RCU_NOCB_CPU_ALL=y,
+	which offloads all RCU callbacks to kthreads that can be moved
+	off of CPUs susceptible to OS jitter.  This approach prevents the
+	rcuc/%u kthreads from having any work to do, so that they are
+	never awakened.
+4.	Ensure that the CPU never enters the kernel, and, in particular,
+	avoid initiating any CPU hotplug operations on this CPU.  This is
+	another way of preventing any callbacks from being queued on the
+	CPU, again preventing the rcuc/%u kthreads from having any work
+	to do.
+
+Name: rcuob/%d, rcuop/%d, and rcuos/%d
+Purpose: Offload RCU callbacks from the corresponding CPU.
+To reduce its OS jitter, do at least one of the following:
+1.	Use affinity, cgroups, or other mechanism to force these kthreads
+	to execute on some other CPU.
+2.	Build with CONFIG_RCU_NOCB_CPUS=n, which will prevent these
+	kthreads from being created in the first place.  However, please
+	note that this will not eliminate OS jitter, but will instead
+	shift it to RCU_SOFTIRQ.
+
+Name: watchdog/%u
+Purpose: Detect software lockups on each CPU.
+To reduce its OS jitter, do at least one of the following:
+1.	Build with CONFIG_LOCKUP_DETECTOR=n, which will prevent these
+	kthreads from being created in the first place.
+2.	Echo a zero to /proc/sys/kernel/watchdog to disable the
+	watchdog timer.
+3.	Echo a large number of /proc/sys/kernel/watchdog_thresh in
+	order to reduce the frequency of OS jitter due to the watchdog
+	timer down to a level that is acceptable for your workload.
diff --git a/arch/Kconfig b/arch/Kconfig
index 99f0e17..3e64403 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -213,6 +213,9 @@ config USE_GENERIC_SMP_HELPERS
 config GENERIC_SMP_IDLE_THREAD
        bool
 
+config GENERIC_IDLE_POLL_SETUP
+       bool
+
 # Select if arch init_task initializer is different to init/init_task.c
 config ARCH_INIT_TASK
        bool
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 8b86c0c..d5585f5 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -40,11 +40,13 @@ __setup("hlt", cpu_idle_nopoll_setup);
 
 static inline int cpu_idle_poll(void)
 {
+	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	rcu_idle_exit();
 	return 1;
 }
 
