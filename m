Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3JBPIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:08:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48613 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab3JBPIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:08:32 -0400
Message-Id: <20131002150518.600557855@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 16:56:56 +0200
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
Subject: [PATCH 1/3] hotplug: Optimize {get,put}_online_cpus()
References: <20131002145655.361606532@infradead.org>
Content-Disposition: inline; filename=peterz-per-cpu-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of get_online_cpus() is global of nature
and thus not suited for any kind of common usage.

Re-implement the current recursive r/w cpu hotplug lock such that the
read side locks are as light as possible.

The current cpu hotplug lock is entirely reader biased; but since
readers are expensive there aren't a lot of them about and writer
starvation isn't a particular problem.

However by making the reader side more usable there is a fair chance
it will get used more and thus the starvation issue becomes a real
possibility.

Therefore this new implementation is fair, alternating readers and
writers; this however requires per-task state to allow the reader
recursion -- this new task_struct member is placed in a 4 byte hole on
64bit builds.

Many comments are contributed by Paul McKenney, and many previous
attempts were shown to be inadequate by both Paul and Oleg; many
thanks to them for persisting to poke holes in my attempts.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/cpu.h   |   67 ++++++++++++++
 include/linux/sched.h |    3 
 kernel/cpu.c          |  226 ++++++++++++++++++++++++++++++++++++--------------
 kernel/sched/core.c   |    2 
 4 files changed, 235 insertions(+), 63 deletions(-)

--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -16,6 +16,8 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
 
 struct device;
 
@@ -173,10 +175,69 @@ extern struct bus_type cpu_subsys;
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
 
+extern void cpu_hotplug_init_task(struct task_struct *p);
+
 extern void cpu_hotplug_begin(void);
 extern void cpu_hotplug_done(void);
