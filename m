Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaJXIex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:34:53 -0400
Received: from mail-bn1on0090.outbound.protection.outlook.com ([157.56.110.90]:55360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932323AbaJXIZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:26 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 10/29] nios2: Process management
Date: Fri, 24 Oct 2014 16:24:12 +0800
Message-ID: <1414139071-3818-11-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(22564002)(104166001)(44976005)(19580395003)(19580405001)(86362001)(93916002)(87936001)(68736004)(42186005)(6806004)(77096002)(47776003)(64706001)(102836001)(4396001)(50226001)(95666004)(88136002)(89996001)(20776003)(92726001)(85852003)(87286001)(2201001)(92566001)(107046002)(105596002)(229853001)(106466001)(31966008)(84676001)(33646002)(48376002)(50466002)(36756003)(76482002)(97736003)(77156001)(76176999)(50986999)(46102003)(99396003)(62966002)(85306004)(80022003)(120916001)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for thread creation and context switching.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/mmu_context.h |  66 +++++++++
 arch/nios2/include/asm/processor.h   | 103 ++++++++++++++
 arch/nios2/include/asm/switch_to.h   |  31 +++++
 arch/nios2/include/asm/thread_info.h | 120 ++++++++++++++++
 arch/nios2/kernel/process.c          | 257 +++++++++++++++++++++++++++++++++++
 arch/nios2/mm/mmu_context.c          | 116 ++++++++++++++++
 6 files changed, 693 insertions(+)
 create mode 100644 arch/nios2/include/asm/mmu_context.h
 create mode 100644 arch/nios2/include/asm/processor.h
 create mode 100644 arch/nios2/include/asm/switch_to.h
 create mode 100644 arch/nios2/include/asm/thread_info.h
 create mode 100644 arch/nios2/kernel/process.c
 create mode 100644 arch/nios2/mm/mmu_context.c

