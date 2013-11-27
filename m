Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab3K0CzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:55:13 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:58921 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab3K0Cx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:59 -0500
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
Subject: [PATCH v3 12/15] ARM: Change the remaining shared kprobes/uprobes symbols to something generic
Date: Tue, 26 Nov 2013 21:53:31 -0500
Message-Id: <1385520814-10663-13-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Any more ARM kprobes/uprobes symbols which have "kprobe" in the name must be
changed to the more generic "probes" or other non-kprobes specific symbol.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/probes.h    | 13 ++++++------
 arch/arm/kernel/kprobes-common.c |  2 +-
 arch/arm/kernel/kprobes-test.c   |  8 ++++---
 arch/arm/kernel/kprobes.c        | 13 ++++++------
 arch/arm/kernel/kprobes.h        | 25 ++++++++++------------
 arch/arm/kernel/probes-arm.c     | 12 +++++------
 arch/arm/kernel/probes-arm.h     |  6 ++++++
 arch/arm/kernel/probes-thumb.c   | 26 +++++++++++------------
 arch/arm/kernel/probes-thumb.h   | 10 +++++++++
 arch/arm/kernel/probes.c         |  4 ++--
 arch/arm/kernel/probes.h         | 46 +++++++++++++---------------------------
 11 files changed, 82 insertions(+), 83 deletions(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index 81b05b0..614977b 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -1,26 +1,25 @@
 #ifndef _ASM_PROBES_H
 #define _ASM_PROBES_H
 
-struct kprobe;
 typedef u32 probes_opcode_t;
 
 struct arch_specific_insn;
-typedef void (kprobe_insn_handler_t)(probes_opcode_t,
+typedef void (probes_insn_handler_t)(probes_opcode_t,
 				     struct arch_specific_insn *,
 				     struct pt_regs *);
 typedef unsigned long (probes_check_cc)(unsigned long);
-typedef void (kprobe_insn_singlestep_t)(probes_opcode_t,
+typedef void (probes_insn_singlestep_t)(probes_opcode_t,
 					struct arch_specific_insn *,
 					struct pt_regs *);
-typedef void (kprobe_insn_fn_t)(void);
+typedef void (probes_insn_fn_t)(void);
 
 /* Architecture specific copy of original instruction. */
 struct arch_specific_insn {
 	probes_opcode_t			*insn;
-	kprobe_insn_handler_t		*insn_handler;
+	probes_insn_handler_t		*insn_handler;
 	probes_check_cc			*insn_check_cc;
-	kprobe_insn_singlestep_t	*insn_singlestep;
-	kprobe_insn_fn_t		*insn_fn;
+	probes_insn_singlestep_t	*insn_singlestep;
+	probes_insn_fn_t		*insn_fn;
 };
 
 #endif
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index f8a1589..0c485ca 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -128,7 +128,7 @@ enum probes_insn __kprobes
 kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 	struct decode_header *h)
 {
-	kprobe_insn_handler_t *handler = 0;
+	probes_insn_handler_t *handler = 0;
 	unsigned reglist = insn & 0xffff;
 	int is_ldm = insn & 0x100000;
 	int rn = (insn >> 16) & 0xf;
diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 65230b2..a1f155c 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -205,6 +205,8 @@
 #include <asm/opcodes.h>
 
 #include "kprobes.h"
+#include "probes-arm.h"
+#include "probes-thumb.h"
 #include "kprobes-test.h"
 
 
@@ -1616,7 +1618,7 @@ static int __init run_all_tests(void)
 		goto out;
 
 	pr_info("ARM instruction simulation\n");
-	ret = run_test_cases(kprobe_arm_test_cases, kprobe_decode_arm_table);
+	ret = run_test_cases(kprobe_arm_test_cases, probes_decode_arm_table);
 	if (ret)
 		goto out;
 
@@ -1639,13 +1641,13 @@ static int __init run_all_tests(void)
 
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
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 31bc9b7..0d9d49b 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -29,6 +29,8 @@
 #include <asm/cacheflush.h>
 
 #include "kprobes.h"
+#include "probes-arm.h"
+#include "probes-thumb.h"
 #include "patch.h"
 
 #define MIN_STACK_SIZE(addr) 				\
@@ -67,10 +69,10 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
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
@@ -78,15 +80,14 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
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
+	switch ((*decode_insn)(insn, &p->ainsn, actions)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
@@ -98,7 +99,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 			p->ainsn.insn[is] = tmp_insn[is];
 		flush_insns(p->ainsn.insn,
 				sizeof(p->ainsn.insn[0]) * MAX_INSN_SIZE);
-		p->ainsn.insn_fn = (kprobe_insn_fn_t *)
+		p->ainsn.insn_fn = (probes_insn_fn_t *)
 					((uintptr_t)p->ainsn.insn | thumb);
 		break;
 
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 2c8a888..e1305a8 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -19,6 +19,8 @@
 #ifndef _ARM_KERNEL_KPROBES_H
 #define _ARM_KERNEL_KPROBES_H
 
+#include "probes.h"
+
 /*
  * These undefined instructions must be unique and
  * reserved solely for kprobes' use.
@@ -27,29 +29,24 @@
 #define KPROBE_THUMB16_BREAKPOINT_INSTRUCTION	0xde18
 #define KPROBE_THUMB32_BREAKPOINT_INSTRUCTION	0xf7f0a018
 
-struct decode_header;
+enum probes_insn __kprobes
+kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
+		struct decode_header *h);
 
-typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
-		struct arch_specific_insn *,
-		struct decode_header *);
+typedef enum probes_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
+			struct arch_specific_insn *,
+			const union decode_item *);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
-enum probes_insn thumb16_kprobe_decode_insn(probes_opcode_t,
-						struct arch_specific_insn *,
-						struct decode_header *);
-enum probes_insn thumb32_kprobe_decode_insn(probes_opcode_t,
-						struct arch_specific_insn *,
-						struct decode_header *);
+extern const union decode_item kprobes_t32_actions[];
+extern const union decode_item kprobes_t16_actions[];
 
 #else /* !CONFIG_THUMB2_KERNEL */
 
-enum probes_insn arm_kprobe_decode_insn(probes_opcode_t,
-					struct arch_specific_insn *,
-					struct decode_header *);
+extern const union decode_item kprobes_arm_actions[];
 
 #endif
 
-#include "probes.h"
 
 #endif /* _ARM_KERNEL_KPROBES_H */
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 3bec735..a44c3ad 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -608,7 +608,7 @@ static const union decode_item arm_cccc_100x_table[] = {
 	DECODE_END
 };
 
-const union decode_item kprobe_decode_arm_table[] = {
+const union decode_item probes_decode_arm_table[] = {
 	/*
 	 * Unconditional instructions
 	 *			1111 xxxx xxxx xxxx xxxx xxxx xxxx xxxx
@@ -699,7 +699,7 @@ const union decode_item kprobe_decode_arm_table[] = {
 	DECODE_END
 };
 #ifdef CONFIG_ARM_KPROBES_TEST_MODULE
-EXPORT_SYMBOL_GPL(kprobe_decode_arm_table);
+EXPORT_SYMBOL_GPL(probes_decode_arm_table);
 #endif
 
 static void __kprobes arm_singlestep(probes_opcode_t insn,
@@ -722,11 +722,11 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  *   should also be very rare.
  */
 enum probes_insn __kprobes
-arm_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		       struct decode_header *actions)
+arm_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		const union decode_item *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
 	asi->insn_check_cc = probes_condition_checks[insn>>28];
-	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false,
-				  (const union decode_item *) actions);
+	return probes_decode_insn(insn, asi, probes_decode_arm_table, false,
+			actions);
 }
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 2662ada..7f81199 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -63,4 +63,10 @@ void __kprobes simulate_mrs(probes_opcode_t opcode,
 void __kprobes simulate_mov_ipsp(probes_opcode_t opcode,
 	struct arch_specific_insn *asi, struct pt_regs *regs);
 
+extern const union decode_item probes_decode_arm_table[];
+
+enum probes_insn arm_probes_decode_insn(probes_opcode_t,
+		struct arch_specific_insn *,
+		const union decode_item *actions);
+
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 64ae4b3..3f250e9 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-thumb.c
+ * arch/arm/kernel/probes-thumb.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -551,7 +551,7 @@ static const union decode_item t32_table_1111_1011_1[] = {
 	DECODE_END
 };
 
-const union decode_item kprobe_decode_thumb32_table[] = {
+const union decode_item probes_decode_thumb32_table[] = {
 
 	/*
 	 * Load/store multiple instructions
@@ -640,7 +640,7 @@ const union decode_item kprobe_decode_thumb32_table[] = {
 	DECODE_END
 };
 #ifdef CONFIG_ARM_KPROBES_TEST_MODULE
-EXPORT_SYMBOL_GPL(kprobe_decode_thumb32_table);
+EXPORT_SYMBOL_GPL(probes_decode_thumb32_table);
 #endif
 static const union decode_item t16_table_1011[] = {
 	/* Miscellaneous 16-bit instructions		    */
@@ -694,7 +694,7 @@ static const union decode_item t16_table_1011[] = {
 	DECODE_END
 };
 
-const union decode_item kprobe_decode_thumb16_table[] = {
+const union decode_item probes_decode_thumb16_table[] = {
 
 	/*
 	 * Shift (immediate), add, subtract, move, and compare
@@ -831,7 +831,7 @@ const union decode_item kprobe_decode_thumb16_table[] = {
 	DECODE_END
 };
 #ifdef CONFIG_ARM_KPROBES_TEST_MODULE
-EXPORT_SYMBOL_GPL(kprobe_decode_thumb16_table);
+EXPORT_SYMBOL_GPL(probes_decode_thumb16_table);
 #endif
 
 static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
@@ -860,21 +860,21 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 }
 
 enum probes_insn __kprobes
-thumb16_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			   struct decode_header *actions)
+thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+			   const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
-	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb16_table, true,
-				  (const union decode_item *) actions);
+	return probes_decode_insn(insn, asi, probes_decode_thumb16_table, true,
+				  actions);
 }
 
 enum probes_insn __kprobes
-thumb32_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			   struct decode_header *actions)
+thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+			   const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
-	return kprobe_decode_insn(insn, asi, kprobe_decode_thumb32_table, true,
-				  (const union decode_item *) actions);
+	return probes_decode_insn(insn, asi, probes_decode_thumb32_table, true,
+				  actions);
 }
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index f024a4c..556f067 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -82,4 +82,14 @@ enum probes_t16_action {
 	PROBES_T16_BRANCH
 };
 
+extern const union decode_item probes_decode_thumb32_table[];
+extern const union decode_item probes_decode_thumb16_table[];
+
+enum probes_insn __kprobes
+thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		const union decode_item *actions);
+enum probes_insn __kprobes
+thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		const union decode_item *actions);
+
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index c63b0f6..a0a4220 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -336,7 +336,7 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 };
 
 /*
- * kprobe_decode_insn operates on data tables in order to decode an ARM
+ * probes_decode_insn operates on data tables in order to decode an ARM
  * architecture instruction onto which a kprobe has been placed.
  *
  * These instruction decoding tables are a concatenation of entries each
@@ -379,7 +379,7 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
  *
  */
 int __kprobes
-kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 				const union decode_item *table, bool thumb,
 				const union decode_item *actions)
 {
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 577fb35..9591c2c 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -19,11 +19,12 @@
 #ifndef _ARM_KERNEL_PROBES_H
 #define  _ARM_KERNEL_PROBES_H
 
-#include <linux/kprobes.h>
-#include "kprobes.h"
+#include <asm/probes.h>
 
 void __init arm_probes_decode_init(void);
 
+extern probes_check_cc * const probes_condition_checks[16];
+
 #if __LINUX_ARM_ARCH__ >= 7
 
 /* str_pc_offset is architecturally defined from ARMv7 onwards */
@@ -38,7 +39,6 @@ void __init find_str_pc_offset(void);
 
 #endif
 
-struct decode_header;
 
 /*
  * Update ITSTATE after normal execution of an IT block instruction.
@@ -130,16 +130,6 @@ static inline void __kprobes alu_write_pc(long pcv, struct pt_regs *regs)
 		regs->ARM_pc = pcv;
 }
 
-
-void __kprobes probes_simulate_nop(probes_opcode_t, struct arch_specific_insn *,
-		struct pt_regs *regs);
-void __kprobes probes_emulate_none(probes_opcode_t, struct arch_specific_insn *,
-		struct pt_regs *regs);
-
-enum probes_insn __kprobes
-kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
-		struct decode_header *h);
-
 /*
  * Test if load/store instructions writeback the address register.
  * if P (bit 24) == 0 or W (bit 21) == 1
@@ -148,7 +138,7 @@ kprobe_decode_ldmstm(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 /*
  * The following definitions and macros are used to build instruction
- * decoding tables for use by kprobe_decode_insn.
+ * decoding tables for use by probes_decode_insn.
  *
  * These tables are a concatenation of entries each of which consist of one of
  * the decode_* structs. All of the fields in every type of decode structure
@@ -300,11 +290,14 @@ enum decode_reg_type {
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
 
 
@@ -391,21 +384,12 @@ enum probes_insn {
 	INSN_GOOD_NO_SLOT
 };
 
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
-extern probes_check_cc * const probes_condition_checks[16];
-
+probes_insn_handler_t probes_simulate_nop;
+probes_insn_handler_t probes_emulate_none;
 
-int kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			const union decode_item *table, bool thumb16,
-			const union decode_item *actions);
+int __kprobes
+probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
+		const union decode_item *table, bool thumb,
+		const union decode_item *actions);
 
 #endif
-- 
1.8.1.2

