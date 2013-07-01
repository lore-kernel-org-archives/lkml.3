Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3GAIbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:31:41 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53713 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3GAIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:31:38 -0400
Date: Mon, 1 Jul 2013 10:31:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.11
Message-ID: <20130701083133.GA14271@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest RCU git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: b1fe9987b78755719e8627d58409174ba00c24de Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The major changes:
    
  - Simplify RCU's grace-period and callback processing based on
    the new numbering for callbacks.
    
  - Removal of TINY_PREEMPT_RCU in favor of TREE_PREEMPT_RCU for
    single-CPU low-latency systems.

  - SRCU-related changes and fixes.
    
  - Miscellaneous fixes, including converting a few remaining printk()
    calls to pr_*().
    
  - Documentation updates.
    
 Thanks,

	Ingo

------------------>
Lai Jiangshan (1):
      powerpc,kvm: fix imbalance srcu_read_[un]lock()

Paul E. McKenney (31):
      rcu: Convert rcutree.c printk calls
      rcu: Move code to apply callback-numbering simplifications
      rcu: Make __note_new_gpnum() check for ends of prior grace periods
      rcu: Rename note_new_gpnum() to note_gp_changes()
      rcu: Convert rcutree_plugin.h printk calls
      rcu: Switch callers from rcu_process_gp_end() to note_gp_changes()
      rcu: Merge __rcu_process_gp_end() into __note_gp_changes()
      rcu: Eliminate check_for_new_grace_period() wrapper function
      rcu: Inline trivial wrapper function rcu_start_gp_per_cpu()
      rcu: Move redundant call to note_gp_changes() into called function
      nohz_full: Update based on Sedat Dilek review
      nohz_full: Document additional restrictions
      kthread: Add kworker kthreads to OS-jitter documentation
      rcu: Remove "Experimental" flags
      rcu: Drive quiescent-state-forcing delay from HZ
      rcu: Merge adjacent identical ifdefs
      rcu: Apply Dave Jones's NOCB Kconfig help feedback
      rcu: Remove srcu_read_lock_raw() and srcu_read_unlock_raw().
      rcu: Remove TINY_PREEMPT_RCU
      rcu: Remove show_tiny_preempt_stats()
      rcu: Remove rcu_preempt_check_callbacks()
      rcu: Remove rcu_preempt_remove_callbacks()
      rcu: Remove rcu_preempt_process_callbacks()
      rcu: Simplify RCU_TINY RCU callback invocation
      rcu: Remove check_cpu_stall_preempt()
      rcu: Remove the CONFIG_TINY_RCU ifdefs in rcutiny.h
      rcu: Remove rcu_preempt_note_context_switch()
      rcu: Consolidate rcutiny_plugin.h ifdefs
      rcu: Remove TINY_PREEMPT_RCU tracing documentation
      rcu: Shrink TINY_RCU by moving exit_rcu()
      rcu: Shrink TINY_RCU by reworking CPU-stall ifdefs


 Documentation/RCU/checklist.txt           |    6 -
 Documentation/RCU/torture.txt             |    6 -
 Documentation/RCU/trace.txt               |  100 +--
 Documentation/RCU/whatisRCU.txt           |   22 +-
 Documentation/kernel-per-CPU-kthreads.txt |   47 ++
 Documentation/timers/NO_HZ.txt            |   79 ++-
 arch/powerpc/kvm/book3s_hv.c              |    2 +-
 include/linux/hardirq.h                   |    2 +-
 include/linux/rcupdate.h                  |    5 +-
 include/linux/rcutiny.h                   |   41 +-
 include/linux/rcutree.h                   |    3 +-
 include/linux/srcu.h                      |   43 --
 init/Kconfig                              |   46 +-
 kernel/rcupdate.c                         |   29 +-
 kernel/rcutiny.c                          |   21 +-
 kernel/rcutiny_plugin.h                   | 1009 +----------------------------
 kernel/rcutorture.c                       |   39 --
 kernel/rcutree.c                          |  168 ++---
 kernel/rcutree.h                          |   15 +-
 kernel/rcutree_plugin.h                   |   81 ++-
 20 files changed, 316 insertions(+), 1448 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 79e789b8..7703ec7 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -354,12 +354,6 @@ over a rather long period of time, but improvements are always welcome!
 	using RCU rather than SRCU, because RCU is almost always faster
 	and easier to use than is SRCU.
 
-	If you need to enter your read-side critical section in a
-	hardirq or exception handler, and then exit that same read-side
-	critical section in the task that was interrupted, then you need
-	to srcu_read_lock_raw() and srcu_read_unlock_raw(), which avoid
-	the lockdep checking that would otherwise this practice illegal.
-
 	Also unlike other forms of RCU, explicit initialization
 	and cleanup is required via init_srcu_struct() and
 	cleanup_srcu_struct().	These are passed a "struct srcu_struct"
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 7dce8a1..d8a5023 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -182,12 +182,6 @@ torture_type	The type of RCU to test, with string values as follows:
 		"srcu_expedited": srcu_read_lock(), srcu_read_unlock() and
 			synchronize_srcu_expedited().
 
-		"srcu_raw": srcu_read_lock_raw(), srcu_read_unlock_raw(),
-			and call_srcu().
-
-		"srcu_raw_sync": srcu_read_lock_raw(), srcu_read_unlock_raw(),
-			and synchronize_srcu().
-
 		"sched": preempt_disable(), preempt_enable(), and
 			call_rcu_sched().
 
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index c776968..f3778f8 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -530,113 +530,21 @@ o	"nos" counts the number of times we balked for other
 	reasons, e.g., the grace period ended first.
 
 
-CONFIG_TINY_RCU and CONFIG_TINY_PREEMPT_RCU debugfs Files and Formats
+CONFIG_TINY_RCU debugfs Files and Formats
 
 These implementations of RCU provides a single debugfs file under the
 top-level directory RCU, namely rcu/rcudata, which displays fields in
-rcu_bh_ctrlblk, rcu_sched_ctrlblk and, for CONFIG_TINY_PREEMPT_RCU,
-rcu_preempt_ctrlblk.
+rcu_bh_ctrlblk and rcu_sched_ctrlblk.
 
 The output of "cat rcu/rcudata" is as follows:
 
-rcu_preempt: qlen=24 gp=1097669 g197/p197/c197 tasks=...
-             ttb=. btg=no ntb=184 neb=0 nnb=183 j=01f7 bt=0274
-             normal balk: nt=1097669 gt=0 bt=371 b=0 ny=25073378 nos=0
-             exp balk: bt=0 nos=0
 rcu_sched: qlen: 0
 rcu_bh: qlen: 0
 
-This is split into rcu_preempt, rcu_sched, and rcu_bh sections, with the
-rcu_preempt section appearing only in CONFIG_TINY_PREEMPT_RCU builds.
-The last three lines of the rcu_preempt section appear only in
-CONFIG_RCU_BOOST kernel builds.  The fields are as follows:
+This is split into rcu_sched and rcu_bh sections.  The field is as
+follows:
 
 o	"qlen" is the number of RCU callbacks currently waiting either
 	for an RCU grace period or waiting to be invoked.  This is the
 	only field present for rcu_sched and rcu_bh, due to the
 	short-circuiting of grace period in those two cases.
-
-o	"gp" is the number of grace periods that have completed.
-
-o	"g197/p197/c197" displays the grace-period state, with the
-	"g" number being the number of grace periods that have started
-	(mod 256), the "p" number being the number of grace periods
-	that the CPU has responded to (also mod 256), and the "c"
-	number being the number of grace periods that have completed
-	(once again mode 256).
-
-	Why have both "gp" and "g"?  Because the data flowing into
-	"gp" is only present in a CONFIG_RCU_TRACE kernel.
-
-o	"tasks" is a set of bits.  The first bit is "T" if there are
-	currently tasks that have recently blocked within an RCU
-	read-side critical section, the second bit is "N" if any of the
-	aforementioned tasks are blocking the current RCU grace period,
-	and the third bit is "E" if any of the aforementioned tasks are
-	blocking the current expedited grace period.  Each bit is "."
-	if the corresponding condition does not hold.
-
-o	"ttb" is a single bit.  It is "B" if any of the blocked tasks
-	need to be priority boosted and "." otherwise.
-
-o	"btg" indicates whether boosting has been carried out during
-	the current grace period, with "exp" indicating that boosting
-	is in progress for an expedited grace period, "no" indicating
-	that boosting has not yet started for a normal grace period,
-	"begun" indicating that boosting has bebug for a normal grace
-	period, and "done" indicating that boosting has completed for
-	a normal grace period.
-
-o	"ntb" is the total number of tasks subjected to RCU priority boosting
-	periods since boot.
-
-o	"neb" is the number of expedited grace periods that have had
-	to resort to RCU priority boosting since boot.
-
-o	"nnb" is the number of normal grace periods that have had
-	to resort to RCU priority boosting since boot.
-
-o	"j" is the low-order 16 bits of the jiffies counter in hexadecimal.
-
-o	"bt" is the low-order 16 bits of the value that the jiffies counter
-	will have at the next time that boosting is scheduled to begin.
-
-o	In the line beginning with "normal balk", the fields are as follows:
-
-	o	"nt" is the number of times that the system balked from
-		boosting because there were no blocked tasks to boost.
-		Note that the system will balk from boosting even if the
-		grace period is overdue when the currently running task
-		is looping within an RCU read-side critical section.
-		There is no point in boosting in this case, because
-		boosting a running task won't make it run any faster.
-
-	o	"gt" is the number of times that the system balked
-		from boosting because, although there were blocked tasks,
-		none of them were preventing the current grace period
-		from completing.
-
-	o	"bt" is the number of times that the system balked
-		from boosting because boosting was already in progress.
-
-	o	"b" is the number of times that the system balked from
-		boosting because boosting had already completed for
-		the grace period in question.
-
-	o	"ny" is the number of times that the system balked from
-		boosting because it was not yet time to start boosting
-		the grace period in question.
-
-	o	"nos" is the number of times that the system balked from
-		boosting for inexplicable ("not otherwise specified")
-		reasons.  This can actually happen due to races involving
-		increments of the jiffies counter.
-
-o	In the line beginning with "exp balk", the fields are as follows:
-
-	o	"bt" is the number of times that the system balked from
-		boosting because there were no blocked tasks to boost.
-
-	o	"nos" is the number of times that the system balked from
-		 boosting for inexplicable ("not otherwise specified")
-		 reasons.
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 10df0b8..0f0fb7c 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -842,9 +842,7 @@ SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	srcu_barrier
 	srcu_read_unlock	call_srcu
-	srcu_read_lock_raw	synchronize_srcu_expedited
-	srcu_read_unlock_raw
-	srcu_dereference
+	srcu_dereference	synchronize_srcu_expedited
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
@@ -865,38 +863,32 @@ list can be helpful:
 
 a.	Will readers need to block?  If so, you need SRCU.
 
