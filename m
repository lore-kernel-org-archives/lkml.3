Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaJYTBg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:01:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42365 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaJYTBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:01:33 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>, <dave.long@linaro.org>,
        <taras.kondratiuk@linaro.org>, <ben.dooks@codethink.co.uk>,
        <cl@linux.com>, <rabin@rab.in>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH v7 2/2] ARM: kprobes: enable OPTPROBES for ARM 32
Date: Sat, 25 Oct 2014 14:51:05 +0800
Message-ID: <1414219865-35988-3-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1414219865-35988-1-git-send-email-wangnan0@huawei.com>
References: <1414219865-35988-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce kprobeopt for ARM 32.

Limitations:
 - Currently only kernel compiled with ARM ISA is supported.

 - Offset between probe point and optinsn slot must not larger than
   32MiB. Masami Hiramatsu suggests replacing 2 words, it will make
   things complex. Futher patch can make such optimization.

Kprobe opt on ARM is relatively simpler than kprobe opt on x86 because
ARM instruction is always 4 bytes aligned and 4 bytes long. This patch
replace probed instruction by a 'b', branch to trampoline code and then
calls optimized_callback(). optimized_callback() calls opt_pre_handler()
to execute kprobe handler. It also emulate/simulate replaced instruction.

When unregistering kprobe, the deferred manner of unoptimizer may leave
branch instruction before optimizer is called. Different from x86_64,
which only copy the probed insn after optprobe_template_end and
reexecute them, this patch call singlestep to emulate/simulate the insn
directly. Futher patch can optimize this behavior.

v1 -> v2:

 - Improvement: if replaced instruction is conditional, generate a
   conditional branch instruction for it;

 - Introduces RELATIVEJUMP_OPCODES due to ARM kprobe_opcode_t is 4
   bytes;

 - Removes size field in struct arch_optimized_insn;

 - Use arm_gen_branch() to generate branch instruction;

 - Remove all recover logic: ARM doesn't use tail buffer, no need
   recover replaced instructions like x86;

 - Remove incorrect CONFIG_THUMB checking;

 - can_optimize() always returns true if address is well aligned;

 - Improve optimized_callback: using opt_pre_handler();

 - Bugfix: correct range checking code and improve comments;

 - Fix commit message.

v2 -> v3:

 - Rename RELATIVEJUMP_OPCODES to MAX_COPIED_INSNS;

 - Remove unneeded checking:
      arch_check_optimized_kprobe(), can_optimize();

 - Add missing flush_icache_range() in arch_prepare_optimized_kprobe();

 - Remove unneeded 'return;'.

v3 -> v4:

 - Use __mem_to_opcode_arm() to translate copied_insn to ensure it
   works in big endian kernel;

 - Replace 'nop' placeholder in trampoline code template with
   '.long 0' to avoid confusion: reader may regard 'nop' as an
   instruction, but it is value in fact.

v4 -> v5:

 - Don't optimize stack store operations.

 - Introduce prepared field to arch_optimized_insn to indicate whether
   it is prepared. Similar to size field with x86. See v1 -> v2.

v5 -> v6:

 - Dynamically reserve stack according to instruction.

 - Rename: kprobes-opt.c -> kprobes-opt-arm.c.

 - Set op->optinsn.insn after all works are done.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/Kconfig                  |   1 +
 arch/arm/include/asm/kprobes.h    |  26 ++++
 arch/arm/kernel/Makefile          |   3 +-
 arch/arm/kernel/kprobes-opt-arm.c | 285 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 314 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/kernel/kprobes-opt-arm.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..8281cea 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -59,6 +59,7 @@ config ARM
 	select HAVE_MEMBLOCK
 	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
 	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
+	select HAVE_OPTPROBES if (!THUMB2_KERNEL)
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 49fa0df..a05297f 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -51,5 +51,31 @@ int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
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
+	/*
+	 * copy of the original instructions.
+	 * Different from x86, ARM kprobe_opcode_t is u32.
+	 */
+#define MAX_COPIED_INSN	((RELATIVEJUMP_SIZE) / sizeof(kprobe_opcode_t))
+	kprobe_opcode_t copied_insn[MAX_COPIED_INSN];
+	/* detour code buffer */
+	kprobe_opcode_t *insn;
+	/*
+	 *  we always copies one instruction on arm32,
+	 *  size always be 4, so no size field.
+	 */
+};
 
 #endif /* _ARM_KPROBES_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f..2fcd980 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -52,11 +52,12 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_UPROBES)		+= probes.o probes-arm.o uprobes.o uprobes-arm.o
-obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o
+obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o insn.o
 ifdef CONFIG_THUMB2_KERNEL
 obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o
 else
 obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o
+obj-$(CONFIG_OPTPROBES)		+= kprobes-opt-arm.o
 endif
 obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
 test-kprobes-objs		:= kprobes-test.o
diff --git a/arch/arm/kernel/kprobes-opt-arm.c b/arch/arm/kernel/kprobes-opt-arm.c
new file mode 100644
index 0000000..55eb3ea
--- /dev/null
+++ b/arch/arm/kernel/kprobes-opt-arm.c
@@ -0,0 +1,285 @@
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
+/* for arm_gen_branch */
+#include "insn.h"
+/* for patch_text */
+#include "patch.h"
+
+/*
+ * NOTE: the first sub and add instruction will be modified according
+ * to the stack cost of the instruction.
+ */
+asm (
+			".global optprobe_template_entry\n"
+			"optprobe_template_entry:\n"
+			"	sub	sp, sp, #0xff\n"
+			"	stmia	sp, {r0 - r14} \n"
+			"	add	r3, sp, #0xff\n"
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
+			"1:	.long 0\n"
+			".global optprobe_template_call\n"
+			"optprobe_template_call:\n"
+			"2:	.long 0\n"
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
+/*
+ * ARM can always optimize an instruction when using ARM ISA, except
+ * instructions like 'str r0, [sp, r1]' which store to stack and unable
+ * to determine stack space consumption statically.
+ */
+int arch_prepared_optinsn(struct arch_optimized_insn *optinsn)
+{
+	return optinsn->insn != NULL;
+}
+
+/*
+ * In ARM ISA, kprobe opt always replace one instruction (4 bytes
+ * aligned and 4 bytes long). It is impossiable to encounter another
+ * kprobe in the address range. So always return 0.
+ */
+int arch_check_optimized_kprobe(struct optimized_kprobe *op)
+{
+	return 0;
+}
+
+/* Caller must ensure addr & 3 == 0 */
+static int can_optimize(struct optimized_kprobe *op)
+{
+	if (op->kp.ainsn.stack_space < 0)
+		return 0;
+	/*
+	 * 255 is the biggest imm can be used in 'sub r0, r0, #<imm>'.
+	 * Number larger than 255 needs special encoding.
+	 */
+	if (op->kp.ainsn.stack_space > 255 - sizeof(struct pt_regs))
+		return 0;
+	return 1;
+}
+
+/* Free optimized instruction slot */
+static void
+__arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
+{
+	if (op->optinsn.insn) {
+		free_optinsn_slot(op->optinsn.insn, dirty);
+		op->optinsn.insn = NULL;
+	}
+}
+
+extern void kprobe_handler(struct pt_regs *regs);
+
+static void
+optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
+{
+	unsigned long flags;
+	struct kprobe *p = &op->kp;
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	/* Save skipped registers */
+	regs->ARM_pc = (unsigned long)op->kp.addr;
+	regs->ARM_ORIG_r0 = ~0UL;
+
+	local_irq_save(flags);
+
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(&op->kp);
+	} else {
+		__this_cpu_write(current_kprobe, &op->kp);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		opt_pre_handler(&op->kp, regs);
+		__this_cpu_write(current_kprobe, NULL);
+	}
+
+	/* In each case, we must singlestep the replaced instruction. */
+	op->kp.ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
+
+	local_irq_restore(flags);
+}
+
+int arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+{
+	u8 *buf;
+	unsigned long *code;
+	unsigned long rel_chk;
+	unsigned long val;
+	unsigned long stack_protect = sizeof(struct pt_regs);
+
+	if (!can_optimize(op))
+		return -EILSEQ;
+
+	buf = (u8 *)get_optinsn_slot();
+	if (!buf)
+		return -ENOMEM;
+
+	/*
+	 * Verify if the address gap is in 32MiB range, because this uses
+	 * a relative jump.
+	 *
+	 * kprobe opt use a 'b' instruction to branch to optinsn.insn.
+	 * According to ARM manual, branch instruction is:
+	 *
+	 *   31  28 27           24 23             0
+	 *  +------+---+---+---+---+----------------+
+	 *  | cond | 1 | 0 | 1 | 0 |      imm24     |
+	 *  +------+---+---+---+---+----------------+
+	 *
+	 * imm24 is a signed 24 bits integer. The real branch offset is computed
+	 * by: imm32 = SignExtend(imm24:'00', 32);
+	 *
+	 * So the maximum forward branch should be:
+	 *   (0x007fffff << 2) = 0x01fffffc =  0x1fffffc
+	 * The maximum backword branch should be:
+	 *   (0xff800000 << 2) = 0xfe000000 = -0x2000000
+	 *
+	 * We can simply check (rel & 0xfe000003):
+	 *  if rel is positive, (rel & 0xfe000000) shoule be 0
+	 *  if rel is negitive, (rel & 0xfe000000) should be 0xfe000000
+	 *  the last '3' is used for alignment checking.
+	 */
+	rel_chk = (unsigned long)((long)buf -
+			(long)op->kp.addr + 8) & 0xfe000003;
+
+	if ((rel_chk != 0) && (rel_chk != 0xfe000000)) {
+		__arch_remove_optimized_kprobe(op, 0);
+		return -ERANGE;
+	}
+
+	/* Copy arch-dep-instance from template. */
+	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
+
+	/* Adjust buffer according to instruction. */
+	BUG_ON(op->kp.ainsn.stack_space < 0);
+	stack_protect += op->kp.ainsn.stack_space;
+
+	/* Should have been filtered by can_optimize(). */
+	BUG_ON(stack_protect > 255);
+
+	/* Create a 'sub sp, sp, #<stack_protect>' */
+	code = (unsigned long *)(buf);
+	code[0] = __opcode_to_mem_arm(0xe24dd000 | stack_protect);
+	/* Create a 'add r3, sp, #<stack_protect>' */
+	code[2] = __opcode_to_mem_arm(0xe28d3000 | stack_protect);
+
+	/* Set probe information */
+	val = (unsigned long)op;
+	memcpy(buf + TMPL_VAL_IDX, &val, sizeof(val));
+
+	/* Set probe function call */
+	val = (unsigned long)optimized_callback;
+	memcpy(buf + TMPL_CALL_IDX, &val, sizeof(val));
+
+	flush_icache_range((unsigned long)buf,
+			   (unsigned long)buf + TMPL_END_IDX);
+
+	/* Set op->optinsn.insn means prepared */
+	op->optinsn.insn = (kprobe_opcode_t *)buf;
+	return 0;
+}
+
+void arch_optimize_kprobes(struct list_head *oplist)
+{
+	struct optimized_kprobe *op, *tmp;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		unsigned long insn;
+		WARN_ON(kprobe_disabled(&op->kp));
+
+		/*
+		 * Backup instructions which will be replaced
+		 * by jump address
+		 */
+		memcpy(op->optinsn.copied_insn, op->kp.addr,
+				RELATIVEJUMP_SIZE);
+
+		insn = arm_gen_branch((unsigned long)op->kp.addr,
+				(unsigned long)op->optinsn.insn);
+		BUG_ON(insn == 0);
+
+		/*
+		 * Make it a conditional branch if replaced insn
+		 * is consitional
+		 */
+		insn = (__mem_to_opcode_arm(
+			  op->optinsn.copied_insn[0]) & 0xf0000000) |
+			(insn & 0x0fffffff);
+
+		patch_text(op->kp.addr, insn);
+
+		list_del_init(&op->list);
+	}
+}
+
+void arch_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	arch_arm_kprobe(&op->kp);
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
+		(unsigned long)op->kp.addr + RELATIVEJUMP_SIZE > addr);
+}
+
+void arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+{
+	__arch_remove_optimized_kprobe(op, 1);
+}
-- 
1.8.4

