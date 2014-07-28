Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaG1W43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:56:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33159 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaG1W42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:56:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 2/9] rcu: Provide cond_resched_rcu_qs() to force quiescent states in long loops
Date: Mon, 28 Jul 2014 15:56:13 -0700
Message-Id: <1406588180-21933-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072822-6688-0000-0000-0000039D704D
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
index 05656b504295..3299ff98ad03 100644
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
index 7fa34f86e5ba..febe07062ac5 100644
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
index f958c52f644d..645a33efc0d4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1650,7 +1650,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		    system_state == SYSTEM_RUNNING)
 			udelay(200);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 
 	mutex_unlock(&rsp->onoff_mutex);
@@ -1739,7 +1739,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
@@ -1788,7 +1788,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
-			cond_resched();
+			cond_resched_rcu_qs();
 			flush_signals(current);
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
@@ -1831,10 +1831,10 @@ static int __noreturn rcu_gp_kthread(void *arg)
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
@@ -2437,7 +2437,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
-		cond_resched();
+		cond_resched_rcu_qs();
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		smp_mb__after_unlock_lock();
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 02ac0fb186b8..a86a363ea453 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1842,7 +1842,7 @@ static int rcu_oom_notify(struct notifier_block *self,
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, rcu_oom_notify_cpu, NULL, 1);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	put_online_cpus();
 
diff --git a/mm/mlock.c b/mm/mlock.c
index b1eb53634005..bc386a22d647 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -782,7 +782,7 @@ static int do_mlockall(int flags)
 
 		/* Ignore errors */
 		mlock_fixup(vma, &prev, vma->vm_start, vma->vm_end, newflags);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 out:
 	return 0;
-- 
1.8.1.5