-b.	Is it necessary to start a read-side critical section in a
-	hardirq handler or exception handler, and then to complete
-	this read-side critical section in the task that was
-	interrupted?  If so, you need SRCU's srcu_read_lock_raw() and
-	srcu_read_unlock_raw() primitives.
-
-c.	What about the -rt patchset?  If readers would need to block
+b.	What about the -rt patchset?  If readers would need to block
 	in an non-rt kernel, you need SRCU.  If readers would block
 	in a -rt kernel, but not in a non-rt kernel, SRCU is not
 	necessary.
 
-d.	Do you need to treat NMI handlers, hardirq handlers,
+c.	Do you need to treat NMI handlers, hardirq handlers,
 	and code segments with preemption disabled (whether
 	via preempt_disable(), local_irq_save(), local_bh_disable(),
 	or some other mechanism) as if they were explicit RCU readers?
 	If so, RCU-sched is the only choice that will work for you.
 
-e.	Do you need RCU grace periods to complete even in the face
+d.	Do you need RCU grace periods to complete even in the face
 	of softirq monopolization of one or more of the CPUs?  For
 	example, is your code subject to network-based denial-of-service
 	attacks?  If so, you need RCU-bh.
 
-f.	Is your workload too update-intensive for normal use of
+e.	Is your workload too update-intensive for normal use of
 	RCU, but inappropriate for other synchronization mechanisms?
 	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
 
-g.	Do you need read-side critical sections that are respected
+f.	Do you need read-side critical sections that are respected
 	even though they are in the middle of the idle loop, during
 	user-mode execution, or on an offlined CPU?  If so, SRCU is the
 	only choice that will work for you.
 
-h.	Otherwise, use RCU.
+g.	Otherwise, use RCU.
 
 Of course, this all assumes that you have determined that RCU is in fact
 the right tool for your job.
diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index cbf7ae4..5f39ef5 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -157,6 +157,53 @@ RCU_SOFTIRQ:  Do at least one of the following:
 		calls and by forcing both kernel threads and interrupts
 		to execute elsewhere.
 
+Name: kworker/%u:%d%s (cpu, id, priority)
+Purpose: Execute workqueue requests
+To reduce its OS jitter, do any of the following:
+1.	Run your workload at a real-time priority, which will allow
+	preempting the kworker daemons.
+2.	Do any of the following needed to avoid jitter that your
+	application cannot tolerate:
+	a.	Build your kernel with CONFIG_SLUB=y rather than
+		CONFIG_SLAB=y, thus avoiding the slab allocator's periodic
+		use of each CPU's workqueues to run its cache_reap()
+		function.
+	b.	Avoid using oprofile, thus avoiding OS jitter from
+		wq_sync_buffer().
+	c.	Limit your CPU frequency so that a CPU-frequency
+		governor is not required, possibly enlisting the aid of
+		special heatsinks or other cooling technologies.  If done
+		correctly, and if you CPU architecture permits, you should
+		be able to build your kernel with CONFIG_CPU_FREQ=n to
+		avoid the CPU-frequency governor periodically running
+		on each CPU, including cs_dbs_timer() and od_dbs_timer().
+		WARNING:  Please check your CPU specifications to
+		make sure that this is safe on your particular system.
+	d.	It is not possible to entirely get rid of OS jitter
+		from vmstat_update() on CONFIG_SMP=y systems, but you
+		can decrease its frequency by writing a large value to
+		/proc/sys/vm/stat_interval.  The default value is HZ,
+		for an interval of one second.  Of course, larger values
+		will make your virtual-memory statistics update more
+		slowly.  Of course, you can also run your workload at
+		a real-time priority, thus preempting vmstat_update().
+	e.	If running on high-end powerpc servers, build with
+		CONFIG_PPC_RTAS_DAEMON=n.  This prevents the RTAS
+		daemon from running on each CPU every second or so.
+		(This will require editing Kconfig files and will defeat
+		this platform's RAS functionality.)  This avoids jitter
+		due to the rtas_event_scan() function.
+		WARNING:  Please check your CPU specifications to
+		make sure that this is safe on your particular system.
+	f.	If running on Cell Processor, build your kernel with
+		CBE_CPUFREQ_SPU_GOVERNOR=n to avoid OS jitter from
+		spu_gov_work().
+		WARNING:  Please check your CPU specifications to
+		make sure that this is safe on your particular system.
+	g.	If running on PowerMAC, build your kernel with
+		CONFIG_PMAC_RACKMETER=n to disable the CPU-meter,
+		avoiding OS jitter from rackmeter_do_timer().
+
 Name: rcuc/%u
 Purpose: Execute RCU callbacks in CONFIG_RCU_BOOST=y kernels.
 To reduce its OS jitter, do at least one of the following:
diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
index 5b53220..8869758 100644
--- a/Documentation/timers/NO_HZ.txt
+++ b/Documentation/timers/NO_HZ.txt
@@ -7,21 +7,59 @@ efficiency and reducing OS jitter.  Reducing OS jitter is important for
 some types of computationally intensive high-performance computing (HPC)
 applications and for real-time applications.
 
-There are two main contexts in which the number of scheduling-clock
-interrupts can be reduced compared to the old-school approach of sending
-a scheduling-clock interrupt to all CPUs every jiffy whether they need
-it or not (CONFIG_HZ_PERIODIC=y or CONFIG_NO_HZ=n for older kernels):
+There are three main ways of managing scheduling-clock interrupts
+(also known as "scheduling-clock ticks" or simply "ticks"):
 
-1.	Idle CPUs (CONFIG_NO_HZ_IDLE=y or CONFIG_NO_HZ=y for older kernels).
+1.	Never omit scheduling-clock ticks (CONFIG_HZ_PERIODIC=y or
+	CONFIG_NO_HZ=n for older kernels).  You normally will -not-
+	want to choose this option.
 
-2.	CPUs having only one runnable task (CONFIG_NO_HZ_FULL=y).
+2.	Omit scheduling-clock ticks on idle CPUs (CONFIG_NO_HZ_IDLE=y or
+	CONFIG_NO_HZ=y for older kernels).  This is the most common
+	approach, and should be the default.
 
-These two cases are described in the following two sections, followed
+3.	Omit scheduling-clock ticks on CPUs that are either idle or that
+	have only one runnable task (CONFIG_NO_HZ_FULL=y).  Unless you
+	are running realtime applications or certain types of HPC
+	workloads, you will normally -not- want this option.
+
+These three cases are described in the following three sections, followed
 by a third section on RCU-specific considerations and a fourth and final
 section listing known issues.
 
 
-IDLE CPUs
+NEVER OMIT SCHEDULING-CLOCK TICKS
+
+Very old versions of Linux from the 1990s and the very early 2000s
+are incapable of omitting scheduling-clock ticks.  It turns out that
+there are some situations where this old-school approach is still the
+right approach, for example, in heavy workloads with lots of tasks
+that use short bursts of CPU, where there are very frequent idle
+periods, but where these idle periods are also quite short (tens or
+hundreds of microseconds).  For these types of workloads, scheduling
+clock interrupts will normally be delivered any way because there
+will frequently be multiple runnable tasks per CPU.  In these cases,
+attempting to turn off the scheduling clock interrupt will have no effect
+other than increasing the overhead of switching to and from idle and
+transitioning between user and kernel execution.
+
+This mode of operation can be selected using CONFIG_HZ_PERIODIC=y (or
+CONFIG_NO_HZ=n for older kernels).
+
+However, if you are instead running a light workload with long idle
+periods, failing to omit scheduling-clock interrupts will result in
+excessive power consumption.  This is especially bad on battery-powered
+devices, where it results in extremely short battery lifetimes.  If you
+are running light workloads, you should therefore read the following
+section.
+
+In addition, if you are running either a real-time workload or an HPC
+workload with short iterations, the scheduling-clock interrupts can
+degrade your applications performance.  If this describes your workload,
+you should read the following two sections.
+
+
+OMIT SCHEDULING-CLOCK TICKS FOR IDLE CPUs
 
 If a CPU is idle, there is little point in sending it a scheduling-clock
 interrupt.  After all, the primary purpose of a scheduling-clock interrupt
@@ -59,10 +97,12 @@ By default, CONFIG_NO_HZ_IDLE=y kernels boot with "nohz=on", enabling
 dyntick-idle mode.
 
 
-CPUs WITH ONLY ONE RUNNABLE TASK
+OMIT SCHEDULING-CLOCK TICKS FOR CPUs WITH ONLY ONE RUNNABLE TASK
 
 If a CPU has only one runnable task, there is little point in sending it
 a scheduling-clock interrupt because there is no other task to switch to.
+Note that omitting scheduling-clock ticks for CPUs with only one runnable
+task implies also omitting them for idle CPUs.
 
 The CONFIG_NO_HZ_FULL=y Kconfig option causes the kernel to avoid
 sending scheduling-clock interrupts to CPUs with a single runnable task,
@@ -238,6 +278,11 @@ o	Adaptive-ticks does not do anything unless there is only one
 	single runnable SCHED_FIFO task and multiple runnable SCHED_OTHER
 	tasks, even though these interrupts are unnecessary.
 
+	And even when there are multiple runnable tasks on a given CPU,
+	there is little point in interrupting that CPU until the current
+	running task's timeslice expires, which is almost always way
+	longer than the time of the next scheduling-clock interrupt.
+
 	Better handling of these sorts of situations is future work.
 
 o	A reboot is required to reconfigure both adaptive idle and RCU
@@ -268,6 +313,16 @@ o	Unless all CPUs are idle, at least one CPU must keep the
 	scheduling-clock interrupt going in order to support accurate
 	timekeeping.
 
-o	If there are adaptive-ticks CPUs, there will be at least one
-	CPU keeping the scheduling-clock interrupt going, even if all
-	CPUs are otherwise idle.
+o	If there might potentially be some adaptive-ticks CPUs, there
+	will be at least one CPU keeping the scheduling-clock interrupt
+	going, even if all CPUs are otherwise idle.
+
+	Better handling of this situation is ongoing work.
+
+o	Some process-handling operations still require the occasional
+	scheduling-clock tick.	These operations include calculating CPU
+	load, maintaining sched average, computing CFS entity vruntime,
+	computing avenrun, and carrying out load balancing.  They are
+	currently accommodated by scheduling-clock tick every second
+	or so.	On-going work will eliminate the need even for these
+	infrequent scheduling-clock ticks.
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 550f592..2efa9dd 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1864,7 +1864,7 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
 
  up_out:
 	up_read(&current->mm->mmap_sem);
-	goto out;
+	goto out_srcu;
 }
 
 int kvmppc_core_init_vm(struct kvm *kvm)
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index c1d6555..05bcc09 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -128,7 +128,7 @@ extern void synchronize_irq(unsigned int irq);
 # define synchronize_irq(irq)	barrier()
 #endif
 
