Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab3K0C45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:56:57 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:49739 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab3K0Cxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:52 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/15] ARM: Use new opcode type in ARM kprobes/uprobes code
Date: Tue, 26 Nov 2013 21:53:27 -0500
Message-Id: <1385520814-10663-9-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

For any ARM kprobes/uprobes code interfacing to the generic ARM probes code
use a new probes_opcode_t type to avoid a dependency on kprobes definitions.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/probes.h    |  7 ++--
 arch/arm/kernel/kprobes-arm.c    | 16 ++++-----
 arch/arm/kernel/kprobes-common.c | 14 ++++----
 arch/arm/kernel/kprobes-thumb.c  | 72 ++++++++++++++++++++--------------------
 arch/arm/kernel/kprobes.h        |  8 ++---
 arch/arm/kernel/probes-arm.c     | 14 ++++----
 arch/arm/kernel/probes-arm.h     | 10 +++---
 arch/arm/kernel/probes-thumb.c   |  8 ++---
 arch/arm/kernel/probes.c         | 20 +++++------
 arch/arm/kernel/probes.h         |  8 ++---
 10 files changed, 89 insertions(+), 88 deletions(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index a7b0a79..8032591 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -2,20 +2,21 @@
 #define _ASM_PROBES_H
 
 struct kprobe;
+typedef u32 probes_opcode_t;
 
 struct arch_specific_insn;
-typedef void (kprobe_insn_handler_t)(kprobe_opcode_t,
+typedef void (kprobe_insn_handler_t)(probes_opcode_t,
 				     struct arch_specific_insn *,
 				     struct pt_regs *);
 typedef unsigned long (kprobe_check_cc)(unsigned long);
-typedef void (kprobe_insn_singlestep_t)(kprobe_opcode_t,
+typedef void (kprobe_insn_singlestep_t)(probes_opcode_t,
 					struct arch_specific_insn *,
 					struct pt_regs *);
 typedef void (kprobe_insn_fn_t)(void);
 
 /* Architecture specific copy of original instruction. */
 struct arch_specific_insn {
-	kprobe_opcode_t			*insn;
+	probes_opcode_t			*insn;
 	kprobe_insn_handler_t		*insn_handler;
 	kprobe_check_cc			*insn_check_cc;
 	kprobe_insn_singlestep_t	*insn_singlestep;
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index 394b611..1fe3a44 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -73,7 +73,7 @@
 #endif
 
 static void __kprobes
-emulate_ldrdstrd(kprobe_opcode_t insn,
+emulate_ldrdstrd(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 4;
@@ -102,7 +102,7 @@ emulate_ldrdstrd(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_ldr(kprobe_opcode_t insn,
+emulate_ldr(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 4;
@@ -132,7 +132,7 @@ emulate_ldr(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_str(kprobe_opcode_t insn,
+emulate_str(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long rtpc = regs->ARM_pc - 4 + str_pc_offset;
@@ -159,7 +159,7 @@ emulate_str(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
+emulate_rd12rn16rm0rs8_rwflags(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 4;
@@ -194,7 +194,7 @@ emulate_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_rd12rn16rm0_rwflags_nopc(kprobe_opcode_t insn,
+emulate_rd12rn16rm0_rwflags_nopc(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 12) & 0xf;
@@ -221,7 +221,7 @@ emulate_rd12rn16rm0_rwflags_nopc(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_rd16rn12rm0rs8_rwflags_nopc(kprobe_opcode_t insn,
+emulate_rd16rn12rm0rs8_rwflags_nopc(probes_opcode_t insn,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
@@ -251,7 +251,7 @@ emulate_rd16rn12rm0rs8_rwflags_nopc(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_rd12rm0_noflags_nopc(kprobe_opcode_t insn,
+emulate_rd12rm0_noflags_nopc(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 12) & 0xf;
@@ -271,7 +271,7 @@ emulate_rd12rm0_noflags_nopc(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(kprobe_opcode_t insn,
+emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(probes_opcode_t insn,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 45590a4..bd3d8c5 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -18,7 +18,7 @@
 #include "kprobes.h"
 
 
-static void __kprobes simulate_ldm1stm1(kprobe_opcode_t insn,
+static void __kprobes simulate_ldm1stm1(probes_opcode_t insn,
 		struct arch_specific_insn *asi,
 		struct pt_regs *regs)
 {
@@ -60,7 +60,7 @@ static void __kprobes simulate_ldm1stm1(kprobe_opcode_t insn,
 	}
 }
 
-static void __kprobes simulate_stm1_pc(kprobe_opcode_t insn,
+static void __kprobes simulate_stm1_pc(probes_opcode_t insn,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
@@ -71,7 +71,7 @@ static void __kprobes simulate_stm1_pc(kprobe_opcode_t insn,
 	regs->ARM_pc = (long)addr + 4;
 }
 
-static void __kprobes simulate_ldm1_pc(kprobe_opcode_t insn,
+static void __kprobes simulate_ldm1_pc(probes_opcode_t insn,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
@@ -80,7 +80,7 @@ static void __kprobes simulate_ldm1_pc(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_generic_r0_12_noflags(kprobe_opcode_t insn,
+emulate_generic_r0_12_noflags(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	register void *rregs asm("r1") = regs;
@@ -108,7 +108,7 @@ emulate_generic_r0_12_noflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_generic_r2_14_noflags(kprobe_opcode_t insn,
+emulate_generic_r2_14_noflags(probes_opcode_t insn,
       struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	emulate_generic_r0_12_noflags(insn, asi,
@@ -116,7 +116,7 @@ emulate_generic_r2_14_noflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-emulate_ldm_r3_15(kprobe_opcode_t insn,
+emulate_ldm_r3_15(probes_opcode_t insn,
 	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	emulate_generic_r0_12_noflags(insn, asi,
@@ -125,7 +125,7 @@ emulate_ldm_r3_15(kprobe_opcode_t insn,
 }
 
 enum kprobe_insn __kprobes
-kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 	struct decode_header *h)
 {
 	kprobe_insn_handler_t *handler = 0;
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 5501fa3..bb45870 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -22,7 +22,7 @@
 /* t32 thumb actions */
 
 static void __kprobes
-t32_simulate_table_branch(kprobe_opcode_t insn,
+t32_simulate_table_branch(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
@@ -42,7 +42,7 @@ t32_simulate_table_branch(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_simulate_mrs(kprobe_opcode_t insn,
+t32_simulate_mrs(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 8) & 0xf;
@@ -51,7 +51,7 @@ t32_simulate_mrs(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_simulate_cond_branch(kprobe_opcode_t insn,
+t32_simulate_cond_branch(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
@@ -66,7 +66,7 @@ t32_simulate_cond_branch(kprobe_opcode_t insn,
 }
 
 static enum kprobe_insn __kprobes
-t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t32_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	int cc = (insn >> 22) & 0xf;
@@ -76,7 +76,7 @@ t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 static void __kprobes
-t32_simulate_branch(kprobe_opcode_t insn,
+t32_simulate_branch(probes_opcode_t insn,
 		    struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
@@ -104,7 +104,7 @@ t32_simulate_branch(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_simulate_ldr_literal(kprobe_opcode_t insn,
+t32_simulate_ldr_literal(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long addr = regs->ARM_pc & ~3;
@@ -142,7 +142,7 @@ t32_simulate_ldr_literal(kprobe_opcode_t insn,
 }
 
 enum kprobe_insn __kprobes
-t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t32_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	enum kprobe_insn ret = kprobe_decode_ldmstm(insn, asi, d);
@@ -156,7 +156,7 @@ t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 static void __kprobes
-t32_emulate_ldrdstrd(kprobe_opcode_t insn,
+t32_emulate_ldrdstrd(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc & ~3;
@@ -183,7 +183,7 @@ t32_emulate_ldrdstrd(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_emulate_ldrstr(kprobe_opcode_t insn,
+t32_emulate_ldrstr(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rt = (insn >> 12) & 0xf;
@@ -209,7 +209,7 @@ t32_emulate_ldrstr(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_emulate_rd8rn16rm0_rwflags(kprobe_opcode_t insn,
+t32_emulate_rd8rn16rm0_rwflags(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 8) & 0xf;
@@ -236,7 +236,7 @@ t32_emulate_rd8rn16rm0_rwflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_emulate_rd8pc16_noflags(kprobe_opcode_t insn,
+t32_emulate_rd8pc16_noflags(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
@@ -256,7 +256,7 @@ t32_emulate_rd8pc16_noflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_emulate_rd8rn16_noflags(kprobe_opcode_t insn,
+t32_emulate_rd8rn16_noflags(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 8) & 0xf;
@@ -276,7 +276,7 @@ t32_emulate_rd8rn16_noflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t32_emulate_rdlo12rdhi8rn16rm0_noflags(kprobe_opcode_t insn,
+t32_emulate_rdlo12rdhi8rn16rm0_noflags(probes_opcode_t insn,
 		struct arch_specific_insn *asi,
 		struct pt_regs *regs)
 {
@@ -304,7 +304,7 @@ t32_emulate_rdlo12rdhi8rn16rm0_noflags(kprobe_opcode_t insn,
 /* t16 thumb actions */
 
 static void __kprobes
-t16_simulate_bxblx(kprobe_opcode_t insn,
+t16_simulate_bxblx(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
@@ -318,7 +318,7 @@ t16_simulate_bxblx(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_simulate_ldr_literal(kprobe_opcode_t insn,
+t16_simulate_ldr_literal(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long *base = (unsigned long *)((regs->ARM_pc + 2) & ~3);
@@ -328,7 +328,7 @@ t16_simulate_ldr_literal(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_simulate_ldrstr_sp_relative(kprobe_opcode_t insn,
+t16_simulate_ldrstr_sp_relative(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long* base = (unsigned long *)regs->ARM_sp;
@@ -341,7 +341,7 @@ t16_simulate_ldrstr_sp_relative(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_simulate_reladr(kprobe_opcode_t insn,
+t16_simulate_reladr(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long base = (insn & 0x800) ? regs->ARM_sp
@@ -352,7 +352,7 @@ t16_simulate_reladr(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_simulate_add_sp_imm(kprobe_opcode_t insn,
+t16_simulate_add_sp_imm(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	long imm = insn & 0x7f;
@@ -363,11 +363,11 @@ t16_simulate_add_sp_imm(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_simulate_cbz(kprobe_opcode_t insn,
+t16_simulate_cbz(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rn = insn & 0x7;
-	kprobe_opcode_t nonzero = regs->uregs[rn] ? insn : ~insn;
+	probes_opcode_t nonzero = regs->uregs[rn] ? insn : ~insn;
 	if (nonzero & 0x800) {
 		long i = insn & 0x200;
 		long imm5 = insn & 0xf8;
@@ -377,7 +377,7 @@ t16_simulate_cbz(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_simulate_it(kprobe_opcode_t insn,
+t16_simulate_it(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	/*
@@ -394,7 +394,7 @@ t16_simulate_it(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_singlestep_it(kprobe_opcode_t insn,
+t16_singlestep_it(probes_opcode_t insn,
 		  struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
@@ -402,7 +402,7 @@ t16_singlestep_it(kprobe_opcode_t insn,
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_it(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	asi->insn_singlestep = t16_singlestep_it;
@@ -410,7 +410,7 @@ t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 static void __kprobes
-t16_simulate_cond_branch(kprobe_opcode_t insn,
+t16_simulate_cond_branch(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
@@ -420,7 +420,7 @@ t16_simulate_cond_branch(kprobe_opcode_t insn,
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	int cc = (insn >> 8) & 0xf;
@@ -430,7 +430,7 @@ t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 static void __kprobes
-t16_simulate_branch(kprobe_opcode_t insn,
+t16_simulate_branch(probes_opcode_t insn,
 		   struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
@@ -440,7 +440,7 @@ t16_simulate_branch(kprobe_opcode_t insn,
 }
 
 static unsigned long __kprobes
-t16_emulate_loregs(kprobe_opcode_t insn,
+t16_emulate_loregs(probes_opcode_t insn,
 		   struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long oldcpsr = regs->ARM_cpsr;
@@ -463,14 +463,14 @@ t16_emulate_loregs(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_emulate_loregs_rwflags(kprobe_opcode_t insn,
+t16_emulate_loregs_rwflags(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_cpsr = t16_emulate_loregs(insn, asi, regs);
 }
 
 static void __kprobes
-t16_emulate_loregs_noitrwflags(kprobe_opcode_t insn,
+t16_emulate_loregs_noitrwflags(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long cpsr = t16_emulate_loregs(insn, asi, regs);
@@ -479,7 +479,7 @@ t16_emulate_loregs_noitrwflags(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_emulate_hiregs(kprobe_opcode_t insn,
+t16_emulate_hiregs(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
@@ -510,7 +510,7 @@ t16_emulate_hiregs(kprobe_opcode_t insn,
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_hiregs(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	insn &= ~0x00ff;
@@ -521,7 +521,7 @@ t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 static void __kprobes
-t16_emulate_push(kprobe_opcode_t insn,
+t16_emulate_push(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
@@ -538,7 +538,7 @@ t16_emulate_push(kprobe_opcode_t insn,
 }
 
 static enum kprobe_insn __kprobes
-t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_push(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	/*
@@ -553,7 +553,7 @@ t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 static void __kprobes
-t16_emulate_pop_nopc(kprobe_opcode_t insn,
+t16_emulate_pop_nopc(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
@@ -570,7 +570,7 @@ t16_emulate_pop_nopc(kprobe_opcode_t insn,
 }
 
 static void __kprobes
-t16_emulate_pop_pc(kprobe_opcode_t insn,
+t16_emulate_pop_pc(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	register unsigned long pc asm("r8");
@@ -591,7 +591,7 @@ t16_emulate_pop_pc(kprobe_opcode_t insn,
 }
 
 enum kprobe_insn __kprobes
-t16_decode_pop(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_pop(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	/*
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 6c1ed3c..c8a8413 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -35,22 +35,22 @@ enum kprobe_insn {
 	INSN_GOOD_NO_SLOT
 };
 
-typedef enum kprobe_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
+typedef enum kprobe_insn (kprobe_decode_insn_t)(probes_opcode_t,
 		struct arch_specific_insn *,
 		struct decode_header *);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
-enum kprobe_insn thumb16_kprobe_decode_insn(kprobe_opcode_t,
+enum kprobe_insn thumb16_kprobe_decode_insn(probes_opcode_t,
 						struct arch_specific_insn *,
 						struct decode_header *);
-enum kprobe_insn thumb32_kprobe_decode_insn(kprobe_opcode_t,
+enum kprobe_insn thumb32_kprobe_decode_insn(probes_opcode_t,
 						struct arch_specific_insn *,
 						struct decode_header *);
 
 #else /* !CONFIG_THUMB2_KERNEL */
 
-enum kprobe_insn arm_kprobe_decode_insn(kprobe_opcode_t,
+enum kprobe_insn arm_kprobe_decode_insn(probes_opcode_t,
 					struct arch_specific_insn *,
 					struct decode_header *);
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 3aba9c3..e50fb03 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -55,7 +55,7 @@
  * read and write of flags.
  */
 
-void __kprobes simulate_bbl(kprobe_opcode_t insn,
+void __kprobes simulate_bbl(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	long iaddr = (long) regs->ARM_pc - 4;
@@ -67,7 +67,7 @@ void __kprobes simulate_bbl(kprobe_opcode_t insn,
 	regs->ARM_pc = iaddr + 8 + disp;
 }
 
-void __kprobes simulate_blx1(kprobe_opcode_t insn,
+void __kprobes simulate_blx1(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	long iaddr = (long) regs->ARM_pc - 4;
@@ -78,7 +78,7 @@ void __kprobes simulate_blx1(kprobe_opcode_t insn,
 	regs->ARM_cpsr |= PSR_T_BIT;
 }
 
-void __kprobes simulate_blx2bx(kprobe_opcode_t insn,
+void __kprobes simulate_blx2bx(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rm = insn & 0xf;
@@ -93,7 +93,7 @@ void __kprobes simulate_blx2bx(kprobe_opcode_t insn,
 		regs->ARM_cpsr |= PSR_T_BIT;
 }
 
-void __kprobes simulate_mrs(kprobe_opcode_t insn,
+void __kprobes simulate_mrs(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 12) & 0xf;
@@ -101,7 +101,7 @@ void __kprobes simulate_mrs(kprobe_opcode_t insn,
 	regs->uregs[rd] = regs->ARM_cpsr & mask;
 }
 
-void __kprobes simulate_mov_ipsp(kprobe_opcode_t insn,
+void __kprobes simulate_mov_ipsp(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->uregs[12] = regs->uregs[13];
@@ -702,7 +702,7 @@ const union decode_item kprobe_decode_arm_table[] = {
 EXPORT_SYMBOL_GPL(kprobe_decode_arm_table);
 #endif
 
-static void __kprobes arm_singlestep(kprobe_opcode_t insn,
+static void __kprobes arm_singlestep(probes_opcode_t insn,
 		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
@@ -722,7 +722,7 @@ static void __kprobes arm_singlestep(kprobe_opcode_t insn,
  *   should also be very rare.
  */
 enum kprobe_insn __kprobes
-arm_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+arm_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		       struct decode_header *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 2c9e841..2662ada 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -52,15 +52,15 @@ enum probes_arm_action {
 	PROBES_LDMSTM
 };
 
-void __kprobes simulate_bbl(kprobe_opcode_t opcode,
+void __kprobes simulate_bbl(probes_opcode_t opcode,
 	struct arch_specific_insn *asi, struct pt_regs *regs);
-void __kprobes simulate_blx1(kprobe_opcode_t opcode,
+void __kprobes simulate_blx1(probes_opcode_t opcode,
 	struct arch_specific_insn *asi, struct pt_regs *regs);
-void __kprobes simulate_blx2bx(kprobe_opcode_t opcode,
+void __kprobes simulate_blx2bx(probes_opcode_t opcode,
 	struct arch_specific_insn *asi, struct pt_regs *regs);
-void __kprobes simulate_mrs(kprobe_opcode_t opcode,
+void __kprobes simulate_mrs(probes_opcode_t opcode,
 	struct arch_specific_insn *asi, struct pt_regs *regs);
-void __kprobes simulate_mov_ipsp(kprobe_opcode_t opcode,
+void __kprobes simulate_mov_ipsp(probes_opcode_t opcode,
 	struct arch_specific_insn *asi, struct pt_regs *regs);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index fb79dd9..e6dbbc3 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -841,7 +841,7 @@ static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 	return true;
 }
 
-static void __kprobes thumb16_singlestep(kprobe_opcode_t opcode,
+static void __kprobes thumb16_singlestep(probes_opcode_t opcode,
 		struct arch_specific_insn *asi,
 		struct pt_regs *regs)
 {
@@ -850,7 +850,7 @@ static void __kprobes thumb16_singlestep(kprobe_opcode_t opcode,
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
-static void __kprobes thumb32_singlestep(kprobe_opcode_t opcode,
+static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 		struct arch_specific_insn *asi,
 		struct pt_regs *regs)
 {
@@ -860,7 +860,7 @@ static void __kprobes thumb32_singlestep(kprobe_opcode_t opcode,
 }
 
 enum kprobe_insn __kprobes
-thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+thumb16_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			   struct decode_header *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
@@ -870,7 +870,7 @@ thumb16_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 enum kprobe_insn __kprobes
-thumb32_kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+thumb32_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			   struct decode_header *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index b2db250..7354448 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -171,13 +171,13 @@ kprobe_check_cc * const kprobe_condition_checks[16] = {
 };
 
 
-void __kprobes kprobe_simulate_nop(kprobe_opcode_t opcode,
+void __kprobes kprobe_simulate_nop(probes_opcode_t opcode,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
 }
 
-void __kprobes kprobe_emulate_none(kprobe_opcode_t opcode,
+void __kprobes kprobe_emulate_none(probes_opcode_t opcode,
 	struct arch_specific_insn *asi,
 	struct pt_regs *regs)
 {
@@ -191,8 +191,8 @@ void __kprobes kprobe_emulate_none(kprobe_opcode_t opcode,
  * unconditional as the condition code will already be checked before any
  * emulation handler is called.
  */
-static kprobe_opcode_t __kprobes
-prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+static probes_opcode_t __kprobes
+prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 								bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
@@ -217,7 +217,7 @@ prepare_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
  * prepare_emulated_insn
  */
 static void  __kprobes
-set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 								bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
@@ -253,14 +253,14 @@ set_emulated_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
  * non-zero value, the corresponding nibble in pinsn is validated and modified
  * according to the type.
  */
-static bool __kprobes decode_regs(kprobe_opcode_t *pinsn, u32 regs)
+static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
 {
-	kprobe_opcode_t insn = *pinsn;
-	kprobe_opcode_t mask = 0xf; /* Start at least significant nibble */
+	probes_opcode_t insn = *pinsn;
+	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
 
 	for (; regs != 0; regs >>= 4, mask <<= 4) {
 
-		kprobe_opcode_t new_bits = INSN_NEW_BITS;
+		probes_opcode_t new_bits = INSN_NEW_BITS;
 
 		switch (regs & 0xf) {
 
@@ -379,7 +379,7 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
  *
  */
 int __kprobes
-kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 				const union decode_item *table, bool thumb,
 				const union decode_item *actions)
 {
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 45151a1..c0536b1 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -129,13 +129,13 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
 }
 
 
-void __kprobes kprobe_simulate_nop(kprobe_opcode_t, struct arch_specific_insn *,
+void __kprobes kprobe_simulate_nop(probes_opcode_t, struct arch_specific_insn *,
 		struct pt_regs *regs);
-void __kprobes kprobe_emulate_none(kprobe_opcode_t, struct arch_specific_insn *,
+void __kprobes kprobe_emulate_none(probes_opcode_t, struct arch_specific_insn *,
 		struct pt_regs *regs);
 
 enum kprobe_insn __kprobes
-kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *h);
 
 /*
@@ -397,7 +397,7 @@ extern const union decode_item kprobes_arm_actions[];
 extern kprobe_check_cc * const kprobe_condition_checks[16];
 
 
-int kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+int kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 			const union decode_item *table, bool thumb16,
 			const union decode_item *actions);
 
-- 
1.8.1.2

