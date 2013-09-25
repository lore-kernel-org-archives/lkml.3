Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3IYQkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:40:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40236 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3IYQkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:40:09 -0400
Date: Wed, 25 Sep 2013 09:39:32 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-gzn5rfsf8trgjoqx8hyayy3q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, x86:
  Provide a per-cpu preempt_count implementation
Git-Commit-ID: c2daa3bed53a81171cf8c1a36db798e82b91afe8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:39:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2daa3bed53a81171cf8c1a36db798e82b91afe8
Gitweb:     http://git.kernel.org/tip/c2daa3bed53a81171cf8c1a36db798e82b91afe8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 Aug 2013 14:51:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 14:07:57 +0200

sched, x86: Provide a per-cpu preempt_count implementation

Convert x86 to use a per-cpu preemption count. The reason for doing so
is that accessing per-cpu variables is a lot cheaper than accessing
thread_info variables.

We still need to save/restore the actual preemption count due to
PREEMPT_ACTIVE so we place the per-cpu __preempt_count variable in the
same cache-line as the other hot __switch_to() variables such as
current_task.

NOTE: this save/restore is required even for !PREEMPT kernels as
cond_resched() also relies on preempt_count's PREEMPT_ACTIVE to ignore
task_struct::state.

Also rename thread_info::preempt_count to ensure nobody is
'accidentally' still poking at it.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-gzn5rfsf8trgjoqx8hyayy3q@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/Kbuild                        |  1 -
 .../asm-generic => arch/x86/include/asm}/preempt.h | 39 ++++++++++------------
 arch/x86/include/asm/thread_info.h                 |  5 ++-
 arch/x86/kernel/asm-offsets.c                      |  1 -
 arch/x86/kernel/cpu/common.c                       |  5 +++
 arch/x86/kernel/entry_32.S                         |  7 ++--
 arch/x86/kernel/entry_64.S                         |  4 +--
 arch/x86/kernel/irq_32.c                           |  4 ---
 arch/x86/kernel/process_32.c                       |  8 +++++
 arch/x86/kernel/process_64.c                       |  8 +++++
 10 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index eca2028..7f66985 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,4 +5,3 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
-generic-y += preempt.h
diff --git a/include/asm-generic/preempt.h b/arch/x86/include/asm/preempt.h
similarity index 65%
copy from include/asm-generic/preempt.h
copy to arch/x86/include/asm/preempt.h
index 82d958f..1309942 100644
--- a/include/asm-generic/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -1,44 +1,39 @@
 #ifndef __ASM_PREEMPT_H
 #define __ASM_PREEMPT_H
 
+#include <asm/rmwcc.h>
+#include <asm/percpu.h>
 #include <linux/thread_info.h>
 
+DECLARE_PER_CPU(int, __preempt_count);
+
 /*
  * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
  * that think a non-zero value indicates we cannot preempt.
  */
 static __always_inline int preempt_count(void)
 {
-	return current_thread_info()->preempt_count & ~PREEMPT_NEED_RESCHED;
-}
-
-static __always_inline int *preempt_count_ptr(void)
-{
-	return &current_thread_info()->preempt_count;
+	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
 }
 
-/*
- * We now loose PREEMPT_NEED_RESCHED and cause an extra reschedule; however the
- * alternative is loosing a reschedule. Better schedule too often -- also this
- * should be a very rare operation.
- */
 static __always_inline void preempt_count_set(int pc)
 {
-	*preempt_count_ptr() = pc;
+	__this_cpu_write_4(__preempt_count, pc);
 }
 
 /*
  * must be macros to avoid header recursion hell
  */
 #define task_preempt_count(p) \
-	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
+	(task_thread_info(p)->saved_preempt_count & ~PREEMPT_NEED_RESCHED)
 
 #define init_task_preempt_count(p) do { \
-	task_thread_info(p)->preempt_count = PREEMPT_DISABLED; \
+	task_thread_info(p)->saved_preempt_count = PREEMPT_DISABLED; \
 } while (0)
 
 #define init_idle_preempt_count(p, cpu) do { \