-#if defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
+#if defined(CONFIG_TINY_RCU)
 
 static inline void rcu_nmi_enter(void)
 {
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ddcc782..4b14bdc 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -216,6 +216,7 @@ static inline int rcu_preempt_depth(void)
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 /* Internal to kernel */
+extern void rcu_init(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
@@ -239,8 +240,6 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
-extern void exit_rcu(void);
-
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
  * @a: Code that RCU needs to pay attention to.
@@ -277,7 +276,7 @@ void wait_rcu_gp(call_rcu_func_t crf);
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
-#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
+#elif defined(CONFIG_TINY_RCU)
 #include <linux/rcutiny.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 4e56a9c..e31005e 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,10 +27,6 @@
 
 #include <linux/cache.h>
 
-static inline void rcu_init(void)
-{
-}
-
 static inline void rcu_barrier_bh(void)
 {
 	wait_rcu_gp(call_rcu_bh);
@@ -41,8 +37,6 @@ static inline void rcu_barrier_sched(void)
 	wait_rcu_gp(call_rcu_sched);
 }
 
-#ifdef CONFIG_TINY_RCU
-
 static inline void synchronize_rcu_expedited(void)
 {
 	synchronize_sched();	/* Only one CPU, so pretty fast anyway!!! */
@@ -53,17 +47,6 @@ static inline void rcu_barrier(void)
 	rcu_barrier_sched();  /* Only one CPU, so only one list of callbacks! */
 }
 
-#else /* #ifdef CONFIG_TINY_RCU */
-
-void synchronize_rcu_expedited(void);
-
-static inline void rcu_barrier(void)
-{
-	wait_rcu_gp(call_rcu);
-}
-
-#endif /* #else #ifdef CONFIG_TINY_RCU */
-
 static inline void synchronize_rcu_bh(void)
 {
 	synchronize_sched();
@@ -85,35 +68,15 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 	call_rcu(head, func);
 }
 
-#ifdef CONFIG_TINY_RCU
-
-static inline void rcu_preempt_note_context_switch(void)
-{
-}
-
 static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
 	return 0;
 }
 
-#else /* #ifdef CONFIG_TINY_RCU */
-
-void rcu_preempt_note_context_switch(void);
-int rcu_preempt_needs_cpu(void);
-
-static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
-{
-	*delta_jiffies = ULONG_MAX;
-	return rcu_preempt_needs_cpu();
-}
-
-#endif /* #else #ifdef CONFIG_TINY_RCU */
-
 static inline void rcu_note_context_switch(int cpu)
 {
 	rcu_sched_qs(cpu);
-	rcu_preempt_note_context_switch();
 }
 
 /*
@@ -156,6 +119,10 @@ static inline void rcu_cpu_stall_reset(void)
 {
 }
 
+static inline void exit_rcu(void)
+{
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern int rcu_scheduler_active __read_mostly;
 extern void rcu_scheduler_starting(void);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 952b793..226169d 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,7 +30,6 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
 extern void rcu_cpu_stall_reset(void);
@@ -86,6 +85,8 @@ extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
 
+extern void exit_rcu(void);
+
 extern void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 04f4121..c114614 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -237,47 +237,4 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__srcu_read_unlock(sp, idx);
 }
 
-/**
- * srcu_read_lock_raw - register a new reader for an SRCU-protected structure.
- * @sp: srcu_struct in which to register the new reader.
- *
- * Enter an SRCU read-side critical section.  Similar to srcu_read_lock(),
- * but avoids the RCU-lockdep checking.  This means that it is legal to
- * use srcu_read_lock_raw() in one context, for example, in an exception
- * handler, and then have the matching srcu_read_unlock_raw() in another
- * context, for example in the task that took the exception.
- *
- * However, the entire SRCU read-side critical section must reside within a
- * single task.  For example, beware of using srcu_read_lock_raw() in
- * a device interrupt handler and srcu_read_unlock() in the interrupted
- * task:  This will not work if interrupts are threaded.
- */
-static inline int srcu_read_lock_raw(struct srcu_struct *sp)
-{
-	unsigned long flags;
-	int ret;
-
-	local_irq_save(flags);
-	ret =  __srcu_read_lock(sp);
-	local_irq_restore(flags);
-	return ret;
-}
-
-/**
- * srcu_read_unlock_raw - unregister reader from an SRCU-protected structure.
- * @sp: srcu_struct in which to unregister the old reader.
- * @idx: return value from corresponding srcu_read_lock_raw().
- *
- * Exit an SRCU read-side critical section without lockdep-RCU checking.
- * See srcu_read_lock_raw() for more details.
- */
-static inline void srcu_read_unlock_raw(struct srcu_struct *sp, int idx)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__srcu_read_unlock(sp, idx);
-	local_irq_restore(flags);
-}
-
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 2d9b831..be52daf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -459,18 +459,10 @@ config TINY_RCU
 	  is not required.  This option greatly reduces the
 	  memory footprint of RCU.
 
-config TINY_PREEMPT_RCU
-	bool "Preemptible UP-only small-memory-footprint RCU"
-	depends on PREEMPT && !SMP
-	help
-	  This option selects the RCU implementation that is designed
-	  for real-time UP systems.  This option greatly reduces the
-	  memory footprint of RCU.
-
 endchoice
 
 config PREEMPT_RCU
-	def_bool ( TREE_PREEMPT_RCU || TINY_PREEMPT_RCU )
+	def_bool TREE_PREEMPT_RCU
 	help
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
@@ -656,7 +648,7 @@ config RCU_BOOST_DELAY
 	  Accept the default if unsure.
 
 config RCU_NOCB_CPU
-	bool "Offload RCU callback processing from boot-selected CPUs (EXPERIMENTAL"
+	bool "Offload RCU callback processing from boot-selected CPUs"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
@@ -682,9 +674,10 @@ choice
 	prompt "Build-forced no-CBs CPUs"
 	default RCU_NOCB_CPU_NONE
 	help
-	  This option allows no-CBs CPUs to be specified at build time.
-	  Additional no-CBs CPUs may be specified by the rcu_nocbs=
-	  boot parameter.
+	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
+	  from kthreads rather than from softirq context) to be specified
+	  at build time.  Additional no-CBs CPUs may be specified by
+	  the rcu_nocbs= boot parameter.
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
@@ -692,25 +685,40 @@ config RCU_NOCB_CPU_NONE
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
-	  no-CBs CPUs.
+	  no-CBs CPUs, whose RCU callbacks will be invoked by per-CPU
+	  kthreads whose names begin with "rcuo".  All other CPUs will
+	  invoke their own RCU callbacks in softirq context.
+
+	  Select this option if you want to choose no-CBs CPUs at
+	  boot time, for example, to allow testing of different no-CBs
+	  configurations without having to rebuild the kernel each time.
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
 	depends on RCU_NOCB_CPU && !NO_HZ_FULL
 	help
-	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
-	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
-	  parameter will be no-CBs CPUs.
+	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
+	  callbacks are invoked by a per-CPU kthread whose name begins
+	  with "rcuo".	Additional CPUs may be designated as no-CBs
+	  CPUs using the rcu_nocbs= boot parameter will be no-CBs CPUs.
+	  All other CPUs will invoke their own RCU callbacks in softirq
+	  context.
 
 	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
-	  or energy-efficiency reasons.
+	  or energy-efficiency reasons, but the real reason it exists
+	  is to ensure that randconfig testing covers mixed systems.
 
 config RCU_NOCB_CPU_ALL
 	bool "All CPUs are build_forced no-CBs CPUs"
 	depends on RCU_NOCB_CPU
 	help
 	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
