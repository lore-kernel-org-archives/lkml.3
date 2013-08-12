Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3HLLv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:51:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53939 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3HLLvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:51:25 -0400
Date: Mon, 12 Aug 2013 13:51:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, mingo@kernel.org,
        tglx@linutronix.de
Cc: bitbucket@online.de, hpa@zytor.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [RFC] per-cpu preempt_count
Message-ID: <20130812115113.GE27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

new thread since someone forgot to CC scheduler maintainers on actual
scheduler patches and I can't be arsed to look up the original thread.

The below boots to wanting to mount a root filesystem with
CONFIG_PREEMPT=y using kvm -smp 4.

I suppose we might want to move TIF_NEED_RESCHED into the preempt_count
just as we might want to move PREEMPT_ACTIVE out of it.

Adding TIF_NEED_RESCHED into the preempt count would allow a single test
in preempt_check_resched() instead of still needing the TI. Removing
PREEMPT_ACTIVE from preempt count should allow us to get rid of
ti::preempt_count altogether.

The only problem with TIF_NEED_RESCHED is that its cross-cpu which would
make the entire thing atomic which would suck donkey balls so maybe we
need two separate per-cpu variables? 

---
 arch/x86/kernel/entry_64.S |  2 +-
 include/linux/preempt.h    |  9 ++++++---
 kernel/context_tracking.c  |  3 +--
 kernel/sched/core.c        | 20 +++++++++++++++-----
 lib/smp_processor_id.c     |  3 +--
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1b69951..5ea77d2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1118,7 +1118,7 @@ ENTRY(native_iret)
 	/* Returning to kernel space. Check if we need preemption */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
-	cmpl $0,TI_preempt_count(%rcx)
+	cmpl $0,PER_CPU_VAR(__preempt_count_var)
 	jnz  retint_restore_args
 	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
 	jnc  retint_restore_args
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index f5d4723..2ca9c8ff 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -6,7 +6,7 @@
  * preempt_count (used for kernel preemption, interrupt count, etc.)
  */
 
-#include <linux/thread_info.h>
+#include <asm/percpu.h>
 #include <linux/linkage.h>
 #include <linux/list.h>
 
@@ -21,7 +21,9 @@
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
-#define preempt_count()	(current_thread_info()->preempt_count)
+DECLARE_PER_CPU(int, __preempt_count_var);
+
+#define preempt_count() __raw_get_cpu_var(__preempt_count_var)
 
 #ifdef CONFIG_PREEMPT
 
@@ -29,7 +31,8 @@ asmlinkage void preempt_schedule(void);
 
 #define preempt_check_resched() \
 do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+	if (unlikely(preempt_count() == 0 && \
+	             test_thread_flag(TIF_NEED_RESCHED))) \
 		preempt_schedule(); \
 } while (0)
 
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 383f823..6d113d8 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -87,10 +87,9 @@ void user_enter(void)
  */
 void __sched notrace preempt_schedule_context(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_ctx;
 
-	if (likely(ti->preempt_count || irqs_disabled()))
+	if (likely(preempt_count() || irqs_disabled()))
 		return;
 
 	/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 54957a6..59d0b6e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -89,6 +89,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
+DEFINE_PER_CPU(int, __preempt_count_var) = INIT_PREEMPT_COUNT;
+
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
@@ -2013,6 +2015,16 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 #endif
 
+#ifdef CONFIG_PREEMPT_COUNT
+	/*
+	 * If it weren't for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count() of all tasks was equal here and this wouldn't be
+	 * needed at all -- try and move PREEMPT_ACTIVE into TI_flags?
+	 */
+	task_thread_info(prev)->preempt_count = preempt_count();
+	preempt_count() = task_thread_info(next)->preempt_count;
+#endif
+
 	context_tracking_task_switch(prev, next);
 	/* Here we just switch the register state and the stack. */
 	switch_to(prev, next, prev);
@@ -2515,13 +2527,11 @@ void __sched schedule_preempt_disabled(void)
  */
 asmlinkage void __sched notrace preempt_schedule(void)
 {
-	struct thread_info *ti = current_thread_info();
-
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
 	 * we do not want to preempt the current task. Just return..
 	 */
-	if (likely(ti->preempt_count || irqs_disabled()))
+	if (likely(preempt_count() || irqs_disabled()))
 		return;
 
 	do {
@@ -2546,11 +2556,10 @@ EXPORT_SYMBOL(preempt_schedule);
  */
 asmlinkage void __sched preempt_schedule_irq(void)
 {
-	struct thread_info *ti = current_thread_info();
 	enum ctx_state prev_state;
 
 	/* Catch callers which need to be fixed */
-	BUG_ON(ti->preempt_count || !irqs_disabled());
+	BUG_ON(preempt_count() || !irqs_disabled());
 
 	prev_state = exception_enter();
 
@@ -4218,6 +4227,7 @@ void init_idle(struct task_struct *idle, int cpu)
 
 	/* Set the preempt count _outside_ the spinlocks! */
 	task_thread_info(idle)->preempt_count = 0;
+	per_cpu(__preempt_count_var, cpu) = 0;
 
 	/*
 	 * The idle tasks have their own, simple scheduling class:
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 4c0d0e5..04abe53 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -9,10 +9,9 @@
 
 notrace unsigned int debug_smp_processor_id(void)
 {
-	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
 
-	if (likely(preempt_count))
+	if (likely(preempt_count()))
 		goto out;
 
 	if (irqs_disabled())
