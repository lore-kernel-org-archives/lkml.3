Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3IYQjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:39:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab3IYQjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:39:45 -0400
Date: Wed, 25 Sep 2013 09:39:10 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ewbpdbupy9xpsjhg960zwbv8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Extract the basic add/
 sub preempt_count modifiers
Git-Commit-ID: bdb43806589096ac4272fe1307e789846ac08d7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:39:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdb43806589096ac4272fe1307e789846ac08d7c
Gitweb:     http://git.kernel.org/tip/bdb43806589096ac4272fe1307e789846ac08d7c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 10 Sep 2013 12:15:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:07:54 +0200

sched: Extract the basic add/sub preempt_count modifiers

Rewrite the preempt_count macros in order to extract the 3 basic
preempt_count value modifiers:

  __preempt_count_add()
  __preempt_count_sub()

and the new:

  __preempt_count_dec_and_test()

And since we're at it anyway, replace the unconventional
$op_preempt_count names with the more conventional preempt_count_$op.

Since these basic operators are equivalent to the previous _notrace()
variants, do away with the _notrace() versions.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-ewbpdbupy9xpsjhg960zwbv8@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/mm/init.c           |   5 +-
 arch/x86/kernel/traps.c       |   4 +-
 include/asm-generic/preempt.h |  35 ++++++++++++++
 include/linux/hardirq.h       |   8 ++--
 include/linux/preempt.h       | 106 +++++++++++++++++++-----------------------
 include/linux/sched.h         |   5 --
 include/linux/uaccess.h       |   8 +---
 kernel/context_tracking.c     |   2 +-
 kernel/sched/core.c           |  29 +++++-------
 kernel/softirq.c              |  14 +++---
 10 files changed, 113 insertions(+), 103 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index e205ef5..1215617 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -124,7 +124,7 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 
 	BUG_ON(Page_dcache_dirty(page));
 
-	inc_preempt_count();
+	pagefault_disable();
 	idx = (addr >> PAGE_SHIFT) & (FIX_N_COLOURS - 1);
 #ifdef CONFIG_MIPS_MT_SMTC
 	idx += FIX_N_COLOURS * smp_processor_id() +
@@ -193,8 +193,7 @@ void kunmap_coherent(void)
 	write_c0_entryhi(old_ctx);
 	EXIT_CRITICAL(flags);
 #endif
-	dec_preempt_count();
-	preempt_check_resched();
+	pagefault_enable();
 }
 
 void copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8c8093b..729aa77 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -88,7 +88,7 @@ static inline void conditional_sti(struct pt_regs *regs)
 
 static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
-	inc_preempt_count();
+	preempt_count_inc();
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -103,7 +103,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
-	dec_preempt_count();
+	preempt_count_dec();
 }
 
 static int __kprobes
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index 8100b1e..82d958f 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -65,4 +65,39 @@ static __always_inline bool test_preempt_need_resched(void)
 	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
 }
 
