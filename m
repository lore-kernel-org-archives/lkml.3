Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbbAKEDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:03:42 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64635 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbbAKED3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:03:29 -0500
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
Subject: [PATCH v4 3/6] arm64: Kprobes with single stepping support
Date: Sat, 10 Jan 2015 23:03:18 -0500
Message-Id: <1420949002-3726-4-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>

Add support for basic kernel probes(kprobes) and jump probes
(jprobes) for ARM64.

Kprobes will utilize software breakpoint and single step debug
exceptions supported on ARM v8.

Software breakpoint is placed at the probe address to trap the
kernel execution into kprobe handler.

ARM v8 supports single stepping to be enabled while exception return
(ERET) with next PC in exception return address (ELR_EL1). The
kprobe handler prepares an executable memory slot for out-of-line
execution with a copy of the original instruction being probed, and
enables single stepping from the instruction slot. With this scheme,
the instruction is executed with the exact same register context
'except PC' that points to instruction slot.

Debug mask(PSTATE.D) is enabled only when single stepping a recursive
kprobe, e.g.: during kprobes reenter so that probed instruction can be
single stepped within the kprobe handler -exception- context.
The recursion depth of kprobe is always 2, i.e. upon probe re-entry,
any further re-entry is prevented by not calling handlers and the case
counted as a missed kprobe).

Single stepping from slot has a drawback on PC-relative accesses
like branching and symbolic literals access as offset from new PC
(slot address) may not be ensured to fit in immediate value of
opcode. Such instructions needs simulation, so reject
probing such instructions.

Instructions generating exceptions or cpu mode change are rejected,
and not allowed to insert probe for these instructions.

Instructions using Exclusive Monitor are rejected too.

System instructions are mostly enabled for stepping, except MSR
immediate that updates "daif" flags in PSTATE, which are not safe
for probing.

Changes since v3:
from David Long:
1) Removed unnecessary addtion of NOP after out-of-line instruction.
2) Replaced table-driven instruction parsing with calls to external
   test functions.
