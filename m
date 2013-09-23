Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3IWPiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:38:22 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3IWPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:38:21 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/4] um: Rewrite show_stack()
Date: Mon, 23 Sep 2013 17:38:01 +0200
Message-Id: <1379950684-18710-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently on UML stack traces are not very reliable and both
x86 and x86_64 have their on implementations.
This patch unifies both and adds support to outline unreliable
functions calls.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/sysrq.c         | 85 ++++++++++++++++++++++++++----------------
 arch/um/kernel/um_arch.c       |  1 -
 arch/x86/um/asm/processor_32.h |  5 +++
 arch/x86/um/asm/processor_64.h |  5 +++
 arch/x86/um/sysrq_32.c         | 66 --------------------------------
 arch/x86/um/sysrq_64.c         |  8 +---
 6 files changed, 64 insertions(+), 106 deletions(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 0dc4d1c..33cc72e 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -1,6 +1,10 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Licensed under the GPL
+ * Copyright (C) 2013 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
  */
 
 #include <linux/kallsyms.h>
@@ -9,58 +13,75 @@
 #include <linux/sched.h>
 #include <asm/sysrq.h>
 
-/* Catch non-i386 SUBARCH's. */
-#if !defined(CONFIG_UML_X86) || defined(CONFIG_64BIT)
-void show_trace(struct task_struct *task, unsigned long * stack)
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+static void print_stack_trace(unsigned long *sp, unsigned long bp)
 {
+	int reliable;
 	unsigned long addr;
+	struct stack_frame *frame = (struct stack_frame *)bp;
 
-	if (!stack) {
-		stack = (unsigned long*) &stack;
-		WARN_ON(1);
-	}
-
-	printk(KERN_INFO "Call Trace: \n");
-	while (((long) stack & (THREAD_SIZE-1)) != 0) {
-		addr = *stack;
+	printk(KERN_INFO "Call Trace:\n");
+	while (((long) sp & (THREAD_SIZE-1)) != 0) {
+		addr = *sp;
 		if (__kernel_text_address(addr)) {
-			printk(KERN_INFO "%08lx:  [<%08lx>]",
-			       (unsigned long) stack, addr);
-			print_symbol(KERN_CONT " %s", addr);
+			reliable = 0;
+			if ((unsigned long) sp == bp + sizeof(long)) {
+				frame = frame ? frame->next_frame : NULL;
+				bp = (unsigned long)frame;
+				reliable = 1;
+			}
+
+			printk(KERN_INFO " [<%08lx>]", addr);
+			printk(KERN_CONT " %s", reliable ? "" : "? ");
+			print_symbol(KERN_CONT "%s", addr);
 			printk(KERN_CONT "\n");
 		}
-		stack++;
+		sp++;
 	}
 	printk(KERN_INFO "\n");
 }
-#endif
 
 /*Stolen from arch/i386/kernel/traps.c */
 static const int kstack_depth_to_print = 24;
 
-/* This recently started being used in arch-independent code too, as in
- * kernel/sched/core.c.*/
-void show_stack(struct task_struct *task, unsigned long *esp)
+static unsigned long get_frame_pointer(struct task_struct *task)
+{
+	if (!task || task == current)
+		return current_bp();
+	else
+		return KSTK_EBP(task);
+}
+
+void show_stack(struct task_struct *task, unsigned long *stack)
 {
-	unsigned long *stack;
+	unsigned long *sp = stack, bp = 0;
 	int i;
 
-	if (esp == NULL) {
-		if (task != current && task != NULL) {
-			esp = (unsigned long *) KSTK_ESP(task);
-		} else {
-			esp = (unsigned long *) &esp;
-		}
+#ifdef CONFIG_FRAME_POINTER
+	bp = get_frame_pointer(task);
+#endif
+
+	if (!stack) {
+		if (!task || task == current)
+			sp = current_sp();
+		else
+			sp = (unsigned long *)KSTK_ESP(task);
 	}
 
-	stack = esp;
+	printk(KERN_INFO "Stack:\n");
+	stack = sp;
 	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (kstack_end(stack))
 			break;
-		if (i && ((i % 8) == 0))
-			printk(KERN_INFO "       ");
-		printk(KERN_CONT "%08lx ", *stack++);
+		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
+			printk(KERN_CONT "\n");
+		printk(KERN_CONT " %08lx", *stack++);
 	}
+	printk(KERN_CONT "\n");
 
-	show_trace(task, esp);
+	print_stack_trace(sp, bp);
 }
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 87df5e3..b9dd13e 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -234,7 +234,6 @@ static int panic_exit(struct notifier_block *self, unsigned long unused1,
 		      void *unused2)
 {
 	bust_spinlocks(1);
-	show_regs(&(current->thread.regs));
 	bust_spinlocks(0);
 	uml_exitcode = 1;
 	os_dump_core();
diff --git a/arch/x86/um/asm/processor_32.h b/arch/x86/um/asm/processor_32.h
index 6c6689e..c112de8 100644
--- a/arch/x86/um/asm/processor_32.h
+++ b/arch/x86/um/asm/processor_32.h
@@ -33,6 +33,8 @@ struct arch_thread {
 	.faultinfo		= { 0, 0, 0 } \
 }
 
+#define STACKSLOTS_PER_LINE 8
+
 static inline void arch_flush_thread(struct arch_thread *thread)
 {
 	/* Clear any TLS still hanging */
@@ -53,4 +55,7 @@ static inline void arch_copy_thread(struct arch_thread *from,
 #define current_text_addr() \
 	({ void *pc; __asm__("movl $1f,%0\n1:":"=g" (pc)); pc; })
 
+#define current_sp() ({ void *sp; __asm__("movl %%esp, %0" : "=r" (sp) : ); sp; })
+#define current_bp() ({ unsigned long bp; __asm__("movl %%ebp, %0" : "=r" (bp) : ); bp; })
+
 #endif
diff --git a/arch/x86/um/asm/processor_64.h b/arch/x86/um/asm/processor_64.h
index 4b02a84..c3be852 100644
--- a/arch/x86/um/asm/processor_64.h
+++ b/arch/x86/um/asm/processor_64.h
@@ -19,6 +19,8 @@ struct arch_thread {
 			   .fs			= 0, \
 			   .faultinfo		= { 0, 0, 0 } }
 
+#define STACKSLOTS_PER_LINE 4
+
 static inline void arch_flush_thread(struct arch_thread *thread)
 {
 }
@@ -32,4 +34,7 @@ static inline void arch_copy_thread(struct arch_thread *from,
 #define current_text_addr() \
 	({ void *pc; __asm__("movq $1f,%0\n1:":"=g" (pc)); pc; })
 
+#define current_sp() ({ void *sp; __asm__("movq %%rsp, %0" : "=r" (sp) : ); sp; })
+#define current_bp() ({ unsigned long bp; __asm__("movq %%rbp, %0" : "=r" (bp) : ); bp; })
+
 #endif
diff --git a/arch/x86/um/sysrq_32.c b/arch/x86/um/sysrq_32.c
index c9bee5b..16ee0e4 100644
--- a/arch/x86/um/sysrq_32.c
+++ b/arch/x86/um/sysrq_32.c
@@ -30,70 +30,4 @@ void show_regs(struct pt_regs *regs)
         printk(" DS: %04lx ES: %04lx\n",
 	       0xffff & PT_REGS_DS(regs), 
 	       0xffff & PT_REGS_ES(regs));
-
-        show_trace(NULL, (unsigned long *) &regs);
 }
-
-/* Copied from i386. */
-static inline int valid_stack_ptr(struct thread_info *tinfo, void *p)
-{
-	return	p > (void *)tinfo &&
-		p < (void *)tinfo + THREAD_SIZE - 3;
-}
-
-/* Adapted from i386 (we also print the address we read from). */
-static inline unsigned long print_context_stack(struct thread_info *tinfo,
-				unsigned long *stack, unsigned long ebp)
-{
-	unsigned long addr;
-
-#ifdef CONFIG_FRAME_POINTER
-	while (valid_stack_ptr(tinfo, (void *)ebp)) {
-		addr = *(unsigned long *)(ebp + 4);
-		printk("%08lx:  [<%08lx>]", ebp + 4, addr);
-		print_symbol(" %s", addr);
-		printk("\n");
-		ebp = *(unsigned long *)ebp;
-	}
-#else
-	while (valid_stack_ptr(tinfo, stack)) {
-		addr = *stack;
-		if (__kernel_text_address(addr)) {
-			printk("%08lx:  [<%08lx>]", (unsigned long) stack, addr);
-			print_symbol(" %s", addr);
-			printk("\n");
-		}
-		stack++;
-	}
-#endif
-	return ebp;
-}
-
-void show_trace(struct task_struct* task, unsigned long * stack)
-{
-	unsigned long ebp;
-	struct thread_info *context;
-
-	/* Turn this into BUG_ON if possible. */
-	if (!stack) {
-		stack = (unsigned long*) &stack;
-		printk("show_trace: got NULL stack, implicit assumption task == current");
-		WARN_ON(1);
-	}
-
-	if (!task)
-		task = current;
-
-	if (task != current) {
-		ebp = (unsigned long) KSTK_EBP(task);
-	} else {
-		asm ("movl %%ebp, %0" : "=r" (ebp) : );
-	}
-
-	context = (struct thread_info *)
-		((unsigned long)stack & (~(THREAD_SIZE - 1)));
-	print_context_stack(context, stack, ebp);
-
-	printk("\n");
-}
-
diff --git a/arch/x86/um/sysrq_64.c b/arch/x86/um/sysrq_64.c
index a0e7fb1..38b4e4a 100644
--- a/arch/x86/um/sysrq_64.c
+++ b/arch/x86/um/sysrq_64.c
@@ -12,7 +12,7 @@
 #include <asm/ptrace.h>
 #include <asm/sysrq.h>
 
-void __show_regs(struct pt_regs *regs)
+void show_regs(struct pt_regs *regs)
 {
 	printk("\n");
 	print_modules();
@@ -33,9 +33,3 @@ void __show_regs(struct pt_regs *regs)
 	printk(KERN_INFO "R13: %016lx R14: %016lx R15: %016lx\n",
 	       PT_REGS_R13(regs), PT_REGS_R14(regs), PT_REGS_R15(regs));
 }
-
-void show_regs(struct pt_regs *regs)
-{
-	__show_regs(regs);
-	show_trace(current, (unsigned long *) &regs);
-}
-- 
1.8.3.1

