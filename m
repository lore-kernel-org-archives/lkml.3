Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3LPEKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:10:31 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63677 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3LPEJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:09:19 -0500
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
Subject: [PATCH v4 14/16] ARM: Make arch_specific_insn a define for new arch_probes_insn structure
Date: Sun, 15 Dec 2013 23:08:48 -0500
Message-Id: <1387166930-13182-15-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Because the common underlying code for ARM kprobes and uprobes needs
to share a common architecrure-specific context structure, and because
the generic kprobes include file insists on defining this to a dummy
structure when kprobes is not configured, a new common structure is
required which can exist when uprobes is configured without kprobes.
In this case kprobes will define a dummy structure, but without the
define aliasing the two structure tags it will not affect uprobes and
the shared probes code.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/kprobes.h   |  2 ++
 arch/arm/include/asm/probes.h    |  8 ++---
 arch/arm/kernel/kprobes-arm.c    | 16 ++++-----
 arch/arm/kernel/kprobes-common.c | 14 ++++----
 arch/arm/kernel/kprobes-thumb.c  | 70 ++++++++++++++++++++--------------------
 arch/arm/kernel/kprobes.h        |  4 +--
 arch/arm/kernel/probes-arm.c     | 14 ++++----
 arch/arm/kernel/probes-arm.h     | 12 +++----
 arch/arm/kernel/probes-thumb.c   |  8 ++---
 arch/arm/kernel/probes-thumb.h   |  4 +--
 arch/arm/kernel/probes.c         | 10 +++---
 arch/arm/kernel/probes.h         |  4 +--
 12 files changed, 84 insertions(+), 82 deletions(-)

diff --git a/arch/arm/include/asm/kprobes.h b/arch/arm/include/asm/kprobes.h
index 30fc11b..87b8aa2 100644
--- a/arch/arm/include/asm/kprobes.h
+++ b/arch/arm/include/asm/kprobes.h
@@ -31,6 +31,8 @@ typedef u32 kprobe_opcode_t;
 struct kprobe;
 #include <asm/probes.h>
 
+#define	arch_specific_insn	arch_probes_insn
+
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned int status;
diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index 614977b..36775ff 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -3,18 +3,18 @@
 
 typedef u32 probes_opcode_t;
 
-struct arch_specific_insn;
+struct arch_probes_insn;
 typedef void (probes_insn_handler_t)(probes_opcode_t,
-				     struct arch_specific_insn *,
+				     struct arch_probes_insn *,
 				     struct pt_regs *);
 typedef unsigned long (probes_check_cc)(unsigned long);
 typedef void (probes_insn_singlestep_t)(probes_opcode_t,
-					struct arch_specific_insn *,
+					struct arch_probes_insn *,
 					struct pt_regs *);
 typedef void (probes_insn_fn_t)(void);
 
 /* Architecture specific copy of original instruction. */