from Steve Capper:
3) Disable local irq while executing out of line instruction.

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Signed-off-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/kprobes.h  |  60 +++++
 arch/arm64/include/asm/probes.h   |  50 ++++
 arch/arm64/include/asm/ptrace.h   |   3 +-
 arch/arm64/kernel/Makefile        |   1 +
 arch/arm64/kernel/kprobes-arm64.c |  65 +++++
 arch/arm64/kernel/kprobes-arm64.h |  28 ++
 arch/arm64/kernel/kprobes.c       | 551 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/kprobes.h       |  30 +++
 arch/arm64/kernel/vmlinux.lds.S   |   1 +
 10 files changed, 789 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kprobes.h
 create mode 100644 arch/arm64/include/asm/probes.h
 create mode 100644 arch/arm64/kernel/kprobes-arm64.c
 create mode 100644 arch/arm64/kernel/kprobes-arm64.h
 create mode 100644 arch/arm64/kernel/kprobes.c
 create mode 100644 arch/arm64/kernel/kprobes.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 12b3fd6..b3f61ba 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -67,6 +67,7 @@ config ARM64
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RCU_TABLE_FREE
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_KPROBES if !XIP_KERNEL
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
new file mode 100644
index 0000000..b35d3b9
--- /dev/null
+++ b/arch/arm64/include/asm/kprobes.h
@@ -0,0 +1,60 @@
+/*
+ * arch/arm64/include/asm/kprobes.h
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
+#ifndef _ARM_KPROBES_H
+#define _ARM_KPROBES_H
+
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/percpu.h>
+
+#define __ARCH_WANT_KPROBES_INSN_SLOT
+#define MAX_INSN_SIZE			1
+#define MAX_STACK_SIZE			128
+
+#define flush_insn_slot(p)		do { } while (0)
+#define kretprobe_blacklist_size	0
+
+#include <asm/probes.h>
+
+struct prev_kprobe {
+	struct kprobe *kp;
+	unsigned int status;
+};
+
+/* Single step context for kprobe */
+struct kprobe_step_ctx {
+#define KPROBES_STEP_NONE	0x0
+#define KPROBES_STEP_PENDING	0x1
+	unsigned long ss_status;
+	unsigned long match_addr;
+};
+
+/* per-cpu kprobe control block */
+struct kprobe_ctlblk {
+	unsigned int kprobe_status;
+	unsigned long saved_irqflag;
+	struct prev_kprobe prev_kprobe;
+	struct kprobe_step_ctx ss_ctx;
+	struct pt_regs jprobe_saved_regs;
+	char jprobes_stack[MAX_STACK_SIZE];
+};
+
+void arch_remove_kprobe(struct kprobe *);
+int kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr);
+int kprobe_exceptions_notify(struct notifier_block *self,
+			     unsigned long val, void *data);
+
+#endif /* _ARM_KPROBES_H */
diff --git a/arch/arm64/include/asm/probes.h b/arch/arm64/include/asm/probes.h
new file mode 100644
index 0000000..9dba74d
--- /dev/null
+++ b/arch/arm64/include/asm/probes.h
@@ -0,0 +1,50 @@
+/*
+ * arch/arm64/include/asm/probes.h
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
+#ifndef _ARM_PROBES_H
+#define _ARM_PROBES_H
+
+struct kprobe;
+struct arch_specific_insn;
+
+typedef u32 kprobe_opcode_t;
+typedef unsigned long (kprobes_pstate_check_t)(unsigned long);
+typedef unsigned long
+(kprobes_condition_check_t)(struct kprobe *p, struct pt_regs *);
+typedef void
+(kprobes_prepare_t)(struct kprobe *, struct arch_specific_insn *);
+typedef void (kprobes_handler_t) (u32 opcode, long addr, struct pt_regs *);
+
+enum pc_restore_type {
+	NO_RESTORE,
+	RESTORE_PC,
+};
+
+struct kprobe_pc_restore {
+	enum pc_restore_type type;
+	unsigned long addr;
+};
+
+/* architecture specific copy of original instruction */
+struct arch_specific_insn {
+	kprobe_opcode_t *insn;
+	kprobes_pstate_check_t *pstate_cc;
+	kprobes_condition_check_t *check_condn;
+	kprobes_prepare_t *prepare;
+	kprobes_handler_t *handler;
+	/* restore address after step xol */
+	struct kprobe_pc_restore restore;
+};
+
+#endif
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 3613e49..e436b49 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -203,7 +203,8 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
 	return 0;
 }
 
-#define instruction_pointer(regs)	((unsigned long)(regs)->pc)
+#define instruction_pointer(regs)	((regs)->pc)
+#define stack_pointer(regs)		((regs)->sp)
 
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index eaa77ed..6ca9fc0 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -31,6 +31,7 @@ arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
+arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o
 arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
 arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c
