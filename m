Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3KKOKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:10:51 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42324 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3KKOKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:10:41 -0500
Date: Mon, 11 Nov 2013 15:10:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.13
Message-ID: <20131111141037.GA9847@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   # HEAD: 0e95c69bde1a5bf22acd53b356fe10d7bec6e2be Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The main RCU changes in this cycle are:
    
  - Idle entry/exit changes, to throttle callback execution and
    other refinements to speed up kbuild, primarily to address
    performance issues located by Tibor Billes.

  - Grace-period related changes, primarily to aid in debugging,
    inspired by an -rt debugging session.
    
  - Code reorganization moving RCU's source files into its own
    kernel/rcu/ directory.

  - RCU documentation updates
    
  - Miscellaneous fixes.

Note, the following commit:

  5c889690aa08 mm: Place preemption point in do_mlockall() loop

is identical to the commit already in your tree via email:

  22356f447ceb mm: Place preemption point in do_mlockall() loop

[ Your version of the changelog nicely demonstrates it how kernel oops 
  messages should be trimmed properly :-/ ]

 Thanks,

	Ingo

------------------>
Christoph Lameter (1):
      rcu: Replace __get_cpu_var() uses

Kirill Tkhai (1):
      rcu: Fix CONFIG_RCU_NOCB_CPU_ALL panic on machines with sparse CPU mask

Michael Opdenacker (1):
      rcu: Fix occurrence of "the the" in checklist.txt

Paul E. McKenney (27):
      mm: Place preemption point in do_mlockall() loop
      rcu: Use proper cpp macro for ->gp_flags
      rcu: Convert local functions to static
      rcu: Fix dubious "if" condition in __call_rcu_nocb_enqueue()
      rcu: Make list_splice_init_rcu() account for RCU readers
      rcu: Silence unused-variable warnings
      rcu: Micro-optimize rcu_cpu_has_callbacks()
      rcu: Reject memory-order-induced stall-warning false positives
      rcu: Have rcutiny tracepoints use tracepoint_string()
      rcu: Improve grace-period start logic
      rcu: Prevent spurious-wakeup DoS attack on rcu_gp_kthread()
      rcu: Flag lockless access to ->gp_flags with ACCESS_ONCE()
      rcu: Add tracing to rcu_gp_kthread()
      rcu: Add tracing of normal (non-NOCB) grace-period requests
      rcu: Add tracing for rcuo no-CBs CPU wakeup handshake
      rcu: Distinguish between NOCB and non-NOCB rcu_callback trace events
      rcu: Track rcu_nocb_kthread()'s sleeping and awakening
      rcu: Avoid sparse warnings in rcu_nocb_wake trace event
      rcu: Remove redundant code from rcu_cleanup_after_idle()
      rcu: Throttle rcu_try_advance_all_cbs() execution
      rcu: Throttle invoke_rcu_core() invocations due to non-lazy callbacks
      rcu: Is it safe to enter an RCU read-side critical section?
      rcu: Change EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL()
      rcu: Consistent rcu_is_watching() naming
      rcu: Update stall-warning documentation
      kthread: Add pointer to vmstat-avoidance patch
      rcu: Move RCU-related source code to kernel/rcu directory


 Documentation/DocBook/device-drivers.tmpl      |   5 +-
 Documentation/RCU/checklist.txt                |   4 +-
 Documentation/RCU/stallwarn.txt                |  22 ++-
 Documentation/kernel-parameters.txt            |  95 ++++++++-----
 Documentation/kernel-per-CPU-kthreads.txt      |  17 ++-
 MAINTAINERS                                    |  11 +-
 include/linux/rculist.h                        |  23 ++-
 include/linux/rcupdate.h                       |  24 ++--
 include/linux/rcutiny.h                        |  17 +++
 include/linux/rcutree.h                        |   2 +
 include/trace/events/rcu.h                     |  80 +++++++++--
 kernel/Makefile                                |  11 +-
 kernel/lockdep.c                               |   4 +-
 kernel/rcu/Makefile                            |   6 +
 kernel/{ => rcu}/rcu.h                         |   7 +
 kernel/{ => rcu}/srcu.c                        |   0
 kernel/{rcutiny.c => rcu/tiny.c}               |  37 ++---
 kernel/{rcutiny_plugin.h => rcu/tiny_plugin.h} |   0
 kernel/{rcutorture.c => rcu/torture.c}         |   6 +
 kernel/{rcutree.c => rcu/tree.c}               | 185 ++++++++++++++++++-------
 kernel/{rcutree.h => rcu/tree.h}               |   2 +
 kernel/{rcutree_plugin.h => rcu/tree_plugin.h} |  84 +++++++----
 kernel/{rcutree_trace.c => rcu/tree_trace.c}   |   2 +-
 kernel/{rcupdate.c => rcu/update.c}            |  10 +-
 24 files changed, 464 insertions(+), 190 deletions(-)
 create mode 100644 kernel/rcu/Makefile
 rename kernel/{ => rcu}/rcu.h (94%)
 rename kernel/{ => rcu}/srcu.c (100%)
 rename kernel/{rcutiny.c => rcu/tiny.c} (90%)
 rename kernel/{rcutiny_plugin.h => rcu/tiny_plugin.h} (100%)
 rename kernel/{rcutorture.c => rcu/torture.c} (99%)
 rename kernel/{rcutree.c => rcu/tree.c} (95%)
 rename kernel/{rcutree.h => rcu/tree.h} (99%)
 rename kernel/{rcutree_plugin.h => rcu/tree_plugin.h} (97%)
 rename kernel/{rcutree_trace.c => rcu/tree_trace.c} (99%)
 rename kernel/{rcupdate.c => rcu/update.c} (97%)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index fe397f9..6c9d9d3 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -87,7 +87,10 @@ X!Iinclude/linux/kobject.h
 !Ekernel/printk/printk.c
 !Ekernel/panic.c
 !Ekernel/sys.c
-!Ekernel/rcupdate.c
+!Ekernel/rcu/srcu.c
+!Ekernel/rcu/tree.c
+!Ekernel/rcu/tree_plugin.h
+!Ekernel/rcu/update.c
      </sect1>
 
      <sect1><title>Device Resource Management</title>
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 7703ec7..9126619 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -202,8 +202,8 @@ over a rather long period of time, but improvements are always welcome!
 	updater uses call_rcu_sched() or synchronize_sched(), then
 	the corresponding readers must disable preemption, possibly
 	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
-	If the updater uses synchronize_srcu() or call_srcu(),
-	the the corresponding readers must use srcu_read_lock() and
+	If the updater uses synchronize_srcu() or call_srcu(), then
+	the corresponding readers must use srcu_read_lock() and
 	srcu_read_unlock(), and with the same srcu_struct.  The rules for
 	the expedited primitives are the same as for their non-expedited
 	counterparts.  Mixing things up will result in confusion and
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 8e9359d..6f3a005 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -12,12 +12,12 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	This kernel configuration parameter defines the period of time
 	that RCU will wait from the beginning of a grace period until it
 	issues an RCU CPU stall warning.  This time period is normally
-	sixty seconds.
+	21 seconds.
 
 	This configuration parameter may be changed at runtime via the
 	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
 	this parameter is checked only at the beginning of a cycle.
-	So if you are 30 seconds into a 70-second stall, setting this
+	So if you are 10 seconds into a 40-second stall, setting this
 	sysfs parameter to (say) five will shorten the timeout for the
 	-next- stall, or the following warning for the current stall
 	(assuming the stall lasts long enough).  It will not affect the
