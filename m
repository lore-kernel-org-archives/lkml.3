Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaLaPXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:23:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaLaPXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:23:13 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 8/8] ARM64: Add uprobe support
Date: Wed, 31 Dec 2014 20:51:24 +0530
Message-Id: <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
In-Reply-To: <cover.1420038188.git.panand@redhat.com>
References: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for uprobe on ARM64 architecture.

Unit test for following has been done so far and they have been found
working
1. Normal instruction, which can be probed like sub, ldr, add etc.
2. Instructions which can be simulated like ret.
3. uretprobe

Signed-off-by: Pratyush Anand <panand@redhat.com>
---
 arch/arm64/Kconfig                   |   3 +
 arch/arm64/include/asm/insn.h        |   2 +
 arch/arm64/include/asm/probes.h      |   1 +
 arch/arm64/include/asm/ptrace.h      |   1 +
 arch/arm64/include/asm/thread_info.h |   5 +-
 arch/arm64/include/asm/uprobes.h     |  43 ++++++
 arch/arm64/kernel/Makefile           |   3 +
 arch/arm64/kernel/signal.c           |   4 +-
 arch/arm64/kernel/uprobes.c          | 255 +++++++++++++++++++++++++++++++++++
 arch/arm64/mm/flush.c                |   6 +
 10 files changed, 321 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/uprobes.h
 create mode 100644 arch/arm64/kernel/uprobes.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index de4f0561cd14..51b1db7a3bc9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -145,6 +145,9 @@ config KERNEL_MODE_NEON
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config ARCH_SUPPORTS_UPROBES
+	def_bool y
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 87fa48746806..412df9457260 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -27,6 +27,8 @@
 #define BRK64_ESR_MASK		0xFFFF
 #define BRK64_ESR_KPROBES	0x0004
 #define BRK64_OPCODE_KPROBES	0xD4200080	/* "brk 0x4" */
+#define BRK64_ESR_UPROBES	0x0008
+#define BRK64_OPCODE_UPROBES	0xD4200100	/* "brk 0x8" */
 #define ARCH64_NOP_OPCODE	0xD503201F
 
 #ifndef __ASSEMBLY__
diff --git a/arch/arm64/include/asm/probes.h b/arch/arm64/include/asm/probes.h
index daa2ff822a2e..25a69508d137 100644
--- a/arch/arm64/include/asm/probes.h
+++ b/arch/arm64/include/asm/probes.h
@@ -18,6 +18,7 @@
 struct arch_specific_insn;
 
 typedef u32 kprobe_opcode_t;
+typedef u32 uprobe_opcode_t;
 typedef u32 probe_opcode_t;
 typedef unsigned long (probes_pstate_check_t)(unsigned long);
 typedef unsigned long
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 29d9bf5e3635..79c312bb503e 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -205,6 +205,7 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
 
 #define instruction_pointer(regs)	((regs)->pc)
 #define stack_pointer(regs)		((regs)->sp)