-	  boot parameter will be ignored.
+	  boot parameter will be ignored.  All CPUs' RCU callbacks will
+	  be executed in the context of per-CPU rcuo kthreads created for
+	  this purpose.  Assuming that the kthreads whose names start with
+	  "rcuo" are bound to "housekeeping" CPUs, this reduces OS jitter
+	  on the remaining CPUs, but might decrease memory locality during
+	  RCU-callback invocation, thus potentially degrading throughput.
 
 	  Select this if all CPUs need to be no-CBs CPUs for real-time
 	  or energy-efficiency reasons.
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 48ab703..cce6ba8 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -104,31 +104,7 @@ void __rcu_read_unlock(void)
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
-/*
- * Check for a task exiting while in a preemptible-RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (likely(list_empty(&current->rcu_node_entry)))
-		return;
-	t->rcu_read_lock_nesting = 1;
-	barrier();
-	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
-	__rcu_read_unlock();
-}
-
-#else /* #ifdef CONFIG_PREEMPT_RCU */
-
-void exit_rcu(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -145,9 +121,6 @@ static struct lock_class_key rcu_sched_lock_key;
 struct lockdep_map rcu_sched_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
 EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
-#endif
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 int debug_lockdep_rcu_enabled(void)
 {
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index a0714a5..aa34411 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -44,7 +44,6 @@
 
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
-static void invoke_rcu_callbacks(void);
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
 static void rcu_process_callbacks(struct softirq_action *unused);
 static void __call_rcu(struct rcu_head *head,
@@ -205,7 +204,7 @@ static int rcu_is_cpu_rrupt_from_idle(void)
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
-	reset_cpu_stall_ticks(rcp);
+	RCU_TRACE(reset_cpu_stall_ticks(rcp));
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
@@ -227,7 +226,7 @@ void rcu_sched_qs(int cpu)
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_callbacks();
+		raise_softirq(RCU_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -240,7 +239,7 @@ void rcu_bh_qs(int cpu)
 
 	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
-		invoke_rcu_callbacks();
+		raise_softirq(RCU_SOFTIRQ);
 	local_irq_restore(flags);
 }
 
@@ -252,12 +251,11 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
-	check_cpu_stalls();
+	RCU_TRACE(check_cpu_stalls());
 	if (user || rcu_is_cpu_rrupt_from_idle())
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
-	rcu_preempt_check_callbacks();
 }
 
 /*
@@ -278,7 +276,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 					      ACCESS_ONCE(rcp->rcucblist),
 					      need_resched(),
 					      is_idle_task(current),
-					      rcu_is_callbacks_kthread()));
+					      false));
 		return;
 	}
 
@@ -290,7 +288,6 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	*rcp->donetail = NULL;
 	if (rcp->curtail == rcp->donetail)
 		rcp->curtail = &rcp->rcucblist;
-	rcu_preempt_remove_callbacks(rcp);
 	rcp->donetail = &rcp->rcucblist;
 	local_irq_restore(flags);
 
@@ -309,14 +306,13 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
 	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count, 0, need_resched(),
 				      is_idle_task(current),
-				      rcu_is_callbacks_kthread()));
+				      false));
 }
 
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	__rcu_process_callbacks(&rcu_sched_ctrlblk);
 	__rcu_process_callbacks(&rcu_bh_ctrlblk);
-	rcu_preempt_process_callbacks();
 }
 
 /*
@@ -382,3 +378,8 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	__call_rcu(head, func, &rcu_bh_ctrlblk);
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+void rcu_init(void)
+{
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 8a23300..0cd385a 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -53,958 +53,10 @@ static struct rcu_ctrlblk rcu_bh_ctrlblk = {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+#include <linux/kernel_stat.h>
+
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-
-#ifdef CONFIG_RCU_TRACE
-
-static void check_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	unsigned long j;
-	unsigned long js;
-
-	if (rcu_cpu_stall_suppress)
-		return;
-	rcp->ticks_this_gp++;
-	j = jiffies;
-	js = rcp->jiffies_stall;
-	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
-		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
-		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
-		       jiffies - rcp->gp_start, rcp->qlen);
-		dump_stack();
-	}
-	if (*rcp->curtail && ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies +
-			3 * rcu_jiffies_till_stall_check() + 3;
-	else if (ULONG_CMP_GE(j, js))
-		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
-}
-
-static void check_cpu_stall_preempt(void);
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
-{
-#ifdef CONFIG_RCU_TRACE
-	rcp->ticks_this_gp = 0;
-	rcp->gp_start = jiffies;
-	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
-#endif /* #ifdef CONFIG_RCU_TRACE */
-}
-
-static void check_cpu_stalls(void)
-{
-	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
-	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
-	RCU_TRACE(check_cpu_stall_preempt());
-}
-
-#ifdef CONFIG_TINY_PREEMPT_RCU
-
-#include <linux/delay.h>
-
-/* Global control variables for preemptible RCU. */
-struct rcu_preempt_ctrlblk {
-	struct rcu_ctrlblk rcb;	/* curtail: ->next ptr of last CB for GP. */
-	struct rcu_head **nexttail;
-				/* Tasks blocked in a preemptible RCU */
-				/*  read-side critical section while an */
-				/*  preemptible-RCU grace period is in */
-				/*  progress must wait for a later grace */
-				/*  period.  This pointer points to the */
-				/*  ->next pointer of the last task that */
-				/*  must wait for a later grace period, or */
-				/*  to &->rcb.rcucblist if there is no */
-				/*  such task. */
-	struct list_head blkd_tasks;
-				/* Tasks blocked in RCU read-side critical */
-				/*  section.  Tasks are placed at the head */
-				/*  of this list and age towards the tail. */
-	struct list_head *gp_tasks;
-				/* Pointer to the first task blocking the */
-				/*  current grace period, or NULL if there */
-				/*  is no such task. */
-	struct list_head *exp_tasks;
-				/* Pointer to first task blocking the */
-				/*  current expedited grace period, or NULL */
-				/*  if there is no such task.  If there */
-				/*  is no current expedited grace period, */
-				/*  then there cannot be any such task. */
-#ifdef CONFIG_RCU_BOOST
-	struct list_head *boost_tasks;
-				/* Pointer to first task that needs to be */
-				/*  priority-boosted, or NULL if no priority */
-				/*  boosting is needed.  If there is no */
-				/*  current or expedited grace period, there */
-				/*  can be no such task. */
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	u8 gpnum;		/* Current grace period. */
-	u8 gpcpu;		/* Last grace period blocked by the CPU. */
-	u8 completed;		/* Last grace period completed. */
-				/*  If all three are equal, RCU is idle. */
-#ifdef CONFIG_RCU_BOOST
-	unsigned long boost_time; /* When to start boosting (jiffies) */
-#endif /* #ifdef CONFIG_RCU_BOOST */
-#ifdef CONFIG_RCU_TRACE
-	unsigned long n_grace_periods;
-#ifdef CONFIG_RCU_BOOST
-	unsigned long n_tasks_boosted;
-				/* Total number of tasks boosted. */
-	unsigned long n_exp_boosts;
-				/* Number of tasks boosted for expedited GP. */
-	unsigned long n_normal_boosts;
-				/* Number of tasks boosted for normal GP. */
-	unsigned long n_balk_blkd_tasks;
-				/* Refused to boost: no blocked tasks. */
-	unsigned long n_balk_exp_gp_tasks;
-				/* Refused to boost: nothing blocking GP. */
-	unsigned long n_balk_boost_tasks;
-				/* Refused to boost: already boosting. */
-	unsigned long n_balk_notyet;
-				/* Refused to boost: not yet time. */
-	unsigned long n_balk_nos;
-				/* Refused to boost: not sure why, though. */
-				/*  This can happen due to race conditions. */
-#endif /* #ifdef CONFIG_RCU_BOOST */
-#endif /* #ifdef CONFIG_RCU_TRACE */
-};
-
-static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
-	.rcb.donetail = &rcu_preempt_ctrlblk.rcb.rcucblist,
-	.rcb.curtail = &rcu_preempt_ctrlblk.rcb.rcucblist,
-	.nexttail = &rcu_preempt_ctrlblk.rcb.rcucblist,
-	.blkd_tasks = LIST_HEAD_INIT(rcu_preempt_ctrlblk.blkd_tasks),
-	RCU_TRACE(.rcb.name = "rcu_preempt")
-};
-
-static int rcu_preempted_readers_exp(void);
-static void rcu_report_exp_done(void);
-
-/*
- * Return true if the CPU has not yet responded to the current grace period.
- */
-static int rcu_cpu_blocking_cur_gp(void)
-{
-	return rcu_preempt_ctrlblk.gpcpu != rcu_preempt_ctrlblk.gpnum;
-}
-
-/*
- * Check for a running RCU reader.  Because there is only one CPU,
- * there can be but one running RCU reader at a time.  ;-)
- *
- * Returns zero if there are no running readers.  Returns a positive
- * number if there is at least one reader within its RCU read-side
- * critical section.  Returns a negative number if an outermost reader
- * is in the midst of exiting from its RCU read-side critical section
- *
- * Returns zero if there are no running readers.  Returns a positive
- * number if there is at least one reader within its RCU read-side
- * critical section.  Returns a negative number if an outermost reader
- * is in the midst of exiting from its RCU read-side critical section.
- */
-static int rcu_preempt_running_reader(void)
-{
-	return current->rcu_read_lock_nesting;
-}
-
-/*
- * Check for preempted RCU readers blocking any grace period.
- * If the caller needs a reliable answer, it must disable hard irqs.
- */
-static int rcu_preempt_blocked_readers_any(void)
-{
-	return !list_empty(&rcu_preempt_ctrlblk.blkd_tasks);
-}
-
-/*
- * Check for preempted RCU readers blocking the current grace period.
- * If the caller needs a reliable answer, it must disable hard irqs.
- */
-static int rcu_preempt_blocked_readers_cgp(void)
-{
-	return rcu_preempt_ctrlblk.gp_tasks != NULL;
-}
-
-/*
- * Return true if another preemptible-RCU grace period is needed.
- */
-static int rcu_preempt_needs_another_gp(void)
-{
-	return *rcu_preempt_ctrlblk.rcb.curtail != NULL;
-}
-
-/*
- * Return true if a preemptible-RCU grace period is in progress.
- * The caller must disable hardirqs.
- */
-static int rcu_preempt_gp_in_progress(void)
-{
-	return rcu_preempt_ctrlblk.completed != rcu_preempt_ctrlblk.gpnum;
-}
-
-/*
- * Advance a ->blkd_tasks-list pointer to the next entry, instead
- * returning NULL if at the end of the list.
- */
-static struct list_head *rcu_next_node_entry(struct task_struct *t)
-{
-	struct list_head *np;
-
-	np = t->rcu_node_entry.next;
-	if (np == &rcu_preempt_ctrlblk.blkd_tasks)
-		np = NULL;
-	return np;
-}
-
-#ifdef CONFIG_RCU_TRACE
-
-#ifdef CONFIG_RCU_BOOST
-static void rcu_initiate_boost_trace(void);
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
-/*
- * Dump additional statistice for TINY_PREEMPT_RCU.
- */
-static void show_tiny_preempt_stats(struct seq_file *m)
-{
-	seq_printf(m, "rcu_preempt: qlen=%ld gp=%lu g%u/p%u/c%u tasks=%c%c%c\n",
-		   rcu_preempt_ctrlblk.rcb.qlen,
-		   rcu_preempt_ctrlblk.n_grace_periods,
-		   rcu_preempt_ctrlblk.gpnum,
-		   rcu_preempt_ctrlblk.gpcpu,
-		   rcu_preempt_ctrlblk.completed,
-		   "T."[list_empty(&rcu_preempt_ctrlblk.blkd_tasks)],
-		   "N."[!rcu_preempt_ctrlblk.gp_tasks],
-		   "E."[!rcu_preempt_ctrlblk.exp_tasks]);
-#ifdef CONFIG_RCU_BOOST
-	seq_printf(m, "%sttb=%c ntb=%lu neb=%lu nnb=%lu j=%04x bt=%04x\n",
-		   "             ",
-		   "B."[!rcu_preempt_ctrlblk.boost_tasks],
-		   rcu_preempt_ctrlblk.n_tasks_boosted,
-		   rcu_preempt_ctrlblk.n_exp_boosts,
-		   rcu_preempt_ctrlblk.n_normal_boosts,
-		   (int)(jiffies & 0xffff),
-		   (int)(rcu_preempt_ctrlblk.boost_time & 0xffff));
-	seq_printf(m, "%s: nt=%lu egt=%lu bt=%lu ny=%lu nos=%lu\n",
-		   "             balk",
-		   rcu_preempt_ctrlblk.n_balk_blkd_tasks,
-		   rcu_preempt_ctrlblk.n_balk_exp_gp_tasks,
-		   rcu_preempt_ctrlblk.n_balk_boost_tasks,
-		   rcu_preempt_ctrlblk.n_balk_notyet,
-		   rcu_preempt_ctrlblk.n_balk_nos);
-#endif /* #ifdef CONFIG_RCU_BOOST */
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-#ifdef CONFIG_RCU_BOOST
-
-#include "rtmutex_common.h"
-
-#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
-
-/* Controls for rcu_kthread() kthread. */
-static struct task_struct *rcu_kthread_task;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
-static unsigned long have_rcu_kthread_work;
-
-/*
- * Carry out RCU priority boosting on the task indicated by ->boost_tasks,
- * and advance ->boost_tasks to the next task in the ->blkd_tasks list.
- */
-static int rcu_boost(void)
-{
-	unsigned long flags;
-	struct rt_mutex mtx;
-	struct task_struct *t;
-	struct list_head *tb;
-
-	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
-	    rcu_preempt_ctrlblk.exp_tasks == NULL)
-		return 0;  /* Nothing to boost. */
-
-	local_irq_save(flags);
-
-	/*
-	 * Recheck with irqs disabled: all tasks in need of boosting
-	 * might exit their RCU read-side critical sections on their own
-	 * if we are preempted just before disabling irqs.
-	 */
-	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
-	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
-		local_irq_restore(flags);
-		return 0;
-	}
-
-	/*
-	 * Preferentially boost tasks blocking expedited grace periods.
-	 * This cannot starve the normal grace periods because a second
-	 * expedited grace period must boost all blocked tasks, including
-	 * those blocking the pre-existing normal grace period.
-	 */
-	if (rcu_preempt_ctrlblk.exp_tasks != NULL) {
-		tb = rcu_preempt_ctrlblk.exp_tasks;
-		RCU_TRACE(rcu_preempt_ctrlblk.n_exp_boosts++);
-	} else {
-		tb = rcu_preempt_ctrlblk.boost_tasks;
-		RCU_TRACE(rcu_preempt_ctrlblk.n_normal_boosts++);
-	}
-	RCU_TRACE(rcu_preempt_ctrlblk.n_tasks_boosted++);
-
-	/*
-	 * We boost task t by manufacturing an rt_mutex that appears to
-	 * be held by task t.  We leave a pointer to that rt_mutex where
-	 * task t can find it, and task t will release the mutex when it
-	 * exits its outermost RCU read-side critical section.  Then
-	 * simply acquiring this artificial rt_mutex will boost task
-	 * t's priority.  (Thanks to tglx for suggesting this approach!)
-	 */
-	t = container_of(tb, struct task_struct, rcu_node_entry);
-	rt_mutex_init_proxy_locked(&mtx, t);
-	t->rcu_boost_mutex = &mtx;
-	local_irq_restore(flags);
-	rt_mutex_lock(&mtx);
-	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
-
-	return ACCESS_ONCE(rcu_preempt_ctrlblk.boost_tasks) != NULL ||
-	       ACCESS_ONCE(rcu_preempt_ctrlblk.exp_tasks) != NULL;
-}
-
-/*
- * Check to see if it is now time to start boosting RCU readers blocking
- * the current grace period, and, if so, tell the rcu_kthread_task to
- * start boosting them.  If there is an expedited boost in progress,
- * we wait for it to complete.
- *
- * If there are no blocked readers blocking the current grace period,
- * return 0 to let the caller know, otherwise return 1.  Note that this
- * return value is independent of whether or not boosting was done.
- */
-static int rcu_initiate_boost(void)
-{
-	if (!rcu_preempt_blocked_readers_cgp() &&
-	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
-		RCU_TRACE(rcu_preempt_ctrlblk.n_balk_exp_gp_tasks++);
-		return 0;
-	}
-	if (rcu_preempt_ctrlblk.exp_tasks != NULL ||
-	    (rcu_preempt_ctrlblk.gp_tasks != NULL &&
-	     rcu_preempt_ctrlblk.boost_tasks == NULL &&
-	     ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))) {
-		if (rcu_preempt_ctrlblk.exp_tasks == NULL)
-			rcu_preempt_ctrlblk.boost_tasks =
-				rcu_preempt_ctrlblk.gp_tasks;
-		invoke_rcu_callbacks();
-	} else {
-		RCU_TRACE(rcu_initiate_boost_trace());
-	}
-	return 1;
-}
-
-#define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
-
-/*
- * Do priority-boost accounting for the start of a new grace period.
- */
-static void rcu_preempt_boost_start_gp(void)
-{
-	rcu_preempt_ctrlblk.boost_time = jiffies + RCU_BOOST_DELAY_JIFFIES;
-}
-
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-/*
- * If there is no RCU priority boosting, we don't initiate boosting,
- * but we do indicate whether there are blocked readers blocking the
- * current grace period.
- */
-static int rcu_initiate_boost(void)
-{
-	return rcu_preempt_blocked_readers_cgp();
-}
-
-/*
- * If there is no RCU priority boosting, nothing to do at grace-period start.
- */
-static void rcu_preempt_boost_start_gp(void)
-{
-}
-
-#endif /* else #ifdef CONFIG_RCU_BOOST */
-
-/*
- * Record a preemptible-RCU quiescent state for the specified CPU.  Note
- * that this just means that the task currently running on the CPU is
- * in a quiescent state.  There might be any number of tasks blocked
- * while in an RCU read-side critical section.
- *
- * Unlike the other rcu_*_qs() functions, callers to this function
- * must disable irqs in order to protect the assignment to
- * ->rcu_read_unlock_special.
- *
- * Because this is a single-CPU implementation, the only way a grace
- * period can end is if the CPU is in a quiescent state.  The reason is
- * that a blocked preemptible-RCU reader can exit its critical section
- * only if the CPU is running it at the time.  Therefore, when the
- * last task blocking the current grace period exits its RCU read-side
- * critical section, neither the CPU nor blocked tasks will be stopping
- * the current grace period.  (In contrast, SMP implementations
- * might have CPUs running in RCU read-side critical sections that
- * block later grace periods -- but this is not possible given only
- * one CPU.)
- */
-static void rcu_preempt_cpu_qs(void)
-{
-	/* Record both CPU and task as having responded to current GP. */
-	rcu_preempt_ctrlblk.gpcpu = rcu_preempt_ctrlblk.gpnum;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
-
-	/* If there is no GP then there is nothing more to do.  */
-	if (!rcu_preempt_gp_in_progress())
-		return;
-	/*
-	 * Check up on boosting.  If there are readers blocking the
-	 * current grace period, leave.
-	 */
-	if (rcu_initiate_boost())
-		return;
-
-	/* Advance callbacks. */
-	rcu_preempt_ctrlblk.completed = rcu_preempt_ctrlblk.gpnum;
-	rcu_preempt_ctrlblk.rcb.donetail = rcu_preempt_ctrlblk.rcb.curtail;
-	rcu_preempt_ctrlblk.rcb.curtail = rcu_preempt_ctrlblk.nexttail;
-
-	/* If there are no blocked readers, next GP is done instantly. */
-	if (!rcu_preempt_blocked_readers_any())
-		rcu_preempt_ctrlblk.rcb.donetail = rcu_preempt_ctrlblk.nexttail;
-
-	/* If there are done callbacks, cause them to be invoked. */
-	if (*rcu_preempt_ctrlblk.rcb.donetail != NULL)
-		invoke_rcu_callbacks();
-}
-
-/*
- * Start a new RCU grace period if warranted.  Hard irqs must be disabled.
- */
-static void rcu_preempt_start_gp(void)
-{
-	if (!rcu_preempt_gp_in_progress() && rcu_preempt_needs_another_gp()) {
-
-		/* Official start of GP. */
-		rcu_preempt_ctrlblk.gpnum++;
-		RCU_TRACE(rcu_preempt_ctrlblk.n_grace_periods++);
-		reset_cpu_stall_ticks(&rcu_preempt_ctrlblk.rcb);
-
-		/* Any blocked RCU readers block new GP. */
-		if (rcu_preempt_blocked_readers_any())
-			rcu_preempt_ctrlblk.gp_tasks =
-				rcu_preempt_ctrlblk.blkd_tasks.next;
-
-		/* Set up for RCU priority boosting. */
-		rcu_preempt_boost_start_gp();
-
-		/* If there is no running reader, CPU is done with GP. */
-		if (!rcu_preempt_running_reader())
-			rcu_preempt_cpu_qs();
-	}
-}
-
-/*
- * We have entered the scheduler, and the current task might soon be
- * context-switched away from.  If this task is in an RCU read-side
- * critical section, we will no longer be able to rely on the CPU to
- * record that fact, so we enqueue the task on the blkd_tasks list.
- * If the task started after the current grace period began, as recorded
- * by ->gpcpu, we enqueue at the beginning of the list.  Otherwise
- * before the element referenced by ->gp_tasks (or at the tail if
- * ->gp_tasks is NULL) and point ->gp_tasks at the newly added element.
- * The task will dequeue itself when it exits the outermost enclosing
- * RCU read-side critical section.  Therefore, the current grace period
- * cannot be permitted to complete until the ->gp_tasks pointer becomes
- * NULL.
- *
- * Caller must disable preemption.
- */
-void rcu_preempt_note_context_switch(void)
-{
-	struct task_struct *t = current;
-	unsigned long flags;
-
-	local_irq_save(flags); /* must exclude scheduler_tick(). */
-	if (rcu_preempt_running_reader() > 0 &&
-	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
-
-		/* Possibly blocking in an RCU read-side critical section. */
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
-
-		/*
-		 * If this CPU has already checked in, then this task
-		 * will hold up the next grace period rather than the
-		 * current grace period.  Queue the task accordingly.
-		 * If the task is queued for the current grace period
-		 * (i.e., this CPU has not yet passed through a quiescent
-		 * state for the current grace period), then as long
-		 * as that task remains queued, the current grace period
-		 * cannot end.
-		 */
-		list_add(&t->rcu_node_entry, &rcu_preempt_ctrlblk.blkd_tasks);
-		if (rcu_cpu_blocking_cur_gp())
-			rcu_preempt_ctrlblk.gp_tasks = &t->rcu_node_entry;
-	} else if (rcu_preempt_running_reader() < 0 &&
-		   t->rcu_read_unlock_special) {
-		/*
-		 * Complete exit from RCU read-side critical section on
-		 * behalf of preempted instance of __rcu_read_unlock().
-		 */
-		rcu_read_unlock_special(t);
-	}
-
-	/*
-	 * Either we were not in an RCU read-side critical section to
-	 * begin with, or we have now recorded that critical section
-	 * globally.  Either way, we can now note a quiescent state
-	 * for this CPU.  Again, if we were in an RCU read-side critical
-	 * section, and if that critical section was blocking the current
-	 * grace period, then the fact that the task has been enqueued
-	 * means that current grace period continues to be blocked.
-	 */
-	rcu_preempt_cpu_qs();
-	local_irq_restore(flags);
-}
-
-/*
- * Handle special cases during rcu_read_unlock(), such as needing to
- * notify RCU core processing or task having blocked during the RCU
- * read-side critical section.
- */
-void rcu_read_unlock_special(struct task_struct *t)
-{
-	int empty;
-	int empty_exp;
-	unsigned long flags;
-	struct list_head *np;
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rbmp = NULL;
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	int special;
-
-	/*
-	 * NMI handlers cannot block and cannot safely manipulate state.
-	 * They therefore cannot possibly be special, so just leave.
-	 */
-	if (in_nmi())
-		return;
-
-	local_irq_save(flags);
-
-	/*
-	 * If RCU core is waiting for this CPU to exit critical section,
-	 * let it know that we have done so.
-	 */
-	special = t->rcu_read_unlock_special;
-	if (special & RCU_READ_UNLOCK_NEED_QS)
-		rcu_preempt_cpu_qs();
-
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
-		local_irq_restore(flags);
-		return;
-	}
-
-	/* Clean up if blocked during RCU read-side critical section. */
-	if (special & RCU_READ_UNLOCK_BLOCKED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
-
-		/*
-		 * Remove this task from the ->blkd_tasks list and adjust
-		 * any pointers that might have been referencing it.
-		 */
-		empty = !rcu_preempt_blocked_readers_cgp();
-		empty_exp = rcu_preempt_ctrlblk.exp_tasks == NULL;
-		np = rcu_next_node_entry(t);
-		list_del_init(&t->rcu_node_entry);
-		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.gp_tasks)
-			rcu_preempt_ctrlblk.gp_tasks = np;
-		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.exp_tasks)
-			rcu_preempt_ctrlblk.exp_tasks = np;
-#ifdef CONFIG_RCU_BOOST
-		if (&t->rcu_node_entry == rcu_preempt_ctrlblk.boost_tasks)
-			rcu_preempt_ctrlblk.boost_tasks = np;
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
-		/*
-		 * If this was the last task on the current list, and if
-		 * we aren't waiting on the CPU, report the quiescent state
-		 * and start a new grace period if needed.
-		 */
-		if (!empty && !rcu_preempt_blocked_readers_cgp()) {
-			rcu_preempt_cpu_qs();
-			rcu_preempt_start_gp();
-		}
-
-		/*
-		 * If this was the last task on the expedited lists,
-		 * then we need wake up the waiting task.
-		 */
-		if (!empty_exp && rcu_preempt_ctrlblk.exp_tasks == NULL)
-			rcu_report_exp_done();
-	}
-#ifdef CONFIG_RCU_BOOST
-	/* Unboost self if was boosted. */
-	if (t->rcu_boost_mutex != NULL) {
-		rbmp = t->rcu_boost_mutex;
-		t->rcu_boost_mutex = NULL;
-		rt_mutex_unlock(rbmp);
-	}
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	local_irq_restore(flags);
-}
-
-/*
- * Check for a quiescent state from the current CPU.  When a task blocks,
- * the task is recorded in the rcu_preempt_ctrlblk structure, which is
- * checked elsewhere.  This is called from the scheduling-clock interrupt.
- *
- * Caller must disable hard irqs.
- */
-static void rcu_preempt_check_callbacks(void)
-{
-	struct task_struct *t = current;
-
-	if (rcu_preempt_gp_in_progress() &&
-	    (!rcu_preempt_running_reader() ||
-	     !rcu_cpu_blocking_cur_gp()))
-		rcu_preempt_cpu_qs();
-	if (&rcu_preempt_ctrlblk.rcb.rcucblist !=
-	    rcu_preempt_ctrlblk.rcb.donetail)
-		invoke_rcu_callbacks();
-	if (rcu_preempt_gp_in_progress() &&
-	    rcu_cpu_blocking_cur_gp() &&
-	    rcu_preempt_running_reader() > 0)
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
-}
-
-/*
- * TINY_PREEMPT_RCU has an extra callback-list tail pointer to
- * update, so this is invoked from rcu_process_callbacks() to
- * handle that case.  Of course, it is invoked for all flavors of
- * RCU, but RCU callbacks can appear only on one of the lists, and
- * neither ->nexttail nor ->donetail can possibly be NULL, so there
- * is no need for an explicit check.
- */
-static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
-{
-	if (rcu_preempt_ctrlblk.nexttail == rcp->donetail)
-		rcu_preempt_ctrlblk.nexttail = &rcp->rcucblist;
-}
-
-/*
- * Process callbacks for preemptible RCU.
- */
-static void rcu_preempt_process_callbacks(void)
-{
-	__rcu_process_callbacks(&rcu_preempt_ctrlblk.rcb);
-}
-
-/*
- * Queue a preemptible -RCU callback for invocation after a grace period.
- */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-
-	debug_rcu_head_queue(head);
-	head->func = func;
-	head->next = NULL;
-
-	local_irq_save(flags);
-	*rcu_preempt_ctrlblk.nexttail = head;
-	rcu_preempt_ctrlblk.nexttail = &head->next;
-	RCU_TRACE(rcu_preempt_ctrlblk.rcb.qlen++);
-	rcu_preempt_start_gp();  /* checks to see if GP needed. */
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-/*
- * synchronize_rcu - wait until a grace period has elapsed.
- *
- * Control will return to the caller some time after a full grace
- * period has elapsed, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-void synchronize_rcu(void)
-{
-	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map) &&
-			   !lock_is_held(&rcu_lock_map) &&
-			   !lock_is_held(&rcu_sched_lock_map),
-			   "Illegal synchronize_rcu() in RCU read-side critical section");
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	if (!rcu_scheduler_active)
-		return;
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
-
-	WARN_ON_ONCE(rcu_preempt_running_reader());
-	if (!rcu_preempt_blocked_readers_any())
-		return;
-
-	/* Once we get past the fastpath checks, same code as rcu_barrier(). */
-	if (rcu_expedited)
-		synchronize_rcu_expedited();
-	else
-		rcu_barrier();
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu);
-
-static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
-static unsigned long sync_rcu_preempt_exp_count;
-static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
-
-/*
- * Return non-zero if there are any tasks in RCU read-side critical
- * sections blocking the current preemptible-RCU expedited grace period.
- * If there is no preemptible-RCU expedited grace period currently in
- * progress, returns zero unconditionally.
- */
-static int rcu_preempted_readers_exp(void)
-{
-	return rcu_preempt_ctrlblk.exp_tasks != NULL;
-}
-
-/*
- * Report the exit from RCU read-side critical section for the last task
- * that queued itself during or before the current expedited preemptible-RCU
- * grace period.
- */
-static void rcu_report_exp_done(void)
-{
-	wake_up(&sync_rcu_preempt_exp_wq);
-}
-
-/*
- * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
- * is to rely in the fact that there is but one CPU, and that it is
- * illegal for a task to invoke synchronize_rcu_expedited() while in a
- * preemptible-RCU read-side critical section.  Therefore, any such
- * critical sections must correspond to blocked tasks, which must therefore
- * be on the ->blkd_tasks list.  So just record the current head of the
- * list in the ->exp_tasks pointer, and wait for all tasks including and
- * after the task pointed to by ->exp_tasks to drain.
- */
-void synchronize_rcu_expedited(void)
-{
-	unsigned long flags;
-	struct rcu_preempt_ctrlblk *rpcp = &rcu_preempt_ctrlblk;
-	unsigned long snap;
-
-	barrier(); /* ensure prior action seen before grace period. */
-
-	WARN_ON_ONCE(rcu_preempt_running_reader());
-
-	/*
-	 * Acquire lock so that there is only one preemptible RCU grace
-	 * period in flight.  Of course, if someone does the expedited
-	 * grace period for us while we are acquiring the lock, just leave.
-	 */
-	snap = sync_rcu_preempt_exp_count + 1;
-	mutex_lock(&sync_rcu_preempt_exp_mutex);
-	if (ULONG_CMP_LT(snap, sync_rcu_preempt_exp_count))
-		goto unlock_mb_ret; /* Others did our work for us. */
-
-	local_irq_save(flags);
-
-	/*
-	 * All RCU readers have to already be on blkd_tasks because
-	 * we cannot legally be executing in an RCU read-side critical
-	 * section.
-	 */
-
-	/* Snapshot current head of ->blkd_tasks list. */
-	rpcp->exp_tasks = rpcp->blkd_tasks.next;
-	if (rpcp->exp_tasks == &rpcp->blkd_tasks)
-		rpcp->exp_tasks = NULL;
-
-	/* Wait for tail of ->blkd_tasks list to drain. */
-	if (!rcu_preempted_readers_exp()) {
-		local_irq_restore(flags);
-	} else {
-		rcu_initiate_boost();
-		local_irq_restore(flags);
-		wait_event(sync_rcu_preempt_exp_wq,
-			   !rcu_preempted_readers_exp());
-	}
-
-	/* Clean up and exit. */
-	barrier(); /* ensure expedited GP seen before counter increment. */
-	sync_rcu_preempt_exp_count++;
-unlock_mb_ret:
-	mutex_unlock(&sync_rcu_preempt_exp_mutex);
-	barrier(); /* ensure subsequent action seen after grace period. */
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu_expedited);
-
-/*
- * Does preemptible RCU need the CPU to stay out of dynticks mode?
- */
-int rcu_preempt_needs_cpu(void)
-{
-	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
-}
-
-#else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
-
-#ifdef CONFIG_RCU_TRACE
-
-/*
- * Because preemptible RCU does not exist, it is not necessary to
- * dump out its statistics.
- */
-static void show_tiny_preempt_stats(struct seq_file *m)
-{
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-/*
- * Because preemptible RCU does not exist, it never has any callbacks
- * to check.
- */
-static void rcu_preempt_check_callbacks(void)
-{
-}
-
-/*
- * Because preemptible RCU does not exist, it never has any callbacks
- * to remove.
- */
-static void rcu_preempt_remove_callbacks(struct rcu_ctrlblk *rcp)
-{
-}
-
-/*
- * Because preemptible RCU does not exist, it never has any callbacks
- * to process.
- */
-static void rcu_preempt_process_callbacks(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_TINY_PREEMPT_RCU */
-
-#ifdef CONFIG_RCU_BOOST
-
-/*
- * Wake up rcu_kthread() to process callbacks now eligible for invocation
- * or to boost readers.
- */
-static void invoke_rcu_callbacks(void)
-{
-	have_rcu_kthread_work = 1;
-	if (rcu_kthread_task != NULL)
-		wake_up(&rcu_kthread_wq);
-}
-
-#ifdef CONFIG_RCU_TRACE
-
-/*
- * Is the current CPU running the RCU-callbacks kthread?
- * Caller must have preemption disabled.
- */
-static bool rcu_is_callbacks_kthread(void)
-{
-	return rcu_kthread_task == current;
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-/*
- * This kthread invokes RCU callbacks whose grace periods have
- * elapsed.  It is awakened as needed, and takes the place of the
- * RCU_SOFTIRQ that is used for this purpose when boosting is disabled.
- * This is a kthread, but it is never stopped, at least not until
- * the system goes down.
- */
-static int rcu_kthread(void *arg)
-{
-	unsigned long work;
-	unsigned long morework;
-	unsigned long flags;
-
-	for (;;) {
-		wait_event_interruptible(rcu_kthread_wq,
-					 have_rcu_kthread_work != 0);
-		morework = rcu_boost();
-		local_irq_save(flags);
-		work = have_rcu_kthread_work;
-		have_rcu_kthread_work = morework;
-		local_irq_restore(flags);
-		if (work)
-			rcu_process_callbacks(NULL);
-		schedule_timeout_interruptible(1); /* Leave CPU for others. */
-	}
-
-	return 0;  /* Not reached, but needed to shut gcc up. */
-}
-
-/*
- * Spawn the kthread that invokes RCU callbacks.
- */
-static int __init rcu_spawn_kthreads(void)
-{
-	struct sched_param sp;
-
-	rcu_kthread_task = kthread_run(rcu_kthread, NULL, "rcu_kthread");
-	sp.sched_priority = RCU_BOOST_PRIO;
-	sched_setscheduler_nocheck(rcu_kthread_task, SCHED_FIFO, &sp);
-	return 0;
-}
-early_initcall(rcu_spawn_kthreads);
-
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-/* Hold off callback invocation until early_initcall() time. */
-static int rcu_scheduler_fully_active __read_mostly;
-
-/*
- * Start up softirq processing of callbacks.
- */
-void invoke_rcu_callbacks(void)
-{
-	if (rcu_scheduler_fully_active)
-		raise_softirq(RCU_SOFTIRQ);
-}
-
-#ifdef CONFIG_RCU_TRACE
-
-/*
- * There is no callback kthread, so this thread is never it.
- */
-static bool rcu_is_callbacks_kthread(void)
-{
-	return false;
-}
-
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-static int __init rcu_scheduler_really_started(void)
-{
-	rcu_scheduler_fully_active = 1;
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
-	raise_softirq(RCU_SOFTIRQ);  /* Invoke any callbacks from early boot. */
-	return 0;
-}
-early_initcall(rcu_scheduler_really_started);
-
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-#include <linux/kernel_stat.h>
 
 /*
  * During boot, we forgive RCU lockdep issues.  After this function is
@@ -1020,25 +72,6 @@ void __init rcu_scheduler_starting(void)
 
 #ifdef CONFIG_RCU_TRACE
 
-#ifdef CONFIG_RCU_BOOST
-
-static void rcu_initiate_boost_trace(void)
-{
-	if (list_empty(&rcu_preempt_ctrlblk.blkd_tasks))
-		rcu_preempt_ctrlblk.n_balk_blkd_tasks++;
-	else if (rcu_preempt_ctrlblk.gp_tasks == NULL &&
-		 rcu_preempt_ctrlblk.exp_tasks == NULL)
-		rcu_preempt_ctrlblk.n_balk_exp_gp_tasks++;
-	else if (rcu_preempt_ctrlblk.boost_tasks != NULL)
-		rcu_preempt_ctrlblk.n_balk_boost_tasks++;
-	else if (!ULONG_CMP_GE(jiffies, rcu_preempt_ctrlblk.boost_time))
-		rcu_preempt_ctrlblk.n_balk_notyet++;
-	else
-		rcu_preempt_ctrlblk.n_balk_nos++;
-}
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
 {
 	unsigned long flags;
@@ -1053,7 +86,6 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
  */
 static int show_tiny_stats(struct seq_file *m, void *unused)
 {
-	show_tiny_preempt_stats(m);
 	seq_printf(m, "rcu_sched: qlen: %ld\n", rcu_sched_ctrlblk.qlen);
 	seq_printf(m, "rcu_bh: qlen: %ld\n", rcu_bh_ctrlblk.qlen);
 	return 0;
@@ -1103,11 +135,40 @@ MODULE_AUTHOR("Paul E. McKenney");
 MODULE_DESCRIPTION("Read-Copy Update tracing for tiny implementation");
 MODULE_LICENSE("GPL");
 
-static void check_cpu_stall_preempt(void)
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
 {
-#ifdef CONFIG_TINY_PREEMPT_RCU
-	check_cpu_stall(&rcu_preempt_ctrlblk.rcb);
-#endif /* #ifdef CONFIG_TINY_PREEMPT_RCU */
+	unsigned long j;
+	unsigned long js;
+
+	if (rcu_cpu_stall_suppress)
+		return;
+	rcp->ticks_this_gp++;
+	j = jiffies;
+	js = rcp->jiffies_stall;
+	if (*rcp->curtail && ULONG_CMP_GE(j, js)) {
+		pr_err("INFO: %s stall on CPU (%lu ticks this GP) idle=%llx (t=%lu jiffies q=%ld)\n",
+		       rcp->name, rcp->ticks_this_gp, rcu_dynticks_nesting,
+		       jiffies - rcp->gp_start, rcp->qlen);
+		dump_stack();
+	}
+	if (*rcp->curtail && ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies +
+			3 * rcu_jiffies_till_stall_check() + 3;
+	else if (ULONG_CMP_GE(j, js))
+		rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+}
+
+static void reset_cpu_stall_ticks(struct rcu_ctrlblk *rcp)
+{
+	rcp->ticks_this_gp = 0;
+	rcp->gp_start = jiffies;
+	rcp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+}
+
+static void check_cpu_stalls(void)
+{
+	RCU_TRACE(check_cpu_stall(&rcu_bh_ctrlblk));
+	RCU_TRACE(check_cpu_stall(&rcu_sched_ctrlblk));
 }
 
 #endif /* #ifdef CONFIG_RCU_TRACE */
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e1f3a8c..b1fa551 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -695,44 +695,6 @@ static struct rcu_torture_ops srcu_sync_ops = {
 	.name		= "srcu_sync"
 };
 
-static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
-{
-	return srcu_read_lock_raw(&srcu_ctl);
-}
-
-static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
-{
-	srcu_read_unlock_raw(&srcu_ctl, idx);
-}
-
-static struct rcu_torture_ops srcu_raw_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= srcu_torture_read_lock_raw,
-	.read_delay	= srcu_read_delay,
-	.readunlock	= srcu_torture_read_unlock_raw,
-	.completed	= srcu_torture_completed,
-	.deferred_free	= srcu_torture_deferred_free,
-	.sync		= srcu_torture_synchronize,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.stats		= srcu_torture_stats,
-	.name		= "srcu_raw"
-};
-
-static struct rcu_torture_ops srcu_raw_sync_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= srcu_torture_read_lock_raw,
-	.read_delay	= srcu_read_delay,
-	.readunlock	= srcu_torture_read_unlock_raw,
-	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= srcu_torture_synchronize,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.stats		= srcu_torture_stats,
-	.name		= "srcu_raw_sync"
-};
-
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -1983,7 +1945,6 @@ rcu_torture_init(void)
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
 		  &srcu_ops, &srcu_sync_ops, &srcu_expedited_ops,
-		  &srcu_raw_ops, &srcu_raw_sync_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3538001..cf3adc6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -218,8 +218,8 @@ module_param(blimit, long, 0444);
 module_param(qhimark, long, 0444);
 module_param(qlowmark, long, 0444);
 
-static ulong jiffies_till_first_fqs = RCU_JIFFIES_TILL_FORCE_QS;
-static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
+static ulong jiffies_till_first_fqs = ULONG_MAX;
+static ulong jiffies_till_next_fqs = ULONG_MAX;
 
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
@@ -866,7 +866,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s detected stalls on CPUs/tasks:",
+	pr_err("INFO: %s detected stalls on CPUs/tasks:",
 	       rsp->name);
 	print_cpu_stall_info_begin();
 	rcu_for_each_leaf_node(rsp, rnp) {
@@ -899,7 +899,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
 	       rsp->gpnum, rsp->completed, totqlen);
 	if (ndetected == 0)
-		printk(KERN_ERR "INFO: Stall ended before state dump start\n");
+		pr_err("INFO: Stall ended before state dump start\n");
 	else if (!trigger_all_cpu_backtrace())
 		rcu_dump_cpu_stacks(rsp);
 
@@ -922,7 +922,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	 * See Documentation/RCU/stallwarn.txt for info on how to debug
 	 * RCU CPU stall warnings.
 	 */
-	printk(KERN_ERR "INFO: %s self-detected stall on CPU", rsp->name);
+	pr_err("INFO: %s self-detected stall on CPU", rsp->name);
 	print_cpu_stall_info_begin();
 	print_cpu_stall_info(rsp, smp_processor_id());
 	print_cpu_stall_info_end();
@@ -985,65 +985,6 @@ void rcu_cpu_stall_reset(void)
 }
 
 /*
- * Update CPU-local rcu_data state to record the newly noticed grace period.
- * This is used both when we started the grace period and when we notice
- * that someone else started the grace period.  The caller must hold the
- * ->lock of the leaf rcu_node structure corresponding to the current CPU,
- *  and must have irqs disabled.
- */
-static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
-{
-	if (rdp->gpnum != rnp->gpnum) {
-		/*
-		 * If the current grace period is waiting for this CPU,
-		 * set up to detect a quiescent state, otherwise don't
-		 * go looking for one.
-		 */
-		rdp->gpnum = rnp->gpnum;
-		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
-		rdp->passed_quiesce = 0;
-		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
-		zero_cpu_stall_ticks(rdp);
-	}
-}
-
-static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-	struct rcu_node *rnp;
-
-	local_irq_save(flags);
-	rnp = rdp->mynode;
-	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
-	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
-		local_irq_restore(flags);
-		return;
-	}
-	__note_new_gpnum(rsp, rnp, rdp);
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-}
-
-/*
- * Did someone else start a new RCU grace period start since we last
- * checked?  Update local state appropriately if so.  Must be called
- * on the CPU corresponding to rdp.
- */
-static int
-check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	local_irq_save(flags);
-	if (rdp->gpnum != rsp->gpnum) {
-		note_new_gpnum(rsp, rdp);
-		ret = 1;
-	}
-	local_irq_restore(flags);
-	return ret;
-}
-
-/*
  * Initialize the specified rcu_data structure's callback list to empty.
  */
 static void init_callback_list(struct rcu_data *rdp)