diff --git a/arch/nios2/include/asm/mmu_context.h b/arch/nios2/include/asm/mmu_context.h
new file mode 100644
index 0000000..294b4b1
--- /dev/null
+++ b/arch/nios2/include/asm/mmu_context.h
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 1996, 1997, 1998, 1999 by Ralf Baechle
+ * Copyright (C) 1999 Silicon Graphics, Inc.
+ *
+ * based on MIPS asm/mmu_context.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_MMU_CONTEXT_H
+#define _ASM_NIOS2_MMU_CONTEXT_H
+
+#include <asm-generic/mm_hooks.h>
+
+extern void mmu_context_init(void);
+extern unsigned long get_pid_from_context(mm_context_t *ctx);
+
+/*
+ * For the fast tlb miss handlers, we keep a pointer to the current pgd.
+ * processor.
+ */
+extern pgd_t *pgd_current;
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+/*
+ * Initialize the context related info for a new mm_struct instance.
+ *
+ * Set all new contexts to 0, that way the generation will never match
+ * the currently running generation when this context is switched in.
+ */
+static inline int init_new_context(struct task_struct *tsk,
+					struct mm_struct *mm)
+{
+	mm->context = 0;
+	return 0;
+}
+
+/*
+ * Destroy context related info for an mm_struct that is about
+ * to be put to rest.
+ */
+static inline void destroy_context(struct mm_struct *mm)
+{
+}
+
+void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+		struct task_struct *tsk);
+
+static inline void deactivate_mm(struct task_struct *tsk,
+				struct mm_struct *mm)
+{
+}
+
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+void activate_mm(struct mm_struct *prev, struct mm_struct *next);
+
+#endif /* _ASM_NIOS2_MMU_CONTEXT_H */
diff --git a/arch/nios2/include/asm/processor.h b/arch/nios2/include/asm/processor.h
new file mode 100644
index 0000000..3bd3494
--- /dev/null
+++ b/arch/nios2/include/asm/processor.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ * Copyright (C) 2001 Ken Hill (khill@microtronix.com)
+ *                    Vic Phillips (vic@microtronix.com)
+ *
+ * based on SPARC asm/processor_32.h which is:
+ *
+ * Copyright (C) 1994 David S. Miller
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_PROCESSOR_H
+#define _ASM_NIOS2_PROCESSOR_H
+
+#include <asm/ptrace.h>
+#include <asm/registers.h>
+#include <asm/page.h>
+
+#define NIOS2_FLAG_KTHREAD	0x00000001	/* task is a kernel thread */
+
+#define NIOS2_OP_NOP		0x1883a
+#define NIOS2_OP_BREAK		0x3da03a
+
+#ifdef __KERNEL__
+
+#define STACK_TOP	TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+
+#endif /* __KERNEL__ */
+
+/* Kuser helpers is mapped to this user space address */
+#define KUSER_BASE		0x1000
+#define KUSER_SIZE		(PAGE_SIZE)
+#ifndef __ASSEMBLY__
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l; })
+
+# define TASK_SIZE		0x7FFF0000UL
+# define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+
+/* The Nios processor specific thread struct. */
+struct thread_struct {
+	struct pt_regs *kregs;
+
+	/* Context switch saved kernel state. */
+	unsigned long ksp;
+	unsigned long kpsr;
+};
+
+#define INIT_MMAP \
+	{ &init_mm, (0), (0), __pgprot(0x0), VM_READ | VM_WRITE | VM_EXEC }
+
+# define INIT_THREAD {			\
+	.kregs	= NULL,			\
+	.ksp	= 0,			\
+	.kpsr	= 0,			\
+}
+
+extern void start_thread(struct pt_regs *regs, unsigned long pc,
+			unsigned long sp);
+
+struct task_struct;
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+/* Free current thread data structures etc.. */
+static inline void exit_thread(void)
+{
+}
+
+/* Return saved PC of a blocked thread. */
+#define thread_saved_pc(tsk)	((tsk)->thread.kregs->ea)
+
+extern unsigned long get_wchan(struct task_struct *p);
+
+/* Prepare to copy thread state - unlazy all lazy status */
+#define prepare_to_copy(tsk)	do { } while (0)
+
+#define task_pt_regs(p) \
+	((struct pt_regs *)(THREAD_SIZE + task_stack_page(p)) - 1)
+
+/* Used by procfs */
+#define KSTK_EIP(tsk)	((tsk)->thread.kregs->ea)
+#define KSTK_ESP(tsk)	((tsk)->thread.kregs->sp)
+
+#define cpu_relax()	barrier()
+#define cpu_relax_lowlatency()  cpu_relax()
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_NIOS2_PROCESSOR_H */
diff --git a/arch/nios2/include/asm/switch_to.h b/arch/nios2/include/asm/switch_to.h
new file mode 100644
index 0000000..c47b3f4
--- /dev/null
+++ b/arch/nios2/include/asm/switch_to.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef _ASM_NIOS2_SWITCH_TO_H
+#define _ASM_NIOS2_SWITCH_TO_H
+
+/*
+ * switch_to(n) should switch tasks to task ptr, first checking that
+ * ptr isn't the current task, in which case it does nothing.  This
+ * also clears the TS-flag if the task we switched to has used the
+ * math co-processor latest.
+ */
+#define switch_to(prev, next, last)			\
+{							\
+	void *_last;					\
+	__asm__ __volatile__ (				\
+		"mov	r4, %1\n"			\
+		"mov	r5, %2\n"			\
+		"call	resume\n"			\
+		"mov	%0,r4\n"			\
+		: "=r" (_last)				\
+		: "r" (prev), "r" (next)		\
+		: "r4", "r5", "r7", "r8", "ra");	\
+	(last) = _last;					\
+}
+
+#endif /* _ASM_NIOS2_SWITCH_TO_H */
diff --git a/arch/nios2/include/asm/thread_info.h b/arch/nios2/include/asm/thread_info.h
new file mode 100644
index 0000000..1f26657
--- /dev/null
+++ b/arch/nios2/include/asm/thread_info.h
@@ -0,0 +1,120 @@
+/*
+ * NiosII low-level thread information
+ *
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * Based on asm/thread_info_no.h from m68k which is:
+ *
+ * Copyright (C) 2002 David Howells <dhowells@redhat.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_THREAD_INFO_H
+#define _ASM_NIOS2_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+/*
+ * Size of the kernel stack for each process.
+ */
+#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE		8192 /* 2 * PAGE_SIZE */
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants
+ *   must also be changed
+ */
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	__u32			cpu;		/* current CPU */
+	int			preempt_count;	/* 0 => preemptable,<0 => BUG */
+	mm_segment_t		addr_limit;	/* thread address space:
+						  0-0x7FFFFFFF for user-thead
+						  0-0xFFFFFFFF for kernel-thread
+						*/
+	struct restart_block	restart_block;
+	struct pt_regs		*regs;
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block	= {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* how to get the thread information struct from C */
+static inline struct thread_info *current_thread_info(void)
+{
+	register unsigned long sp asm("sp");
+
+	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
+}
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need to
+ *   access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_MEMDIE		4	/* is terminating due to OOM killer */
+#define TIF_SECCOMP		5	/* secure computing */
+#define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
+#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
+
+#define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling
+					   TIF_NEED_RESCHED */
+
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+
+/* work to do on interrupt/exception return */
+#define _TIF_WORK_MASK		0x0000FFFE
+
+/* work to do on any return to u-space */
+# define _TIF_ALLWORK_MASK	0x0000FFFF
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_NIOS2_THREAD_INFO_H */
diff --git a/arch/nios2/kernel/process.c b/arch/nios2/kernel/process.c
new file mode 100644
index 0000000..e4c85bb
--- /dev/null
+++ b/arch/nios2/kernel/process.c
@@ -0,0 +1,257 @@
+/*
+ * Architecture-dependent parts of process handling.
+ *
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/tick.h>
+#include <linux/uaccess.h>
+
+#include <asm/unistd.h>
+#include <asm/traps.h>
+#include <asm/cpuinfo.h>
+
+asmlinkage void ret_from_fork(void);
+asmlinkage void ret_from_kernel_thread(void);
+
+void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
+
+void arch_cpu_idle(void)
+{
+	local_irq_enable();
+}
+
+/*
+ * The development boards have no way to pull a board reset. Just jump to the
+ * cpu reset address and let the boot loader or the code in head.S take care of
+ * resetting peripherals.
+ */
+void machine_restart(char *__unused)
+{
+	pr_notice("Machine restart (%08x)...\n", cpuinfo.reset_addr);
+	local_irq_disable();
+	__asm__ __volatile__ (
+	"jmp	%0\n\t"
+	:
+	: "r" (cpuinfo.reset_addr)
+	: "r4");
+}
+
+void machine_halt(void)
+{
+	pr_notice("Machine halt...\n");
+	local_irq_disable();
+	for (;;)
+		;
+}
+
+/*
+ * There is no way to power off the development boards. So just spin for now. If
+ * we ever have a way of resetting a board using a GPIO we should add that here.
+ */
+void machine_power_off(void)
+{
+	pr_notice("Machine power off...\n");
+	local_irq_disable();
+	for (;;)
+		;
+}
+
+void show_regs(struct pt_regs *regs)
+{
+	pr_notice("\n");
+	show_regs_print_info(KERN_DEFAULT);
+
+	pr_notice("r1: %08lx r2: %08lx r3: %08lx r4: %08lx\n",
+		regs->r1,  regs->r2,  regs->r3,  regs->r4);
+
+	pr_notice("r5: %08lx r6: %08lx r7: %08lx r8: %08lx\n",
+		regs->r5,  regs->r6,  regs->r7,  regs->r8);
+
+	pr_notice("r9: %08lx r10: %08lx r11: %08lx r12: %08lx\n",
+		regs->r9,  regs->r10, regs->r11, regs->r12);
+
+	pr_notice("r13: %08lx r14: %08lx r15: %08lx\n",
+		regs->r13, regs->r14, regs->r15);
+
+	pr_notice("ra: %08lx fp:  %08lx sp: %08lx gp: %08lx\n",
+		regs->ra,  regs->fp,  regs->sp,  regs->gp);
+
+	pr_notice("ea: %08lx estatus: %08lx\n",
+		regs->ea,  regs->estatus);
+}
+
+void flush_thread(void)
+{
+	set_fs(USER_DS);
+}
+
+int copy_thread(unsigned long clone_flags,
+		unsigned long usp, unsigned long arg, struct task_struct *p)
+{
+	struct pt_regs *childregs = task_pt_regs(p);
+	struct pt_regs *regs;
+	struct switch_stack *stack;
+	struct switch_stack *childstack =
+		((struct switch_stack *)childregs) - 1;
+
+	if (unlikely(p->flags & PF_KTHREAD)) {
+		memset(childstack, 0,
+			sizeof(struct switch_stack) + sizeof(struct pt_regs));
+
+		childstack->r16 = usp;		/* fn */
+		childstack->r17 = arg;
+		childstack->ra = (unsigned long) ret_from_kernel_thread;
+		childregs->estatus = STATUS_PIE;
+		childregs->sp = (unsigned long) childstack;
+
+		p->thread.ksp = (unsigned long) childstack;
+		p->thread.kregs = childregs;
+		return 0;
+	}
+
+	regs = current_pt_regs();
+	*childregs = *regs;
+	childregs->r2 = 0;	/* Set the return value for the child. */
+	childregs->r7 = 0;
+
+	stack = ((struct switch_stack *) regs) - 1;
+	*childstack = *stack;
+	childstack->ra = (unsigned long)ret_from_fork;
+	p->thread.kregs = childregs;
+	p->thread.ksp = (unsigned long) childstack;
+
+	if (usp)
+		childregs->sp = usp;
+
+	/* Initialize tls register. */
+	if (clone_flags & CLONE_SETTLS)
+		childstack->r23 = regs->r8;
+
+	return 0;
+}
+
+/*
+ *	Generic dumping code. Used for panic and debug.
+ */
+void dump(struct pt_regs *fp)
+{
+	unsigned long	*sp;
+	unsigned char	*tp;
+	int		i;
+
+	pr_emerg("\nCURRENT PROCESS:\n\n");
+	pr_emerg("COMM=%s PID=%d\n", current->comm, current->pid);
+
+	if (current->mm) {
+		pr_emerg("TEXT=%08x-%08x DATA=%08x-%08x BSS=%08x-%08x\n",
+			(int) current->mm->start_code,
+			(int) current->mm->end_code,
+			(int) current->mm->start_data,
+			(int) current->mm->end_data,
+			(int) current->mm->end_data,
+			(int) current->mm->brk);
+		pr_emerg("USER-STACK=%08x  KERNEL-STACK=%08x\n\n",
+			(int) current->mm->start_stack,
+			(int)(((unsigned long) current) + THREAD_SIZE));
+	}
+
+	pr_emerg("PC: %08lx\n", fp->ea);
+	pr_emerg(KERN_EMERG "SR: %08lx    SP: %08lx\n",
+		(long) fp->estatus, (long) fp);
+
+	pr_emerg("r1: %08lx    r2: %08lx    r3: %08lx\n",
+		fp->r1, fp->r2, fp->r3);
+
+	pr_emerg("r4: %08lx    r5: %08lx    r6: %08lx    r7: %08lx\n",
+		fp->r4, fp->r5, fp->r6, fp->r7);
+	pr_emerg("r8: %08lx    r9: %08lx    r10: %08lx    r11: %08lx\n",
+		fp->r8, fp->r9, fp->r10, fp->r11);
+	pr_emerg("r12: %08lx  r13: %08lx    r14: %08lx    r15: %08lx\n",
+		fp->r12, fp->r13, fp->r14, fp->r15);
+	pr_emerg("or2: %08lx   ra: %08lx     fp: %08lx    sp: %08lx\n",
+		fp->orig_r2, fp->ra, fp->fp, fp->sp);
+	pr_emerg("\nUSP: %08x   TRAPFRAME: %08x\n",
+		(unsigned int) fp->sp, (unsigned int) fp);
+
+	pr_emerg("\nCODE:");
+	tp = ((unsigned char *) fp->ea) - 0x20;
+	for (sp = (unsigned long *) tp, i = 0; (i < 0x40);  i += 4) {
+		if ((i % 0x10) == 0)
+			pr_emerg("\n%08x: ", (int) (tp + i));
+		pr_emerg("%08x ", (int) *sp++);
+	}
+	pr_emerg("\n");
+
+	pr_emerg("\nKERNEL STACK:");
+	tp = ((unsigned char *) fp) - 0x40;
+	for (sp = (unsigned long *) tp, i = 0; (i < 0xc0); i += 4) {
+		if ((i % 0x10) == 0)
+			pr_emerg("\n%08x: ", (int) (tp + i));
+		pr_emerg("%08x ", (int) *sp++);
+	}
+	pr_emerg("\n");
+	pr_emerg("\n");
+
+	pr_emerg("\nUSER STACK:");
+	tp = (unsigned char *) (fp->sp - 0x10);
+	for (sp = (unsigned long *) tp, i = 0; (i < 0x80); i += 4) {
+		if ((i % 0x10) == 0)
+			pr_emerg("\n%08x: ", (int) (tp + i));
+		pr_emerg("%08x ", (int) *sp++);
+	}
+	pr_emerg("\n\n");
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	unsigned long fp, pc;
+	unsigned long stack_page;
+	int count = 0;
+	if (!p || p == current || p->state == TASK_RUNNING)
+		return 0;
+
+	stack_page = (unsigned long)p;
+	fp = ((struct switch_stack *)p->thread.ksp)->fp;	/* ;dgt2 */
+	do {
+		if (fp < stack_page+sizeof(struct task_struct) ||
+			fp >= 8184+stack_page)	/* ;dgt2;tmp */
+			return 0;
+		pc = ((unsigned long *)fp)[1];
+		if (!in_sched_functions(pc))
+			return pc;
+		fp = *(unsigned long *) fp;
+	} while (count++ < 16);		/* ;dgt2;tmp */
+	return 0;
+}
+
+/*
+ * Do necessary setup to start up a newly executed thread.
+ * Will startup in user mode (status_extension = 0).
+ */
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long sp)
+{
+	memset((void *) regs, 0, sizeof(struct pt_regs));
+	regs->estatus = ESTATUS_EPIE | ESTATUS_EU;
+	regs->ea = pc;
+	regs->sp = sp;
+}
+
+#include <linux/elfcore.h>
+
+/* Fill in the FPU structure for a core dump. */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *r)
+{
+	return 0; /* Nios2 has no FPU and thus no FPU registers */
+}
diff --git a/arch/nios2/mm/mmu_context.c b/arch/nios2/mm/mmu_context.c
new file mode 100644
index 0000000..45d6b9c
--- /dev/null
+++ b/arch/nios2/mm/mmu_context.c
@@ -0,0 +1,116 @@
+/*
+ * MMU context handling.
+ *
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2009 Wind River Systems Inc
+ *   Implemented by fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/mm.h>
+
+#include <asm/cpuinfo.h>
+#include <asm/mmu_context.h>
+#include <asm/tlb.h>
+
+/* The pids position and mask in context */
+#define PID_SHIFT	0
+#define PID_BITS	(cpuinfo.tlb_pid_num_bits)
+#define PID_MASK	((1UL << PID_BITS) - 1)
+
+/* The versions position and mask in context */
+#define VERSION_BITS	(32 - PID_BITS)
+#define VERSION_SHIFT	(PID_SHIFT + PID_BITS)
+#define VERSION_MASK	((1UL << VERSION_BITS) - 1)
+
+/* Return the version part of a context */
+#define CTX_VERSION(c)	(((c) >> VERSION_SHIFT) & VERSION_MASK)
+
+/* Return the pid part of a context */
+#define CTX_PID(c)	(((c) >> PID_SHIFT) & PID_MASK)
+
+/* Value of the first context (version 1, pid 0) */
+#define FIRST_CTX	((1UL << VERSION_SHIFT) | (0 << PID_SHIFT))
+
+static mm_context_t next_mmu_context;
+
+/*
+ * Initialize MMU context management stuff.
+ */
+void __init mmu_context_init(void)
+{
+	/* We need to set this here because the value depends on runtime data
+	 * from cpuinfo */
+	next_mmu_context = FIRST_CTX;
+}
+
+/*
+ * Set new context (pid), keep way
+ */
+static void set_context(mm_context_t context)
+{
+	set_mmu_pid(CTX_PID(context));
+}
+
+static mm_context_t get_new_context(void)
+{
+	/* Return the next pid */
+	next_mmu_context += (1UL << PID_SHIFT);
+
+	/* If the pid field wraps around we increase the version and
+	 * flush the tlb */
+	if (unlikely(CTX_PID(next_mmu_context) == 0)) {
+		/* Version is incremented since the pid increment above
+		 * overflows info version */
+		flush_cache_all();
+		flush_tlb_all();
+	}
+
+	/* If the version wraps we start over with the first generation, we do
+	 * not need to flush the tlb here since it's always done above */
+	if (unlikely(CTX_VERSION(next_mmu_context) == 0))
+		next_mmu_context = FIRST_CTX;
+
+	return next_mmu_context;
+}
+
+void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+	       struct task_struct *tsk)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/* If the process context we are swapping in has a different context
+	 * generation then we have it should get a new generation/pid */
+	if (unlikely(CTX_VERSION(next->context) !=
+		CTX_VERSION(next_mmu_context)))
+		next->context = get_new_context();
+
+	/* Save the current pgd so the fast tlb handler can find it */
+	pgd_current = next->pgd;
+
+	/* Set the current context */
+	set_context(next->context);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+void activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+	next->context = get_new_context();
+	set_context(next->context);
+	pgd_current = next->pgd;
+}
+
+unsigned long get_pid_from_context(mm_context_t *context)
+{
+	return CTX_PID((*context));
+}
-- 
1.8.2.1

