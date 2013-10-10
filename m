Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3JJC7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:59:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41149 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3JJC7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:59:12 -0400
Date: Wed, 9 Oct 2013 19:59:04 -0700
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
Message-ID: <20131010025904.GA4891@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131005080416.GA25193@gmail.com>
 <20131008095927.GS3081@twins.programming.kicks-ass.net>
 <20131008102331.GB8852@gmail.com>
 <20131008141657.GW5790@linux.vnet.ibm.com>
 <20131008194718.GD7315@gmail.com>
 <20131008204056.GR5790@linux.vnet.ibm.com>
 <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
 <20131009060806.GC7664@gmail.com>
 <20131009142123.GT5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009142123.GT5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101002-9332-0000-0000-000001B612BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 07:21:23AM -0700, Paul E. McKenney wrote:
> On Wed, Oct 09, 2013 at 08:08:06AM +0200, Ingo Molnar wrote:

[ . . . ]

> > > Now if it actually still builds, boots, and runs...  ;-)
> > 
> > Booting is overrated! ;-)
> 
> Well, some work is needed on this front, but will get there.
> 
> > Seriously, this is good stuff.
> > 
> >    Reviewed-by: Ingo Molnar <mingo@kernel.org>
> 
> Very good, I have added this.
> 
> > I'd definitely argue in favor of doing a mechanical move first, then any 
> > further reorganization separately.
> > 
> > (One minor detail I noticed: you'll probably need to update the RCU file 
> > patterns in MAINTAINERS as well.)
> 
> Ah, good point, fixed!

And it now builds, boots, and passes short rcutorture tests, updated
patch below.

One side-effect is the boot parameters, namely that what used to be
rcutree.blimit=10 is now simply tree.blimit=10.  Not a problem for
me, I just made my test scripts probe the source tree and generate
the corresponding format.  But is there some straightforward way to
get the name of the "rcu" directory involved?  The obvious approach
of "rcu.tree.blimit=10" does not work -- the kernel happily ignores
any such parameter.

It looks like I should be able to do something like the following
in kernel/rcu/tree.c to get back the old parameter names:

MODULE_ALIAS("rcutree");
#ifdef MODULE_PARAM_PREFIX
#undef MODULE_PARAM_PREFIX
#endif
#define MODULE_PARAM_PREFIX "rcutree."

And similarly for rcu/update.c and rcu/torture.c.

In fact, it looks like I could make rcu/update.c also use either the
"rcutree." or "rcutiny." prefix, depending on which was being built.

Any thoughts, cautions, or suggestions?

							Thanx, Paul

 b/Documentation/DocBook/device-drivers.tmpl |    5 
 b/Documentation/RCU/stallwarn.txt           |    4 
 b/Documentation/kernel-parameters.txt       |  257 ++++++++++++++--------------
 b/MAINTAINERS                               |   11 -
 b/kernel/Makefile                           |   11 -
 b/kernel/rcu/Makefile                       |    6 
 b/kernel/rcu/tiny.c                         |    8 
 b/kernel/rcu/tree.c                         |    6 
 b/kernel/rcu/tree_plugin.h                  |    4 
 b/kernel/rcu/tree_trace.c                   |    2 
 10 files changed, 168 insertions(+), 146 deletions(-)

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
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 6f3a0057548e..934448acdfbe 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -15,7 +15,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	21 seconds.
 
 	This configuration parameter may be changed at runtime via the
-	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
+	/sys/module/tree/parameters/rcu_cpu_stall_timeout, however
 	this parameter is checked only at the beginning of a cycle.
 	So if you are 10 seconds into a 40-second stall, setting this
 	sysfs parameter to (say) five will shorten the timeout for the
@@ -24,7 +24,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	timing of the next warning for the current stall.
 
 	Stall-warning messages may be enabled and disabled completely via
-	/sys/module/rcutree/parameters/rcu_cpu_stall_suppress.
+	/sys/module/tree/parameters/rcu_cpu_stall_suppress.
 
 CONFIG_RCU_CPU_STALL_VERBOSE
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1a036cd972fb..e442114cda5a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2619,126 +2619,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			energy efficiency by requiring that the kthreads
 			periodically wake up to do the polling.
 
