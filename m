Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaHEHoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:44:05 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:56537 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaHEHoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:44:02 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <peifeiyue@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Wang Nan <wangnan0@huawei.com>
Subject: [RFC PATCH] kprobes: arm: enable OPTPROBES for arm 32
Date: Tue, 5 Aug 2014 15:28:17 +0800
Message-ID: <1407223697-74911-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.53E08AD5.00DF,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 8ae366152b675ef64ca022781ccfa7e4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce kprobeopt for ARM 32.

Limitations:
 - Currently only kernel compiled with ARM ISA is supported.

 - offset between probe point and kprobe pre_handler must not larger
    than 64MiB. Masami Hiramatsu suggests replacing 2 words, it will
    make things complex. Futher patch can make such optimization.

I have tested this patch on qemu vexpress a9 platform.

Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
ARM instruction is always 4 bytes aligned. This patch replace probed
instruction by a 'b', branch to trampoline code and then calls
optimized_callback(). optimized_callback() calls kprobe_handler() to
execute kprobe handler. It also emulate/simulate replaced instruction.

When unregistering kprobe, the deferred manner of unoptimizer may leave
branch instruction before optimizer is called. Different from x86_64,
which only copy the probed insn after optprobe_template_end and
reexecute them, this patch call singlestep to emulate/simulate the insn
directly. Futher patch can optimize this behavior.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/arm/Kconfig               |   1 +
 arch/arm/include/asm/kprobes.h |  20 +++
 arch/arm/kernel/Makefile       |   1 +
 arch/arm/kernel/kprobes-opt.c  | 322 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 344 insertions(+)
 create mode 100644 arch/arm/kernel/kprobes-opt.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 290f02ee..2106918 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -57,6 +57,7 @@ config ARM
 	select HAVE_MEMBLOCK
 	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
+	select HAVE_OPTPROBES if (!THUMB2_KERNEL)
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 49fa0df..0f4e5c0 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -51,5 +51,25 @@ int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
 int kprobe_exceptions_notify(struct notifier_block *self,
 			     unsigned long val, void *data);
 
+/* optinsn template addresses */
+extern __visible kprobe_opcode_t optprobe_template_entry;
+extern __visible kprobe_opcode_t optprobe_template_val;
+extern __visible kprobe_opcode_t optprobe_template_call;
+extern __visible kprobe_opcode_t optprobe_template_end;
+
+#define MAX_OPTIMIZED_LENGTH	(4)
+#define MAX_OPTINSN_SIZE				\
+	(((unsigned long)&optprobe_template_end -	\
+	  (unsigned long)&optprobe_template_entry))
+#define RELATIVEJUMP_SIZE	(4)
+
+struct arch_optimized_insn {
+	/* copy of the original instructions */
+	kprobe_opcode_t copied_insn[RELATIVEJUMP_SIZE];
+	/* detour code buffer */
+	kprobe_opcode_t *insn;
+	/* the size of instructions copied to detour code buffer */
+	size_t size;
+};
 
 #endif /* _ARM_KPROBES_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f..918ee34 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -57,6 +57,7 @@ ifdef CONFIG_THUMB2_KERNEL
 obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o
 else
 obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o
+obj-$(CONFIG_OPTPROBES)		+= kprobes-opt.o
 endif
 obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
 test-kprobes-objs		:= kprobes-test.o
