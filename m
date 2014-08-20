Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaHTJ4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:56:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40042 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHTJ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:56:04 -0400
Date: Wed, 20 Aug 2014 10:56:00 +0100
From: Daniel Walter <dwalter@google.com>
To: richard@nod.at
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] uml: Add support for CONFIG_STACKTRACE
Message-ID: <20140820095600.GA19605@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add stacktrace support for User Mode Linux

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/um/Kconfig.common           |  3 +-
 arch/um/include/asm/stacktrace.h | 42 +++++++++++++++++++++
 arch/um/kernel/Makefile          |  1 +
 arch/um/kernel/stacktrace.c      | 80 ++++++++++++++++++++++++++++++++++++++++
 arch/um/kernel/sysrq.c           | 69 +++++++++-------------------------
 5 files changed, 142 insertions(+), 53 deletions(-)
 create mode 100644 arch/um/include/asm/stacktrace.h
 create mode 100644 arch/um/kernel/stacktrace.c

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 6915d28..87bc868 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -39,7 +39,8 @@ config LOCKDEP_SUPPORT
 
 config STACKTRACE_SUPPORT
 	bool
-	default n
+	default y
+	select STACKTRACE
 
 config GENERIC_CALIBRATE_DELAY
 	bool
diff --git a/arch/um/include/asm/stacktrace.h b/arch/um/include/asm/stacktrace.h
new file mode 100644
index 0000000..9a86432
--- /dev/null
+++ b/arch/um/include/asm/stacktrace.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_UML_STACKTRACE_H
+#define _ASM_UML_STACKTRACE_H
+
+#include <linux/uaccess.h>
+#include <linux/ptrace.h>
+
+struct stack_frame {
+	struct stack_frame *next_frame;
+	unsigned long return_address;
+};
+
+struct stacktrace_ops {
+	void (*address)(void *data, unsigned long address, int reliable);
+};
+
+#ifdef CONFIG_FRAME_POINTER
+static inline unsigned long
+get_frame_pointer(struct task_struct *task, struct pt_regs *segv_regs)
+{
+	if (!task || task == current)
+		return segv_regs ? PT_REGS_BP(segv_regs) : current_bp();
+	return KSTK_EBP(task);
+}
+#else
+static inline unsigned long
+get_frame_pointer(struct task_struct *task, struct pt_regs *segv_regs)
+{
+	return 0;
+}
+#endif
+
+static inline unsigned long
+*get_stack_pointer(struct task_struct *task, struct pt_regs *segv_regs)
+{
+	if (!task || task == current)
+		return segv_regs ? (unsigned long *)PT_REGS_SP(segv_regs) : current_sp();
+	return (unsigned long *)KSTK_ESP(task);
+}
+
+void dump_trace(struct task_struct *tsk, const struct stacktrace_ops *ops, void *data);
+
+#endif /* _ASM_UML_STACKTRACE_H */
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index d8b78a0..2d840a0 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
 obj-$(CONFIG_GPROF)	+= gprof_syms.o
 obj-$(CONFIG_GCOV)	+= gmon_syms.o
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
+obj-$(CONFIG_STACKTRACE) += stacktrace.o
 
 USER_OBJS := config.o
 
