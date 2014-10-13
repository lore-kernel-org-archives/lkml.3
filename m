Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaJMFSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:18:41 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52548 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaJMFSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:18:36 -0400
Date: Mon, 13 Oct 2014 07:18:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.18
Message-ID: <20141013051830.GA7726@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   # HEAD: fd19bda491207f66d39aeba93487197a087bc00b Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The main changes in this cycle were:

  * Changes related to No-CBs CPUs and NO_HZ_FULL.

  * RCU-tasks implementation.

  * Torture-test updates.

  * Miscellaneous fixes.

  * Locktorture updates.

  * RCU documentation updates.

Note, you'll get a conflict in init/main.c, interacting with the 
earlier timers/nohz tree, which will look like this if you 
combine v3.17 + timers/nohz + core/rcu:

++<<<<<<< HEAD
+      tick_nohz_init();
+      rcu_init_nohz();
++=======
++>>>>>>> timers/nohz

The correct resolution is to remove this pair:

+      tick_nohz_init();
+      rcu_init_nohz();

and to apply the following change:

        early_irq_init();
        init_IRQ();
        tick_init();
++      rcu_init_nohz();
        init_timers();
        hrtimers_init();
        softirq_init();

That's necessary because tick_nohz_init() must be called after 
tick_init() and rcu_init_nohz() must be called after 
tick_nohz_init(). tick_nohz_init() is now called at the end of 
tick_init() so everything should be fine in the end.

Thanks,

	Ingo

------------------>
Ard Biesheuvel (1):
      rcu: Define tracepoint strings only if CONFIG_TRACING is set

Davidlohr Bueso (13):
      locktorture: Rename locktorture_runnable parameter
      locktorture: Add documentation
      locktorture: Support mutexes
      locktorture: Teach about lock debugging
      locktorture: Make statistics generic
      torture: Address race in module cleanup
      locktorture: Add infrastructure for torturing read locks
      locktorture: Support rwsems
      locktorture: Introduce torture context
      locktorture: Support rwlocks
      locktorture: Fix __acquire annotation for spinlock irq
      locktorture: Cannot hold read and write lock
      locktorture: Cleanup header usage

Joe Lawrence (2):
      workqueue: Add quiescent state between work items
      workqueue: Use cond_resched_rcu_qs macro

Joe Perches (1):
      rcu: Use pr_alert/pr_cont for printing logs

Oleg Nesterov (1):
      rcu: Uninline rcu_read_lock_held()

Paul E. McKenney (44):
      memory-barriers: Fix control-ordering no-transitivity example
      memory-barriers: Retain barrier() in fold-to-zero example
      memory-barriers: Fix description of 2-legged-if-based control dependencies
      rcu: Break more call_rcu() deadlock involving scheduler and perf
      rcu: Make TINY_RCU tinier by putting error checks under #ifdef
      rcu: Replace flush_signals() with WARN_ON(signal_pending())
      rcu: Add step to initrd documentation
      rcutorture: Test partial nohz_full= configuration
      rcutorture: Specify MAXSMP=y for TREE01
      rcutorture: Specify CONFIG_CPUMASK_OFFSTACK=y for TREE07
      rcutorture: Add callback-flood test
      torture: Print PID in hung-kernel diagnostic message
      torture: Check for nul bytes in console output
      rcu: Add call_rcu_tasks()
      rcu: Provide cond_resched_rcu_qs() to force quiescent states in long loops
      rcu: Add synchronous grace-period waiting for RCU-tasks
      rcu: Make TASKS_RCU handle tasks that are almost done exiting
      rcutorture: Add torture tests for RCU-tasks
      rcutorture: Add RCU-tasks test cases
      rcu: Add stall-warning checks for RCU-tasks
      rcu: Improve RCU-tasks energy efficiency
      documentation: Add verbiage on RCU-tasks stall warning messages
      rcu: Defer rcu_tasks_kthread() creation till first call_rcu_tasks()
      rcu: Make TASKS_RCU handle nohz_full= CPUs
      rcu: Make rcu_tasks_kthread()'s GP-wait loop allow preemption
      rcu: Remove redundant preempt_disable() from rcu_note_voluntary_context_switch()
      rcu: Additional information on RCU-tasks stall-warning messages
      rcu: Remove local_irq_disable() in rcu_preempt_note_context_switch()
      rcu: Per-CPU operation cleanups to rcu_*_qs() functions
      rcutorture: Add RCU-tasks tests to default rcutorture list
      rcu: Fix attempt to avoid unsolicited offloading of callbacks
      rcu: Rationalize kthread spawning
      rcu: Create rcuo kthreads only for onlined CPUs
      rcu: Eliminate redundant rcu_sysidle_state variable
      rcu: Don't track sysidle state if no nohz_full= CPUs
      rcu: Avoid misordering in __call_rcu_nocb_enqueue()
      rcu: Handle NOCB callbacks from irq-disabled idle code
      rcu: Avoid misordering in nocb_leader_wait()
      locktorture: Make torture scripting account for new _runnable name
      locktorture: Add test scenario for mutex_lock
      locktorture: Add test scenario for rwsem_lock
      rcutorture: Rename rcutorture_runnable parameter
      locktorture: Document boot/module parameters
      rcu: Eliminate deadlock between CPU hotplug and expedited grace periods

Pranith Kumar (18):
      rcu: Remove remaining read-modify-write ACCESS_ONCE() calls
      rcu: Fix sparse warning about rcu_batches_completed_preempt() being non-static
      rcu: Use bool type for return value in rcu_is_watching()
      rcu: Return bool type for rcu_try_advance_all_cbs()
      rcu: Return bool type in rcu_lockdep_current_cpu_online()
      rcu: Use true/false instead of 1/0 for a bool type
      rcu: Update tiny.c references to tree.c
      rcu: Remove stale comment in tree.c
      rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads
      rcutorture: Fix a sparse warning by marking boost_mutex static
      rcutorture: Use bash shell for all the test scripts
      rcutorture: Set executable bit and drop bash from Usage
      rcu: Check the return value of zalloc_cpumask_var()
      rcu: Use true/false for return in __call_rcu_nocb()
      rcu: Use true/false for return in rcu_nocb_adopt_orphan_cbs()
      rcu: Use false for return in __call_rcu_nocb()
      rcu: Return false instead of 0 in rcu_nocb_adopt_orphan_cbs()
      rcu: Check for have_rcu_nocb_mask instead of rcu_nocb_mask

Steven Rostedt (1):
      rcu: Export RCU-tasks APIs to GPL modules


 Documentation/RCU/stallwarn.txt                    |  33 +-
 Documentation/kernel-parameters.txt                |  68 ++-
 Documentation/locking/locktorture.txt              | 147 ++++++
 Documentation/memory-barriers.txt                  | 128 ++---
 fs/file.c                                          |   2 +-
 include/linux/cpu.h                                |   2 +
 include/linux/init_task.h                          |  12 +-
 include/linux/lockdep.h                            |   1 +
 include/linux/rcupdate.h                           | 106 +++--
 include/linux/rcutiny.h                            |   2 +-
 include/linux/sched.h                              |  39 +-
 include/linux/torture.h                            |   5 +-
 include/trace/events/rcu.h                         |   3 +
 init/Kconfig                                       |  14 +-
 init/main.c                                        |   1 +
 kernel/cpu.c                                       |  16 +-
 kernel/exit.c                                      |   3 +
 kernel/locking/locktorture.c                       | 529 +++++++++++++++++----
 kernel/rcu/rcutorture.c                            | 278 +++++++----
 kernel/rcu/tiny.c                                  |  20 +-
 kernel/rcu/tree.c                                  | 115 +++--
 kernel/rcu/tree.h                                  |  18 +-
 kernel/rcu/tree_plugin.h                           | 404 +++++++++++-----
 kernel/rcu/update.c                                | 345 +++++++++++++-
 kernel/softirq.c                                   |   2 +-
 kernel/sysctl.c                                    |   9 -
 kernel/torture.c                                   |  32 +-
 kernel/workqueue.c                                 |   5 +-
 mm/mlock.c                                         |   2 +-
 .../selftests/rcutorture/bin/config2frag.sh        |   4 +-
 .../selftests/rcutorture/bin/configcheck.sh        |   4 +-
 .../testing/selftests/rcutorture/bin/configinit.sh |   4 +-
 .../testing/selftests/rcutorture/bin/functions.sh  |  20 +
 .../testing/selftests/rcutorture/bin/kvm-build.sh  |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |   2 +-
 .../selftests/rcutorture/bin/kvm-recheck.sh        |   2 +-
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   5 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      |   6 +-
 .../selftests/rcutorture/bin/parse-build.sh        |   5 +-
 .../selftests/rcutorture/bin/parse-console.sh      |   9 +-
 .../selftests/rcutorture/bin/parse-torture.sh      |   5 +-
 .../selftests/rcutorture/configs/lock/CFLIST       |   3 +
 .../selftests/rcutorture/configs/lock/LOCK02       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK02.boot  |   1 +
 .../selftests/rcutorture/configs/lock/LOCK03       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK03.boot  |   1 +
 .../selftests/rcutorture/configs/lock/LOCK04       |   6 +
 .../selftests/rcutorture/configs/lock/LOCK04.boot  |   1 +
 .../rcutorture/configs/lock/ver_functions.sh       |   2 +-
 .../selftests/rcutorture/configs/rcu/CFLIST        |   3 +
 .../selftests/rcutorture/configs/rcu/TASKS01       |   9 +
 .../selftests/rcutorture/configs/rcu/TASKS01.boot  |   1 +
 .../selftests/rcutorture/configs/rcu/TASKS02       |   5 +
 .../selftests/rcutorture/configs/rcu/TASKS02.boot  |   1 +
 .../selftests/rcutorture/configs/rcu/TASKS03       |  13 +
 .../selftests/rcutorture/configs/rcu/TASKS03.boot  |   1 +
 .../selftests/rcutorture/configs/rcu/TREE01        |   4 +-
 .../selftests/rcutorture/configs/rcu/TREE01.boot   |   2 +-
 .../selftests/rcutorture/configs/rcu/TREE07        |   3 +-
 .../selftests/rcutorture/configs/rcu/TREE07.boot   |   1 +
 .../rcutorture/configs/rcu/ver_functions.sh        |   2 +-
 tools/testing/selftests/rcutorture/doc/initrd.txt  |   1 +
 63 files changed, 1936 insertions(+), 547 deletions(-)
 create mode 100644 Documentation/locking/locktorture.txt
 mode change 100644 => 100755 tools/testing/selftests/rcutorture/bin/config2frag.sh
 mode change 100644 => 100755 tools/testing/selftests/rcutorture/bin/kvm.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK02
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK03
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK03.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04
 create mode 100644 tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS03
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 68fe3ad27015..ef5a2fd4ff70 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -56,8 +56,20 @@ RCU_STALL_RAT_DELAY
 	two jiffies.  (This is a cpp macro, not a kernel configuration
 	parameter.)
 
-When a CPU detects that it is stalling, it will print a message similar
-to the following:
+rcupdate.rcu_task_stall_timeout
+
+	This boot/sysfs parameter controls the RCU-tasks stall warning
+	interval.  A value of zero or less suppresses RCU-tasks stall
+	warnings.  A positive value sets the stall-warning interval
+	in jiffies.  An RCU-tasks stall warning starts wtih the line:
+
+		INFO: rcu_tasks detected stalls on tasks:
+
+	And continues with the output of sched_show_task() for each
+	task stalling the current RCU-tasks grace period.
+
+For non-RCU-tasks flavors of RCU, when a CPU detects that it is stalling,
+it will print a message similar to the following:
 
 INFO: rcu_sched_state detected stall on CPU 5 (t=2500 jiffies)
 
@@ -174,8 +186,12 @@ o	A CPU looping with preemption disabled.  This condition can
 o	A CPU looping with bottom halves disabled.  This condition can
 	result in RCU-sched and RCU-bh stalls.
 
-o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
-	without invoking schedule().
+o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the
+	kernel without invoking schedule().  Note that cond_resched()
+	does not necessarily prevent RCU CPU stall warnings.  Therefore,
+	if the looping in the kernel is really expected and desirable
+	behavior, you might need to replace some of the cond_resched()
+	calls with calls to cond_resched_rcu_qs().
 
 o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
 	happen to preempt a low-priority task in the middle of an RCU
@@ -208,11 +224,10 @@ o	A hardware failure.  This is quite unlikely, but has occurred
 	This resulted in a series of RCU CPU stall warnings, eventually
 	leading the realization that the CPU had failed.
 
-The RCU, RCU-sched, and RCU-bh implementations have CPU stall warning.
-SRCU does not have its own CPU stall warnings, but its calls to
-synchronize_sched() will result in RCU-sched detecting RCU-sched-related
-CPU stalls.  Please note that RCU only detects CPU stalls when there is
-a grace period in progress.  No grace period, no CPU stall warnings.
+The RCU, RCU-sched, RCU-bh, and RCU-tasks implementations have CPU stall
+warning.  Note that SRCU does -not- have CPU stall warnings.  Please note
+that RCU only detects CPU stalls when there is a grace period in progress.
+No grace period, no CPU stall warnings.
 
 To diagnose the cause of the stall, inspect the stack traces.
 The offending function will usually be near the top of the stack.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 10d51c2f10d7..aa0eedc84d00 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1704,6 +1704,49 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	lockd.nlm_udpport=M	[NFS] Assign UDP port.
 			Format: <integer>
 
+	locktorture.nreaders_stress= [KNL]
+			Set the number of locking read-acquisition kthreads.
+			Defaults to being automatically set based on the
+			number of online CPUs.
+
+	locktorture.nwriters_stress= [KNL]
+			Set the number of locking write-acquisition kthreads.
+
+	locktorture.onoff_holdoff= [KNL]
+			Set time (s) after boot for CPU-hotplug testing.
+
+	locktorture.onoff_interval= [KNL]
+			Set time (s) between CPU-hotplug operations, or
+			zero to disable CPU-hotplug testing.
+
+	locktorture.shuffle_interval= [KNL]
+			Set task-shuffle interval (jiffies).  Shuffling
+			tasks allows some CPUs to go into dyntick-idle
+			mode during the locktorture test.
+
+	locktorture.shutdown_secs= [KNL]
+			Set time (s) after boot system shutdown.  This
+			is useful for hands-off automated testing.
+
+	locktorture.stat_interval= [KNL]
+			Time (s) between statistics printk()s.
+
+	locktorture.stutter= [KNL]
+			Time (s) to stutter testing, for example,
+			specifying five seconds causes the test to run for
+			five seconds, wait for five seconds, and so on.
+			This tests the locking primitive's ability to
+			transition abruptly to and from idle.
+
+	locktorture.torture_runnable= [BOOT]
+			Start locktorture running at boot time.
+
+	locktorture.torture_type= [KNL]
+			Specify the locking implementation to test.
+
+	locktorture.verbose= [KNL]
+			Enable additional printk() statements.
+
 	logibm.irq=	[HW,MOUSE] Logitech Bus Mouse Driver
 			Format: <irq>
 
@@ -2881,6 +2924,24 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Lazy RCU callbacks are those which RCU can
 			prove do nothing more than free memory.
 
+	rcutorture.cbflood_inter_holdoff= [KNL]
+			Set holdoff time (jiffies) between successive
+			callback-flood tests.
+
+	rcutorture.cbflood_intra_holdoff= [KNL]
+			Set holdoff time (jiffies) between successive
+			bursts of callbacks within a given callback-flood
+			test.
+
+	rcutorture.cbflood_n_burst= [KNL]
+			Set the number of bursts making up a given
+			callback-flood test.  Set this to zero to
+			disable callback-flood testing.
+
+	rcutorture.cbflood_n_per_burst= [KNL]
+			Set the number of callbacks to be registered
+			in a given burst of a callback-flood test.
+
 	rcutorture.fqs_duration= [KNL]
 			Set duration of force_quiescent_state bursts.
 
@@ -2920,7 +2981,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Set time (s) between CPU-hotplug operations, or
 			zero to disable CPU-hotplug testing.
 
-	rcutorture.rcutorture_runnable= [BOOT]
+	rcutorture.torture_runnable= [BOOT]
 			Start rcutorture running at boot time.
 
 	rcutorture.shuffle_interval= [KNL]
@@ -2982,6 +3043,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	rcupdate.rcu_cpu_stall_timeout= [KNL]
 			Set timeout for RCU CPU stall warning messages.
 
+	rcupdate.rcu_task_stall_timeout= [KNL]
+			Set timeout in jiffies for RCU task stall warning
+			messages.  Disable with a value less than or equal
+			to zero.
+
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
diff --git a/Documentation/locking/locktorture.txt b/Documentation/locking/locktorture.txt
new file mode 100644
index 000000000000..619f2bb136a5
--- /dev/null
+++ b/Documentation/locking/locktorture.txt
@@ -0,0 +1,147 @@
+Kernel Lock Torture Test Operation
+
+CONFIG_LOCK_TORTURE_TEST
+
+The CONFIG LOCK_TORTURE_TEST config option provides a kernel module
+that runs torture tests on core kernel locking primitives. The kernel
+module, 'locktorture', may be built after the fact on the running
+kernel to be tested, if desired. The tests periodically output status
+messages via printk(), which can be examined via the dmesg (perhaps
+grepping for "torture").  The test is started when the module is loaded,
+and stops when the module is unloaded. This program is based on how RCU
+is tortured, via rcutorture.
+
+This torture test consists of creating a number of kernel threads which
+acquire the lock and hold it for specific amount of time, thus simulating
+different critical region behaviors. The amount of contention on the lock
+can be simulated by either enlarging this critical region hold time and/or
+creating more kthreads.
+
+
+MODULE PARAMETERS
+
+This module has the following parameters:
+
+
+	    ** Locktorture-specific **
+
+nwriters_stress   Number of kernel threads that will stress exclusive lock
+		  ownership (writers). The default value is twice the number
+		  of online CPUs.
+
+nreaders_stress   Number of kernel threads that will stress shared lock
+		  ownership (readers). The default is the same amount of writer
+		  locks. If the user did not specify nwriters_stress, then
+		  both readers and writers be the amount of online CPUs.
+
+torture_type	  Type of lock to torture. By default, only spinlocks will
+		  be tortured. This module can torture the following locks,
+		  with string values as follows:
+
+		     o "lock_busted": Simulates a buggy lock implementation.
+
+		     o "spin_lock": spin_lock() and spin_unlock() pairs.
+
+		     o "spin_lock_irq": spin_lock_irq() and spin_unlock_irq()
+					pairs.
+
+		     o "rw_lock": read/write lock() and unlock() rwlock pairs.
+
+		     o "rw_lock_irq": read/write lock_irq() and unlock_irq()
+				      rwlock pairs.
+
+		     o "mutex_lock": mutex_lock() and mutex_unlock() pairs.
+
+		     o "rwsem_lock": read/write down() and up() semaphore pairs.
+
+torture_runnable  Start locktorture at boot time in the case where the
+		  module is built into the kernel, otherwise wait for
+		  torture_runnable to be set via sysfs before starting.
+		  By default it will begin once the module is loaded.
+
+
+	    ** Torture-framework (RCU + locking) **
+
+shutdown_secs	  The number of seconds to run the test before terminating
+		  the test and powering off the system.  The default is
+		  zero, which disables test termination and system shutdown.
+		  This capability is useful for automated testing.
+
+onoff_interval	  The number of seconds between each attempt to execute a
+		  randomly selected CPU-hotplug operation.  Defaults
+		  to zero, which disables CPU hotplugging.  In
+		  CONFIG_HOTPLUG_CPU=n kernels, locktorture will silently
+		  refuse to do any CPU-hotplug operations regardless of
+		  what value is specified for onoff_interval.
+
+onoff_holdoff	  The number of seconds to wait until starting CPU-hotplug
+		  operations.  This would normally only be used when
+		  locktorture was built into the kernel and started
+		  automatically at boot time, in which case it is useful
+		  in order to avoid confusing boot-time code with CPUs
+		  coming and going. This parameter is only useful if
+		  CONFIG_HOTPLUG_CPU is enabled.
+
+stat_interval	  Number of seconds between statistics-related printk()s.
+		  By default, locktorture will report stats every 60 seconds.
+		  Setting the interval to zero causes the statistics to
+		  be printed -only- when the module is unloaded, and this
+		  is the default.
+
+stutter		  The length of time to run the test before pausing for this
+		  same period of time.  Defaults to "stutter=5", so as
+		  to run and pause for (roughly) five-second intervals.
+		  Specifying "stutter=0" causes the test to run continuously
+		  without pausing, which is the old default behavior.
+
+shuffle_interval  The number of seconds to keep the test threads affinitied
+		  to a particular subset of the CPUs, defaults to 3 seconds.
+		  Used in conjunction with test_no_idle_hz.
+
+verbose		  Enable verbose debugging printing, via printk(). Enabled
+		  by default. This extra information is mostly related to
+		  high-level errors and reports from the main 'torture'
+		  framework.
+
+
+STATISTICS
+
+Statistics are printed in the following format:
+
+spin_lock-torture: Writes:  Total: 93746064  Max/Min: 0/0   Fail: 0
+   (A)		    (B)		   (C)		  (D)	       (E)
+
+(A): Lock type that is being tortured -- torture_type parameter.
+
+(B): Number of writer lock acquisitions. If dealing with a read/write primitive
+     a second "Reads" statistics line is printed.
+
+(C): Number of times the lock was acquired.
+
+(D): Min and max number of times threads failed to acquire the lock.
+
+(E): true/false values if there were errors acquiring the lock. This should
+     -only- be positive if there is a bug in the locking primitive's
+     implementation. Otherwise a lock should never fail (i.e., spin_lock()).
+     Of course, the same applies for (C), above. A dummy example of this is
+     the "lock_busted" type.
+
+USAGE
+
+The following script may be used to torture locks:
+
+	#!/bin/sh
+
+	modprobe locktorture
+	sleep 3600
+	rmmod locktorture
+	dmesg | grep torture:
+
+The output can be manually inspected for the error flag of "!!!".
+One could of course create a more elaborate script that automatically
+checked for such errors.  The "rmmod" command forces a "SUCCESS",
+"FAILURE", or "RCU_HOTPLUG" indication to be printk()ed.  The first
+two are self-explanatory, while the last indicates that while there
+were no locking failures, CPU-hotplug problems were detected.
+
+Also see: Documentation/RCU/torture.txt
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a4de88fb55f0..22a969cdd476 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -574,30 +574,14 @@ However, stores are not speculated.  This means that ordering -is- provided
 in the following example:
 
 	q = ACCESS_ONCE(a);
