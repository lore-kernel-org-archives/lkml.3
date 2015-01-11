Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbbAKEEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:04:47 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61560 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbbAKEDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:03:30 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] arm64: Kprobes instruction simulation support
Date: Sat, 10 Jan 2015 23:03:19 -0500
Message-Id: <1420949002-3726-5-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>

Add support for AArch64 instruction simulation in kprobes.

Kprobes needs simulation of instructions that cannot be stepped
from different memory location, e.g.: those instructions
that uses PC-relative addressing. In simulation, the behaviour
of the instruction is implemented using a copy of pt_regs.

Following instruction catagories are simulated:
 - All branching instructions(conditional, register, and immediate)
 - Literal access instructions(load-literal, adr/adrp)

Conditional execution is limited to branching instructions in
ARM v8. If conditions at PSTATE do not match the condition fields
of opcode, the instruction is effectively NOP. Kprobes considers
this case as 'miss'.
changes since v3:
from David A. Long:
1) Fix incorrect simulate_ldrsw_literal() semantics.
2) Use instruction test functions instead of private parse table.
from Will Cohen:
3) Remove PC adjustments when simulating an instruction.
4) Fix displacement calculations.

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Signed-off-by: William Cohen <wcohen@redhat.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm64/kernel/Makefile               |   4 +-
 arch/arm64/kernel/kprobes-arm64.c        |  96 +++++++++++++++++
 arch/arm64/kernel/kprobes-arm64.h        |   2 +
 arch/arm64/kernel/kprobes.c              |  35 ++++++-
 arch/arm64/kernel/probes-condn-check.c   | 122 ++++++++++++++++++++++
 arch/arm64/kernel/probes-simulate-insn.c | 174 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/probes-simulate-insn.h |  33 ++++++
 7 files changed, 462 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/kernel/probes-condn-check.c
 create mode 100644 arch/arm64/kernel/probes-simulate-insn.c
 create mode 100644 arch/arm64/kernel/probes-simulate-insn.h

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 6ca9fc0..6e4dcde 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -31,7 +31,9 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
-arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o
+arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o		\
+					   probes-simulate-insn.o		\
+					   probes-condn-check.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
 arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c
index a698bd3..531d14a 100644
--- a/arch/arm64/kernel/kprobes-arm64.c
+++ b/arch/arm64/kernel/kprobes-arm64.c
@@ -20,6 +20,76 @@
 #include <asm/insn.h>
 
 #include "kprobes-arm64.h"
+#include "probes-simulate-insn.h"
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
 
 static bool aarch64_insn_is_steppable(u32 insn)
 {
@@ -60,6 +130,32 @@ arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
 	 */
 	if (aarch64_insn_is_steppable(insn))
 		return INSN_GOOD;
+
+	asi->prepare = prepare_none;
+
+	if (aarch64_insn_is_bcond(insn)) {
+		asi->prepare = prepare_bcond;
+		asi->handler = simulate_b_cond;
+	} else if (aarch64_insn_is_cb(insn)) {
+		asi->prepare = prepare_cbz_cbnz;
+		asi->handler = simulate_cbz_cbnz;
+	} else if (aarch64_insn_is_tb(insn)) {
+		asi->prepare = prepare_tbz_tbnz;
+		asi->handler = simulate_tbz_tbnz;
+	} else if (aarch64_insn_is_adr(insn))
+		asi->handler = simulate_adr_adrp;
+	else if (aarch64_insn_is_b_bl(insn))
+		asi->handler = simulate_b_bl;
+	else if (aarch64_insn_is_ldr_lit(insn))
+		asi->handler = simulate_ldr_literal;
+	else if (aarch64_insn_is_ldrsw_lit(insn))
+		asi->handler = simulate_ldrsw_literal;
 	else
+		/*
+		 * Instruction cannot be stepped out-of-line and we don't
+		 * (yet) simulate it.
+		 */
 		return INSN_REJECTED;
+
+	return INSN_GOOD_NO_SLOT;
 }
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
index 65e22d8..31a7894e 100644
--- a/arch/arm64/kernel/kprobes.c
+++ b/arch/arm64/kernel/kprobes.c
@@ -38,6 +38,9 @@
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+static void __kprobes
+post_kprobe_handler(struct kprobe_ctlblk *, struct pt_regs *);
+
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
 	/* prepare insn slot */
@@ -54,6 +57,27 @@ static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 	p->ainsn.restore.type = RESTORE_PC;
 }
 
+static void __kprobes arch_prepare_simulate(struct kprobe *p)
+{
+	if (p->ainsn.prepare)
+		p->ainsn.prepare(p, &p->ainsn);
+
+	/* This instructions is not executed xol. No need to adjust the PC */
+	p->ainsn.restore.addr = 0;
+	p->ainsn.restore.type = NO_RESTORE;
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
@@ -72,7 +96,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		return -EINVAL;
 
 	case INSN_GOOD_NO_SLOT:	/* insn need simulation */
-		return -EINVAL;
+		p->ainsn.insn = NULL;
+		break;
 
 	case INSN_GOOD:	/* instruction uses slot */
 		p->ainsn.insn = get_insn_slot();
@@ -82,7 +107,10 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	};
 
 	/* prepare the instruction */