diff --git a/arch/um/kernel/stacktrace.c b/arch/um/kernel/stacktrace.c
new file mode 100644
index 0000000..ebe7bcf
--- /dev/null
+++ b/arch/um/kernel/stacktrace.c
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Copyright (C) 2013 Richard Weinberger <richard@nod.at>
+ * Copyright (C) 2014 Google Inc., Author: Daniel Walter <dwalter@google.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kallsyms.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <asm/stacktrace.h>
+
+void dump_trace(struct task_struct *tsk,
+		const struct stacktrace_ops *ops,
+		void *data)
+{
+	int reliable = 0;
+	unsigned long *sp, bp, addr;
+	struct pt_regs *segv_regs = tsk->thread.segv_regs;
+	struct stack_frame *frame;
+
+	bp = get_frame_pointer(tsk, segv_regs);
+	sp = get_stack_pointer(tsk, segv_regs);
+
+	frame = (struct stack_frame *)bp;
+	while (((long) sp & (THREAD_SIZE-1)) != 0) {
+		addr = *sp;
+		if (__kernel_text_address(addr)) {
+			reliable = 0;
+			if ((unsigned long) sp == bp + sizeof(long)) {
+				frame = frame ? frame->next_frame : NULL;
+				bp = (unsigned long)frame;
+				reliable = 1;
+			}
+			ops->address(data, addr, reliable);
+		}
+		sp++;
+	}
+}
+
+static void save_addr(void *data, unsigned long address, int reliable)
+{
+	struct stack_trace *trace = data;
+
+	if (!reliable)
+		return;
+	if (trace->nr_entries >= trace->max_entries)
+		return;
+
+	trace->entries[trace->nr_entries++] = address;
+}
+
+static const struct stacktrace_ops dump_ops = {
+	.address = save_addr
+};
+
+static void __save_stack_trace(struct task_struct *tsk, struct stack_trace *trace)
+{
+	dump_trace(tsk, &dump_ops, trace);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
+}
+
+void save_stack_trace(struct stack_trace *trace)
+{
+	__save_stack_trace(current, trace);
+}
+EXPORT_SYMBOL_GPL(save_stack_trace);
+
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	__save_stack_trace(tsk, trace);
+}
+EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 799d7e4..894c8d3 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -12,57 +12,20 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <asm/sysrq.h>
+#include <asm/stacktrace.h>
 #include <os.h>
 
-struct stack_frame {
-	struct stack_frame *next_frame;
-	unsigned long return_address;
-};
-
-static void do_stack_trace(unsigned long *sp, unsigned long bp)
+static void _print_addr(void *data, unsigned long address, int reliable)
 {
-	int reliable;
-	unsigned long addr;
-	struct stack_frame *frame = (struct stack_frame *)bp;
-
-	printk(KERN_INFO "Call Trace:\n");
-	while (((long) sp & (THREAD_SIZE-1)) != 0) {
-		addr = *sp;
-		if (__kernel_text_address(addr)) {
-			reliable = 0;
-			if ((unsigned long) sp == bp + sizeof(long)) {
-				frame = frame ? frame->next_frame : NULL;
-				bp = (unsigned long)frame;
-				reliable = 1;
-			}
-
-			printk(KERN_INFO " [<%08lx>]", addr);
-			printk(KERN_CONT " %s", reliable ? "" : "? ");
-			print_symbol(KERN_CONT "%s", addr);
-			printk(KERN_CONT "\n");
-		}
-		sp++;
-	}
-	printk(KERN_INFO "\n");
+	pr_info(" [<%08lx>]", address);
+	pr_cont(" %s", reliable ? "" : "? ");
+	print_symbol("%s", address);
+	pr_cont("\n");
 }
 
-static unsigned long get_frame_pointer(struct task_struct *task,
-				       struct pt_regs *segv_regs)
-{
-	if (!task || task == current)
-		return segv_regs ? PT_REGS_BP(segv_regs) : current_bp();
-	else
-		return KSTK_EBP(task);
-}
-
-static unsigned long *get_stack_pointer(struct task_struct *task,
-					struct pt_regs *segv_regs)
-{
-	if (!task || task == current)
-		return segv_regs ? (unsigned long *)PT_REGS_SP(segv_regs) : current_sp();
-	else
-		return (unsigned long *)KSTK_ESP(task);
-}
+static const struct stacktrace_ops stackops = {
+	.address = _print_addr
+};
 
 void show_stack(struct task_struct *task, unsigned long *stack)
 {
@@ -71,7 +34,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	int i;
 
 	if (!segv_regs && os_is_signal_stack()) {
-		printk(KERN_ERR "Received SIGSEGV in SIGSEGV handler,"
+		pr_err("Received SIGSEGV in SIGSEGV handler,"
 				" aborting stack trace!\n");
 		return;
 	}
@@ -83,16 +46,18 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	if (!stack)
 		sp = get_stack_pointer(task, segv_regs);
 
-	printk(KERN_INFO "Stack:\n");
+	pr_info("Stack:\n");
 	stack = sp;
 	for (i = 0; i < 3 * STACKSLOTS_PER_LINE; i++) {
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk(KERN_CONT "\n");
-		printk(KERN_CONT " %08lx", *stack++);
+			pr_cont("\n");
+		pr_cont(" %08lx", *stack++);
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 
-	do_stack_trace(sp, bp);
+	pr_info("Call Trace:\n");
+	dump_trace(current, &stackops, NULL);
+	pr_info("\n");
 }
-- 
2.1.0.rc2.206.gedb03e5