-	if (ACCESS_ONCE(q)) {
-		ACCESS_ONCE(b) = p;
-	}
-
-Please note that ACCESS_ONCE() is not optional!  Without the ACCESS_ONCE(),
-the compiler is within its rights to transform this example:
-
-	q = a;
 	if (q) {
-		b = p;  /* BUG: Compiler can reorder!!! */
-		do_something();
-	} else {
-		b = p;  /* BUG: Compiler can reorder!!! */
-		do_something_else();
+		ACCESS_ONCE(b) = p;
 	}
 
-into this, which of course defeats the ordering:
-
-	b = p;
-	q = a;
-	if (q)
-		do_something();
-	else
-		do_something_else();
+Please note that ACCESS_ONCE() is not optional!  Without the
+ACCESS_ONCE(), might combine the load from 'a' with other loads from
+'a', and the store to 'b' with other stores to 'b', with possible highly
+counterintuitive effects on ordering.
 
 Worse yet, if the compiler is able to prove (say) that the value of
 variable 'a' is always non-zero, it would be well within its rights
@@ -605,11 +589,12 @@ to optimize the original example by eliminating the "if" statement
 as follows:
 
 	q = a;
-	b = p;  /* BUG: Compiler can reorder!!! */
-	do_something();
+	b = p;  /* BUG: Compiler and CPU can both reorder!!! */
+
+So don't leave out the ACCESS_ONCE().
 
-The solution is again ACCESS_ONCE() and barrier(), which preserves the
-ordering between the load from variable 'a' and the store to variable 'b':
+It is tempting to try to enforce ordering on identical stores on both
+branches of the "if" statement as follows:
 
 	q = ACCESS_ONCE(a);
 	if (q) {
@@ -622,18 +607,11 @@ The solution is again ACCESS_ONCE() and barrier(), which preserves the
 		do_something_else();
 	}
 
-The initial ACCESS_ONCE() is required to prevent the compiler from
-proving the value of 'a', and the pair of barrier() invocations are
-required to prevent the compiler from pulling the two identical stores
-to 'b' out from the legs of the "if" statement.
-
-It is important to note that control dependencies absolutely require a
-a conditional.  For example, the following "optimized" version of
-the above example breaks ordering, which is why the barrier() invocations
-are absolutely required if you have identical stores in both legs of
-the "if" statement:
+Unfortunately, current compilers will transform this as follows at high
+optimization levels:
 
 	q = ACCESS_ONCE(a);
+	barrier();
 	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
 	if (q) {
 		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
@@ -643,21 +621,36 @@ are absolutely required if you have identical stores in both legs of
 		do_something_else();
 	}
 
-It is of course legal for the prior load to be part of the conditional,
-for example, as follows:
+Now there is no conditional between the load from 'a' and the store to
+'b', which means that the CPU is within its rights to reorder them:
+The conditional is absolutely required, and must be present in the
+assembly code even after all compiler optimizations have been applied.
+Therefore, if you need ordering in this example, you need explicit
+memory barriers, for example, smp_store_release():
 
-	if (ACCESS_ONCE(a) > 0) {
-		barrier();
-		ACCESS_ONCE(b) = q / 2;
+	q = ACCESS_ONCE(a);
+	if (q) {
+		smp_store_release(&b, p);
 		do_something();
 	} else {
-		barrier();
-		ACCESS_ONCE(b) = q / 3;
+		smp_store_release(&b, p);
+		do_something_else();
+	}
+
+In contrast, without explicit memory barriers, two-legged-if control
+ordering is guaranteed only when the stores differ, for example:
+
+	q = ACCESS_ONCE(a);
+	if (q) {
+		ACCESS_ONCE(b) = p;
+		do_something();
+	} else {
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
-This will again ensure that the load from variable 'a' is ordered before the
-stores to variable 'b'.
+The initial ACCESS_ONCE() is still required to prevent the compiler from
+proving the value of 'a'.
 
 In addition, you need to be careful what you do with the local variable 'q',
 otherwise the compiler might be able to guess the value and again remove
@@ -665,12 +658,10 @@ otherwise the compiler might be able to guess the value and again remove
 
 	q = ACCESS_ONCE(a);
 	if (q % MAX) {
-		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		barrier();
-		ACCESS_ONCE(b) = p;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
@@ -682,9 +673,12 @@ equal to zero, in which case the compiler is within its rights to
 	ACCESS_ONCE(b) = p;
 	do_something_else();
 
-This transformation loses the ordering between the load from variable 'a'
-and the store to variable 'b'.  If you are relying on this ordering, you
-should do something like the following:
+Given this transformation, the CPU is not required to respect the ordering
+between the load from variable 'a' and the store to variable 'b'.  It is
+tempting to add a barrier(), but this does not help.  The conditional
+is gone, and the barrier won't bring it back.  Therefore, if you are
+relying on this ordering, you should make sure that MAX is greater than
+one, perhaps as follows:
 
 	q = ACCESS_ONCE(a);
 	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
@@ -692,35 +686,45 @@ and the store to variable 'b'.  If you are relying on this ordering, you
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		ACCESS_ONCE(b) = p;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
+Please note once again that the stores to 'b' differ.  If they were
+identical, as noted earlier, the compiler could pull this store outside
+of the 'if' statement.
+
 Finally, control dependencies do -not- provide transitivity.  This is
-demonstrated by two related examples:
+demonstrated by two related examples, with the initial values of
+x and y both being zero:
 
 	CPU 0                     CPU 1
 	=====================     =====================
 	r1 = ACCESS_ONCE(x);      r2 = ACCESS_ONCE(y);
-	if (r1 >= 0)              if (r2 >= 0)
+	if (r1 > 0)               if (r2 > 0)
 	  ACCESS_ONCE(y) = 1;       ACCESS_ONCE(x) = 1;
 
 	assert(!(r1 == 1 && r2 == 1));
 
 The above two-CPU example will never trigger the assert().  However,
 if control dependencies guaranteed transitivity (which they do not),
-then adding the following two CPUs would guarantee a related assertion:
+then adding the following CPU would guarantee a related assertion:
 
-	CPU 2                     CPU 3
-	=====================     =====================
-	ACCESS_ONCE(x) = 2;       ACCESS_ONCE(y) = 2;
+	CPU 2
+	=====================
+	ACCESS_ONCE(x) = 2;
+
+	assert(!(r1 == 2 && r2 == 1 && x == 2)); /* FAILS!!! */
 
-	assert(!(r1 == 2 && r2 == 2 && x == 1 && y == 1)); /* FAILS!!! */
+But because control dependencies do -not- provide transitivity, the above
+assertion can fail after the combined three-CPU example completes.  If you
+need the three-CPU example to provide ordering, you will need smp_mb()
+between the loads and stores in the CPU 0 and CPU 1 code fragments,
+that is, just before or just after the "if" statements.
 
-But because control dependencies do -not- provide transitivity, the
-above assertion can fail after the combined four-CPU example completes.
-If you need the four-CPU example to provide ordering, you will need
-smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments.
+These two examples are the LB and WWC litmus tests from this paper:
+http://www.cl.cam.ac.uk/users/pes20/ppc-supplemental/test6.pdf and this
+site: https://www.cl.cam.ac.uk/~pes20/ppcmem/index.html.
 
 In summary:
 
diff --git a/fs/file.c b/fs/file.c
index 66923fe3176e..1cafc4c9275b 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -367,7 +367,7 @@ static struct fdtable *close_files(struct files_struct * files)
 				struct file * file = xchg(&fdt->fd[i], NULL);
 				if (file) {
 					filp_close(file, files);
-					cond_resched();
+					cond_resched_rcu_qs();
 				}
 			}
 			i++;
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 95978ad7fcdd..b2d9a43012b2 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -213,6 +213,7 @@ extern struct bus_type cpu_subsys;
 extern void cpu_hotplug_begin(void);
 extern void cpu_hotplug_done(void);
 extern void get_online_cpus(void);
+extern bool try_get_online_cpus(void);
 extern void put_online_cpus(void);
 extern void cpu_hotplug_disable(void);
 extern void cpu_hotplug_enable(void);
@@ -230,6 +231,7 @@ int cpu_down(unsigned int cpu);
 static inline void cpu_hotplug_begin(void) {}
 static inline void cpu_hotplug_done(void) {}
 #define get_online_cpus()	do { } while (0)
+#define try_get_online_cpus()	true
 #define put_online_cpus()	do { } while (0)
 #define cpu_hotplug_disable()	do { } while (0)
 #define cpu_hotplug_enable()	do { } while (0)
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 2bb4c4f3531a..77fc43f8fb72 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -111,12 +111,21 @@ extern struct group_info init_groups;
 #ifdef CONFIG_PREEMPT_RCU
 #define INIT_TASK_RCU_PREEMPT(tsk)					\
 	.rcu_read_lock_nesting = 0,					\
-	.rcu_read_unlock_special = 0,					\
+	.rcu_read_unlock_special.s = 0,					\
 	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
 	INIT_TASK_RCU_TREE_PREEMPT()
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
+#ifdef CONFIG_TASKS_RCU
+#define INIT_TASK_RCU_TASKS(tsk)					\
+	.rcu_tasks_holdout = false,					\
+	.rcu_tasks_holdout_list =					\
+		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),		\
+	.rcu_tasks_idle_cpu = -1,
+#else
+#define INIT_TASK_RCU_TASKS(tsk)
+#endif
 
 extern struct cred init_cred;
 
@@ -224,6 +233,7 @@ extern struct task_group root_task_group;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_TASK_RCU_TASKS(tsk)					\
 	INIT_CPUSET_SEQ(tsk)						\
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 008388f920d7..4f86465cc317 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -505,6 +505,7 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
+#define lock_map_acquire_tryread(l)		lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
 #define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 
 #ifdef CONFIG_PROVE_LOCKING
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d231aa17b1d7..a4a819ffb2d1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -47,14 +47,12 @@
 #include <asm/barrier.h>
 
 extern int rcu_expedited; /* for sysctl */
-#ifdef CONFIG_RCU_TORTURE_TEST
-extern int rcutorture_runnable; /* for sysctl */
-#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 enum rcutorture_type {
 	RCU_FLAVOR,
 	RCU_BH_FLAVOR,
 	RCU_SCHED_FLAVOR,
+	RCU_TASKS_FLAVOR,
 	SRCU_FLAVOR,
 	INVALID_RCU_FLAVOR
 };
@@ -197,6 +195,28 @@ void call_rcu_sched(struct rcu_head *head,
 
 void synchronize_sched(void);
 
+/**
+ * call_rcu_tasks() - Queue an RCU for invocation task-based grace period
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all currently executing RCU
+ * read-side critical sections have completed. call_rcu_tasks() assumes
+ * that the read-side critical sections end at a voluntary context
+ * switch (not a preemption!), entry into idle, or transition to usermode
+ * execution.  As such, there are no read-side primitives analogous to
+ * rcu_read_lock() and rcu_read_unlock() because this primitive is intended
+ * to determine that all tasks have passed through a safe state, not so
+ * much for data-strcuture synchronization.
+ *
+ * See the description of call_rcu() for more detailed information on
+ * memory ordering guarantees.
+ */
+void call_rcu_tasks(struct rcu_head *head, void (*func)(struct rcu_head *head));
+void synchronize_rcu_tasks(void);
+void rcu_barrier_tasks(void);
+
 #ifdef CONFIG_PREEMPT_RCU
 
 void __rcu_read_lock(void);
@@ -238,8 +258,8 @@ static inline int rcu_preempt_depth(void)
 
 /* Internal to kernel */
 void rcu_init(void);
-void rcu_sched_qs(int cpu);
-void rcu_bh_qs(int cpu);
+void rcu_sched_qs(void);
+void rcu_bh_qs(void);
 void rcu_check_callbacks(int cpu, int user);
 struct notifier_block;
 void rcu_idle_enter(void);
@@ -269,6 +289,14 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
+#ifdef CONFIG_RCU_NOCB_CPU
+void rcu_init_nohz(void);
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+static inline void rcu_init_nohz(void)
+{
+}
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
  * @a: Code that RCU needs to pay attention to.
@@ -294,6 +322,36 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 		rcu_irq_exit(); \
 	} while (0)
 
+/*
+ * Note a voluntary context switch for RCU-tasks benefit.  This is a
+ * macro rather than an inline function to avoid #include hell.
+ */
+#ifdef CONFIG_TASKS_RCU
+#define TASKS_RCU(x) x
+extern struct srcu_struct tasks_rcu_exit_srcu;
+#define rcu_note_voluntary_context_switch(t) \
+	do { \
+		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
+			ACCESS_ONCE((t)->rcu_tasks_holdout) = false; \
+	} while (0)
+#else /* #ifdef CONFIG_TASKS_RCU */
+#define TASKS_RCU(x) do { } while (0)
+#define rcu_note_voluntary_context_switch(t)	do { } while (0)
+#endif /* #else #ifdef CONFIG_TASKS_RCU */
+
+/**
+ * cond_resched_rcu_qs - Report potential quiescent states to RCU
+ *
+ * This macro resembles cond_resched(), except that it is defined to
+ * report potential quiescent states to RCU-tasks even if the cond_resched()
+ * machinery were to be shut off, as some advocate for PREEMPT kernels.
+ */
+#define cond_resched_rcu_qs() \
+do { \
+	rcu_note_voluntary_context_switch(current); \
+	cond_resched(); \
+} while (0)
+
 #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
 bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
@@ -349,7 +407,7 @@ bool rcu_lockdep_current_cpu_online(void);
 #else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
 static inline bool rcu_lockdep_current_cpu_online(void)
 {
-	return 1;
+	return true;
 }
 #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
 
@@ -371,41 +429,7 @@ extern struct lockdep_map rcu_sched_lock_map;
 extern struct lockdep_map rcu_callback_map;
 int debug_lockdep_rcu_enabled(void);
 
-/**
- * rcu_read_lock_held() - might we be in RCU read-side critical section?
- *
- * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
- * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
- * this assumes we are in an RCU read-side critical section unless it can
- * prove otherwise.  This is useful for debug checks in functions that
- * require that they be called within an RCU read-side critical section.
- *
- * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
- * and while lockdep is disabled.
- *
- * Note that rcu_read_lock() and the matching rcu_read_unlock() must
- * occur in the same context, for example, it is illegal to invoke
- * rcu_read_unlock() in process context if the matching rcu_read_lock()
- * was invoked from within an irq handler.
- *
- * Note that rcu_read_lock() is disallowed if the CPU is either idle or
- * offline from an RCU perspective, so check for those as well.
- */
-static inline int rcu_read_lock_held(void)
-{
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
-	return lock_is_held(&rcu_lock_map);
-}
-
-/*
- * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
- * hell.
- */
+int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
 
 /**
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index d40a6a451330..38cc5b1e252d 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -80,7 +80,7 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 static inline void rcu_note_context_switch(int cpu)
 {
-	rcu_sched_qs(cpu);
+	rcu_sched_qs();
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885ee52b..42888d715fb1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1212,6 +1212,13 @@ struct sched_dl_entity {
 	struct hrtimer dl_timer;
 };
 
+union rcu_special {
+	struct {
+		bool blocked;
+		bool need_qs;
+	} b;
+	short s;
+};
 struct rcu_node;
 
 enum perf_event_task_context {
@@ -1264,12 +1271,18 @@ struct task_struct {
 
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
-	char rcu_read_unlock_special;
+	union rcu_special rcu_read_unlock_special;
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
 	struct rcu_node *rcu_blocked_node;
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_TASKS_RCU
+	unsigned long rcu_tasks_nvcsw;
+	bool rcu_tasks_holdout;
+	struct list_head rcu_tasks_holdout_list;
+	int rcu_tasks_idle_cpu;
+#endif /* #ifdef CONFIG_TASKS_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -1999,29 +2012,21 @@ extern void task_clear_jobctl_trapping(struct task_struct *task);
 extern void task_clear_jobctl_pending(struct task_struct *task,
 				      unsigned int mask);
 
-#ifdef CONFIG_PREEMPT_RCU
-
-#define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
-
 static inline void rcu_copy_process(struct task_struct *p)
 {
+#ifdef CONFIG_PREEMPT_RCU
 	p->rcu_read_lock_nesting = 0;
-	p->rcu_read_unlock_special = 0;
-#ifdef CONFIG_TREE_PREEMPT_RCU
+	p->rcu_read_unlock_special.s = 0;
 	p->rcu_blocked_node = NULL;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#ifdef CONFIG_TASKS_RCU
+	p->rcu_tasks_holdout = false;
+	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
+	p->rcu_tasks_idle_cpu = -1;
+#endif /* #ifdef CONFIG_TASKS_RCU */
 }
 
