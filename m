Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3JBPIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:08:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48607 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3JBPI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:08:27 -0400
Message-Id: <20131002150518.748974359@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 16:56:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] hotplug: Optimize cpu_hotplug_{begin,done}() using rcu_sync
References: <20131002145655.361606532@infradead.org>
Content-Disposition: inline; filename=peterz-cpu-hotplug-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the fancy new rcu_sync bits from Oleg to optimize the fancy new
hotplug lock implementation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/cpu.h |    7 ++++---
 kernel/cpu.c        |   52 +++++++++++++++++++++++-----------------------------
 2 files changed, 27 insertions(+), 32 deletions(-)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -18,6 +18,7 @@
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
+#include <linux/rcusync.h>
 
 struct device;
 
@@ -180,7 +181,7 @@ extern void cpu_hotplug_init_task(struct
 extern void cpu_hotplug_begin(void);
 extern void cpu_hotplug_done(void);
 
-extern int __cpuhp_state;
+extern struct rcu_sync_struct __cpuhp_rss;
 DECLARE_PER_CPU(unsigned int, __cpuhp_refcount);
 
 extern void __get_online_cpus(void);
@@ -204,7 +205,7 @@ static inline void get_online_cpus(void)
 	 * writer will see anything we did within this RCU-sched read-side
 	 * critical section.
 	 */
-	if (likely(!__cpuhp_state))
+	if (likely(rcu_sync_is_idle(&__cpuhp_rss)))
 		__this_cpu_inc(__cpuhp_refcount);
 	else
 		__get_online_cpus(); /* Unconditional memory barrier. */
@@ -231,7 +232,7 @@ static inline void put_online_cpus(void)
 	/*
 	 * Same as in get_online_cpus().
 	 */
-	if (likely(!__cpuhp_state))
+	if (likely(rcu_sync_is_idle(&__cpuhp_rss)))
 		__this_cpu_dec(__cpuhp_refcount);
 	else
 		__put_online_cpus(); /* Unconditional memory barrier. */
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -49,14 +49,15 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-enum { readers_fast = 0, readers_slow, readers_block };
+enum { readers_slow, readers_block };
 
-int __cpuhp_state;
-EXPORT_SYMBOL_GPL(__cpuhp_state);
+DEFINE_RCU_SCHED_SYNC(__cpuhp_rss);
+EXPORT_SYMBOL_GPL(__cpuhp_rss);
 
 DEFINE_PER_CPU(unsigned int, __cpuhp_refcount);
 EXPORT_PER_CPU_SYMBOL_GPL(__cpuhp_refcount);
 
+static int cpuhp_state = readers_slow;
 static atomic_t cpuhp_waitcount;
 static DECLARE_WAIT_QUEUE_HEAD(cpuhp_readers);
 static DECLARE_WAIT_QUEUE_HEAD(cpuhp_writer);
@@ -68,7 +69,6 @@ void cpu_hotplug_init_task(struct task_s
 
 void __get_online_cpus(void)
 {
-again:
 	__this_cpu_inc(__cpuhp_refcount);
 
 	/*
@@ -77,7 +77,7 @@ void __get_online_cpus(void)
 	 * increment-on-one-CPU-and-decrement-on-another problem.
 	 *
 	 * And yes, if the reader misses the writer's assignment of
-	 * readers_block to __cpuhp_state, then the writer is
+	 * readers_block to cpuhp_state, then the writer is
 	 * guaranteed to see the reader's increment.  Conversely, any
 	 * readers that increment their __cpuhp_refcount after the
 	 * writer looks are guaranteed to see the readers_block value,
@@ -88,7 +88,7 @@ void __get_online_cpus(void)
 
 	smp_mb(); /* A matches D */
 
-	if (likely(__cpuhp_state != readers_block))
+	if (likely(cpuhp_state != readers_block))
 		return;
 
 	/*
@@ -108,19 +108,19 @@ void __get_online_cpus(void)
 	 * and reschedule on the preempt_enable() in get_online_cpus().
 	 */
 	preempt_enable_no_resched();
-	__wait_event(cpuhp_readers, __cpuhp_state != readers_block);
+	__wait_event(cpuhp_readers, cpuhp_state != readers_block);
 	preempt_disable();
 
+	__this_cpu_inc(__cpuhp_refcount);
+
 	/*
-	 * Given we've still got preempt_disabled and new cpu_hotplug_begin()
-	 * must do a synchronize_sched() we're guaranteed a successfull
-	 * acquisition this time -- even if we wake the current
-	 * cpu_hotplug_end() now.
+	 * cpu_hotplug_done() waits until all pending readers are gone;
+	 * this means that a new cpu_hotplug_begin() must observe our
+	 * refcount increment and wait for it to go away.
 	 */
-	if (atomic_dec_and_test(&cpuhp_waitcount))
-		wake_up(&cpuhp_writer);
 
-	goto again;
+	if (atomic_dec_and_test(&cpuhp_waitcount)) /* A */
+		wake_up(&cpuhp_writer);
 }
 EXPORT_SYMBOL_GPL(__get_online_cpus);
 
@@ -183,21 +183,18 @@ void cpu_hotplug_begin(void)
 	current->cpuhp_ref++;
 
 	/* Notify readers to take the slow path. */
-	__cpuhp_state = readers_slow;
-
-	/* See percpu_down_write(); guarantees all readers take the slow path */
-	synchronize_sched();
+	rcu_sync_enter(&__cpuhp_rss);
 
 	/*
 	 * Notify new readers to block; up until now, and thus throughout the
 	 * longish synchronize_sched() above, new readers could still come in.
 	 */
-	__cpuhp_state = readers_block;
+	cpuhp_state = readers_block;
 
 	smp_mb(); /* D matches A */
 
 	/*
-	 * If they don't see our writer of readers_block to __cpuhp_state,
+	 * If they don't see our writer of readers_block to cpuhp_state,
 	 * then we are guaranteed to see their __cpuhp_refcount increment, and
 	 * therefore will wait for them.
 	 */
@@ -215,26 +212,23 @@ void cpu_hotplug_done(void)
 	 * that new readers might fail to see the results of this writer's
 	 * critical section.
 	 */
-	__cpuhp_state = readers_slow;
+	cpuhp_state = readers_slow;
 	wake_up_all(&cpuhp_readers);
 
 	/*
 	 * The wait_event()/wake_up_all() prevents the race where the readers
-	 * are delayed between fetching __cpuhp_state and blocking.
+	 * are delayed between fetching cpuhp_state and blocking.
 	 */
 
-	/* See percpu_up_write(); readers will no longer attempt to block. */
-	synchronize_sched();
-
-	/* Let 'em rip */
-	__cpuhp_state = readers_fast;
 	current->cpuhp_ref--;
 
 	/*
-	 * Wait for any pending readers to be running. This ensures readers
-	 * after writer and avoids writers starving readers.
+	 * Wait for any pending readers to be running. This avoids writers
+	 * starving readers.
 	 */
 	wait_event(cpuhp_writer, !atomic_read(&cpuhp_waitcount));
+
+	rcu_sync_exit(&__cpuhp_rss);
 }
 
 /*