new file mode 100644
index 0000000..a698bd3
--- /dev/null
+++ b/arch/arm64/kernel/kprobes-arm64.c
@@ -0,0 +1,65 @@
+/*
+ * arch/arm64/kernel/kprobes-arm64.c
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
+#include <asm/kprobes.h>
+#include <asm/insn.h>
+
+#include "kprobes-arm64.h"
+
+static bool aarch64_insn_is_steppable(u32 insn)
+{
+	if (aarch64_get_insn_class(insn) == AARCH64_INSN_CLS_BR_SYS) {
+		if (aarch64_insn_is_branch(insn))
+			return false;
+
+		/* modification of daif creates issues */
+		if (aarch64_insn_is_msr_daif(insn))
+			return false;
+
+		if (aarch64_insn_is_hint(insn))
+			return aarch64_insn_is_nop(insn);
+
+		return true;
+	}
+
+	if (aarch64_insn_uses_literal(insn))
+		return false;
+
+	if (aarch64_insn_is_exclusive(insn))
+		return false;
+
+	return true;
+}
+
+/* Return:
+ *   INSN_REJECTED     If instruction is one not allowed to kprobe,
+ *   INSN_GOOD         If instruction is supported and uses instruction slot,
+ *   INSN_GOOD_NO_SLOT If instruction is supported but doesn't use its slot.
+ */
+enum kprobe_insn __kprobes
+arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi)
+{
+	/*
+	 * Instructions reading or modifying the PC won't work from the XOL
+	 * slot.
+	 */
+	if (aarch64_insn_is_steppable(insn))
+		return INSN_GOOD;
+	else
+		return INSN_REJECTED;
+}
diff --git a/arch/arm64/kernel/kprobes-arm64.h b/arch/arm64/kernel/kprobes-arm64.h
new file mode 100644
index 0000000..87e7891
--- /dev/null
+++ b/arch/arm64/kernel/kprobes-arm64.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm64/kernel/kprobes-arm64.h
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
+#ifndef _ARM_KERNEL_KPROBES_ARM64_H
+#define _ARM_KERNEL_KPROBES_ARM64_H
+
+enum kprobe_insn {
+	INSN_REJECTED,
+	INSN_GOOD_NO_SLOT,
+	INSN_GOOD,
+};
+
+enum kprobe_insn __kprobes
+arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi);
+
+#endif /* _ARM_KERNEL_KPROBES_ARM64_H */
diff --git a/arch/arm64/kernel/kprobes.c b/arch/arm64/kernel/kprobes.c
new file mode 100644
index 0000000..65e22d8
--- /dev/null
+++ b/arch/arm64/kernel/kprobes.c
@@ -0,0 +1,551 @@
+/*
+ * arch/arm64/kernel/kprobes.c
+ *
+ * Kprobes support for ARM64
+ *
+ * Copyright (C) 2013 Linaro Limited.
+ * Author: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
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
+ */
+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/stop_machine.h>
+#include <linux/stringify.h>
+#include <asm/traps.h>
+#include <asm/ptrace.h>
+#include <asm/cacheflush.h>
+#include <asm/debug-monitors.h>
+#include <asm/system_misc.h>
+#include <asm/insn.h>
+
+#include "kprobes.h"
+#include "kprobes-arm64.h"
+
+#define MIN_STACK_SIZE(addr)	min((unsigned long)MAX_STACK_SIZE,	\
+	(unsigned long)current_thread_info() + THREAD_START_SP - (addr))
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
+{
+	/* prepare insn slot */
+	p->ainsn.insn[0] = p->opcode;
+
+	flush_icache_range((uintptr_t) (p->ainsn.insn),
+			   (uintptr_t) (p->ainsn.insn) + MAX_INSN_SIZE);
+
+	/*
+	 * Needs restoring of return address after stepping xol.
+	 */
+	p->ainsn.restore.addr = (unsigned long) p->addr +
+	  sizeof(kprobe_opcode_t);
+	p->ainsn.restore.type = RESTORE_PC;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	kprobe_opcode_t insn;
+	unsigned long probe_addr = (unsigned long)p->addr;
+
+	/* copy instruction */
+	insn = *p->addr;
+	p->opcode = insn;
+
+	if (in_exception_text(probe_addr))
+		return -EINVAL;
+
+	/* decode instruction */
+	switch (arm_kprobe_decode_insn(insn, &p->ainsn)) {
+	case INSN_REJECTED:	/* insn not supported */
+		return -EINVAL;
+
+	case INSN_GOOD_NO_SLOT:	/* insn need simulation */
+		return -EINVAL;
+
+	case INSN_GOOD:	/* instruction uses slot */
+		p->ainsn.insn = get_insn_slot();
+		if (!p->ainsn.insn)
+			return -ENOMEM;
+		break;
+	};
+
+	/* prepare the instruction */
+	arch_prepare_ss_slot(p);
+
+	return 0;
+}
+
+static int __kprobes patch_text(kprobe_opcode_t *addr, u32 opcode)
+{
+	void *addrs[1];
+	u32 insns[1];
+
+	addrs[0] = (void *)addr;
+	insns[0] = (u32)opcode;
+
+	return aarch64_insn_patch_text_sync(addrs, insns, 1);
+}
+
+/* arm kprobe: install breakpoint in text */
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	patch_text(p->addr, BRK64_OPCODE_KPROBES);
+}
+
+/* disarm kprobe: remove breakpoint from text */
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	patch_text(p->addr, p->opcode);
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	if (p->ainsn.insn) {
+		free_insn_slot(p->ainsn.insn, 0);
+		p->ainsn.insn = NULL;
+	}
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p)
+{
+	__this_cpu_write(current_kprobe, p);
+}
+
+/*
+ * Debug flag (D-flag) is disabled upon exception entry.
+ * Kprobes need to unmask D-flag -ONLY- in case of recursive
+ * probe i.e. when probe hit from kprobe handler context upon
+ * executing the pre/post handlers. In this case we return with
+ * D-flag unmasked so that single-stepping can be carried-out.
+ *
+ * Keep D-flag masked in all other cases.
+ */
+static void __kprobes
+spsr_set_debug_flag(struct pt_regs *regs, int mask)
+{
+	unsigned long spsr = regs->pstate;
+
+	if (mask)
+		spsr |= PSR_D_BIT;
+	else
+		spsr &= ~PSR_D_BIT;
+
+	regs->pstate = spsr;
+}
+
+/*
+ * Interrupt needs to be disabled for the duration from probe hitting
+ * breakpoint exception until kprobe is processed completely.
+ * Without disabling interrupt on local CPU, there is a chance of
+ * interrupt occurrence in the period of exception return and  start of
+ * out-of-line single-step, that result in wrongly single stepping
+ * the interrupt handler.
+ */
+static void __kprobes kprobes_save_local_irqflag(struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	kcb->saved_irqflag = regs->pstate;
+	regs->pstate |= PSR_I_BIT;
+}
+
+static void __kprobes kprobes_restore_local_irqflag(struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (kcb->saved_irqflag & PSR_I_BIT)
+		regs->pstate |= PSR_I_BIT;
+	else
+		regs->pstate &= ~PSR_I_BIT;
+}
+
+static void __kprobes
+set_ss_context(struct kprobe_ctlblk *kcb, unsigned long addr)
+{
+	kcb->ss_ctx.ss_status = KPROBES_STEP_PENDING;
+	kcb->ss_ctx.match_addr = addr + sizeof(kprobe_opcode_t);
+}
+
+static void __kprobes clear_ss_context(struct kprobe_ctlblk *kcb)
+{
+	kcb->ss_ctx.ss_status = KPROBES_STEP_NONE;
+	kcb->ss_ctx.match_addr = 0;
+}
+
+static void __kprobes
+skip_singlestep_missed(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
+{
+	/* set return addr to next pc to continue */
+	instruction_pointer(regs) += sizeof(kprobe_opcode_t);
+}
+
+static void __kprobes setup_singlestep(struct kprobe *p,
+				       struct pt_regs *regs,
+				       struct kprobe_ctlblk *kcb, int reenter)
+{
+	unsigned long slot;
+
+	if (reenter) {
+		save_previous_kprobe(kcb);
+		set_current_kprobe(p);
+		kcb->kprobe_status = KPROBE_REENTER;
+	} else {
+		kcb->kprobe_status = KPROBE_HIT_SS;
+	}
+
+	if (p->ainsn.insn) {
+		/* prepare for single stepping */
+		slot = (unsigned long)p->ainsn.insn;
+
+		set_ss_context(kcb, slot);	/* mark pending ss */
+
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			spsr_set_debug_flag(regs, 0);
+
+		/* IRQs and single stepping do not mix well. */
+		kprobes_save_local_irqflag(regs);
+		kernel_enable_single_step(regs);
+		instruction_pointer(regs) = slot;
+	} else	{
+		BUG();
+	}
+}
+
+static int __kprobes reenter_kprobe(struct kprobe *p,
+				    struct pt_regs *regs,
+				    struct kprobe_ctlblk *kcb)
+{
+	switch (kcb->kprobe_status) {
+	case KPROBE_HIT_SSDONE:
+	case KPROBE_HIT_ACTIVE:
+		if (!p->ainsn.check_condn || p->ainsn.check_condn(p, regs)) {
+			kprobes_inc_nmissed_count(p);
+			setup_singlestep(p, regs, kcb, 1);
+		} else	{
+			/* condition check failed, skip stepping */
+			skip_singlestep_missed(kcb, regs);
+		}
+		break;
+	case KPROBE_HIT_SS:
+		pr_warn("Unrecoverable kprobe detected at %p.\n", p->addr);
+		dump_kprobe(p);
+		BUG();
+		break;
+	default:
+		WARN_ON(1);
+		return 0;
+	}
+
+	return 1;
+}
+
+static void __kprobes
+post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+
+	if (!cur)
+		return;
+
+	/* return addr restore if non-branching insn */
+	if (cur->ainsn.restore.type == RESTORE_PC) {
+		instruction_pointer(regs) = cur->ainsn.restore.addr;
+		if (!instruction_pointer(regs))
+			BUG();
+	}
+
+	/* restore back original saved kprobe variables and continue */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		return;
+	}
+	/* call post handler */
+	kcb->kprobe_status = KPROBE_HIT_SSDONE;
+	if (cur->post_handler)	{
+		/* post_handler can hit breakpoint and single step
+		 * again, so we enable D-flag for recursive exception.
+		 */
+		cur->post_handler(cur, regs, 0);
+	}
+
+	reset_current_kprobe();
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, unsigned int fsr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	switch (kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the ip points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		instruction_pointer(regs) = (unsigned long)cur->addr;
+		if (!instruction_pointer(regs))
+			BUG();
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accounting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, fsr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+		if (fixup_exception(regs))
+			return 1;
+
+		break;
+	}
+	return 0;
+}
+
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	return NOTIFY_DONE;
+}
+
+void __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p, *cur;
+	struct kprobe_ctlblk *kcb;
+	unsigned long addr = instruction_pointer(regs);
+
+	kcb = get_kprobe_ctlblk();
+	cur = kprobe_running();
+
+	p = get_kprobe((kprobe_opcode_t *) addr);
+
+	if (p) {
+		if (cur) {
+			if (reenter_kprobe(p, regs, kcb))
+				return;
+		} else if (!p->ainsn.check_condn ||
+			   p->ainsn.check_condn(p, regs)) {
+			/* Probe hit and conditional execution check ok. */
+			set_current_kprobe(p);
+			kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+			/*
+			 * If we have no pre-handler or it returned 0, we
+			 * continue with normal processing.  If we have a
+			 * pre-handler and it returned non-zero, it prepped
+			 * for calling the break_handler below on re-entry,
+			 * so get out doing nothing more here.
+			 *
+			 * pre_handler can hit a breakpoint and can step thru
+			 * before return, keep PSTATE D-flag enabled until
+			 * pre_handler return back.
+			 */
+			if (!p->pre_handler || !p->pre_handler(p, regs)) {
+				kcb->kprobe_status = KPROBE_HIT_SS;
+				setup_singlestep(p, regs, kcb, 0);
+				return;
+			}
+		} else {
+			/*
+			 * Breakpoint hit but conditional check failed,
+			 * so just skip the instruction (NOP behaviour)
+			 */
+			skip_singlestep_missed(kcb, regs);
+			return;
+		}
+	} else if (*(kprobe_opcode_t *) addr != BRK64_OPCODE_KPROBES) {
+		/*
+		 * The breakpoint instruction was removed right
+		 * after we hit it.  Another cpu has removed
+		 * either a probepoint or a debugger breakpoint
+		 * at this address.  In either case, no further
+		 * handling of this interrupt is appropriate.
+		 * Return back to original instruction, and continue.
+		 */
+		return;
+	} else if (cur) {
+		/* We probably hit a jprobe.  Call its break handler. */
+		if (cur->break_handler && cur->break_handler(cur, regs)) {
+			kcb->kprobe_status = KPROBE_HIT_SS;
+			setup_singlestep(cur, regs, kcb, 0);
+			return;
+		}
+	} else {
+		/* breakpoint is removed, now in a race
+		 * Return back to original instruction & continue.
+		 */
+	}
+}
+
+static int __kprobes
+kprobe_ss_hit(struct kprobe_ctlblk *kcb, unsigned long addr)
+{
+	if ((kcb->ss_ctx.ss_status == KPROBES_STEP_PENDING)
+	    && (kcb->ss_ctx.match_addr == addr)) {
+		clear_ss_context(kcb);	/* clear pending ss */
+		return DBG_HOOK_HANDLED;
+	}
+	/* not ours, kprobes should ignore it */
+	return DBG_HOOK_ERROR;
+}
+
+static int __kprobes
+kprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	int retval;
+
+	/* return error if this is not our step */
+	retval = kprobe_ss_hit(kcb, instruction_pointer(regs));
+
+	if (retval == DBG_HOOK_HANDLED) {
+		kprobes_restore_local_irqflag(regs);
+		kernel_disable_single_step();
+
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			spsr_set_debug_flag(regs, 1);
+
+		post_kprobe_handler(kcb, regs);
+	}
+
+	return retval;
+}
+
+static int __kprobes
+kprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
+{
+	kprobe_handler(regs);
+	return DBG_HOOK_HANDLED;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	long stack_ptr = stack_pointer(regs);
+
+	kcb->jprobe_saved_regs = *regs;
+	memcpy(kcb->jprobes_stack, (void *)stack_ptr,
+	       MIN_STACK_SIZE(stack_ptr));
+
+	instruction_pointer(regs) = (long)jp->entry;
+	preempt_disable();
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	/*
+	 * Jprobe handler return by entering break exception,
+	 * encoded same as kprobe, but with following conditions
+	 * -a magic number in x0 to identify from rest of other kprobes.
+	 * -restore stack addr to original saved pt_regs
+	 */
+	asm volatile ("ldr x0, [%0]\n\t"
+		      "mov sp, x0\n\t"
+		      "ldr x0, =" __stringify(JPROBES_MAGIC_NUM) "\n\t"
+		      "BRK %1\n\t"
+		      "NOP\n\t"
+		      :
+		      : "r"(&kcb->jprobe_saved_regs.sp),
+		      "I"(BRK64_ESR_KPROBES)
+		      : "memory");
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	long stack_addr = kcb->jprobe_saved_regs.sp;
+	long orig_sp = stack_pointer(regs);
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+
+	if (regs->regs[0] == JPROBES_MAGIC_NUM) {
+		if (orig_sp != stack_addr) {
+			struct pt_regs *saved_regs =
+			    (struct pt_regs *)kcb->jprobe_saved_regs.sp;
+			pr_err("current sp %lx does not match saved sp %lx\n",
+			       orig_sp, stack_addr);
+			pr_err("Saved registers for jprobe %p\n", jp);
+			show_regs(saved_regs);
+			pr_err("Current registers\n");
+			show_regs(regs);
+			BUG();
+		}
+		*regs = kcb->jprobe_saved_regs;
+		memcpy((void *)stack_addr, kcb->jprobes_stack,
+		       MIN_STACK_SIZE(stack_addr));
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+
+/* Break Handler hook */
+static struct break_hook kprobes_break_hook = {
+	.esr_mask = BRK64_ESR_MASK,
+	.esr_val = BRK64_ESR_KPROBES,
+	.fn = kprobe_breakpoint_handler,
+};
+
+/* Single Step handler hook */
+static struct step_hook kprobes_step_hook = {
+	.fn = kprobe_single_step_handler,
+};
+
+int __init arch_init_kprobes(void)
+{
+	register_break_hook(&kprobes_break_hook);
+	register_step_hook(&kprobes_step_hook);
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/kprobes.h b/arch/arm64/kernel/kprobes.h
new file mode 100644
index 0000000..93c54b4
--- /dev/null
+++ b/arch/arm64/kernel/kprobes.h
@@ -0,0 +1,30 @@
+/*
+ * arch/arm64/kernel/kprobes.h
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
+#ifndef _ARM_KERNEL_KPROBES_H
+#define _ARM_KERNEL_KPROBES_H
+
+/* BRK opcodes with ESR encoding  */
+#define BRK64_ESR_MASK		0xFFFF
+#define BRK64_ESR_KPROBES	0x0004
+#define BRK64_OPCODE_KPROBES	0xD4200080	/* "brk 0x4" */
+#define ARCH64_NOP_OPCODE	0xD503201F
+
+#define JPROBES_MAGIC_NUM	0xa5a5a5a5a5a5a5a5
+
+/* Move this out to appropriate header file */
+int fixup_exception(struct pt_regs *regs);
+
+#endif /* _ARM_KERNEL_KPROBES_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 9965ec8..5402a98 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -80,6 +80,7 @@ SECTIONS
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
+			KPROBES_TEXT
 			HYPERVISOR_TEXT
 			*(.fixup)
 			*(.gnu.warning)
-- 
1.8.1.2