@@ -32,7 +32,7 @@ CONFIG_RCU_CPU_STALL_VERBOSE
 	also dump the stacks of any tasks that are blocking the current
 	RCU-preempt grace period.
 
-RCU_CPU_STALL_INFO
+CONFIG_RCU_CPU_STALL_INFO
 
 	This kernel configuration parameter causes the stall warning to
 	print out additional per-CPU diagnostic information, including
@@ -43,7 +43,8 @@ RCU_STALL_DELAY_DELTA
 	Although the lockdep facility is extremely useful, it does add
 	some overhead.  Therefore, under CONFIG_PROVE_RCU, the
 	RCU_STALL_DELAY_DELTA macro allows five extra seconds before
-	giving an RCU CPU stall warning message.
+	giving an RCU CPU stall warning message.  (This is a cpp
+	macro, not a kernel configuration parameter.)
 
 RCU_STALL_RAT_DELAY
 
@@ -52,7 +53,8 @@ RCU_STALL_RAT_DELAY
 	However, if the offending CPU does not detect its own stall in
 	the number of jiffies specified by RCU_STALL_RAT_DELAY, then
 	some other CPU will complain.  This delay is normally set to
-	two jiffies.
+	two jiffies.  (This is a cpp macro, not a kernel configuration
+	parameter.)
 
 When a CPU detects that it is stalling, it will print a message similar
 to the following:
@@ -86,7 +88,12 @@ printing, there will be a spurious stall-warning message:
 
 INFO: rcu_bh_state detected stalls on CPUs/tasks: { } (detected by 4, 2502 jiffies)
 
-This is rare, but does happen from time to time in real life.
+This is rare, but does happen from time to time in real life.  It is also
+possible for a zero-jiffy stall to be flagged in this case, depending
+on how the stall warning and the grace-period initialization happen to
+interact.  Please note that it is not possible to entirely eliminate this
+sort of false positive without resorting to things like stop_machine(),
+which is overkill for this sort of problem.
 
 If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
 more information is printed with the stall-warning message, for example:
@@ -216,4 +223,5 @@ that portion of the stack which remains the same from trace to trace.
 If you can reliably trigger the stall, ftrace can be quite helpful.
 
 RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE
-and with RCU's event tracing.
+and with RCU's event tracing.  For information on RCU's event tracing,
+see include/trace/events/rcu.h.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736..203f4a9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2599,7 +2599,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
-	rcu_nocbs=	[KNL,BOOT]
+	rcu_nocbs=	[KNL]
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
 			Invocation of these CPUs' RCU callbacks will
@@ -2612,7 +2612,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
-	rcu_nocb_poll	[KNL,BOOT]
+	rcu_nocb_poll	[KNL]
 			Rather than requiring that offloaded CPUs
 			(specified by rcu_nocbs= above) explicitly
 			awaken the corresponding "rcuoN" kthreads,
@@ -2623,126 +2623,145 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			energy efficiency by requiring that the kthreads
 			periodically wake up to do the polling.
 
-	rcutree.blimit=	[KNL,BOOT]
+	rcutree.blimit=	[KNL]
 			Set maximum number of finished RCU callbacks to process
 			in one batch.
 
-	rcutree.fanout_leaf=	[KNL,BOOT]
+	rcutree.rcu_fanout_leaf= [KNL]
 			Increase the number of CPUs assigned to each
 			leaf rcu_node structure.  Useful for very large
 			systems.
 
-	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
+	rcutree.jiffies_till_first_fqs= [KNL]
 			Set delay from grace-period initialization to
 			first attempt to force quiescent states.
 			Units are jiffies, minimum value is zero,
 			and maximum value is HZ.
 
-	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
+	rcutree.jiffies_till_next_fqs= [KNL]
 			Set delay between subsequent attempts to force
 			quiescent states.  Units are jiffies, minimum
 			value is one, and maximum value is HZ.
 
-	rcutree.qhimark=	[KNL,BOOT]
+	rcutree.qhimark= [KNL]
 			Set threshold of queued
 			RCU callbacks over which batch limiting is disabled.
 
-	rcutree.qlowmark=	[KNL,BOOT]
+	rcutree.qlowmark= [KNL]
 			Set threshold of queued RCU callbacks below which
 			batch limiting is re-enabled.
 
-	rcutree.rcu_cpu_stall_suppress=	[KNL,BOOT]
-			Suppress RCU CPU stall warning messages.
-
-	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
-			Set timeout for RCU CPU stall warning messages.
-
-	rcutree.rcu_idle_gp_delay=	[KNL,BOOT]
+	rcutree.rcu_idle_gp_delay= [KNL]
 			Set wakeup interval for idle CPUs that have
 			RCU callbacks (RCU_FAST_NO_HZ=y).
 
-	rcutree.rcu_idle_lazy_gp_delay=	[KNL,BOOT]
+	rcutree.rcu_idle_lazy_gp_delay= [KNL]
 			Set wakeup interval for idle CPUs that have
 			only "lazy" RCU callbacks (RCU_FAST_NO_HZ=y).
 			Lazy RCU callbacks are those which RCU can
 			prove do nothing more than free memory.
 
-	rcutorture.fqs_duration= [KNL,BOOT]
+	rcutorture.fqs_duration= [KNL]
 			Set duration of force_quiescent_state bursts.
 
-	rcutorture.fqs_holdoff= [KNL,BOOT]
+	rcutorture.fqs_holdoff= [KNL]
 			Set holdoff time within force_quiescent_state bursts.
 
-	rcutorture.fqs_stutter= [KNL,BOOT]
+	rcutorture.fqs_stutter= [KNL]
 			Set wait time between force_quiescent_state bursts.
 
-	rcutorture.irqreader= [KNL,BOOT]
-			Test RCU readers from irq handlers.
+	rcutorture.gp_exp= [KNL]
+			Use expedited update-side primitives.
+
+	rcutorture.gp_normal= [KNL]
+			Use normal (non-expedited) update-side primitives.
+			If both gp_exp and gp_normal are set, do both.
+			If neither gp_exp nor gp_normal are set, still
+			do both.
 
-	rcutorture.n_barrier_cbs= [KNL,BOOT]
+	rcutorture.n_barrier_cbs= [KNL]
 			Set callbacks/threads for rcu_barrier() testing.
 
-	rcutorture.nfakewriters= [KNL,BOOT]
+	rcutorture.nfakewriters= [KNL]
 			Set number of concurrent RCU writers.  These just
 			stress RCU, they don't participate in the actual
 			test, hence the "fake".
 
-	rcutorture.nreaders= [KNL,BOOT]
+	rcutorture.nreaders= [KNL]
 			Set number of RCU readers.
 
-	rcutorture.onoff_holdoff= [KNL,BOOT]
+	rcutorture.object_debug= [KNL]
+			Enable debug-object double-call_rcu() testing.
+
+	rcutorture.onoff_holdoff= [KNL]
 			Set time (s) after boot for CPU-hotplug testing.
 
-	rcutorture.onoff_interval= [KNL,BOOT]
+	rcutorture.onoff_interval= [KNL]
 			Set time (s) between CPU-hotplug operations, or
 			zero to disable CPU-hotplug testing.
 
-	rcutorture.shuffle_interval= [KNL,BOOT]
+	rcutorture.rcutorture_runnable= [BOOT]
+			Start rcutorture running at boot time.
+
+	rcutorture.shuffle_interval= [KNL]
 			Set task-shuffle interval (s).  Shuffling tasks
 			allows some CPUs to go into dyntick-idle mode
 			during the rcutorture test.
 
