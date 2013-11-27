Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab3K0C4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:56:53 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34263 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3K0Cxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:53 -0500
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
Subject: [PATCH v3 09/15] ARM: Make the kprobes condition_check symbol names more generic
Date: Tue, 26 Nov 2013 21:53:28 -0500
Message-Id: <1385520814-10663-10-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

In preparation for sharing the ARM kprobes instruction interpreting
code with uprobes, make the symbols names less kprobes-specific.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/include/asm/probes.h   | 4 ++--
 arch/arm/kernel/kprobes-thumb.c | 4 ++--
 arch/arm/kernel/probes-arm.c    | 2 +-
 arch/arm/kernel/probes-thumb.c  | 2 +-
 arch/arm/kernel/probes.c        | 2 +-
 arch/arm/kernel/probes.h        | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index 8032591..81b05b0 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -8,7 +8,7 @@ struct arch_specific_insn;
 typedef void (kprobe_insn_handler_t)(probes_opcode_t,
 				     struct arch_specific_insn *,
 				     struct pt_regs *);
-typedef unsigned long (kprobe_check_cc)(unsigned long);
+typedef unsigned long (probes_check_cc)(unsigned long);
 typedef void (kprobe_insn_singlestep_t)(probes_opcode_t,
 					struct arch_specific_insn *,
 					struct pt_regs *);
@@ -18,7 +18,7 @@ typedef void (kprobe_insn_fn_t)(void);
 struct arch_specific_insn {
 	probes_opcode_t			*insn;
 	kprobe_insn_handler_t		*insn_handler;
-	kprobe_check_cc			*insn_check_cc;
+	probes_check_cc			*insn_check_cc;
 	kprobe_insn_singlestep_t	*insn_singlestep;
 	kprobe_insn_fn_t		*insn_fn;
 };
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index bb45870..4f30217 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -70,7 +70,7 @@ t32_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	int cc = (insn >> 22) & 0xf;
-	asi->insn_check_cc = kprobe_condition_checks[cc];
+	asi->insn_check_cc = probes_condition_checks[cc];
 	asi->insn_handler = t32_simulate_cond_branch;
 	return INSN_GOOD_NO_SLOT;
 }
@@ -424,7 +424,7 @@ t16_decode_cond_branch(probes_opcode_t insn, struct arch_specific_insn *asi,
 		struct decode_header *d)
 {
 	int cc = (insn >> 8) & 0xf;
-	asi->insn_check_cc = kprobe_condition_checks[cc];
+	asi->insn_check_cc = probes_condition_checks[cc];
 	asi->insn_handler = t16_simulate_cond_branch;
 	return INSN_GOOD_NO_SLOT;
 }
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index e50fb03..95ef3e3 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -726,7 +726,7 @@ arm_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		       struct decode_header *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
-	asi->insn_check_cc = kprobe_condition_checks[insn>>28];
+	asi->insn_check_cc = probes_condition_checks[insn>>28];
 	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false,
 				  (const union decode_item *) actions);
 }
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index e6dbbc3..055faf0 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -837,7 +837,7 @@ EXPORT_SYMBOL_GPL(kprobe_decode_thumb16_table);
 static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 {
 	if (unlikely(in_it_block(cpsr)))
-		return kprobe_condition_checks[current_cond(cpsr)](cpsr);
+		return probes_condition_checks[current_cond(cpsr)](cpsr);
 	return true;
 }
 
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index 7354448..36fafd2 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -163,7 +163,7 @@ static unsigned long __kprobes __check_al(unsigned long cpsr)
 	return true;
 }
 
-kprobe_check_cc * const kprobe_condition_checks[16] = {
+probes_check_cc * const probes_condition_checks[16] = {
 	&__check_eq, &__check_ne, &__check_cs, &__check_cc,
 	&__check_mi, &__check_pl, &__check_vs, &__check_vc,
 	&__check_hi, &__check_ls, &__check_ge, &__check_lt,
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index c0536b1..e7c7a92 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -394,7 +394,7 @@ extern const union decode_item kprobe_decode_arm_table[];
 extern const union decode_item kprobes_arm_actions[];
 #endif
 
-extern kprobe_check_cc * const kprobe_condition_checks[16];
+extern probes_check_cc * const probes_condition_checks[16];
 
 
 int kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-- 
1.8.1.2

