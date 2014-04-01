Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaDAIr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:47:56 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46301 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDAIrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:47:51 -0400
Date: Tue, 1 Apr 2014 10:47:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/threadinfo changes for v3.15
Message-ID: <20140401084747.GA24379@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-threadinfo-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-threadinfo-for-linus

   # HEAD: 6cce16f99d7be23cec7cabdf32a8166eec6e5393 x86, threadinfo: Redo "x86: Use inline assembler to get sp"

The main change here is the consolidation/unification of 32 and 64 bit 
thread_info handling methods, from Steve Rostedt.

 Thanks,

	Ingo

------------------>
Mathias Krause (1):
      x86, threadinfo: Redo "x86: Use inline assembler to get sp"

Steven Rostedt (4):
      x86: Nuke the supervisor_stack field in i386 thread_info
      x86: Prepare removal of previous_esp from i386 thread_info structure
      x86: Keep thread_info on thread stack in x86_32
      x86: Clean up dumpstack_64.c code

Steven Rostedt (Red Hat) (1):
      x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386


 arch/x86/include/asm/processor.h   |   9 +++
 arch/x86/include/asm/thread_info.h |  53 ++---------------
 arch/x86/kernel/cpu/common.c       |   8 +--
 arch/x86/kernel/dumpstack_32.c     |  44 ++++++++++++--
 arch/x86/kernel/dumpstack_64.c     | 117 ++++++++++++++++++++++++++-----------
 arch/x86/kernel/irq_32.c           |  83 +++++++++++++-------------
 arch/x86/kernel/process_32.c       |   4 ++
 arch/x86/kernel/ptrace.c           |   8 +--
 arch/x86/kernel/smpboot.c          |   2 +-
 9 files changed, 191 insertions(+), 137 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fdedd38..a4ea023 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -449,6 +449,15 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
+/*
+ * per-CPU IRQ handling stacks
+ */
+struct irq_stack {
+	u32                     stack[THREAD_SIZE/sizeof(u32)];
+} __aligned(THREAD_SIZE);
+
+DECLARE_PER_CPU(struct irq_stack *, hardirq_stack);
+DECLARE_PER_CPU(struct irq_stack *, softirq_stack);
 #endif	/* X86_64 */
 
 extern unsigned int xstate_size;
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e1940c0..47e5de2 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -9,6 +9,7 @@
 
 #include <linux/compiler.h>
 #include <asm/page.h>
