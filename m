Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3JQLTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:19:07 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43139 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3JQLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:18:58 -0400
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, dsaxena@linaro.org,
        jiang.liu@huawei.com, Vijaya.Kumar@caviumnetworks.com,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH RFC 2/6] arm64: Kprobes with single stepping support
Date: Thu, 17 Oct 2013 16:47:47 +0530
Message-Id: <1382008671-4515-3-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for basic kernel probes(kprobes), jump probes (jprobes)
for ARM64.

Kprobes will utilize software breakpoint and single step debug
exceptions supported on ARM v8.

software breakpoint is placed at the probe address to trap the
kernel execution into kprobe handler.

ARM v8 support single stepping to be enabled while exception return
(ERET) with next PC in exception return address (ELR_EL1).
kprobe handler prepares a executable memory slot for out-of-line
execution with the copy of the original instruction under probe, and
enable single stepping from the instruction slot. With this scheme,
the instruction is executed with the exact same register context
'except PC' that points to instruction slot.

Debug mask(PSTATE.D) is enabled while calling user pre & post handlers
since it can hit breakpoint again(like kprobe placed on printk, with
user handler invoking printk again). This allow kprobe re-entry and
any further re-entry is prevented by not calling handlers (counted as
missed kprobe)

Single stepping from slot has drawback on PC-relative accesses
like branching and symbolic literals access as offset from new PC
may not be ensured to fit in immediate value of opcode,
(usually +/-1MB range). So these instructions needs simulation, so
are not allowed to place probe on those instructions.

Instructions generating exceptions or cpu mode change are rejected,
and not allowed to insert probe for such instructions.

Instructions using Exclusive Monitor are rejected right now.

System instructions are mostly enabled for stepping, except MSR
immediate that update "daif" flags in PSTATE, which are not safe
for probing(rejected)

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
---
 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/kprobes.h  |  59 +++++
 arch/arm64/include/asm/probes.h   |  50 ++++
 arch/arm64/include/asm/ptrace.h   |   1 +
 arch/arm64/kernel/Makefile        |   1 +
 arch/arm64/kernel/kprobes-arm64.c | 211 +++++++++++++++
 arch/arm64/kernel/kprobes-arm64.h |  28 ++
 arch/arm64/kernel/kprobes.c       | 538 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/kprobes.h       |  30 +++
 arch/arm64/kernel/probes-decode.h | 110 ++++++++
 arch/arm64/kernel/vmlinux.lds.S   |   1 +
 11 files changed, 1030 insertions(+)
 create mode 100644 arch/arm64/include/asm/kprobes.h
 create mode 100644 arch/arm64/include/asm/probes.h
 create mode 100644 arch/arm64/kernel/kprobes-arm64.c
 create mode 100644 arch/arm64/kernel/kprobes-arm64.h
 create mode 100644 arch/arm64/kernel/kprobes.c
 create mode 100644 arch/arm64/kernel/kprobes.h
 create mode 100644 arch/arm64/kernel/probes-decode.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index da388e4..2e89059 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -27,6 +27,7 @@ config ARM64
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
 	select HAVE_PERF_EVENTS
+	select HAVE_KPROBES if !XIP_KERNEL
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
new file mode 100644
index 0000000..9b491d0
--- /dev/null
+++ b/arch/arm64/include/asm/kprobes.h
@@ -0,0 +1,59 @@
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
+#define MAX_INSN_SIZE			2
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
index 0000000..c9c7734
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
+typedef enum {
+	NO_RESTORE,
+	RESTORE_PC,
+} pc_restore_t;
+
+struct kprobe_pc_restore {
+	pc_restore_t type;
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
index 0dacbbf..89f1727 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -164,6 +164,7 @@ static inline int valid_user_regs(struct user_pt_regs *regs)
 }
 
 #define instruction_pointer(regs)	(regs)->pc