+/*
+ * The various preempt_count add/sub methods
+ */
+
+static __always_inline void __preempt_count_add(int val)
+{
+	*preempt_count_ptr() += val;
+}
+
+static __always_inline void __preempt_count_sub(int val)
+{
+	*preempt_count_ptr() -= val;
+}
+
+static __always_inline bool __preempt_count_dec_and_test(void)
+{
+	return !--*preempt_count_ptr();
+}
+
+/*
+ * Returns true when we need to resched -- even if we can not.
+ */
+static __always_inline bool need_resched(void)
+{
+	return unlikely(test_preempt_need_resched());
+}
+
+/*
+ * Returns true when we need to resched and can (barring IRQ state).
+ */
+static __always_inline bool should_resched(void)
+{
+	return unlikely(!*preempt_count_ptr());
+}
+
 #endif /* __ASM_PREEMPT_H */
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 1e04106..d9cf963 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -33,7 +33,7 @@ extern void rcu_nmi_exit(void);
 #define __irq_enter()					\
 	do {						\
 		account_irq_enter_time(current);	\
-		add_preempt_count(HARDIRQ_OFFSET);	\
+		preempt_count_add(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
 	} while (0)
 
@@ -49,7 +49,7 @@ extern void irq_enter(void);
 	do {						\
 		trace_hardirq_exit();			\
 		account_irq_exit_time(current);		\
-		sub_preempt_count(HARDIRQ_OFFSET);	\
+		preempt_count_sub(HARDIRQ_OFFSET);	\
 	} while (0)
 
 /*
@@ -62,7 +62,7 @@ extern void irq_exit(void);
 		lockdep_off();					\
 		ftrace_nmi_enter();				\
 		BUG_ON(in_nmi());				\
-		add_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
+		preempt_count_add(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		rcu_nmi_enter();				\
 		trace_hardirq_enter();				\
 	} while (0)
@@ -72,7 +72,7 @@ extern void irq_exit(void);
 		trace_hardirq_exit();				\
 		rcu_nmi_exit();					\
 		BUG_ON(!in_nmi());				\
-		sub_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
+		preempt_count_sub(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		ftrace_nmi_exit();				\
 		lockdep_on();					\
 	} while (0)
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index df8e245..2343d87 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -18,97 +18,86 @@
 #include <asm/preempt.h>
 
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
-  extern void add_preempt_count(int val);
-  extern void sub_preempt_count(int val);
+extern void preempt_count_add(int val);
+extern void preempt_count_sub(int val);
+#define preempt_count_dec_and_test() ({ preempt_count_sub(1); should_resched(); })
 #else
-# define add_preempt_count(val)	do { *preempt_count_ptr() += (val); } while (0)
-# define sub_preempt_count(val)	do { *preempt_count_ptr() -= (val); } while (0)
+#define preempt_count_add(val)	__preempt_count_add(val)
+#define preempt_count_sub(val)	__preempt_count_sub(val)
+#define preempt_count_dec_and_test() __preempt_count_dec_and_test()
 #endif
 
-#define inc_preempt_count() add_preempt_count(1)
-#define dec_preempt_count() sub_preempt_count(1)
-
-#ifdef CONFIG_PREEMPT
-
-asmlinkage void preempt_schedule(void);
-
-#define preempt_check_resched() \
-do { \
-	if (unlikely(!*preempt_count_ptr())) \
-		preempt_schedule(); \
-} while (0)
-
-#ifdef CONFIG_CONTEXT_TRACKING
-
-void preempt_schedule_context(void);
-
-#define preempt_check_resched_context() \
-do { \
-	if (unlikely(!*preempt_count_ptr())) \
-		preempt_schedule_context(); \
-} while (0)
-#else
-
-#define preempt_check_resched_context() preempt_check_resched()
-
-#endif /* CONFIG_CONTEXT_TRACKING */
-
-#else /* !CONFIG_PREEMPT */
-
-#define preempt_check_resched()		do { } while (0)
-#define preempt_check_resched_context()	do { } while (0)
-
-#endif /* CONFIG_PREEMPT */
+#define __preempt_count_inc() __preempt_count_add(1)
+#define __preempt_count_dec() __preempt_count_sub(1)
 
+#define preempt_count_inc() preempt_count_add(1)
+#define preempt_count_dec() preempt_count_sub(1)
 
 #ifdef CONFIG_PREEMPT_COUNT
 
 #define preempt_disable() \
 do { \
-	inc_preempt_count(); \
+	preempt_count_inc(); \
 	barrier(); \
 } while (0)
 
 #define sched_preempt_enable_no_resched() \
 do { \
 	barrier(); \
-	dec_preempt_count(); \
+	preempt_count_dec(); \
 } while (0)
 
-#define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
+#define preempt_enable_no_resched() sched_preempt_enable_no_resched()
 
+#ifdef CONFIG_PREEMPT
+asmlinkage void preempt_schedule(void);
 #define preempt_enable() \
 do { \
-	preempt_enable_no_resched(); \
-	preempt_check_resched(); \
+	barrier(); \
+	if (unlikely(preempt_count_dec_and_test())) \
+		preempt_schedule(); \
 } while (0)
 
-/* For debugging and tracer internals only! */
-#define add_preempt_count_notrace(val)			\
-	do { *preempt_count_ptr() += (val); } while (0)
-#define sub_preempt_count_notrace(val)			\
-	do { *preempt_count_ptr() -= (val); } while (0)
-#define inc_preempt_count_notrace() add_preempt_count_notrace(1)
-#define dec_preempt_count_notrace() sub_preempt_count_notrace(1)
+#define preempt_check_resched() \
+do { \
+	if (should_resched()) \
+		preempt_schedule(); \
+} while (0)
+
+#else
+#define preempt_enable() preempt_enable_no_resched()
+#define preempt_check_resched() do { } while (0)
+#endif
 
 #define preempt_disable_notrace() \
 do { \
-	inc_preempt_count_notrace(); \
+	__preempt_count_inc(); \
 	barrier(); \
 } while (0)
 
 #define preempt_enable_no_resched_notrace() \
 do { \
 	barrier(); \
-	dec_preempt_count_notrace(); \
+	__preempt_count_dec(); \
 } while (0)
 
-/* preempt_check_resched is OK to trace */
+#ifdef CONFIG_PREEMPT
+
+#ifdef CONFIG_CONTEXT_TRACKING
+asmlinkage void preempt_schedule_context(void);
+#else
+#define preempt_schedule_context() preempt_schedule()
+#endif
+
 #define preempt_enable_notrace() \
 do { \
-	preempt_enable_no_resched_notrace(); \
-	preempt_check_resched_context(); \
+	barrier(); \
+	if (unlikely(__preempt_count_dec_and_test())) \
+		preempt_schedule_context(); \
 } while (0)
+#else
+#define preempt_enable_notrace() preempt_enable_no_resched_notrace()
+#endif
 
 #else /* !CONFIG_PREEMPT_COUNT */
 
@@ -118,10 +107,11 @@ do { \
  * that can cause faults and scheduling migrate into our preempt-protected
  * region.
  */
-#define preempt_disable()		barrier()
+#define preempt_disable()			barrier()
 #define sched_preempt_enable_no_resched()	barrier()
-#define preempt_enable_no_resched()	barrier()
-#define preempt_enable()		barrier()
+#define preempt_enable_no_resched()		barrier()
+#define preempt_enable()			barrier()
+#define preempt_check_resched()			do { } while (0)
 
 #define preempt_disable_notrace()		barrier()
 #define preempt_enable_no_resched_notrace()	barrier()
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9fa151f..06ac17c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2409,11 +2409,6 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 
-static inline int need_resched(void)
-{
-	return unlikely(test_preempt_need_resched());
-}
-
 /*
  * cond_resched() and cond_resched_lock(): latency reduction via
  * explicit rescheduling in places that are safe. The return
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 5ca0951..9d8cf05 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -15,7 +15,7 @@
  */
 static inline void pagefault_disable(void)
 {
-	inc_preempt_count();
+	preempt_count_inc();
 	/*
 	 * make sure to have issued the store before a pagefault
 	 * can hit.
@@ -30,11 +30,7 @@ static inline void pagefault_enable(void)
 	 * the pagefault handler again.
 	 */
 	barrier();
-	dec_preempt_count();
-	/*
-	 * make sure we do..
-	 */
-	barrier();
+	preempt_count_dec();
 	preempt_check_resched();
 }
 
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 247091b..013161f 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -111,7 +111,7 @@ void context_tracking_user_enter(void)
  * instead of preempt_schedule() to exit user context if needed before
  * calling the scheduler.
  */
-void __sched notrace preempt_schedule_context(void)
+asmlinkage void __sched notrace preempt_schedule_context(void)
 {
 	enum ctx_state prev_ctx;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0ba4e41..9c84a9a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2219,7 +2219,7 @@ notrace unsigned long get_parent_ip(unsigned long addr)
 #if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
 				defined(CONFIG_PREEMPT_TRACER))
 
-void __kprobes add_preempt_count(int val)
+void __kprobes preempt_count_add(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2228,7 +2228,7 @@ void __kprobes add_preempt_count(int val)
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	add_preempt_count_notrace(val);
+	__preempt_count_add(val);
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -2239,9 +2239,9 @@ void __kprobes add_preempt_count(int val)
 	if (preempt_count() == val)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
-EXPORT_SYMBOL(add_preempt_count);
+EXPORT_SYMBOL(preempt_count_add);
 
-void __kprobes sub_preempt_count(int val)
+void __kprobes preempt_count_sub(int val)
 {
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
@@ -2259,9 +2259,9 @@ void __kprobes sub_preempt_count(int val)
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	sub_preempt_count_notrace(val);
+	__preempt_count_sub(val);
 }
-EXPORT_SYMBOL(sub_preempt_count);
+EXPORT_SYMBOL(preempt_count_sub);
 
 #endif
 
@@ -2525,9 +2525,9 @@ asmlinkage void __sched notrace preempt_schedule(void)
 		return;
 
 	do {
-		add_preempt_count_notrace(PREEMPT_ACTIVE);
+		__preempt_count_add(PREEMPT_ACTIVE);
 		__schedule();
-		sub_preempt_count_notrace(PREEMPT_ACTIVE);
+		__preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -2554,11 +2554,11 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	prev_state = exception_enter();
 
 	do {
-		add_preempt_count(PREEMPT_ACTIVE);
+		__preempt_count_add(PREEMPT_ACTIVE);
 		local_irq_enable();
 		__schedule();
 		local_irq_disable();
-		sub_preempt_count(PREEMPT_ACTIVE);
+		__preempt_count_sub(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
@@ -3798,16 +3798,11 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
 
-static inline int should_resched(void)
-{
-	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
-}
-
 static void __cond_resched(void)
 {
-	add_preempt_count(PREEMPT_ACTIVE);
+	__preempt_count_add(PREEMPT_ACTIVE);
 	__schedule();
-	sub_preempt_count(PREEMPT_ACTIVE);
+	__preempt_count_sub(PREEMPT_ACTIVE);
 }
 
 int __sched _cond_resched(void)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index a90de70..3e88612 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -100,13 +100,13 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 
 	raw_local_irq_save(flags);
 	/*
-	 * The preempt tracer hooks into add_preempt_count and will break
+	 * The preempt tracer hooks into preempt_count_add and will break
 	 * lockdep because it calls back into lockdep after SOFTIRQ_OFFSET
 	 * is set and before current->softirq_enabled is cleared.
 	 * We must manually increment preempt_count here and manually
 	 * call the trace_preempt_off later.
 	 */
-	add_preempt_count_notrace(cnt);
+	__preempt_count_add(cnt);
 	/*
 	 * Were softirqs turned off above:
 	 */
@@ -120,7 +120,7 @@ static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 #else /* !CONFIG_TRACE_IRQFLAGS */
 static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
 {
-	add_preempt_count(cnt);
+	preempt_count_add(cnt);
 	barrier();
 }
 #endif /* CONFIG_TRACE_IRQFLAGS */
@@ -139,7 +139,7 @@ static void __local_bh_enable(unsigned int cnt)
 
 	if (softirq_count() == cnt)
 		trace_softirqs_on(_RET_IP_);
-	sub_preempt_count(cnt);
+	preempt_count_sub(cnt);
 }
 
 /*
@@ -169,12 +169,12 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
-	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
+	preempt_count_sub(SOFTIRQ_DISABLE_OFFSET - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending()))
 		do_softirq();
 
-	dec_preempt_count();
+	preempt_count_dec();
 #ifdef CONFIG_TRACE_IRQFLAGS
 	local_irq_enable();
 #endif
@@ -360,7 +360,7 @@ void irq_exit(void)
 
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
-	sub_preempt_count(HARDIRQ_OFFSET);
+	preempt_count_sub(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
