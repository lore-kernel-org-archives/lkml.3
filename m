Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaH1TUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:20:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48010 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaH1TUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:20:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v7 tip/core/rcu 02/17] rcu: Provide cond_resched_rcu_qs() to force quiescent states in long loops
Date: Thu, 28 Aug 2014 12:19:53 -0700
Message-Id: <1409253608-32538-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191929.GA31795@linux.vnet.ibm.com>
 <1409253608-32538-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-1344-0000-0000-000003CACDA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU-tasks requires the occasional voluntary context switch
from CPU-bound in-kernel tasks.  In some cases, this requires
instrumenting cond_resched().  However, there is some reluctance
to countenance unconditionally instrumenting cond_resched() (see
http://lwn.net/Articles/603252/), so this commit creates a separate
cond_resched_rcu_qs() that may be used in place of cond_resched() in
locations prone to long-duration in-kernel looping.

This commit currently instruments only RCU-tasks.  Future possibilities
include also instrumenting RCU, RCU-bh, and RCU-sched in order to reduce
IPI usage.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 fs/file.c                |  2 +-
 include/linux/rcupdate.h | 13 +++++++++++++
 kernel/rcu/rcutorture.c  |  4 ++--
 kernel/rcu/tree.c        | 12 ++++++------
 kernel/rcu/tree_plugin.h |  2 +-
 mm/mlock.c               |  2 +-
 6 files changed, 24 insertions(+), 11 deletions(-)

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
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3432063f4c87..473350462d04 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -330,6 +330,19 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 #define rcu_note_voluntary_context_switch(t)	do { } while (0)
 #endif /* #else #ifdef CONFIG_TASKS_RCU */
 
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
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 948a7693748e..178716713e11 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -667,7 +667,7 @@ static int rcu_torture_boost(void *arg)
 				}
 				call_rcu_time = jiffies;
 			}
-			cond_resched();
+			cond_resched_rcu_qs();
 			stutter_wait("rcu_torture_boost");
 			if (torture_must_stop())
 				goto checkwait;
@@ -1019,7 +1019,7 @@ rcu_torture_reader(void *arg)
 		__this_cpu_inc(rcu_torture_batch[completed]);
 		preempt_enable();
 		cur_ops->readunlock(idx);
-		cond_resched();
+		cond_resched_rcu_qs();
 		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
 	if (irqreader && cur_ops->irq_capable) {
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8ad91d1e317d..e23dad0661e2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1647,7 +1647,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->level, rnp->grplo,
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 
 	mutex_unlock(&rsp->onoff_mutex);
@@ -1736,7 +1736,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
@@ -1785,7 +1785,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
-			cond_resched();
+			cond_resched_rcu_qs();
 			flush_signals(current);
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
@@ -1828,10 +1828,10 @@ static int __noreturn rcu_gp_kthread(void *arg)
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
 						       TPS("fqsend"));
-				cond_resched();
+				cond_resched_rcu_qs();
 			} else {
 				/* Deal with stray signal. */
-				cond_resched();
+				cond_resched_rcu_qs();
 				flush_signals(current);
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
@@ -2434,7 +2434,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
-		cond_resched();
+		cond_resched_rcu_qs();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 00dc411e9676..36a892d11226 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1848,7 +1848,7 @@ static int rcu_oom_notify(struct notifier_block *self,
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, rcu_oom_notify_cpu, NULL, 1);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	put_online_cpus();
 
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
-- 
1.8.1.5

