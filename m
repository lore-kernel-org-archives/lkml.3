Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab3HNNlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:41:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab3HNNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:34:59 -0400
Message-Id: <20130814133142.576319491@chello.nl>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 15:15:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 1/5] sched: Introduce preempt_count accessor functions
References: <20130814131539.790947874@chello.nl>
Content-Disposition: inline; filename=peterz-preempt_count-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the single preempt_count() 'function' that's an lvalue with
two proper functions:

 preempt_count() - returns the preempt_count value as rvalue
 preempt_count_ptr() - returns a pointer to the preempt_count

Then change all sites that modify the preempt count to use
preempt_count_ptr().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-7zr0ph7cvibcp96lw02ln9nr@git.kernel.org
---
 include/linux/preempt.h |   20 ++++++++++++++------
 init/main.c             |    2 +-
 kernel/sched/core.c     |    4 ++--
 kernel/softirq.c        |    4 ++--
 kernel/timer.c          |    8 ++++----
 lib/smp_processor_id.c  |    3 +--
 6 files changed, 24 insertions(+), 17 deletions(-)

--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -10,19 +10,27 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
+static __always_inline int preempt_count(void)
+{
+	return current_thread_info()->preempt_count;
+}
+
+static __always_inline int *preempt_count_ptr(void)
+{
+	return &current_thread_info()->preempt_count;
+}
+
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
-# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define add_preempt_count(val)	do { *preempt_count_ptr() += (val); } while (0)
+# define sub_preempt_count(val)	do { *preempt_count_ptr() -= (val); } while (0)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
-#define preempt_count()	(current_thread_info()->preempt_count)
-
 #ifdef CONFIG_PREEMPT
 
 asmlinkage void preempt_schedule(void);
@@ -81,9 +89,9 @@ do { \
 
 /* For debugging and tracer internals only! */
 #define add_preempt_count_notrace(val)			\
-	do { preempt_count() += (val); } while (0)
+	do { *preempt_count_ptr() += (val); } while (0)
 #define sub_preempt_count_notrace(val)			\
-	do { preempt_count() -= (val); } while (0)
+	do { *preempt_count_ptr() -= (val); } while (0)
 #define inc_preempt_count_notrace() add_preempt_count_notrace(1)
 #define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
 
--- a/init/main.c
+++ b/init/main.c
@@ -690,7 +690,7 @@ int __init_or_module do_one_initcall(ini
 
 	if (preempt_count() != count) {
 		sprintf(msgbuf, "preemption imbalance ");
-		preempt_count() = count;
+		*preempt_count_ptr() = count;
 	}
 	if (irqs_disabled()) {
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2233,7 +2233,7 @@ void __kprobes add_preempt_count(int val
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	preempt_count() += val;
+	*preempt_count_ptr() += val;
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -2264,7 +2264,7 @@ void __kprobes sub_preempt_count(int val
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	preempt_count() -= val;
+	*preempt_count_ptr() -= val;
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -106,7 +106,7 @@ static void __local_bh_disable(unsigned
 	 * We must manually increment preempt_count here and manually
 	 * call the trace_preempt_off later.
 	 */
-	preempt_count() += cnt;
+	*preempt_count_ptr() += cnt;
 	/*
 	 * Were softirqs turned off above:
 	 */
@@ -256,7 +256,7 @@ asmlinkage void __do_softirq(void)
 				       " exited with %08x?\n", vec_nr,
 				       softirq_to_name[vec_nr], h->action,
 				       prev_count, preempt_count());
-				preempt_count() = prev_count;
+				*preempt_count_ptr() = prev_count;
 			}
 
 			rcu_bh_qs(cpu);
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1092,7 +1092,7 @@ static int cascade(struct tvec_base *bas
 static void call_timer_fn(struct timer_list *timer, void (*fn)(unsigned long),
 			  unsigned long data)
 {
-	int preempt_count = preempt_count();
+	int count = preempt_count();
 
 #ifdef CONFIG_LOCKDEP
 	/*
@@ -1119,16 +1119,16 @@ static void call_timer_fn(struct timer_l
 
 	lock_map_release(&lockdep_map);
 
-	if (preempt_count != preempt_count()) {
+	if (count != preempt_count()) {
 		WARN_ONCE(1, "timer: %pF preempt leak: %08x -> %08x\n",
-			  fn, preempt_count, preempt_count());
+			  fn, count, preempt_count());
 		/*
 		 * Restore the preempt count. That gives us a decent
 		 * chance to survive and extract information. If the
 		 * callback kept a lock held, bad luck, but not worse
 		 * than the BUG() we had.
 		 */
-		preempt_count() = preempt_count;
+		*preempt_count_ptr() = count;
 	}
 }
 
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


