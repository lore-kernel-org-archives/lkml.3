Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3JID2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:28:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44165 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3JID2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:28:50 -0400
Date: Tue, 8 Oct 2013 20:28:43 -0700
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
Message-ID: <20131009032843.GA12970@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131002092217.784439754@infradead.org>
 <20131004204405.GU3081@twins.programming.kicks-ass.net>
 <20131004204438.GR26785@twins.programming.kicks-ass.net>
 <20131005080416.GA25193@gmail.com>
 <20131008095927.GS3081@twins.programming.kicks-ass.net>
 <20131008102331.GB8852@gmail.com>
 <20131008141657.GW5790@linux.vnet.ibm.com>
 <20131008194718.GD7315@gmail.com>
 <20131008204056.GR5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008204056.GR5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100903-1344-0000-0000-0000024642E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:40:56PM -0700, Paul E. McKenney wrote:
> On Tue, Oct 08, 2013 at 09:47:18PM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Tue, Oct 08, 2013 at 12:23:31PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > 
> > > > > On Sat, Oct 05, 2013 at 10:04:16AM +0200, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > 
> > > > > > > On Fri, Oct 04, 2013 at 10:44:05PM +0200, Peter Zijlstra wrote:
> > > > > > > > 
> > > > > > > > slightly related; do we want to do something like the following two
> > > > > > > > patches?
> > > > > > > 
> > > > > > > and
> > > > > > 
> > > > > > Yeah, both look good to me - but I'd move them into 
> > > > > > kernel/sched/completion.c and kernel/sched/wait.c if no-one objects.
> > > > > 
> > > > > Do you also want to suck in semaphore.c mutex.c rwsem.c spinlock.c etc? 
> > > > > Or do you want to create something like kernel/locking/ for all that.
> > > > 
> > > > Yeah, I think kernel/locking/ would be a suitable place for those, and I'd 
> > > > move lockdep*.c there too. (Such things are best done near the end of a 
> > > > merge window, when there's not much pending, to not disrupt development.)
> > > > 
> > > > kernel/*.c is a pretty crowded place with 100+ files currently, I've been 
> > > > gradually working towards depopulating it slowly but surely for subsystems 
> > > > that I co-maintain or where I'm frequently active. We already have:
> > > > 
> > > >   kernel/sched/
> > > >   kernel/events/
> > > >   kernel/irq/
> > > >   kernel/time/
> > > >   kernel/trace/
> > > > 
> > > > and the deeper kernel/*/* hierarchies already host another ~100 .c files. 
> > > > So the transition is half done already I suspect.
> > > 
> > > Should I be thinking about making a kernel/rcu?
> > 
> > I wanted to raise it with you at the KS :-)
> 
> Sorry for jumping the gun.  ;-)
> 
> > To me it would sure look nice to have kernel/rcu/tree.c, 
> > kernel/rcu/tiny.c, kernel/rcu/core.c, etc.
> > 
> > [ ... and we would certainly also break new ground by introducing a
> >   "torture.c" file, for the first time in Linux kernel history! ;-) ]
> 
> Ooh...  I had better act fast!  ;-)
> 
> > But it's really your call, this is something you should only do if you are 
> > comfortable with it.
> 
> I have actually been thinking about it off and on for some time.

And here is a first cut.  Just the renaming and needed adjustments,
no splitting or merging of files.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

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
similarity index 99%
rename from kernel/rcutiny.c
rename to kernel/rcu/tiny.c
index 312e9709713f..238bb39b71c6 100644
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
index 8d85a5ce093a..8ca07e3d9f9b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -28,7 +28,7 @@
 #include <linux/gfp.h>
 #include <linux/oom.h>
 #include <linux/smpboot.h>
-#include "time/tick-internal.h"
+#include "../time/tick-internal.h"
 
 #define RCU_KTHREAD_PRIO 1
 
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

