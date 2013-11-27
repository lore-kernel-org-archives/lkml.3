Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab3K0C5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:57:02 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41433 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab3K0Cxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:51 -0500
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
Subject: [PATCH v3 07/15] ARM: Remove use of struct kprobe from generic probes code
Date: Tue, 26 Nov 2013 21:53:26 -0500
Message-Id: <1385520814-10663-8-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Change the generic ARM probes code to pass in the opcode and architecture-specific
structure separately instead of using struct kprobe, so we do not pollute
code being used only for uprobes or other non-kprobes instruction
interpretation.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/probes.h    |   9 +-
 arch/arm/kernel/kprobes-arm.c    |  77 ++++++-------
 arch/arm/kernel/kprobes-common.c |  42 ++++---
 arch/arm/kernel/kprobes-thumb.c  | 239 +++++++++++++++++++--------------------
 arch/arm/kernel/kprobes.c        |   2 +-
 arch/arm/kernel/kprobes.h        |   2 +-
 arch/arm/kernel/probes-arm.c     |  33 +++---
 arch/arm/kernel/probes-arm.h     |  29 ++---
 arch/arm/kernel/probes-thumb.c   |  18 ++-
 arch/arm/kernel/probes-thumb.h   |  51 ---------
 arch/arm/kernel/probes.c         |  14 ++-
 arch/arm/kernel/probes.h         |   8 +-
 12 files changed, 246 insertions(+), 278 deletions(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index edf5abe..a7b0a79 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -3,9 +3,14 @@
 
 struct kprobe;
 
-typedef void (kprobe_insn_handler_t)(struct kprobe *, struct pt_regs *);
+struct arch_specific_insn;
+typedef void (kprobe_insn_handler_t)(kprobe_opcode_t,
+				     struct arch_specific_insn *,
+				     struct pt_regs *);
 typedef unsigned long (kprobe_check_cc)(unsigned long);
-typedef void (kprobe_insn_singlestep_t)(struct kprobe *, struct pt_regs *);
+typedef void (kprobe_insn_singlestep_t)(kprobe_opcode_t,
+					struct arch_specific_insn *,
+					struct pt_regs *);
 typedef void (kprobe_insn_fn_t)(void);
 
 /* Architecture specific copy of original instruction. */
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index ee329ff..394b611 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -72,12 +72,11 @@
 			"mov	pc, "reg"	\n\t"
 #endif
 
-
-void __kprobes
-emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_ldrdstrd(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = (unsigned long)p->addr + 8;
+	unsigned long pc = regs->ARM_pc + 4;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -92,7 +91,7 @@ emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 		BLX("%[fn]")
 		: "=r" (rtv), "=r" (rt2v), "=r" (rnv)
 		: "0" (rtv), "1" (rt2v), "2" (rnv), "r" (rmv),
-		  [fn] "r" (p->ainsn.insn_fn)
+		  [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -102,11 +101,11 @@ emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rn] = rnv;
 }
 
-void __kprobes
-emulate_ldr(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_ldr(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = (unsigned long)p->addr + 8;
+	unsigned long pc = regs->ARM_pc + 4;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -119,7 +118,7 @@ emulate_ldr(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		BLX("%[fn]")
 		: "=r" (rtv), "=r" (rnv)
-		: "1" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "1" (rnv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -132,12 +131,12 @@ emulate_ldr(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rn] = rnv;
 }
 
-void __kprobes
-emulate_str(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_str(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long rtpc = (unsigned long)p->addr + str_pc_offset;
-	unsigned long rnpc = (unsigned long)p->addr + 8;
+	unsigned long rtpc = regs->ARM_pc - 4 + str_pc_offset;
+	unsigned long rnpc = regs->ARM_pc + 4;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -151,7 +150,7 @@ emulate_str(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		BLX("%[fn]")
 		: "=r" (rnv)
-		: "r" (rtv), "0" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "r" (rtv), "0" (rnv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -159,11 +158,11 @@ emulate_str(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rn] = rnv;
 }
 
-void __kprobes
-emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd12rn16rm0rs8_rwflags(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = (unsigned long)p->addr + 8;
+	unsigned long pc = regs->ARM_pc + 4;
 	int rd = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -183,7 +182,7 @@ emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -194,10 +193,10 @@ emulate_rd12rn16rm0rs8_rwflags(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd12rn16rm0_rwflags_nopc(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -213,7 +212,7 @@ emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -221,10 +220,11 @@ emulate_rd12rn16rm0_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd16rn12rm0rs8_rwflags_nopc(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 16) & 0xf;
 	int rn = (insn >> 12) & 0xf;
 	int rm = insn & 0xf;
@@ -242,7 +242,7 @@ emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv), "r" (rsv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -250,10 +250,10 @@ emulate_rd16rn12rm0rs8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-emulate_rd12rm0_noflags_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+emulate_rd12rm0_noflags_nopc(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 12) & 0xf;
 	int rm = insn & 0xf;
 
@@ -263,17 +263,18 @@ emulate_rd12rm0_noflags_nopc(struct kprobe *p, struct pt_regs *regs)
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
+emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rdlo = (insn >> 12) & 0xf;
 	int rdhi = (insn >> 16) & 0xf;
 	int rn = insn & 0xf;
@@ -291,7 +292,7 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdlov), "=r" (rdhiv), [cpsr] "=r" (cpsr)
 		: "0" (rdlov), "1" (rdhiv), "r" (rnv), "r" (rmv),
-		  "2" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "2" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index 554720c..45590a4 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -18,9 +18,10 @@
 #include "kprobes.h"
 
 
-static void __kprobes simulate_ldm1stm1(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes simulate_ldm1stm1(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rn = (insn >> 16) & 0xf;
 	int lbit = insn & (1 << 20);
 	int wbit = insn & (1 << 21);
@@ -59,24 +60,31 @@ static void __kprobes simulate_ldm1stm1(struct kprobe *p, struct pt_regs *regs)
 	}
 }
 
-static void __kprobes simulate_stm1_pc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes simulate_stm1_pc(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	regs->ARM_pc = (long)p->addr + str_pc_offset;
-	simulate_ldm1stm1(p, regs);
-	regs->ARM_pc = (long)p->addr + 4;
+	unsigned long addr = regs->ARM_pc - 4;
+
+	regs->ARM_pc = (long)addr + str_pc_offset;
+	simulate_ldm1stm1(insn, asi, regs);
+	regs->ARM_pc = (long)addr + 4;
 }
 
-static void __kprobes simulate_ldm1_pc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes simulate_ldm1_pc(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	simulate_ldm1stm1(p, regs);
+	simulate_ldm1stm1(insn, asi, regs);
 	load_write_pc(regs->ARM_pc, regs);
 }
 
 static void __kprobes
-emulate_generic_r0_12_noflags(struct kprobe *p, struct pt_regs *regs)
+emulate_generic_r0_12_noflags(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	register void *rregs asm("r1") = regs;
-	register void *rfn asm("lr") = p->ainsn.insn_fn;
+	register void *rfn asm("lr") = asi->insn_fn;
 
 	__asm__ __volatile__ (
 		"stmdb	sp!, {%[regs], r11}	\n\t"
@@ -100,21 +108,25 @@ emulate_generic_r0_12_noflags(struct kprobe *p, struct pt_regs *regs)
 }
 
 static void __kprobes
-emulate_generic_r2_14_noflags(struct kprobe *p, struct pt_regs *regs)
+emulate_generic_r2_14_noflags(kprobe_opcode_t insn,
+      struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	emulate_generic_r0_12_noflags(p, (struct pt_regs *)(regs->uregs+2));
+	emulate_generic_r0_12_noflags(insn, asi,
+		(struct pt_regs *)(regs->uregs+2));
 }
 
 static void __kprobes
-emulate_ldm_r3_15(struct kprobe *p, struct pt_regs *regs)
+emulate_ldm_r3_15(kprobe_opcode_t insn,
+	struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	emulate_generic_r0_12_noflags(p, (struct pt_regs *)(regs->uregs+3));
+	emulate_generic_r0_12_noflags(insn, asi,
+		(struct pt_regs *)(regs->uregs+3));
 	load_write_pc(regs->ARM_pc, regs);
 }
 
 enum kprobe_insn __kprobes
 kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-		struct decode_header *h)
+	struct decode_header *h)
 {
 	kprobe_insn_handler_t *handler = 0;
 	unsigned reglist = insn & 0xffff;
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 687924b..5501fa3 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -19,24 +19,13 @@
 #define t32_emulate_rd8rn16rm0ra12_noflags \
 		t32_emulate_rdlo12rdhi8rn16rm0_noflags
 
-/*
- * Return the PC value for a probe in thumb code.
- * This is the address of the probed instruction plus 4.
- * We subtract one because the address will have bit zero set to indicate
- * a pointer to thumb code.
- */
-static inline unsigned long __kprobes thumb_probe_pc(struct kprobe *p)
-{
-	return (unsigned long)p->addr - 1 + 4;
-}
-
 /* t32 thumb actions */
 
-void __kprobes
-t32_simulate_table_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_table_branch(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
 
@@ -52,20 +41,20 @@ t32_simulate_table_branch(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = pc + 2 * halfwords;
 }
 
-void __kprobes
-t32_simulate_mrs(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_mrs(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 8) & 0xf;
 	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
 	regs->uregs[rd] = regs->ARM_cpsr & mask;
 }
 
-void __kprobes
-t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_cond_branch(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc;
 
 	long offset = insn & 0x7ff;		/* imm11 */
 	offset += (insn & 0x003f0000) >> 5;	/* imm6 */
@@ -76,7 +65,7 @@ t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-enum kprobe_insn __kprobes
+static enum kprobe_insn __kprobes
 t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -86,11 +75,11 @@ t32_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD_NO_SLOT;
 }
 
-void __kprobes
-t32_simulate_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_branch(kprobe_opcode_t insn,
+		    struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc;
 
 	long offset = insn & 0x7ff;		/* imm11 */
 	offset += (insn & 0x03ff0000) >> 5;	/* imm10 */
@@ -103,7 +92,7 @@ t32_simulate_branch(struct kprobe *p, struct pt_regs *regs)
 
 	if (insn & (1 << 14)) {
 		/* BL or BLX */
-		regs->ARM_lr = (unsigned long)p->addr + 4;
+		regs->ARM_lr = regs->ARM_pc | 1;
 		if (!(insn & (1 << 12))) {
 			/* BLX so switch to ARM mode */
 			regs->ARM_cpsr &= ~PSR_T_BIT;
@@ -114,11 +103,11 @@ t32_simulate_branch(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-void __kprobes
-t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_simulate_ldr_literal(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long addr = thumb_probe_pc(p) & ~3;
+	unsigned long addr = regs->ARM_pc & ~3;
 	int rt = (insn >> 12) & 0xf;
 	unsigned long rtv;
 
@@ -166,11 +155,11 @@ t32_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return ret;
 }
 
-void __kprobes
-t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_ldrdstrd(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p) & ~3;
+	unsigned long pc = regs->ARM_pc & ~3;
 	int rt1 = (insn >> 12) & 0xf;
 	int rt2 = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -183,7 +172,7 @@ t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		"blx    %[fn]"
 		: "=r" (rt1v), "=r" (rt2v), "=r" (rnv)
-		: "0" (rt1v), "1" (rt2v), "2" (rnv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rt1v), "1" (rt2v), "2" (rnv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -193,10 +182,10 @@ t32_emulate_ldrdstrd(struct kprobe *p, struct pt_regs *regs)
 	regs->uregs[rt2] = rt2v;
 }
 
-void __kprobes
-t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_ldrstr(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rt = (insn >> 12) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -208,7 +197,7 @@ t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs)
 	__asm__ __volatile__ (
 		"blx    %[fn]"
 		: "=r" (rtv), "=r" (rnv)
-		: "0" (rtv), "1" (rnv), "r" (rmv), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rtv), "1" (rnv), "r" (rmv), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -219,10 +208,10 @@ t32_emulate_ldrstr(struct kprobe *p, struct pt_regs *regs)
 		regs->uregs[rt] = rtv;
 }
 
-void __kprobes
-t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_rd8rn16rm0_rwflags(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 	int rm = insn & 0xf;
@@ -238,7 +227,7 @@ t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdv), [cpsr] "=r" (cpsr)
 		: "0" (rdv), "r" (rnv), "r" (rmv),
-		  "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		  "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -246,11 +235,11 @@ t32_emulate_rd8rn16rm0_rwflags(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-void __kprobes
-t32_emulate_rd8pc16_noflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t32_emulate_rd8pc16_noflags(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc;
 	int rd = (insn >> 8) & 0xf;
 
 	register unsigned long rdv asm("r1") = regs->uregs[rd];
@@ -259,17 +248,17 @@ t32_emulate_rd8pc16_noflags(struct kprobe *p, struct pt_regs *regs)
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
+t32_emulate_rd8rn16_noflags(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
 
@@ -279,17 +268,18 @@ t32_emulate_rd8rn16_noflags(struct kprobe *p, struct pt_regs *regs)
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
+t32_emulate_rdlo12rdhi8rn16rm0_noflags(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rdlo = (insn >> 12) & 0xf;
 	int rdhi = (insn >> 8) & 0xf;
 	int rn = (insn >> 16) & 0xf;
@@ -304,7 +294,7 @@ t32_emulate_rdlo12rdhi8rn16rm0_noflags(struct kprobe *p, struct pt_regs *regs)
 		"blx    %[fn]"
 		: "=r" (rdlov), "=r" (rdhiv)
 		: "0" (rdlov), "1" (rdhiv), "r" (rnv), "r" (rmv),
-		  [fn] "r" (p->ainsn.insn_fn)
+		  [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -313,34 +303,34 @@ t32_emulate_rdlo12rdhi8rn16rm0_noflags(struct kprobe *p, struct pt_regs *regs)
 }
 /* t16 thumb actions */
 
-void __kprobes
-t16_simulate_bxblx(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_bxblx(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc + 2;
 	int rm = (insn >> 3) & 0xf;
 	unsigned long rmv = (rm == 15) ? pc : regs->uregs[rm];
 
 	if (insn & (1 << 7)) /* BLX ? */
-		regs->ARM_lr = (unsigned long)p->addr + 2;
+		regs->ARM_lr = regs->ARM_pc | 1;
 
 	bx_write_pc(rmv, regs);
 }
 
-void __kprobes
-t16_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_ldr_literal(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long* base = (unsigned long *)(thumb_probe_pc(p) & ~3);
+	unsigned long *base = (unsigned long *)((regs->ARM_pc + 2) & ~3);
 	long index = insn & 0xff;
 	int rt = (insn >> 8) & 0x7;
 	regs->uregs[rt] = base[index];
 }
 
-void __kprobes
-t16_simulate_ldrstr_sp_relative(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_ldrstr_sp_relative(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	unsigned long* base = (unsigned long *)regs->ARM_sp;
 	long index = insn & 0xff;
 	int rt = (insn >> 8) & 0x7;
@@ -350,21 +340,21 @@ t16_simulate_ldrstr_sp_relative(struct kprobe *p, struct pt_regs *regs)
 		base[index] = regs->uregs[rt];
 }
 
-void __kprobes
-t16_simulate_reladr(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_reladr(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	unsigned long base = (insn & 0x800) ? regs->ARM_sp
-					    : (thumb_probe_pc(p) & ~3);
+					    : ((regs->ARM_pc + 2) & ~3);
 	long offset = insn & 0xff;
 	int rt = (insn >> 8) & 0x7;
 	regs->uregs[rt] = base + offset * 4;
 }
 
-void __kprobes
-t16_simulate_add_sp_imm(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_add_sp_imm(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	long imm = insn & 0x7f;
 	if (insn & 0x80) /* SUB */
 		regs->ARM_sp -= imm * 4;
@@ -372,22 +362,23 @@ t16_simulate_add_sp_imm(struct kprobe *p, struct pt_regs *regs)
 		regs->ARM_sp += imm * 4;
 }
 
-void __kprobes
-t16_simulate_cbz(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_cbz(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rn = insn & 0x7;
 	kprobe_opcode_t nonzero = regs->uregs[rn] ? insn : ~insn;
 	if (nonzero & 0x800) {
 		long i = insn & 0x200;
 		long imm5 = insn & 0xf8;
-		unsigned long pc = thumb_probe_pc(p);
+		unsigned long pc = regs->ARM_pc + 2;
 		regs->ARM_pc = pc + (i >> 3) + (imm5 >> 2);
 	}
 }
 
-void __kprobes
-t16_simulate_it(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_it(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	/*
 	 * The 8 IT state bits are split into two parts in CPSR:
@@ -395,7 +386,6 @@ t16_simulate_it(struct kprobe *p, struct pt_regs *regs)
 	 *	ITSTATE<7:2> are in CPSR<15:10>
 	 * The new IT state is in the lower byte of insn.
 	 */
-	kprobe_opcode_t insn = p->opcode;
 	unsigned long cpsr = regs->ARM_cpsr;
 	cpsr &= ~PSR_IT_MASK;
 	cpsr |= (insn & 0xfc) << 8;
@@ -403,14 +393,15 @@ t16_simulate_it(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = cpsr;
 }
 
-void __kprobes
-t16_singlestep_it(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_singlestep_it(kprobe_opcode_t insn,
+		  struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
-	t16_simulate_it(p, regs);
+	t16_simulate_it(insn, asi, regs);
 }
 
-enum kprobe_insn __kprobes
+static enum kprobe_insn __kprobes
 t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -418,17 +409,17 @@ t16_decode_it(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD_NO_SLOT;
 }
 
-void __kprobes
-t16_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_cond_branch(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc + 2;
 	long offset = insn & 0x7f;
 	offset -= insn & 0x80; /* Apply sign bit */
 	regs->ARM_pc = pc + (offset * 2);
 }
 
-enum kprobe_insn __kprobes
+static enum kprobe_insn __kprobes
 t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -438,18 +429,19 @@ t16_decode_cond_branch(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD_NO_SLOT;
 }
 
-void __kprobes
-t16_simulate_branch(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_simulate_branch(kprobe_opcode_t insn,
+		   struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc + 2;
 	long offset = insn & 0x3ff;
 	offset -= insn & 0x400; /* Apply sign bit */
 	regs->ARM_pc = pc + (offset * 2);
 }
 
 static unsigned long __kprobes
-t16_emulate_loregs(struct kprobe *p, struct pt_regs *regs)
+t16_emulate_loregs(kprobe_opcode_t insn,
+		   struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	unsigned long oldcpsr = regs->ARM_cpsr;
 	unsigned long newcpsr;
@@ -462,7 +454,7 @@ t16_emulate_loregs(struct kprobe *p, struct pt_regs *regs)
 		"mrs	%[newcpsr], cpsr	\n\t"
 		: [newcpsr] "=r" (newcpsr)
 		: [oldcpsr] "r" (oldcpsr), [regs] "r" (regs),
-		  [fn] "r" (p->ainsn.insn_fn)
+		  [fn] "r" (asi->insn_fn)
 		: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
 		  "lr", "memory", "cc"
 		);
@@ -470,25 +462,27 @@ t16_emulate_loregs(struct kprobe *p, struct pt_regs *regs)
 	return (oldcpsr & ~APSR_MASK) | (newcpsr & APSR_MASK);
 }
 
-void __kprobes
-t16_emulate_loregs_rwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_loregs_rwflags(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	regs->ARM_cpsr = t16_emulate_loregs(p, regs);
+	regs->ARM_cpsr = t16_emulate_loregs(insn, asi, regs);
 }
 
-void __kprobes
-t16_emulate_loregs_noitrwflags(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_loregs_noitrwflags(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	unsigned long cpsr = t16_emulate_loregs(p, regs);
+	unsigned long cpsr = t16_emulate_loregs(insn, asi, regs);
 	if (!in_it_block(cpsr))
 		regs->ARM_cpsr = cpsr;
 }
 
-void __kprobes
-t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_hiregs(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	unsigned long pc = thumb_probe_pc(p);
+	unsigned long pc = regs->ARM_pc + 2;
 	int rdn = (insn & 0x7) | ((insn & 0x80) >> 4);
 	int rm = (insn >> 3) & 0xf;
 
@@ -504,7 +498,7 @@ t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
 		"blx    %[fn]			\n\t"
 		"mrs	%[cpsr], cpsr		\n\t"
 		: "=r" (rdnv), [cpsr] "=r" (cpsr)
-		: "0" (rdnv), "r" (rmv), "1" (cpsr), [fn] "r" (p->ainsn.insn_fn)
+		: "0" (rdnv), "r" (rmv), "1" (cpsr), [fn] "r" (asi->insn_fn)
 		: "lr", "memory", "cc"
 	);
 
@@ -515,7 +509,7 @@ t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr = (regs->ARM_cpsr & ~APSR_MASK) | (cpsr & APSR_MASK);
 }
 
-enum kprobe_insn __kprobes
+static enum kprobe_insn __kprobes
 t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -526,8 +520,9 @@ t16_decode_hiregs(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD;
 }
 
-void __kprobes
-t16_emulate_push(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_push(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
 		"ldr	r9, [%[regs], #13*4]	\n\t"
@@ -536,13 +531,13 @@ t16_emulate_push(struct kprobe *p, struct pt_regs *regs)
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
+static enum kprobe_insn __kprobes
 t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
@@ -557,8 +552,9 @@ t16_decode_push(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 	return INSN_GOOD;
 }
 
-void __kprobes
-t16_emulate_pop_nopc(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes
+t16_emulate_pop_nopc(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	__asm__ __volatile__ (
 		"ldr	r9, [%[regs], #13*4]	\n\t"
@@ -567,14 +563,15 @@ t16_emulate_pop_nopc(struct kprobe *p, struct pt_regs *regs)
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
+t16_emulate_pop_pc(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	register unsigned long pc asm("r8");
 
@@ -585,7 +582,7 @@ t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs)
 		"stmia	%[regs], {r0-r7}	\n\t"
 		"str	r9, [%[regs], #13*4]	\n\t"
 		: "=r" (pc)
-		: [regs] "r" (regs), [fn] "r" (p->ainsn.insn_fn)
+		: [regs] "r" (regs), [fn] "r" (asi->insn_fn)
 		: "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r9",
 		  "lr", "memory", "cc"
 		);
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index a18b4ca..19c55aa 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -203,7 +203,7 @@ singlestep_skip(struct kprobe *p, struct pt_regs *regs)
 static inline void __kprobes
 singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-	p->ainsn.insn_singlestep(p, regs);
+	p->ainsn.insn_singlestep(p->opcode, &p->ainsn, regs);
 }
 
 /*
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 5ce81dc..6c1ed3c 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -37,7 +37,7 @@ enum kprobe_insn {
 
 typedef enum kprobe_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
 		struct arch_specific_insn *,
-		struct decode_header *actions);
+		struct decode_header *);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 665cd0d..3aba9c3 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -18,8 +18,7 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 
-#include <linux/kprobes.h>
-#include "kprobes.h"
+#include "probes.h"
 #include "probes-arm.h"
 
 #define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
@@ -56,10 +55,10 @@
  * read and write of flags.
  */
 
-void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_bbl(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	long iaddr = (long)p->addr;
+	long iaddr = (long) regs->ARM_pc - 4;
 	int disp  = branch_displacement(insn);
 
 	if (insn & (1 << 24))
@@ -68,10 +67,10 @@ void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_pc = iaddr + 8 + disp;
 }
 
-void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_blx1(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
-	long iaddr = (long)p->addr;
+	long iaddr = (long) regs->ARM_pc - 4;
 	int disp = branch_displacement(insn);
 
 	regs->ARM_lr = iaddr + 4;
@@ -79,14 +78,14 @@ void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs)
 	regs->ARM_cpsr |= PSR_T_BIT;
 }
 
-void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_blx2bx(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rm = insn & 0xf;
 	long rmv = regs->uregs[rm];
 
 	if (insn & (1 << 5))
-		regs->ARM_lr = (long)p->addr + 4;
+		regs->ARM_lr = (long) regs->ARM_pc;
 
 	regs->ARM_pc = rmv & ~0x1;
 	regs->ARM_cpsr &= ~PSR_T_BIT;
@@ -94,15 +93,16 @@ void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs)
 		regs->ARM_cpsr |= PSR_T_BIT;
 }
 
-void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_mrs(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
-	kprobe_opcode_t insn = p->opcode;
 	int rd = (insn >> 12) & 0xf;
 	unsigned long mask = 0xf8ff03df; /* Mask out execution state */
 	regs->uregs[rd] = regs->ARM_cpsr & mask;
 }
 
-void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs)
+void __kprobes simulate_mov_ipsp(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->uregs[12] = regs->uregs[13];
 }
@@ -702,10 +702,11 @@ const union decode_item kprobe_decode_arm_table[] = {
 EXPORT_SYMBOL_GPL(kprobe_decode_arm_table);
 #endif
 
-static void __kprobes arm_singlestep(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes arm_singlestep(kprobe_opcode_t insn,
+		struct arch_specific_insn *asi, struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
-	p->ainsn.insn_handler(p, regs);
+	asi->insn_handler(insn, asi, regs);
 }
 
 /* Return:
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index f8e0f7a..2c9e841 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -52,24 +52,15 @@ enum probes_arm_action {
 	PROBES_LDMSTM
 };
 
-void __kprobes simulate_bbl(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_blx1(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_blx2bx(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_mrs(struct kprobe *p, struct pt_regs *regs);
-void __kprobes simulate_mov_ipsp(struct kprobe *p, struct pt_regs *regs);
-
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
+void __kprobes simulate_bbl(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_blx1(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_blx2bx(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_mrs(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
+void __kprobes simulate_mov_ipsp(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi, struct pt_regs *regs);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index bf2f1e9..fb79dd9 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -9,10 +9,9 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kprobes.h>
 #include <linux/module.h>
 
-#include "kprobes.h"
+#include "probes.h"
 #include "probes-thumb.h"
 
 
@@ -831,6 +830,9 @@ const union decode_item kprobe_decode_thumb16_table[] = {
 
 	DECODE_END
 };
+#ifdef CONFIG_ARM_KPROBES_TEST_MODULE
+EXPORT_SYMBOL_GPL(kprobe_decode_thumb16_table);
+#endif
 
 static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 {
@@ -839,17 +841,21 @@ static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 	return true;
 }
 
-static void __kprobes thumb16_singlestep(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes thumb16_singlestep(kprobe_opcode_t opcode,
+		struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
 	regs->ARM_pc += 2;
-	p->ainsn.insn_handler(p, regs);
+	asi->insn_handler(opcode, asi, regs);
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
-static void __kprobes thumb32_singlestep(struct kprobe *p, struct pt_regs *regs)
+static void __kprobes thumb32_singlestep(kprobe_opcode_t opcode,
+		struct arch_specific_insn *asi,
+		struct pt_regs *regs)
 {
 	regs->ARM_pc += 4;
-	p->ainsn.insn_handler(p, regs);
+	asi->insn_handler(opcode, asi, regs);
 	regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
 }
 
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index 381ad3a..f024a4c 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -82,55 +82,4 @@ enum probes_t16_action {
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
-	struct arch_specific_insn *asi, struct decode_header *d);
-void __kprobes t16_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_cond_branch(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, struct decode_header *d);
-void __kprobes t16_simulate_branch(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_emulate_loregs_rwflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t16_emulate_loregs_noitrwflags(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t16_emulate_hiregs(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_hiregs(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, struct decode_header *d);
-void __kprobes t16_emulate_push(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_push(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, struct decode_header *d);
-void __kprobes t16_emulate_pop_nopc(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t16_emulate_pop_pc(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t16_decode_pop(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, struct decode_header *d);
-
-void __kprobes t32_simulate_table_branch(struct kprobe *p,
-	struct pt_regs *regs);
-void __kprobes t32_simulate_mrs(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t32_simulate_cond_branch(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t32_decode_cond_branch(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, struct decode_header *d);
-void __kprobes t32_simulate_branch(struct kprobe *p, struct pt_regs *regs);
-void __kprobes t32_simulate_ldr_literal(struct kprobe *p, struct pt_regs *regs);
-enum kprobe_insn __kprobes t32_decode_ldmstm(kprobe_opcode_t insn,
-	struct arch_specific_insn *asi, struct decode_header *d);
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
-
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index 1bcf5da..b2db250 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -12,11 +12,9 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kprobes.h>
 #include <asm/system_info.h>
 
-#include "kprobes.h"
-
+#include "probes.h"
 
 #ifndef find_str_pc_offset
 
@@ -173,13 +171,17 @@ kprobe_check_cc * const kprobe_condition_checks[16] = {
 };
 
 
-void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs)
+void __kprobes kprobe_simulate_nop(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
 }
 
-void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs)
+void __kprobes kprobe_emulate_none(kprobe_opcode_t opcode,
+	struct arch_specific_insn *asi,
+	struct pt_regs *regs)
 {
-	p->ainsn.insn_fn();
+	asi->insn_fn();
 }
 
 /*
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 2238972..45151a1 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -20,6 +20,7 @@
 #define  _ARM_KERNEL_PROBES_H
 
 #include <linux/kprobes.h>
+#include "kprobes.h"
 
 #if __LINUX_ARM_ARCH__ >= 7
 
@@ -35,6 +36,7 @@ void __init find_str_pc_offset(void);
 
 #endif
 
+struct decode_header;
 
 /*
  * Update ITSTATE after normal execution of an IT block instruction.
@@ -127,8 +129,10 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
 }
 
 
-void __kprobes kprobe_simulate_nop(struct kprobe *p, struct pt_regs *regs);
-void __kprobes kprobe_emulate_none(struct kprobe *p, struct pt_regs *regs);
+void __kprobes kprobe_simulate_nop(kprobe_opcode_t, struct arch_specific_insn *,
+		struct pt_regs *regs);
+void __kprobes kprobe_emulate_none(kprobe_opcode_t, struct arch_specific_insn *,
+		struct pt_regs *regs);
 
 enum kprobe_insn __kprobes
 kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
-- 
1.8.1.2