-	rcutorture.shutdown_secs= [KNL,BOOT]
+	rcutorture.shutdown_secs= [KNL]
 			Set time (s) after boot system shutdown.  This
 			is useful for hands-off automated testing.
 
-	rcutorture.stall_cpu= [KNL,BOOT]
+	rcutorture.stall_cpu= [KNL]
 			Duration of CPU stall (s) to test RCU CPU stall
 			warnings, zero to disable.
 
-	rcutorture.stall_cpu_holdoff= [KNL,BOOT]
+	rcutorture.stall_cpu_holdoff= [KNL]
 			Time to wait (s) after boot before inducing stall.
 
-	rcutorture.stat_interval= [KNL,BOOT]
+	rcutorture.stat_interval= [KNL]
 			Time (s) between statistics printk()s.
 
-	rcutorture.stutter= [KNL,BOOT]
+	rcutorture.stutter= [KNL]
 			Time (s) to stutter testing, for example, specifying
 			five seconds causes the test to run for five seconds,
 			wait for five seconds, and so on.  This tests RCU's
 			ability to transition abruptly to and from idle.
 
-	rcutorture.test_boost= [KNL,BOOT]
+	rcutorture.test_boost= [KNL]
 			Test RCU priority boosting?  0=no, 1=maybe, 2=yes.
 			"Maybe" means test if the RCU implementation
 			under test support RCU priority boosting.
 
-	rcutorture.test_boost_duration= [KNL,BOOT]
+	rcutorture.test_boost_duration= [KNL]
 			Duration (s) of each individual boost test.
 
-	rcutorture.test_boost_interval= [KNL,BOOT]
+	rcutorture.test_boost_interval= [KNL]
 			Interval (s) between each boost test.
 
-	rcutorture.test_no_idle_hz= [KNL,BOOT]
+	rcutorture.test_no_idle_hz= [KNL]
 			Test RCU's dyntick-idle handling.  See also the
 			rcutorture.shuffle_interval parameter.
 
-	rcutorture.torture_type= [KNL,BOOT]
+	rcutorture.torture_type= [KNL]
 			Specify the RCU implementation to test.
 
-	rcutorture.verbose= [KNL,BOOT]
+	rcutorture.verbose= [KNL]
 			Enable additional printk() statements.
 
+	rcupdate.rcu_expedited= [KNL]
+			Use expedited grace-period primitives, for
+			example, synchronize_rcu_expedited() instead
+			of synchronize_rcu().  This reduces latency,
+			but can increase CPU utilization, degrade
+			real-time latency, and degrade energy efficiency.
+
+	rcupdate.rcu_cpu_stall_suppress= [KNL]
+			Suppress RCU CPU stall warning messages.
+
+	rcupdate.rcu_cpu_stall_timeout= [KNL]
+			Set timeout for RCU CPU stall warning messages.
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 32351bf..827104f 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -181,12 +181,17 @@ To reduce its OS jitter, do any of the following:
 		make sure that this is safe on your particular system.
 	d.	It is not possible to entirely get rid of OS jitter
 		from vmstat_update() on CONFIG_SMP=y systems, but you
-		can decrease its frequency by writing a large value to
-		/proc/sys/vm/stat_interval.  The default value is HZ,
-		for an interval of one second.  Of course, larger values
-		will make your virtual-memory statistics update more
-		slowly.  Of course, you can also run your workload at
-		a real-time priority, thus preempting vmstat_update().
+		can decrease its frequency by writing a large value
+		to /proc/sys/vm/stat_interval.	The default value is
+		HZ, for an interval of one second.  Of course, larger
+		values will make your virtual-memory statistics update
+		more slowly.  Of course, you can also run your workload
+		at a real-time priority, thus preempting vmstat_update(),
+		but if your workload is CPU-bound, this is a bad idea.
+		However, there is an RFC patch from Christoph Lameter
+		(based on an earlier one from Gilad Ben-Yossef) that
+		reduces or even eliminates vmstat overhead for some
+		workloads at https://lkml.org/lkml/2013/9/4/379.
 	e.	If running on high-end powerpc servers, build with
 		CONFIG_PPC_RTAS_DAEMON=n.  This prevents the RTAS
 		daemon from running on each CPU every second or so.
diff --git a/MAINTAINERS b/MAINTAINERS
index a7c34ef..a97694d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6935,7 +6935,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
-F:	kernel/rcutorture.c
+F:	kernel/rcu/torture.c
 
 RDC R-321X SoC
 M:	Florian Fainelli <florian@openwrt.org>
@@ -6962,8 +6962,9 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/
 X:	Documentation/RCU/torture.txt
 F:	include/linux/rcu*
-F:	kernel/rcu*
-X:	kernel/rcutorture.c
+X:	include/linux/srcu.h
+F:	kernel/rcu/
+X:	kernel/rcu/torture.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
@@ -7650,8 +7651,8 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
-F:	include/linux/srcu*
-F:	kernel/srcu*
+F:	include/linux/srcu.h
+F:	kernel/rcu/srcu.c
 
 SMACK SECURITY MODULE
 M:	Casey Schaufler <casey@schaufler-ca.com>
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 4106721..45a0a9e 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -19,6 +19,21 @@
  */
 
 /*
+ * INIT_LIST_HEAD_RCU - Initialize a list_head visible to RCU readers
+ * @list: list to be initialized
+ *
+ * You should instead use INIT_LIST_HEAD() for normal initialization and
+ * cleanup tasks, when readers have no access to the list being initialized.
+ * However, if the list being initialized is visible to readers, you
+ * need to keep the compiler from being too mischievous.
+ */
+static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
+{
+	ACCESS_ONCE(list->next) = list;
+	ACCESS_ONCE(list->prev) = list;
+}
+
+/*
  * return the ->next pointer of a list_head in an rcu safe
  * way, we must not access it directly
  */
@@ -191,9 +206,13 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	if (list_empty(list))
 		return;
 
-	/* "first" and "last" tracking list, so initialize it. */
+	/*
+	 * "first" and "last" tracking list, so initialize it.  RCU readers
+	 * have access to this list, so we must use INIT_LIST_HEAD_RCU()
+	 * instead of INIT_LIST_HEAD().
+	 */
 
-	INIT_LIST_HEAD(list);
+	INIT_LIST_HEAD_RCU(list);
 
 	/*
 	 * At this point, the list body still points to the source list.
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index f1f1bc3..39cbb88 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -261,6 +261,10 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 		rcu_irq_exit(); \
 	} while (0)
 
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
+extern bool __rcu_is_watching(void);
+#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
+
 /*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
@@ -297,10 +301,6 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
-#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP)
-extern int rcu_is_cpu_idle(void);
-#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP) */
-
 #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
 bool rcu_lockdep_current_cpu_online(void);
 #else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
@@ -351,7 +351,7 @@ static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	if (rcu_is_cpu_idle())
+	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
@@ -402,7 +402,7 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	if (rcu_is_cpu_idle())
+	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
@@ -771,7 +771,7 @@ static inline void rcu_read_lock(void)
 	__rcu_read_lock();
 	__acquire(RCU);
 	rcu_lock_acquire(&rcu_lock_map);
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_lock() used illegally while idle");
 }
 
@@ -792,7 +792,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_unlock() used illegally while idle");
 	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