@@ -1313,18 +1254,16 @@ static void rcu_advance_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 }
 
 /*
- * Advance this CPU's callbacks, but only if the current grace period
- * has ended.  This may be called only from the CPU to whom the rdp
- * belongs.  In addition, the corresponding leaf rcu_node structure's
- * ->lock must be held by the caller, with irqs disabled.
+ * Update CPU-local rcu_data state to record the beginnings and ends of
+ * grace periods.  The caller must hold the ->lock of the leaf rcu_node
+ * structure corresponding to the current CPU, and must have irqs disabled.
  */
-static void
-__rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
+static void __note_gp_changes(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
 {
-	/* Did another grace period end? */
+	/* Handle the ends of any preceding grace periods first. */
 	if (rdp->completed == rnp->completed) {
 
-		/* No, so just accelerate recent callbacks. */
+		/* No grace period end, so just accelerate recent callbacks. */
 		rcu_accelerate_cbs(rsp, rnp, rdp);
 
 	} else {
@@ -1335,68 +1274,40 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
 		/* Remember that we saw this grace-period completion. */
 		rdp->completed = rnp->completed;
 		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuend");
+	}
 
+	if (rdp->gpnum != rnp->gpnum) {
 		/*
-		 * If we were in an extended quiescent state, we may have
-		 * missed some grace periods that others CPUs handled on
-		 * our behalf. Catch up with this state to avoid noting
-		 * spurious new grace periods.  If another grace period
-		 * has started, then rnp->gpnum will have advanced, so
-		 * we will detect this later on.  Of course, any quiescent
-		 * states we found for the old GP are now invalid.
-		 */
-		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed)) {
-			rdp->gpnum = rdp->completed;
-			rdp->passed_quiesce = 0;
-		}
-
-		/*
-		 * If RCU does not need a quiescent state from this CPU,
-		 * then make sure that this CPU doesn't go looking for one.
+		 * If the current grace period is waiting for this CPU,
+		 * set up to detect a quiescent state, otherwise don't
+		 * go looking for one.
 		 */
-		if ((rnp->qsmask & rdp->grpmask) == 0)
-			rdp->qs_pending = 0;
+		rdp->gpnum = rnp->gpnum;
+		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
+		rdp->passed_quiesce = 0;
+		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
+		zero_cpu_stall_ticks(rdp);
 	}
 }
 