+#include <asm/percpu.h>
 #include <asm/types.h>
 
 /*
@@ -32,12 +33,6 @@ struct thread_info {
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
-#ifdef CONFIG_X86_32
-	unsigned long           previous_esp;   /* ESP of the previous stack in
-						   case of nested (IRQ) stacks
-						*/
-	__u8			supervisor_stack[0];
-#endif
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 };
@@ -153,9 +148,9 @@ struct thread_info {
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
 
-#ifdef CONFIG_X86_32
+#define STACK_WARN		(THREAD_SIZE/8)
+#define KERNEL_STACK_OFFSET	(5*(BITS_PER_LONG/8))
 
-#define STACK_WARN	(THREAD_SIZE/8)
 /*
  * macros/functions for gaining access to the thread information structure
  *
@@ -163,42 +158,6 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-#define current_stack_pointer ({		\
-	unsigned long sp;			\
-	asm("mov %%esp,%0" : "=g" (sp));	\
-	sp;					\
-})
-
-/* how to get the thread information struct from C */
-static inline struct thread_info *current_thread_info(void)
-{
-	return (struct thread_info *)
-		(current_stack_pointer & ~(THREAD_SIZE - 1));
-}
-
-#else /* !__ASSEMBLY__ */
-
-/* how to get the thread information struct from ASM */
-#define GET_THREAD_INFO(reg)	 \
-	movl $-THREAD_SIZE, reg; \
-	andl %esp, reg
-
-/* use this one if reg already contains %esp */
-#define GET_THREAD_INFO_WITH_ESP(reg) \
-	andl $-THREAD_SIZE, reg
-
-#endif
-
-#else /* X86_32 */
-
-#include <asm/percpu.h>
-#define KERNEL_STACK_OFFSET (5*8)
-
-/*
- * macros/functions for gaining access to the thread information structure
- * preempt_count needs to be 1 initially, until the scheduler is functional.
- */
-#ifndef __ASSEMBLY__
 DECLARE_PER_CPU(unsigned long, kernel_stack);
 
 static inline struct thread_info *current_thread_info(void)
@@ -213,8 +172,8 @@ static inline struct thread_info *current_thread_info(void)
 
 /* how to get the thread information struct from ASM */
 #define GET_THREAD_INFO(reg) \
-	movq PER_CPU_VAR(kernel_stack),reg ; \
-	subq $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg
+	_ASM_MOV PER_CPU_VAR(kernel_stack),reg ; \
+	_ASM_SUB $(THREAD_SIZE-KERNEL_STACK_OFFSET),reg ;
 
 /*
  * Same if PER_CPU_VAR(kernel_stack) is, perhaps with some offset, already in
@@ -224,8 +183,6 @@ static inline struct thread_info *current_thread_info(void)
 
 #endif
 
-#endif /* !X86_32 */
-
 /*
  * Thread-synchronous status.
  *
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8e28bf2..29c1944 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1078,6 +1078,10 @@ static __init int setup_disablecpuid(char *arg)
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
+DEFINE_PER_CPU(unsigned long, kernel_stack) =
+	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
+EXPORT_PER_CPU_SYMBOL(kernel_stack);
+
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
 struct desc_ptr debug_idt_descr = { NR_VECTORS * 16 - 1,
@@ -1094,10 +1098,6 @@ DEFINE_PER_CPU(struct task_struct *, current_task) ____cacheline_aligned =
 	&init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
-DEFINE_PER_CPU(unsigned long, kernel_stack) =
-	(unsigned long)&init_thread_union - KERNEL_STACK_OFFSET + THREAD_SIZE;
-EXPORT_PER_CPU_SYMBOL(kernel_stack);
-
 DEFINE_PER_CPU(char *, irq_stack_ptr) =
 	init_per_cpu_var(irq_stack_union.irq_stack) + IRQ_STACK_SIZE - 64;
 
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f2a1770..dca820b 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -16,12 +16,35 @@
 
 #include <asm/stacktrace.h>
 
+static void *is_irq_stack(void *p, void *irq)
+{
+	if (p < irq || p >= (irq + THREAD_SIZE))
+		return NULL;
+	return irq + THREAD_SIZE;
+}
+
+
+static void *is_hardirq_stack(unsigned long *stack, int cpu)
+{
+	void *irq = per_cpu(hardirq_stack, cpu);
+
+	return is_irq_stack(stack, irq);
+}
+
+static void *is_softirq_stack(unsigned long *stack, int cpu)
+{
+	void *irq = per_cpu(softirq_stack, cpu);
+
+	return is_irq_stack(stack, irq);
+}
 
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
+	const unsigned cpu = get_cpu();
 	int graph = 0;
+	u32 *prev_esp;
 
 	if (!task)
 		task = current;
@@ -39,18 +62,31 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 	for (;;) {
 		struct thread_info *context;
+		void *end_stack;
+
+		end_stack = is_hardirq_stack(stack, cpu);
+		if (!end_stack)
+			end_stack = is_softirq_stack(stack, cpu);
 
-		context = (struct thread_info *)
-			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
+		context = task_thread_info(task);
+		bp = ops->walk_stack(context, stack, bp, ops, data,
+				     end_stack, &graph);
 
-		stack = (unsigned long *)context->previous_esp;
+		/* Stop if not on irq stack */
+		if (!end_stack)
+			break;
+
+		/* The previous esp is saved on the bottom of the stack */
+		prev_esp = (u32 *)(end_stack - THREAD_SIZE);
+		stack = (unsigned long *)*prev_esp;
 		if (!stack)
 			break;
+
 		if (ops->stack(data, "IRQ") < 0)
 			break;
 		touch_nmi_watchdog();
 	}
+	put_cpu();
 }
 EXPORT_SYMBOL(dump_trace);
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index addb207..346b1df 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -104,6 +104,45 @@ in_irq_stack(unsigned long *stack, unsigned long *irq_stack,
 	return (stack >= irq_stack && stack < irq_stack_end);
 }
 
+static const unsigned long irq_stack_size =
+	(IRQ_STACK_SIZE - 64) / sizeof(unsigned long);
+
+enum stack_type {
+	STACK_IS_UNKNOWN,
+	STACK_IS_NORMAL,
+	STACK_IS_EXCEPTION,
+	STACK_IS_IRQ,
+};
+
+static enum stack_type
+analyze_stack(int cpu, struct task_struct *task,
+	      unsigned long *stack, unsigned long **stack_end, char **id)
+{
+	unsigned long *irq_stack;
+	unsigned long addr;
+	unsigned used = 0;
+
+	addr = ((unsigned long)stack & (~(THREAD_SIZE - 1)));
+	if ((unsigned long)task_stack_page(task) == addr)
+		return STACK_IS_NORMAL;
+
+	*stack_end = in_exception_stack(cpu, (unsigned long)stack,
+					 &used, id);
+	if (*stack_end)
+		return STACK_IS_EXCEPTION;
+
+	*stack_end = (unsigned long *)per_cpu(irq_stack_ptr, cpu);
+	if (!*stack_end)
+		return STACK_IS_UNKNOWN;
+
+	irq_stack = *stack_end - irq_stack_size;
+
+	if (in_irq_stack(stack, irq_stack, *stack_end))
+		return STACK_IS_IRQ;
+
+	return STACK_IS_UNKNOWN;
+}
+
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -116,12 +155,11 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irq_stack_end =
-		(unsigned long *)per_cpu(irq_stack_ptr, cpu);
-	unsigned used = 0;
 	struct thread_info *tinfo;