-	rcutree.blimit=	[KNL,BOOT]
-			Set maximum number of finished RCU callbacks to process
-			in one batch.
-
-	rcutree.fanout_leaf=	[KNL,BOOT]
-			Increase the number of CPUs assigned to each
-			leaf rcu_node structure.  Useful for very large
-			systems.
-
-	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
-			Set delay from grace-period initialization to
-			first attempt to force quiescent states.
-			Units are jiffies, minimum value is zero,
-			and maximum value is HZ.
-
-	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
-			Set delay between subsequent attempts to force
-			quiescent states.  Units are jiffies, minimum
-			value is one, and maximum value is HZ.
-
-	rcutree.qhimark=	[KNL,BOOT]
-			Set threshold of queued
-			RCU callbacks over which batch limiting is disabled.
-
-	rcutree.qlowmark=	[KNL,BOOT]
-			Set threshold of queued RCU callbacks below which
-			batch limiting is re-enabled.
-
-	rcutree.rcu_cpu_stall_suppress=	[KNL,BOOT]
-			Suppress RCU CPU stall warning messages.
-
-	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
-			Set timeout for RCU CPU stall warning messages.
-
-	rcutree.rcu_idle_gp_delay=	[KNL,BOOT]
-			Set wakeup interval for idle CPUs that have
-			RCU callbacks (RCU_FAST_NO_HZ=y).
-
-	rcutree.rcu_idle_lazy_gp_delay=	[KNL,BOOT]
-			Set wakeup interval for idle CPUs that have
-			only "lazy" RCU callbacks (RCU_FAST_NO_HZ=y).
-			Lazy RCU callbacks are those which RCU can
-			prove do nothing more than free memory.
-
-	rcutorture.fqs_duration= [KNL,BOOT]
-			Set duration of force_quiescent_state bursts.
-
-	rcutorture.fqs_holdoff= [KNL,BOOT]
-			Set holdoff time within force_quiescent_state bursts.
-
-	rcutorture.fqs_stutter= [KNL,BOOT]
-			Set wait time between force_quiescent_state bursts.
-
-	rcutorture.irqreader= [KNL,BOOT]
-			Test RCU readers from irq handlers.
-
-	rcutorture.n_barrier_cbs= [KNL,BOOT]
-			Set callbacks/threads for rcu_barrier() testing.
-
-	rcutorture.nfakewriters= [KNL,BOOT]
-			Set number of concurrent RCU writers.  These just
-			stress RCU, they don't participate in the actual
-			test, hence the "fake".
-
-	rcutorture.nreaders= [KNL,BOOT]
-			Set number of RCU readers.
-
-	rcutorture.onoff_holdoff= [KNL,BOOT]
-			Set time (s) after boot for CPU-hotplug testing.
-
-	rcutorture.onoff_interval= [KNL,BOOT]
-			Set time (s) between CPU-hotplug operations, or
-			zero to disable CPU-hotplug testing.
-
-	rcutorture.shuffle_interval= [KNL,BOOT]
-			Set task-shuffle interval (s).  Shuffling tasks
-			allows some CPUs to go into dyntick-idle mode
-			during the rcutorture test.
-
-	rcutorture.shutdown_secs= [KNL,BOOT]
-			Set time (s) after boot system shutdown.  This
-			is useful for hands-off automated testing.
-
-	rcutorture.stall_cpu= [KNL,BOOT]
-			Duration of CPU stall (s) to test RCU CPU stall
-			warnings, zero to disable.
-
-	rcutorture.stall_cpu_holdoff= [KNL,BOOT]
-			Time to wait (s) after boot before inducing stall.
-
-	rcutorture.stat_interval= [KNL,BOOT]
-			Time (s) between statistics printk()s.
-
-	rcutorture.stutter= [KNL,BOOT]
-			Time (s) to stutter testing, for example, specifying
-			five seconds causes the test to run for five seconds,
-			wait for five seconds, and so on.  This tests RCU's
-			ability to transition abruptly to and from idle.
-
-	rcutorture.test_boost= [KNL,BOOT]
-			Test RCU priority boosting?  0=no, 1=maybe, 2=yes.
-			"Maybe" means test if the RCU implementation
-			under test support RCU priority boosting.
-
-	rcutorture.test_boost_duration= [KNL,BOOT]
-			Duration (s) of each individual boost test.
-
-	rcutorture.test_boost_interval= [KNL,BOOT]
-			Interval (s) between each boost test.
-
-	rcutorture.test_no_idle_hz= [KNL,BOOT]
-			Test RCU's dyntick-idle handling.  See also the
-			rcutorture.shuffle_interval parameter.
-
-	rcutorture.torture_type= [KNL,BOOT]
-			Specify the RCU implementation to test.
-
-	rcutorture.verbose= [KNL,BOOT]
-			Enable additional printk() statements.
-
 	rdinit=		[KNL]
 			Format: <full_path>
 			Run specified binary instead of /init from the ramdisk,
