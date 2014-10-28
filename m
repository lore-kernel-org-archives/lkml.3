Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaJ1V6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:58:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43323 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbaJ1V5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/10] rcu: Remove "cpu" argument to rcu_needs_cpu()
Date: Tue, 28 Oct 2014 14:53:34 -0700
Message-Id: <1414533217-24910-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0033-0000-0000-000000E3EBB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The "cpu" argument to rcu_needs_cpu() is always the current CPU, so drop
it.  This in turn allows the "cpu" argument to rcu_cpu_has_callbacks()
to be removed, which allows the uses of "cpu" in both functions to be
replaced with a this_cpu_ptr().  Again, the anticipated cross-CPU uses
of these functions has been replaced by NO_HZ_FULL.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  2 +-
 include/linux/rcutree.h  |  2 +-
 kernel/rcu/tree.c        |  4 ++--
 kernel/rcu/tree_plugin.h | 12 ++++++------
 kernel/time/tick-sched.c |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b4ad275d90d0..4eb810832b19 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1103,7 +1103,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	__kfree_rcu(&((ptr)->rcu_head), offsetof(typeof(*(ptr)), rcu_head))
 
 #if defined(CONFIG_TINY_RCU) || defined(CONFIG_RCU_NOCB_CPU_ALL)
-static inline int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+static inline int rcu_needs_cpu(unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
 	return 0;
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 7b5484db1857..52953790dcca 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -32,7 +32,7 @@
 
 void rcu_note_context_switch(void);
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies);
+int rcu_needs_cpu(unsigned long *delta_jiffies);
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 void rcu_cpu_stall_reset(void);
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index b591f1459240..d678a98caf1d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3159,7 +3159,7 @@ static int rcu_pending(void)
  * non-NULL, store an indication of whether all callbacks are lazy.
  * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
+static int __maybe_unused rcu_cpu_has_callbacks(bool *all_lazy)
 {
 	bool al = true;
 	bool hc = false;
@@ -3167,7 +3167,7 @@ static int __maybe_unused rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
+		rdp = this_cpu_ptr(rsp->rda);
 		if (!rdp->nxtlist)
 			continue;
 		hc = true;
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 495d4cce47a7..1797b76cb3ff 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1512,10 +1512,10 @@ static void rcu_prepare_kthreads(int cpu)
  * any flavor of RCU.
  */
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+int rcu_needs_cpu(unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
-	return rcu_cpu_has_callbacks(cpu, NULL);
+	return rcu_cpu_has_callbacks(NULL);
 }
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
@@ -1624,15 +1624,15 @@ static bool __maybe_unused rcu_try_advance_all_cbs(void)
  * The caller must have disabled interrupts.
  */
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
-int rcu_needs_cpu(int cpu, unsigned long *dj)
+int rcu_needs_cpu(unsigned long *dj)
 {
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	/* Snapshot to detect later posting of non-lazy callback. */
 	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
 
 	/* If no callbacks, RCU doesn't need the CPU. */
-	if (!rcu_cpu_has_callbacks(cpu, &rdtp->all_lazy)) {
+	if (!rcu_cpu_has_callbacks(&rdtp->all_lazy)) {
 		*dj = ULONG_MAX;
 		return 0;
 	}
@@ -1679,7 +1679,7 @@ static void rcu_prepare_for_idle(int cpu)
 	/* Handle nohz enablement switches conservatively. */
 	tne = ACCESS_ONCE(tick_nohz_active);
 	if (tne != rdtp->tick_nohz_enabled_snap) {
-		if (rcu_cpu_has_callbacks(cpu, NULL))
+		if (rcu_cpu_has_callbacks(NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
 		rdtp->tick_nohz_enabled_snap = tne;
 		return;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7b5741fc4110..1f4356037a7d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -585,7 +585,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 		last_jiffies = jiffies;
 	} while (read_seqretry(&jiffies_lock, seq));
 
-	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
+	if (rcu_needs_cpu(&rcu_delta_jiffies) ||
 	    arch_needs_cpu() || irq_work_needs_cpu()) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
-- 
1.8.1.5