-	task_thread_info(p)->preempt_count = PREEMPT_ENABLED; \
+	task_thread_info(p)->saved_preempt_count = PREEMPT_ENABLED; \
+	per_cpu(__preempt_count, (cpu)) = PREEMPT_ENABLED; \
 } while (0)
 
 /*
@@ -52,17 +47,17 @@ static __always_inline void preempt_count_set(int pc)
 
 static __always_inline void set_preempt_need_resched(void)
 {
-	*preempt_count_ptr() &= ~PREEMPT_NEED_RESCHED;
+	__this_cpu_and_4(__preempt_count, ~PREEMPT_NEED_RESCHED);
 }
 
 static __always_inline void clear_preempt_need_resched(void)
 {
-	*preempt_count_ptr() |= PREEMPT_NEED_RESCHED;
+	__this_cpu_or_4(__preempt_count, PREEMPT_NEED_RESCHED);
 }
 
 static __always_inline bool test_preempt_need_resched(void)
 {
-	return !(*preempt_count_ptr() & PREEMPT_NEED_RESCHED);
+	return !(__this_cpu_read_4(__preempt_count) & PREEMPT_NEED_RESCHED);
 }
 
 /*
@@ -71,17 +66,17 @@ static __always_inline bool test_preempt_need_resched(void)
 
 static __always_inline void __preempt_count_add(int val)
 {
-	*preempt_count_ptr() += val;
+	__this_cpu_add_4(__preempt_count, val);
 }
 
 static __always_inline void __preempt_count_sub(int val)
 {
-	*preempt_count_ptr() -= val;
+	__this_cpu_add_4(__preempt_count, -val);
 }
 
 static __always_inline bool __preempt_count_dec_and_test(void)
 {
-	return !--*preempt_count_ptr();
+	GEN_UNARY_RMWcc("decl", __preempt_count, __percpu_arg(0), "e");
 }
 
 /*
@@ -97,7 +92,7 @@ static __always_inline bool need_resched(void)
  */
 static __always_inline bool should_resched(void)
 {
-	return unlikely(!*preempt_count_ptr());
+	return unlikely(!__this_cpu_read_4(__preempt_count));
 }
 
 #endif /* __ASM_PREEMPT_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2781119..c46a46b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -28,8 +28,7 @@ struct thread_info {
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable,
-						   <0 => BUG */
+	int			saved_preempt_count;
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
@@ -49,7 +48,7 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.saved_preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 2861082..9f6b934 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,7 +32,6 @@ void common(void) {
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
-	OFFSET(TI_preempt_count, thread_info, preempt_count);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2793d1f..5223fe6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1095,6 +1095,9 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 
 DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
 
+DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
+EXPORT_PER_CPU_SYMBOL(__preempt_count);
+
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
 /*
@@ -1169,6 +1172,8 @@ void debug_stack_reset(void)
 
 DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
+DEFINE_PER_CPU(int, __preempt_count) = INIT_PREEMPT_COUNT;
+EXPORT_PER_CPU_SYMBOL(__preempt_count);
 DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f0dcb0c..fd1bc1b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -362,12 +362,9 @@ END(ret_from_exception)
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
-	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
-	jnz restore_all
 need_resched:
-	movl TI_flags(%ebp), %ecx	# need_resched set ?
-	testb $_TIF_NEED_RESCHED, %cl
-	jz restore_all
+	cmpl $0,PER_CPU_VAR(__preempt_count)
+	jnz restore_all
 	testl $X86_EFLAGS_IF,PT_EFLAGS(%esp)	# interrupts off (exception path) ?
 	jz restore_all
 	call preempt_schedule_irq
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1b69951..6a43e7d 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1118,10 +1118,8 @@ retint_signal:
 	/* Returning to kernel space. Check if we need preemption */
 	/* rcx:	 threadinfo. interrupts off. */
 ENTRY(retint_kernel)
-	cmpl $0,TI_preempt_count(%rcx)
+	cmpl $0,PER_CPU_VAR(__preempt_count)
 	jnz  retint_restore_args
-	bt  $TIF_NEED_RESCHED,TI_flags(%rcx)
-	jnc  retint_restore_args
 	bt   $9,EFLAGS-ARGOFFSET(%rsp)	/* interrupts off? */
 	jnc  retint_restore_args
 	call preempt_schedule_irq
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 4186755..3fe0663 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -100,9 +100,6 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	irqctx->tinfo.task = curctx->tinfo.task;
 	irqctx->tinfo.previous_esp = current_stack_pointer;
 
-	/* Copy the preempt_count so that the [soft]irq checks work. */
-	irqctx->tinfo.preempt_count = curctx->tinfo.preempt_count;
-
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
 
@@ -131,7 +128,6 @@ void irq_ctx_init(int cpu)
 					       THREAD_SIZE_ORDER));
 	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= HARDIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 884f98f..c2ec1aa 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -292,6 +292,14 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		set_iopl_mask(next->iopl);
 
 	/*
+	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count of all tasks was equal here and this would not be
+	 * needed.
+	 */
+	task_thread_info(prev_p)->saved_preempt_count = this_cpu_read(__preempt_count);
+	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
+
+	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index bb1dc51..45ab4d6 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -363,6 +363,14 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	this_cpu_write(old_rsp, next->usersp);
 	this_cpu_write(current_task, next_p);
 
+	/*
+	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count of all tasks was equal here and this would not be
+	 * needed.
+	 */
+	task_thread_info(prev_p)->saved_preempt_count = this_cpu_read(__preempt_count);
+	this_cpu_write(__preempt_count, task_thread_info(next_p)->saved_preempt_count);
+
 	this_cpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);
