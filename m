Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab3HNNlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:41:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54862 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819Ab3HNNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:34:59 -0400
Message-Id: <20130814133142.881926488@chello.nl>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 15:15:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 5/5] sched, x86: Provide a per-cpu preempt_count implementation
References: <20130814131539.790947874@chello.nl>
Content-Disposition: inline; filename=peterz-x86-per-cpu-preempt_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert x86 to use a per-cpu preemption count. The reason for doing so
is that accessing per-cpu variables is a lot cheaper than accessing
thread_info variables.

With this preempt_enable() reduces to:

  decl fs:__preempt_count
  jnz 1f
  call preempt_schedule
1:

We still need to save/restore the actual preemption count due to
PREEMPT_ACTIVE so we place the per-cpu __preempt_count variable in the
same cache-line as the other hot __switch_to() variables such as
current_task.

Also rename thread_info::preempt_count to ensure nobody is
'accidentally' still poking at it.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-dechwc0p86ik69ajunev8brp@git.kernel.org
---
 arch/x86/include/asm/Kbuild        |    1 
 arch/x86/include/asm/preempt.h     |   38 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/thread_info.h |    5 +---
 arch/x86/kernel/asm-offsets.c      |    1 
 arch/x86/kernel/cpu/common.c       |    5 ++++
 arch/x86/kernel/entry_32.S         |    7 +-----
 arch/x86/kernel/entry_64.S         |    4 ---
 arch/x86/kernel/process_32.c       |   10 +++++++++
 arch/x86/kernel/process_64.c       |   10 +++++++++
 9 files changed, 68 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -5,4 +5,3 @@ genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
 
 generic-y += clkdev.h
-generic-y += preempt.h
--- /dev/null
+++ b/arch/x86/include/asm/preempt.h
@@ -0,0 +1,38 @@
+#ifndef __ASM_PREEMPT_H
+#define __ASM_PREEMPT_H
+
+#include <asm/percpu.h>
+#include <linux/thread_info.h>
+
+DECLARE_PER_CPU(int, __preempt_count);
+
+/*
+ * We mask the PREEMPT_NEED_RESCHED bit so as not to confuse all current users
+ * that think a non-zero value indicates we cannot preempt.
+ */
+static __always_inline int preempt_count(void)
+{
+	return __raw_get_cpu_var(__preempt_count) & ~PREEMPT_NEED_RESCHED;
+}
+
+static __always_inline int *preempt_count_ptr(void)
+{
+	return &__raw_get_cpu_var(__preempt_count);
+}
+
+/*
+ * must be macros to avoid header recursion hell
+ */
+#define task_preempt_count(p) \
+	(task_thread_info(p)->saved_preempt_count & ~PREEMPT_NEED_RESCHED)
+
+#define init_task_preempt_count(p) do { \
+	task_thread_info(p)->saved_preempt_count = 1 | PREEMPT_NEED_RESCHED; \
+} while (0)
+
+#define init_idle_preempt_count(p, cpu) do { \
+	task_thread_info(p)->saved_preempt_count = 0; \
+	per_cpu(__preempt_count, (cpu)) = 0; \
+} while (0)
+
+#endif /* __ASM_PREEMPT_H */
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
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,7 +32,6 @@ void common(void) {
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
-	OFFSET(TI_preempt_count, thread_info, preempt_count);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1095,6 +1095,9 @@ DEFINE_PER_CPU(char *, irq_stack_ptr) =
 
 DEFINE_PER_CPU(unsigned int, irq_count) = -1;
 
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
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1118,10 +1118,8 @@ ENTRY(native_iret)
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
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -291,6 +291,16 @@ __switch_to(struct task_struct *prev_p,
 	if (get_kernel_rpl() && unlikely(prev->iopl != next->iopl))
 		set_iopl_mask(next->iopl);
 
+#ifdef CONFIG_PREEMPT_COUNT
+	/*
+	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count of all tasks was equal here and this would not be
+	 * needed.
+	 */
+	task_thread_info(prev_p)->saved_preempt_count = __raw_get_cpu_var(__preempt_count);
+	__raw_get_cpu_var(__preempt_count) = task_thread_info(next_p)->saved_preempt_count;
+#endif
+
 	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -363,6 +363,16 @@ __switch_to(struct task_struct *prev_p,
 	this_cpu_write(old_rsp, next->usersp);
 	this_cpu_write(current_task, next_p);
 
+#ifdef CONFIG_PREEMPT_COUNT
+	/*
+	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
+	 * preempt_count of all tasks was equal here and this would not be
+	 * needed.
+	 */
+	task_thread_info(prev_p)->saved_preempt_count = __raw_get_cpu_var(__preempt_count);
+	__raw_get_cpu_var(__preempt_count) = task_thread_info(next_p)->saved_preempt_count;
+#endif
+
 	this_cpu_write(kernel_stack,
 		  (unsigned long)task_stack_page(next_p) +
 		  THREAD_SIZE - KERNEL_STACK_OFFSET);


