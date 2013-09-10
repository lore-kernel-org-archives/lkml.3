Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IJNXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:23:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46866 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3IJNV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:21:27 -0400
Message-Id: <20130910132011.116593485@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Sep 2013 15:08:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/7] sched: Add NEED_RESCHED to the preempt_count
References: <20130910130811.507933095@infradead.org>
Content-Disposition: inline; filename=peterz-preempt_count-need_resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to combine the preemption and need_resched test we need to
fold the need_resched information into the preempt_count value.

We keep the existing TIF_NEED_RESCHED infrastructure in place but at 3
sites test it and fold its value into preempt_count; namely:

 - resched_task() when setting TIF_NEED_RESCHED on the current task
 - scheduler_ipi() when resched_task() sets TIF_NEED_RESCHED on a
                   remote task it follows it up with a reschedule IPI
                   and we can modify the cpu local preempt_count from
                   there.
 - cpu_idle_loop() for when resched_task() found tsk_is_polling().

We use an inverted bitmask to indicate need_resched so that a 0 means
both need_resched and !atomic.

Also remove the barrier() in preempt_enable() between
preempt_enable_no_resched() and preempt_check_resched() to avoid
having to reload the preemption value and allow the compiler to use
the flags of the previuos decrement. I couldn't come up with any sane
reason for this barrier() to be there as preempt_enable_no_resched()
already has a barrier() before doing the decrement.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/preempt.h     |   42 +++++++++++++++++++++++++++++++++++++-----
 include/linux/sched.h       |    2 +-
 include/linux/thread_info.h |    1 +
 kernel/context_tracking.c   |    2 +-
 kernel/cpu/idle.c           |   10 ++++++++++
 kernel/sched/core.c         |   18 ++++++++++++++----
 6 files changed, 64 insertions(+), 11 deletions(-)

--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -10,9 +10,19 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
+/*
+ * We use the MSB mostly because its available; see <linux/hardirq.h> for
+ * the other bits.
+ */
+#define PREEMPT_NEED_RESCHED	0x80000000
+
+/*
+ * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
+ * that think a non-zero value indicates we cannot preempt.
+ */
 static __always_inline int preempt_count(void)
 {
-	return current_thread_info()->preempt_count;
+	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
 }
 
 static __always_inline int *preempt_count_ptr(void)
@@ -20,6 +30,30 @@ static __always_inline int *preempt_coun
 	return &current_thread_info()->preempt_count;
 }
 
+/*
+ * We fold the NEED_RESCHED bit into the preempt count such that
+ * preempt_enable() can decrement and test for needing to reschedule with a
+ * single instruction.
+ *
+ * We invert the actual bit, so that when the decrement hits 0 we know we both
+ * need to resched (the bit is cleared) and can resched (no preempt count).
+ */
+
+static __always_inline void set_preempt_need_resched(void)
+{
+	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline void clear_preempt_need_resched(void)
+{
+	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline bool test_preempt_need_resched(void)
+{
+	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
+}
+
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
@@ -37,7 +71,7 @@ asmlinkage void preempt_schedule(void);
 
 #define preempt_check_resched() \
 do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+	if (unlikely(!*preempt_count_ptr())) \
 		preempt_schedule(); \
 } while (0)
 
@@ -47,7 +81,7 @@ void preempt_schedule_context(void);
 
 #define preempt_check_resched_context() \
 do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+	if (unlikely(!*preempt_count_ptr())) \
 		preempt_schedule_context(); \
 } while (0)
 #else
@@ -83,7 +117,6 @@ do { \
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
-	barrier(); \
 	preempt_check_resched(); \
 } while (0)
 
@@ -111,7 +144,6 @@ do { \
 #define preempt_enable_notrace() \
 do { \
 	preempt_enable_no_resched_notrace(); \
-	barrier(); \
 	preempt_check_resched_context(); \
 } while (0)
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2405,7 +2405,7 @@ static inline int signal_pending_state(l
 
 static inline int need_resched(void)
 {
-	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
+	return unlikely(test_preempt_need_resched());
 }
 
 /*
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -104,6 +104,7 @@ static inline int test_ti_thread_flag(st
 #define test_thread_flag(flag) \
 	test_ti_thread_flag(current_thread_info(), flag)
 
+#define test_need_resched()	test_thread_flag(TIF_NEED_RESCHED)
 #define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
 #define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
 
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -115,7 +115,7 @@ void __sched notrace preempt_schedule_co
 {
 	enum ctx_state prev_ctx;
 
-	if (likely(!preemptible()))
+	if (likely(preempt_count() || irqs_disabled()))
 		return;
 
 	/*
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -106,6 +106,13 @@ static void cpu_idle_loop(void)
 				current_set_polling();
 			}
 			arch_cpu_idle_exit();
+			/*
+			 * We need to test and propagate the TIF_NEED_RESCHED
+			 * bit here because we might not have send the
+			 * reschedule IPI to idle tasks.
+			 */
+			if (test_need_resched())
+				set_preempt_need_resched();
 		}
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -526,8 +526,10 @@ void resched_task(struct task_struct *p)
 	set_tsk_need_resched(p);
 
 	cpu = task_cpu(p);
-	if (cpu == smp_processor_id())
+	if (cpu == smp_processor_id()) {
+		set_preempt_need_resched();
 		return;
+	}
 
 	/* NEED_RESCHED must be visible before we test polling */
 	smp_mb();
@@ -1411,6 +1413,14 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
+	/*
+	 * Fold TIF_NEED_RESCHED into the preempt_count; anybody setting
+	 * TIF_NEED_RESCHED remotely (for the first time) will also send
+	 * this IPI.
+	 */
+	if (test_need_resched())
+		set_preempt_need_resched();
+
 	if (llist_empty(&this_rq()->wake_list)
 			&& !tick_nohz_full_cpu(smp_processor_id())
 			&& !got_nohz_idle_kick())
@@ -2445,6 +2455,7 @@ static void __sched __schedule(void)
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);
+	clear_preempt_need_resched();
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
@@ -2531,7 +2542,7 @@ asmlinkage void __sched notrace preempt_
 	 * If there is a non-zero preempt_count or interrupts are disabled,
 	 * we do not want to preempt the current task. Just return..
 	 */
-	if (likely(!preemptible()))
+	if (likely(preempt_count() || irqs_disabled()))
 		return;
 
 	do {
@@ -2556,11 +2567,10 @@ EXPORT_SYMBOL(preempt_schedule);
  */
 asmlinkage void __sched preempt_schedule_irq(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_state;
 
 	/* Catch callers which need to be fixed */
-	BUG_ON(ti->preempt_count || !irqs_disabled());
+	BUG_ON(preempt_count() || !irqs_disabled());
 
 	prev_state = exception_enter();
 