-	arch_prepare_ss_slot(p);
+	if (p->ainsn.insn)
+		arch_prepare_ss_slot(p);
+	else
+		arch_prepare_simulate(p);
 
 	return 0;
 }
@@ -231,7 +259,8 @@ static void __kprobes setup_singlestep(struct kprobe *p,
 		kernel_enable_single_step(regs);
 		instruction_pointer(regs) = slot;
 	} else	{
-		BUG();
+		/* insn simulation */
+		arch_simulate_insn(p, regs);
 	}
 }
 
diff --git a/arch/arm64/kernel/probes-condn-check.c b/arch/arm64/kernel/probes-condn-check.c
new file mode 100644
index 0000000..e68aa0c
--- /dev/null
+++ b/arch/arm64/kernel/probes-condn-check.c
@@ -0,0 +1,122 @@
+/*
+ * arch/arm64/kernel/probes-condn-check.c
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
+ *  are implemented in separate files, this file contains common bits.
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
+
+	temp |= (pstate << 1);	/*PSR_N_BIT |= PSR_Z_BIT */
+	return (~temp) & PSR_N_BIT;
+}
+
+static unsigned long __kprobes __check_le(unsigned long pstate)
+{
+	/*PSR_N_BIT ^= PSR_V_BIT */
+	unsigned long temp = pstate ^ (pstate << 3);
+
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
diff --git a/arch/arm64/kernel/probes-simulate-insn.c b/arch/arm64/kernel/probes-simulate-insn.c
new file mode 100644
index 0000000..a224c91
--- /dev/null
+++ b/arch/arm64/kernel/probes-simulate-insn.c
@@ -0,0 +1,174 @@
+/*
+ * arch/arm64/kernel/probes-simulate-insn.c
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
+#include "probes-simulate-insn.h"
+
+#define sign_extend(x, signbit)		\
+	((x) | (0 - ((x) & (1 << (signbit)))))
+
+#define bbl_displacement(insn)		\
+	sign_extend(((insn) & 0x3ffffff) << 2, 27)
+
+#define bcond_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0x7ffff) << 2, 21)
+
+#define cbz_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0x7ffff) << 2, 21)
+
+#define tbz_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0x3fff) << 2, 15)
+
+#define ldr_displacement(insn)	\
+	sign_extend(((insn >> 5) & 0x7ffff) << 2, 21)
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
+	long imm, xn, val;
+
+	xn = opcode & 0x1f;
+	imm = ((opcode >> 3) & 0x1ffffc) | ((opcode >> 29) & 0x3);
+	imm = sign_extend(imm, 20);
+	if (opcode & 0x80000000)
+		val = (imm<<12) + (addr & 0xfffffffffffff000);
+	else
+		val = imm + addr;
+
+	regs->regs[xn] = val;
+
+	instruction_pointer(regs) += 4;
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
+}
+
+void __kprobes
+simulate_b_cond(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = bcond_displacement(opcode);
+
+	instruction_pointer(regs) = addr + disp;
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
+}
+
+void __kprobes
+simulate_cbz_cbnz(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = cbz_displacement(opcode);
+
+	instruction_pointer(regs) = addr + disp;
+}
+
+void __kprobes
+simulate_tbz_tbnz(u32 opcode, long addr, struct pt_regs *regs)
+{
+	int disp = tbz_displacement(opcode);
+
+	instruction_pointer(regs) = addr + disp;
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
+	instruction_pointer(regs) += 4;
+}
+
+void __kprobes
+simulate_ldrsw_literal(u32 opcode, long addr, struct pt_regs *regs)
+{
+	s32 *load_addr;
+	int xn = opcode & 0x1f;
+	int disp = ldr_displacement(opcode);
+
+	load_addr = (s32 *) (addr + disp);
+	regs->regs[xn] = *load_addr;
+
+	instruction_pointer(regs) += 4;
+}
diff --git a/arch/arm64/kernel/probes-simulate-insn.h b/arch/arm64/kernel/probes-simulate-insn.h
new file mode 100644
index 0000000..406f5c2
--- /dev/null
+++ b/arch/arm64/kernel/probes-simulate-insn.h
@@ -0,0 +1,33 @@
+/*
+ * arch/arm64/kernel/probes-simulate-insn.h
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
+#ifndef _ARM_KERNEL_PROBES_SIMULATE_INSN_H
+#define _ARM_KERNEL_PROBES_SIMULATE_INSN_H
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
+#endif /* _ARM_KERNEL_PROBES_SIMULATE_INSN_H */
-- 
1.8.1.2

