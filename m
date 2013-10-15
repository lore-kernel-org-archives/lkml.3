Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab3JOVGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:06:37 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52091 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933792Ab3JOVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:50 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/13] ARM: add uprobes support
Date: Tue, 15 Oct 2013 17:04:27 -0400
Message-Id: <1381871068-27660-13-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Using Rabin Vincent's ARM uprobes patches as a base, enable uprobes
support on ARM.

Caveats:

 - Thumb is not supported
 - XOL abort/trap handling is not implemented

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/Kconfig                   |   4 +
 arch/arm/include/asm/ptrace.h      |   6 +
 arch/arm/include/asm/thread_info.h |   5 +-
 arch/arm/include/asm/uprobes.h     |  34 ++++++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/kprobes-common.c   |   2 +-
 arch/arm/kernel/kprobes.h          |   2 +-
 arch/arm/kernel/signal.c           |   4 +
 arch/arm/kernel/uprobes-arm.c      | 220 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/uprobes.c          | 201 +++++++++++++++++++++++++++++++++
 arch/arm/kernel/uprobes.h          |  25 +++++
 arch/powerpc/include/asm/uprobes.h |   1 -
 include/linux/uprobes.h            |   3 +
 13 files changed, 504 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/include/asm/uprobes.h
 create mode 100644 arch/arm/kernel/uprobes-arm.c
 create mode 100644 arch/arm/kernel/uprobes.c
 create mode 100644 arch/arm/kernel/uprobes.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..5b2cc2b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -198,6 +198,10 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
        def_bool y
 
+config ARCH_SUPPORTS_UPROBES
+	depends on KPROBES
+	def_bool y
+
 config ARCH_HAS_DMA_SET_COHERENT_MASK
 	bool
 
diff --git a/arch/arm/include/asm/ptrace.h b/arch/arm/include/asm/ptrace.h
index 04c99f3..ee688b0a 100644
--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -80,6 +80,12 @@ static inline long regs_return_value(struct pt_regs *regs)
 
 #define instruction_pointer(regs)	(regs)->ARM_pc
 
+static inline void instruction_pointer_set(struct pt_regs *regs,
+					   unsigned long val)
+{
+	instruction_pointer(regs) = val;
+}
+
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
 #else
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index df5e13d..2aa12e8 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -159,6 +159,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+#define TIF_UPROBE		7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_SYSCALL_AUDIT	9
 #define TIF_SYSCALL_TRACEPOINT	10
@@ -171,6 +172,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
@@ -184,7 +186,8 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 /*
  * Change these and you break ASM code in entry-common.S
  */
-#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_RESUME)
+#define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
+				 _TIF_NOTIFY_RESUME | _TIF_UPROBE)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_ARM_THREAD_INFO_H */
diff --git a/arch/arm/include/asm/uprobes.h b/arch/arm/include/asm/uprobes.h
new file mode 100644
index 0000000..fa4b81e
--- /dev/null
+++ b/arch/arm/include/asm/uprobes.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_UPROBES_H
+#define _ASM_UPROBES_H
+
+#include <asm/probes.h>
+
+typedef u32 uprobe_opcode_t;
+
+#define MAX_UINSN_BYTES		4
+#define UPROBE_XOL_SLOT_BYTES	64
+
+#define UPROBE_SWBP_INSN	0x07f001f9
+#define UPROBE_SS_INSN		0x07f001fa
+#define UPROBE_SWBP_INSN_SIZE	4
+
+struct arch_uprobe_task {
+	u32 backup;
+};
+
+struct arch_uprobe {
+	u8 insn[MAX_UINSN_BYTES];
+	uprobe_opcode_t modinsn;
+	uprobe_opcode_t bpinsn;
+	bool simulate;
+	u32 pcreg;
+	void (*prehandler)(struct arch_uprobe *auprobe,
+			   struct arch_uprobe_task *autask,
+			   struct pt_regs *regs);
+	void (*posthandler)(struct arch_uprobe *auprobe,
+			    struct arch_uprobe_task *autask,
+			    struct pt_regs *regs);
+	struct arch_specific_insn asi;
+};
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 2fe6139..f84eb26 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_UPROBES)		+= probes.o probes-arm.o uprobes.o uprobes-arm.o
 obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o
 ifdef CONFIG_THUMB2_KERNEL
 obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 1093f5a..948e025 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -127,7 +127,7 @@ emulate_ldm_r3_15(probes_opcode_t opcode, probes_opcode_t *addr,
 
 enum probes_insn __kprobes
 kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *h)
