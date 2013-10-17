Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3JQLUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:20:13 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39269 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:19:06 -0400
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, dsaxena@linaro.org,
        jiang.liu@huawei.com, Vijaya.Kumar@caviumnetworks.com,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH RFC 3/6] arm64: Kprobes instruction simulation support
Date: Thu, 17 Oct 2013 16:47:48 +0530
Message-Id: <1382008671-4515-4-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for AArch64 instruction simulation in kprobes.

Kprobes need simulation of instructions that cannot be stepped
right-away from different memory location. i.e. those instructions
that uses PC-relative addressing. In simulation, the behaviour
of the instruction is implemented using copy of pt_regs.

Following instruction catagories are simulated:
 - All branching instructions(conditional, register, and immediate)
 - Literal access instructions(load-literal, adr/adrp)

conditional execution are limited to branching instructions in
ARM v8. If conditions at PSTATE does not match the condition fields
of opcode, the instruction is effectively NOP. Kprobes consider
this case as 'miss'.

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
---
 arch/arm64/kernel/Makefile        |   3 +-
 arch/arm64/kernel/condn-helpers.c | 120 +++++++++++++++++++++++++
 arch/arm64/kernel/kprobes-arm64.c | 120 +++++++++++++++++++++++--
 arch/arm64/kernel/kprobes-arm64.h |   2 +
 arch/arm64/kernel/kprobes.c       |  31 ++++++-
 arch/arm64/kernel/simulate-insn.c | 184 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/simulate-insn.h |  33 +++++++
 7 files changed, 480 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm64/kernel/condn-helpers.c
 create mode 100644 arch/arm64/kernel/simulate-insn.c
 create mode 100644 arch/arm64/kernel/simulate-insn.h

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 12ef8d2..b000a51 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -19,7 +19,8 @@ arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
-arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o
+arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o		\
+					   simulate-insn.o condn-helpers.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/condn-helpers.c b/arch/arm64/kernel/condn-helpers.c
new file mode 100644
index 0000000..7abc7ec
--- /dev/null
+++ b/arch/arm64/kernel/condn-helpers.c
@@ -0,0 +1,120 @@
+/*
+ * arch/arm64/kernel/condn-helpers.c
+ *
+ * Copyright (C) 2013 Linaro Limited
+ *
+ * Copied from: arch/arm/kernel/kprobes-common.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Description:
+ *
+ *  AArch64 and AArch32 shares same conditional(CNZV) flags encoding.
+ *  This file implements conditional check helpers compatible with
+ *  both AArch64 and AArch32 modes. Uprobes on v8 can handle both 32-bit
+ *  & 64-bit user-space instructions, so we abstract the common functions
+ *  in this file. While AArch64 and AArch32 specific instruction handling
+ *  are implemented in seperate files, this file contains common bits.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/probes.h>
+
+static unsigned long __kprobes __check_eq(unsigned long pstate)
+{
+	return pstate & PSR_Z_BIT;
+}
+
+static unsigned long __kprobes __check_ne(unsigned long pstate)
+{
+	return (~pstate) & PSR_Z_BIT;
+}
+
+static unsigned long __kprobes __check_cs(unsigned long pstate)
+{
+	return pstate & PSR_C_BIT;
+}
+
+static unsigned long __kprobes __check_cc(unsigned long pstate)
+{
+	return (~pstate) & PSR_C_BIT;
+}
+
+static unsigned long __kprobes __check_mi(unsigned long pstate)
+{
+	return pstate & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_pl(unsigned long pstate)
+{
+	return (~pstate) & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_vs(unsigned long pstate)
+{
+	return pstate & PSR_V_BIT;
+}
+
+static unsigned long __kprobes __check_vc(unsigned long pstate)
+{
+	return (~pstate) & PSR_V_BIT;
+}
+
+static unsigned long __kprobes __check_hi(unsigned long pstate)
+{
+	pstate &= ~(pstate >> 1);	/* PSR_C_BIT &= ~PSR_Z_BIT */
+	return pstate & PSR_C_BIT;
+}
+
+static unsigned long __kprobes __check_ls(unsigned long pstate)
+{
+	pstate &= ~(pstate >> 1);	/* PSR_C_BIT &= ~PSR_Z_BIT */
+	return (~pstate) & PSR_C_BIT;
+}
+
+static unsigned long __kprobes __check_ge(unsigned long pstate)
+{
+	pstate ^= (pstate << 3);	/* PSR_N_BIT ^= PSR_V_BIT */
+	return (~pstate) & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_lt(unsigned long pstate)
+{
+	pstate ^= (pstate << 3);	/* PSR_N_BIT ^= PSR_V_BIT */
+	return pstate & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_gt(unsigned long pstate)
+{
+	/*PSR_N_BIT ^= PSR_V_BIT */
+	unsigned long temp = pstate ^ (pstate << 3);
+	temp |= (pstate << 1);	/*PSR_N_BIT |= PSR_Z_BIT */
+	return (~temp) & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_le(unsigned long pstate)
+{
+	/*PSR_N_BIT ^= PSR_V_BIT */
+	unsigned long temp = pstate ^ (pstate << 3);
+	temp |= (pstate << 1);	/*PSR_N_BIT |= PSR_Z_BIT */
+	return temp & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_al(unsigned long pstate)
+{
+	return true;
+}
+
+kprobes_pstate_check_t * const kprobe_condition_checks[16] = {
+	&__check_eq, &__check_ne, &__check_cs, &__check_cc,
+	&__check_mi, &__check_pl, &__check_vs, &__check_vc,
+	&__check_hi, &__check_ls, &__check_ge, &__check_lt,
+	&__check_gt, &__check_le, &__check_al, &__check_al
+};
diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c
index 30d1c14..c690be3 100644
--- a/arch/arm64/kernel/kprobes-arm64.c
+++ b/arch/arm64/kernel/kprobes-arm64.c
@@ -20,6 +20,101 @@
 
 #include "probes-decode.h"
 #include "kprobes-arm64.h"
+#include "simulate-insn.h"
+
+/*
+ * condition check functions for kprobes simulation
+ */
+static unsigned long __kprobes
+__check_pstate(struct kprobe *p, struct pt_regs *regs)
+{
+	struct arch_specific_insn *asi = &p->ainsn;
+	unsigned long pstate = regs->pstate & 0xffffffff;
+
+	return asi->pstate_cc(pstate);
+}
+
+static unsigned long __kprobes
+__check_cbz(struct kprobe *p, struct pt_regs *regs)
+{
+	return check_cbz((u32)p->opcode, regs);
+}
+
+static unsigned long __kprobes
+__check_cbnz(struct kprobe *p, struct pt_regs *regs)
+{
+	return check_cbnz((u32)p->opcode, regs);
+}
+
+static unsigned long __kprobes
+__check_tbz(struct kprobe *p, struct pt_regs *regs)
+{
+	return check_tbz((u32)p->opcode, regs);
+}
+
+static unsigned long __kprobes
+__check_tbnz(struct kprobe *p, struct pt_regs *regs)
+{
+	return check_tbnz((u32)p->opcode, regs);
+}
+
+/*
+ * prepare functions for instruction simulation
+ */
+static void __kprobes
+prepare_none(struct kprobe *p, struct arch_specific_insn *asi)
+{
+}
+
+static void __kprobes
+prepare_bcond(struct kprobe *p, struct arch_specific_insn *asi)
+{
+	kprobe_opcode_t insn = p->opcode;
+
+	asi->check_condn = __check_pstate;
+	asi->pstate_cc = kprobe_condition_checks[insn & 0xf];
+}
+
+static void __kprobes
+prepare_cbz_cbnz(struct kprobe *p, struct arch_specific_insn *asi)
+{
+	kprobe_opcode_t insn = p->opcode;
+
+	asi->check_condn = (insn & (1 << 24)) ? __check_cbnz : __check_cbz;
+}
+
+static void __kprobes
+prepare_tbz_tbnz(struct kprobe *p, struct arch_specific_insn *asi)
+{
+	kprobe_opcode_t insn = p->opcode;
+
+	asi->check_condn = (insn & (1 << 24)) ? __check_tbnz : __check_tbz;
+}
+
+
+/* Load literal (PC-relative) instructions
+ * Encoding:  xx01 1x00 xxxx xxxx xxxx xxxx xxxx xxxx
+ *
+ * opcode[26]: V=0, Load GP registers, simulate them.
+ * Encoding: xx01 1000 xxxx xxxx xxxx xxxx xxxx xxxx
+ *	opcode[31:30]: op = 00, 01 - LDR literal
+ *	opcode[31:30]: op = 10,    - LDRSW literal
+ *
+ * 1.   V=1 -Load FP/AdvSIMD registers
+ *	Encoding: xx01 1100 xxxx xxxx xxxx xxxx xxxx xxxx
+ * 2.   V=0,opc=11 -PRFM(Prefetch literal)
+ *	Encoding: 1101 1000 xxxx xxxx xxxx xxxx xxxx xxxx
+ *	Reject FP/AdvSIMD literal load & PRFM literal.
+ */
+static const struct aarch64_decode_item load_literal_subtable[] = {
+	DECODE_REJECT(0x1C000000, 0x3F000000),
+	DECODE_REJECT(0xD8000000, 0xFF000000),
+	DECODE_LITERAL(0x18000000, 0xBF000000, prepare_none,
+		       simulate_ldr_literal),
+	DECODE_LITERAL(0x98000000, 0xFF000000, prepare_none,
+		       simulate_ldrsw_literal),
+	DECODE_END,
+};
 
 /* AArch64 instruction decode table for kprobes:
  * The instruction will fall into one of the 3 groups:
@@ -43,7 +138,8 @@ static const struct aarch64_decode_item aarch64_decode_table[] = {
 	 * Data processing - PC relative(literal) addressing:
 	 * Encoding: xxx1 0000 xxxx xxxx xxxx xxxx xxxx xxxx
 	 */
-	DECODE_REJECT(0x10000000, 0x1F000000),
+	DECODE_LITERAL(0x10000000, 0x1F000000, prepare_none,
+			simulate_adr_adrp),
 
 	/*
 	 * Data processing - Add/Substract Immediate:
@@ -83,12 +179,16 @@ static const struct aarch64_decode_item aarch64_decode_table[] = {
 	 *  0101 010x xxxx xxxx xxxx xxxx xxxx xxxx (Conditional, immediate)
 	 *  1101 011x xxxx xxxx xxxx xxxx xxxx xxxx (Unconditional,register)
 	 */
-	DECODE_REJECT(0x14000000, 0x7C000000),
-	DECODE_REJECT(0x14000000, 0x7C000000),
-	DECODE_REJECT(0x34000000, 0x7E000000),
-	DECODE_REJECT(0x36000000, 0x7E000000),
-	DECODE_REJECT(0x54000000, 0xFE000000),
-	DECODE_REJECT(0xD6000000, 0xFE000000),
+	DECODE_BRANCH(0x14000000, 0x7C000000, prepare_none,
+			simulate_b_bl),
+	DECODE_BRANCH(0x34000000, 0x7E000000, prepare_cbz_cbnz,
+		      simulate_cbz_cbnz),
+	DECODE_BRANCH(0x36000000, 0x7E000000, prepare_tbz_tbnz,
+		      simulate_tbz_tbnz),
+	DECODE_BRANCH(0x54000000, 0xFE000000, prepare_bcond,
+			simulate_b_cond),
+	DECODE_BRANCH(0xD6000000, 0xFE000000, prepare_none,
+		      simulate_br_blr_ret),
 
 	/* System insn:
 	 * Encoding: 1101 0101 00xx xxxx xxxx xxxx xxxx xxxx
@@ -119,7 +219,7 @@ static const struct aarch64_decode_item aarch64_decode_table[] = {
 	 * Load/Store - PC relative(literal):
 	 * Encoding:  xx01 1x00 xxxx xxxx xxxx xxxx xxxx xxxx
 	 */
-	DECODE_REJECT(0x18000000, 0x3B000000),
+	DECODE_TABLE(0x18000000, 0x3B000000, load_literal_subtable),
 
 	/*
 	 * Load/Store - Register Pair
@@ -188,7 +288,9 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		break;
 
 	case DECODE_TYPE_SIMULATE:
-		ret = INSN_REJECTED;
+		asi->prepare = decode_prepare_fn(tbl[entry]);
+		asi->handler = decode_handler_fn(tbl[entry]);
+		ret = INSN_GOOD_NO_SLOT;
 		break;
 
 	case DECODE_TYPE_TABLE:
diff --git a/arch/arm64/kernel/kprobes-arm64.h b/arch/arm64/kernel/kprobes-arm64.h
index 87e7891..ff8a55f 100644
--- a/arch/arm64/kernel/kprobes-arm64.h
+++ b/arch/arm64/kernel/kprobes-arm64.h
@@ -22,6 +22,8 @@ enum kprobe_insn {
 	INSN_GOOD,
 };
 
+extern kprobes_pstate_check_t * const kprobe_condition_checks[16];
+
 enum kprobe_insn __kprobes
 arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi);
 
diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
index def10b6..1fa8690 100644
--- a/arch/arm64/kernel/kprobes.c
+++ b/arch/arm64/kernel/kprobes.c
@@ -37,6 +37,9 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+static int __kprobes
+post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs);
+
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
 	int i;
@@ -50,6 +53,23 @@ static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 			   (uintptr_t) (p->ainsn.insn) + MAX_INSN_SIZE);
 }
 
+static void __kprobes arch_prepare_simulate(struct kprobe *p)
+{
+	if (p->ainsn.prepare)
+		p->ainsn.prepare(p, &p->ainsn);
+}
+
+static void __kprobes arch_simulate_insn(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (p->ainsn.handler)
+		p->ainsn.handler((u32)p->opcode, (long)p->addr, regs);
+
+	/* single step simulated, now go for post processing */
+	post_kprobe_handler(kcb, regs);
+}
+
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	kprobe_opcode_t insn;
@@ -69,7 +89,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		break;
 
 	case INSN_GOOD_NO_SLOT:	/* insn need simulation */
-		return -EINVAL;
+		p->ainsn.insn = NULL;
 		break;
 
 	case INSN_GOOD:	/* instruction uses slot */
@@ -80,7 +100,10 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	};
 
 	/* prepare the instruction */
-	arch_prepare_ss_slot(p);
+	if (p->ainsn.insn)
+		arch_prepare_ss_slot(p);
+	else
+		arch_prepare_simulate(p);
 
 	return 0;
 }
@@ -199,13 +222,15 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 		 */
 		p->ainsn.restore.addr = instruction_pointer(regs) +
 				sizeof(kprobe_opcode_t);
+
 		p->ainsn.restore.type = RESTORE_PC;
 
 		set_ss_context(kcb, slot);	/* mark pending ss */
 		kernel_enable_single_step(regs);
 		instruction_pointer(regs) = slot;
 	} else	{
-		BUG();
+		/* insn simulation */
+		arch_simulate_insn(p, regs);
 	}
 }
 