@@ -821,7 +821,7 @@ static inline void rcu_read_lock_bh(void)
 	local_bh_disable();
 	__acquire(RCU_BH);
 	rcu_lock_acquire(&rcu_bh_lock_map);
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_lock_bh() used illegally while idle");
 }
 
@@ -832,7 +832,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_unlock_bh() used illegally while idle");
 	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
@@ -857,7 +857,7 @@ static inline void rcu_read_lock_sched(void)
 	preempt_disable();
 	__acquire(RCU_SCHED);
 	rcu_lock_acquire(&rcu_sched_lock_map);
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_lock_sched() used illegally while idle");
 }
 
@@ -875,7 +875,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_lockdep_assert(!rcu_is_cpu_idle(),
+	rcu_lockdep_assert(rcu_is_watching(),
 			   "rcu_read_unlock_sched() used illegally while idle");
 	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e31005e..09ebcbe 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -132,4 +132,21 @@ static inline void rcu_scheduler_starting(void)
 }
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE)
+
+static inline bool rcu_is_watching(void)
+{
+	return __rcu_is_watching();
+}
+
+#else /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
+
+static inline bool rcu_is_watching(void)
+{
+	return true;
+}
+
+
+#endif /* #else defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
+
 #endif /* __LINUX_RCUTINY_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 226169d..4b9c815 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -90,4 +90,6 @@ extern void exit_rcu(void);
 extern void rcu_scheduler_starting(void);
 extern int rcu_scheduler_active __read_mostly;
 
