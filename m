Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab3JOVE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:04:56 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:46580 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791Ab3JOVEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:49 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/13] ARM: Finish renaming ARM kprobes APIs for sharing with uprobes
Date: Tue, 15 Oct 2013 17:04:26 -0400
Message-Id: <1381871068-27660-12-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Use the prefix "probes_" for APIs and definitions to be shared between
kprobes and uprobes. Pass additional information into the lower-level decoding
functions to avoid having to duplicate architecture-specfific data structures.
Make susbsystem-specific APIs static (non-global) again.  Make a couple of utility
functions (probes_simulate_nop and probes_emulate_none) sharable and in a common
file. Keep the current "action" tables specific to kprobes, as this is where
uprobes functionality will be connected up to the instruction interpreter.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/kprobes.h   |   4 +-
 arch/arm/include/asm/probes.h    |  25 ++--
 arch/arm/kernel/kprobes-arm.c    |  99 ++++++++------
 arch/arm/kernel/kprobes-common.c |  48 ++++---
 arch/arm/kernel/kprobes-test.c   |  10 +-
 arch/arm/kernel/kprobes-thumb.c  | 289 +++++++++++++++++++++------------------
 arch/arm/kernel/kprobes.c        |  20 +--
 arch/arm/kernel/kprobes.h        |  31 ++---
 arch/arm/kernel/probes-arm.c     |  58 ++++----
 arch/arm/kernel/probes-arm.h     |  33 ++---
 arch/arm/kernel/probes-thumb.c   |  44 +++---
 arch/arm/kernel/probes-thumb.h   |  57 ++------
 arch/arm/kernel/probes.c         |  65 +++++----
 arch/arm/kernel/probes.h         |  49 +++----
 14 files changed, 430 insertions(+), 402 deletions(-)

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 30fc11b..73669b8 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <asm/probes.h>
 
 #define __ARCH_WANT_KPROBES_INSN_SLOT
 #define MAX_INSN_SIZE			2
@@ -28,9 +29,8 @@
 #define kretprobe_blacklist_size	0
 
 typedef u32 kprobe_opcode_t;
-struct kprobe;
-#include <asm/probes.h>
 
+struct kprobe;
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned int status;
diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index edf5abe..00a93a2 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -1,20 +1,25 @@
 #ifndef _ASM_PROBES_H
 #define _ASM_PROBES_H
 
-struct kprobe;
+typedef u32 probes_opcode_t;
 
-typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
-typedef unsigned long (kprobe_check_cc)(unsigned long);
-typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
-typedef void (kprobe_insn_fn_t)(void);
+struct arch_specific_insn;
+typedef void (probes_insn_handler_t)(probes_opcode_t, probes_opcode_t *,
+				     struct arch_specific_insn *,
+				     struct pt_regs *);
+typedef unsigned long (probes_check_cc)(unsigned long);
+typedef void (probes_insn_singlestep_t)(probes_opcode_t, probes_opcode_t *,
+					struct arch_specific_insn *,
+					struct pt_regs *);
+typedef void (probes_insn_fn_t)(void);
 
 /* Architecture specific copy of original instruction. */
 struct arch_specific_insn {
-	kprobe_opcode_t			*insn;
-	kprobe_insn_handler_t		*insn_handler;
-	kprobe_check_cc			*insn_check_cc;
-	kprobe_insn_singlestep_t	*insn_singlestep;
-	kprobe_insn_fn_t		*insn_fn;
+	probes_opcode_t			*insn;
+	probes_insn_handler_t		*insn_handler;
+	probes_check_cc			*insn_check_cc;
+	probes_insn_singlestep_t	*insn_singlestep;
+	probes_insn_fn_t		*insn_fn;
 };
 
 #endif
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index 2fe1f47..368f19b 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -62,9 +62,9 @@
 #include <linux/kprobes.h>
 #include <linux/module.h>
 
-#include "kprobes.h"
 #include "probes.h"
 #include "probes-arm.h"
+#include "kprobes.h"
 
 #if  __LINUX_ARM_ARCH__ >= 6
 #define BLX(reg)	"blx	"reg"		\n\t"
@@ -73,12 +73,12 @@
 			"mov	pc, "reg"	\n\t"
 #endif
 
-
-void __kprobes
-emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_ldrdstrd(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = (unsigned long)p->addr + 8;
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = (unsigned long)addr + 8;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -93,7 +93,7 @@ emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 		BLX("%[fn]")
 		: "=r" (rtv), "=r" (rt2v), "=r" (rnv)
 		: "0" (rtv), "1" (rt2v), "2" (rnv), "r" (rmv),
-		  [fn] "r" (p->ainsn.insn_fn)
+		  [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -103,11 +103,12 @@ emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rn] = rnv;
 }
 