@@ -3109,6 +2989,94 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			e.g. base its process migration decisions on it.
 			Default is on.
 
+	torture.fqs_duration= [KNL,BOOT]
+			Set duration of force_quiescent_state bursts.
+
+	torture.fqs_holdoff= [KNL,BOOT]
+			Set holdoff time within force_quiescent_state bursts.
+
+	torture.fqs_stutter= [KNL,BOOT]
+			Set wait time between force_quiescent_state bursts.
+
+	torture.gp_exp= [KNL,BOOT]
+			Use expedited update-side primitives.
+
+	torture.gp_normal= [KNL,BOOT]
+			Use normal (non-expedited) update-side primitives.
+			If both gp_exp and gp_normal are set, do both.
+			If neither gp_exp or gp_normal are set, still
+			do both.
+
+	torture.n_barrier_cbs= [KNL,BOOT]
+			Set callbacks/threads for rcu_barrier() testing.
+
+	torture.nfakewriters= [KNL,BOOT]
+			Set number of concurrent RCU writers.  These just
+			stress RCU, they don't participate in the actual
+			test, hence the "fake".
+
+	torture.nreaders= [KNL,BOOT]
+			Set number of RCU readers.
+
+	torture.object_debug= [KNL,BOOT]
+			Enable debug-object double-call_rcu() testing.
+
+	torture.onoff_holdoff= [KNL,BOOT]
+			Set time (s) after boot for CPU-hotplug testing.
+
+	torture.onoff_interval= [KNL,BOOT]
+			Set time (s) between CPU-hotplug operations, or
+			zero to disable CPU-hotplug testing.
+
+	torture.rcutorture_runnable= [BOOT]
+			Start rcutorture running at boot time.
+
+	torture.shuffle_interval= [KNL,BOOT]
+			Set task-shuffle interval (s).  Shuffling tasks
+			allows some CPUs to go into dyntick-idle mode
+			during the rcutorture test.
+
+	torture.shutdown_secs= [KNL,BOOT]
+			Set time (s) after boot system shutdown.  This
+			is useful for hands-off automated testing.
+
+	torture.stall_cpu= [KNL,BOOT]
+			Duration of CPU stall (s) to test RCU CPU stall
+			warnings, zero to disable.
+
+	torture.stall_cpu_holdoff= [KNL,BOOT]
+			Time to wait (s) after boot before inducing stall.
+
+	torture.stat_interval= [KNL,BOOT]
+			Time (s) between statistics printk()s.
+
+	torture.stutter= [KNL,BOOT]
+			Time (s) to stutter testing, for example, specifying
+			five seconds causes the test to run for five seconds,
+			wait for five seconds, and so on.  This tests RCU's
+			ability to transition abruptly to and from idle.
+
+	torture.test_boost= [KNL,BOOT]
+			Test RCU priority boosting?  0=no, 1=maybe, 2=yes.
+			"Maybe" means test if the RCU implementation
+			under test support RCU priority boosting.
+
+	torture.test_boost_duration= [KNL,BOOT]
+			Duration (s) of each individual boost test.
+
+	torture.test_boost_interval= [KNL,BOOT]
+			Interval (s) between each boost test.
+
+	torture.test_no_idle_hz= [KNL,BOOT]
+			Test RCU's dyntick-idle handling.  See also the
+			torture.shuffle_interval parameter.
+
+	torture.torture_type= [KNL,BOOT]
+			Specify the RCU implementation to test.
+
+	torture.verbose= [KNL,BOOT]
+			Enable additional printk() statements.
+
 	tp720=		[HW,PS2]
 
 	tpm_suspend_pcr=[HW,TPM]