+		struct decode_header *h)
 {
 	probes_insn_handler_t *handler = 0;
 	unsigned reglist = insn & 0xffff;
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index c13f3b1..0c7a071 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -29,7 +29,7 @@
 
 enum probes_insn __kprobes
 kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *h);
+		struct decode_header *h);
 
 typedef enum probes_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
 			struct arch_specific_insn *,
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index ab33042..5bc71c6 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -13,6 +13,7 @@
 #include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
+#include <linux/uprobes.h>
 
 #include <asm/elf.h>
 #include <asm/cacheflush.h>
@@ -606,6 +607,9 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
 					return restart;
 				}
 				syscall = 0;
+			} else if (thread_flags & _TIF_UPROBE) {
+				clear_thread_flag(TIF_UPROBE);
+				uprobe_notify_resume(regs);
 			} else {
 				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
new file mode 100644
index 0000000..1b9ace0
--- /dev/null
+++ b/arch/arm/kernel/uprobes-arm.c
@@ -0,0 +1,220 @@
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/uprobes.h>
+#include <linux/module.h>
+
+#include "probes.h"
+#include "probes-arm.h"
+#include "uprobes.h"
+
+static int uprobes_substitute_pc(probes_opcode_t *pinsn, u32 oregs)
+{
+	probes_opcode_t insn = *pinsn;
+	probes_opcode_t temp;
+	probes_opcode_t mask;
+	int freereg;
+	u32 free = 0xffff;
+	u32 regs;
+
+	for (regs = oregs; regs; regs >>= 4, insn >>= 4) {
+		if ((regs & 0xf) == REG_TYPE_NONE)
+			continue;
+
+		free &= ~(1 << (insn & 0xf));
+	}
+
+	/* No PC, no problem */
+	if (free & (1 << 15))
+		return 15;
+
+	if (!free)
+		return -1;
+
+	/*
+	 * fls instead of ffs ensures that for "ldrd r0, r1, [pc]" we would
+	 * pick LR instead of R1.
+	 */
+	freereg = free = fls(free) - 1;
+
+	temp = *pinsn;
+	insn = *pinsn;
+	regs = oregs;
+	mask = 0xf;
+
+	for (; regs; regs >>= 4, mask <<= 4, free <<= 4, temp >>= 4) {
+		if ((regs & 0xf) == REG_TYPE_NONE)
+			continue;
+
+		if ((temp & 0xf) != 15)
+			continue;
+
+		insn &= ~mask;
+		insn |= free & mask;
+	}
+
+	*pinsn = insn;
+	return freereg;
+}
+
+static void uprobe_set_pc(struct arch_uprobe *auprobe,
+			  struct arch_uprobe_task *autask,
+			  struct pt_regs *regs)
+{
+	u32 pcreg = auprobe->pcreg;
+
+	autask->backup = regs->uregs[pcreg];
+	regs->uregs[pcreg] = regs->ARM_pc + 8;
+}
+
+static void uprobe_unset_pc(struct arch_uprobe *auprobe,
+			    struct arch_uprobe_task *autask,
+			    struct pt_regs *regs)
+{
+	/* PC will be taken care of by common code */
+	regs->uregs[auprobe->pcreg] = autask->backup;
+}
+
+static void uprobe_aluwrite_pc(struct arch_uprobe *auprobe,
+			       struct arch_uprobe_task *autask,
+			       struct pt_regs *regs)
+{
+	u32 pcreg = auprobe->pcreg;
+
+	alu_write_pc(regs->uregs[pcreg], regs);
+	regs->uregs[pcreg] = autask->backup;
+}
+
+static void uprobe_write_pc(struct arch_uprobe *auprobe,
+			    struct arch_uprobe_task *autask,
+			    struct pt_regs *regs)
+{
+	u32 pcreg = auprobe->pcreg;
+
+	load_write_pc(regs->uregs[pcreg], regs);
+	regs->uregs[pcreg] = autask->backup;
+}
+
+enum probes_insn
+decode_pc_ro(probes_opcode_t insn, struct arch_specific_insn *asi, struct decode_header *d)
+{
+	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
+						   asi);
+	struct decode_emulate *decode = (struct decode_emulate *) d;
+	u32 regs = decode->header.type_regs.bits >> DECODE_TYPE_BITS;
+	int reg;
+
+	reg = uprobes_substitute_pc(&auprobe->modinsn, regs);
+	if (reg == 15)
+		return INSN_GOOD;
+
+	if (reg == -1)
+		return INSN_REJECTED;
+
+	auprobe->pcreg = reg;
+	auprobe->prehandler = uprobe_set_pc;
+	auprobe->posthandler = uprobe_unset_pc;
+
+	return INSN_GOOD;
+}
+
+enum probes_insn
+decode_wb_pc(probes_opcode_t insn, struct arch_specific_insn *asi,
+	     struct decode_header *d, bool alu)
+{
+	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
+						   asi);
+	enum probes_insn ret = decode_pc_ro(insn, asi, d);
+
+	if (((insn >> 12) & 0xf) == 15)
+		auprobe->posthandler = alu ? uprobe_aluwrite_pc
+					   : uprobe_write_pc;
+
+	return ret;
+}
+
+enum probes_insn
+decode_rd12rn16rm0rs8_rwflags(probes_opcode_t insn,
+			      struct arch_specific_insn *asi, struct decode_header *d)
+{
+	return decode_wb_pc(insn, asi, d, true);
+}
+
+enum probes_insn
+decode_ldr(probes_opcode_t insn, struct arch_specific_insn *asi, struct decode_header *d)
+{
+	return decode_wb_pc(insn, asi, d, false);
+}
+
+enum probes_insn
+uprobe_decode_ldmstm(probes_opcode_t insn,
+		     struct arch_specific_insn *asi, struct decode_header *d)
+{
+	struct arch_uprobe *auprobe = container_of(asi, struct arch_uprobe,
+						   asi);
+	unsigned reglist = insn & 0xffff;
+	int rn = (insn >> 16) & 0xf;
+	int lbit = insn & (1 << 20);
+	unsigned used = reglist | (1 << rn);
+
+	if (rn == 15)
+		return INSN_REJECTED;
+
+	if (!(used & (1 << 15)))
+		return INSN_GOOD;
+
+	if (used & (1 << 14))
+		return INSN_REJECTED;
+
+	/* Use LR instead of PC */
+	insn ^= 0xc000;
+
+	auprobe->pcreg = 14;
+	auprobe->modinsn = insn;
+
+	auprobe->prehandler = uprobe_set_pc;
+	if (lbit)
+		auprobe->posthandler = uprobe_write_pc;
+	else
+		auprobe->posthandler = uprobe_unset_pc;
+
+	return INSN_GOOD;
+}
+
+const union decode_item uprobes_probes_actions[] = {
+	[PROBES_EMULATE_NONE] {.handler = probes_simulate_nop},
+	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
+	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
+	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
+	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
+	[PROBES_MRS] = {.handler = simulate_mrs},
+	[PROBES_BRANCH_REG] = {.handler = simulate_blx2bx},
+	[PROBES_CLZ] = {.handler = probes_simulate_nop},
+	[PROBES_SATURATING_ARITHMETIC] = {.handler = probes_simulate_nop},
+	[PROBES_MUL1] = {.handler = probes_simulate_nop},
+	[PROBES_MUL2] = {.handler = probes_simulate_nop},
+	[PROBES_SWP] = {.handler = probes_simulate_nop},
+	[PROBES_LDRSTRD] = {.decoder = decode_pc_ro},
+	[PROBES_LOAD_EXTRA] = {.decoder = decode_pc_ro},
+	[PROBES_LOAD] = {.decoder = decode_ldr},
+	[PROBES_STORE_EXTRA] = {.decoder = decode_pc_ro},
+	[PROBES_STORE] = {.decoder = decode_pc_ro},
+	[PROBES_MOV_IP_SP] = {.handler = simulate_mov_ipsp},
+	[PROBES_DATA_PROCESSING_REG] = {
+		.decoder = decode_rd12rn16rm0rs8_rwflags},
+	[PROBES_DATA_PROCESSING_IMM] = {
+		.decoder = decode_rd12rn16rm0rs8_rwflags},
+	[PROBES_MOV_HALFWORD] = {.handler = probes_simulate_nop},
+	[PROBES_SEV] = {.handler = probes_simulate_nop},
+	[PROBES_WFE] = {.handler = probes_simulate_nop},
+	[PROBES_SATURATE] = {.handler = probes_simulate_nop},
+	[PROBES_REV] = {.handler = probes_simulate_nop},
+	[PROBES_MMI] = {.handler = probes_simulate_nop},
+	[PROBES_PACK] = {.handler = probes_simulate_nop},
+	[PROBES_EXTEND] = {.handler = probes_simulate_nop},
+	[PROBES_EXTEND_ADD] = {.handler = probes_simulate_nop},
+	[PROBES_MUL_ADD_LONG] = {.handler = probes_simulate_nop},
+	[PROBES_MUL_ADD] = {.handler = probes_simulate_nop},
+	[PROBES_BITFIELD] = {.handler = probes_simulate_nop},
+	[PROBES_BRANCH] = {.handler = simulate_bbl},
+	[PROBES_LDMSTM] = {.decoder = uprobe_decode_ldmstm}
+};
diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
new file mode 100644
index 0000000..48e13d3
--- /dev/null
+++ b/arch/arm/kernel/uprobes.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (C) 2012 Rabin Vincent <rabin at rab.in>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/uprobes.h>
+#include <linux/notifier.h>
+
+#include <asm/opcodes.h>
+#include <asm/traps.h>
+
+#include "probes.h"
+#include "probes-arm.h"
+#include "uprobes.h"
+
+bool is_swbp_insn(uprobe_opcode_t *insn)
+{
+	return (__mem_to_opcode_arm(*insn) & 0x0fffffff) == UPROBE_SWBP_INSN;
+}
+
+bool arch_uprobe_ignore(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	if (!auprobe->asi.insn_check_cc(regs->ARM_cpsr)) {
+		regs->ARM_pc += 4;
+		return true;
+	}
+
+	return false;
+}
+
+bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	void *addr;
+	probes_opcode_t opcode;
+
+	if (!auprobe->simulate)
+		return false;
+
+	addr = (void *) regs->ARM_pc;
+	opcode = __mem_to_opcode_arm(*(unsigned int *) auprobe->insn);
+
+	auprobe->asi.insn_singlestep(opcode, addr, &auprobe->asi, regs);
+
+	return true;
+}
+
+unsigned long
+arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr,
+				  struct pt_regs *regs)
+{
+	regs->ARM_pc = trampoline_vaddr;
+	return trampoline_vaddr;
+}
+
+int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
+			     unsigned long addr)
+{
+	unsigned int insn;
+	unsigned int bpinsn;
+	enum probes_insn ret;
+
+	/* Thumb not yet support */
+	if (addr & 0x3)
+		return -EINVAL;
+
+	insn = __mem_to_opcode_arm(*(unsigned int *)auprobe->insn);
+	auprobe->modinsn = insn;
+
+	ret = arm_probes_decode_insn(insn, &auprobe->asi, true,
+				     uprobes_probes_actions);
+	switch (ret) {
+	case INSN_REJECTED:
+		return -EINVAL;
+
+	case INSN_GOOD_NO_SLOT:
+		auprobe->simulate = true;
+		break;
+
+	case INSN_GOOD:
+	default:
+		break;
+	}
+
+	bpinsn = UPROBE_SWBP_INSN;
+	if (insn >= 0xe0000000)
+		bpinsn |= 0xe0000000;  /* Unconditional instruction */
+	else
+		bpinsn |= insn & 0xf0000000;  /* Copy condition from insn */
+
+	auprobe->bpinsn = bpinsn;
+
+	return 0;
+}
+
+void arch_uprobe_write_opcode(struct arch_uprobe *auprobe, void *vaddr,
+			      uprobe_opcode_t opcode)
+{
+	unsigned long *addr = vaddr;
+
+	if (opcode == UPROBE_SWBP_INSN)
+		opcode = __opcode_to_mem_arm(auprobe->bpinsn);
+
+	*addr = opcode;
+}
+
+void arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr)
+{
+	unsigned long *addr = vaddr;
+
+	addr[0] = __opcode_to_mem_arm(auprobe->modinsn);
+	addr[1] = __opcode_to_mem_arm(0xe0000000 | UPROBE_SS_INSN);
+}
+
+int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	if (auprobe->prehandler)
+		auprobe->prehandler(auprobe, &utask->autask, regs);
+
+	regs->ARM_pc = utask->xol_vaddr;
+
+	return 0;
+}
+
+int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	struct uprobe_task *utask = current->utask;
+
+	regs->ARM_pc = utask->vaddr + 4;
+
+	if (auprobe->posthandler)
+		auprobe->posthandler(auprobe, &utask->autask, regs);
+
+	return 0;
+}
+
+bool arch_uprobe_xol_was_trapped(struct task_struct *t)
+{
+	/* TODO: implement */
+	return false;
+}
+
+void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
+{
+	/* TODO: implement */
+}
+
+int arch_uprobe_exception_notify(struct notifier_block *self,
+				 unsigned long val, void *data)
+{
+	return NOTIFY_DONE;
+}
+
+static int uprobe_trap_handler(struct pt_regs *regs, unsigned int instr)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if ((instr & 0x0fffffff) == UPROBE_SWBP_INSN)
+		uprobe_pre_sstep_notifier(regs);
+	else
+		uprobe_post_sstep_notifier(regs);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
+{
+	return instruction_pointer(regs);
+}
+
+static struct undef_hook uprobes_arm_break_hook = {
+	.instr_mask	= 0x0fffffff,
+	.instr_val	= UPROBE_SWBP_INSN,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= USR_MODE,
+	.fn		= uprobe_trap_handler,
+};
+
+static struct undef_hook uprobes_arm_ss_hook = {
+	.instr_mask	= 0x0fffffff,
+	.instr_val	= UPROBE_SS_INSN,
+	.cpsr_mask	= MODE_MASK,
+	.cpsr_val	= USR_MODE,
+	.fn		= uprobe_trap_handler,
+};
+
+int arch_uprobes_init(void)
+{
+	register_undef_hook(&uprobes_arm_break_hook);
+	register_undef_hook(&uprobes_arm_ss_hook);
+
+	return 0;
+}
diff --git a/arch/arm/kernel/uprobes.h b/arch/arm/kernel/uprobes.h
new file mode 100644
index 0000000..2850e793
--- /dev/null
+++ b/arch/arm/kernel/uprobes.h
@@ -0,0 +1,25 @@
+#ifndef __ARM_KERNEL_UPROBES_H
+#define __ARM_KERNEL_UPROBES_H
+
+enum probes_insn uprobe_decode_ldmstm(probes_opcode_t insn,
+				      struct arch_specific_insn *asi,
+				      struct decode_header *d);
+
+enum probes_insn decode_ldr(probes_opcode_t insn,
+			    struct arch_specific_insn *asi,
+			    struct decode_header *d);
+
+enum probes_insn
+decode_rd12rn16rm0rs8_rwflags(probes_opcode_t insn,
+			      struct arch_specific_insn *asi, struct decode_header *d);
+
+enum probes_insn
+decode_wb_pc(probes_opcode_t insn, struct arch_specific_insn *asi,
+	     struct decode_header *d, bool alu);
+
+enum probes_insn
+decode_pc_ro(probes_opcode_t insn, struct arch_specific_insn *asi, struct decode_header *d);
+
+extern const union decode_item uprobes_probes_actions[];
+
+#endif
diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
index 2301602..b532060 100644
--- a/arch/powerpc/include/asm/uprobes.h
+++ b/arch/powerpc/include/asm/uprobes.h
@@ -51,5 +51,4 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
 extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
 extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 34375da..2d30820 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -139,6 +139,9 @@ extern int __weak arch_uprobes_init(void);
 extern void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe,
 					    void *vaddr,
 					    uprobe_opcode_t opcode);
+extern
+unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr,
+						       struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
-- 
1.8.1.2