-void __kprobes
-emulate_ldr(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_ldr(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = (unsigned long)p->addr + 8;
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = (unsigned long)addr + 8;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -120,7 +121,7 @@ emulate_ldr(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		BLX("%[fn]")
 		: "=r" (rtv), "=r" (rnv)
-		: "1" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "1" (rnv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -133,12 +134,13 @@ emulate_ldr(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rn] = rnv;
 }
 
-void __kprobes
-emulate_str(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_str(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long rtpc = (unsigned long)p->addr + str_pc_offset;
-	unsigned long rnpc = (unsigned long)p->addr + 8;
+	kprobe_opcode_t insn = opcode;
+	unsigned long rtpc = (unsigned long)addr + str_pc_offset;
+	unsigned long rnpc = (unsigned long)addr + 8;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -152,7 +154,7 @@ emulate_str(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		BLX("%[fn]")
 		: "=r" (rnv)
-		: "r" (rtv), "0" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "r" (rtv), "0" (rnv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -160,11 +162,12 @@ emulate_str(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rn] = rnv;
 }
 
-void __kprobes
-emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd12rn16rm0rs8_rwflags(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = (unsigned long)p->addr + 8;
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = (unsigned long)addr + 8;
 	int rd = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -184,7 +187,7 @@ emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -195,10 +198,11 @@ emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd12rn16rm0_rwflags_nopc(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rd = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -214,7 +218,7 @@ emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -222,10 +226,12 @@ emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd16rn12rm0rs8_rwflags_nopc(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rd = (insn >> 16) & 0xf;
 	int rn = (insn >> 12) & 0xf;
 	int rm = insn & 0xf;
@@ -243,7 +249,7 @@ emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -251,10 +257,11 @@ emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-emulate_rd12rm0_noflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd12rm0_noflags_nopc(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rd = (insn >> 12) & 0xf;
 	int rm = insn & 0xf;
 
@@ -264,17 +271,19 @@ emulate_rd12rm0_noflags_nopc(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		BLX("%[fn]")
 		: "=r" (rdv)
-		: "0" (rdv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rdv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
 	regs->uregs[rd] = rdv;
 }
 
-void __kprobes
-emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rdlo = (insn >> 12) & 0xf;
 	int rdhi = (insn >> 16) & 0xf;
 	int rn = insn & 0xf;
@@ -292,7 +301,7 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdlov), "=r" (rdhiv), [cpsr] "=r" (cpsr)
 		: "0" (rdlov), "1" (rdhiv), "r" (rnv), "r" (rmv),
-		  "2" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "2" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -302,10 +311,10 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 }
 
 const union decode_item kprobes_arm_actions[] = {
-	[PROBES_EMULATE_NONE] = {.handler = kprobe_emulate_none},
-	[PROBES_SIMULATE_NOP] = {.handler = kprobe_simulate_nop},
-	[PROBES_PRELOAD_IMM] = {.handler = kprobe_simulate_nop},
-	[PROBES_PRELOAD_REG] = {.handler = kprobe_simulate_nop},
+	[PROBES_EMULATE_NONE] = {.handler = probes_emulate_none},
+	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
+	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
+	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
 	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
 	[PROBES_MRS] = {.handler = simulate_mrs},
 	[PROBES_BRANCH_REG] = {.handler = simulate_blx2bx},
@@ -326,8 +335,8 @@ const union decode_item kprobes_arm_actions[] = {
 	[PROBES_DATA_PROCESSING_IMM] = {
 		.handler = emulate_rd12rn16rm0rs8_rwflags},
 	[PROBES_MOV_HALFWORD] = {.handler = emulate_rd12rm0_noflags_nopc},
-	[PROBES_SEV] = {.handler = kprobe_emulate_none},
-	[PROBES_WFE] = {.handler = kprobe_simulate_nop},
+	[PROBES_SEV] = {.handler = probes_emulate_none},
+	[PROBES_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_SATURATE] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
 	[PROBES_REV] = {.handler = emulate_rd12rm0_noflags_nopc},
 	[PROBES_MMI] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index cea610a..1093f5a 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -15,22 +15,25 @@
 #include <linux/kprobes.h>
 #include <asm/system_info.h>
 
-#include "kprobes.h"
 #include "probes.h"
+#include "kprobes.h"
+
 
 
-static void __kprobes simulate_ldm1stm1(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes simulate_ldm1stm1(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rn = (insn >> 16) & 0xf;
 	int lbit = insn & (1 << 20);
 	int wbit = insn & (1 << 21);
 	int ubit = insn & (1 << 23);
 	int pbit = insn & (1 << 24);
-	long *addr = (long *)regs->uregs[rn];
 	int reg_bit_vector;
 	int reg_count;
 
+	addr = (u32 *)regs->uregs[rn];
 	reg_count = 0;
 	reg_bit_vector = insn & 0xffff;
 	while (reg_bit_vector) {
@@ -60,24 +63,29 @@ static void __kprobes simulate_ldm1stm1(struct kprobe *p, struct pt_regs *regs)
 	}
 }
 
-static void __kprobes simulate_stm1_pc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes simulate_stm1_pc(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	regs->ARM_pc = (long)p->addr + str_pc_offset;
-	simulate_ldm1stm1(p, regs);
-	regs->ARM_pc = (long)p->addr + 4;
+	regs->ARM_pc = (long)addr + str_pc_offset;
+	simulate_ldm1stm1(opcode, addr, asi, regs);
+	regs->ARM_pc = (long)addr + 4;
 }
 
-static void __kprobes simulate_ldm1_pc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes simulate_ldm1_pc(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	simulate_ldm1stm1(p, regs);
+	simulate_ldm1stm1(opcode, addr, asi, regs);
 	load_write_pc(regs->ARM_pc, regs);
 }
 
 static void __kprobes
-emulate_generic_r0_12_noflags(struct kprobe *p, struct pt_regs *regs)
+emulate_generic_r0_12_noflags(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	register void *rregs asm("r1") = regs;
-	register void *rfn asm("lr") = p->ainsn.insn_fn;
+	register void *rfn asm("lr") = asi->insn_fn;
 
 	__asm__ __volatile__ (
 		"stmdb	sp!, {%[regs], r11}	\n\t"
@@ -101,23 +109,27 @@ emulate_generic_r0_12_noflags(struct kprobe *p, struct pt_regs *regs)
 }
 
 static void __kprobes
-emulate_generic_r2_14_noflags(struct kprobe *p, struct pt_regs *regs)
+emulate_generic_r2_14_noflags(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	emulate_generic_r0_12_noflags(p, (struct pt_regs *)(regs->uregs+2));
+	emulate_generic_r0_12_noflags(opcode, addr, asi,
+		(struct pt_regs *)(regs->uregs+2));
 }
 
 static void __kprobes
-emulate_ldm_r3_15(struct kprobe *p, struct pt_regs *regs)
+emulate_ldm_r3_15(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	emulate_generic_r0_12_noflags(p, (struct pt_regs *)(regs->uregs+3));
+	emulate_generic_r0_12_noflags(opcode, addr, asi,
+		(struct pt_regs *)(regs->uregs+3));
 	load_write_pc(regs->ARM_pc, regs);
 }
 
-enum kprobe_insn __kprobes
+enum probes_insn __kprobes
 kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		const struct decode_header *h)
 {
-	kprobe_insn_handler_t *handler = 0;
+	probes_insn_handler_t *handler = 0;
 	unsigned reglist = insn & 0xffff;
 	int is_ldm = insn & 0x100000;
 	int rn = (insn >> 16) & 0xf;
diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 2144df1..710bae8 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -204,8 +204,10 @@
 
 #include <asm/opcodes.h>
 
-#include "kprobes.h"
 #include "probes.h"
+#include "probes-arm.h"
+#include "probes-thumb.h"
+#include "kprobes.h"
 #include "kprobes-test.h"
 
 
@@ -1613,7 +1615,7 @@ static int __init run_all_tests(void)
 		goto out;
 
 	pr_info("ARM instruction simulation\n");
-	ret = run_test_cases(kprobe_arm_test_cases, kprobe_decode_arm_table);
+	ret = run_test_cases(kprobe_arm_test_cases, probes_decode_arm_table);
 	if (ret)
 		goto out;
 
@@ -1636,13 +1638,13 @@ static int __init run_all_tests(void)
 
 	pr_info("16-bit Thumb instruction simulation\n");
 	ret = run_test_cases(kprobe_thumb16_test_cases,
-				kprobe_decode_thumb16_table);
+				probes_decode_thumb16_table);
 	if (ret)
 		goto out;
 
 	pr_info("32-bit Thumb instruction simulation\n");
 	ret = run_test_cases(kprobe_thumb32_test_cases,
-				kprobe_decode_thumb32_table);
+				probes_decode_thumb32_table);
 	if (ret)
 		goto out;
 #endif
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 7cc5286..1b44533 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -12,9 +12,9 @@
 #include <linux/kprobes.h>
 #include <linux/module.h>
 
-#include "kprobes.h"
 #include "probes.h"
 #include "probes-thumb.h"
+#include "kprobes.h"
 
 /* These emulation encodings are functionally equivalent... */
 #define t32_emulate_rd8rn16rm0ra12_noflags \
@@ -26,18 +26,19 @@
  * We subtract one because the address will have bit zero set to indicate
  * a pointer to thumb code.
  */
-static inline unsigned long __kprobes thumb_probe_pc(struct kprobe *p)
+static inline unsigned long __kprobes thumb_probe_pc(probes_opcode_t *addr)
 {
-	return (unsigned long)p->addr - 1 + 4;
+	return (unsigned long) addr - 1 + 4;
 }
 
 /* t32 thumb actions */
 
-void __kprobes
-t32_simulate_table_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_table_branch(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
 
@@ -53,20 +54,22 @@ t32_simulate_table_branch(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = pc + 2 * halfwords;
 }
 
-void __kprobes
-t32_simulate_mrs(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_mrs(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rd = (insn >> 8) & 0xf;
 	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
 	regs->uregs[rd] = regs->ARM_cpsr & mask;
 }
 
-void __kprobes
-t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_cond_branch(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 
 	long offset = insn & 0x7ff;		/* imm11 */
 	offset += (insn & 0x003f0000) >> 5;	/* imm6 */
@@ -77,21 +80,22 @@ t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
 	int cc = (insn >> 22) & 0xf;
-	asi->insn_check_cc = kprobe_condition_checks[cc];
+	asi->insn_check_cc = probes_condition_checks[cc];
 	asi->insn_handler = t32_simulate_cond_branch;
 	return INSN_GOOD_NO_SLOT;
 }
 
-void __kprobes
-t32_simulate_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_branch(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 
 	long offset = insn & 0x7ff;		/* imm11 */
 	offset += (insn & 0x03ff0000) >> 5;	/* imm10 */
@@ -104,7 +108,7 @@ t32_simulate_branch(struct kprobe *p, struct pt_regs *regs)
 
 	if (insn & (1 << 14)) {
 		/* BL or BLX */
-		regs->ARM_lr = (unsigned long)p->addr + 4;
+		regs->ARM_lr = (unsigned long) addr + 4;
 		if (!(insn & (1 << 12))) {
 			/* BLX so switch to ARM mode */
 			regs->ARM_cpsr &= ~PSR_T_BIT;
@@ -115,11 +119,12 @@ t32_simulate_branch(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-void __kprobes
-t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_ldr_literal(probes_opcode_t opcode, probes_opcode_t *pcaddr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long addr = thumb_probe_pc(p) & ~3;
+	kprobe_opcode_t insn = opcode;
+	unsigned long addr = thumb_probe_pc(pcaddr) & ~3;
 	int rt = (insn >> 12) & 0xf;
 	unsigned long rtv;
 
@@ -153,11 +158,11 @@ t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
 	regs->uregs[rt] = rtv;
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
-	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi, d);
+	enum probes_insn ret = kprobe_decode_ldmstm(insn, asi, d);
 
 	/* Fixup modified instruction to have halfwords in correct order...*/
 	insn = asi->insn[0];
@@ -167,11 +172,12 @@ t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return ret;
 }
 
-void __kprobes
-t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_ldrdstrd(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p) & ~3;
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr) & ~3;
 	int rt1 = (insn >> 12) & 0xf;
 	int rt2 = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -184,7 +190,7 @@ t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		"blx    %[fn]"
 		: "=r" (rt1v), "=r" (rt2v), "=r" (rnv)
-		: "0" (rt1v), "1" (rt2v), "2" (rnv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rt1v), "1" (rt2v), "2" (rnv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -194,10 +200,11 @@ t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 	regs->uregs[rt2] = rt2v;
 }
 
-void __kprobes
-t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_ldrstr(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -209,7 +216,7 @@ t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		"blx    %[fn]"
 		: "=r" (rtv), "=r" (rnv)
-		: "0" (rtv), "1" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rtv), "1" (rnv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -220,10 +227,11 @@ t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rt] = rtv;
 }
 
-void __kprobes
-t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_rd8rn16rm0_rwflags(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rd = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -239,7 +247,7 @@ t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -247,11 +255,12 @@ t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-t32_emulate_rd8pc16_noflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_rd8pc16_noflags(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 	int rd = (insn >> 8) & 0xf;
 
 	register unsigned long rdv asm("r1") = regs->uregs[rd];
@@ -260,17 +269,18 @@ t32_emulate_rd8pc16_noflags(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		"blx    %[fn]"
 		: "=r" (rdv)
-		: "0" (rdv), "r" (rnv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rdv), "r" (rnv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
 	regs->uregs[rd] = rdv;
 }
 
-void __kprobes
-t32_emulate_rd8rn16_noflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_rd8rn16_noflags(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rd = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 
@@ -280,17 +290,19 @@ t32_emulate_rd8rn16_noflags(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		"blx    %[fn]"
 		: "=r" (rdv)
-		: "0" (rdv), "r" (rnv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rdv), "r" (rnv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
 	regs->uregs[rd] = rdv;
 }
 
-void __kprobes
-t32_emulate_rdlo12rdhi8rn16rm0_noflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_rdlo12rdhi8rn16rm0_noflags(probes_opcode_t opcode,
+		probes_opcode_t *addr, struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rdlo = (insn >> 12) & 0xf;
 	int rdhi = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -305,7 +317,7 @@ t32_emulate_rdlo12rdhi8rn16rm0_noflags(struct kprobe *p, struct pt_regs *regs)
 		"blx    %[fn]"
 		: "=r" (rdlov), "=r" (rdhiv)
 		: "0" (rdlov), "1" (rdhiv), "r" (rnv), "r" (rmv),
-		  [fn] "r" (p->ainsn.insn_fn)
+		  [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -314,34 +326,37 @@ t32_emulate_rdlo12rdhi8rn16rm0_noflags(struct kprobe *p, struct pt_regs *regs)
 }
 /* t16 thumb actions */
 
-void __kprobes
-t16_simulate_bxblx(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_bxblx(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 	int rm = (insn >> 3) & 0xf;
 	unsigned long rmv = (rm == 15) ? pc : regs->uregs[rm];
 
 	if (insn & (1 << 7)) /* BLX ? */
-		regs->ARM_lr = (unsigned long)p->addr + 2;
+		regs->ARM_lr = (unsigned long) addr + 2;
 
 	bx_write_pc(rmv, regs);
 }
 
-void __kprobes
-t16_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_ldr_literal(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long* base = (unsigned long *)(thumb_probe_pc(p) & ~3);
+	kprobe_opcode_t insn = opcode;
+	unsigned long *base = (unsigned long *)(thumb_probe_pc(addr) & ~3);
 	long index = insn & 0xff;
 	int rt = (insn >> 8) & 0x7;
 	regs->uregs[rt] = base[index];
 }
 
-void __kprobes
-t16_simulate_ldrstr_sp_relative(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_ldrstr_sp_relative(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	unsigned long* base = (unsigned long *)regs->ARM_sp;
 	long index = insn & 0xff;
 	int rt = (insn >> 8) & 0x7;
@@ -351,21 +366,23 @@ t16_simulate_ldrstr_sp_relative(struct kprobe *p, struct pt_regs *regs)
 		base[index] = regs->uregs[rt];
 }
 
-void __kprobes
-t16_simulate_reladr(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_reladr(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	unsigned long base = (insn & 0x800) ? regs->ARM_sp
-					    : (thumb_probe_pc(p) & ~3);
+					    : (thumb_probe_pc(addr) & ~3);
 	long offset = insn & 0xff;
 	int rt = (insn >> 8) & 0x7;
 	regs->uregs[rt] = base + offset * 4;
 }
 
-void __kprobes
-t16_simulate_add_sp_imm(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_add_sp_imm(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	long imm = insn & 0x7f;
 	if (insn & 0x80) /* SUB */
 		regs->ARM_sp -= imm * 4;
@@ -373,22 +390,24 @@ t16_simulate_add_sp_imm(struct kprobe *p, struct pt_regs *regs)
 		regs->ARM_sp += imm * 4;
 }
 
-void __kprobes
-t16_simulate_cbz(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_cbz(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	int rn = insn & 0x7;
 	kprobe_opcode_t nonzero = regs->uregs[rn] ? insn : ~insn;
 	if (nonzero & 0x800) {
 		long i = insn & 0x200;
 		long imm5 = insn & 0xf8;
-		unsigned long pc = thumb_probe_pc(p);
+		unsigned long pc = thumb_probe_pc(addr);
 		regs->ARM_pc = pc + (i >> 3) + (imm5 >> 2);
 	}
 }
 
-void __kprobes
-t16_simulate_it(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_it(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	/*
 	 * The 8 IT state bits are split into two parts in CPSR:
@@ -396,7 +415,7 @@ t16_simulate_it(struct kprobe *p, struct pt_regs *regs)
 	 *	ITSTATE<7:2> are in CPSR<15:10>
 	 * The new IT state is in the lower byte of insn.
 	 */
-	kprobe_opcode_t insn = p->opcode;
+	kprobe_opcode_t insn = opcode;
 	unsigned long cpsr = regs->ARM_cpsr;
 	cpsr &= ~PSR_IT_MASK;
 	cpsr |= (insn & 0xfc) << 8;
@@ -404,53 +423,57 @@ t16_simulate_it(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = cpsr;
 }
 
-void __kprobes
-t16_singlestep_it(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_singlestep_it(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
-	t16_simulate_it(p, regs);
+	t16_simulate_it(opcode, addr, asi, regs);
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
 	asi->insn_singlestep = t16_singlestep_it;
 	return INSN_GOOD_NO_SLOT;
 }
 
-void __kprobes
-t16_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_cond_branch(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 	long offset = insn & 0x7f;
 	offset -= insn & 0x80; /* Apply sign bit */
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
 	int cc = (insn >> 8) & 0xf;
-	asi->insn_check_cc = kprobe_condition_checks[cc];
+	asi->insn_check_cc = probes_condition_checks[cc];
 	asi->insn_handler = t16_simulate_cond_branch;
 	return INSN_GOOD_NO_SLOT;
 }
 
-void __kprobes
-t16_simulate_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_branch(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 	long offset = insn & 0x3ff;
 	offset -= insn & 0x400; /* Apply sign bit */
 	regs->ARM_pc = pc + (offset * 2);
 }
 
 static unsigned long __kprobes
-t16_emulate_loregs(struct kprobe *p, struct pt_regs *regs)
+t16_emulate_loregs(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long oldcpsr = regs->ARM_cpsr;
 	unsigned long newcpsr;
@@ -463,7 +486,7 @@ t16_emulate_loregs(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[newcpsr], cpsr	\n\t"
 		: [newcpsr] "=r" (newcpsr)
 		: [oldcpsr] "r" (oldcpsr), [regs] "r" (regs),
-		  [fn] "r" (p->ainsn.insn_fn)
+		  [fn] "r" (asi->insn_fn)
 		: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
 		  "lr", "memory", "cc"
 		);
@@ -471,25 +494,28 @@ t16_emulate_loregs(struct kprobe *p, struct pt_regs *regs)
 	return (oldcpsr & ~APSR_MASK) | (newcpsr & APSR_MASK);
 }
 
-void __kprobes
-t16_emulate_loregs_rwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_loregs_rwflags(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	regs->ARM_cpsr = t16_emulate_loregs(p, regs);
+	regs->ARM_cpsr = t16_emulate_loregs(opcode, addr, asi, regs);
 }
 
-void __kprobes
-t16_emulate_loregs_noitrwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_loregs_noitrwflags(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	unsigned long cpsr = t16_emulate_loregs(p, regs);
+	unsigned long cpsr = t16_emulate_loregs(opcode, addr, asi, regs);
 	if (!in_it_block(cpsr))
 		regs->ARM_cpsr = cpsr;
 }
 
-void __kprobes
-t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_hiregs(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	kprobe_opcode_t insn = opcode;
+	unsigned long pc = thumb_probe_pc(addr);
 	int rdn = (insn & 0x7) | ((insn & 0x80) >> 4);
 	int rm = (insn >> 3) & 0xf;
 
@@ -505,7 +531,7 @@ t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
 		"blx    %[fn]			\n\t"
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdnv), [cpsr] "=r" (cpsr)
-		: "0" (rdnv), "r" (rmv), "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rdnv), "r" (rmv), "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -516,9 +542,9 @@ t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
 	insn &= ~0x00ff;
 	insn |= 0x001; /* Set Rdn = R1 and Rm = R0 */
@@ -527,8 +553,9 @@ t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD;
 }
 
-void __kprobes
-t16_emulate_push(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_push(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
 		"ldr	r9, [%[regs], #13*4]	\n\t"
@@ -537,15 +564,15 @@ t16_emulate_push(struct kprobe *p, struct pt_regs *regs)
 		"blx	%[fn]			\n\t"
 		"str	r9, [%[regs], #13*4]	\n\t"
 		:
-		: [regs] "r" (regs), [fn] "r" (p->ainsn.insn_fn)
+		: [regs] "r" (regs), [fn] "r" (asi->insn_fn)
 		: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9",
 		  "lr", "memory", "cc"
 		);
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
 	/*
 	 * To simulate a PUSH we use a Thumb-2 "STMDB R9!, {registers}"
@@ -558,8 +585,9 @@ t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD;
 }
 
-void __kprobes
-t16_emulate_pop_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_pop_nopc(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
 		"ldr	r9, [%[regs], #13*4]	\n\t"
@@ -568,14 +596,15 @@ t16_emulate_pop_nopc(struct kprobe *p, struct pt_regs *regs)
 		"stmia	%[regs], {r0-r7}	\n\t"
 		"str	r9, [%[regs], #13*4]	\n\t"
 		:
-		: [regs] "r" (regs), [fn] "r" (p->ainsn.insn_fn)
+		: [regs] "r" (regs), [fn] "r" (asi->insn_fn)
 		: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r9",
 		  "lr", "memory", "cc"
 		);
 }
 
-void __kprobes
-t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_pop_pc(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	register unsigned long pc asm("r8");
 
@@ -586,7 +615,7 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
 		"stmia	%[regs], {r0-r7}	\n\t"
 		"str	r9, [%[regs], #13*4]	\n\t"
 		: "=r" (pc)
-		: [regs] "r" (regs), [fn] "r" (p->ainsn.insn_fn)
+		: [regs] "r" (regs), [fn] "r" (asi->insn_fn)
 		: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r9",
 		  "lr", "memory", "cc"
 		);
@@ -594,9 +623,9 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
 	bx_write_pc(pc, regs);
 }
 
-enum kprobe_insn __kprobes
+static enum probes_insn __kprobes
 t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		const struct decode_header *d)
+		struct decode_header *d)
 {
 	/*
 	 * To simulate a POP we use a Thumb-2 "LDMDB R9!, {registers}"
@@ -616,8 +645,8 @@ const union decode_item kprobes_t16_actions[] = {
 	[PROBES_T16_SIGN_EXTEND] = {.handler = t16_emulate_loregs_rwflags},
 	[PROBES_T16_PUSH] = {.decoder = t16_decode_push},
 	[PROBES_T16_POP] = {.decoder = t16_decode_pop},
-	[PROBES_T16_SEV] = {.handler = kprobe_emulate_none},
-	[PROBES_T16_WFE] = {.handler = kprobe_simulate_nop},
+	[PROBES_T16_SEV] = {.handler = probes_emulate_none},
+	[PROBES_T16_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_T16_IT] = {.decoder = t16_decode_it},
 	[PROBES_T16_CMP] = {.handler = t16_emulate_loregs_rwflags},
 	[PROBES_T16_ADDSUB] = {.handler = t16_emulate_loregs_noitrwflags},
@@ -647,12 +676,12 @@ const union decode_item kprobes_t32_actions[] = {
 	[PROBES_T32_MOVW] = {.handler = t32_emulate_rd8rn16_noflags},
 	[PROBES_T32_SAT] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_BITFIELD] = {.handler = t32_emulate_rd8rn16_noflags},
-	[PROBES_T32_SEV] = {.handler = kprobe_emulate_none},
-	[PROBES_T32_WFE] = {.handler = kprobe_simulate_nop},
+	[PROBES_T32_SEV] = {.handler = probes_emulate_none},
+	[PROBES_T32_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_T32_MRS] = {.handler = t32_simulate_mrs},
 	[PROBES_T32_BRANCH_COND] = {.decoder = t32_decode_cond_branch},
 	[PROBES_T32_BRANCH] = {.handler = t32_simulate_branch},
-	[PROBES_T32_PLDI] = {.handler = kprobe_simulate_nop},
+	[PROBES_T32_PLDI] = {.handler = probes_simulate_nop},
 	[PROBES_T32_LDR_LIT] = {.handler = t32_simulate_ldr_literal},
 	[PROBES_T32_LDRSTR] = {.handler = t32_emulate_ldrstr},
 	[PROBES_T32_SIGN_EXTEND] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index c72d552..30c74c0 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -28,8 +28,10 @@
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
 
-#include "kprobes.h"
 #include "probes.h"
+#include "probes-arm.h"
+#include "probes-thumb.h"
+#include "kprobes.h"
 #include "patch.h"
 
 #define MIN_STACK_SIZE(addr) 				\
@@ -68,10 +70,10 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (is_wide_instruction(insn)) {
 		insn <<= 16;
 		insn |= ((u16 *)addr)[1];
-		decode_insn = thumb32_kprobe_decode_insn;
+		decode_insn = thumb32_probes_decode_insn;
 		actions = kprobes_t32_actions;
 	} else {
-		decode_insn = thumb16_kprobe_decode_insn;
+		decode_insn = thumb16_probes_decode_insn;
 		actions = kprobes_t16_actions;
 	}
 #else /* !CONFIG_THUMB2_KERNEL */
@@ -79,15 +81,15 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (addr & 0x3)
 		return -EINVAL;
 	insn = *p->addr;
-	decode_insn = arm_kprobe_decode_insn;
+	decode_insn = arm_probes_decode_insn;
 	actions = kprobes_arm_actions;
 #endif
 
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)
-		(insn, &p->ainsn, (struct decode_header *) actions)) {
+	switch ((*decode_insn)(insn, &p->ainsn,
+			       false, actions)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
@@ -99,7 +101,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 			p->ainsn.insn[is] = tmp_insn[is];
 		flush_insns(p->ainsn.insn,
 				sizeof(p->ainsn.insn[0]) * MAX_INSN_SIZE);
-		p->ainsn.insn_fn = (kprobe_insn_fn_t *)
+		p->ainsn.insn_fn = (probes_insn_fn_t *)
 					((uintptr_t)p->ainsn.insn | thumb);
 		break;
 
@@ -204,7 +206,7 @@ singlestep_skip(struct kprobe *p, struct pt_regs *regs)
 static inline void __kprobes
 singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-	p->ainsn.insn_singlestep(p, regs);
+	p->ainsn.insn_singlestep(p->opcode, p->addr, &p->ainsn, regs);
 }
 
 /*
@@ -614,7 +616,7 @@ static struct undef_hook kprobes_arm_break_hook = {
 
 int __init arch_init_kprobes()
 {
-	arm_kprobe_decode_init();
+	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL
 	register_undef_hook(&kprobes_thumb16_break_hook);
 	register_undef_hook(&kprobes_thumb32_break_hook);
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 77e4374..c13f3b1 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -27,36 +27,25 @@
 #define KPROBE_THUMB16_BREAKPOINT_INSTRUCTION	0xde18
 #define KPROBE_THUMB32_BREAKPOINT_INSTRUCTION	0xf7f0a018
 
-struct decode_header;
+enum probes_insn __kprobes
+kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		const struct decode_header *h);
 
-enum kprobe_insn {
-	INSN_REJECTED,
-	INSN_GOOD,
-	INSN_GOOD_NO_SLOT
-};
-
-typedef enum kprobe_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
-		struct arch_specific_insn *,
-		const struct decode_header *actions);
+typedef enum probes_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
+			struct arch_specific_insn *,
+			bool,
+			const union decode_item *);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
-enum kprobe_insn thumb16_kprobe_decode_insn(kprobe_opcode_t,
-						struct arch_specific_insn *,
-						const struct decode_header *);
-enum kprobe_insn thumb32_kprobe_decode_insn(kprobe_opcode_t,
-						struct arch_specific_insn *,
-						const struct decode_header *);
+extern const union decode_item kprobes_t32_actions[];
+extern const union decode_item kprobes_t16_actions[];
 
 #else /* !CONFIG_THUMB2_KERNEL */
 
-enum kprobe_insn arm_kprobe_decode_insn(kprobe_opcode_t,
-					struct arch_specific_insn *,
-					const struct decode_header *);
+extern const union decode_item kprobes_arm_actions[];
 
 #endif
 
-void __init arm_kprobe_decode_init(void);
-
 
 #endif /* _ARM_KERNEL_KPROBES_H */
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 812be68..b093079 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -18,9 +18,8 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 
-#include <linux/kprobes.h>
-#include "kprobes.h"
 #include "probes.h"
+#include "asm/probes.h"
 #include "probes-arm.h"
 
 #define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
@@ -57,10 +56,11 @@
  * read and write of flags.
  */
 
-void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_bbl(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	long iaddr = (long)p->addr;
+	probes_opcode_t insn = opcode;
+	long iaddr = (long) addr;
 	int disp  = branch_displacement(insn);
 
 	if (insn & (1 << 24))
@@ -69,10 +69,11 @@ void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = iaddr + 8 + disp;
 }
 
-void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_blx1(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	long iaddr = (long)p->addr;
+	probes_opcode_t insn = opcode;
+	long iaddr = (long) addr;
 	int disp = branch_displacement(insn);
 
 	regs->ARM_lr = iaddr + 4;
@@ -80,14 +81,15 @@ void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr |= PSR_T_BIT;
 }
 
-void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_blx2bx(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	probes_opcode_t insn = opcode;
 	int rm = insn & 0xf;
 	long rmv = regs->uregs[rm];
 
 	if (insn & (1 << 5))
-		regs->ARM_lr = (long)p->addr + 4;
+		regs->ARM_lr = (long) addr + 4;
 
 	regs->ARM_pc = rmv & ~0x1;
 	regs->ARM_cpsr &= ~PSR_T_BIT;
@@ -95,15 +97,17 @@ void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs)
 		regs->ARM_cpsr |= PSR_T_BIT;
 }
 
-void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_mrs(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
+	probes_opcode_t insn = opcode;
 	int rd = (insn >> 12) & 0xf;
 	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
 	regs->uregs[rd] = regs->ARM_cpsr & mask;
 }
 
-void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_mov_ipsp(probes_opcode_t opcode, probes_opcode_t *addr,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->uregs[12] = regs->uregs[13];
 }
@@ -609,7 +613,7 @@ static const union decode_item arm_cccc_100x_table[] = {
 	DECODE_END
 };
 
-const union decode_item kprobe_decode_arm_table[] = {
+const union decode_item probes_decode_arm_table[] = {
 	/*
 	 * Unconditional instructions
 	 *			1111 xxxx xxxx xxxx xxxx xxxx xxxx xxxx
@@ -700,13 +704,15 @@ const union decode_item kprobe_decode_arm_table[] = {
 	DECODE_END
 };
 #ifdef CONFIG_ARM_KPROBES_TEST_MODULE
-EXPORT_SYMBOL_GPL(kprobe_decode_arm_table);
+EXPORT_SYMBOL_GPL(probes_decode_arm_table);
 #endif
 
-static void __kprobes arm_singlestep(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes arm_singlestep(probes_opcode_t opcode,
+		probes_opcode_t *addr, struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
-	p->ainsn.insn_handler(p, regs);
+	asi->insn_handler(opcode, addr, asi, regs);
 }
 
 /* Return:
@@ -721,12 +727,16 @@ static void __kprobes arm_singlestep(struct kprobe *p, struct pt_regs *regs)
  *   if the work was put into it, but low return considering they
  *   should also be very rare.
  */
-enum kprobe_insn __kprobes
-arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		       const struct decode_header *actions)
+enum probes_insn __kprobes
+arm_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		bool usermode, const union decode_item *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
-	asi->insn_check_cc = kprobe_condition_checks[insn>>28];
-	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false,
-				  (const union decode_item *) actions);
+	asi->insn_check_cc = probes_condition_checks[insn>>28];
+	return probes_decode_insn(insn, asi, probes_decode_arm_table, false,
+			usermode, actions);
 }
+
+#ifdef CONFIG_ARM_KPROBES_TEST_MODULE
+EXPORT_SYMBOL_GPL(probes_decode_arm_table);
+#endif
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index f8e0f7a..55fe7da 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -52,24 +52,21 @@ enum probes_arm_action {
 	PROBES_LDMSTM
 };
 
-void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs);
+void __kprobes simulate_bbl(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_blx1(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_blx2bx(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_mrs(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_mov_ipsp(probes_opcode_t opcode, probes_opcode_t *addr,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
 
-void __kprobes emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs);
-void __kprobes emulate_ldr(struct kprobe *p, struct pt_regs *regs);
-void __kprobes emulate_str(struct kprobe *p, struct pt_regs *regs);
-void __kprobes emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes emulate_rd12rm0_noflags_nopc(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p,
-	struct pt_regs *regs);
+extern const union decode_item probes_decode_arm_table[];
+
+enum probes_insn arm_probes_decode_insn(probes_opcode_t,
+		struct arch_specific_insn *, bool usermode,
+		const union decode_item *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 5d6048c..4504283 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-thumb.c
+ * arch/arm/kernel/probes-thumb.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -9,10 +9,8 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kprobes.h>
 #include <linux/module.h>
 
-#include "kprobes.h"
 #include "probes.h"
 #include "probes-thumb.h"
 
@@ -553,7 +551,7 @@ static const union decode_item t32_table_1111_1011_1[] = {
 	DECODE_END
 };
 
-const union decode_item kprobe_decode_thumb32_table[] = {
+const union decode_item probes_decode_thumb32_table[] = {
 
 	/*
 	 * Load/store multiple instructions
@@ -642,7 +640,7 @@ const union decode_item kprobe_decode_thumb32_table[] = {
 	DECODE_END
 };
 #ifdef CONFIG_ARM_KPROBES_TEST_MODULE
-EXPORT_SYMBOL_GPL(kprobe_decode_thumb32_table);
+EXPORT_SYMBOL_GPL(probes_decode_thumb32_table);
 #endif
 static const union decode_item t16_table_1011[] = {
 	/* Miscellaneous 16-bit instructions		    */
@@ -696,7 +694,7 @@ static const union decode_item t16_table_1011[] = {
 	DECODE_END
 };
 
-const union decode_item kprobe_decode_thumb16_table[] = {
+const union decode_item probes_decode_thumb16_table[] = {
 
 	/*
 	 * Shift (immediate), add, subtract, move, and compare
@@ -836,40 +834,44 @@ const union decode_item kprobe_decode_thumb16_table[] = {
 static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 {
 	if (unlikely(in_it_block(cpsr)))
-		return kprobe_condition_checks[current_cond(cpsr)](cpsr);
+		return probes_condition_checks[current_cond(cpsr)](cpsr);
 	return true;
 }
 
-static void __kprobes thumb16_singlestep(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes thumb16_singlestep(probes_opcode_t opcode,
+		probes_opcode_t *addr, struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
-	p->ainsn.insn_handler(p, regs);
+	asi->insn_handler(opcode, addr, asi, regs);
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
-static void __kprobes thumb32_singlestep(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
+		probes_opcode_t *addr, struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
-	p->ainsn.insn_handler(p, regs);
+	asi->insn_handler(opcode, addr, asi, regs);
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
-enum kprobe_insn __kprobes
-thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-			   const struct decode_header *actions)
+enum probes_insn __kprobes
+thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+			   bool usermode, const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
-	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb16_table, true,
-				  (const union decode_item *) actions);
+	return probes_decode_insn(insn, asi, probes_decode_thumb16_table, true,
+				  usermode, actions);
 }
 
-enum kprobe_insn __kprobes
-thumb32_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-			   const struct decode_header *actions)
+enum probes_insn __kprobes
+thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+			   bool usermode, const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
-	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb32_table, true,
-				  (const union decode_item *) actions);
+	return probes_decode_insn(insn, asi, probes_decode_thumb32_table, true,
+				  usermode, actions);
 }
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index d424dd638..ceda36e 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -82,55 +82,14 @@ enum probes_t16_action {
 	PROBES_T16_BRANCH
 };
 
-void __kprobes t16_simulate_bxblx(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_simulate_ldrstr_sp_relative(struct kprobe *p,
-		struct pt_regs *regs);
-void __kprobes t16_simulate_reladr(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_simulate_add_sp_imm(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_simulate_cbz(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_simulate_it(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_singlestep_it(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_it(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const const struct decode_header *d);
-void __kprobes t16_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_cond_branch(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const const struct decode_header *d);
-void __kprobes t16_simulate_branch(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_emulate_loregs_rwflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t16_emulate_loregs_noitrwflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_hiregs(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const const struct decode_header *d);
-void __kprobes t16_emulate_push(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_push(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const const struct decode_header *d);
-void __kprobes t16_emulate_pop_nopc(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_pop(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const struct decode_header *d);
+extern const union decode_item probes_decode_thumb32_table[];
+extern const union decode_item probes_decode_thumb16_table[];
 
-void __kprobes t32_simulate_table_branch(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t32_simulate_mrs(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t32_decode_cond_branch(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const const struct decode_header *d);
-void __kprobes t32_simulate_branch(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t32_decode_ldmstm(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, const const struct decode_header *d);
-void __kprobes t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t32_emulate_rd8pc16_noflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t32_emulate_rd8rn16_noflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t32_emulate_rdlo12rdhi8rn16rm0_noflags(struct kprobe *p,
-	struct pt_regs *regs);
+enum probes_insn __kprobes
+thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		   bool usermode, const union decode_item *actions);
+enum probes_insn __kprobes
+thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		   bool usermode, const union decode_item *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index cdfb3c5..5a17af1 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -15,7 +15,6 @@
 #include <linux/kprobes.h>
 #include <asm/system_info.h>
 
-#include "kprobes.h"
 #include "probes.h"
 
 
@@ -75,7 +74,7 @@ void __init test_alu_write_pc_interworking(void)
 #endif /* !test_alu_write_pc_interworking */
 
 
-void __init arm_kprobe_decode_init(void)
+void __init arm_probes_decode_init(void)
 {
 	find_str_pc_offset();
 	test_load_write_pc_interworking();
@@ -166,7 +165,7 @@ static unsigned long __kprobes __check_al(unsigned long cpsr)
 	return true;
 }
 
-kprobe_check_cc * const kprobe_condition_checks[16] = {
+probes_check_cc * const probes_condition_checks[16] = {
 	&__check_eq, &__check_ne, &__check_cs, &__check_cc,
 	&__check_mi, &__check_pl, &__check_vs, &__check_vc,
 	&__check_hi, &__check_ls, &__check_ge, &__check_lt,
@@ -174,13 +173,17 @@ kprobe_check_cc * const kprobe_condition_checks[16] = {
 };
 
 
-void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs)
+void __kprobes probes_simulate_nop(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
 }
 
-void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs)
+void __kprobes probes_emulate_none(probes_opcode_t opcode,
+	probes_opcode_t *addr, struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	p->ainsn.insn_fn();
+	asi->insn_fn();
 }
 
 /*
@@ -190,9 +193,9 @@ void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs)
  * unconditional as the condition code will already be checked before any
  * emulation handler is called.
  */
-static kprobe_opcode_t __kprobes
-prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-								bool thumb)
+static probes_opcode_t __kprobes
+prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+			bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
 	if (thumb) {
@@ -216,8 +219,8 @@ prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
  * prepare_emulated_insn
  */
 static void  __kprobes
-set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-								bool thumb)
+set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+			bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
 	if (thumb) {
@@ -252,14 +255,14 @@ set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
  * non-zero value, the corresponding nibble in pinsn is validated and modified
  * according to the type.
  */
-static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs)
+static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
 {
-	kprobe_opcode_t insn = *pinsn;
-	kprobe_opcode_t mask = 0xf; /* Start at least significant nibble */
+	probes_opcode_t insn = *pinsn;
+	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
 
 	for (; regs != 0; regs >>= 4, mask <<= 4) {
 
-		kprobe_opcode_t new_bits = INSN_NEW_BITS;
+		probes_opcode_t new_bits = INSN_NEW_BITS;
 
 		switch (regs & 0xf) {
 
@@ -316,9 +319,16 @@ static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs)
 		/* Replace value of nibble with new register number... */
 		insn &= ~mask;
 		insn |= new_bits & mask;
+		if (modify) {
+			/* Replace value of nibble with new register number */
+			insn &= ~mask;
+			insn |= new_bits & mask;
+		}
 	}
 
-	*pinsn = insn;
+	if (modify)
+		*pinsn = insn;
+
 	return true;
 
 reject:
@@ -335,7 +345,7 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 };
 
 /*
- * kprobe_decode_insn operates on data tables in order to decode an ARM
+ * probes_decode_insn operates on data tables in order to decode an ARM
  * architecture instruction onto which a kprobe has been placed.
  *
  * These instruction decoding tables are a concatenation of entries each
@@ -378,15 +388,16 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
  *
  */
 int __kprobes
-kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 				const union decode_item *table, bool thumb,
-				const union decode_item *actions)
+				bool usermode, const union decode_item *actions)
 {
-	const struct decode_header *h = (struct decode_header *)table;
-	const struct decode_header *next;
+	struct decode_header *h = (struct decode_header *)table;
+	struct decode_header *next;
 	bool matched = false;
 
-	insn = prepare_emulated_insn(insn, asi, thumb);
+	if (!usermode)
+		insn = prepare_emulated_insn(insn, asi, thumb);
 
 	for (;; h = next) {
 		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
@@ -401,7 +412,7 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		if (!matched && (insn & h->mask.bits) != h->value.bits)
 			continue;
 
-		if (!decode_regs(&insn, regs))
+		if (!decode_regs(&insn, regs, !usermode))
 			return INSN_REJECTED;
 
 		switch (type) {
@@ -414,7 +425,8 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_CUSTOM: {
 			struct decode_custom *d = (struct decode_custom *)h;
-			return actions[d->decoder.bits].decoder(insn, asi, h);
+			return actions[d->decoder.bits].decoder(insn,
+					asi, h);
 		}
 
 		case DECODE_TYPE_SIMULATE: {
@@ -425,6 +437,11 @@ kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_EMULATE: {
 			struct decode_emulate *d = (struct decode_emulate *)h;
+
+			if (usermode)
+				return actions[d->handler.bits].decoder(insn,
+								asi, h);
+
 			asi->insn_handler = actions[d->handler.bits].handler;
 			set_emulated_insn(insn, asi, thumb);
 			return INSN_GOOD;
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index ad87d68..0fc8745 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -19,7 +19,11 @@
 #ifndef _ARM_KERNEL_PROBES_H
 #define  _ARM_KERNEL_PROBES_H
 
-#include <linux/kprobes.h>
+#include <asm/probes.h>
+
+void __init arm_probes_decode_init(void);
+
+extern probes_check_cc * const probes_condition_checks[16];
 
 #if __LINUX_ARM_ARCH__ >= 7
 
@@ -126,14 +130,6 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
 		regs->ARM_pc = pcv;
 }
 
-
-void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs);
-void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs);
-
-enum kprobe_insn __kprobes
-kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		     const struct decode_header *h);
-
 /*
  * Test if load/store instructions writeback the address register.
  * if P (bit 24) == 0 or W (bit 21) == 1
@@ -142,7 +138,7 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 /*
  * The following definitions and macros are used to build instruction
- * decoding tables for use by kprobe_decode_insn.
+ * decoding tables for use by probes_decode_insn.
  *
  * These tables are a concatenation of entries each of which consist of one of
  * the decode_* structs. All of the fields in every type of decode structure
@@ -294,11 +290,14 @@ enum decode_reg_type {
 	((REG_TYPE_##r4) << 4) +	\
 	(REG_TYPE_##r0))
 
+struct decode_header;
 union decode_item {
 	u32			bits;
 	const union decode_item	*table;
-	kprobe_insn_handler_t	*handler;
-	kprobe_decode_insn_t	*decoder;
+	probes_insn_handler_t	*handler;
+	enum probes_insn (*decoder)(probes_opcode_t,
+				    struct arch_specific_insn *,
+				    struct decode_header *);
 };
 
 
@@ -379,22 +378,18 @@ struct decode_reject {
 #define DECODE_REJECT(_mask, _value)				\
 	DECODE_HEADER(DECODE_TYPE_REJECT, _mask, _value, 0)
 
+enum probes_insn {
+	INSN_REJECTED,
+	INSN_GOOD,
+	INSN_GOOD_NO_SLOT
+};
 
-#ifdef CONFIG_THUMB2_KERNEL
-extern const union decode_item kprobe_decode_thumb16_table[];
-extern const union decode_item kprobe_decode_thumb32_table[];
-extern const union decode_item kprobes_t32_actions[];
-extern const union decode_item kprobes_t16_actions[];
-#else
-extern const union decode_item kprobe_decode_arm_table[];
-extern const union decode_item kprobes_arm_actions[];
-#endif
-
-extern kprobe_check_cc * const kprobe_condition_checks[16];
-
+probes_insn_handler_t probes_simulate_nop;
+probes_insn_handler_t probes_emulate_none;
 
-int kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-			const union decode_item *table, bool thumb16,
-			const union decode_item *actions);
+int __kprobes
+probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		const union decode_item *table, bool thumb, bool usermode,
+		const union decode_item *actions);
 
 #endif
-- 
1.8.1.2

