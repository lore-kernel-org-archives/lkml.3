Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3IYBpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:45:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56753 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab3IYBm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:42:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/10] sched, rcu: Make RCU use resched_cpu()
Date: Tue, 24 Sep 2013 18:42:39 -0700
Message-Id: <1380073359-31959-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925014210.GA31690@linux.vnet.ibm.com>
 <1380073359-31959-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-8236-0000-0000-000002124077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

We're going to deprecate and remove set_need_resched() for it will do
the wrong thing. Make an exception for RCU and allow it to use
resched_cpu() which will do the right thing.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c    | 15 ++++++++++++++-
 kernel/sched/core.c | 10 ++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 54dd6d0..bd170f5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -898,6 +898,12 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
+/*
+ * This function really isn't for public consumption, but RCU is special in
+ * that context switches can allow the state machine to make progress.
+ */
+extern void resched_cpu(int cpu);
+
 static void print_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -927,7 +933,14 @@ static void print_cpu_stall(struct rcu_state *rsp)
 				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
-	set_need_resched();  /* kick ourselves to get things going. */
+	/*
+	 * Attempt to revive the RCU machinery by forcing a context switch.
+	 *
+	 * A context switch would normally allow the RCU state machine to make
+	 * progress and it could be we're stuck in kernel space without context
+	 * switches for an entirely unreasonable amount of time.
+	 */
+	resched_cpu(smp_processor_id());
 }
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..bd37fcc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -513,12 +513,11 @@ static inline void init_hrtick(void)
  * might also involve a cross-CPU call to trigger the scheduler on
  * the target CPU.
  */
-#ifdef CONFIG_SMP
 void resched_task(struct task_struct *p)
 {
 	int cpu;
 
-	assert_raw_spin_locked(&task_rq(p)->lock);
+	lockdep_assert_held(&task_rq(p)->lock);
 
 	if (test_tsk_need_resched(p))
 		return;
@@ -546,6 +545,7 @@ void resched_cpu(int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+#ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
@@ -693,12 +693,6 @@ void sched_avg_update(struct rq *rq)
 	}
 }
 
-#else /* !CONFIG_SMP */
-void resched_task(struct task_struct *p)
-{
-	assert_raw_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
-}
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \
-- 
1.8.1.5