@@ -3164,6 +3132,44 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			with respect to transparent hugepages.
 			See Documentation/vm/transhuge.txt for more details.
 
+	tree.blimit=	[KNL,BOOT]
+			Set maximum number of finished RCU callbacks to process
+			in one batch.
+
+	tree.rcu_fanout_leaf=	[KNL,BOOT]
+			Increase the number of CPUs assigned to each
+			leaf rcu_node structure.  Useful for very large
+			systems.
+
+	tree.jiffies_till_first_fqs= [KNL,BOOT]
+			Set delay from grace-period initialization to
+			first attempt to force quiescent states.
+			Units are jiffies, minimum value is zero,
+			and maximum value is HZ.
+
+	tree.jiffies_till_next_fqs= [KNL,BOOT]
+			Set delay between subsequent attempts to force
+			quiescent states.  Units are jiffies, minimum
+			value is one, and maximum value is HZ.
+
+	tree.qhimark=	[KNL,BOOT]
+			Set threshold of queued
+			RCU callbacks over which batch limiting is disabled.
+
+	tree.qlowmark=	[KNL,BOOT]
+			Set threshold of queued RCU callbacks below which
+			batch limiting is re-enabled.
+
+	tree.rcu_idle_gp_delay=	[KNL,BOOT]
+			Set wakeup interval for idle CPUs that have
+			RCU callbacks (RCU_FAST_NO_HZ=y).
+
+	tree.rcu_idle_lazy_gp_delay=	[KNL,BOOT]
+			Set wakeup interval for idle CPUs that have
+			only "lazy" RCU callbacks (RCU_FAST_NO_HZ=y).
+			Lazy RCU callbacks are those which RCU can
+			prove do nothing more than free memory.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
@@ -3201,6 +3207,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	unknown_nmi_panic
 			[X86] Cause panic on unknown NMI.
 
+	rcu.update.rcu_expedited= [KNL,BOOT]
+			Use expedited grace-period primitives, for
+			example, synchronize_rcu_expedited() instead
+			of synchronize_rcu().
+
+	update.rcu_cpu_stall_suppress=	[KNL,BOOT]
+			Suppress RCU CPU stall warning messages.
+
+	update.rcu_cpu_stall_timeout= [KNL,BOOT]
+			Set timeout for RCU CPU stall warning messages.
+
 	usbcore.authorized_default=
 			[USB] Default USB device authorization:
 			(default -1 = authorized except for wireless USB,
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
similarity index 100%
rename from kernel/rcutorture.c
rename to kernel/rcu/torture.c
diff --git a/kernel/rcutree.c b/kernel/rcu/tree.c
similarity index 99%
rename from kernel/rcutree.c
rename to kernel/rcu/tree.c
index 240604aa3f70..52b67ee63a0b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcu/tree.c
@@ -56,7 +56,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/suspend.h>
 
-#include "rcutree.h"
+#include "tree.h"
 #include <trace/events/rcu.h>
 
 #include "rcu.h"
@@ -3298,7 +3298,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 
 /*
  * Compute the rcu_node tree geometry from kernel parameters.  This cannot
- * replace the definitions in rcutree.h because those are needed to size
+ * replace the definitions in tree.h because those are needed to size
  * the ->node array in the rcu_state structure.
  */
 static void __init rcu_init_geometry(void)
@@ -3393,4 +3393,4 @@ void __init rcu_init(void)
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
similarity index 100%
rename from kernel/rcupdate.c
rename to kernel/rcu/update.c