diff --git a/arch/arm64/kernel/simulate-insn.c b/arch/arm64/kernel/simulate-insn.c
new file mode 100644
index 0000000..10173cf
--- /dev/null
+++ b/arch/arm64/kernel/simulate-insn.c
@@ -0,0 +1,184 @@
+/*
+ * arch/arm64/kernel/simulate-insn.c
+ *
+ * Copyright (C) 2013 Linaro Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+
+#include "simulate-insn.h"
+
+#define sign_extend(x, signbit)		\
+	((x) | (0 - ((x) & (1 << (signbit)))))
+
+#define bbl_displacement(insn)		\
+	sign_extend(((insn) & 0x3ffffff) << 2, 27)
+
+#define bcond_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0xfffff) << 2, 21)
+
+#define cbz_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0xfffff) << 2, 21)
+
+#define tbz_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0x3fff) << 2, 15)
+
+#define ldr_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0xfffff) << 2, 21)
+
+
+unsigned long __kprobes check_cbz(u32 opcode, struct pt_regs *regs)
+{
+	int xn = opcode & 0x1f;
+
+	return (opcode & (1 << 31)) ?
+	    !(regs->regs[xn]) : !(regs->regs[xn] & 0xffffffff);
+}
+
+unsigned long __kprobes check_cbnz(u32 opcode, struct pt_regs *regs)
+{
+	int xn = opcode & 0x1f;
+
+	return (opcode & (1 << 31)) ?
+	    (regs->regs[xn]) : (regs->regs[xn] & 0xffffffff);
+}
+
+unsigned long __kprobes check_tbz(u32 opcode, struct pt_regs *regs)
+{
+	int xn = opcode & 0x1f;
+	int bit_pos = ((opcode & (1 << 31)) >> 26) | ((opcode >> 19) & 0x1f);
+
+	return ~((regs->regs[xn] >> bit_pos) & 0x1);
+}
+
+unsigned long __kprobes check_tbnz(u32 opcode, struct pt_regs *regs)
+{
+	int xn = opcode & 0x1f;
+	int bit_pos = ((opcode & (1 << 31)) >> 26) | ((opcode >> 19) & 0x1f);
+
+	return (regs->regs[xn] >> bit_pos) & 0x1;
+}
+
+/*
+ * instruction simulate functions
+ */
+void __kprobes simulate_none(u32 opcode, long addr, struct pt_regs *regs)
+{
+}
+
+void __kprobes
+simulate_adr_adrp(u32 opcode, long addr, struct pt_regs *regs)
+{
+	long res, imm, xn;
+
+	xn = opcode & 0x1f;
+	imm = ((opcode >> 3) & 0xffffc) | ((opcode >> 29) & 0x3);
+	res = addr + 8 + sign_extend(imm, 20);
+
+	regs->regs[xn] = opcode & 0x80000000 ? res & 0xfffffffffffff000 : res;
+	instruction_pointer(regs) += 4;
+
+	return;
+}
+
+void __kprobes
+simulate_b_bl(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = bbl_displacement(opcode);
+
+	/* Link register is x30 */
+	if (opcode & (1 << 31))
+		regs->regs[30] = addr + 4;
+
+	instruction_pointer(regs) = addr + disp;
+
+	return;
+}
+
+void __kprobes
+simulate_b_cond(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = bcond_displacement(opcode);
+
+	instruction_pointer(regs) = addr + disp;
+
+	return;
+}
+
+void __kprobes
+simulate_br_blr_ret(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int xn = (opcode >> 5) & 0x1f;
+
+	/* Link register is x30 */
+	if (((opcode >> 21) & 0x3) == 1)
+		regs->regs[30] = addr + 4;
+
+	instruction_pointer(regs) = regs->regs[xn];
+
+	return;
+}
+
+void __kprobes
+simulate_cbz_cbnz(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = cbz_displacement(opcode);
+
+	instruction_pointer(regs) = addr + disp;
+
+	return;
+}
+
+void __kprobes
+simulate_tbz_tbnz(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = tbz_displacement(opcode);
+
+	instruction_pointer(regs) = addr + disp;
+
+	return;
+}
+
+void __kprobes
+simulate_ldr_literal(u32 opcode, long addr, struct pt_regs *regs)
+{
+	u64 *load_addr;
+	int xn = opcode & 0x1f;
+	int disp = ldr_displacement(opcode);
+
+	load_addr = (u64 *) (addr + disp);
+
+	if (opcode & (1 << 30))	/* x0-x31 */
+		regs->regs[xn] = *load_addr;
+	else			/* w0-w31 */
+		*(u32 *) (&regs->regs[xn]) = (*(u32 *) (load_addr));
+
+	return;
+}
+
+void __kprobes
+simulate_ldrsw_literal(u32 opcode, long addr, struct pt_regs *regs)
+{
+	u64 *load_addr;
+	long data;
+	int xn = opcode & 0x1f;
+	int disp = ldr_displacement(opcode);
+
+	load_addr = (u64 *) (addr + disp);
+	data = *load_addr;
+
+	regs->regs[xn] = sign_extend(data, 63);
+
+	return;
+}
diff --git a/arch/arm64/kernel/simulate-insn.h b/arch/arm64/kernel/simulate-insn.h
new file mode 100644
index 0000000..7713bf6
--- /dev/null
+++ b/arch/arm64/kernel/simulate-insn.h
@@ -0,0 +1,33 @@
+/*
+ * arch/arm64/kernel/simulate-insn.h
+ *
+ * Copyright (C) 2013 Linaro Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _ARM_KERNEL_SIMULATE_INSN_H
+#define _ARM_KERNEL_SIMULATE_INSN_H
+
+unsigned long check_cbz(u32 opcode, struct pt_regs *regs);
+unsigned long check_cbnz(u32 opcode, struct pt_regs *regs);
+unsigned long check_tbz(u32 opcode, struct pt_regs *regs);
+unsigned long check_tbnz(u32 opcode, struct pt_regs *regs);
+void simulate_none(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_adr_adrp(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_b_bl(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_b_cond(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_br_blr_ret(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_cbz_cbnz(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_tbz_tbnz(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_ldr_literal(u32 opcode, long addr, struct pt_regs *regs);
+void simulate_ldrsw_literal(u32 opcode, long addr, struct pt_regs *regs);
+
+#endif /* _ARM_KERNEL_SIMULATE_INSN_H */
-- 
1.8.1.2