+#define stack_pointer(regs)		((regs)->sp)
 
 #ifdef CONFIG_SMP
 extern unsigned long profile_pc(struct pt_regs *regs);
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index b7db65e..12ef8d2 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -19,6 +19,7 @@ arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
+arm64-obj-$(CONFIG_KPROBES)		+= kprobes.o kprobes-arm64.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/kprobes-arm64.c b/arch/arm64/kernel/kprobes-arm64.c
new file mode 100644
index 0000000..30d1c14
--- /dev/null
+++ b/arch/arm64/kernel/kprobes-arm64.c
@@ -0,0 +1,211 @@
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
+
+#include "probes-decode.h"
+#include "kprobes-arm64.h"
+
+/* AArch64 instruction decode table for kprobes:
+ * The instruction will fall into one of the 3 groups:
+ *  1. Single stepped out-of-the-line slot.
+ *     -Most instructions fall in this group, those does not
+ *      depend on PC address.
+ *
+ *  2. Should be simulated because of PC-relative/literal access.
+ *     -All branching and PC-relative insrtcutions are simulated
+ *      in C code, making use of saved pt_regs
+ *      Catch: SIMD/NEON register context are not saved while
+ *      entering debug exception, so are rejected for now.
+ *
+ *  3. Cannot be probed(not safe) so are rejected.
+ *     - Exception generation and exception return instructions
+ *     - Exclusive monitor(LDREX/STREX family)
+ *
+ */
+static const struct aarch64_decode_item aarch64_decode_table[] = {
+	/*
+	 * Data processing - PC relative(literal) addressing:
+	 * Encoding: xxx1 0000 xxxx xxxx xxxx xxxx xxxx xxxx
+	 */
+	DECODE_REJECT(0x10000000, 0x1F000000),
+
+	/*
+	 * Data processing - Add/Substract Immediate:
+	 * Encoding: xxx1 0001 xxxx xxxx xxxx xxxx xxxx xxxx
+	 */
+	DECODE_SINGLESTEP(0x11000000, 0x1F000000),
+
+	/*
+	 * Data processing
+	 * Encoding:
+	 *      xxx1 0010 0xxx xxxx xxxx xxxx xxxx xxxx (Logical)
+	 *      xxx1 0010 1xxx xxxx xxxx xxxx xxxx xxxx (Move wide)
+	 *      xxx1 0011 0xxx xxxx xxxx xxxx xxxx xxxx (Bitfield)
+	 *      xxx1 0011 1xxx xxxx xxxx xxxx xxxx xxxx (Extract)
+	 */
+	DECODE_SINGLESTEP(0x12000000, 0x1E000000),
+
+	/*
+	 * Data processing - SIMD/FP/AdvSIMD/Crypto-AES/SHA
+	 * Encoding: xxx0 111x xxxx xxxx xxxx xxxx xxxx xxxx
+	 * Encoding: xxx1 111x xxxx xxxx xxxx xxxx xxxx xxxx
+	 */
+	DECODE_SINGLESTEP(0x0E000000, 0x0E000000),
+
+	/*
+	 * Data processing - Register
+	 * Encoding: xxxx 101x xxxx xxxx xxxx xxxx xxxx xxxx
+	 */
+	DECODE_SINGLESTEP(0x0A000000, 0x0E000000),
+
+	/* Branching Instructions
+	 *
+	 * Encoding:
+	 *  x001 01xx xxxx xxxx xxxx xxxx xxxx xxxx (uncondtional Branch)
+	 *  x011 010x xxxx xxxx xxxx xxxx xxxx xxxx (compare & branch)
+	 *  x011 011x xxxx xxxx xxxx xxxx xxxx xxxx (Test & Branch)
+	 *  0101 010x xxxx xxxx xxxx xxxx xxxx xxxx (Conditional, immediate)
+	 *  1101 011x xxxx xxxx xxxx xxxx xxxx xxxx (Unconditional,register)
+	 */
+	DECODE_REJECT(0x14000000, 0x7C000000),
+	DECODE_REJECT(0x14000000, 0x7C000000),
+	DECODE_REJECT(0x34000000, 0x7E000000),
+	DECODE_REJECT(0x36000000, 0x7E000000),
+	DECODE_REJECT(0x54000000, 0xFE000000),
+	DECODE_REJECT(0xD6000000, 0xFE000000),
+
+	/* System insn:
+	 * Encoding: 1101 0101 00xx xxxx xxxx xxxx xxxx xxxx
+	 *
+	 * Note: MSR immediate (update PSTATE daif) is not safe handling
+	 * within kprobes, rejected.
+	 *
+	 * Don't re-arrange these decode table entries.
+	 */
+	DECODE_REJECT(0xD500401F, 0xFFF8F01F),
+	DECODE_SINGLESTEP(0xD5000000, 0xFFC00000),
+
+	/* Exception Generation:
+	 * Encoding:  1101 0100 xxxx xxxx xxxx xxxx xxxx xxxx
+	 * Instructions: SVC, HVC, SMC, BRK, HLT, DCPS1, DCPS2, DCPS3
+	 */
+	DECODE_REJECT(0xD4000000, 0xFF000000),
+
+	/*
+	 * Load/Store - Exclusive monitor
+	 * Encoding: xx00 1000 xxxx xxxx xxxx xxxx xxxx xxxx
+	 *
+	 * Reject exlusive monitor'ed instructions
+	 */
+	DECODE_REJECT(0x08000000, 0x3F000000),
+
+	/*
+	 * Load/Store - PC relative(literal):
+	 * Encoding:  xx01 1x00 xxxx xxxx xxxx xxxx xxxx xxxx
+	 */
+	DECODE_REJECT(0x18000000, 0x3B000000),
+
+	/*
+	 * Load/Store - Register Pair
+	 * Encoding:
+	 *      xx10 1x00 0xxx xxxx xxxx xxxx xxxx xxxx
+	 *      xx10 1x00 1xxx xxxx xxxx xxxx xxxx xxxx
+	 *      xx10 1x01 0xxx xxxx xxxx xxxx xxxx xxxx
+	 *      xx10 1x01 1xxx xxxx xxxx xxxx xxxx xxxx
+	 */
+	DECODE_SINGLESTEP(0x28000000, 0x3A000000),
+
+	/*
+	 * Load/Store - Register
+	 * Encoding:
+	 *      xx11 1x00 xx0x xxxx xxxx 00xx xxxx xxxx (unscaled imm)
+	 *      xx11 1x00 xx0x xxxx xxxx 01xx xxxx xxxx (imm post-indexed)
+	 *      xx11 1x00 xx0x xxxx xxxx 10xx xxxx xxxx (unpriviledged)
+	 *      xx11 1x00 xx0x xxxx xxxx 11xx xxxx xxxx (imm pre-indexed)
+	 *
+	 *      xx11 1x00 xx10 xxxx xxxx xx10 xxxx xxxx (register offset)
+	 *
+	 *      xx11 1x01 xxxx xxxx xxxx xxxx xxxx xxxx (unsigned imm)
+	 */
+	DECODE_SINGLESTEP(0x38000000, 0x3B200000),
+	DECODE_SINGLESTEP(0x38200200, 0x38300300),
+	DECODE_SINGLESTEP(0x39000000, 0x3B000000),
+
+	/*
+	 * Load/Store - AdvSIMD
+	 * Encoding:
+	 *  0x00 1100 0x00 0000 xxxx xxxx xxxx xxxx (Multiple-structure)
+	 *  0x00 1100 1x0x xxxx xxxx xxxx xxxx xxxx (Multi-struct post-indexed)
+	 *  0x00 1101 0xx0 0000 xxxx xxxx xxxx xxxx (Single-structure))
+	 *  0x00 1101 1xxx xxxx xxxx xxxx xxxx xxxx (Single-struct post-index)
+	 */
+	DECODE_SINGLESTEP(0x0C000000, 0xBFBF0000),
+	DECODE_SINGLESTEP(0x0C800000, 0xBFA00000),
+	DECODE_SINGLESTEP(0x0D000000, 0xBF9F0000),
+	DECODE_SINGLESTEP(0x0D800000, 0xBF800000),
+
+	/* Unallocated:         xxx0 0xxx xxxx xxxx xxxx xxxx xxxx xxxx */
+	DECODE_REJECT(0x00000000, 0x18000000),
+	DECODE_END,
+};
+
+static int __kprobes
+kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		   const struct aarch64_decode_item *tbl)
+{
+	unsigned int entry, ret = INSN_REJECTED;
+
+	for (entry = 0; !decode_table_end(tbl[entry]); entry++) {
+		if (decode_table_hit(tbl[entry], insn))
+			break;
+	}
+
+	switch (decode_get_type(tbl[entry])) {
+	case DECODE_TYPE_END:
+	case DECODE_TYPE_REJECT:
+	default:
+		ret = INSN_REJECTED;
+		break;
+
+	case DECODE_TYPE_SINGLESTEP:
+		ret = INSN_GOOD;
+		break;
+
+	case DECODE_TYPE_SIMULATE:
+		ret = INSN_REJECTED;
+		break;
+
+	case DECODE_TYPE_TABLE:
+		/* recurse with next level decode table */
+		ret = kprobe_decode_insn(insn, asi,
+					 decode_sub_table(tbl[entry]));
+	};
+	return ret;
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
+	return kprobe_decode_insn(insn, asi, aarch64_decode_table);
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
index 0000000..def10b6
--- /dev/null
+++ b/arch/arm64/kernel/kprobes.c
@@ -0,0 +1,538 @@
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
+	int i;
+	/* prepare insn slot */
+	p->ainsn.insn[0] = p->opcode;
+	/* NOP for superscalar uArch decode */
+	for (i = 1; i < MAX_INSN_SIZE; i++)
+		p->ainsn.insn[i] = ARCH64_NOP_OPCODE;
+
+	flush_icache_range((uintptr_t) (p->ainsn.insn),
+			   (uintptr_t) (p->ainsn.insn) + MAX_INSN_SIZE);
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
+		break;
+
+	case INSN_GOOD_NO_SLOT:	/* insn need simulation */
+		return -EINVAL;
+		break;
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
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p)
+{
+	__get_cpu_var(current_kprobe) = p;
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
+nop_singlestep_skip(struct kprobe *p, struct pt_regs *regs)
+{
+	/* set return addr to next pc to continue */
+	instruction_pointer(regs) += sizeof(kprobe_opcode_t);
+	return;
+}
+
+/* Mask/Unmask PSTATE.D flag
+ *
+ * Unmasking D-flag enables recursing into another debug
+ * exception (breakpoint or single step).
+ *
+ * Upon every exception entry, D-flag is disabled by the
+ * hardware. We shall unmask this flag only after safely
+ * saved the previous context and kprobes state machines.
+ *
+ * kprobes can generate recursing in breakpoint (followed
+ * by single stepping) within user-provided handlers only.
+ *
+ * All other places, keep the D-flag masked.
+ */
+static void mask_pstate_debug_flag(u32 mask)
+{
+	if (mask)
+		asm volatile("msr daifset, #9\n\t");
+	else
+		asm volatile("msr daifclr, #9\n\t");
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
+		/*
+		 * Needs restoring of return address after stepping xol.
+		 */
+		p->ainsn.restore.addr = instruction_pointer(regs) +
+				sizeof(kprobe_opcode_t);
+		p->ainsn.restore.type = RESTORE_PC;
+
+		set_ss_context(kcb, slot);	/* mark pending ss */
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
+			/* condition failed, it's NOP so skip stepping */
+			nop_singlestep_skip(p, regs);
+		}
+		break;
+	case KPROBE_HIT_SS:
+		pr_warn("Unrecoverable kprobe detected at %p.\n", p->addr);
+		dump_kprobe(p);
+		BUG();
+	default:
+		WARN_ON(1);
+		return 0;
+	}
+
+	return 1;
+}
+
+static int __kprobes
+post_kprobe_handler(struct kprobe_ctlblk *kcb, struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+
+	if (!cur)
+		return 0;
+
+	/* return addr restore if non-branching insn */
+	if (cur->ainsn.restore.type == RESTORE_PC) {
+		instruction_pointer(regs) = cur->ainsn.restore.addr;
+		cur->ainsn.restore.addr = 0;
+		cur->ainsn.restore.type = NO_RESTORE;
+	}
+
+	/* restore back original saved kprobe variables and continue */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	} else	{ /* call post handler */
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		if (cur->post_handler)	{
+			/* post_handler can hit breakpoint and single step
+			 * again, so we enable D-flag for recursive exception.
+			 */
+			mask_pstate_debug_flag(0);
+			cur->post_handler(cur, regs, 0);
+			mask_pstate_debug_flag(1);
+		}
+	}
+	reset_current_kprobe();
+out:
+
+	return 1;
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
+	default:
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
+			mask_pstate_debug_flag(0);
+			if (!p->pre_handler || !p->pre_handler(p, regs)) {
+				mask_pstate_debug_flag(1);
+				kcb->kprobe_status = KPROBE_HIT_SS;
+				setup_singlestep(p, regs, kcb, 0);
+				return;
+			}
+			mask_pstate_debug_flag(1);
+		} else {
+			/*
+			 * Breakpoint hit but conditional check failed,
+			 * so just skip handling since it is NOP.
+			 */
+			nop_singlestep_skip(p, regs);
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
+		preempt_enable_no_resched();
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
+		preempt_enable_no_resched();
+	}
+	return;
+}
+
+static int __kprobes
+kprobe_ss_hit(struct kprobe_ctlblk *kcb, unsigned long addr)
+{
+	if ((kcb->ss_ctx.ss_status == KPROBES_STEP_PENDING)
+	    && (kcb->ss_ctx.match_addr == addr)) {
+		clear_ss_context(kcb);	/* clear pending ss */
+		return DBG_HOOK_HANDLED;
+	} else {
+		/* not ours, kprobes should ignore it */
+		return DBG_HOOK_ERROR;
+	}
+}
+
+static int __kprobes
+kprobe_single_step_handler(struct pt_regs *regs, unsigned int esr)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long flags;
+	int retval;
+
+	/* check, and return error if this is not our step */
+	retval = kprobe_ss_hit(kcb, instruction_pointer(regs));
+
+	if (retval == DBG_HOOK_HANDLED) {
+		/* single step complete, call post handlers */
+		local_irq_save(flags);
+		kernel_disable_single_step();
+		post_kprobe_handler(kcb, regs);
+		local_irq_restore(flags);
+	}
+	return retval;
+}
+
+static int __kprobes
+kprobe_breakpoint_handler(struct pt_regs *regs, unsigned int esr)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	kprobe_handler(regs);
+	local_irq_restore(flags);
+
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
+
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
+int __init arch_init_kprobes()
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
diff --git a/arch/arm64/kernel/probes-decode.h b/arch/arm64/kernel/probes-decode.h
new file mode 100644
index 0000000..3650ab3
--- /dev/null
+++ b/arch/arm64/kernel/probes-decode.h
@@ -0,0 +1,110 @@
+/*
+ * arch/arm64/kernel/probes-decode.h
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
+#ifndef _ARM_KERNEL_PROBES_DECODE_H
+#define _ARM_KERNEL_PROBES_DECODE_H
+
+/*
+ * The following definitions and macros are used to build instruction
+ * decoding tables.
+ */
+enum decode_type {
+	DECODE_TYPE_END,
+	DECODE_TYPE_SINGLESTEP,
+	DECODE_TYPE_SIMULATE,
+	DECODE_TYPE_TABLE,
+	DECODE_TYPE_REJECT,
+};
+
+struct aarch64_decode_item;
+
+struct aarch64_decode_header {
+	enum decode_type type;
+	u32 mask;
+	u32 val;
+};
+
+struct aarch64_decode_actions {
+	kprobes_prepare_t *prepare;
+	kprobes_handler_t *handler;
+};
+
+struct aarch64_decode_table {
+	const struct aarch64_decode_item *tbl;
+};
+
+union aarch64_decode_handler {
+	struct aarch64_decode_actions actions;
+	struct aarch64_decode_table table;
+};
+
+struct aarch64_decode_item {
+	struct aarch64_decode_header header;
+	union aarch64_decode_handler decode;
+};
+
+#define decode_get_type(_entry)	 ((_entry).header.type)
+
+#define decode_table_end(_entry)		\
+	((_entry).header.type == DECODE_TYPE_END)
+
+#define decode_table_hit(_entry, insn)		\
+	((insn & (_entry).header.mask) == (_entry).header.val)
+
+#define decode_prepare_fn(_entry)	((_entry).decode.actions.prepare)
+#define decode_handler_fn(_entry)	((_entry).decode.actions.handler)
+#define decode_sub_table(_entry)	((_entry).decode.table.tbl)
+
+#define DECODE_ADD_HEADER(_type, _val, _mask)	\
+	.header = {				\
+		.type = _type,			\
+		.mask = _mask,			\
+		.val = _val,			\
+	},
+
+#define DECODE_ADD_ACTION(_prepare, _handler)	\
+	.decode = {				\
+		.actions = {			\
+			.prepare = _prepare,	\
+			.handler = _handler,	\
+		}				\
+	},
+
+#define DECODE_ADD_TABLE(_table)		\
+	.decode = {				\
+		.table = {.tbl = _table}	\
+	},
+
+#define DECODE_REJECT(_v, _m)					\
+	{ DECODE_ADD_HEADER(DECODE_TYPE_REJECT, _v, _m) }
+
+#define DECODE_SINGLESTEP(_v, _m)				\
+	{ DECODE_ADD_HEADER(DECODE_TYPE_SINGLESTEP, _v, _m) }
+
+#define DECODE_SIMULATE(_v, _m, _p, _h)				\
+	{ DECODE_ADD_HEADER(DECODE_TYPE_SIMULATE, _v, _m)	\
+	  DECODE_ADD_ACTION(_p, _h) }
+
+#define DECODE_TABLE(_v, _m, _table)				\
+	{ DECODE_ADD_HEADER(DECODE_TYPE_TABLE, _v, _m)		\
+	  DECODE_ADD_TABLE(_table) }
+
+#define DECODE_LITERAL(_v, _m, _p, _h)	DECODE_SIMULATE(_v, _m, _p, _h)
+#define DECODE_BRANCH(_v, _m, _p, _h)	DECODE_SIMULATE(_v, _m, _p, _h)
+
+/* should be the last element in decode structure */
+#define DECODE_END	{ .header = {.type = DECODE_TYPE_END, } }
+
+#endif /* _ARM_KERNEL_PROBES_DECODE_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index f8ab9d8..40951b1 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -62,6 +62,7 @@ SECTIONS
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
+			KPROBES_TEXT
 			HYPERVISOR_TEXT
 			*(.fixup)
 			*(.gnu.warning)
-- 
1.8.1.2

