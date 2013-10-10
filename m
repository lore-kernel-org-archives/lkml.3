Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3JJRLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:11:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58926 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab3JJRLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:11:42 -0400
Date: Thu, 10 Oct 2013 10:11:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131010171135.GL5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008102331.GB8852@gmail.com>
 <20131008141657.GW5790@linux.vnet.ibm.com>
 <20131008194718.GD7315@gmail.com>
 <20131008204056.GR5790@linux.vnet.ibm.com>
 <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
 <20131009060806.GC7664@gmail.com>
 <20131009142123.GT5790@linux.vnet.ibm.com>
 <20131010025904.GA4891@linux.vnet.ibm.com>
 <20131010080501.GA18481@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010080501.GA18481@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101017-0320-0000-0000-000001500BE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:05:01AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > And it now builds, boots, and passes short rcutorture tests, updated 
> > patch below.
> > 
> > One side-effect is the boot parameters, namely that what used to be 
> > rcutree.blimit=10 is now simply tree.blimit=10.  Not a problem for me, I 
> > just made my test scripts probe the source tree and generate the 
> > corresponding format.  But is there some straightforward way to get the 
> > name of the "rcu" directory involved?  The obvious approach of 
> > "rcu.tree.blimit=10" does not work -- the kernel happily ignores any 
> > such parameter.
> 
> Hm, that boot option parser attitude is a bit sad - more structure to boot 
> parameters is IMHO a Good Thing.

No argument here!

> Does it accept :
> 
> 	rcu/tree/blimit=10
> 
> 	rcu/tree.blimit=10
> 
> type of structure perhaps?

Unfortunately, no.  :-(

> > It looks like I should be able to do something like the following in 
> > kernel/rcu/tree.c to get back the old parameter names:
> > 
> > MODULE_ALIAS("rcutree");
> > #ifdef MODULE_PARAM_PREFIX
> > #undef MODULE_PARAM_PREFIX
> > #endif
> > #define MODULE_PARAM_PREFIX "rcutree."
> 
> Yeah.
> 
> ( To keep it simple, the undef should be unnecessary, it's not like anyone 
>   can slip in a MODULE_PARAM_PREFIX without you noticing, right? )

Works with the #undef, trying it without it...  And it works, but I do
get the following complaint from the compiler:

/home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:66:0: warning: "MODULE_PARAM_PREFIX" redefined [enabled by default]
/home/paulmck/public_git/linux-rcu/include/linux/moduleparam.h:13:0: note: this is the location of the previous definition

The problem is that moduleparam.h contains the following:

#define MODULE_PARAM_PREFIX KBUILD_MODNAME "."

So the #undef is ugly, but better than the compiler warning.  :-(

> > And similarly for rcu/update.c and rcu/torture.c.
> > 
> > In fact, it looks like I could make rcu/update.c also use either the 
> > "rcutree." or "rcutiny." prefix, depending on which was being built.
> > 
> > Any thoughts, cautions, or suggestions?
> 
> Still looks nice to me!

Glad you like it!  ;-)

Updated patch below.  The prefix change thrash was useful, as it rubbed
my face in the fact that I needed to update the kernel-parameter.txt file.
Some times you get lucky!

Would you like this for the upcoming 3.13 merge window, or would it be
better for 3.14?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Move RCU-related source code to kernel/rcu directory

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>

 b/Documentation/DocBook/device-drivers.tmpl |    5 +
 b/Documentation/kernel-parameters.txt       |   95 ++++++++++++++++------------
 b/MAINTAINERS                               |   11 +--
 b/kernel/Makefile                           |   11 ---
 b/kernel/rcu/Makefile                       |    6 +
 b/kernel/rcu/tiny.c                         |    8 +-
 b/kernel/rcu/torture.c                      |    6 +
 b/kernel/rcu/tree.c                         |   13 ++-
 b/kernel/rcu/tree_plugin.h                  |    4 -
 b/kernel/rcu/tree_trace.c                   |    2 
 b/kernel/rcu/update.c                       |    6 +
 11 files changed, 105 insertions(+), 62 deletions(-)

rcu: Move RCU-related source code to kernel/rcu directory

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index fe397f90a34f..6c9d9d37c83a 100644
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
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1a036cd972fb..c3dc13e90a40 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2595,7 +2595,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
 			See Documentation/blockdev/ramdisk.txt.
 
-	rcu_nocbs=	[KNL,BOOT]
+	rcu_nocbs=	[KNL]
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
 			Invocation of these CPUs' RCU callbacks will
@@ -2608,7 +2608,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
-	rcu_nocb_poll	[KNL,BOOT]
+	rcu_nocb_poll	[KNL]
 			Rather than requiring that offloaded CPUs
 			(specified by rcu_nocbs= above) explicitly
 			awaken the corresponding "rcuoN" kthreads,
@@ -2619,126 +2619,145 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e83fc2b..28f2478b6794 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6903,7 +6903,7 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
-F:	kernel/rcutorture.c
+F:	kernel/rcu/torture.c
 
 RDC R-321X SoC
 M:	Florian Fainelli <florian@openwrt.org>
