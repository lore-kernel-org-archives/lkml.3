Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaD2Aa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:58 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59713 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 29/45] sched,rcu: Make cond_resched() report RCU quiescent states
Date: Mon, 28 Apr 2014 17:25:17 -0700
Message-Id: <1398731133-18925-29-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D137E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Given a CPU running a loop containing cond_resched(), with no
other tasks runnable on that CPU, RCU will eventually report RCU
CPU stall warnings due to lack of quiescent states.  Fortunately,
every call to cond_resched() is a perfectly good quiescent state.
Unfortunately, invoking rcu_note_context_switch() is a bit heavyweight
for cond_resched(), especially given the need to disable preemption,
and, for RCU-preempt, interrupts as well.

This commit therefore maintains a per-CPU counter that causes
cond_resched(), cond_resched_lock(), and cond_resched_softirq() to call
rcu_note_context_switch(), but only about once per 256 invocations.
This ratio was chosen in keeping with the relative time constants of
RCU grace periods.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 36 ++++++++++++++++++++++++++++++++++++
 kernel/rcu/update.c      | 18 ++++++++++++++++++
 kernel/sched/core.c      |  7 ++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a6c3898e141e..baead1bd0556 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -44,6 +44,7 @@
 #include <linux/debugobjects.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/percpu.h>
 #include <asm/barrier.h>
 
 extern int rcu_expedited; /* for sysctl */
@@ -287,6 +288,41 @@ bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
 
 /*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+#define RCU_COND_RESCHED_LIM 256	/* ms vs. 100s of ms. */
+DECLARE_PER_CPU(int, rcu_cond_resched_count);
+void rcu_resched(void);
+
+/*
+ * Is it time to report RCU quiescent states?
+ *
+ * Note unsynchronized access to rcu_cond_resched_count.  Yes, we might
+ * increment some random CPU's count, and possibly also load the result from
+ * yet another CPU's count.  We might even clobber some other CPU's attempt
+ * to zero its counter.  This is all OK because the goal is not precision,
+ * but rather reasonable amortization of rcu_note_context_switch() overhead
+ * and extremely high probability of avoiding RCU CPU stall warnings.
+ * Note that this function has to be preempted in just the wrong place,
+ * many thousands of times in a row, for anything bad to happen.
+ */
+static inline bool rcu_should_resched(void)
+{
+	return raw_cpu_inc_return(rcu_cond_resched_count) >=
+	       RCU_COND_RESCHED_LIM;
+}
+
+/*
+ * Report quiscent states to RCU if it is time to do so.
+ */
+static inline void rcu_cond_resched(void)
+{
+	if (unlikely(rcu_should_resched()))
+		rcu_resched();
+}
+
+/*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
  */
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4c0a9b0af469..ed7a0d72562c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -338,3 +338,21 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
+/*
+ * Hooks for cond_resched() and friends to avoid RCU CPU stall warnings.
+ */
+
+DEFINE_PER_CPU(int, rcu_cond_resched_count);
+
+/*
+ * Report a set of RCU quiescent states, for use by cond_resched()
+ * and friends.  Out of line due to being called infrequently.
+ */
+void rcu_resched(void)
+{
+	preempt_disable();
+	__this_cpu_write(rcu_cond_resched_count, 0);
+	rcu_note_context_switch(smp_processor_id());
+	preempt_enable();
+}
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45ea238c..9f530c9ed911 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4051,6 +4051,7 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
+	rcu_cond_resched();
 	if (should_resched()) {
 		__cond_resched();
 		return 1;
@@ -4069,15 +4070,18 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int __cond_resched_lock(spinlock_t *lock)
 {
+	bool need_rcu_resched = rcu_should_resched();
 	int resched = should_resched();
 	int ret = 0;
 
 	lockdep_assert_held(lock);
 
-	if (spin_needbreak(lock) || resched) {
+	if (spin_needbreak(lock) || resched || need_rcu_resched) {
 		spin_unlock(lock);
 		if (resched)
 			__cond_resched();
+		else if (unlikely(need_rcu_resched))
+			rcu_resched();
 		else
 			cpu_relax();
 		ret = 1;
@@ -4091,6 +4095,7 @@ int __sched __cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
+	rcu_cond_resched();  /* BH disabled OK, just recording QSes. */
 	if (should_resched()) {
 		local_bh_enable();
 		__cond_resched();
-- 
1.8.1.5