-	int graph = 0;
+	unsigned long *irq_stack;
 	unsigned long dummy;
+	int graph = 0;
+	int done = 0;
 
 	if (!task)
 		task = current;
@@ -143,49 +181,60 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 * exceptions
 	 */
 	tinfo = task_thread_info(task);
-	for (;;) {
+	while (!done) {
+		unsigned long *stack_end;
+		enum stack_type stype;
 		char *id;
-		unsigned long *estack_end;
-		estack_end = in_exception_stack(cpu, (unsigned long)stack,
-						&used, &id);
 
-		if (estack_end) {
+		stype = analyze_stack(cpu, task, stack, &stack_end, &id);
+
+		/* Default finish unless specified to continue */
+		done = 1;
+
+		switch (stype) {
+
+		/* Break out early if we are on the thread stack */
+		case STACK_IS_NORMAL:
+			break;
+
+		case STACK_IS_EXCEPTION:
+
 			if (ops->stack(data, id) < 0)
 				break;
 
 			bp = ops->walk_stack(tinfo, stack, bp, ops,
-					     data, estack_end, &graph);
+					     data, stack_end, &graph);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
 			 * second-to-last pointer (index -2 to end) in the
 			 * exception stack:
 			 */
-			stack = (unsigned long *) estack_end[-2];
-			continue;
-		}
-		if (irq_stack_end) {
-			unsigned long *irq_stack;
-			irq_stack = irq_stack_end -
-				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
-
-			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
-				if (ops->stack(data, "IRQ") < 0)
-					break;
-				bp = ops->walk_stack(tinfo, stack, bp,
-					ops, data, irq_stack_end, &graph);
-				/*
-				 * We link to the next stack (which would be
-				 * the process stack normally) the last
-				 * pointer (index -1 to end) in the IRQ stack:
-				 */
-				stack = (unsigned long *) (irq_stack_end[-1]);
-				irq_stack_end = NULL;
-				ops->stack(data, "EOI");
-				continue;
-			}
+			stack = (unsigned long *) stack_end[-2];
+			done = 0;
+			break;
+
+		case STACK_IS_IRQ:
+
+			if (ops->stack(data, "IRQ") < 0)
+				break;
+			bp = ops->walk_stack(tinfo, stack, bp,
+				     ops, data, stack_end, &graph);
+			/*
+			 * We link to the next stack (which would be
+			 * the process stack normally) the last
+			 * pointer (index -1 to end) in the IRQ stack:
+			 */
+			stack = (unsigned long *) (stack_end[-1]);
+			irq_stack = stack_end - irq_stack_size;
+			ops->stack(data, "EOI");
+			done = 0;
+			break;
+
+		case STACK_IS_UNKNOWN:
+			ops->stack(data, "UNK");
+			break;
 		}
-		break;
 	}
 
 	/*
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index d7fcbed..63ce838 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -55,16 +55,8 @@ static inline int check_stack_overflow(void) { return 0; }
 static inline void print_stack_overflow(void) { }
 #endif
 
-/*
- * per-CPU IRQ handling contexts (thread information and stack)
- */
-union irq_ctx {
-	struct thread_info      tinfo;
-	u32                     stack[THREAD_SIZE/sizeof(u32)];
-} __attribute__((aligned(THREAD_SIZE)));
-
-static DEFINE_PER_CPU(union irq_ctx *, hardirq_ctx);
-static DEFINE_PER_CPU(union irq_ctx *, softirq_ctx);
+DEFINE_PER_CPU(struct irq_stack *, hardirq_stack);
+DEFINE_PER_CPU(struct irq_stack *, softirq_stack);
 
 static void call_on_stack(void *func, void *stack)
 {
@@ -77,14 +69,26 @@ static void call_on_stack(void *func, void *stack)
 		     : "memory", "cc", "edx", "ecx", "eax");
 }
 