-/*
- * Advance this CPU's callbacks, but only if the current grace period
- * has ended.  This may be called only from the CPU to whom the rdp
- * belongs.
- */
-static void
-rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
+static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_node *rnp;
 
 	local_irq_save(flags);
 	rnp = rdp->mynode;
-	if (rdp->completed == ACCESS_ONCE(rnp->completed) || /* outside lock. */
+	if ((rdp->gpnum == ACCESS_ONCE(rnp->gpnum) &&
+	     rdp->completed == ACCESS_ONCE(rnp->completed)) || /* w/out lock. */
 	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
 		local_irq_restore(flags);
 		return;
 	}
-	__rcu_process_gp_end(rsp, rnp, rdp);
+	__note_gp_changes(rsp, rnp, rdp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
- * Do per-CPU grace-period initialization for running CPU.  The caller
- * must hold the lock of the leaf rcu_node structure corresponding to
- * this CPU.
- */
-static void
-rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
-{
-	/* Prior grace period ended, so advance callbacks for current CPU. */
-	__rcu_process_gp_end(rsp, rnp, rdp);
-
-	/* Set state so that this CPU will detect the next quiescent state. */
-	__note_new_gpnum(rsp, rnp, rdp);
-}
-
-/*
  * Initialize a new grace period.
  */
 static int rcu_gp_init(struct rcu_state *rsp)
@@ -1444,7 +1355,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		WARN_ON_ONCE(rnp->completed != rsp->completed);
 		ACCESS_ONCE(rnp->completed) = rsp->completed;
 		if (rnp == rdp->mynode)
-			rcu_start_gp_per_cpu(rsp, rnp, rdp);
+			__note_gp_changes(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
 		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
 					    rnp->level, rnp->grplo,
@@ -1527,7 +1438,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
 		rdp = this_cpu_ptr(rsp->rda);
 		if (rnp == rdp->mynode)
-			__rcu_process_gp_end(rsp, rnp, rdp);
+			__note_gp_changes(rsp, rnp, rdp);
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
@@ -1805,9 +1716,8 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
 static void
 rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	/* If there is now a new grace period, record and return. */
-	if (check_for_new_grace_period(rsp, rdp))
-		return;
+	/* Check for grace-period ends and beginnings. */
+	note_gp_changes(rsp, rdp);
 
 	/*
 	 * Does this CPU still need to do its part for current grace period?
@@ -2271,9 +2181,6 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 
 	WARN_ON_ONCE(rdp->beenonline == 0);
 
-	/* Handle the end of a grace period that some other CPU ended.  */
-	rcu_process_gp_end(rsp, rdp);
-
 	/* Update RCU state based on any recent quiescent states. */
 	rcu_check_quiescent_state(rsp, rdp);
 
@@ -2358,8 +2265,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 	if (unlikely(rdp->qlen > rdp->qlen_last_fqs_check + qhimark)) {
 
 		/* Are we ignoring a completed grace period? */
-		rcu_process_gp_end(rsp, rdp);
-		check_for_new_grace_period(rsp, rdp);
+		note_gp_changes(rsp, rdp);
 
 		/* Start a new grace period if one not already started. */
 		if (!rcu_gp_in_progress(rsp)) {
@@ -3265,11 +3171,25 @@ static void __init rcu_init_one(struct rcu_state *rsp,
  */
 static void __init rcu_init_geometry(void)
 {
+	ulong d;
 	int i;
 	int j;
 	int n = nr_cpu_ids;
 	int rcu_capacity[MAX_RCU_LVLS + 1];
 
+	/*
+	 * Initialize any unspecified boot parameters.
+	 * The default values of jiffies_till_first_fqs and
+	 * jiffies_till_next_fqs are set to the RCU_JIFFIES_TILL_FORCE_QS
+	 * value, which is a function of HZ, then adding one for each
+	 * RCU_JIFFIES_FQS_DIV CPUs that might be on the system.
+	 */
+	d = RCU_JIFFIES_TILL_FORCE_QS + nr_cpu_ids / RCU_JIFFIES_FQS_DIV;
+	if (jiffies_till_first_fqs == ULONG_MAX)
+		jiffies_till_first_fqs = d;
+	if (jiffies_till_next_fqs == ULONG_MAX)
+		jiffies_till_next_fqs = d;
+
 	/* If the compile-time values are accurate, just leave. */
 	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF &&
 	    nr_cpu_ids == NR_CPUS)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4df5034..4a39d36 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -343,12 +343,17 @@ struct rcu_data {
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 
-#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#define RCU_JIFFIES_TILL_FORCE_QS (1 + (HZ > 250) + (HZ > 500))
+					/* For jiffies_till_first_fqs and */
+					/*  and jiffies_till_next_fqs. */
 
-#define RCU_STALL_RAT_DELAY		2	/* Allow other CPUs time */
-						/*  to take at least one */
-						/*  scheduling clock irq */
-						/*  before ratting on them. */
+#define RCU_JIFFIES_FQS_DIV	256	/* Very large systems need more */
+					/*  delay between bouts of */
+					/*  quiescent-state forcing. */
+
+#define RCU_STALL_RAT_DELAY	2	/* Allow other CPUs time to take */
+					/*  at least one scheduling clock */
+					/*  irq before ratting on them. */
 
 #define rcu_wait(cond)							\
 do {									\
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3db5a37..63098a5 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -53,38 +53,37 @@ static char __initdata nocb_buf[NR_CPUS * 5];
 static void __init rcu_bootup_announce_oddness(void)
 {
 #ifdef CONFIG_RCU_TRACE
-	printk(KERN_INFO "\tRCU debugfs-based tracing is enabled.\n");
+	pr_info("\tRCU debugfs-based tracing is enabled.\n");
 #endif
 #if (defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 64) || (!defined(CONFIG_64BIT) && CONFIG_RCU_FANOUT != 32)
-	printk(KERN_INFO "\tCONFIG_RCU_FANOUT set to non-default value of %d\n",
+	pr_info("\tCONFIG_RCU_FANOUT set to non-default value of %d\n",
 	       CONFIG_RCU_FANOUT);
 #endif
 #ifdef CONFIG_RCU_FANOUT_EXACT
-	printk(KERN_INFO "\tHierarchical RCU autobalancing is disabled.\n");
+	pr_info("\tHierarchical RCU autobalancing is disabled.\n");
 #endif
 #ifdef CONFIG_RCU_FAST_NO_HZ
-	printk(KERN_INFO
-	       "\tRCU dyntick-idle grace-period acceleration is enabled.\n");
+	pr_info("\tRCU dyntick-idle grace-period acceleration is enabled.\n");
 #endif
 #ifdef CONFIG_PROVE_RCU
-	printk(KERN_INFO "\tRCU lockdep checking is enabled.\n");
+	pr_info("\tRCU lockdep checking is enabled.\n");
 #endif
 #ifdef CONFIG_RCU_TORTURE_TEST_RUNNABLE
-	printk(KERN_INFO "\tRCU torture testing starts during boot.\n");
+	pr_info("\tRCU torture testing starts during boot.\n");
 #endif
 #if defined(CONFIG_TREE_PREEMPT_RCU) && !defined(CONFIG_RCU_CPU_STALL_VERBOSE)
-	printk(KERN_INFO "\tDump stacks of tasks blocking RCU-preempt GP.\n");
+	pr_info("\tDump stacks of tasks blocking RCU-preempt GP.\n");
 #endif
 #if defined(CONFIG_RCU_CPU_STALL_INFO)
-	printk(KERN_INFO "\tAdditional per-CPU info printed with stalls.\n");
+	pr_info("\tAdditional per-CPU info printed with stalls.\n");
 #endif
 #if NUM_RCU_LVL_4 != 0
-	printk(KERN_INFO "\tFour-level hierarchy is enabled.\n");
+	pr_info("\tFour-level hierarchy is enabled.\n");
 #endif
 	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
-		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
+		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
-		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
+		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
 	if (!have_rcu_nocb_mask) {
@@ -92,19 +91,19 @@ static void __init rcu_bootup_announce_oddness(void)
 		have_rcu_nocb_mask = true;
 	}
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO
-	pr_info("\tExperimental no-CBs CPU 0\n");
+	pr_info("\tOffload RCU callbacks from CPU 0\n");
 	cpumask_set_cpu(0, rcu_nocb_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
 #ifdef CONFIG_RCU_NOCB_CPU_ALL
-	pr_info("\tExperimental no-CBs for all CPUs\n");
+	pr_info("\tOffload RCU callbacks from all CPUs\n");
 	cpumask_setall(rcu_nocb_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
 	if (have_rcu_nocb_mask) {
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
+		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
-			pr_info("\tExperimental polled no-CBs CPUs.\n");
+			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
 	}
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 }
@@ -123,7 +122,7 @@ static int rcu_preempted_readers_exp(struct rcu_node *rnp);
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO "Preemptible hierarchical RCU implementation.\n");
+	pr_info("Preemptible hierarchical RCU implementation.\n");
 	rcu_bootup_announce_oddness();
 }
 
@@ -490,13 +489,13 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
 
 static void rcu_print_task_stall_begin(struct rcu_node *rnp)
 {
-	printk(KERN_ERR "\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
+	pr_err("\tTasks blocked on level-%d rcu_node (CPUs %d-%d):",
 	       rnp->level, rnp->grplo, rnp->grphi);
 }
 
 static void rcu_print_task_stall_end(void)
 {
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
@@ -526,7 +525,7 @@ static int rcu_print_task_stall(struct rcu_node *rnp)
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry) {
-		printk(KERN_CONT " P%d", t->pid);
+		pr_cont(" P%d", t->pid);
 		ndetected++;
 	}
 	rcu_print_task_stall_end();
@@ -933,6 +932,24 @@ static void __init __rcu_init_preempt(void)
 	rcu_init_one(&rcu_preempt_state, &rcu_preempt_data);
 }
 
+/*
+ * Check for a task exiting while in a preemptible-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (likely(list_empty(&current->rcu_node_entry)))
+		return;
+	t->rcu_read_lock_nesting = 1;
+	barrier();
+	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	__rcu_read_unlock();
+}
+
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state = &rcu_sched_state;
@@ -942,7 +959,7 @@ static struct rcu_state *rcu_state = &rcu_sched_state;
  */
 static void __init rcu_bootup_announce(void)
 {
-	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+	pr_info("Hierarchical RCU implementation.\n");
 	rcu_bootup_announce_oddness();
 }
 
@@ -1101,6 +1118,14 @@ static void __init __rcu_init_preempt(void)
 {
 }
 
+/*
+ * Because preemptible RCU does not exist, tasks cannot possibly exit
+ * while in preemptible RCU read-side critical sections.
+ */
+void exit_rcu(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_BOOST
@@ -1629,7 +1654,7 @@ static bool rcu_try_advance_all_cbs(void)
 		 */
 		if (rdp->completed != rnp->completed &&
 		    rdp->nxttail[RCU_DONE_TAIL] != rdp->nxttail[RCU_NEXT_TAIL])
-			rcu_process_gp_end(rsp, rdp);
+			note_gp_changes(rsp, rdp);
 
 		if (cpu_has_callbacks_ready_to_invoke(rdp))
 			cbs_ready = true;
@@ -1883,7 +1908,7 @@ static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 /* Initiate the stall-info list. */
 static void print_cpu_stall_info_begin(void)
 {
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 /*
@@ -1914,7 +1939,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 		ticks_value = rsp->gpnum - rdp->gpnum;
 	}
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
-	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
+	pr_err("\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
 	       cpu, ticks_value, ticks_title,
 	       atomic_read(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
@@ -1925,7 +1950,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 /* Terminate the stall-info list. */
 static void print_cpu_stall_info_end(void)
 {
-	printk(KERN_ERR "\t");
+	pr_err("\t");
 }
 
 /* Zero ->ticks_this_gp for all flavors of RCU. */
@@ -1948,17 +1973,17 @@ static void increment_cpu_stall_ticks(void)
 
 static void print_cpu_stall_info_begin(void)
 {
-	printk(KERN_CONT " {");
+	pr_cont(" {");
 }
 
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 {
-	printk(KERN_CONT " %d", cpu);
+	pr_cont(" %d", cpu);
 }
 
 static void print_cpu_stall_info_end(void)
 {
-	printk(KERN_CONT "} ");
+	pr_cont("} ");
 }
 
 static void zero_cpu_stall_ticks(struct rcu_data *rdp)