diff --git a/arch/arm/kernel/kprobes-opt.c b/arch/arm/kernel/kprobes-opt.c
new file mode 100644
index 0000000..a4aa7ed
--- /dev/null
+++ b/arch/arm/kernel/kprobes-opt.c
@@ -0,0 +1,322 @@
+/*
+ *  Kernel Probes Jump Optimization (Optprobes)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2002, 2004
+ * Copyright (C) Hitachi Ltd., 2012
+ * Copyright (C) Huawei Inc., 2014
+ */
+
+#include <linux/kprobes.h>
+#include <linux/jump_label.h>
+#include <asm/kprobes.h>
+#include <asm/cacheflush.h>
+#include "patch.h"
+
+unsigned long
+__recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
+{
+	struct optimized_kprobe *op;
+	struct kprobe *kp;
+	int i;
+	long offs;
+	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
+		kp = get_kprobe((void *)addr - i);
+		if (!kp || !kprobe_optimized(kp))
+			continue;
+		op = container_of(kp, struct optimized_kprobe, kp);
+		/* If op->list is not empty, op is under optimizing */
+		if (list_empty(&op->list))
+			goto found;
+	}
+
+	return addr;
+
+found:
+	offs = addr - (unsigned long)kp->addr;
+	memcpy(buf, op->optinsn.copied_insn + offs, RELATIVEJUMP_SIZE - offs);
+	return (unsigned long)buf;
+}
+
+static unsigned long
+__recover_probed_insn(kprobe_opcode_t *buf, unsigned long addr)
+{
+	struct kprobe *kp;
+
+	kp = get_kprobe((void *)addr);
+	/* There is no probe, return original address */
+	if (!kp)
+		return addr;
+
+	/*
+	 *  Basically, kp->ainsn.insn has an original instruction.
+	 */
+	memcpy(buf, kp->ainsn.insn, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	return (unsigned long)buf;
+}
+
+/*
+ * Recover the probed instruction at addr for further analysis.
+ * Caller must lock kprobes by kprobe_mutex, or disable preemption
+ * for preventing to release referencing kprobes.
+ */
+unsigned long
+recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
+{
+	unsigned long __addr;
+
+	__addr = __recover_optprobed_insn(buf, addr);
+	if (__addr != addr)
+		return __addr;
+
+	return __recover_probed_insn(buf, addr);
+}
+
+
+/* 
+ * recover kprobed instruction and copy to dest
+ */
+int
+__copy_instruction(u8 *dest, u8 *src)
+{
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	memcpy(dest, (void *)recover_probed_instruction(buf, (unsigned long)src),
+			sizeof(kprobe_opcode_t) * MAX_INSN_SIZE);
+	return (sizeof(kprobe_opcode_t) * MAX_INSN_SIZE);
+}
+
+
+asm (
+			".global optprobe_template_entry\n"
+			"optprobe_template_entry:\n"
+#ifndef CONFIG_THUMB
+			"	sub	sp, sp, #80\n"
+			"	stmia	sp, {r0 - r14} \n"
+			"	add	r3, sp, #80\n"
+			"	str	r3, [sp, #52]\n"
+			"	mrs	r4, cpsr\n"
+			"	str	r4, [sp, #64]\n"
+			"	mov	r1, sp\n"
+			"	ldr	r0, 1f\n"
+			"	ldr	r2, 2f\n"
+			"	blx	r2\n"
+			"	ldr	r1, [sp, #64]\n"
+			"	msr	cpsr_fs, r1\n"
+			"	ldmia	sp, {r0 - r15}\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val:\n"
+			"1:	nop\n"
+			".global optprobe_template_call\n"
+			"optprobe_template_call:\n"
+			"2:	nop\n"
+#else /* CONFIG_THUMB */
+# error optprobe for thumb is not supported.
+#endif
+			".global optprobe_template_end\n"
+			"optprobe_template_end:\n");
+
+#define TMPL_VAL_IDX \
+	((long)&optprobe_template_val - (long)&optprobe_template_entry)
+#define TMPL_CALL_IDX \
+	((long)&optprobe_template_call - (long)&optprobe_template_entry)
+#define TMPL_END_IDX \
+	((long)&optprobe_template_end - (long)&optprobe_template_entry)
+
+int arch_prepared_optinsn(struct arch_optimized_insn *optinsn)
+{
+	return optinsn->size;
+}
+
+int arch_check_optimized_kprobe(struct optimized_kprobe *op)
+{
+	int i;
+	struct kprobe *p;
+
+	for (i = 1; i < op->optinsn.size; i++) {
+		p = get_kprobe(op->kp.addr + i);
+		if (p && !kprobe_disabled(p))
+			return -EEXIST;
+	}
+
+	return 0;
+}
+
+static int can_optimize(unsigned long paddr)
+{
+	unsigned long size = 0, offset = 0;
+
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
+		return 0;
+
+	/* Check there is enough space for a relative jump. */
+	if (size - offset < RELATIVEJUMP_SIZE)
+		return 0;
+
+	return 1;
+}
+
+/* Free optimized instruction slot */
+static
+void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
+{
+	if (op->optinsn.insn) {
+		free_optinsn_slot(op->optinsn.insn, dirty);
+		op->optinsn.insn = NULL;
+		op->optinsn.size = 0;
+	}
+}
+
+extern void kprobe_handler(struct pt_regs *regs);
+
+static void
+optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
+{
+	unsigned long flags;
+
+	regs->ARM_pc = (unsigned long)op->kp.addr;
+	regs->ARM_ORIG_r0 = ~0UL;
+
+
+	local_irq_save(flags);
+	/* 
+	 * This is possible if op is under delayed unoptimizing.
+	 * We need simulate the replaced instruction.
+	 */
+	if (kprobe_disabled(&op->kp)) {
+		struct kprobe *p = &op->kp;
+		op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
+	} else {
+		kprobe_handler(regs);
+	}
+
+	local_irq_restore(flags);
+}
+
+int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+{
+	u8 *buf;
+	long rel;
+	unsigned long val;
+
+	if (!can_optimize((unsigned long)op->kp.addr))
+		return -EILSEQ;
+
+	op->optinsn.insn = get_optinsn_slot();
+	if (!op->optinsn.insn)
+		return -ENOMEM;
+
+	/*
+	 * Verify if the address gap is in 2GB range, because this uses
+	 * a relative jump.
+	 */
+	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
+	if ((abs(rel) > 0x3fffffc) || ((abs(rel) & 3) != 0)) {
+		__arch_remove_optimized_kprobe(op, 0);
+		return -ERANGE;
+	}
+
+	buf = (u8 *)op->optinsn.insn;
+
+	op->optinsn.size = RELATIVEJUMP_SIZE;
+
+	/* Copy arch-dep-instance from template */
+	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
+
+	/* Set probe information */
+	val = (unsigned long)op;
+	memcpy(buf + TMPL_VAL_IDX, &val, sizeof(val));
+
+	/* Set probe function call */
+	val = (unsigned long)optimized_callback;
+	memcpy(buf + TMPL_CALL_IDX, &val, sizeof(val));
+
+	flush_icache_range((unsigned long) buf,
+			   (unsigned long) buf + TMPL_END_IDX +
+			   op->optinsn.size + RELATIVEJUMP_SIZE);
+	return 0;
+}
+
+static inline int
+arm_branch_to_addr(unsigned int *pinst, void *src, void *dest)
+{
+	unsigned int inst = 0xea000000;
+	long offset = (unsigned long)(dest) -
+			((unsigned long)(src) + 8);
+	if ((offset > 0x3fffffc) || (offset < -0x3fffffc)) {
+		printk(KERN_WARNING "Failed to instrument %pS to %pS\n", src, dest);
+		return -EINVAL;
+	}
+
+	inst |= (((unsigned long)offset) >> 2) & (0x00ffffffUL);
+	*pinst = inst;
+	return 0;
+}
+
+void arch_optimize_kprobes(struct list_head *oplist)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		int err;
+		unsigned int insn;
+		WARN_ON(kprobe_disabled(&op->kp));
+
+		/* Backup instructions which will be replaced by jump address */
+		memcpy(op->optinsn.copied_insn, op->kp.addr, RELATIVEJUMP_SIZE);
+
+		err = arm_branch_to_addr(&insn, op->kp.addr, op->optinsn.insn);
+		BUG_ON(err);
+
+		patch_text(op->kp.addr, insn);
+
+		list_del_init(&op->list);
+	}
+	return;
+}
+
+void arch_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	arch_arm_kprobe(&op->kp);
+	return;
+}
+
+/*
+ * Recover original instructions and breakpoints from relative jumps.
+ * Caller must call with locking kprobe_mutex.
+ */
+void arch_unoptimize_kprobes(struct list_head *oplist,
+ 			    struct list_head *done_list)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		arch_unoptimize_kprobe(op);
+		list_move(&op->list, done_list);
+	}
+}
+
+int arch_within_optimized_kprobe(struct optimized_kprobe *op,
+ 				unsigned long addr)
+{
+	return ((unsigned long)op->kp.addr <= addr &&
+		(unsigned long)op->kp.addr + op->optinsn.size > addr);
+}
+
+void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+{
+	__arch_remove_optimized_kprobe(op, 1);
+}
-- 
1.8.4