@@ -6930,8 +6930,9 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
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
@@ -7618,8 +7619,8 @@ M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/RCU/
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
-F:	include/linux/srcu*
-F:	kernel/srcu*
+F:	include/linux/srcu.h
+F:	kernel/rcu/srcu.c
 
 SMACK SECURITY MODULE
 M:	Casey Schaufler <casey@schaufler-ca.com>
diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce47553fb02..f99d908b5550 100644
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
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
new file mode 100644
index 000000000000..01e9ec37a3e3
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
similarity index 100%
rename from kernel/rcu.h
rename to kernel/rcu/rcu.h
diff --git a/kernel/srcu.c b/kernel/rcu/srcu.c
similarity index 100%
rename from kernel/srcu.c
rename to kernel/rcu/srcu.c
diff --git a/kernel/rcutiny.c b/kernel/rcu/tiny.c
similarity index 97%
rename from kernel/rcutiny.c
rename to kernel/rcu/tiny.c
index 312e9709713f..0c9a934cfec1 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcu/tiny.c
@@ -43,7 +43,7 @@
 
 #include "rcu.h"
 
-/* Forward declarations for rcutiny_plugin.h. */
+/* Forward declarations for tiny_plugin.h. */
 struct rcu_ctrlblk;
 static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp);
 static void rcu_process_callbacks(struct softirq_action *unused);
@@ -53,7 +53,7 @@ static void __call_rcu(struct rcu_head *head,
 
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
-#include "rcutiny_plugin.h"
+#include "tiny_plugin.h"
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long newval)
@@ -67,7 +67,7 @@ static void rcu_idle_enter_common(long long newval)
 	RCU_TRACE(trace_rcu_dyntick(TPS("Start"),
 				    rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick(TPS("Entry error: not idle task"),
 					    rcu_dynticks_nesting, newval));
@@ -128,7 +128,7 @@ static void rcu_idle_exit_common(long long oldval)
 	}
 	RCU_TRACE(trace_rcu_dyntick(TPS("End"), oldval, rcu_dynticks_nesting));
 	if (!is_idle_task(current)) {
-		struct task_struct *idle = idle_task(smp_processor_id());
+		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick(TPS("Exit error: not idle task"),
 			  oldval, rcu_dynticks_nesting));
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcu/tiny_plugin.h
similarity index 100%
rename from kernel/rcutiny_plugin.h
rename to kernel/rcu/tiny_plugin.h
diff --git a/kernel/rcutorture.c b/kernel/rcu/torture.c
similarity index 99%
rename from kernel/rcutorture.c
rename to kernel/rcu/torture.c
index be63101c6175..3929cd451511 100644
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
similarity index 99%
rename from kernel/rcutree.c
rename to kernel/rcu/tree.c
index 240604aa3f70..8a2c81e86dda 100644
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
@@ -56,11 +57,17 @@
 #include <linux/ftrace_event.h>
 #include <linux/suspend.h>
 
-#include "rcutree.h"
+#include "tree.h"
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
 
+MODULE_ALIAS("rcutree");
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "rcutree."
+
 /* Data structures. */
 
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
@@ -3298,7 +3305,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 /*
  * Compute the rcu_node tree geometry from kernel parameters.  This cannot
- * replace the definitions in rcutree.h because those are needed to size
+ * replace the definitions in tree.h because those are needed to size
  * the ->node array in the rcu_state structure.
  */
 static void __init rcu_init_geometry(void)
@@ -3393,4 +3400,4 @@ void __init rcu_init(void)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
 
-#include "rcutree_plugin.h"
+#include "tree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcu/tree.h
similarity index 100%
rename from kernel/rcutree.h
rename to kernel/rcu/tree.h
diff --git a/kernel/rcutree_plugin.h b/kernel/rcu/tree_plugin.h
similarity index 99%
rename from kernel/rcutree_plugin.h
rename to kernel/rcu/tree_plugin.h
index 8d85a5ce093a..3822ac0c4b27 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -28,7 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
-#include "time/tick-internal.h"
+#include "../time/tick-internal.h"
 
 #define RCU_KTHREAD_PRIO 1
 
@@ -1133,7 +1133,7 @@ void exit_rcu(void)
 
 #ifdef CONFIG_RCU_BOOST
 
-#include "rtmutex_common.h"
+#include "../rtmutex_common.h"
 
 #ifdef CONFIG_RCU_TRACE
 
diff --git a/kernel/rcutree_trace.c b/kernel/rcu/tree_trace.c
similarity index 99%
rename from kernel/rcutree_trace.c
rename to kernel/rcu/tree_trace.c
index cf6c17412932..3596797b7e46 100644
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
similarity index 98%
rename from kernel/rcupdate.c
rename to kernel/rcu/update.c
index c07af1c4e1bb..6cb3dff89e2b 100644
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