+extern bool rcu_is_watching(void);
+
 #endif /* __LINUX_RCUTREE_H */
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index ee2376c..aca3822 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -39,15 +39,26 @@ TRACE_EVENT(rcu_utilization,
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 
 /*
- * Tracepoint for grace-period events: starting and ending a grace
- * period ("start" and "end", respectively), a CPU noting the start
- * of a new grace period or the end of an old grace period ("cpustart"
- * and "cpuend", respectively), a CPU passing through a quiescent
- * state ("cpuqs"), a CPU coming online or going offline ("cpuonl"
- * and "cpuofl", respectively), a CPU being kicked for being too
- * long in dyntick-idle mode ("kick"), a CPU accelerating its new
- * callbacks to RCU_NEXT_READY_TAIL ("AccReadyCB"), and a CPU
- * accelerating its new callbacks to RCU_WAIT_TAIL ("AccWaitCB").
+ * Tracepoint for grace-period events.  Takes a string identifying the
+ * RCU flavor, the grace-period number, and a string identifying the
+ * grace-period-related event as follows:
+ *
+ *	"AccReadyCB": CPU acclerates new callbacks to RCU_NEXT_READY_TAIL.
+ *	"AccWaitCB": CPU accelerates new callbacks to RCU_WAIT_TAIL.
+ *	"newreq": Request a new grace period.
+ *	"start": Start a grace period.
+ *	"cpustart": CPU first notices a grace-period start.
+ *	"cpuqs": CPU passes through a quiescent state.
+ *	"cpuonl": CPU comes online.
+ *	"cpuofl": CPU goes offline.
+ *	"reqwait": GP kthread sleeps waiting for grace-period request.
+ *	"reqwaitsig": GP kthread awakened by signal from reqwait state.
+ *	"fqswait": GP kthread waiting until time to force quiescent states.
+ *	"fqsstart": GP kthread starts forcing quiescent states.
+ *	"fqsend": GP kthread done forcing quiescent states.
+ *	"fqswaitsig": GP kthread awakened by signal from fqswait state.
+ *	"end": End a grace period.
+ *	"cpuend": CPU first notices a grace-period end.
  */
 TRACE_EVENT(rcu_grace_period,
 
@@ -161,6 +172,46 @@ TRACE_EVENT(rcu_grace_period_init,
 );
 
 /*
+ * Tracepoint for RCU no-CBs CPU callback handoffs.  This event is intended
+ * to assist debugging of these handoffs.
+ *
+ * The first argument is the name of the RCU flavor, and the second is
+ * the number of the offloaded CPU are extracted.  The third and final
+ * argument is a string as follows:
+ *
+ *	"WakeEmpty": Wake rcuo kthread, first CB to empty list.
+ *	"WakeOvf": Wake rcuo kthread, CB list is huge.
+ *	"WakeNot": Don't wake rcuo kthread.
+ *	"WakeNotPoll": Don't wake rcuo kthread because it is polling.
+ *	"Poll": Start of new polling cycle for rcu_nocb_poll.
+ *	"Sleep": Sleep waiting for CBs for !rcu_nocb_poll.
+ *	"WokeEmpty": rcuo kthread woke to find empty list.
+ *	"WokeNonEmpty": rcuo kthread woke to find non-empty list.
+ *	"WaitQueue": Enqueue partially done, timed wait for it to complete.
+ *	"WokeQueue": Partial enqueue now complete.
+ */
+TRACE_EVENT(rcu_nocb_wake,
+
+	TP_PROTO(const char *rcuname, int cpu, const char *reason),
+
+	TP_ARGS(rcuname, cpu, reason),
+
+	TP_STRUCT__entry(
+		__field(const char *, rcuname)
+		__field(int, cpu)
+		__field(const char *, reason)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->cpu = cpu;
+		__entry->reason = reason;
+	),
+
+	TP_printk("%s %d %s", __entry->rcuname, __entry->cpu, __entry->reason)
+);
+
+/*
  * Tracepoint for tasks blocking within preemptible-RCU read-side
  * critical sections.  Track the type of RCU (which one day might
  * include SRCU), the grace-period number that the task is blocking
@@ -540,17 +591,17 @@ TRACE_EVENT(rcu_invoke_kfree_callback,
 TRACE_EVENT(rcu_batch_end,
 
 	TP_PROTO(const char *rcuname, int callbacks_invoked,
-		 bool cb, bool nr, bool iit, bool risk),
+		 char cb, char nr, char iit, char risk),
 
 	TP_ARGS(rcuname, callbacks_invoked, cb, nr, iit, risk),
 
 	TP_STRUCT__entry(
 		__field(const char *, rcuname)
 		__field(int, callbacks_invoked)
-		__field(bool, cb)
-		__field(bool, nr)
-		__field(bool, iit)
-		__field(bool, risk)
+		__field(char, cb)
+		__field(char, nr)
+		__field(char, iit)
+		__field(char, risk)
 	),
 
 	TP_fast_assign(
@@ -656,6 +707,7 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_future_grace_period(rcuname, gpnum, completed, c, \
 				      level, grplo, grphi, event) \
 				      do { } while (0)
+#define trace_rcu_nocb_wake(rcuname, cpu, reason) do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..f99d908 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -6,9 +6,9 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
-	    rcupdate.o extable.o params.o posix-timers.o \
+	    extable.o params.o posix-timers.o \
 	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
+	    hrtimer.o rwsem.o nsproxy.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
 
@@ -27,6 +27,7 @@ obj-y += power/
 obj-y += printk/
 obj-y += cpu/
 obj-y += irq/
+obj-y += rcu/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
@@ -81,12 +82,6 @@ obj-$(CONFIG_KGDB) += debug/
 obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
 obj-$(CONFIG_SECCOMP) += seccomp.o
-obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
-obj-$(CONFIG_TREE_RCU) += rcutree.o
-obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
-obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
-obj-$(CONFIG_TINY_RCU) += rcutiny.o
-obj-$(CONFIG_TINY_PREEMPT_RCU) += rcutiny.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e16c45b..4e8e14c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4224,7 +4224,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
 	       !rcu_lockdep_current_cpu_online()
 			? "RCU used illegally from offline CPU!\n"
-			: rcu_is_cpu_idle()
+			: !rcu_is_watching()
 				? "RCU used illegally from idle CPU!\n"
 				: "",
 	       rcu_scheduler_active, debug_locks);
@@ -4247,7 +4247,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	 * So complain bitterly if someone does call rcu_read_lock(),
 	 * rcu_read_lock_bh() and so on from extended quiescent states.
 	 */
-	if (rcu_is_cpu_idle())
+	if (!rcu_is_watching())
 		printk("RCU used illegally from extended quiescent state!\n");
 
 	lockdep_print_held_locks(curr);
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
new file mode 100644
index 0000000..01e9ec3
--- /dev/null
+++ b/kernel/rcu/Makefile
@@ -0,0 +1,6 @@
+obj-y += update.o srcu.o
+obj-$(CONFIG_RCU_TORTURE_TEST) += torture.o
+obj-$(CONFIG_TREE_RCU) += tree.o
+obj-$(CONFIG_TREE_PREEMPT_RCU) += tree.o
+obj-$(CONFIG_TREE_RCU_TRACE) += tree_trace.o
+obj-$(CONFIG_TINY_RCU) += tiny.o
diff --git a/kernel/rcu.h b/kernel/rcu/rcu.h
similarity index 94%
rename from kernel/rcu.h
rename to kernel/rcu/rcu.h
index 7713196..7859a0a 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -122,4 +122,11 @@ int rcu_jiffies_till_stall_check(void);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
 
+/*
+ * Strings used in tracepoints need to be exported via the
+ * tracing system such that tools like perf and trace-cmd can
+ * translate the string address pointers to actual text.
+ */
+#define TPS(x)  tracepoint_string(x)
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/srcu.c b/kernel/rcu/srcu.c
similarity index 100%
rename from kernel/srcu.c
rename to kernel/rcu/srcu.c
diff --git a/kernel/rcutiny.c b/kernel/rcu/tiny.c
similarity index 90%
rename from kernel/rcutiny.c
rename to kernel/rcu/tiny.c
index 9ed6075..0c9a934 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcu/tiny.c
@@ -35,6 +35,7 @@
 #include <linux/time.h>
 #include <linux/cpu.h>
 #include <linux/prefetch.h>
+#include <linux/ftrace_event.h>
 
 #ifdef CONFIG_RCU_TRACE
 #include <trace/events/rcu.h>
@@ -42,7 +43,7 @@
 
 #include "rcu.h"
 
-/* Forward declarations for rcutiny_plugin.h. */
+/* Forward declarations for tiny_plugin.h. */
 struct rcu_ctrlblk;
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
 static void rcu_process_callbacks(struct softirq_action *unused);
@@ -52,22 +53,23 @@ static void __call_rcu(struct rcu_head *head,
 
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
-#include "rcutiny_plugin.h"
+#include "tiny_plugin.h"
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
 	if (newval) {
-		RCU_TRACE(trace_rcu_dyntick("--=",
+		RCU_TRACE(trace_rcu_dyntick(TPS("--="),
 					    rcu_dynticks_nesting, newval));
 		rcu_dynticks_nesting = newval;
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
+	RCU_TRACE(trace_rcu_dyntick(TPS("Start"),
+				    rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
-		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
+		RCU_TRACE(trace_rcu_dyntick(TPS("Entry error: not idle task"),
 					    rcu_dynticks_nesting, newval));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
@@ -120,15 +122,15 @@ EXPORT_SYMBOL_GPL(rcu_irq_exit);
 static void rcu_idle_exit_common(long long oldval)
 {
 	if (oldval) {
-		RCU_TRACE(trace_rcu_dyntick("++=",
+		RCU_TRACE(trace_rcu_dyntick(TPS("++="),
 					    oldval, rcu_dynticks_nesting));
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick(TPS("End"), oldval, rcu_dynticks_nesting));
 	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
-		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
+		RCU_TRACE(trace_rcu_dyntick(TPS("Exit error: not idle task"),
 			  oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
@@ -174,18 +176,18 @@ void rcu_irq_enter(void)
 }
 EXPORT_SYMBOL_GPL(rcu_irq_enter);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE)
 
 /*
  * Test whether RCU thinks that the current CPU is idle.
  */
-int rcu_is_cpu_idle(void)
+bool __rcu_is_watching(void)
 {
-	return !rcu_dynticks_nesting;
+	return rcu_dynticks_nesting;
 }
-EXPORT_SYMBOL(rcu_is_cpu_idle);
+EXPORT_SYMBOL(__rcu_is_watching);
 
-#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+#endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
 /*
  * Test whether the current CPU was interrupted from idle.  Nested
@@ -273,7 +275,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	if (&rcp->rcucblist == rcp->donetail) {
 		RCU_TRACE(trace_rcu_batch_start(rcp->name, 0, 0, -1));
 		RCU_TRACE(trace_rcu_batch_end(rcp->name, 0,
-					      ACCESS_ONCE(rcp->rcucblist),
+					      !!ACCESS_ONCE(rcp->rcucblist),
 					      need_resched(),
 					      is_idle_task(current),
 					      false));
@@ -304,7 +306,8 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
-	RCU_TRACE(trace_rcu_batch_end(rcp->name, cb_count, 0, need_resched(),
+	RCU_TRACE(trace_rcu_batch_end(rcp->name,
+				      cb_count, 0, need_resched(),
 				      is_idle_task(current),
 				      false));
 }
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcu/tiny_plugin.h
similarity index 100%
rename from kernel/rcutiny_plugin.h
rename to kernel/rcu/tiny_plugin.h
diff --git a/kernel/rcutorture.c b/kernel/rcu/torture.c
similarity index 99%
rename from kernel/rcutorture.c
rename to kernel/rcu/torture.c
index be63101..3929cd4 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcu/torture.c
@@ -52,6 +52,12 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
 
+MODULE_ALIAS("rcutorture");
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "rcutorture."
+
 static int fqs_duration;
 module_param(fqs_duration, int, 0444);
 MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us), 0 to disable");
diff --git a/kernel/rcutree.c b/kernel/rcu/tree.c
similarity index 95%
rename from kernel/rcutree.c
rename to kernel/rcu/tree.c
index 32618b3..8a2c81e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcu/tree.c
@@ -41,6 +41,7 @@
 #include <linux/export.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
@@ -56,17 +57,16 @@
 #include <linux/ftrace_event.h>
 #include <linux/suspend.h>
 
-#include "rcutree.h"
+#include "tree.h"
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
 
-/*
- * Strings used in tracepoints need to be exported via the
- * tracing system such that tools like perf and trace-cmd can
- * translate the string address pointers to actual text.
- */
-#define TPS(x)	tracepoint_string(x)
+MODULE_ALIAS("rcutree");
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "rcutree."
 
 /* Data structures. */
 
@@ -222,7 +222,7 @@ void rcu_note_context_switch(int cpu)
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
-DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
+static DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
@@ -371,7 +371,8 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 {
 	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused =
+			idle_task(smp_processor_id());
 
 		trace_rcu_dyntick(TPS("Error on entry: not idle task"), oldval, 0);
 		ftrace_dump(DUMP_ORIG);
@@ -407,7 +408,7 @@ static void rcu_eqs_enter(bool user)
 	long long oldval;
 	struct rcu_dynticks *rdtp;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
@@ -435,7 +436,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
-	rcu_sysidle_enter(&__get_cpu_var(rcu_dynticks), 0);
+	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -478,7 +479,7 @@ void rcu_irq_exit(void)
 	struct rcu_dynticks *rdtp;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting--;
 	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
@@ -508,7 +509,8 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused =
+			idle_task(smp_processor_id());
 
 		trace_rcu_dyntick(TPS("Error on exit: not idle task"),
 				  oldval, rdtp->dynticks_nesting);
@@ -528,7 +530,7 @@ static void rcu_eqs_exit(bool user)
 	struct rcu_dynticks *rdtp;
 	long long oldval;
 
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	WARN_ON_ONCE(oldval < 0);
 	if (oldval & DYNTICK_TASK_NEST_MASK)
@@ -555,7 +557,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
-	rcu_sysidle_exit(&__get_cpu_var(rcu_dynticks), 0);
+	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -599,7 +601,7 @@ void rcu_irq_enter(void)
 	long long oldval;
 
 	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp = this_cpu_ptr(&rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
 	rdtp->dynticks_nesting++;
 	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
@@ -620,7 +622,7 @@ void rcu_irq_enter(void)
  */
 void rcu_nmi_enter(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 &&
 	    (atomic_read(&rdtp->dynticks) & 0x1))
@@ -642,7 +644,7 @@ void rcu_nmi_enter(void)
  */
 void rcu_nmi_exit(void)
 {
-	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	if (rdtp->dynticks_nmi_nesting == 0 ||
 	    --rdtp->dynticks_nmi_nesting != 0)
@@ -655,21 +657,34 @@ void rcu_nmi_exit(void)
 }
 
 /**
- * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
+ * __rcu_is_watching - are RCU read-side critical sections safe?
+ *
+ * Return true if RCU is watching the running CPU, which means that
+ * this CPU can safely enter RCU read-side critical sections.  Unlike
+ * rcu_is_watching(), the caller of __rcu_is_watching() must have at
+ * least disabled preemption.
+ */
+bool __rcu_is_watching(void)
+{
+	return atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
+}
+
+/**
+ * rcu_is_watching - see if RCU thinks that the current CPU is idle
  *
  * If the current CPU is in its idle loop and is neither in an interrupt
  * or NMI handler, return true.
  */
-int rcu_is_cpu_idle(void)
+bool rcu_is_watching(void)
 {
 	int ret;
 
 	preempt_disable();
-	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
+	ret = __rcu_is_watching();
 	preempt_enable();
 	return ret;
 }
-EXPORT_SYMBOL(rcu_is_cpu_idle);
+EXPORT_SYMBOL_GPL(rcu_is_watching);
 
 #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
 
@@ -703,7 +718,7 @@ bool rcu_lockdep_current_cpu_online(void)
 	if (in_nmi())
 		return 1;
 	preempt_disable();
-	rdp = &__get_cpu_var(rcu_sched_data);
+	rdp = this_cpu_ptr(&rcu_sched_data);
 	rnp = rdp->mynode;
 	ret = (rdp->grpmask & rnp->qsmaskinit) ||
 	      !rcu_scheduler_fully_active;
@@ -723,7 +738,7 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
  */
 static int rcu_is_cpu_rrupt_from_idle(void)
 {
-	return __get_cpu_var(rcu_dynticks).dynticks_nesting <= 1;
+	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
 }
 
 /*
@@ -802,8 +817,11 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
-	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+	unsigned long j = ACCESS_ONCE(jiffies);
+
+	rsp->gp_start = j;
+	smp_wmb(); /* Record start time before stall time. */
+	rsp->jiffies_stall = j + rcu_jiffies_till_stall_check();
 }
 
 /*
@@ -932,17 +950,48 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
+	unsigned long completed;
+	unsigned long gpnum;
+	unsigned long gps;
 	unsigned long j;
 	unsigned long js;
 	struct rcu_node *rnp;
 
-	if (rcu_cpu_stall_suppress)
+	if (rcu_cpu_stall_suppress || !rcu_gp_in_progress(rsp))
 		return;
 	j = ACCESS_ONCE(jiffies);
+
+	/*
+	 * Lots of memory barriers to reject false positives.
+	 *
+	 * The idea is to pick up rsp->gpnum, then rsp->jiffies_stall,
+	 * then rsp->gp_start, and finally rsp->completed.  These values
+	 * are updated in the opposite order with memory barriers (or
+	 * equivalent) during grace-period initialization and cleanup.
+	 * Now, a false positive can occur if we get an new value of
+	 * rsp->gp_start and a old value of rsp->jiffies_stall.  But given
+	 * the memory barriers, the only way that this can happen is if one
+	 * grace period ends and another starts between these two fetches.
+	 * Detect this by comparing rsp->completed with the previous fetch
+	 * from rsp->gpnum.
+	 *
+	 * Given this check, comparisons of jiffies, rsp->jiffies_stall,
+	 * and rsp->gp_start suffice to forestall false positives.
+	 */
+	gpnum = ACCESS_ONCE(rsp->gpnum);
+	smp_rmb(); /* Pick up ->gpnum first... */
 	js = ACCESS_ONCE(rsp->jiffies_stall);
+	smp_rmb(); /* ...then ->jiffies_stall before the rest... */
+	gps = ACCESS_ONCE(rsp->gp_start);
+	smp_rmb(); /* ...and finally ->gp_start before ->completed. */
+	completed = ACCESS_ONCE(rsp->completed);
+	if (ULONG_CMP_GE(completed, gpnum) ||
+	    ULONG_CMP_LT(j, js) ||
+	    ULONG_CMP_GE(gps, js))
+		return; /* No stall or GP completed since entering function. */
 	rnp = rdp->mynode;
 	if (rcu_gp_in_progress(rsp) &&
-	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
+	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
@@ -1297,7 +1346,7 @@ static void note_gp_changes(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
- * Initialize a new grace period.
+ * Initialize a new grace period.  Return 0 if no grace period required.
  */
 static int rcu_gp_init(struct rcu_state *rsp)
 {
@@ -1306,18 +1355,27 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
+	if (rsp->gp_flags == 0) {
+		/* Spurious wakeup, tell caller to go back to sleep.  */
+		raw_spin_unlock_irq(&rnp->lock);
+		return 0;
+	}
 	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
-	if (rcu_gp_in_progress(rsp)) {
-		/* Grace period already in progress, don't start another.  */
+	if (WARN_ON_ONCE(rcu_gp_in_progress(rsp))) {
+		/*
+		 * Grace period already in progress, don't start another.
+		 * Not supposed to be able to happen.
+		 */
 		raw_spin_unlock_irq(&rnp->lock);
 		return 0;
 	}
 
 	/* Advance to a new grace period and initialize state. */
+	record_gp_stall_check_time(rsp);
+	smp_wmb(); /* Record GP times before starting GP. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
-	record_gp_stall_check_time(rsp);
 	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */
@@ -1366,7 +1424,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 /*
  * Do one round of quiescent-state forcing.
  */
-int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
+static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 {
 	int fqs_state = fqs_state_in;
 	bool isidle = false;
@@ -1451,8 +1509,12 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
 	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
-	if (cpu_needs_another_gp(rsp, rdp))
-		rsp->gp_flags = 1;
+	if (cpu_needs_another_gp(rsp, rdp)) {
+		rsp->gp_flags = RCU_GP_FLAG_INIT;
+		trace_rcu_grace_period(rsp->name,
+				       ACCESS_ONCE(rsp->gpnum),
+				       TPS("newreq"));
+	}
 	raw_spin_unlock_irq(&rnp->lock);
 }
 
@@ -1462,6 +1524,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 static int __noreturn rcu_gp_kthread(void *arg)
 {
 	int fqs_state;
+	int gf;
 	unsigned long j;
 	int ret;
 	struct rcu_state *rsp = arg;
@@ -1471,14 +1534,19 @@ static int __noreturn rcu_gp_kthread(void *arg)
 
 		/* Handle grace-period start. */
 		for (;;) {
+			trace_rcu_grace_period(rsp->name,
+					       ACCESS_ONCE(rsp->gpnum),
+					       TPS("reqwait"));
 			wait_event_interruptible(rsp->gp_wq,
-						 rsp->gp_flags &
+						 ACCESS_ONCE(rsp->gp_flags) &
 						 RCU_GP_FLAG_INIT);
-			if ((rsp->gp_flags & RCU_GP_FLAG_INIT) &&
-			    rcu_gp_init(rsp))
+			if (rcu_gp_init(rsp))
 				break;
 			cond_resched();
 			flush_signals(current);
+			trace_rcu_grace_period(rsp->name,
+					       ACCESS_ONCE(rsp->gpnum),
+					       TPS("reqwaitsig"));
 		}
 
 		/* Handle quiescent-state forcing. */
@@ -1488,10 +1556,16 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			j = HZ;
 			jiffies_till_first_fqs = HZ;
 		}
+		ret = 0;
 		for (;;) {
-			rsp->jiffies_force_qs = jiffies + j;
+			if (!ret)
+				rsp->jiffies_force_qs = jiffies + j;
+			trace_rcu_grace_period(rsp->name,
+					       ACCESS_ONCE(rsp->gpnum),
+					       TPS("fqswait"));
 			ret = wait_event_interruptible_timeout(rsp->gp_wq,
-					(rsp->gp_flags & RCU_GP_FLAG_FQS) ||
+					((gf = ACCESS_ONCE(rsp->gp_flags)) &
+					 RCU_GP_FLAG_FQS) ||
 					(!ACCESS_ONCE(rnp->qsmask) &&
 					 !rcu_preempt_blocked_readers_cgp(rnp)),
 					j);
@@ -1500,13 +1574,23 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			    !rcu_preempt_blocked_readers_cgp(rnp))
 				break;
 			/* If time for quiescent-state forcing, do it. */
-			if (ret == 0 || (rsp->gp_flags & RCU_GP_FLAG_FQS)) {
+			if (ULONG_CMP_GE(jiffies, rsp->jiffies_force_qs) ||
+			    (gf & RCU_GP_FLAG_FQS)) {
+				trace_rcu_grace_period(rsp->name,
+						       ACCESS_ONCE(rsp->gpnum),
+						       TPS("fqsstart"));
 				fqs_state = rcu_gp_fqs(rsp, fqs_state);
+				trace_rcu_grace_period(rsp->name,
+						       ACCESS_ONCE(rsp->gpnum),
+						       TPS("fqsend"));
 				cond_resched();
 			} else {
 				/* Deal with stray signal. */
 				cond_resched();
 				flush_signals(current);
+				trace_rcu_grace_period(rsp->name,
+						       ACCESS_ONCE(rsp->gpnum),
+						       TPS("fqswaitsig"));
 			}
 			j = jiffies_till_next_fqs;
 			if (j > HZ) {
@@ -1554,6 +1638,8 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 		return;
 	}
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
+	trace_rcu_grace_period(rsp->name, ACCESS_ONCE(rsp->gpnum),
+			       TPS("newreq"));
 
 	/*
 	 * We can't do wakeups while holding the rnp->lock, as that
@@ -2255,7 +2341,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 	 * If called from an extended quiescent state, invoke the RCU
 	 * core in order to force a re-evaluation of RCU's idleness.
 	 */
-	if (rcu_is_cpu_idle() && cpu_online(smp_processor_id()))
+	if (!rcu_is_watching() && cpu_online(smp_processor_id()))
 		invoke_rcu_core();
 
 	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
@@ -2725,10 +2811,13 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 
 	for_each_rcu_flavor(rsp) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (rdp->qlen != rdp->qlen_lazy)
+		if (!rdp->nxtlist)
+			continue;
+		hc = true;
+		if (rdp->qlen != rdp->qlen_lazy || !all_lazy) {
 			al = false;
-		if (rdp->nxtlist)
-			hc = true;
+			break;
+		}
 	}
 	if (all_lazy)
 		*all_lazy = al;
@@ -3216,7 +3305,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 /*
  * Compute the rcu_node tree geometry from kernel parameters.  This cannot
- * replace the definitions in rcutree.h because those are needed to size
+ * replace the definitions in tree.h because those are needed to size
  * the ->node array in the rcu_state structure.
  */
 static void __init rcu_init_geometry(void)
@@ -3295,8 +3384,8 @@ void __init rcu_init(void)
 
 	rcu_bootup_announce();
 	rcu_init_geometry();
-	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
+	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
@@ -3311,4 +3400,4 @@ void __init rcu_init(void)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
 
-#include "rcutree_plugin.h"
+#include "tree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcu/tree.h
similarity index 99%
rename from kernel/rcutree.h
rename to kernel/rcu/tree.h
index 5f97eab..52be957 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcu/tree.h
@@ -104,6 +104,8 @@ struct rcu_dynticks {
 				    /* idle-period nonlazy_posted snapshot. */
 	unsigned long last_accelerate;
 				    /* Last jiffy CBs were accelerated. */
+	unsigned long last_advance_all;
+				    /* Last jiffy CBs were all advanced. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 };
diff --git a/kernel/rcutree_plugin.h b/kernel/rcu/tree_plugin.h
similarity index 97%
rename from kernel/rcutree_plugin.h
rename to kernel/rcu/tree_plugin.h
index 130c97b..3822ac0 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -28,7 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
-#include "time/tick-internal.h"
+#include "../time/tick-internal.h"
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -96,10 +96,15 @@ static void __init rcu_bootup_announce_oddness(void)
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
 #ifdef CONFIG_RCU_NOCB_CPU_ALL
 	pr_info("\tOffload RCU callbacks from all CPUs\n");
-	cpumask_setall(rcu_nocb_mask);
+	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
 	if (have_rcu_nocb_mask) {
+		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
+			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
+			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
+				    rcu_nocb_mask);
+		}
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
@@ -660,7 +665,7 @@ static void rcu_preempt_check_callbacks(int cpu)
 
 static void rcu_preempt_do_callbacks(void)
 {
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
+	rcu_do_batch(&rcu_preempt_state, this_cpu_ptr(&rcu_preempt_data));
 }
 
 #endif /* #ifdef CONFIG_RCU_BOOST */
@@ -1128,7 +1133,7 @@ void exit_rcu(void)
 
 #ifdef CONFIG_RCU_BOOST
 
-#include "rtmutex_common.h"
+#include "../rtmutex_common.h"
 
 #ifdef CONFIG_RCU_TRACE
 
@@ -1332,7 +1337,7 @@ static void invoke_rcu_callbacks_kthread(void)
  */
 static bool rcu_is_callbacks_kthread(void)
 {
-	return __get_cpu_var(rcu_cpu_kthread_task) == current;
+	return __this_cpu_read(rcu_cpu_kthread_task) == current;
 }
 
 #define RCU_BOOST_DELAY_JIFFIES DIV_ROUND_UP(CONFIG_RCU_BOOST_DELAY * HZ, 1000)
@@ -1382,8 +1387,8 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 
 static void rcu_kthread_do_work(void)
 {
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_do_batch(&rcu_sched_state, this_cpu_ptr(&rcu_sched_data));
+	rcu_do_batch(&rcu_bh_state, this_cpu_ptr(&rcu_bh_data));
 	rcu_preempt_do_callbacks();
 }
 
@@ -1402,7 +1407,7 @@ static void rcu_cpu_kthread_park(unsigned int cpu)
 
 static int rcu_cpu_kthread_should_run(unsigned int cpu)
 {
-	return __get_cpu_var(rcu_cpu_has_work);
+	return __this_cpu_read(rcu_cpu_has_work);
 }
 
 /*
@@ -1412,8 +1417,8 @@ static int rcu_cpu_kthread_should_run(unsigned int cpu)
  */
 static void rcu_cpu_kthread(unsigned int cpu)
 {
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	unsigned int *statusp = this_cpu_ptr(&rcu_cpu_kthread_status);
+	char work, *workp = this_cpu_ptr(&rcu_cpu_has_work);
 	int spincnt;
 
 	for (spincnt = 0; spincnt < 10; spincnt++) {
@@ -1630,17 +1635,23 @@ module_param(rcu_idle_lazy_gp_delay, int, 0644);
 extern int tick_nohz_enabled;
 
 /*
- * Try to advance callbacks for all flavors of RCU on the current CPU.
- * Afterwards, if there are any callbacks ready for immediate invocation,
- * return true.
+ * Try to advance callbacks for all flavors of RCU on the current CPU, but
+ * only if it has been awhile since the last time we did so.  Afterwards,
+ * if there are any callbacks ready for immediate invocation, return true.
  */
 static bool rcu_try_advance_all_cbs(void)
 {
 	bool cbs_ready = false;
 	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
 
+	/* Exit early if we advanced recently. */
+	if (jiffies == rdtp->last_advance_all)
+		return 0;
+	rdtp->last_advance_all = jiffies;
+
 	for_each_rcu_flavor(rsp) {
 		rdp = this_cpu_ptr(rsp->rda);
 		rnp = rdp->mynode;
@@ -1739,6 +1750,8 @@ static void rcu_prepare_for_idle(int cpu)
 	 */
 	if (rdtp->all_lazy &&
 	    rdtp->nonlazy_posted != rdtp->nonlazy_posted_snap) {
+		rdtp->all_lazy = false;
+		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 		invoke_rcu_core();
 		return;
 	}
@@ -1768,17 +1781,11 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	struct rcu_data *rdp;
-	struct rcu_state *rsp;
 
 	if (rcu_is_nocb_cpu(cpu))
 		return;
-	rcu_try_advance_all_cbs();
-	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (cpu_has_callbacks_ready_to_invoke(rdp))
-			invoke_rcu_core();
-	}
+	if (rcu_try_advance_all_cbs())
+		invoke_rcu_core();
 }
 
 /*
@@ -2108,15 +2115,22 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 
 	/* If we are not being polled and there is a kthread, awaken it ... */
 	t = ACCESS_ONCE(rdp->nocb_kthread);
-	if (rcu_nocb_poll | !t)
+	if (rcu_nocb_poll || !t) {
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+				    TPS("WakeNotPoll"));
 		return;
+	}
 	len = atomic_long_read(&rdp->nocb_q_count);
 	if (old_rhpp == &rdp->nocb_head) {
 		wake_up(&rdp->nocb_wq); /* ... only if queue was empty ... */
 		rdp->qlen_last_fqs_check = 0;
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeEmpty"));
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
 		wake_up_process(t); /* ... or if many callbacks queued. */
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
+	} else {
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeNot"));
 	}
 	return;
 }
@@ -2140,10 +2154,12 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
 		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
 					 (unsigned long)rhp->func,
-					 rdp->qlen_lazy, rdp->qlen);
+					 -atomic_long_read(&rdp->nocb_q_count_lazy),
+					 -atomic_long_read(&rdp->nocb_q_count));
 	else
 		trace_rcu_callback(rdp->rsp->name, rhp,
-				   rdp->qlen_lazy, rdp->qlen);
+				   -atomic_long_read(&rdp->nocb_q_count_lazy),
+				   -atomic_long_read(&rdp->nocb_q_count));
 	return 1;
 }
 
@@ -2221,6 +2237,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 static int rcu_nocb_kthread(void *arg)
 {
 	int c, cl;
+	bool firsttime = 1;
 	struct rcu_head *list;
 	struct rcu_head *next;
 	struct rcu_head **tail;
@@ -2229,14 +2246,27 @@ static int rcu_nocb_kthread(void *arg)
 	/* Each pass through this loop invokes one batch of callbacks */
 	for (;;) {
 		/* If not polling, wait for next batch of callbacks. */
-		if (!rcu_nocb_poll)
+		if (!rcu_nocb_poll) {
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("Sleep"));
 			wait_event_interruptible(rdp->nocb_wq, rdp->nocb_head);
+		} else if (firsttime) {
+			firsttime = 0;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("Poll"));
+		}
 		list = ACCESS_ONCE(rdp->nocb_head);
 		if (!list) {
+			if (!rcu_nocb_poll)
+				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+						    TPS("WokeEmpty"));
 			schedule_timeout_interruptible(1);
 			flush_signals(current);
 			continue;
 		}
+		firsttime = 1;
+		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+				    TPS("WokeNonEmpty"));
 
 		/*
 		 * Extract queued callbacks, update counts, and wait
@@ -2257,7 +2287,11 @@ static int rcu_nocb_kthread(void *arg)
 			next = list->next;
 			/* Wait for enqueuing to complete, if needed. */
 			while (next == NULL && &list->next != tail) {
+				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+						    TPS("WaitQueue"));
 				schedule_timeout_interruptible(1);
+				trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+						    TPS("WokeQueue"));
 				next = list->next;
 			}
 			debug_rcu_head_unqueue(list);
diff --git a/kernel/rcutree_trace.c b/kernel/rcu/tree_trace.c
similarity index 99%
rename from kernel/rcutree_trace.c
rename to kernel/rcu/tree_trace.c
index cf6c174..3596797 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -44,7 +44,7 @@
 #include <linux/seq_file.h>
 
 #define RCU_TREE_NONCORE
-#include "rcutree.h"
+#include "tree.h"
 
 static int r_open(struct inode *inode, struct file *file,
 					const struct seq_operations *op)
diff --git a/kernel/rcupdate.c b/kernel/rcu/update.c
similarity index 97%
rename from kernel/rcupdate.c
rename to kernel/rcu/update.c
index b02a339..6cb3dff 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcu/update.c
@@ -53,6 +53,12 @@
 
 #include "rcu.h"
 
+MODULE_ALIAS("rcupdate");
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "rcupdate."
+
 module_param(rcu_expedited, int, 0);
 
 #ifdef CONFIG_PREEMPT_RCU
@@ -148,7 +154,7 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
-	if (rcu_is_cpu_idle())
+	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
@@ -298,7 +304,7 @@ EXPORT_SYMBOL_GPL(do_trace_rcu_torture_read);
 #endif
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
-int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
+static int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
 
 module_param(rcu_cpu_stall_suppress, int, 0644);
 module_param(rcu_cpu_stall_timeout, int, 0644);