-struct arch_specific_insn {
+struct arch_probes_insn {
 	probes_opcode_t			*insn;
 	probes_insn_handler_t		*insn_handler;
 	probes_check_cc			*insn_check_cc;
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index ccb10bc..bb1dec2 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -74,7 +74,7 @@
 
 static void __kprobes
 emulate_ldrdstrd(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 4;
 	int rt = (insn >> 12) & 0xf;
@@ -103,7 +103,7 @@ emulate_ldrdstrd(probes_opcode_t insn,
 
 static void __kprobes
 emulate_ldr(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 4;
 	int rt = (insn >> 12) & 0xf;
@@ -133,7 +133,7 @@ emulate_ldr(probes_opcode_t insn,
 
 static void __kprobes
 emulate_str(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long rtpc = regs->ARM_pc - 4 + str_pc_offset;
 	unsigned long rnpc = regs->ARM_pc + 4;
@@ -160,7 +160,7 @@ emulate_str(probes_opcode_t insn,
 
 static void __kprobes
 emulate_rd12rn16rm0rs8_rwflags(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 4;
 	int rd = (insn >> 12) & 0xf;
@@ -195,7 +195,7 @@ emulate_rd12rn16rm0rs8_rwflags(probes_opcode_t insn,
 
 static void __kprobes
 emulate_rd12rn16rm0_rwflags_nopc(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -222,7 +222,7 @@ emulate_rd12rn16rm0_rwflags_nopc(probes_opcode_t insn,
 
 static void __kprobes
 emulate_rd16rn12rm0rs8_rwflags_nopc(probes_opcode_t insn,
-	struct arch_specific_insn *asi,
+	struct arch_probes_insn *asi,
 	struct pt_regs *regs)
 {
 	int rd = (insn >> 16) & 0xf;
@@ -252,7 +252,7 @@ emulate_rd16rn12rm0rs8_rwflags_nopc(probes_opcode_t insn,
 
 static void __kprobes
 emulate_rd12rm0_noflags_nopc(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 12) & 0xf;
 	int rm = insn & 0xf;
@@ -272,7 +272,7 @@ emulate_rd12rm0_noflags_nopc(probes_opcode_t insn,
 
 static void __kprobes
 emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(probes_opcode_t insn,
-	struct arch_specific_insn *asi,
+	struct arch_probes_insn *asi,
 	struct pt_regs *regs)
 {
 	int rdlo = (insn >> 12) & 0xf;
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 0c485ca..3ee8a7b 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -19,7 +19,7 @@
 
 
 static void __kprobes simulate_ldm1stm1(probes_opcode_t insn,
-		struct arch_specific_insn *asi,
+		struct arch_probes_insn *asi,
 		struct pt_regs *regs)
 {
 	int rn = (insn >> 16) & 0xf;
@@ -61,7 +61,7 @@ static void __kprobes simulate_ldm1stm1(probes_opcode_t insn,
 }
 
 static void __kprobes simulate_stm1_pc(probes_opcode_t insn,
-	struct arch_specific_insn *asi,
+	struct arch_probes_insn *asi,
 	struct pt_regs *regs)
 {
 	unsigned long addr = regs->ARM_pc - 4;
@@ -72,7 +72,7 @@ static void __kprobes simulate_stm1_pc(probes_opcode_t insn,
 }
 
 static void __kprobes simulate_ldm1_pc(probes_opcode_t insn,
-	struct arch_specific_insn *asi,
+	struct arch_probes_insn *asi,
 	struct pt_regs *regs)
 {
 	simulate_ldm1stm1(insn, asi, regs);
@@ -81,7 +81,7 @@ static void __kprobes simulate_ldm1_pc(probes_opcode_t insn,
 
 static void __kprobes
 emulate_generic_r0_12_noflags(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	register void *rregs asm("r1") = regs;
 	register void *rfn asm("lr") = asi->insn_fn;
@@ -109,7 +109,7 @@ emulate_generic_r0_12_noflags(probes_opcode_t insn,
 
 static void __kprobes
 emulate_generic_r2_14_noflags(probes_opcode_t insn,
-      struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	emulate_generic_r0_12_noflags(insn, asi,
 		(struct pt_regs *)(regs->uregs+2));
@@ -117,7 +117,7 @@ emulate_generic_r2_14_noflags(probes_opcode_t insn,
 
 static void __kprobes
 emulate_ldm_r3_15(probes_opcode_t insn,
-	struct arch_specific_insn *asi, struct pt_regs *regs)
+	struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	emulate_generic_r0_12_noflags(insn, asi,
 		(struct pt_regs *)(regs->uregs+3));
@@ -125,7 +125,7 @@ emulate_ldm_r3_15(probes_opcode_t insn,
 }
 
 enum probes_insn __kprobes
-kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
+kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_probes_insn *asi,
 	struct decode_header *h)
 {
 	probes_insn_handler_t *handler = 0;
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 9624abb..eb31108 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -23,7 +23,7 @@
 
 static void __kprobes
 t32_simulate_table_branch(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
 	int rn = (insn >> 16) & 0xf;
@@ -43,7 +43,7 @@ t32_simulate_table_branch(probes_opcode_t insn,
 
 static void __kprobes
 t32_simulate_mrs(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 8) & 0xf;
 	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
@@ -52,7 +52,7 @@ t32_simulate_mrs(probes_opcode_t insn,
 
 static void __kprobes
 t32_simulate_cond_branch(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
 
@@ -66,7 +66,7 @@ t32_simulate_cond_branch(probes_opcode_t insn,
 }
 
 static enum probes_insn __kprobes
-t32_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
+t32_decode_cond_branch(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	int cc = (insn >> 22) & 0xf;
@@ -77,7 +77,7 @@ t32_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 static void __kprobes
 t32_simulate_branch(probes_opcode_t insn,
-		    struct arch_specific_insn *asi, struct pt_regs *regs)
+		    struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
 
@@ -105,7 +105,7 @@ t32_simulate_branch(probes_opcode_t insn,
 
 static void __kprobes
 t32_simulate_ldr_literal(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long addr = regs->ARM_pc & ~3;
 	int rt = (insn >> 12) & 0xf;
@@ -142,7 +142,7 @@ t32_simulate_ldr_literal(probes_opcode_t insn,
 }
 
 enum probes_insn __kprobes
-t32_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
+t32_decode_ldmstm(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	enum probes_insn ret = kprobe_decode_ldmstm(insn, asi, d);
@@ -157,7 +157,7 @@ t32_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 static void __kprobes
 t32_emulate_ldrdstrd(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc & ~3;
 	int rt1 = (insn >> 12) & 0xf;
@@ -184,7 +184,7 @@ t32_emulate_ldrdstrd(probes_opcode_t insn,
 
 static void __kprobes
 t32_emulate_ldrstr(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -210,7 +210,7 @@ t32_emulate_ldrstr(probes_opcode_t insn,
 
 static void __kprobes
 t32_emulate_rd8rn16rm0_rwflags(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -237,7 +237,7 @@ t32_emulate_rd8rn16rm0_rwflags(probes_opcode_t insn,
 
 static void __kprobes
 t32_emulate_rd8pc16_noflags(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc;
 	int rd = (insn >> 8) & 0xf;
@@ -257,7 +257,7 @@ t32_emulate_rd8pc16_noflags(probes_opcode_t insn,
 
 static void __kprobes
 t32_emulate_rd8rn16_noflags(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -277,7 +277,7 @@ t32_emulate_rd8rn16_noflags(probes_opcode_t insn,
 
 static void __kprobes
 t32_emulate_rdlo12rdhi8rn16rm0_noflags(probes_opcode_t insn,
-		struct arch_specific_insn *asi,
+		struct arch_probes_insn *asi,
 		struct pt_regs *regs)
 {
 	int rdlo = (insn >> 12) & 0xf;
@@ -305,7 +305,7 @@ t32_emulate_rdlo12rdhi8rn16rm0_noflags(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_bxblx(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
 	int rm = (insn >> 3) & 0xf;
@@ -319,7 +319,7 @@ t16_simulate_bxblx(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_ldr_literal(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long *base = (unsigned long *)((regs->ARM_pc + 2) & ~3);
 	long index = insn & 0xff;
@@ -329,7 +329,7 @@ t16_simulate_ldr_literal(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_ldrstr_sp_relative(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long* base = (unsigned long *)regs->ARM_sp;
 	long index = insn & 0xff;
@@ -342,7 +342,7 @@ t16_simulate_ldrstr_sp_relative(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_reladr(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long base = (insn & 0x800) ? regs->ARM_sp
 					    : ((regs->ARM_pc + 2) & ~3);
@@ -353,7 +353,7 @@ t16_simulate_reladr(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_add_sp_imm(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	long imm = insn & 0x7f;
 	if (insn & 0x80) /* SUB */
@@ -364,7 +364,7 @@ t16_simulate_add_sp_imm(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_cbz(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rn = insn & 0x7;
 	probes_opcode_t nonzero = regs->uregs[rn] ? insn : ~insn;
@@ -378,7 +378,7 @@ t16_simulate_cbz(probes_opcode_t insn,
 
 static void __kprobes
 t16_simulate_it(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	/*
 	 * The 8 IT state bits are split into two parts in CPSR:
@@ -395,14 +395,14 @@ t16_simulate_it(probes_opcode_t insn,
 
 static void __kprobes
 t16_singlestep_it(probes_opcode_t insn,
-		  struct arch_specific_insn *asi, struct pt_regs *regs)
+		  struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
 	t16_simulate_it(insn, asi, regs);
 }
 
 static enum probes_insn __kprobes
-t16_decode_it(probes_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_it(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	asi->insn_singlestep = t16_singlestep_it;
@@ -411,7 +411,7 @@ t16_decode_it(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 static void __kprobes
 t16_simulate_cond_branch(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
 	long offset = insn & 0x7f;
@@ -420,7 +420,7 @@ t16_simulate_cond_branch(probes_opcode_t insn,
 }
 
 static enum probes_insn __kprobes
-t16_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_cond_branch(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	int cc = (insn >> 8) & 0xf;
@@ -431,7 +431,7 @@ t16_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 static void __kprobes
 t16_simulate_branch(probes_opcode_t insn,
-		   struct arch_specific_insn *asi, struct pt_regs *regs)
+		   struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
 	long offset = insn & 0x3ff;
@@ -441,7 +441,7 @@ t16_simulate_branch(probes_opcode_t insn,
 
 static unsigned long __kprobes
 t16_emulate_loregs(probes_opcode_t insn,
-		   struct arch_specific_insn *asi, struct pt_regs *regs)
+		   struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long oldcpsr = regs->ARM_cpsr;
 	unsigned long newcpsr;
@@ -464,14 +464,14 @@ t16_emulate_loregs(probes_opcode_t insn,
 
 static void __kprobes
 t16_emulate_loregs_rwflags(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_cpsr = t16_emulate_loregs(insn, asi, regs);
 }
 
 static void __kprobes
 t16_emulate_loregs_noitrwflags(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long cpsr = t16_emulate_loregs(insn, asi, regs);
 	if (!in_it_block(cpsr))
@@ -480,7 +480,7 @@ t16_emulate_loregs_noitrwflags(probes_opcode_t insn,
 
 static void __kprobes
 t16_emulate_hiregs(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	unsigned long pc = regs->ARM_pc + 2;
 	int rdn = (insn & 0x7) | ((insn & 0x80) >> 4);
@@ -510,7 +510,7 @@ t16_emulate_hiregs(probes_opcode_t insn,
 }
 
 static enum probes_insn __kprobes
-t16_decode_hiregs(probes_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_hiregs(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	insn &= ~0x00ff;
@@ -522,7 +522,7 @@ t16_decode_hiregs(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 static void __kprobes
 t16_emulate_push(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
 		"ldr	r9, [%[regs], #13*4]	\n\t"
@@ -538,7 +538,7 @@ t16_emulate_push(probes_opcode_t insn,
 }
 
 static enum probes_insn __kprobes
-t16_decode_push(probes_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_push(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	/*
@@ -554,7 +554,7 @@ t16_decode_push(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 static void __kprobes
 t16_emulate_pop_nopc(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
 		"ldr	r9, [%[regs], #13*4]	\n\t"
@@ -571,7 +571,7 @@ t16_emulate_pop_nopc(probes_opcode_t insn,
 
 static void __kprobes
 t16_emulate_pop_pc(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	register unsigned long pc asm("r8");
 
@@ -591,7 +591,7 @@ t16_emulate_pop_pc(probes_opcode_t insn,
 }
 
 enum probes_insn __kprobes
-t16_decode_pop(probes_opcode_t insn, struct arch_specific_insn *asi,
+t16_decode_pop(probes_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *d)
 {
 	/*
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 580d82c..841416c 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -30,11 +30,11 @@
 #define KPROBE_THUMB32_BREAKPOINT_INSTRUCTION	0xf7f0a018
 
 enum probes_insn __kprobes
-kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_probes_insn *asi,
 		struct decode_header *h);
 
 typedef enum probes_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
-			struct arch_specific_insn *,
+			struct arch_probes_insn *,
 			bool,
 			const union decode_item *);
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 01e99f7..e9b54f7 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -56,7 +56,7 @@
  */
 
 void __kprobes simulate_bbl(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	long iaddr = (long) regs->ARM_pc - 4;
 	int disp  = branch_displacement(insn);
@@ -68,7 +68,7 @@ void __kprobes simulate_bbl(probes_opcode_t insn,
 }
 
 void __kprobes simulate_blx1(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	long iaddr = (long) regs->ARM_pc - 4;
 	int disp = branch_displacement(insn);
@@ -79,7 +79,7 @@ void __kprobes simulate_blx1(probes_opcode_t insn,
 }
 
 void __kprobes simulate_blx2bx(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rm = insn & 0xf;
 	long rmv = regs->uregs[rm];
@@ -94,7 +94,7 @@ void __kprobes simulate_blx2bx(probes_opcode_t insn,
 }
 
 void __kprobes simulate_mrs(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	int rd = (insn >> 12) & 0xf;
 	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
@@ -102,7 +102,7 @@ void __kprobes simulate_mrs(probes_opcode_t insn,
 }
 
 void __kprobes simulate_mov_ipsp(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	regs->uregs[12] = regs->uregs[13];
 }
@@ -703,7 +703,7 @@ EXPORT_SYMBOL_GPL(probes_decode_arm_table);
 #endif
 
 static void __kprobes arm_singlestep(probes_opcode_t insn,
-		struct arch_specific_insn *asi, struct pt_regs *regs)
+		struct arch_probes_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
 	asi->insn_handler(insn, asi, regs);
@@ -722,7 +722,7 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  *   should also be very rare.
  */
 enum probes_insn __kprobes
-arm_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+arm_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		bool emulate, const union decode_item *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 904033c..984aaa7 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -53,20 +53,20 @@ enum probes_arm_action {
 };
 
 void __kprobes simulate_bbl(probes_opcode_t opcode,
-	struct arch_specific_insn *asi, struct pt_regs *regs);
+	struct arch_probes_insn *asi, struct pt_regs *regs);
 void __kprobes simulate_blx1(probes_opcode_t opcode,
-	struct arch_specific_insn *asi, struct pt_regs *regs);
+	struct arch_probes_insn *asi, struct pt_regs *regs);
 void __kprobes simulate_blx2bx(probes_opcode_t opcode,
-	struct arch_specific_insn *asi, struct pt_regs *regs);
+	struct arch_probes_insn *asi, struct pt_regs *regs);
 void __kprobes simulate_mrs(probes_opcode_t opcode,
-	struct arch_specific_insn *asi, struct pt_regs *regs);
+	struct arch_probes_insn *asi, struct pt_regs *regs);
 void __kprobes simulate_mov_ipsp(probes_opcode_t opcode,
-	struct arch_specific_insn *asi, struct pt_regs *regs);
+	struct arch_probes_insn *asi, struct pt_regs *regs);
 
 extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
-		struct arch_specific_insn *, bool emulate,
+		struct arch_probes_insn *, bool emulate,
 		const union decode_item *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 2ad0880..9cf56d8 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -842,7 +842,7 @@ static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 }
 
 static void __kprobes thumb16_singlestep(probes_opcode_t opcode,
-		struct arch_specific_insn *asi,
+		struct arch_probes_insn *asi,
 		struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
@@ -851,7 +851,7 @@ static void __kprobes thumb16_singlestep(probes_opcode_t opcode,
 }
 
 static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
-		struct arch_specific_insn *asi,
+		struct arch_probes_insn *asi,
 		struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
@@ -860,7 +860,7 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 }
 
 enum probes_insn __kprobes
-thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 			   bool emulate, const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
@@ -870,7 +870,7 @@ thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 }
 
 enum probes_insn __kprobes
-thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 			   bool emulate, const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index 78be667..2916222 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -86,10 +86,10 @@ extern const union decode_item probes_decode_thumb32_table[];
 extern const union decode_item probes_decode_thumb16_table[];
 
 enum probes_insn __kprobes
-thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		bool emulate, const union decode_item *actions);
 enum probes_insn __kprobes
-thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		bool emulate, const union decode_item *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index e691e12..e194955 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -172,13 +172,13 @@ probes_check_cc * const probes_condition_checks[16] = {
 
 
 void __kprobes probes_simulate_nop(probes_opcode_t opcode,
-	struct arch_specific_insn *asi,
+	struct arch_probes_insn *asi,
 	struct pt_regs *regs)
 {
 }
 
 void __kprobes probes_emulate_none(probes_opcode_t opcode,
-	struct arch_specific_insn *asi,
+	struct arch_probes_insn *asi,
 	struct pt_regs *regs)
 {
 	asi->insn_fn();
@@ -192,7 +192,7 @@ void __kprobes probes_emulate_none(probes_opcode_t opcode,
  * emulation handler is called.
  */
 static probes_opcode_t __kprobes
-prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+prepare_emulated_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 			bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
@@ -217,7 +217,7 @@ prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
  * prepare_emulated_insn
  */
 static void  __kprobes
-set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+set_emulated_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 			bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
@@ -386,7 +386,7 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
  *
  */
 int __kprobes
-probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		   const union decode_item *table, bool thumb,
 		   bool emulate, const union decode_item *actions)
 {
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 233ab7b..2a1eb32 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -296,7 +296,7 @@ union decode_item {
 	const union decode_item	*table;
 	probes_insn_handler_t	*handler;
 	enum probes_insn (*decoder)(probes_opcode_t,
-				    struct arch_specific_insn *,
+				    struct arch_probes_insn *,
 				    struct decode_header *);
 };
 
@@ -388,7 +388,7 @@ probes_insn_handler_t probes_simulate_nop;
 probes_insn_handler_t probes_emulate_none;
 
 int __kprobes
-probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		const union decode_item *table, bool thumb, bool emulate,
 		const union decode_item *actions);
 
-- 
1.8.1.2