+/* how to get the current stack pointer from C */
+#define current_stack_pointer ({		\
+	unsigned long sp;			\
+	asm("mov %%esp,%0" : "=g" (sp));	\
+	sp;					\
+})
+
+static inline void *current_stack(void)
+{
+	return (void *)(current_stack_pointer & ~(THREAD_SIZE - 1));
+}
+
 static inline int
 execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 {
-	union irq_ctx *curctx, *irqctx;
-	u32 *isp, arg1, arg2;
+	struct irq_stack *curstk, *irqstk;
+	u32 *isp, *prev_esp, arg1, arg2;
 
-	curctx = (union irq_ctx *) current_thread_info();
-	irqctx = __this_cpu_read(hardirq_ctx);
+	curstk = (struct irq_stack *) current_stack();
+	irqstk = __this_cpu_read(hardirq_stack);
 
 	/*
 	 * this is where we switch to the IRQ stack. However, if we are
@@ -92,13 +96,14 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	 * handler) we can't do that and just have to keep using the
 	 * current stack (which is the irq stack already after all)
 	 */
-	if (unlikely(curctx == irqctx))
+	if (unlikely(curstk == irqstk))
 		return 0;
 
-	/* build the stack frame on the IRQ stack */
-	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
-	irqctx->tinfo.task = curctx->tinfo.task;
-	irqctx->tinfo.previous_esp = current_stack_pointer;
+	isp = (u32 *) ((char *)irqstk + sizeof(*irqstk));
+
+	/* Save the next esp at the bottom of the stack */
+	prev_esp = (u32 *)irqstk;
+	*prev_esp = current_stack_pointer;
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -118,46 +123,40 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
  */
 void irq_ctx_init(int cpu)
 {
-	union irq_ctx *irqctx;
+	struct irq_stack *irqstk;
 
-	if (per_cpu(hardirq_ctx, cpu))
+	if (per_cpu(hardirq_stack, cpu))
 		return;
 
-	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
+	irqstk = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREADINFO_GFP,
 					       THREAD_SIZE_ORDER));
-	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
-	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
-
-	per_cpu(hardirq_ctx, cpu) = irqctx;
+	per_cpu(hardirq_stack, cpu) = irqstk;
 
-	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
+	irqstk = page_address(alloc_pages_node(cpu_to_node(cpu),
 					       THREADINFO_GFP,
 					       THREAD_SIZE_ORDER));
-	memset(&irqctx->tinfo, 0, sizeof(struct thread_info));
-	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
-
-	per_cpu(softirq_ctx, cpu) = irqctx;
+	per_cpu(softirq_stack, cpu) = irqstk;
 
 	printk(KERN_DEBUG "CPU %u irqstacks, hard=%p soft=%p\n",
-	       cpu, per_cpu(hardirq_ctx, cpu),  per_cpu(softirq_ctx, cpu));
+	       cpu, per_cpu(hardirq_stack, cpu),  per_cpu(softirq_stack, cpu));
 }
 
 void do_softirq_own_stack(void)
 {
-	struct thread_info *curctx;
-	union irq_ctx *irqctx;
-	u32 *isp;
+	struct thread_info *curstk;
+	struct irq_stack *irqstk;
+	u32 *isp, *prev_esp;
 
-	curctx = current_thread_info();
-	irqctx = __this_cpu_read(softirq_ctx);
-	irqctx->tinfo.task = curctx->task;
-	irqctx->tinfo.previous_esp = current_stack_pointer;
+	curstk = current_stack();
+	irqstk = __this_cpu_read(softirq_stack);
 
 	/* build the stack frame on the softirq stack */
-	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
+	isp = (u32 *) ((char *)irqstk + sizeof(*irqstk));
+
+	/* Push the previous esp onto the stack */
+	prev_esp = (u32 *)irqstk;
+	*prev_esp = current_stack_pointer;
 
 	call_on_stack(__do_softirq, isp);
 }
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0de43e9..7bc86bb 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -314,6 +314,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	arch_end_context_switch(next_p);
 
+	this_cpu_write(kernel_stack,
+		  (unsigned long)task_stack_page(next_p) +
+		  THREAD_SIZE - KERNEL_STACK_OFFSET);
+
 	/*
 	 * Restore %gs if needed (which is common)
 	 */
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7461f50..678c0ad 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -184,14 +184,14 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
 	unsigned long sp = (unsigned long)&regs->sp;
-	struct thread_info *tinfo;
+	u32 *prev_esp;
 
 	if (context == (sp & ~(THREAD_SIZE - 1)))
 		return sp;
 
-	tinfo = (struct thread_info *)context;
-	if (tinfo->previous_esp)
-		return tinfo->previous_esp;
+	prev_esp = (u32 *)(context);
+	if (prev_esp)
+		return (unsigned long)prev_esp;
 
 	return (unsigned long)regs;
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..867d53e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -758,10 +758,10 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 #else
 	clear_tsk_thread_flag(idle, TIF_FORK);
 	initial_gs = per_cpu_offset(cpu);
+#endif
 	per_cpu(kernel_stack, cpu) =
 		(unsigned long)task_stack_page(idle) -
 		KERNEL_STACK_OFFSET + THREAD_SIZE;
-#endif
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	initial_code = (unsigned long)start_secondary;
 	stack_start  = idle->thread.sp;
