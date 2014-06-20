Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967115AbaFTSeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:34:17 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34263 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaFTSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:33:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Christoph Lameter <cl@gentwo.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH RFC tip/core/rcu 2/5] rcu: Provide cond_resched_rcu_qs() to force quiescent states in long loops
Date: Fri, 20 Jun 2014 11:33:20 -0700
Message-Id: <1403289203-6371-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140620183249.GA6325@linux.vnet.ibm.com>
 <1403289203-6371-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062018-0928-0000-0000-000002CB458B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Back in the Good Olde Days, the kernel entered the scheduler on every
CPU periodically, whether anyone needed it or not.  This was of course
wasteful and inefficient, so recent kernels have of course discontinued
this practice.  However, this means that a given CPU might execute
for a very long time in the kernel without entering the scheduler,
and thus for a very long time without RCU quiescent states.  This has
in fact happened on systems with unusual numbers of CPUs, open files,
and disk drives, and also on systems with large quantities of main memory.

Fortunately, each of the kernel's more than 500 calls to cond_resched()
can serve as an RCU quiescent state.  Unfortunately, there appears to
be some desire to make cond_resched() be a no-op for PREEMPT=y builds.

Therefore, this commit creates cond_resched_rcu_qs(), which acts as
cond_resched() except that it also supplies RCU with a quiescent state
when RCU needs one.  In the very common case where RCU does not need
a quiescent state, cond_resched_rcu_qs() adds only a test of a single
per-CPU variable.  Note that cond_resched_rcu_qs() is implemented as a
macro rather than an inline function to avoid include-file issues.

This commit also applies cond_resched_rcu_qs() in a few places known
to need it, should cond_resched() not provide RCU grace periods.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 fs/file.c                |  2 +-
 include/linux/rcutiny.h  |  4 ++++
 include/linux/rcutree.h  | 13 +++++++++++++
 kernel/rcu/rcutorture.c  |  4 ++--
 kernel/rcu/tree.c        | 12 ++++++------
 kernel/rcu/tree_plugin.h |  2 +-
 mm/mlock.c               |  2 +-
 7 files changed, 28 insertions(+), 11 deletions(-)

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
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index ff2ede319890..968977da1803 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -83,6 +83,10 @@ static inline void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 }
 
+static inline void cond_resched_rcu_qs(void)
+{
+}
+
 static inline bool rcu_should_resched(void)
 {
 	return false;
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 16780fed7155..ca7d34027935 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -62,6 +62,19 @@ static inline void rcu_cond_resched(void)
 		rcu_resched();
 }
 
+/**
+ * cond_resched_rcu_qs - Report potential quiescent states to RCU
+ *
+ * This macro resembles cond_resched(), except that it is defined to
+ * report potential quiescent states to RCU even if the cond_resched()
+ * machinery were to be shut off, as some advocate for PREEMPT kernels.
+ */
+#define cond_resched_rcu_qs() \
+do { \
+	rcu_cond_resched(); \
+	cond_resched(); \
+} while (0)
+
 void synchronize_rcu_bh(void);
 void synchronize_sched_expedited(void);
 void synchronize_rcu_expedited(void);
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
index 2cc72ce19ff6..8d1f45b41433 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1629,7 +1629,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		    system_state == SYSTEM_RUNNING)
 			udelay(200);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 
 	mutex_unlock(&rsp->onoff_mutex);
@@ -1718,7 +1718,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		/* smp_mb() provided by prior unlock-lock pair. */
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
-		cond_resched();
+		cond_resched_rcu_qs();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
@@ -1767,7 +1767,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			/* Locking provides needed memory barrier. */
 			if (rcu_gp_init(rsp))
 				break;
-			cond_resched();
+			cond_resched_rcu_qs();
 			flush_signals(current);
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
@@ -1810,10 +1810,10 @@ static int __noreturn rcu_gp_kthread(void *arg)
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
@@ -2414,7 +2414,7 @@ static void force_qs_rnp(struct rcu_state *rsp,
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