-#else
-
-static inline void rcu_copy_process(struct task_struct *p)
-{
-}
-
-#endif
-
 static inline void tsk_restore_flags(struct task_struct *task,
 				unsigned long orig_flags, unsigned long flags)
 {
diff --git a/include/linux/torture.h b/include/linux/torture.h
index 5ca58fcbaf1b..7759fc3c622d 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -51,7 +51,7 @@
 
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
-char *torture_onoff_stats(char *page);
+void torture_onoff_stats(void);
 bool torture_onoff_failures(void);
 
 /* Low-rider random number generator. */
@@ -77,7 +77,8 @@ int torture_stutter_init(int s);
 /* Initialization and cleanup. */
 bool torture_init_begin(char *ttype, bool v, int *runnable);
 void torture_init_end(void);
-bool torture_cleanup(void);
+bool torture_cleanup_begin(void);
+void torture_cleanup_end(void);
 bool torture_must_stop(void);
 bool torture_must_stop_irq(void);
 void torture_kthread_stopping(char *title);
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index aca382266411..9b56f37148cf 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -180,9 +180,12 @@ TRACE_EVENT(rcu_grace_period_init,
  * argument is a string as follows:
  *
  *	"WakeEmpty": Wake rcuo kthread, first CB to empty list.
+ *	"WakeEmptyIsDeferred": Wake rcuo kthread later, first CB to empty list.
  *	"WakeOvf": Wake rcuo kthread, CB list is huge.
+ *	"WakeOvfIsDeferred": Wake rcuo kthread later, CB list is huge.
  *	"WakeNot": Don't wake rcuo kthread.
  *	"WakeNotPoll": Don't wake rcuo kthread because it is polling.
+ *	"DeferredWake": Carried out the "IsDeferred" wakeup.
  *	"Poll": Start of new polling cycle for rcu_nocb_poll.
  *	"Sleep": Sleep waiting for CBs for !rcu_nocb_poll.
  *	"WokeEmpty": rcuo kthread woke to find empty list.
diff --git a/init/Kconfig b/init/Kconfig
index e84c6423a2e5..4fe5500b998f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -507,6 +507,16 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  TREE_PREEMPT_RCU and, in the old days, TINY_PREEMPT_RCU.
 
+config TASKS_RCU
+	bool "Task_based RCU implementation using voluntary context switch"
+	default n
+	help
+	  This option enables a task-based RCU implementation that uses
+	  only voluntary context switch (not preemption!), idle, and
+	  user-mode execution as quiescent states.
+
+	  If unsure, say N.
+
 config RCU_STALL_COMMON
 	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
 	help
@@ -737,7 +747,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on RCU_NOCB_CPU
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -751,7 +761,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on RCU_NOCB_CPU
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..e3c4cdd94d5b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -578,6 +578,7 @@ asmlinkage __visible void __init start_kernel(void)
 	idr_init_cache();
 	rcu_init();
 	tick_nohz_init();
+	rcu_init_nohz();
 	context_tracking_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 81e2a388a0f6..356450f09c1f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -79,6 +79,8 @@ static struct {
 
 /* Lockdep annotations for get/put_online_cpus() and cpu_hotplug_begin/end() */
 #define cpuhp_lock_acquire_read() lock_map_acquire_read(&cpu_hotplug.dep_map)
+#define cpuhp_lock_acquire_tryread() \
+				  lock_map_acquire_tryread(&cpu_hotplug.dep_map)
 #define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
 #define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
 
@@ -91,10 +93,22 @@ void get_online_cpus(void)
 	mutex_lock(&cpu_hotplug.lock);
 	cpu_hotplug.refcount++;
 	mutex_unlock(&cpu_hotplug.lock);
-
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
+bool try_get_online_cpus(void)
+{
+	if (cpu_hotplug.active_writer == current)
+		return true;
+	if (!mutex_trylock(&cpu_hotplug.lock))
+		return false;
+	cpuhp_lock_acquire_tryread();
+	cpu_hotplug.refcount++;
+	mutex_unlock(&cpu_hotplug.lock);
+	return true;
+}
+EXPORT_SYMBOL_GPL(try_get_online_cpus);
+
 void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7433a3..d13f2eec4bb8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -667,6 +667,7 @@ void do_exit(long code)
 {
 	struct task_struct *tsk = current;
 	int group_dead;
+	TASKS_RCU(int tasks_rcu_i);
 
 	profile_task_exit(tsk);
 
@@ -775,6 +776,7 @@ void do_exit(long code)
 	 */
 	flush_ptrace_hw_breakpoint(tsk);
 
+	TASKS_RCU(tasks_rcu_i = __srcu_read_lock(&tasks_rcu_exit_srcu));
 	exit_notify(tsk, group_dead);
 	proc_exit_connector(tsk);
 #ifdef CONFIG_NUMA
@@ -814,6 +816,7 @@ void do_exit(long code)
 	if (tsk->nr_dirtied)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
+	TASKS_RCU(__srcu_read_unlock(&tasks_rcu_exit_srcu, tasks_rcu_i));
 
 	/*
 	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 0955b885d0dc..ec8cce259779 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -20,30 +20,20 @@
  * Author: Paul E. McKenney <paulmck@us.ibm.com>
  *	Based on kernel/rcu/torture.c.
  */
-#include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
-#include <linux/err.h>
 #include <linux/spinlock.h>
+#include <linux/rwlock.h>
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/atomic.h>
-#include <linux/bitops.h>
-#include <linux/completion.h>
 #include <linux/moduleparam.h>
-#include <linux/percpu.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/freezer.h>
-#include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/stat.h>
 #include <linux/slab.h>
-#include <linux/trace_clock.h>
-#include <asm/byteorder.h>
 #include <linux/torture.h>
 
 MODULE_LICENSE("GPL");
@@ -51,6 +41,8 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
 
 torture_param(int, nwriters_stress, -1,
 	     "Number of write-locking stress-test threads");
+torture_param(int, nreaders_stress, -1,
+	     "Number of read-locking stress-test threads");
 torture_param(int, onoff_holdoff, 0, "Time after boot before CPU hotplugs (s)");
 torture_param(int, onoff_interval, 0,
 	     "Time between CPU hotplugs (s), 0=disable");
@@ -66,30 +58,28 @@ torture_param(bool, verbose, true,
 static char *torture_type = "spin_lock";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type,
-		 "Type of lock to torture (spin_lock, spin_lock_irq, ...)");
-
-static atomic_t n_lock_torture_errors;
+		 "Type of lock to torture (spin_lock, spin_lock_irq, mutex_lock, ...)");
 
 static struct task_struct *stats_task;
 static struct task_struct **writer_tasks;
+static struct task_struct **reader_tasks;
 
-static int nrealwriters_stress;
 static bool lock_is_write_held;
+static bool lock_is_read_held;
 
-struct lock_writer_stress_stats {
-	long n_write_lock_fail;
-	long n_write_lock_acquired;
+struct lock_stress_stats {
+	long n_lock_fail;
+	long n_lock_acquired;
 };
-static struct lock_writer_stress_stats *lwsa;
 
 #if defined(MODULE)
 #define LOCKTORTURE_RUNNABLE_INIT 1
 #else
 #define LOCKTORTURE_RUNNABLE_INIT 0
 #endif
-int locktorture_runnable = LOCKTORTURE_RUNNABLE_INIT;
-module_param(locktorture_runnable, int, 0444);
-MODULE_PARM_DESC(locktorture_runnable, "Start locktorture at module init");
+int torture_runnable = LOCKTORTURE_RUNNABLE_INIT;
+module_param(torture_runnable, int, 0444);
+MODULE_PARM_DESC(torture_runnable, "Start locktorture at module init");
 
 /* Forward reference. */
 static void lock_torture_cleanup(void);
@@ -102,12 +92,25 @@ struct lock_torture_ops {
 	int (*writelock)(void);
 	void (*write_delay)(struct torture_random_state *trsp);
 	void (*writeunlock)(void);
+	int (*readlock)(void);
+	void (*read_delay)(struct torture_random_state *trsp);
+	void (*readunlock)(void);
 	unsigned long flags;
 	const char *name;
 };
 
-static struct lock_torture_ops *cur_ops;
-
+struct lock_torture_cxt {
+	int nrealwriters_stress;
+	int nrealreaders_stress;
+	bool debug_lock;
+	atomic_t n_lock_torture_errors;
+	struct lock_torture_ops *cur_ops;
+	struct lock_stress_stats *lwsa; /* writer statistics */
+	struct lock_stress_stats *lrsa; /* reader statistics */
+};
+static struct lock_torture_cxt cxt = { 0, 0, false,
+				       ATOMIC_INIT(0),
+				       NULL, NULL};
 /*
  * Definitions for lock torture testing.
  */
@@ -123,10 +126,10 @@ static void torture_lock_busted_write_delay(struct torture_random_state *trsp)
 
 	/* We want a long delay occasionally to force massive contention.  */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_us)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_us)))
 		mdelay(longdelay_us);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -140,6 +143,9 @@ static struct lock_torture_ops lock_busted_ops = {
 	.writelock	= torture_lock_busted_write_lock,
 	.write_delay	= torture_lock_busted_write_delay,
 	.writeunlock	= torture_lock_busted_write_unlock,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "lock_busted"
 };
 
@@ -160,13 +166,13 @@ static void torture_spin_lock_write_delay(struct torture_random_state *trsp)
 	 * we want a long delay occasionally to force massive contention.
 	 */
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2000 * longdelay_us)))
+	      (cxt.nrealwriters_stress * 2000 * longdelay_us)))
 		mdelay(longdelay_us);
 	if (!(torture_random(trsp) %
-	      (nrealwriters_stress * 2 * shortdelay_us)))
+	      (cxt.nrealwriters_stress * 2 * shortdelay_us)))
 		udelay(shortdelay_us);
 #ifdef CONFIG_PREEMPT
-	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
 		preempt_schedule();  /* Allow test to be preempted. */
 #endif
 }
@@ -180,39 +186,253 @@ static struct lock_torture_ops spin_lock_ops = {
 	.writelock	= torture_spin_lock_write_lock,
 	.write_delay	= torture_spin_lock_write_delay,
 	.writeunlock	= torture_spin_lock_write_unlock,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "spin_lock"
 };
 
 static int torture_spin_lock_write_lock_irq(void)
-__acquires(torture_spinlock_irq)
+__acquires(torture_spinlock)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&torture_spinlock, flags);
-	cur_ops->flags = flags;
+	cxt.cur_ops->flags = flags;
 	return 0;
 }
 
 static void torture_lock_spin_write_unlock_irq(void)
 __releases(torture_spinlock)
 {
-	spin_unlock_irqrestore(&torture_spinlock, cur_ops->flags);
+	spin_unlock_irqrestore(&torture_spinlock, cxt.cur_ops->flags);
 }
 
 static struct lock_torture_ops spin_lock_irq_ops = {
 	.writelock	= torture_spin_lock_write_lock_irq,
 	.write_delay	= torture_spin_lock_write_delay,
 	.writeunlock	= torture_lock_spin_write_unlock_irq,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
 	.name		= "spin_lock_irq"
 };
 