+#define procedure_link_pointer(regs)	((regs)->regs[30])
 
 static inline void instruction_pointer_set(struct pt_regs *regs,
 					   unsigned long val)
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 459bf8e53208..3d5d1ec181cb 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -108,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
+#define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_NOHZ		7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_SYSCALL_AUDIT	9
@@ -129,10 +130,12 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
+#define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE)
+				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
+				 _TIF_UPROBE)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/include/asm/uprobes.h b/arch/arm64/include/asm/uprobes.h
new file mode 100644
index 000000000000..f575dc389b85
--- /dev/null
+++ b/arch/arm64/include/asm/uprobes.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2014 Pratyush Anand <panand@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_UPROBES_H
+#define _ASM_UPROBES_H
+#include <asm/insn.h>
+#include <asm/probes.h>
+
+#define MAX_UINSN_BYTES		AARCH64_INSN_SIZE
+
+#define UPROBE_SWBP_INSN	BRK64_OPCODE_UPROBES
+#define UPROBE_SWBP_INSN_SIZE	4
+#define UPROBE_XOL_SLOT_BYTES	MAX_UINSN_BYTES
+
+/* Single step context for uprobe */
+struct uprobe_step_ctx {
+	struct list_head node;
+	unsigned long match_addr;
+};
+
+struct arch_uprobe_task {
+	unsigned long saved_fault_code;
+	u64 saved_user_pc;
+	struct uprobe_step_ctx ss_ctx;
+};
+
+struct arch_uprobe {
+	union {
+		u8 insn[MAX_UINSN_BYTES];
+		u8 ixol[MAX_UINSN_BYTES];
+	};
+	struct arch_specific_insn ainsn;
+	bool simulate;
+};
+
+extern void flush_uprobe_xol_access(struct page *page, unsigned long uaddr,
+		void *kaddr, unsigned long len);
+#endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 0ed83ba3d46d..0e5f0af91540 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -31,6 +31,9 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
+arm64-obj-$(CONFIG_UPROBES)		+= uprobes.o probes-arm64.o		\
+					   probes-simulate-insn.o		\
+					   probes-condn-check.o
 arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o probes-arm64.o		\
 					   probes-simulate-insn.o		\
 					   probes-condn-check.o
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6fa792137eda..2d1e18b0cc10 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -409,6 +409,9 @@ static void do_signal(struct pt_regs *regs)
 asmlinkage void do_notify_resume(struct pt_regs *regs,
 				 unsigned int thread_flags)
 {
+	if (thread_flags & _TIF_UPROBE)
+		uprobe_notify_resume(regs);
+
 	if (thread_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
@@ -419,5 +422,4 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 
 	if (thread_flags & _TIF_FOREIGN_FPSTATE)
 		fpsimd_restore_current_state();
-
 }
diff --git a/arch/arm64/kernel/uprobes.c b/arch/arm64/kernel/uprobes.c
new file mode 100644
index 000000000000..fdc6dc3cfb0b
--- /dev/null
+++ b/arch/arm64/kernel/uprobes.c
@@ -0,0 +1,255 @@
+/*
+ * Copyright (C) 2014 Pratyush Anand <panand@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/highmem.h>
+#include <linux/ptrace.h>
+#include <linux/uprobes.h>
+#include <asm/debug-monitors.h>
+#include <asm/probes.h>
+
+#include "probes-arm64.h"
+
+#define UPROBE_INV_FAULT_CODE	UINT_MAX
+
+static LIST_HEAD(step_ctx);
+static DEFINE_RWLOCK(step_ctx_lock);
+
+static void add_ss_context(struct uprobe_task *utask)
+{
+	struct uprobe_step_ctx *ss_ctx = &utask->autask.ss_ctx;
+
+	ss_ctx->match_addr = utask->xol_vaddr;
+	write_lock(&step_ctx_lock);
+	list_add(&ss_ctx->node, &step_ctx);
+	write_unlock(&step_ctx_lock);
+}
+
+static struct uprobe_step_ctx *find_ss_context(unsigned long vaddr)
+{
+	struct uprobe_step_ctx *ss_ctx;
+
+	read_lock(&step_ctx_lock);
+	list_for_each_entry(ss_ctx, &step_ctx, node)	{
+		if (ss_ctx->match_addr == vaddr) {
+			read_unlock(&step_ctx_lock);
+			return ss_ctx;
+		}
+	}
+	read_unlock(&step_ctx_lock);
+
+	return NULL;
+}
+
+static void del_ss_context(struct uprobe_task *utask)
+{
+	struct uprobe_step_ctx *ss_ctx = find_ss_context(utask->xol_vaddr);
+
+	if (ss_ctx) {
+		write_lock(&step_ctx_lock);
+		list_del(&ss_ctx->node);
+		write_unlock(&step_ctx_lock);
+	} else {
+		WARN_ON(1);
+	}
+}
+
+void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
+		void *src, unsigned long len)
+{
+	void *xol_page_kaddr = kmap_atomic(page);
+	void *dst = xol_page_kaddr + (vaddr & ~PAGE_MASK);
+
+	preempt_disable();
+
+	/* Initialize the slot */
+	memcpy(dst, src, len);
+
+	/* flush caches (dcache/icache) */
+	flush_uprobe_xol_access(page, vaddr, dst, len);
+
+	preempt_enable();
+
+	kunmap_atomic(xol_page_kaddr);
+}
+
+unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
+}
+
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
+		unsigned long addr)
+{
+	probe_opcode_t insn;
+
+	insn = *(probe_opcode_t *)(&auprobe->insn[0]);
+
+	switch (arm_probe_decode_insn(insn, &auprobe->ainsn)) {
+	case INSN_REJECTED:
+		return -EINVAL;
+
+	case INSN_GOOD_NO_SLOT:
+		auprobe->simulate = true;
+		if (auprobe->ainsn.prepare)
+			auprobe->ainsn.prepare(insn, &auprobe->ainsn);
+		break;
+
+	case INSN_GOOD:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	/* saved fault code is restored in post_xol */
+	utask->autask.saved_fault_code = current->thread.fault_code;
+
+	/* An invalid fault code between pre/post xol event */
+	current->thread.fault_code = UPROBE_INV_FAULT_CODE;
+
+	/* Save user pc */
+	utask->autask.saved_user_pc = task_pt_regs(current)->user_regs.pc;
+
+	/* Instruction point to execute ol */
+	instruction_pointer_set(regs, utask->xol_vaddr);
+
+	add_ss_context(utask);
+
+	user_enable_single_step(current);
+
+	return 0;
+}
+
+int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	WARN_ON_ONCE(current->thread.fault_code != UPROBE_INV_FAULT_CODE);
+
+	/* restore fault code */
+	current->thread.fault_code = utask->autask.saved_fault_code;
+
+	/* restore user pc */
+	task_pt_regs(current)->user_regs.pc = utask->autask.saved_user_pc;
+
+	/* Instruction point to execute next to breakpoint address */
+	instruction_pointer_set(regs, utask->vaddr + 4);
+
+	del_ss_context(utask);
+
+	user_disable_single_step(current);
+
+	return 0;
+}
+bool arch_uprobe_xol_was_trapped(struct task_struct *t)
+{
+	/*
+	 * Between arch_uprobe_pre_xol and arch_uprobe_post_xol, if an xol
+	 * insn itself is trapped, then detect the case with the help of
+	 * invalid fault code which is being set in arch_uprobe_pre_xol and
+	 * restored in arch_uprobe_post_xol.
+	 */
+	if (t->thread.fault_code != UPROBE_INV_FAULT_CODE)
+		return true;
+
+	return false;
+}
+
+bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	probe_opcode_t insn;
+	unsigned long addr;
+
+	if (!auprobe->simulate)
+		return false;
+
+	insn = *(probe_opcode_t *)(&auprobe->insn[0]);
+	addr = instruction_pointer(regs);
+
+	if (auprobe->ainsn.handler)
+		auprobe->ainsn.handler(insn, addr, regs);
+
+	return true;
+}
+
+void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	current->thread.fault_code = utask->autask.saved_fault_code;
+	/*
+	 * Task has received a fatal signal, so reset back to probbed
+	 * address.
+	 */
+	instruction_pointer_set(regs, utask->vaddr);
+
+	user_disable_single_step(current);
+}
+
+unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr,
+				  struct pt_regs *regs)
+{
+	unsigned long orig_ret_vaddr;
+
+	orig_ret_vaddr = procedure_link_pointer(regs);
+	/* Replace the return addr with trampoline addr */
+	procedure_link_pointer(regs) = trampoline_vaddr;
+	return orig_ret_vaddr;
+}
+
+static int uprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	uprobe_pre_sstep_notifier(regs);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static int uprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
+{
+	unsigned long flags;
+
+	if (!find_ss_context(regs->pc - 4))
+		return DBG_HOOK_ERROR;
+
+	local_irq_save(flags);
+	uprobe_post_sstep_notifier(regs);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+/* uprobe breakpoint handler hook */
+static struct break_hook uprobes_break_hook = {
+	.esr_mask = BRK64_ESR_MASK,
+	.esr_val = BRK64_ESR_UPROBES,
+	.fn = uprobe_breakpoint_handler,
+};
+
+/* uprobe single step handler hook */
+static struct step_hook uprobes_step_hook = {
+	.fn = uprobe_single_step_handler,
+};
+
+static int __init arch_init_uprobes(void)
+{
+	register_break_hook(&uprobes_break_hook);
+	register_step_hook(&uprobes_step_hook);
+
+	return 0;
+}
+
+device_initcall(arch_init_uprobes);
diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
index 9a4dd6f39cfb..04fe6671907e 100644
--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -55,6 +55,12 @@ static void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 		__flush_ptrace_access(page, uaddr, kaddr, len);
 }
 
+void flush_uprobe_xol_access(struct page *page, unsigned long uaddr,
+		void *kaddr, unsigned long len)
+{
+	__flush_ptrace_access(page, uaddr, kaddr, len);
+}
+
 /*
  * Copy user data from/to a page which is mapped into a different processes
  * address space.  Really, we want to allow our "user space" model to handle
-- 
2.1.0