-extern void get_online_cpus(void);
-extern void put_online_cpus(void);
+
+extern int __cpuhp_state;
+DECLARE_PER_CPU(unsigned int, __cpuhp_refcount);
+
+extern void __get_online_cpus(void);
+
+static inline void get_online_cpus(void)
+{
+	might_sleep();
+
+	/* Support reader recursion */
+	/* The value was >= 1 and remains so, reordering causes no harm. */
+	if (current->cpuhp_ref++)
+		return;
+
+	preempt_disable();
+	/*
+	 * We are in an RCU-sched read-side critical section, so the writer
+	 * cannot both change __cpuhp_state from readers_fast and start
+	 * checking counters while we are here. So if we see !__cpuhp_state,
+	 * we know that the writer won't be checking until we past the
+	 * preempt_enable() and that once the synchronize_sched() is done, the
+	 * writer will see anything we did within this RCU-sched read-side
+	 * critical section.
+	 */
+	if (likely(!__cpuhp_state))
+		__this_cpu_inc(__cpuhp_refcount);
+	else
+		__get_online_cpus(); /* Unconditional memory barrier. */
+	preempt_enable();
+	/*
+	 * The barrier() from preempt_enable() prevents the compiler from
+	 * bleeding the critical section out.
+	 */
+}
+
+extern void __put_online_cpus(void);
+
+static inline void put_online_cpus(void)
+{
+	/* The value was >= 1 and remains so, reordering causes no harm. */
+	if (--current->cpuhp_ref)
+		return;
+
+	/*
+	 * The barrier() in preempt_disable() prevents the compiler from
+	 * bleeding the critical section out.
+	 */
+	preempt_disable();
+	/*
+	 * Same as in get_online_cpus().
+	 */
+	if (likely(!__cpuhp_state))
+		__this_cpu_dec(__cpuhp_refcount);
+	else
+		__put_online_cpus(); /* Unconditional memory barrier. */
+	preempt_enable();
+}
+
 extern void cpu_hotplug_disable(void);
 extern void cpu_hotplug_enable(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
@@ -200,6 +261,8 @@ static inline void cpu_hotplug_driver_un
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
+static inline void cpu_hotplug_init_task(struct task_struct *p) {}
+
 static inline void cpu_hotplug_begin(void) {}
 static inline void cpu_hotplug_done(void) {}
 #define get_online_cpus()	do { } while (0)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1039,6 +1039,9 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	struct llist_node wake_entry;
 	int on_cpu;
+#ifdef CONFIG_HOTPLUG_CPU
+	int cpuhp_ref;
+#endif
 	struct task_struct *last_wakee;
 	unsigned long wakee_flips;
 	unsigned long wakee_flip_decay_ts;
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -49,88 +49,192 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-static struct {
-	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
-	/*
-	 * Also blocks the new readers during
-	 * an ongoing cpu hotplug operation.
-	 */
-	int refcount;
-} cpu_hotplug = {
-	.active_writer = NULL,
-	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
-	.refcount = 0,
-};
+enum { readers_fast = 0, readers_slow, readers_block };
 
-void get_online_cpus(void)
+int __cpuhp_state;
+EXPORT_SYMBOL_GPL(__cpuhp_state);
+
+DEFINE_PER_CPU(unsigned int, __cpuhp_refcount);
+EXPORT_PER_CPU_SYMBOL_GPL(__cpuhp_refcount);
+
+static atomic_t cpuhp_waitcount;
+static DECLARE_WAIT_QUEUE_HEAD(cpuhp_readers);
+static DECLARE_WAIT_QUEUE_HEAD(cpuhp_writer);
+
+void cpu_hotplug_init_task(struct task_struct *p)
 {
-	might_sleep();
-	if (cpu_hotplug.active_writer == current)
+	p->cpuhp_ref = 0;
+}
+
+void __get_online_cpus(void)
+{
+again:
+	__this_cpu_inc(__cpuhp_refcount);
+
+	/*
+	 * Due to having preemption disabled the decrement happens on
+	 * the same CPU as the increment, avoiding the
+	 * increment-on-one-CPU-and-decrement-on-another problem.
+	 *
+	 * And yes, if the reader misses the writer's assignment of
+	 * readers_block to __cpuhp_state, then the writer is
+	 * guaranteed to see the reader's increment.  Conversely, any
+	 * readers that increment their __cpuhp_refcount after the
+	 * writer looks are guaranteed to see the readers_block value,
+	 * which in turn means that they are guaranteed to immediately
+	 * decrement their __cpuhp_refcount, so that it doesn't matter
+	 * that the writer missed them.
+	 */
+
+	smp_mb(); /* A matches D */
+
+	if (likely(__cpuhp_state != readers_block))
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
 
+	/*
+	 * Make sure an outgoing writer sees the waitcount to ensure we
+	 * make progress.
+	 */
+	atomic_inc(&cpuhp_waitcount);
+
+	/*
+	 * Per the above comment; we still have preemption disabled and
+	 * will thus decrement on the same CPU as we incremented.
+	 */
+	__put_online_cpus();
+
+	/*
+	 * We either call schedule() in the wait, or we'll fall through
+	 * and reschedule on the preempt_enable() in get_online_cpus().
+	 */
+	preempt_enable_no_resched();
+	__wait_event(cpuhp_readers, __cpuhp_state != readers_block);
+	preempt_disable();
+
+	/*
+	 * Given we've still got preempt_disabled and new cpu_hotplug_begin()
+	 * must do a synchronize_sched() we're guaranteed a successfull
+	 * acquisition this time -- even if we wake the current
+	 * cpu_hotplug_end() now.
+	 */
+	if (atomic_dec_and_test(&cpuhp_waitcount))
+		wake_up(&cpuhp_writer);
+
+	goto again:
 }
-EXPORT_SYMBOL_GPL(get_online_cpus);
+EXPORT_SYMBOL_GPL(__get_online_cpus);
 
-void put_online_cpus(void)
+void __put_online_cpus(void)
 {
-	if (cpu_hotplug.active_writer == current)
-		return;
-	mutex_lock(&cpu_hotplug.lock);
+	smp_mb(); /* B matches C */
+	/*
+	 * In other words, if they see our decrement (presumably to aggregate
+	 * zero, as that is the only time it matters) they will also see our
+	 * critical section.
+	 */
+	this_cpu_dec(__cpuhp_refcount);
+
+	/* Prod writer to recheck readers_active */
+	wake_up(&cpuhp_writer);
+}
+EXPORT_SYMBOL_GPL(__put_online_cpus);
+
+#define per_cpu_sum(var)						\
+({ 									\
+ 	typeof(var) __sum = 0;						\
+ 	int cpu;							\
+ 	for_each_possible_cpu(cpu)					\
+ 		__sum += per_cpu(var, cpu);				\
+ 	__sum;								\
+)}
 
-	if (WARN_ON(!cpu_hotplug.refcount))
-		cpu_hotplug.refcount++; /* try to fix things up */
+/*
+ * See srcu_readers_active_idx_check() for a rather more detailed explanation.
+ */
+static bool cpuhp_readers_active_check(void)
+{
+	if (per_cpu_sum(__cpuhp_refcount) != 0)
+		return false;
 
-	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
-		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
+	/*
+	 * If we observed the decrement; ensure we see the entire critical
+	 * section.
+	 */
+
+	smp_mb(); /* C matches B */
 
+	return true;
 }
-EXPORT_SYMBOL_GPL(put_online_cpus);
 
 /*
- * This ensures that the hotplug operation can begin only when the
- * refcount goes to zero.
- *
- * Note that during a cpu-hotplug operation, the new readers, if any,
- * will be blocked by the cpu_hotplug.lock
- *
- * Since cpu_hotplug_begin() is always called after invoking
- * cpu_maps_update_begin(), we can be sure that only one writer is active.
- *
- * Note that theoretically, there is a possibility of a livelock:
- * - Refcount goes to zero, last reader wakes up the sleeping
- *   writer.
- * - Last reader unlocks the cpu_hotplug.lock.
- * - A new reader arrives at this moment, bumps up the refcount.
- * - The writer acquires the cpu_hotplug.lock finds the refcount
- *   non zero and goes to sleep again.
- *
- * However, this is very difficult to achieve in practice since
- * get_online_cpus() not an api which is called all that often.
- *
+ * This will notify new readers to block and wait for all active readers to
+ * complete.
  */
 void cpu_hotplug_begin(void)
 {
-	cpu_hotplug.active_writer = current;
+	/*
+	 * Since cpu_hotplug_begin() is always called after invoking
+	 * cpu_maps_update_begin(), we can be sure that only one writer is
+	 * active.
+	 */
+	lockdep_assert_held(&cpu_add_remove_lock);
+
+	/* Allow reader-in-writer recursion. */
+	current->cpuhp_ref++;
+
+	/* Notify readers to take the slow path. */
+	__cpuhp_state = readers_slow;
+
+	/* See percpu_down_write(); guarantees all readers take the slow path */
+	synchronize_sched();
+
+	/*
+	 * Notify new readers to block; up until now, and thus throughout the
+	 * longish synchronize_sched() above, new readers could still come in.
+	 */
+	__cpuhp_state = readers_block;
 
-	for (;;) {
-		mutex_lock(&cpu_hotplug.lock);
-		if (likely(!cpu_hotplug.refcount))
-			break;
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
-		schedule();
-	}
+	smp_mb(); /* D matches A */
+
+	/*
+	 * If they don't see our writer of readers_block to __cpuhp_state,
+	 * then we are guaranteed to see their __cpuhp_refcount increment, and
+	 * therefore will wait for them.
+	 */
+
+	/* Wait for all now active readers to complete. */
+	wait_event(cpuhp_writer, cpuhp_readers_active_check());
 }
 
 void cpu_hotplug_done(void)
 {
-	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	/*
+	 * Signal the writer is done, no fast path yet.
+	 *
+	 * One reason that we cannot just immediately flip to readers_fast is
+	 * that new readers might fail to see the results of this writer's
+	 * critical section.
+	 */
+	__cpuhp_state = readers_slow;
+	wake_up_all(&cpuhp_readers);
+
+	/*
+	 * The wait_event()/wake_up_all() prevents the race where the readers
+	 * are delayed between fetching __cpuhp_state and blocking.
+	 */
+
+	/* See percpu_up_write(); readers will no longer attempt to block. */
+	synchronize_sched();
+
+	/* Let 'em rip */
+	__cpuhp_state = readers_fast;
+	current->cpuhp_ref--;
+
+	/*
+	 * Wait for any pending readers to be running. This ensures readers
+	 * after writer and avoids writers starving readers.
+	 */
+	wait_event(cpuhp_writer, !atomic_read(&cpuhp_waitcount));
 }
 
 /*
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1635,6 +1635,8 @@ static void __sched_fork(struct task_str
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
 #endif /* CONFIG_NUMA_BALANCING */
+
+	cpu_hotplug_init_task(p);
 }
 
 #ifdef CONFIG_NUMA_BALANCING