+static DEFINE_RWLOCK(torture_rwlock);
+
+static int torture_rwlock_write_lock(void) __acquires(torture_rwlock)
+{
+	write_lock(&torture_rwlock);
+	return 0;
+}
+
+static void torture_rwlock_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long shortdelay_us = 2;
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a short delay mostly to emulate likely code, and
+	 * we want a long delay occasionally to force massive contention.
+	 */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms);
+	else
+		udelay(shortdelay_us);
+}
+
+static void torture_rwlock_write_unlock(void) __releases(torture_rwlock)
+{
+	write_unlock(&torture_rwlock);
+}
+
+static int torture_rwlock_read_lock(void) __acquires(torture_rwlock)
+{
+	read_lock(&torture_rwlock);
+	return 0;
+}
+
+static void torture_rwlock_read_delay(struct torture_random_state *trsp)
+{
+	const unsigned long shortdelay_us = 10;
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a short delay mostly to emulate likely code, and
+	 * we want a long delay occasionally to force massive contention.
+	 */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealreaders_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms);
+	else
+		udelay(shortdelay_us);
+}
+
+static void torture_rwlock_read_unlock(void) __releases(torture_rwlock)
+{
+	read_unlock(&torture_rwlock);
+}
+
+static struct lock_torture_ops rw_lock_ops = {
+	.writelock	= torture_rwlock_write_lock,
+	.write_delay	= torture_rwlock_write_delay,
+	.writeunlock	= torture_rwlock_write_unlock,
+	.readlock       = torture_rwlock_read_lock,
+	.read_delay     = torture_rwlock_read_delay,
+	.readunlock     = torture_rwlock_read_unlock,
+	.name		= "rw_lock"
+};
+
+static int torture_rwlock_write_lock_irq(void) __acquires(torture_rwlock)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&torture_rwlock, flags);
+	cxt.cur_ops->flags = flags;
+	return 0;
+}
+
+static void torture_rwlock_write_unlock_irq(void)
+__releases(torture_rwlock)
+{
+	write_unlock_irqrestore(&torture_rwlock, cxt.cur_ops->flags);
+}
+
+static int torture_rwlock_read_lock_irq(void) __acquires(torture_rwlock)
+{
+	unsigned long flags;
+
+	read_lock_irqsave(&torture_rwlock, flags);
+	cxt.cur_ops->flags = flags;
+	return 0;
+}
+
+static void torture_rwlock_read_unlock_irq(void)
+__releases(torture_rwlock)
+{
+	write_unlock_irqrestore(&torture_rwlock, cxt.cur_ops->flags);
+}
+
+static struct lock_torture_ops rw_lock_irq_ops = {
+	.writelock	= torture_rwlock_write_lock_irq,
+	.write_delay	= torture_rwlock_write_delay,
+	.writeunlock	= torture_rwlock_write_unlock_irq,
+	.readlock       = torture_rwlock_read_lock_irq,
+	.read_delay     = torture_rwlock_read_delay,
+	.readunlock     = torture_rwlock_read_unlock_irq,
+	.name		= "rw_lock_irq"
+};
+
+static DEFINE_MUTEX(torture_mutex);
+
+static int torture_mutex_lock(void) __acquires(torture_mutex)
+{
+	mutex_lock(&torture_mutex);
+	return 0;
+}
+
+static void torture_mutex_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms * 5);
+	else
+		mdelay(longdelay_ms / 5);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_mutex_unlock(void) __releases(torture_mutex)
+{
+	mutex_unlock(&torture_mutex);
+}
+
+static struct lock_torture_ops mutex_lock_ops = {
+	.writelock	= torture_mutex_lock,
+	.write_delay	= torture_mutex_delay,
+	.writeunlock	= torture_mutex_unlock,
+	.readlock       = NULL,
+	.read_delay     = NULL,
+	.readunlock     = NULL,
+	.name		= "mutex_lock"
+};
+
+static DECLARE_RWSEM(torture_rwsem);
+static int torture_rwsem_down_write(void) __acquires(torture_rwsem)
+{
+	down_write(&torture_rwsem);
+	return 0;
+}
+
+static void torture_rwsem_write_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms * 10);
+	else
+		mdelay(longdelay_ms / 10);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (cxt.nrealwriters_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_rwsem_up_write(void) __releases(torture_rwsem)
+{
+	up_write(&torture_rwsem);
+}
+
+static int torture_rwsem_down_read(void) __acquires(torture_rwsem)
+{
+	down_read(&torture_rwsem);
+	return 0;
+}
+
+static void torture_rwsem_read_delay(struct torture_random_state *trsp)
+{
+	const unsigned long longdelay_ms = 100;
+
+	/* We want a long delay occasionally to force massive contention.  */
+	if (!(torture_random(trsp) %
+	      (cxt.nrealwriters_stress * 2000 * longdelay_ms)))
+		mdelay(longdelay_ms * 2);
+	else
+		mdelay(longdelay_ms / 2);
+#ifdef CONFIG_PREEMPT
+	if (!(torture_random(trsp) % (cxt.nrealreaders_stress * 20000)))
+		preempt_schedule();  /* Allow test to be preempted. */
+#endif
+}
+
+static void torture_rwsem_up_read(void) __releases(torture_rwsem)
+{
+	up_read(&torture_rwsem);
+}
+
+static struct lock_torture_ops rwsem_lock_ops = {
+	.writelock	= torture_rwsem_down_write,
+	.write_delay	= torture_rwsem_write_delay,
+	.writeunlock	= torture_rwsem_up_write,
+	.readlock       = torture_rwsem_down_read,
+	.read_delay     = torture_rwsem_read_delay,
+	.readunlock     = torture_rwsem_up_read,
+	.name		= "rwsem_lock"
+};
+
 /*
  * Lock torture writer kthread.  Repeatedly acquires and releases
  * the lock, checking for duplicate acquisitions.
  */
 static int lock_torture_writer(void *arg)
 {
-	struct lock_writer_stress_stats *lwsp = arg;
+	struct lock_stress_stats *lwsp = arg;
 	static DEFINE_TORTURE_RANDOM(rand);
 
 	VERBOSE_TOROUT_STRING("lock_torture_writer task started");
@@ -221,14 +441,19 @@ static int lock_torture_writer(void *arg)
 	do {
 		if ((torture_random(&rand) & 0xfffff) == 0)
 			schedule_timeout_uninterruptible(1);
-		cur_ops->writelock();
+
+		cxt.cur_ops->writelock();
 		if (WARN_ON_ONCE(lock_is_write_held))
-			lwsp->n_write_lock_fail++;
+			lwsp->n_lock_fail++;
 		lock_is_write_held = 1;
-		lwsp->n_write_lock_acquired++;
-		cur_ops->write_delay(&rand);
+		if (WARN_ON_ONCE(lock_is_read_held))
+			lwsp->n_lock_fail++; /* rare, but... */
+
+		lwsp->n_lock_acquired++;
+		cxt.cur_ops->write_delay(&rand);
 		lock_is_write_held = 0;
-		cur_ops->writeunlock();
+		cxt.cur_ops->writeunlock();
+
 		stutter_wait("lock_torture_writer");
 	} while (!torture_must_stop());
 	torture_kthread_stopping("lock_torture_writer");
@@ -236,32 +461,66 @@ static int lock_torture_writer(void *arg)
 }
 
 /*
+ * Lock torture reader kthread.  Repeatedly acquires and releases
+ * the reader lock.
+ */
+static int lock_torture_reader(void *arg)
+{
+	struct lock_stress_stats *lrsp = arg;
+	static DEFINE_TORTURE_RANDOM(rand);
+
+	VERBOSE_TOROUT_STRING("lock_torture_reader task started");
+	set_user_nice(current, MAX_NICE);
+
+	do {
+		if ((torture_random(&rand) & 0xfffff) == 0)
+			schedule_timeout_uninterruptible(1);
+
+		cxt.cur_ops->readlock();
+		lock_is_read_held = 1;
+		if (WARN_ON_ONCE(lock_is_write_held))
+			lrsp->n_lock_fail++; /* rare, but... */
+
+		lrsp->n_lock_acquired++;
+		cxt.cur_ops->read_delay(&rand);
+		lock_is_read_held = 0;
+		cxt.cur_ops->readunlock();
+
+		stutter_wait("lock_torture_reader");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("lock_torture_reader");
+	return 0;
+}
+
+/*
  * Create an lock-torture-statistics message in the specified buffer.
  */
-static void lock_torture_printk(char *page)
+static void __torture_print_stats(char *page,
+				  struct lock_stress_stats *statp, bool write)
 {
 	bool fail = 0;
-	int i;
+	int i, n_stress;
 	long max = 0;
-	long min = lwsa[0].n_write_lock_acquired;
+	long min = statp[0].n_lock_acquired;
 	long long sum = 0;
 
-	for (i = 0; i < nrealwriters_stress; i++) {
-		if (lwsa[i].n_write_lock_fail)
+	n_stress = write ? cxt.nrealwriters_stress : cxt.nrealreaders_stress;
+	for (i = 0; i < n_stress; i++) {
+		if (statp[i].n_lock_fail)
 			fail = true;
-		sum += lwsa[i].n_write_lock_acquired;
-		if (max < lwsa[i].n_write_lock_fail)
-			max = lwsa[i].n_write_lock_fail;
-		if (min > lwsa[i].n_write_lock_fail)
-			min = lwsa[i].n_write_lock_fail;
+		sum += statp[i].n_lock_acquired;
+		if (max < statp[i].n_lock_fail)
+			max = statp[i].n_lock_fail;
+		if (min > statp[i].n_lock_fail)
+			min = statp[i].n_lock_fail;
 	}
-	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
 	page += sprintf(page,
-			"Writes:  Total: %lld  Max/Min: %ld/%ld %s  Fail: %d %s\n",
+			"%s:  Total: %lld  Max/Min: %ld/%ld %s  Fail: %d %s\n",
+			write ? "Writes" : "Reads ",
 			sum, max, min, max / 2 > min ? "???" : "",
 			fail, fail ? "!!!" : "");
 	if (fail)
-		atomic_inc(&n_lock_torture_errors);
+		atomic_inc(&cxt.n_lock_torture_errors);
 }
 
 /*
@@ -274,18 +533,35 @@ static void lock_torture_printk(char *page)
  */
 static void lock_torture_stats_print(void)
 {
-	int size = nrealwriters_stress * 200 + 8192;
+	int size = cxt.nrealwriters_stress * 200 + 8192;
 	char *buf;
 
+	if (cxt.cur_ops->readlock)
+		size += cxt.nrealreaders_stress * 200 + 8192;
+
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf) {
 		pr_err("lock_torture_stats_print: Out of memory, need: %d",
 		       size);
 		return;
 	}
-	lock_torture_printk(buf);
+
+	__torture_print_stats(buf, cxt.lwsa, true);
 	pr_alert("%s", buf);
 	kfree(buf);
+
+	if (cxt.cur_ops->readlock) {
+		buf = kmalloc(size, GFP_KERNEL);
+		if (!buf) {
+			pr_err("lock_torture_stats_print: Out of memory, need: %d",
+			       size);
+			return;
+		}
+
+		__torture_print_stats(buf, cxt.lrsa, false);
+		pr_alert("%s", buf);
+		kfree(buf);
+	}
 }
 
 /*
@@ -312,9 +588,10 @@ lock_torture_print_module_parms(struct lock_torture_ops *cur_ops,
 				const char *tag)
 {
 	pr_alert("%s" TORTURE_FLAG
-		 "--- %s: nwriters_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
-		 torture_type, tag, nrealwriters_stress, stat_interval, verbose,
-		 shuffle_interval, stutter, shutdown_secs,
+		 "--- %s%s: nwriters_stress=%d nreaders_stress=%d stat_interval=%d verbose=%d shuffle_interval=%d stutter=%d shutdown_secs=%d onoff_interval=%d onoff_holdoff=%d\n",
+		 torture_type, tag, cxt.debug_lock ? " [debug]": "",
+		 cxt.nrealwriters_stress, cxt.nrealreaders_stress, stat_interval,
+		 verbose, shuffle_interval, stutter, shutdown_secs,
 		 onoff_interval, onoff_holdoff);
 }
 
@@ -322,46 +599,59 @@ static void lock_torture_cleanup(void)
 {
 	int i;
 
-	if (torture_cleanup())
+	if (torture_cleanup_begin())
 		return;
 
 	if (writer_tasks) {
-		for (i = 0; i < nrealwriters_stress; i++)
+		for (i = 0; i < cxt.nrealwriters_stress; i++)
 			torture_stop_kthread(lock_torture_writer,
 					     writer_tasks[i]);
 		kfree(writer_tasks);
 		writer_tasks = NULL;
 	}
 
+	if (reader_tasks) {
+		for (i = 0; i < cxt.nrealreaders_stress; i++)
+			torture_stop_kthread(lock_torture_reader,
+					     reader_tasks[i]);
+		kfree(reader_tasks);
+		reader_tasks = NULL;
+	}
+
 	torture_stop_kthread(lock_torture_stats, stats_task);
 	lock_torture_stats_print();  /* -After- the stats thread is stopped! */
 
-	if (atomic_read(&n_lock_torture_errors))
-		lock_torture_print_module_parms(cur_ops,
+	if (atomic_read(&cxt.n_lock_torture_errors))
+		lock_torture_print_module_parms(cxt.cur_ops,
 						"End of test: FAILURE");
 	else if (torture_onoff_failures())
-		lock_torture_print_module_parms(cur_ops,
+		lock_torture_print_module_parms(cxt.cur_ops,
 						"End of test: LOCK_HOTPLUG");
 	else
-		lock_torture_print_module_parms(cur_ops,
+		lock_torture_print_module_parms(cxt.cur_ops,
 						"End of test: SUCCESS");
+	torture_cleanup_end();
 }
 
 static int __init lock_torture_init(void)
 {
-	int i;
+	int i, j;
 	int firsterr = 0;
 	static struct lock_torture_ops *torture_ops[] = {
-		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
+		&lock_busted_ops,
+		&spin_lock_ops, &spin_lock_irq_ops,
+		&rw_lock_ops, &rw_lock_irq_ops,
+		&mutex_lock_ops,
+		&rwsem_lock_ops,
 	};
 
-	if (!torture_init_begin(torture_type, verbose, &locktorture_runnable))
+	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
 		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
-		cur_ops = torture_ops[i];
-		if (strcmp(torture_type, cur_ops->name) == 0)
+		cxt.cur_ops = torture_ops[i];
+		if (strcmp(torture_type, cxt.cur_ops->name) == 0)
 			break;
 	}
 	if (i == ARRAY_SIZE(torture_ops)) {
@@ -374,31 +664,69 @@ static int __init lock_torture_init(void)
 		torture_init_end();
 		return -EINVAL;
 	}
-	if (cur_ops->init)
-		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
+	if (cxt.cur_ops->init)
+		cxt.cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
 	if (nwriters_stress >= 0)
-		nrealwriters_stress = nwriters_stress;
+		cxt.nrealwriters_stress = nwriters_stress;
 	else
-		nrealwriters_stress = 2 * num_online_cpus();
-	lock_torture_print_module_parms(cur_ops, "Start of test");
+		cxt.nrealwriters_stress = 2 * num_online_cpus();
+
+#ifdef CONFIG_DEBUG_MUTEXES
+	if (strncmp(torture_type, "mutex", 5) == 0)
+		cxt.debug_lock = true;
+#endif
+#ifdef CONFIG_DEBUG_SPINLOCK
+	if ((strncmp(torture_type, "spin", 4) == 0) ||
+	    (strncmp(torture_type, "rw_lock", 7) == 0))
+		cxt.debug_lock = true;
+#endif
 
 	/* Initialize the statistics so that each run gets its own numbers. */
 
 	lock_is_write_held = 0;
-	lwsa = kmalloc(sizeof(*lwsa) * nrealwriters_stress, GFP_KERNEL);
-	if (lwsa == NULL) {
-		VERBOSE_TOROUT_STRING("lwsa: Out of memory");
+	cxt.lwsa = kmalloc(sizeof(*cxt.lwsa) * cxt.nrealwriters_stress, GFP_KERNEL);
+	if (cxt.lwsa == NULL) {
+		VERBOSE_TOROUT_STRING("cxt.lwsa: Out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
-	for (i = 0; i < nrealwriters_stress; i++) {
-		lwsa[i].n_write_lock_fail = 0;
-		lwsa[i].n_write_lock_acquired = 0;
+	for (i = 0; i < cxt.nrealwriters_stress; i++) {
+		cxt.lwsa[i].n_lock_fail = 0;
+		cxt.lwsa[i].n_lock_acquired = 0;
 	}
 
-	/* Start up the kthreads. */
+	if (cxt.cur_ops->readlock) {
+		if (nreaders_stress >= 0)
+			cxt.nrealreaders_stress = nreaders_stress;
+		else {
+			/*
+			 * By default distribute evenly the number of
+			 * readers and writers. We still run the same number
+			 * of threads as the writer-only locks default.
+			 */
+			if (nwriters_stress < 0) /* user doesn't care */
+				cxt.nrealwriters_stress = num_online_cpus();
+			cxt.nrealreaders_stress = cxt.nrealwriters_stress;
+		}
+
+		lock_is_read_held = 0;
+		cxt.lrsa = kmalloc(sizeof(*cxt.lrsa) * cxt.nrealreaders_stress, GFP_KERNEL);
+		if (cxt.lrsa == NULL) {
+			VERBOSE_TOROUT_STRING("cxt.lrsa: Out of memory");
+			firsterr = -ENOMEM;
+			kfree(cxt.lwsa);
+			goto unwind;
+		}
+
+		for (i = 0; i < cxt.nrealreaders_stress; i++) {
+			cxt.lrsa[i].n_lock_fail = 0;
+			cxt.lrsa[i].n_lock_acquired = 0;
+		}
+	}
+	lock_torture_print_module_parms(cxt.cur_ops, "Start of test");
 
+	/* Prepare torture context. */
 	if (onoff_interval > 0) {
 		firsterr = torture_onoff_init(onoff_holdoff * HZ,
 					      onoff_interval * HZ);
@@ -422,18 +750,51 @@ static int __init lock_torture_init(void)
 			goto unwind;
 	}
 
-	writer_tasks = kzalloc(nrealwriters_stress * sizeof(writer_tasks[0]),
+	writer_tasks = kzalloc(cxt.nrealwriters_stress * sizeof(writer_tasks[0]),
 			       GFP_KERNEL);
 	if (writer_tasks == NULL) {
 		VERBOSE_TOROUT_ERRSTRING("writer_tasks: Out of memory");
 		firsterr = -ENOMEM;
 		goto unwind;
 	}
-	for (i = 0; i < nrealwriters_stress; i++) {
-		firsterr = torture_create_kthread(lock_torture_writer, &lwsa[i],
+
+	if (cxt.cur_ops->readlock) {
+		reader_tasks = kzalloc(cxt.nrealreaders_stress * sizeof(reader_tasks[0]),
+				       GFP_KERNEL);
+		if (reader_tasks == NULL) {
+			VERBOSE_TOROUT_ERRSTRING("reader_tasks: Out of memory");
+			firsterr = -ENOMEM;
+			goto unwind;
+		}
+	}
+
+	/*
+	 * Create the kthreads and start torturing (oh, those poor little locks).
+	 *
+	 * TODO: Note that we interleave writers with readers, giving writers a
+	 * slight advantage, by creating its kthread first. This can be modified
+	 * for very specific needs, or even let the user choose the policy, if
+	 * ever wanted.
+	 */
+	for (i = 0, j = 0; i < cxt.nrealwriters_stress ||
+		    j < cxt.nrealreaders_stress; i++, j++) {
+		if (i >= cxt.nrealwriters_stress)
+			goto create_reader;
+
+		/* Create writer. */
+		firsterr = torture_create_kthread(lock_torture_writer, &cxt.lwsa[i],
 						  writer_tasks[i]);
 		if (firsterr)
 			goto unwind;
+
+	create_reader:
+		if (cxt.cur_ops->readlock == NULL || (j >= cxt.nrealreaders_stress))
+			continue;
+		/* Create reader. */
+		firsterr = torture_create_kthread(lock_torture_reader, &cxt.lrsa[j],
+						  reader_tasks[j]);
+		if (firsterr)
+			goto unwind;
 	}
 	if (stat_interval > 0) {
 		firsterr = torture_create_kthread(lock_torture_stats, NULL,
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 948a7693748e..240fa9094f83 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -49,11 +49,19 @@
 #include <linux/trace_clock.h>
 #include <asm/byteorder.h>
 #include <linux/torture.h>
+#include <linux/vmalloc.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@joshtriplett.org>");
 
 
+torture_param(int, cbflood_inter_holdoff, HZ,
+	      "Holdoff between floods (jiffies)");
+torture_param(int, cbflood_intra_holdoff, 1,
+	      "Holdoff between bursts (jiffies)");
+torture_param(int, cbflood_n_burst, 3, "# bursts in flood, zero to disable");
+torture_param(int, cbflood_n_per_burst, 20000,
+	      "# callbacks per burst in flood");
 torture_param(int, fqs_duration, 0,
 	      "Duration of fqs bursts (us), 0 to disable");
 torture_param(int, fqs_holdoff, 0, "Holdoff time within fqs bursts (us)");
@@ -96,10 +104,12 @@ module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
 
 static int nrealreaders;
+static int ncbflooders;
 static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
 static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
+static struct task_struct **cbflood_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
 static struct task_struct *stall_task;
@@ -138,6 +148,7 @@ static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
 static long n_barrier_attempts;
 static long n_barrier_successes;
+static atomic_long_t n_cbfloods;
 static struct list_head rcu_torture_removed;
 
 static int rcu_torture_writer_state;
@@ -157,9 +168,9 @@ static int rcu_torture_writer_state;
 #else
 #define RCUTORTURE_RUNNABLE_INIT 0
 #endif
-int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
-module_param(rcutorture_runnable, int, 0444);
-MODULE_PARM_DESC(rcutorture_runnable, "Start rcutorture at boot");
+static int torture_runnable = RCUTORTURE_RUNNABLE_INIT;
+module_param(torture_runnable, int, 0444);
+MODULE_PARM_DESC(torture_runnable, "Start rcutorture at boot");
 
 #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU)
 #define rcu_can_boost() 1
@@ -182,7 +193,7 @@ static u64 notrace rcu_trace_clock_local(void)
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
-DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+static DEFINE_MUTEX(boost_mutex);	/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
 static atomic_t barrier_cbs_count;	/* Barrier callbacks registered. */
 static bool barrier_phase;		/* Test phase. */
@@ -242,7 +253,7 @@ struct rcu_torture_ops {
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
-	void (*stats)(char *page);
+	void (*stats)(void);
 	int irq_capable;
 	int can_boost;
 	const char *name;
@@ -525,21 +536,21 @@ static void srcu_torture_barrier(void)
 	srcu_barrier(&srcu_ctl);
 }
 
-static void srcu_torture_stats(char *page)
+static void srcu_torture_stats(void)
 {
 	int cpu;
 	int idx = srcu_ctl.completed & 0x1;
 
-	page += sprintf(page, "%s%s per-CPU(idx=%d):",
-		       torture_type, TORTURE_FLAG, idx);
+	pr_alert("%s%s per-CPU(idx=%d):",
+		 torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
 		long c0, c1;
 
 		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
 		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
-		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
+		pr_cont(" %d(%ld,%ld)", cpu, c0, c1);
 	}
-	sprintf(page, "\n");
+	pr_cont("\n");
 }
 
 static void srcu_torture_synchronize_expedited(void)
@@ -601,6 +612,52 @@ static struct rcu_torture_ops sched_ops = {
 	.name		= "sched"
 };
 
+#ifdef CONFIG_TASKS_RCU
+
+/*
+ * Definitions for RCU-tasks torture testing.
+ */
+
+static int tasks_torture_read_lock(void)
+{
+	return 0;
+}
+
+static void tasks_torture_read_unlock(int idx)
+{
+}
+
+static void rcu_tasks_torture_deferred_free(struct rcu_torture *p)
+{
+	call_rcu_tasks(&p->rtort_rcu, rcu_torture_cb);
+}
+
+static struct rcu_torture_ops tasks_ops = {
+	.ttype		= RCU_TASKS_FLAVOR,
+	.init		= rcu_sync_torture_init,
+	.readlock	= tasks_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= tasks_torture_read_unlock,
+	.completed	= rcu_no_completed,
+	.deferred_free	= rcu_tasks_torture_deferred_free,
+	.sync		= synchronize_rcu_tasks,
+	.exp_sync	= synchronize_rcu_tasks,
+	.call		= call_rcu_tasks,
+	.cb_barrier	= rcu_barrier_tasks,
+	.fqs		= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "tasks"
+};
+
+#define RCUTORTURE_TASKS_OPS &tasks_ops,
+
+#else /* #ifdef CONFIG_TASKS_RCU */
+
+#define RCUTORTURE_TASKS_OPS
+
+#endif /* #else #ifdef CONFIG_TASKS_RCU */
+
 /*
  * RCU torture priority-boost testing.  Runs one real-time thread per
  * CPU for moderate bursts, repeatedly registering RCU callbacks and
@@ -667,7 +724,7 @@ static int rcu_torture_boost(void *arg)
 				}
 				call_rcu_time = jiffies;
 			}
-			cond_resched();
+			cond_resched_rcu_qs();
 			stutter_wait("rcu_torture_boost");
 			if (torture_must_stop())
 				goto checkwait;
@@ -707,6 +764,58 @@ checkwait:	stutter_wait("rcu_torture_boost");
 	return 0;
 }
 
+static void rcu_torture_cbflood_cb(struct rcu_head *rhp)
+{
+}
+
+/*
+ * RCU torture callback-flood kthread.  Repeatedly induces bursts of calls
+ * to call_rcu() or analogous, increasing the probability of occurrence
+ * of callback-overflow corner cases.
+ */
+static int
+rcu_torture_cbflood(void *arg)
+{
+	int err = 1;
+	int i;
+	int j;
+	struct rcu_head *rhp;
+
+	if (cbflood_n_per_burst > 0 &&
+	    cbflood_inter_holdoff > 0 &&
+	    cbflood_intra_holdoff > 0 &&
+	    cur_ops->call &&
+	    cur_ops->cb_barrier) {
+		rhp = vmalloc(sizeof(*rhp) *
+			      cbflood_n_burst * cbflood_n_per_burst);
+		err = !rhp;
+	}
+	if (err) {
+		VERBOSE_TOROUT_STRING("rcu_torture_cbflood disabled: Bad args or OOM");
+		while (!torture_must_stop())
+			schedule_timeout_interruptible(HZ);
+		return 0;
+	}
+	VERBOSE_TOROUT_STRING("rcu_torture_cbflood task started");
+	do {
+		schedule_timeout_interruptible(cbflood_inter_holdoff);
+		atomic_long_inc(&n_cbfloods);
+		WARN_ON(signal_pending(current));
+		for (i = 0; i < cbflood_n_burst; i++) {
+			for (j = 0; j < cbflood_n_per_burst; j++) {
+				cur_ops->call(&rhp[i * cbflood_n_per_burst + j],
+					      rcu_torture_cbflood_cb);
+			}
+			schedule_timeout_interruptible(cbflood_intra_holdoff);
+			WARN_ON(signal_pending(current));
+		}
+		cur_ops->cb_barrier();
+		stutter_wait("rcu_torture_cbflood");
+	} while (!torture_must_stop());
+	torture_kthread_stopping("rcu_torture_cbflood");
+	return 0;
+}
+
 /*
  * RCU torture force-quiescent-state kthread.  Repeatedly induces
  * bursts of calls to force_quiescent_state(), increasing the probability
@@ -1019,7 +1128,7 @@ rcu_torture_reader(void *arg)
 		__this_cpu_inc(rcu_torture_batch[completed]);
 		preempt_enable();
 		cur_ops->readunlock(idx);
-		cond_resched();
+		cond_resched_rcu_qs();
 		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
 	if (irqreader && cur_ops->irq_capable) {
@@ -1031,10 +1140,15 @@ rcu_torture_reader(void *arg)
 }
 
 /*
- * Create an RCU-torture statistics message in the specified buffer.
+ * Print torture statistics.  Caller must ensure that there is only
+ * one call to this function at a given time!!!  This is normally
+ * accomplished by relying on the module system to only have one copy
+ * of the module loaded, and then by giving the rcu_torture_stats
+ * kthread full control (or the init/cleanup functions when rcu_torture_stats
+ * thread is not running).
  */
 static void
-rcu_torture_printk(char *page)
+rcu_torture_stats_print(void)
 {
 	int cpu;
 	int i;
@@ -1052,55 +1166,61 @@ rcu_torture_printk(char *page)
 		if (pipesummary[i] != 0)
 			break;
 	}
-	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page,
-		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
-		       rcu_torture_current,
-		       rcu_torture_current_version,
-		       list_empty(&rcu_torture_freelist),
-		       atomic_read(&n_rcu_torture_alloc),
-		       atomic_read(&n_rcu_torture_alloc_fail),
-		       atomic_read(&n_rcu_torture_free));
-	page += sprintf(page, "rtmbe: %d rtbke: %ld rtbre: %ld ",
-		       atomic_read(&n_rcu_torture_mberror),
-		       n_rcu_torture_boost_ktrerror,
-		       n_rcu_torture_boost_rterror);
-	page += sprintf(page, "rtbf: %ld rtb: %ld nt: %ld ",
-		       n_rcu_torture_boost_failure,
-		       n_rcu_torture_boosts,
-		       n_rcu_torture_timers);
-	page = torture_onoff_stats(page);
-	page += sprintf(page, "barrier: %ld/%ld:%ld",
-		       n_barrier_successes,
-		       n_barrier_attempts,
-		       n_rcu_torture_barrier_error);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
+
+	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
+	pr_cont("rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
+		rcu_torture_current,
+		rcu_torture_current_version,
+		list_empty(&rcu_torture_freelist),
+		atomic_read(&n_rcu_torture_alloc),
+		atomic_read(&n_rcu_torture_alloc_fail),
+		atomic_read(&n_rcu_torture_free));
+	pr_cont("rtmbe: %d rtbke: %ld rtbre: %ld ",
+		atomic_read(&n_rcu_torture_mberror),
+		n_rcu_torture_boost_ktrerror,
+		n_rcu_torture_boost_rterror);
+	pr_cont("rtbf: %ld rtb: %ld nt: %ld ",
+		n_rcu_torture_boost_failure,
+		n_rcu_torture_boosts,
+		n_rcu_torture_timers);
+	torture_onoff_stats();
+	pr_cont("barrier: %ld/%ld:%ld ",
+		n_barrier_successes,
+		n_barrier_attempts,
+		n_rcu_torture_barrier_error);
+	pr_cont("cbflood: %ld\n", atomic_long_read(&n_cbfloods));
+
+	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_barrier_error != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
 	    n_rcu_torture_boost_failure != 0 ||
 	    i > 1) {
-		page += sprintf(page, "!!! ");
+		pr_cont("%s", "!!! ");
 		atomic_inc(&n_rcu_torture_error);
 		WARN_ON_ONCE(1);
 	}
-	page += sprintf(page, "Reader Pipe: ");
+	pr_cont("Reader Pipe: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		page += sprintf(page, " %ld", pipesummary[i]);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page, "Reader Batch: ");
+		pr_cont(" %ld", pipesummary[i]);
+	pr_cont("\n");
+
+	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
+	pr_cont("Reader Batch: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		page += sprintf(page, " %ld", batchsummary[i]);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page, "Free-Block Circulation: ");
+		pr_cont(" %ld", batchsummary[i]);
+	pr_cont("\n");
+
+	pr_alert("%s%s ", torture_type, TORTURE_FLAG);
+	pr_cont("Free-Block Circulation: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
-		page += sprintf(page, " %d",
-			       atomic_read(&rcu_torture_wcount[i]));
+		pr_cont(" %d", atomic_read(&rcu_torture_wcount[i]));
 	}
-	page += sprintf(page, "\n");
+	pr_cont("\n");
+
 	if (cur_ops->stats)
-		cur_ops->stats(page);
+		cur_ops->stats();
 	if (rtcv_snap == rcu_torture_current_version &&
 	    rcu_torture_current != NULL) {
 		int __maybe_unused flags;
@@ -1109,10 +1229,9 @@ rcu_torture_printk(char *page)
 
 		rcutorture_get_gp_data(cur_ops->ttype,
 				       &flags, &gpnum, &completed);
-		page += sprintf(page,
-				"??? Writer stall state %d g%lu c%lu f%#x\n",
-				rcu_torture_writer_state,
-				gpnum, completed, flags);
+		pr_alert("??? Writer stall state %d g%lu c%lu f%#x\n",
+			 rcu_torture_writer_state,
+			 gpnum, completed, flags);
 		show_rcu_gp_kthreads();
 		rcutorture_trace_dump();
 	}
@@ -1120,30 +1239,6 @@ rcu_torture_printk(char *page)
 }
 
 /*
- * Print torture statistics.  Caller must ensure that there is only
- * one call to this function at a given time!!!  This is normally
- * accomplished by relying on the module system to only have one copy
- * of the module loaded, and then by giving the rcu_torture_stats
- * kthread full control (or the init/cleanup functions when rcu_torture_stats
- * thread is not running).
- */
-static void
-rcu_torture_stats_print(void)
-{
-	int size = nr_cpu_ids * 200 + 8192;
-	char *buf;
-
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf) {
-		pr_err("rcu-torture: Out of memory, need: %d", size);
-		return;
-	}
-	rcu_torture_printk(buf);
-	pr_alert("%s", buf);
-	kfree(buf);
-}
-
-/*
  * Periodically prints torture statistics, if periodic statistics printing
  * was specified via the stat_interval module parameter.
  */
@@ -1295,7 +1390,8 @@ static int rcu_torture_barrier_cbs(void *arg)
 		if (atomic_dec_and_test(&barrier_cbs_count))
 			wake_up(&barrier_wq);
 	} while (!torture_must_stop());
-	cur_ops->cb_barrier();
+	if (cur_ops->cb_barrier != NULL)
+		cur_ops->cb_barrier();
 	destroy_rcu_head_on_stack(&rcu);
 	torture_kthread_stopping("rcu_torture_barrier_cbs");
 	return 0;
@@ -1418,7 +1514,7 @@ rcu_torture_cleanup(void)
 	int i;
 
 	rcutorture_record_test_transition();
-	if (torture_cleanup()) {
+	if (torture_cleanup_begin()) {
 		if (cur_ops->cb_barrier != NULL)
 			cur_ops->cb_barrier();
 		return;
@@ -1447,6 +1543,8 @@ rcu_torture_cleanup(void)
 
 	torture_stop_kthread(rcu_torture_stats, stats_task);
 	torture_stop_kthread(rcu_torture_fqs, fqs_task);
+	for (i = 0; i < ncbflooders; i++)
+		torture_stop_kthread(rcu_torture_cbflood, cbflood_task[i]);
 	if ((test_boost == 1 && cur_ops->can_boost) ||
 	    test_boost == 2) {
 		unregister_cpu_notifier(&rcutorture_cpu_nb);
@@ -1468,6 +1566,7 @@ rcu_torture_cleanup(void)
 					       "End of test: RCU_HOTPLUG");
 	else
 		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
+	torture_cleanup_end();
 }
 
 #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
@@ -1534,9 +1633,10 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] = {
 		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
+		RCUTORTURE_TASKS_OPS
 	};
 
-	if (!torture_init_begin(torture_type, verbose, &rcutorture_runnable))
+	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
 		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
@@ -1693,6 +1793,24 @@ rcu_torture_init(void)
 		goto unwind;
 	if (object_debug)
 		rcu_test_debug_objects();
+	if (cbflood_n_burst > 0) {
+		/* Create the cbflood threads */
+		ncbflooders = (num_online_cpus() + 3) / 4;
+		cbflood_task = kcalloc(ncbflooders, sizeof(*cbflood_task),
+				       GFP_KERNEL);
+		if (!cbflood_task) {
+			VERBOSE_TOROUT_ERRSTRING("out of memory");
+			firsterr = -ENOMEM;
+			goto unwind;
+		}
+		for (i = 0; i < ncbflooders; i++) {
+			firsterr = torture_create_kthread(rcu_torture_cbflood,
+							  NULL,
+							  cbflood_task[i]);
+			if (firsterr)
+				goto unwind;
+		}
+	}
 	rcutorture_record_test_transition();
 	torture_init_end();
 	return 0;
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index d9efcc13008c..c0623fc47125 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -51,7 +51,7 @@ static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 #include "tiny_plugin.h"
 
-/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
+/* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcu/tree.c. */
 static void rcu_idle_enter_common(long long newval)
 {
 	if (newval) {
@@ -62,7 +62,7 @@ static void rcu_idle_enter_common(long long newval)
 	}
 	RCU_TRACE(trace_rcu_dyntick(TPS("Start"),
 				    rcu_dynticks_nesting, newval));
-	if (!is_idle_task(current)) {
+	if (IS_ENABLED(CONFIG_RCU_TRACE) && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick(TPS("Entry error: not idle task"),
@@ -72,7 +72,7 @@ static void rcu_idle_enter_common(long long newval)
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
-	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
+	rcu_sched_qs(); /* implies rcu_bh_inc() */
 	barrier();
 	rcu_dynticks_nesting = newval;
 }
@@ -114,7 +114,7 @@ void rcu_irq_exit(void)
 }
 EXPORT_SYMBOL_GPL(rcu_irq_exit);
 
-/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
+/* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcu/tree.c. */
 static void rcu_idle_exit_common(long long oldval)
 {
 	if (oldval) {
@@ -123,7 +123,7 @@ static void rcu_idle_exit_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick(TPS("End"), oldval, rcu_dynticks_nesting));
-	if (!is_idle_task(current)) {
+	if (IS_ENABLED(CONFIG_RCU_TRACE) && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick(TPS("Exit error: not idle task"),
@@ -217,7 +217,7 @@ static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
  * are at it, given that any rcu quiescent state is also an rcu_bh
  * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
  */
-void rcu_sched_qs(int cpu)
+void rcu_sched_qs(void)
 {
 	unsigned long flags;
 
@@ -231,7 +231,7 @@ void rcu_sched_qs(int cpu)
 /*
  * Record an rcu_bh quiescent state.
  */
-void rcu_bh_qs(int cpu)
+void rcu_bh_qs(void)
 {
 	unsigned long flags;
 
@@ -251,9 +251,11 @@ void rcu_check_callbacks(int cpu, int user)
 {
 	RCU_TRACE(check_cpu_stalls());
 	if (user || rcu_is_cpu_rrupt_from_idle())
-		rcu_sched_qs(cpu);
+		rcu_sched_qs();
 	else if (!in_softirq())
-		rcu_bh_qs(cpu);
+		rcu_bh_qs();
+	if (user)
+		rcu_note_voluntary_context_switch(current);
 }
 
 /*
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1b70cb6fbe3c..133e47223095 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -79,9 +79,18 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
  * the tracing userspace tools to be able to decipher the string
  * address to the matching string.
  */
-#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
+#ifdef CONFIG_TRACING
+# define DEFINE_RCU_TPS(sname) \
 static char sname##_varname[] = #sname; \
-static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
+static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
+# define RCU_STATE_NAME(sname) sname##_varname
+#else
+# define DEFINE_RCU_TPS(sname)
+# define RCU_STATE_NAME(sname) __stringify(sname)
+#endif
+
+#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
+DEFINE_RCU_TPS(sname) \
 struct rcu_state sname##_state = { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
@@ -93,7 +102,7 @@ struct rcu_state sname##_state = { \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
-	.name = sname##_varname, \
+	.name = RCU_STATE_NAME(sname), \
 	.abbr = sabbr, \
 }; \
 DEFINE_PER_CPU(struct rcu_data, sname##_data)
@@ -188,22 +197,24 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
  * one since the start of the grace period, this just sets a flag.
  * The caller must have disabled preemption.
  */
-void rcu_sched_qs(int cpu)
+void rcu_sched_qs(void)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
-
-	if (rdp->passed_quiesce == 0)
-		trace_rcu_grace_period(TPS("rcu_sched"), rdp->gpnum, TPS("cpuqs"));
-	rdp->passed_quiesce = 1;
+	if (!__this_cpu_read(rcu_sched_data.passed_quiesce)) {
+		trace_rcu_grace_period(TPS("rcu_sched"),
+				       __this_cpu_read(rcu_sched_data.gpnum),
+				       TPS("cpuqs"));
+		__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
+	}
 }
 
-void rcu_bh_qs(int cpu)
+void rcu_bh_qs(void)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-
-	if (rdp->passed_quiesce == 0)
-		trace_rcu_grace_period(TPS("rcu_bh"), rdp->gpnum, TPS("cpuqs"));
-	rdp->passed_quiesce = 1;
+	if (!__this_cpu_read(rcu_bh_data.passed_quiesce)) {
+		trace_rcu_grace_period(TPS("rcu_bh"),
+				       __this_cpu_read(rcu_bh_data.gpnum),
+				       TPS("cpuqs"));
+		__this_cpu_write(rcu_bh_data.passed_quiesce, 1);
+	}
 }
 
 static DEFINE_PER_CPU(int, rcu_sched_qs_mask);
@@ -278,7 +289,7 @@ static void rcu_momentary_dyntick_idle(void)
 void rcu_note_context_switch(int cpu)
 {
 	trace_rcu_utilization(TPS("Start context switch"));
-	rcu_sched_qs(cpu);
+	rcu_sched_qs();
 	rcu_preempt_note_context_switch(cpu);
 	if (unlikely(raw_cpu_read(rcu_sched_qs_mask)))
 		rcu_momentary_dyntick_idle();
@@ -526,6 +537,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	rcu_dynticks_task_enter();
 
 	/*
 	 * It is illegal to enter an extended quiescent state while
@@ -642,6 +654,7 @@ void rcu_irq_exit(void)
 static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 			       int user)
 {
+	rcu_dynticks_task_exit();
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
@@ -819,7 +832,7 @@ bool notrace __rcu_is_watching(void)
  */
 bool notrace rcu_is_watching(void)
 {
-	int ret;
+	bool ret;
 
 	preempt_disable();
 	ret = __rcu_is_watching();
@@ -1647,7 +1660,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->level, rnp->grplo,
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 
 	mutex_unlock(&rsp->onoff_mutex);
@@ -1668,7 +1681,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
 		if (is_sysidle_rcu_state(rsp)) {
-			isidle = 1;
+			isidle = true;
 			maxj = jiffies - ULONG_MAX / 4;
 		}
 		force_qs_rnp(rsp, dyntick_save_progress_counter,
@@ -1677,14 +1690,15 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 		fqs_state = RCU_FORCE_QS;
 	} else {
 		/* Handle dyntick-idle and offline CPUs. */
-		isidle = 0;
+		isidle = false;
 		force_qs_rnp(rsp, rcu_implicit_dynticks_qs, &isidle, &maxj);
 	}
 	/* Clear flag to prevent immediate re-entry. */
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
 		smp_mb__after_unlock_lock();
-		ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
+		ACCESS_ONCE(rsp->gp_flags) =
+			ACCESS_ONCE(rsp->gp_flags) & ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
 	return fqs_state;
@@ -1736,7 +1750,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
@@ -1785,8 +1799,8 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
-			cond_resched();
-			flush_signals(current);
+			cond_resched_rcu_qs();
+			WARN_ON(signal_pending(current));
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
 					       TPS("reqwaitsig"));
@@ -1828,11 +1842,11 @@ static int __noreturn rcu_gp_kthread(void *arg)
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
 						       TPS("fqsend"));
-				cond_resched();
+				cond_resched_rcu_qs();
 			} else {
 				/* Deal with stray signal. */
-				cond_resched();
-				flush_signals(current);
+				cond_resched_rcu_qs();
+				WARN_ON(signal_pending(current));
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
 						       TPS("fqswaitsig"));
@@ -1928,7 +1942,7 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 {
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 	raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
@@ -2210,8 +2224,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
 	/* Adjust any no-longer-needed kthreads. */
 	rcu_boost_kthread_setaffinity(rnp, -1);
 
-	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
-
 	/* Exclude any attempts to start a new grace period. */
 	mutex_lock(&rsp->onoff_mutex);
 	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
@@ -2393,8 +2405,8 @@ void rcu_check_callbacks(int cpu, int user)
 		 * at least not while the corresponding CPU is online.
 		 */
 
-		rcu_sched_qs(cpu);
-		rcu_bh_qs(cpu);
+		rcu_sched_qs();
+		rcu_bh_qs();
 
 	} else if (!in_softirq()) {
 
@@ -2405,11 +2417,13 @@ void rcu_check_callbacks(int cpu, int user)
 		 * critical section, so note it.
 		 */
 
-		rcu_bh_qs(cpu);
+		rcu_bh_qs();
 	}
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
 		invoke_rcu_core();
+	if (user)
+		rcu_note_voluntary_context_switch(current);
 	trace_rcu_utilization(TPS("End scheduler-tick"));
 }
 
@@ -2432,7 +2446,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
-		cond_resched();
+		cond_resched_rcu_qs();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
@@ -2449,7 +2463,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
 			if ((rnp->qsmask & bit) != 0) {
 				if ((rnp->qsmaskinit & bit) != 0)
-					*isidle = 0;
+					*isidle = false;
 				if (f(per_cpu_ptr(rsp->rda, cpu), isidle, maxj))
 					mask |= bit;
 			}
@@ -2505,9 +2519,10 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
-	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
+	ACCESS_ONCE(rsp->gp_flags) =
+		ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
-	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
@@ -2925,11 +2940,6 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
  * restructure your code to batch your updates, and then use a single
  * synchronize_sched() instead.
  *
- * Note that it is illegal to call this function while holding any lock
- * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
- * to call this function from a CPU-hotplug notifier.  Failing to observe
- * these restriction will result in deadlock.
- *
  * This implementation can be thought of as an application of ticket
  * locking to RCU, with sync_sched_expedited_started and
  * sync_sched_expedited_done taking on the roles of the halves
@@ -2979,7 +2989,12 @@ void synchronize_sched_expedited(void)
 	 */
 	snap = atomic_long_inc_return(&rsp->expedited_start);
 	firstsnap = snap;
-	get_online_cpus();
+	if (!try_get_online_cpus()) {
+		/* CPU hotplug operation in flight, fall back to normal GP. */
+		wait_rcu_gp(call_rcu_sched);
+		atomic_long_inc(&rsp->expedited_normal);
+		return;
+	}
 	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
 
 	/*
@@ -3026,7 +3041,12 @@ void synchronize_sched_expedited(void)
 		 * and they started after our first try, so their grace
 		 * period works for us.
 		 */
-		get_online_cpus();
+		if (!try_get_online_cpus()) {
+			/* CPU hotplug operation in flight, use normal GP. */
+			wait_rcu_gp(call_rcu_sched);
+			atomic_long_inc(&rsp->expedited_normal);
+			return;
+		}
 		snap = atomic_long_read(&rsp->expedited_start);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
@@ -3442,6 +3462,7 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	case CPU_UP_PREPARE_FROZEN:
 		rcu_prepare_cpu(cpu);
 		rcu_prepare_kthreads(cpu);
+		rcu_spawn_all_nocb_kthreads(cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -3489,7 +3510,7 @@ static int rcu_pm_notify(struct notifier_block *self,
 }
 
 /*
- * Spawn the kthread that handles this RCU flavor's grace periods.
+ * Spawn the kthreads that handle each RCU flavor's grace periods.
  */
 static int __init rcu_spawn_gp_kthread(void)
 {
@@ -3498,6 +3519,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	struct rcu_state *rsp;
 	struct task_struct *t;
 
+	rcu_scheduler_fully_active = 1;
 	for_each_rcu_flavor(rsp) {
 		t = kthread_run(rcu_gp_kthread, rsp, "%s", rsp->name);
 		BUG_ON(IS_ERR(t));
@@ -3505,8 +3527,9 @@ static int __init rcu_spawn_gp_kthread(void)
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rsp->gp_kthread = t;
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-		rcu_spawn_nocb_kthreads(rsp);
 	}
+	rcu_spawn_nocb_kthreads();
+	rcu_spawn_boost_kthreads();
 	return 0;
 }
 early_initcall(rcu_spawn_gp_kthread);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 6a86eb7bac45..d03764652d91 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -350,7 +350,7 @@ struct rcu_data {
 	int nocb_p_count_lazy;		/*  (approximate). */
 	wait_queue_head_t nocb_wq;	/* For nocb kthreads to sleep on. */
 	struct task_struct *nocb_kthread;
-	bool nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
+	int nocb_defer_wakeup;		/* Defer wakeup of nocb_kthread. */
 
 	/* The following fields are used by the leader, hence own cacheline. */
 	struct rcu_head *nocb_gp_head ____cacheline_internodealigned_in_smp;
@@ -383,6 +383,11 @@ struct rcu_data {
 #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 
+/* Values for nocb_defer_wakeup field in struct rcu_data. */
+#define RCU_NOGP_WAKE_NOT	0
+#define RCU_NOGP_WAKE		1
+#define RCU_NOGP_WAKE_FORCE	2
+
 #define RCU_JIFFIES_TILL_FORCE_QS (1 + (HZ > 250) + (HZ > 500))
 					/* For jiffies_till_first_fqs and */
 					/*  and jiffies_till_next_fqs. */
@@ -572,6 +577,7 @@ static void rcu_preempt_do_callbacks(void);
 static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
+static void __init rcu_spawn_boost_kthreads(void);
 static void rcu_prepare_kthreads(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
@@ -589,10 +595,14 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp,
 				      unsigned long flags);
-static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
-static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
+static void rcu_spawn_all_nocb_kthreads(int cpu);
+static void __init rcu_spawn_nocb_kthreads(void);
+#ifdef CONFIG_RCU_NOCB_CPU
+static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
@@ -605,6 +615,8 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
+static void rcu_dynticks_task_enter(void);
+static void rcu_dynticks_task_exit(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a7997e272564..387dd4599344 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -85,33 +85,6 @@ static void __init rcu_bootup_announce_oddness(void)
 		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
 		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
-#ifdef CONFIG_RCU_NOCB_CPU
-#ifndef CONFIG_RCU_NOCB_CPU_NONE
-	if (!have_rcu_nocb_mask) {
-		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
-		have_rcu_nocb_mask = true;
-	}
-#ifdef CONFIG_RCU_NOCB_CPU_ZERO
-	pr_info("\tOffload RCU callbacks from CPU 0\n");
-	cpumask_set_cpu(0, rcu_nocb_mask);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
-#ifdef CONFIG_RCU_NOCB_CPU_ALL
-	pr_info("\tOffload RCU callbacks from all CPUs\n");
-	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
-#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
-	if (have_rcu_nocb_mask) {
-		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
-			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
-			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
-				    rcu_nocb_mask);
-		}
-		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
-		if (rcu_nocb_poll)
-			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
-	}
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -134,7 +107,7 @@ static void __init rcu_bootup_announce(void)
  * Return the number of RCU-preempt batches processed thus far
  * for debug and statistics.
  */
-long rcu_batches_completed_preempt(void)
+static long rcu_batches_completed_preempt(void)
 {
 	return rcu_preempt_state.completed;
 }
@@ -155,18 +128,19 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
  * not in a quiescent state.  There might be any number of tasks blocked
  * while in an RCU read-side critical section.
  *
- * Unlike the other rcu_*_qs() functions, callers to this function
- * must disable irqs in order to protect the assignment to
- * ->rcu_read_unlock_special.
- */
-static void rcu_preempt_qs(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-
-	if (rdp->passed_quiesce == 0)
-		trace_rcu_grace_period(TPS("rcu_preempt"), rdp->gpnum, TPS("cpuqs"));
-	rdp->passed_quiesce = 1;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+ * As with the other rcu_*_qs() functions, callers to this function
+ * must disable preemption.
+ */
+static void rcu_preempt_qs(void)
+{
+	if (!__this_cpu_read(rcu_preempt_data.passed_quiesce)) {
+		trace_rcu_grace_period(TPS("rcu_preempt"),
+				       __this_cpu_read(rcu_preempt_data.gpnum),
+				       TPS("cpuqs"));
+		__this_cpu_write(rcu_preempt_data.passed_quiesce, 1);
+		barrier(); /* Coordinate with rcu_preempt_check_callbacks(). */
+		current->rcu_read_unlock_special.b.need_qs = false;
+	}
 }
 
 /*
@@ -190,14 +164,14 @@ static void rcu_preempt_note_context_switch(int cpu)
 	struct rcu_node *rnp;
 
 	if (t->rcu_read_lock_nesting > 0 &&
-	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+	    !t->rcu_read_unlock_special.b.blocked) {
 
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = per_cpu_ptr(rcu_preempt_state.rda, cpu);
 		rnp = rdp->mynode;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+		t->rcu_read_unlock_special.b.blocked = true;
 		t->rcu_blocked_node = rnp;
 
 		/*
@@ -239,7 +213,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 				       : rnp->gpnum + 1);
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else if (t->rcu_read_lock_nesting < 0 &&
-		   t->rcu_read_unlock_special) {
+		   t->rcu_read_unlock_special.s) {
 
 		/*
 		 * Complete exit from RCU read-side critical section on
@@ -257,9 +231,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 	 * grace period, then the fact that the task has been enqueued
 	 * means that we continue to block the current grace period.
 	 */
-	local_irq_save(flags);
-	rcu_preempt_qs(cpu);
-	local_irq_restore(flags);
+	rcu_preempt_qs();
 }
 
 /*
@@ -340,7 +312,7 @@ void rcu_read_unlock_special(struct task_struct *t)
 	bool drop_boost_mutex = false;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	struct rcu_node *rnp;
-	int special;
+	union rcu_special special;
 
 	/* NMI handlers cannot block and cannot safely manipulate state. */
 	if (in_nmi())
@@ -350,12 +322,13 @@ void rcu_read_unlock_special(struct task_struct *t)
 
 	/*
 	 * If RCU core is waiting for this CPU to exit critical section,
-	 * let it know that we have done so.
+	 * let it know that we have done so.  Because irqs are disabled,
+	 * t->rcu_read_unlock_special cannot change.
 	 */
 	special = t->rcu_read_unlock_special;
-	if (special & RCU_READ_UNLOCK_NEED_QS) {
-		rcu_preempt_qs(smp_processor_id());
-		if (!t->rcu_read_unlock_special) {
+	if (special.b.need_qs) {
+		rcu_preempt_qs();
+		if (!t->rcu_read_unlock_special.s) {
 			local_irq_restore(flags);
 			return;
 		}
@@ -368,8 +341,8 @@ void rcu_read_unlock_special(struct task_struct *t)
 	}
 
 	/* Clean up if blocked during RCU read-side critical section. */
-	if (special & RCU_READ_UNLOCK_BLOCKED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+	if (special.b.blocked) {
+		t->rcu_read_unlock_special.b.blocked = false;
 
 		/*
 		 * Remove this task from the list it blocked on.  The
@@ -653,12 +626,13 @@ static void rcu_preempt_check_callbacks(int cpu)
 	struct task_struct *t = current;
 
 	if (t->rcu_read_lock_nesting == 0) {
-		rcu_preempt_qs(cpu);
+		rcu_preempt_qs();
 		return;
 	}
 	if (t->rcu_read_lock_nesting > 0 &&
-	    per_cpu(rcu_preempt_data, cpu).qs_pending)
-		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+	    per_cpu(rcu_preempt_data, cpu).qs_pending &&
+	    !per_cpu(rcu_preempt_data, cpu).passed_quiesce)
+		t->rcu_read_unlock_special.b.need_qs = true;
 }
 
 #ifdef CONFIG_RCU_BOOST
@@ -819,11 +793,6 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
  * In fact, if you are using synchronize_rcu_expedited() in a loop,
  * please restructure your code to batch your updates, and then Use a
  * single synchronize_rcu() instead.
- *
- * Note that it is illegal to call this function while holding any lock
- * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
- * to call this function from a CPU-hotplug notifier.  Failing to observe
- * these restriction will result in deadlock.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -845,7 +814,11 @@ void synchronize_rcu_expedited(void)
 	 * being boosted.  This simplifies the process of moving tasks
 	 * from leaf to root rcu_node structures.
 	 */
-	get_online_cpus();
+	if (!try_get_online_cpus()) {
+		/* CPU-hotplug operation in flight, fall back to normal GP. */
+		wait_rcu_gp(call_rcu);
+		return;
+	}
 
 	/*
 	 * Acquire lock, falling back to synchronize_rcu() if too many
@@ -897,7 +870,8 @@ void synchronize_rcu_expedited(void)
 
 	/* Clean up and exit. */
 	smp_mb(); /* ensure expedited GP seen before counter increment. */
-	ACCESS_ONCE(sync_rcu_preempt_exp_count)++;
+	ACCESS_ONCE(sync_rcu_preempt_exp_count) =
+					sync_rcu_preempt_exp_count + 1;
 unlock_mb_ret:
 	mutex_unlock(&sync_rcu_preempt_exp_mutex);
 mb_ret:
@@ -941,7 +915,7 @@ void exit_rcu(void)
 		return;
 	t->rcu_read_lock_nesting = 1;
 	barrier();
-	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	t->rcu_read_unlock_special.b.blocked = true;
 	__rcu_read_unlock();
 }
 
@@ -1462,14 +1436,13 @@ static struct smp_hotplug_thread rcu_cpu_thread_spec = {
 };
 
 /*
- * Spawn all kthreads -- called as soon as the scheduler is running.
+ * Spawn boost kthreads -- called as soon as the scheduler is running.
  */
-static int __init rcu_spawn_kthreads(void)
+static void __init rcu_spawn_boost_kthreads(void)
 {
 	struct rcu_node *rnp;
 	int cpu;
 
-	rcu_scheduler_fully_active = 1;
 	for_each_possible_cpu(cpu)
 		per_cpu(rcu_cpu_has_work, cpu) = 0;
 	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
@@ -1479,9 +1452,7 @@ static int __init rcu_spawn_kthreads(void)
 		rcu_for_each_leaf_node(rcu_state_p, rnp)
 			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
 	}
-	return 0;
 }
-early_initcall(rcu_spawn_kthreads);
 
 static void rcu_prepare_kthreads(int cpu)
 {
@@ -1519,12 +1490,9 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 {
 }
 
-static int __init rcu_scheduler_really_started(void)
+static void __init rcu_spawn_boost_kthreads(void)
 {
-	rcu_scheduler_fully_active = 1;
-	return 0;
 }
-early_initcall(rcu_scheduler_really_started);
 
 static void rcu_prepare_kthreads(int cpu)
 {
@@ -1625,7 +1593,7 @@ static bool __maybe_unused rcu_try_advance_all_cbs(void)
 
 	/* Exit early if we advanced recently. */
 	if (jiffies == rdtp->last_advance_all)
-		return 0;
+		return false;
 	rdtp->last_advance_all = jiffies;
 
 	for_each_rcu_flavor(rsp) {
@@ -1848,7 +1816,7 @@ static int rcu_oom_notify(struct notifier_block *self,
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, rcu_oom_notify_cpu, NULL, 1);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	put_online_cpus();
 
@@ -2075,7 +2043,7 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 	if (!ACCESS_ONCE(rdp_leader->nocb_kthread))
 		return;
 	if (ACCESS_ONCE(rdp_leader->nocb_leader_sleep) || force) {
-		/* Prior xchg orders against prior callback enqueue. */
+		/* Prior smp_mb__after_atomic() orders against prior enqueue. */
 		ACCESS_ONCE(rdp_leader->nocb_leader_sleep) = false;
 		wake_up(&rdp_leader->nocb_wq);
 	}
@@ -2104,6 +2072,7 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 	ACCESS_ONCE(*old_rhpp) = rhp;
 	atomic_long_add(rhcount, &rdp->nocb_q_count);
 	atomic_long_add(rhcount_lazy, &rdp->nocb_q_count_lazy);
+	smp_mb__after_atomic(); /* Store *old_rhpp before _wake test. */
 
 	/* If we are not being polled and there is a kthread, awaken it ... */
 	t = ACCESS_ONCE(rdp->nocb_kthread);
@@ -2120,16 +2089,23 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("WakeEmpty"));
 		} else {
-			rdp->nocb_defer_wakeup = true;
+			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE;
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    TPS("WakeEmptyIsDeferred"));
 		}
 		rdp->qlen_last_fqs_check = 0;
 	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
 		/* ... or if many callbacks queued. */
-		wake_nocb_leader(rdp, true);
+		if (!irqs_disabled_flags(flags)) {
+			wake_nocb_leader(rdp, true);
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("WakeOvf"));
+		} else {
+			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE_FORCE;
+			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
+					    TPS("WakeOvfIsDeferred"));
+		}
 		rdp->qlen_last_fqs_check = LONG_MAX / 2;
-		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
 	} else {
 		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeNot"));
 	}
@@ -2150,7 +2126,7 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 {
 
 	if (!rcu_is_nocb_cpu(rdp->cpu))
-		return 0;
+		return false;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy, flags);
 	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
 		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
@@ -2161,7 +2137,18 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 		trace_rcu_callback(rdp->rsp->name, rhp,
 				   -atomic_long_read(&rdp->nocb_q_count_lazy),
 				   -atomic_long_read(&rdp->nocb_q_count));
-	return 1;
+
+	/*
+	 * If called from an extended quiescent state with interrupts
+	 * disabled, invoke the RCU core in order to allow the idle-entry
+	 * deferred-wakeup check to function.
+	 */
+	if (irqs_disabled_flags(flags) &&
+	    !rcu_is_watching() &&
+	    cpu_online(smp_processor_id()))
+		invoke_rcu_core();
+
+	return true;
 }
 
 /*
@@ -2177,7 +2164,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 
 	/* If this is not a no-CBs CPU, tell the caller to do it the old way. */
 	if (!rcu_is_nocb_cpu(smp_processor_id()))
-		return 0;
+		return false;
 	rsp->qlen = 0;
 	rsp->qlen_lazy = 0;
 
@@ -2196,7 +2183,7 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 		rsp->orphan_nxtlist = NULL;
 		rsp->orphan_nxttail = &rsp->orphan_nxtlist;
 	}
-	return 1;
+	return true;
 }
 
 /*
@@ -2229,7 +2216,7 @@ static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
 		if (likely(d))
 			break;
-		flush_signals(current);
+		WARN_ON(signal_pending(current));
 		trace_rcu_future_gp(rnp, rdp, c, TPS("ResumeWait"));
 	}
 	trace_rcu_future_gp(rnp, rdp, c, TPS("EndWait"));
@@ -2288,7 +2275,7 @@ static void nocb_leader_wait(struct rcu_data *my_rdp)
 		if (!rcu_nocb_poll)
 			trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu,
 					    "WokeEmpty");
-		flush_signals(current);
+		WARN_ON(signal_pending(current));
 		schedule_timeout_interruptible(1);
 
 		/* Rescan in case we were a victim of memory ordering. */
@@ -2327,6 +2314,7 @@ static void nocb_leader_wait(struct rcu_data *my_rdp)
 		atomic_long_add(rdp->nocb_gp_count, &rdp->nocb_follower_count);
 		atomic_long_add(rdp->nocb_gp_count_lazy,
 				&rdp->nocb_follower_count_lazy);
+		smp_mb__after_atomic(); /* Store *tail before wakeup. */
 		if (rdp != my_rdp && tail == &rdp->nocb_follower_head) {
 			/*
 			 * List was empty, wake up the follower.
@@ -2367,7 +2355,7 @@ static void nocb_follower_wait(struct rcu_data *rdp)
 		if (!rcu_nocb_poll)
 			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
 					    "WokeEmpty");
-		flush_signals(current);
+		WARN_ON(signal_pending(current));
 		schedule_timeout_interruptible(1);
 	}
 }
@@ -2428,15 +2416,16 @@ static int rcu_nocb_kthread(void *arg)
 			list = next;
 		}
 		trace_rcu_batch_end(rdp->rsp->name, c, !!list, 0, 0, 1);
-		ACCESS_ONCE(rdp->nocb_p_count) -= c;
-		ACCESS_ONCE(rdp->nocb_p_count_lazy) -= cl;
+		ACCESS_ONCE(rdp->nocb_p_count) = rdp->nocb_p_count - c;
+		ACCESS_ONCE(rdp->nocb_p_count_lazy) =
+						rdp->nocb_p_count_lazy - cl;
 		rdp->n_nocbs_invoked += c;
 	}
 	return 0;
 }
 
 /* Is a deferred wakeup of rcu_nocb_kthread() required? */
-static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 {
 	return ACCESS_ONCE(rdp->nocb_defer_wakeup);
 }
@@ -2444,11 +2433,79 @@ static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 /* Do a deferred wakeup of rcu_nocb_kthread(). */
 static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
+	int ndw;
+
 	if (!rcu_nocb_need_deferred_wakeup(rdp))
 		return;
-	ACCESS_ONCE(rdp->nocb_defer_wakeup) = false;
-	wake_nocb_leader(rdp, false);
-	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
+	ndw = ACCESS_ONCE(rdp->nocb_defer_wakeup);
+	ACCESS_ONCE(rdp->nocb_defer_wakeup) = RCU_NOGP_WAKE_NOT;
+	wake_nocb_leader(rdp, ndw == RCU_NOGP_WAKE_FORCE);
+	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWake"));
+}
+
+void __init rcu_init_nohz(void)
+{
+	int cpu;
+	bool need_rcu_nocb_mask = true;
+	struct rcu_state *rsp;
+
+#ifdef CONFIG_RCU_NOCB_CPU_NONE
+	need_rcu_nocb_mask = false;
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
+
+#if defined(CONFIG_NO_HZ_FULL)
+	if (tick_nohz_full_running && cpumask_weight(tick_nohz_full_mask))
+		need_rcu_nocb_mask = true;
+#endif /* #if defined(CONFIG_NO_HZ_FULL) */
+
+	if (!have_rcu_nocb_mask && need_rcu_nocb_mask) {
+		if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
+			pr_info("rcu_nocb_mask allocation failed, callback offloading disabled.\n");
+			return;
+		}
+		have_rcu_nocb_mask = true;
+	}
+	if (!have_rcu_nocb_mask)
+		return;
+
+#ifdef CONFIG_RCU_NOCB_CPU_ZERO
+	pr_info("\tOffload RCU callbacks from CPU 0\n");
+	cpumask_set_cpu(0, rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+	pr_info("\tOffload RCU callbacks from all CPUs\n");
+	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
+#if defined(CONFIG_NO_HZ_FULL)
+	if (tick_nohz_full_running)
+		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
+#endif /* #if defined(CONFIG_NO_HZ_FULL) */
+
+	if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
+		pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
+		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
+			    rcu_nocb_mask);
+	}
+	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
+	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
+	if (rcu_nocb_poll)
+		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
+
+	for_each_rcu_flavor(rsp) {
+		for_each_cpu(cpu, rcu_nocb_mask) {
+			struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+
+			/*
+			 * If there are early callbacks, they will need
+			 * to be moved to the nocb lists.
+			 */
+			WARN_ON_ONCE(rdp->nxttail[RCU_NEXT_TAIL] !=
+				     &rdp->nxtlist &&
+				     rdp->nxttail[RCU_NEXT_TAIL] != NULL);
+			init_nocb_callback_list(rdp);
+		}
+		rcu_organize_nocb_kthreads(rsp);
+	}
 }
 
 /* Initialize per-rcu_data variables for no-CBs CPUs. */
@@ -2459,15 +2516,85 @@ static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 	rdp->nocb_follower_tail = &rdp->nocb_follower_head;
 }
 
+/*
+ * If the specified CPU is a no-CBs CPU that does not already have its
+ * rcuo kthread for the specified RCU flavor, spawn it.  If the CPUs are
+ * brought online out of order, this can require re-organizing the
+ * leader-follower relationships.
+ */
+static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
+{
+	struct rcu_data *rdp;
+	struct rcu_data *rdp_last;
+	struct rcu_data *rdp_old_leader;
+	struct rcu_data *rdp_spawn = per_cpu_ptr(rsp->rda, cpu);
+	struct task_struct *t;
+
+	/*
+	 * If this isn't a no-CBs CPU or if it already has an rcuo kthread,
+	 * then nothing to do.
+	 */
+	if (!rcu_is_nocb_cpu(cpu) || rdp_spawn->nocb_kthread)
+		return;
+
+	/* If we didn't spawn the leader first, reorganize! */
+	rdp_old_leader = rdp_spawn->nocb_leader;
+	if (rdp_old_leader != rdp_spawn && !rdp_old_leader->nocb_kthread) {
+		rdp_last = NULL;
+		rdp = rdp_old_leader;
+		do {
+			rdp->nocb_leader = rdp_spawn;
+			if (rdp_last && rdp != rdp_spawn)
+				rdp_last->nocb_next_follower = rdp;
+			rdp_last = rdp;
+			rdp = rdp->nocb_next_follower;
+			rdp_last->nocb_next_follower = NULL;
+		} while (rdp);
+		rdp_spawn->nocb_next_follower = rdp_old_leader;
+	}
+
+	/* Spawn the kthread for this CPU and RCU flavor. */
+	t = kthread_run(rcu_nocb_kthread, rdp_spawn,
+			"rcuo%c/%d", rsp->abbr, cpu);
+	BUG_ON(IS_ERR(t));
+	ACCESS_ONCE(rdp_spawn->nocb_kthread) = t;
+}
+
+/*
+ * If the specified CPU is a no-CBs CPU that does not already have its
+ * rcuo kthreads, spawn them.
+ */
+static void rcu_spawn_all_nocb_kthreads(int cpu)
+{
+	struct rcu_state *rsp;
+
+	if (rcu_scheduler_fully_active)
+		for_each_rcu_flavor(rsp)
+			rcu_spawn_one_nocb_kthread(rsp, cpu);
+}
+
+/*
+ * Once the scheduler is running, spawn rcuo kthreads for all online
+ * no-CBs CPUs.  This assumes that the early_initcall()s happen before
+ * non-boot CPUs come online -- if this changes, we will need to add
+ * some mutual exclusion.
+ */
+static void __init rcu_spawn_nocb_kthreads(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		rcu_spawn_all_nocb_kthreads(cpu);
+}
+
 /* How many follower CPU IDs per leader?  Default of -1 for sqrt(nr_cpu_ids). */
 static int rcu_nocb_leader_stride = -1;
 module_param(rcu_nocb_leader_stride, int, 0444);
 
 /*
- * Create a kthread for each RCU flavor for each no-CBs CPU.
- * Also initialize leader-follower relationships.
+ * Initialize leader-follower relationships for all no-CBs CPU.
  */
-static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 {
 	int cpu;
 	int ls = rcu_nocb_leader_stride;
@@ -2475,14 +2602,9 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
 	struct rcu_data *rdp_prev = NULL;
-	struct task_struct *t;
 
-	if (rcu_nocb_mask == NULL)
+	if (!have_rcu_nocb_mask)
 		return;
-#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
-	if (tick_nohz_full_running)
-		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
-#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
 	if (ls == -1) {
 		ls = int_sqrt(nr_cpu_ids);
 		rcu_nocb_leader_stride = ls;
@@ -2505,21 +2627,15 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 			rdp_prev->nocb_next_follower = rdp;
 		}
 		rdp_prev = rdp;
-
-		/* Spawn the kthread for this CPU. */
-		t = kthread_run(rcu_nocb_kthread, rdp,
-				"rcuo%c/%d", rsp->abbr, cpu);
-		BUG_ON(IS_ERR(t));
-		ACCESS_ONCE(rdp->nocb_kthread) = t;
 	}
 }
 
 /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
 static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
-	if (rcu_nocb_mask == NULL ||
-	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return false;
+
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 	return true;
 }
@@ -2541,21 +2657,21 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy, unsigned long flags)
 {
-	return 0;
+	return false;
 }
 
 static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 						     struct rcu_data *rdp,
 						     unsigned long flags)
 {
-	return 0;
+	return false;
 }
 
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 }
 
-static bool rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp)
 {
 	return false;
 }
@@ -2564,7 +2680,11 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 {
 }
 
-static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
+static void rcu_spawn_all_nocb_kthreads(int cpu)
+{
+}
+
+static void __init rcu_spawn_nocb_kthreads(void)
 {
 }
 
@@ -2595,16 +2715,6 @@ static void __maybe_unused rcu_kick_nohz_cpu(int cpu)
 
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 
-/*
- * Define RCU flavor that holds sysidle state.  This needs to be the
- * most active flavor of RCU.
- */
-#ifdef CONFIG_PREEMPT_RCU
-static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
-#else /* #ifdef CONFIG_PREEMPT_RCU */
-static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
-
 static int full_sysidle_state;		/* Current system-idle state. */
 #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
 #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
@@ -2622,6 +2732,10 @@ static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
 {
 	unsigned long j;
 
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/* Adjust nesting, check for fully idle. */
 	if (irq) {
 		rdtp->dynticks_idle_nesting--;
@@ -2687,6 +2801,10 @@ void rcu_sysidle_force_exit(void)
  */
 static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 {
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/* Adjust nesting, check for already non-idle. */
 	if (irq) {
 		rdtp->dynticks_idle_nesting++;
@@ -2741,12 +2859,16 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	unsigned long j;
 	struct rcu_dynticks *rdtp = rdp->dynticks;
 
+	/* If there are no nohz_full= CPUs, don't check system-wide idleness. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	/*
 	 * If some other CPU has already reported non-idle, if this is
 	 * not the flavor of RCU that tracks sysidle state, or if this
 	 * is an offline or the timekeeping CPU, nothing to do.
 	 */
-	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
+	if (!*isidle || rdp->rsp != rcu_state_p ||
 	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
 		return;
 	if (rcu_gp_in_progress(rdp->rsp))
@@ -2772,7 +2894,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
  */
 static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 {
-	return rsp == rcu_sysidle_state;
+	return rsp == rcu_state_p;
 }
 
 /*
@@ -2850,7 +2972,7 @@ static void rcu_sysidle_cancel(void)
 static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 			       unsigned long maxj, bool gpkt)
 {
-	if (rsp != rcu_sysidle_state)
+	if (rsp != rcu_state_p)
 		return;  /* Wrong flavor, ignore. */
 	if (gpkt && nr_cpu_ids <= CONFIG_NO_HZ_FULL_SYSIDLE_SMALL)
 		return;  /* Running state machine from timekeeping CPU. */
@@ -2867,6 +2989,10 @@ static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj)
 {
+	/* If there are no nohz_full= CPUs, no need to track this. */
+	if (!tick_nohz_full_enabled())
+		return;
+
 	rcu_sysidle_report(rsp, isidle, maxj, true);
 }
 
@@ -2893,7 +3019,8 @@ static void rcu_sysidle_cb(struct rcu_head *rhp)
 
 /*
  * Check to see if the system is fully idle, other than the timekeeping CPU.
- * The caller must have disabled interrupts.
+ * The caller must have disabled interrupts.  This is not intended to be
+ * called unless tick_nohz_full_enabled().
  */
 bool rcu_sys_is_idle(void)
 {
@@ -2919,13 +3046,12 @@ bool rcu_sys_is_idle(void)
 
 			/* Scan all the CPUs looking for nonidle CPUs. */
 			for_each_possible_cpu(cpu) {
-				rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
+				rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
 				rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
 				if (!isidle)
 					break;
 			}
-			rcu_sysidle_report(rcu_sysidle_state,
-					   isidle, maxj, false);
+			rcu_sysidle_report(rcu_state_p, isidle, maxj, false);
 			oldrss = rss;
 			rss = ACCESS_ONCE(full_sysidle_state);
 		}
@@ -2952,7 +3078,7 @@ bool rcu_sys_is_idle(void)
 	 * provided by the memory allocator.
 	 */
 	if (nr_cpu_ids > CONFIG_NO_HZ_FULL_SYSIDLE_SMALL &&
-	    !rcu_gp_in_progress(rcu_sysidle_state) &&
+	    !rcu_gp_in_progress(rcu_state_p) &&
 	    !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
 		call_rcu(&rsh.rh, rcu_sysidle_cb);
 	return false;
@@ -3036,3 +3162,19 @@ static void rcu_bind_gp_kthread(void)
 		housekeeping_affine(current);
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 }
+
+/* Record the current task on dyntick-idle entry. */
+static void rcu_dynticks_task_enter(void)
+{
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+	ACCESS_ONCE(current->rcu_tasks_idle_cpu) = smp_processor_id();
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+}
+
+/* Record no current task on dyntick-idle exit. */
+static void rcu_dynticks_task_exit(void)
+{
+#if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL)
+	ACCESS_ONCE(current->rcu_tasks_idle_cpu) = -1;
+#endif /* #if defined(CONFIG_TASKS_RCU) && defined(CONFIG_NO_HZ_FULL) */
+}
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4056d7992a6c..3ef8ba58694e 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -47,6 +47,8 @@
 #include <linux/hardirq.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/kthread.h>
+#include <linux/tick.h>
 
 #define CREATE_TRACE_POINTS
 
@@ -91,7 +93,7 @@ void __rcu_read_unlock(void)
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special.s)))
 			rcu_read_unlock_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		t->rcu_read_lock_nesting = 0;
@@ -137,6 +139,38 @@ int notrace debug_lockdep_rcu_enabled(void)
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
 
 /**
+ * rcu_read_lock_held() - might we be in RCU read-side critical section?
+ *
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
+ * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
+ * this assumes we are in an RCU read-side critical section unless it can
+ * prove otherwise.  This is useful for debug checks in functions that
+ * require that they be called within an RCU read-side critical section.
+ *
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
+ *
+ * Note that rcu_read_lock() and the matching rcu_read_unlock() must
+ * occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock() in process context if the matching rcu_read_lock()
+ * was invoked from within an irq handler.
+ *
+ * Note that rcu_read_lock() is disallowed if the CPU is either idle or
+ * offline from an RCU perspective, so check for those as well.
+ */
+int rcu_read_lock_held(void)
+{
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	if (!rcu_is_watching())
+		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
+	return lock_is_held(&rcu_lock_map);
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_held);
+
+/**
  * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
  *
  * Check for bottom half being disabled, which covers both the
@@ -347,3 +381,312 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
+#ifdef CONFIG_TASKS_RCU
+
+/*
+ * Simple variant of RCU whose quiescent states are voluntary context switch,
+ * user-space execution, and idle.  As such, grace periods can take one good
+ * long time.  There are no read-side primitives similar to rcu_read_lock()
+ * and rcu_read_unlock() because this implementation is intended to get
+ * the system into a safe state for some of the manipulations involved in
+ * tracing and the like.  Finally, this implementation does not support
+ * high call_rcu_tasks() rates from multiple CPUs.  If this is required,
+ * per-CPU callback lists will be needed.
+ */
+
+/* Global list of callbacks and associated lock. */
+static struct rcu_head *rcu_tasks_cbs_head;
+static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
+static DECLARE_WAIT_QUEUE_HEAD(rcu_tasks_cbs_wq);
+static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
+
+/* Track exiting tasks in order to allow them to be waited for. */
+DEFINE_SRCU(tasks_rcu_exit_srcu);
+
+/* Control stall timeouts.  Disable with <= 0, otherwise jiffies till stall. */
+static int rcu_task_stall_timeout __read_mostly = HZ * 60 * 10;
+module_param(rcu_task_stall_timeout, int, 0644);
+
+static void rcu_spawn_tasks_kthread(void);
+
+/*
+ * Post an RCU-tasks callback.  First call must be from process context
+ * after the scheduler if fully operational.
+ */
+void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
+{
+	unsigned long flags;
+	bool needwake;
+
+	rhp->next = NULL;
+	rhp->func = func;
+	raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
+	needwake = !rcu_tasks_cbs_head;
+	*rcu_tasks_cbs_tail = rhp;
+	rcu_tasks_cbs_tail = &rhp->next;
+	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
+	if (needwake) {
+		rcu_spawn_tasks_kthread();
+		wake_up(&rcu_tasks_cbs_wq);
+	}
+}
+EXPORT_SYMBOL_GPL(call_rcu_tasks);
+
+/**
+ * synchronize_rcu_tasks - wait until an rcu-tasks grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu-tasks
+ * grace period has elapsed, in other words after all currently
+ * executing rcu-tasks read-side critical sections have elapsed.  These
+ * read-side critical sections are delimited by calls to schedule(),
+ * cond_resched_rcu_qs(), idle execution, userspace execution, calls
+ * to synchronize_rcu_tasks(), and (in theory, anyway) cond_resched().
+ *
+ * This is a very specialized primitive, intended only for a few uses in
+ * tracing and other situations requiring manipulation of function
+ * preambles and profiling hooks.  The synchronize_rcu_tasks() function
+ * is not (yet) intended for heavy use from multiple CPUs.
+ *
+ * Note that this guarantee implies further memory-ordering guarantees.
+ * On systems with more than one CPU, when synchronize_rcu_tasks() returns,
+ * each CPU is guaranteed to have executed a full memory barrier since the
+ * end of its last RCU-tasks read-side critical section whose beginning
+ * preceded the call to synchronize_rcu_tasks().  In addition, each CPU
+ * having an RCU-tasks read-side critical section that extends beyond
+ * the return from synchronize_rcu_tasks() is guaranteed to have executed
+ * a full memory barrier after the beginning of synchronize_rcu_tasks()
+ * and before the beginning of that RCU-tasks read-side critical section.
+ * Note that these guarantees include CPUs that are offline, idle, or
+ * executing in user mode, as well as CPUs that are executing in the kernel.
+ *
+ * Furthermore, if CPU A invoked synchronize_rcu_tasks(), which returned
+ * to its caller on CPU B, then both CPU A and CPU B are guaranteed
+ * to have executed a full memory barrier during the execution of
+ * synchronize_rcu_tasks() -- even if CPU A and CPU B are the same CPU
+ * (but again only if the system has more than one CPU).
+ */
+void synchronize_rcu_tasks(void)
+{
+	/* Complain if the scheduler has not started.  */
+	rcu_lockdep_assert(!rcu_scheduler_active,
+			   "synchronize_rcu_tasks called too soon");
+
+	/* Wait for the grace period. */
+	wait_rcu_gp(call_rcu_tasks);
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
+
+/**
+ * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
+ *
+ * Although the current implementation is guaranteed to wait, it is not
+ * obligated to, for example, if there are no pending callbacks.
+ */
+void rcu_barrier_tasks(void)
+{
+	/* There is only one callback queue, so this is easy.  ;-) */
+	synchronize_rcu_tasks();
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
+
+/* See if tasks are still holding out, complain if so. */
+static void check_holdout_task(struct task_struct *t,
+			       bool needreport, bool *firstreport)
+{
+	int cpu;
+
+	if (!ACCESS_ONCE(t->rcu_tasks_holdout) ||
+	    t->rcu_tasks_nvcsw != ACCESS_ONCE(t->nvcsw) ||
+	    !ACCESS_ONCE(t->on_rq) ||
+	    (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
+	     !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)) {
+		ACCESS_ONCE(t->rcu_tasks_holdout) = false;
+		list_del_init(&t->rcu_tasks_holdout_list);
+		put_task_struct(t);
+		return;
+	}
+	if (!needreport)
+		return;
+	if (*firstreport) {
+		pr_err("INFO: rcu_tasks detected stalls on tasks:\n");
+		*firstreport = false;
+	}
+	cpu = task_cpu(t);
+	pr_alert("%p: %c%c nvcsw: %lu/%lu holdout: %d idle_cpu: %d/%d\n",
+		 t, ".I"[is_idle_task(t)],
+		 "N."[cpu < 0 || !tick_nohz_full_cpu(cpu)],
+		 t->rcu_tasks_nvcsw, t->nvcsw, t->rcu_tasks_holdout,
+		 t->rcu_tasks_idle_cpu, cpu);
+	sched_show_task(t);
+}
+
+/* RCU-tasks kthread that detects grace periods and invokes callbacks. */
+static int __noreturn rcu_tasks_kthread(void *arg)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+	unsigned long lastreport;
+	struct rcu_head *list;
+	struct rcu_head *next;
+	LIST_HEAD(rcu_tasks_holdouts);
+
+	/* FIXME: Add housekeeping affinity. */
+
+	/*
+	 * Each pass through the following loop makes one check for
+	 * newly arrived callbacks, and, if there are some, waits for
+	 * one RCU-tasks grace period and then invokes the callbacks.
+	 * This loop is terminated by the system going down.  ;-)
+	 */
+	for (;;) {
+
+		/* Pick up any new callbacks. */
+		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
+		list = rcu_tasks_cbs_head;
+		rcu_tasks_cbs_head = NULL;
+		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
+		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
+
+		/* If there were none, wait a bit and start over. */
+		if (!list) {
+			wait_event_interruptible(rcu_tasks_cbs_wq,
+						 rcu_tasks_cbs_head);
+			if (!rcu_tasks_cbs_head) {
+				WARN_ON(signal_pending(current));
+				schedule_timeout_interruptible(HZ/10);
+			}
+			continue;
+		}
+
+		/*
+		 * Wait for all pre-existing t->on_rq and t->nvcsw
+		 * transitions to complete.  Invoking synchronize_sched()
+		 * suffices because all these transitions occur with
+		 * interrupts disabled.  Without this synchronize_sched(),
+		 * a read-side critical section that started before the
+		 * grace period might be incorrectly seen as having started
+		 * after the grace period.
+		 *
+		 * This synchronize_sched() also dispenses with the
+		 * need for a memory barrier on the first store to
+		 * ->rcu_tasks_holdout, as it forces the store to happen
+		 * after the beginning of the grace period.
+		 */
+		synchronize_sched();
+
+		/*
+		 * There were callbacks, so we need to wait for an
+		 * RCU-tasks grace period.  Start off by scanning
+		 * the task list for tasks that are not already
+		 * voluntarily blocked.  Mark these tasks and make
+		 * a list of them in rcu_tasks_holdouts.
+		 */
+		rcu_read_lock();
+		for_each_process_thread(g, t) {
+			if (t != current && ACCESS_ONCE(t->on_rq) &&
+			    !is_idle_task(t)) {
+				get_task_struct(t);
+				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
+				ACCESS_ONCE(t->rcu_tasks_holdout) = true;
+				list_add(&t->rcu_tasks_holdout_list,
+					 &rcu_tasks_holdouts);
+			}
+		}
+		rcu_read_unlock();
+
+		/*
+		 * Wait for tasks that are in the process of exiting.
+		 * This does only part of the job, ensuring that all
+		 * tasks that were previously exiting reach the point
+		 * where they have disabled preemption, allowing the
+		 * later synchronize_sched() to finish the job.
+		 */
+		synchronize_srcu(&tasks_rcu_exit_srcu);
+
+		/*
+		 * Each pass through the following loop scans the list
+		 * of holdout tasks, removing any that are no longer
+		 * holdouts.  When the list is empty, we are done.
+		 */
+		lastreport = jiffies;
+		while (!list_empty(&rcu_tasks_holdouts)) {
+			bool firstreport;
+			bool needreport;
+			int rtst;
+			struct task_struct *t1;
+
+			schedule_timeout_interruptible(HZ);
+			rtst = ACCESS_ONCE(rcu_task_stall_timeout);
+			needreport = rtst > 0 &&
+				     time_after(jiffies, lastreport + rtst);
+			if (needreport)
+				lastreport = jiffies;
+			firstreport = true;
+			WARN_ON(signal_pending(current));
+			list_for_each_entry_safe(t, t1, &rcu_tasks_holdouts,
+						rcu_tasks_holdout_list) {
+				check_holdout_task(t, needreport, &firstreport);
+				cond_resched();
+			}
+		}
+
+		/*
+		 * Because ->on_rq and ->nvcsw are not guaranteed
+		 * to have a full memory barriers prior to them in the
+		 * schedule() path, memory reordering on other CPUs could
+		 * cause their RCU-tasks read-side critical sections to
+		 * extend past the end of the grace period.  However,
+		 * because these ->nvcsw updates are carried out with
+		 * interrupts disabled, we can use synchronize_sched()
+		 * to force the needed ordering on all such CPUs.
+		 *
+		 * This synchronize_sched() also confines all
+		 * ->rcu_tasks_holdout accesses to be within the grace
+		 * period, avoiding the need for memory barriers for
+		 * ->rcu_tasks_holdout accesses.
+		 *
+		 * In addition, this synchronize_sched() waits for exiting
+		 * tasks to complete their final preempt_disable() region
+		 * of execution, cleaning up after the synchronize_srcu()
+		 * above.
+		 */
+		synchronize_sched();
+
+		/* Invoke the callbacks. */
+		while (list) {
+			next = list->next;
+			local_bh_disable();
+			list->func(list);
+			local_bh_enable();
+			list = next;
+			cond_resched();
+		}
+		schedule_timeout_uninterruptible(HZ/10);
+	}
+}
+
+/* Spawn rcu_tasks_kthread() at first call to call_rcu_tasks(). */
+static void rcu_spawn_tasks_kthread(void)
+{
+	static DEFINE_MUTEX(rcu_tasks_kthread_mutex);
+	static struct task_struct *rcu_tasks_kthread_ptr;
+	struct task_struct *t;
+
+	if (ACCESS_ONCE(rcu_tasks_kthread_ptr)) {
+		smp_mb(); /* Ensure caller sees full kthread. */
+		return;
+	}
+	mutex_lock(&rcu_tasks_kthread_mutex);
+	if (rcu_tasks_kthread_ptr) {
+		mutex_unlock(&rcu_tasks_kthread_mutex);
+		return;
+	}
+	t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
+	BUG_ON(IS_ERR(t));
+	smp_mb(); /* Ensure others see full kthread. */
+	ACCESS_ONCE(rcu_tasks_kthread_ptr) = t;
+	mutex_unlock(&rcu_tasks_kthread_mutex);
+}
+
+#endif /* #ifdef CONFIG_TASKS_RCU */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 5918d227730f..348ec763b104 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -278,7 +278,7 @@ asmlinkage __visible void __do_softirq(void)
 		pending >>= softirq_bit;
 	}
 
-	rcu_bh_qs(smp_processor_id());
+	rcu_bh_qs();
 	local_irq_disable();
 
 	pending = local_softirq_pending();
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 75875a741b5e..ab456664609d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1055,15 +1055,6 @@ static struct ctl_table kern_table[] = {
 		.child		= key_sysctls,
 	},
 #endif
-#ifdef CONFIG_RCU_TORTURE_TEST
-	{
-		.procname       = "rcutorture_runnable",
-		.data           = &rcutorture_runnable,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
 #ifdef CONFIG_PERF_EVENTS
 	/*
 	 * User-space scripts rely on the existence of this file
diff --git a/kernel/torture.c b/kernel/torture.c
index d600af21f022..dd70993c266c 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -211,18 +211,16 @@ EXPORT_SYMBOL_GPL(torture_onoff_cleanup);
 /*
  * Print online/offline testing statistics.
  */
-char *torture_onoff_stats(char *page)
+void torture_onoff_stats(void)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-	page += sprintf(page,
-		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
-		       n_online_successes, n_online_attempts,
-		       n_offline_successes, n_offline_attempts,
-		       min_online, max_online,
-		       min_offline, max_offline,
-		       sum_online, sum_offline, HZ);
+	pr_cont("onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
+		n_online_successes, n_online_attempts,
+		n_offline_successes, n_offline_attempts,
+		min_online, max_online,
+		min_offline, max_offline,
+		sum_online, sum_offline, HZ);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-	return page;
 }
 EXPORT_SYMBOL_GPL(torture_onoff_stats);
 
@@ -635,8 +633,13 @@ EXPORT_SYMBOL_GPL(torture_init_end);
  *
  * This must be called before the caller starts shutting down its own
  * kthreads.
+ *
+ * Both torture_cleanup_begin() and torture_cleanup_end() must be paired,
+ * in order to correctly perform the cleanup. They are separated because
+ * threads can still need to reference the torture_type type, thus nullify
+ * only after completing all other relevant calls.
  */
-bool torture_cleanup(void)
+bool torture_cleanup_begin(void)
 {
 	mutex_lock(&fullstop_mutex);
 	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
@@ -651,12 +654,17 @@ bool torture_cleanup(void)
 	torture_shuffle_cleanup();
 	torture_stutter_cleanup();
 	torture_onoff_cleanup();
+	return false;
+}
+EXPORT_SYMBOL_GPL(torture_cleanup_begin);
+
+void torture_cleanup_end(void)
+{
 	mutex_lock(&fullstop_mutex);
 	torture_type = NULL;
 	mutex_unlock(&fullstop_mutex);
-	return false;
 }
-EXPORT_SYMBOL_GPL(torture_cleanup);
+EXPORT_SYMBOL_GPL(torture_cleanup_end);
 
 /*
  * Is it time for the current torture test to stop?
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5dbe22aa3efd..09b685daee3d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2043,9 +2043,10 @@ __acquires(&pool->lock)
 	 * kernels, where a requeueing work item waiting for something to
 	 * happen could deadlock with stop_machine as such work item could
 	 * indefinitely requeue itself while all other CPUs are trapped in
-	 * stop_machine.
+	 * stop_machine. At the same time, report a quiescent RCU state so
+	 * the same condition doesn't freeze RCU.
 	 */
-	cond_resched();
+	cond_resched_rcu_qs();
 
 	spin_lock_irq(&pool->lock);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index ce84cb0b83ef..ab3150c26711 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -789,7 +789,7 @@ static int do_mlockall(int flags)
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 out:
 	return 0;
diff --git a/tools/testing/selftests/rcutorture/bin/config2frag.sh b/tools/testing/selftests/rcutorture/bin/config2frag.sh
old mode 100644
new mode 100755
index 9f9ffcd427d3..56f51ae13d73
--- a/tools/testing/selftests/rcutorture/bin/config2frag.sh
+++ b/tools/testing/selftests/rcutorture/bin/config2frag.sh
@@ -1,5 +1,5 @@
-#!/bin/sh
-# Usage: sh config2frag.sh < .config > configfrag
+#!/bin/bash
+# Usage: config2frag.sh < .config > configfrag
 #
 # Converts the "# CONFIG_XXX is not set" to "CONFIG_XXX=n" so that the
 # resulting file becomes a legitimate Kconfig fragment.
diff --git a/tools/testing/selftests/rcutorture/bin/configcheck.sh b/tools/testing/selftests/rcutorture/bin/configcheck.sh
index d686537dd55c..eee31e261bf7 100755
--- a/tools/testing/selftests/rcutorture/bin/configcheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/configcheck.sh
@@ -1,5 +1,5 @@
-#!/bin/sh
-# Usage: sh configcheck.sh .config .config-template
+#!/bin/bash
+# Usage: configcheck.sh .config .config-template
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
index 9c3f3d39b934..15f1a17ca96e 100755
--- a/tools/testing/selftests/rcutorture/bin/configinit.sh
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -1,6 +1,6 @@
-#!/bin/sh
+#!/bin/bash
 #
-# sh configinit.sh config-spec-file [ build output dir ]
+# Usage: configinit.sh config-spec-file [ build output dir ]
 #
 # Create a .config file from the spec file.  Run from the kernel source tree.
 # Exits with 0 if all went well, with 1 if all went well but the config
diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index d01b865bb100..b325470c01b3 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -64,6 +64,26 @@ configfrag_boot_params () {
 	fi
 }
 
+# configfrag_boot_cpus bootparam-string config-fragment-file config-cpus
+#
+# Decreases number of CPUs based on any maxcpus= boot parameters specified.
+configfrag_boot_cpus () {
+	local bootargs="`configfrag_boot_params "$1" "$2"`"
+	local maxcpus
+	if echo "${bootargs}" | grep -q 'maxcpus=[0-9]'
+	then
+		maxcpus="`echo "${bootargs}" | sed -e 's/^.*maxcpus=\([0-9]*\).*$/\1/'`"
+		if test "$3" -gt "$maxcpus"
+		then
+			echo $maxcpus
+		else
+			echo $3
+		fi
+	else
+		echo $3
+	fi
+}
+
 # configfrag_hotplug_cpu config-fragment-file
 #
 # Returns 1 if the config fragment specifies hotplug CPU.
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
index 7c1e56b46de4..00cb0db2643d 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -2,7 +2,7 @@
 #
 # Build a kvm-ready Linux kernel from the tree in the current directory.
 #
-# Usage: sh kvm-build.sh config-template build-dir more-configs
+# Usage: kvm-build.sh config-template build-dir more-configs
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
index 7f1ff1a8fc4b..43f764098e50 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -2,7 +2,7 @@
 #
 # Analyze a given results directory for locktorture progress.
 #
-# Usage: sh kvm-recheck-lock.sh resdir
+# Usage: kvm-recheck-lock.sh resdir
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
index 307c4b95f325..d6cc07fc137f 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -2,7 +2,7 @@
 #
 # Analyze a given results directory for rcutorture progress.
 #
-# Usage: sh kvm-recheck-rcu.sh resdir
+# Usage: kvm-recheck-rcu.sh resdir
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 3f6c9b78d177..4f5b20f367a9 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -4,7 +4,7 @@
 # check the build and console output for errors.  Given a directory
 # containing results directories, this recursively checks them all.
 #
-# Usage: sh kvm-recheck.sh resdir ...
+# Usage: kvm-recheck.sh resdir ...
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 0f69dcbf9def..f6b2b4771b78 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -6,7 +6,7 @@
 # Execute this in the source tree.  Do not run it as a background task
 # because qemu does not seem to like that much.
 #
-# Usage: sh kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
+# Usage: kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
 #
 # qemu-args defaults to "-nographic", along with arguments specifying the
 #			number of CPUs and other options generated from
@@ -140,6 +140,7 @@ fi
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
+cpu_count=`configfrag_boot_cpus "$boot_args" "$config_template" "$cpu_count"`
 vcpus=`identify_qemu_vcpus`
 if test $cpu_count -gt $vcpus
 then
@@ -214,7 +215,7 @@ then
 		fi
 		if test $kruntime -ge $((seconds + grace))
 		then
-			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
+			echo "!!! PID $qemu_pid hung at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
 			kill -KILL $qemu_pid
 			break
 		fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
old mode 100644
new mode 100755
index 589e9c38413b..e527dc952eb0
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -7,7 +7,7 @@
 # Edit the definitions below to set the locations of the various directories,
 # as well as the test duration.
 #
-# Usage: sh kvm.sh [ options ]
+# Usage: kvm.sh [ options ]
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
@@ -188,7 +188,9 @@ for CF in $configs
 do
 	if test -f "$CONFIGFRAG/$kversion/$CF"
 	then
-		echo $CF `configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF` >> $T/cfgcpu
+		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF`
+		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$kversion/$CF" "$cpu_count"`
+		echo $CF $cpu_count >> $T/cfgcpu
 	else
 		echo "The --configs file $CF does not exist, terminating."
 		exit 1
diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
index 543230951c38..499d1e598e42 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Check the build output from an rcutorture run for goodness.
 # The "file" is a pathname on the local system, and "title" is
@@ -6,8 +6,7 @@
 #
 # The file must contain kernel build output.
 #
-# Usage:
-#	sh parse-build.sh file title
+# Usage: parse-build.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
index 4185d4cab32e..f962ba4cf68b 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-console.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -1,11 +1,10 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Check the console output from an rcutorture run for oopses.
 # The "file" is a pathname on the local system, and "title" is
 # a text string for error-message purposes.
 #
-# Usage:
-#	sh parse-console.sh file title
+# Usage: parse-console.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
@@ -33,6 +32,10 @@ title="$2"
 
 . functions.sh
 
+if grep -Pq '\x00' < $file
+then
+	print_warning Console output contains nul bytes, old qemu still running?
+fi
 egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
 if test -s $T
 then
diff --git a/tools/testing/selftests/rcutorture/bin/parse-torture.sh b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
index 3455560ab4e4..e3c5f0705696 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-torture.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Check the console output from a torture run for goodness.
 # The "file" is a pathname on the local system, and "title" is
@@ -7,8 +7,7 @@
 # The file must contain torture output, but can be interspersed
 # with other dmesg text, as in console-log output.
 #
-# Usage:
-#	sh parse-torture.sh file title
+# Usage: parse-torture.sh file title
 #
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
diff --git a/tools/testing/selftests/rcutorture/configs/lock/CFLIST b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
index a061b22d1892..6910b7370761 100644
--- a/tools/testing/selftests/rcutorture/configs/lock/CFLIST
+++ b/tools/testing/selftests/rcutorture/configs/lock/CFLIST
@@ -1 +1,4 @@
 LOCK01
+LOCK02
+LOCK03
+LOCK04
\ No newline at end of file
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK02 b/tools/testing/selftests/rcutorture/configs/lock/LOCK02
new file mode 100644
index 000000000000..1d1da1477fc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK02
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot b/tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot
new file mode 100644
index 000000000000..5aa44b4f1b51
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK02.boot
@@ -0,0 +1 @@
+locktorture.torture_type=mutex_lock
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK03 b/tools/testing/selftests/rcutorture/configs/lock/LOCK03
new file mode 100644
index 000000000000..1d1da1477fc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK03
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK03.boot b/tools/testing/selftests/rcutorture/configs/lock/LOCK03.boot
new file mode 100644
index 000000000000..a67bbe0245c9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK03.boot
@@ -0,0 +1 @@
+locktorture.torture_type=rwsem_lock
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK04 b/tools/testing/selftests/rcutorture/configs/lock/LOCK04
new file mode 100644
index 000000000000..1d1da1477fc3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK04
@@ -0,0 +1,6 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=4
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
diff --git a/tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot b/tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot
new file mode 100644
index 000000000000..48c04fe47fb4
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/lock/LOCK04.boot
@@ -0,0 +1 @@
+locktorture.torture_type=rw_lock
diff --git a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
index 9746ea1cd6c7..252aae618984 100644
--- a/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/lock/ver_functions.sh
@@ -38,6 +38,6 @@ per_version_boot_params () {
 	echo $1 `locktorture_param_onoff "$1" "$2"` \
 		locktorture.stat_interval=15 \
 		locktorture.shutdown_secs=$3 \
-		locktorture.locktorture_runnable=1 \
+		locktorture.torture_runnable=1 \
 		locktorture.verbose=1
 }
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/CFLIST b/tools/testing/selftests/rcutorture/configs/rcu/CFLIST
index cd3d29cb0a47..a3a1a05a2b5c 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/CFLIST
+++ b/tools/testing/selftests/rcutorture/configs/rcu/CFLIST
@@ -11,3 +11,6 @@ SRCU-N
 SRCU-P
 TINY01
 TINY02
+TASKS01
+TASKS02
+TASKS03
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS01 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01
new file mode 100644
index 000000000000..97f0a0b27ef7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01
@@ -0,0 +1,9 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_RCU=y
+CONFIG_TASKS_RCU=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
new file mode 100644
index 000000000000..cd2a188eeb6d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS01.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=tasks
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS02 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02
new file mode 100644
index 000000000000..696d2ea74d13
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02
@@ -0,0 +1,5 @@
+CONFIG_SMP=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_TASKS_RCU=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
new file mode 100644
index 000000000000..cd2a188eeb6d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS02.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=tasks
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS03 b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03
new file mode 100644
index 000000000000..9c60da5b5d1d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03
@@ -0,0 +1,13 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_TASKS_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot
new file mode 100644
index 000000000000..cd2a188eeb6d
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TASKS03.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=tasks
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 063b7079c621..38e3895759dd 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -1,5 +1,4 @@
 CONFIG_SMP=y
-CONFIG_NR_CPUS=8
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
@@ -10,8 +9,7 @@ CONFIG_NO_HZ_FULL=n
 CONFIG_RCU_FAST_NO_HZ=y
 CONFIG_RCU_TRACE=y
 CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_FANOUT=8
-CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_MAXSMP=y
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ZERO=y
 CONFIG_DEBUG_LOCK_ALLOC=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
index 0fc8a3428938..adc3abc82fb8 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
@@ -1 +1 @@
-rcutorture.torture_type=rcu_bh
+rcutorture.torture_type=rcu_bh maxcpus=8
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07 b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
index ab6225506909..8f1017666aa7 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07
@@ -1,5 +1,6 @@
 CONFIG_SMP=y
 CONFIG_NR_CPUS=16
+CONFIG_CPUMASK_OFFSTACK=y
 CONFIG_PREEMPT_NONE=y
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=n
@@ -7,7 +8,7 @@ CONFIG_PREEMPT=n
 CONFIG_HZ_PERIODIC=n
 CONFIG_NO_HZ_IDLE=n
 CONFIG_NO_HZ_FULL=y
-CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_NO_HZ_FULL_ALL=n
 CONFIG_NO_HZ_FULL_SYSIDLE=y
 CONFIG_RCU_FAST_NO_HZ=n
 CONFIG_RCU_TRACE=y
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot
new file mode 100644
index 000000000000..d44609937503
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE07.boot
@@ -0,0 +1 @@
+nohz_full=2-9
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
index 8977d8d31b19..ffb85ed786fa 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/rcu/ver_functions.sh
@@ -51,7 +51,7 @@ per_version_boot_params () {
 		`rcutorture_param_n_barrier_cbs "$1"` \
 		rcutorture.stat_interval=15 \
 		rcutorture.shutdown_secs=$3 \
-		rcutorture.rcutorture_runnable=1 \
+		rcutorture.torture_runnable=1 \
 		rcutorture.test_no_idle_hz=1 \
 		rcutorture.verbose=1
 }
diff --git a/tools/testing/selftests/rcutorture/doc/initrd.txt b/tools/testing/selftests/rcutorture/doc/initrd.txt
index 49d134c25c04..4170e714f044 100644
--- a/tools/testing/selftests/rcutorture/doc/initrd.txt
+++ b/tools/testing/selftests/rcutorture/doc/initrd.txt
@@ -6,6 +6,7 @@ this case.  There are probably much better ways of doing this.
 That said, here are the commands:
 
 ------------------------------------------------------------------------
+cd tools/testing/selftests/rcutorture
 zcat /initrd.img > /tmp/initrd.img.zcat
 mkdir initrd
 cd initrd
