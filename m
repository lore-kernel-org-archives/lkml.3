Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaAWUIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:08:54 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:34362 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaAWUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:06:16 -0500
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
Subject: [PATCH v5 09/16] ARM: Make the kprobes condition_check symbol names more generic
Date: Thu, 23 Jan 2014 15:05:52 -0500
Message-Id: <1390507559-4697-10-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
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
index 5b09f9e..c4acf6c 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -26,7 +26,7 @@ struct arch_specific_insn;
 typedef void (kprobe_insn_handler_t)(probes_opcode_t,
 				     struct arch_specific_insn *,
 				     struct pt_regs *);
-typedef unsigned long (kprobe_check_cc)(unsigned long);
+typedef unsigned long (probes_check_cc)(unsigned long);
 typedef void (kprobe_insn_singlestep_t)(probes_opcode_t,
 					struct arch_specific_insn *,
 					struct pt_regs *);
@@ -36,7 +36,7 @@ typedef void (kprobe_insn_fn_t)(void);
 struct arch_specific_insn {
 	probes_opcode_t			*insn;
 	kprobe_insn_handler_t		*insn_handler;
-	kprobe_check_cc			*insn_check_cc;
+	probes_check_cc			*insn_check_cc;
 	kprobe_insn_singlestep_t	*insn_singlestep;
 	kprobe_insn_fn_t		*insn_fn;
 };
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index dcc6b29..8608e18 100644
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
index 7bf0330..f0c3720 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -726,7 +726,7 @@ arm_kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		       const union decode_action *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
-	asi->insn_check_cc = kprobe_condition_checks[insn>>28];
+	asi->insn_check_cc = probes_condition_checks[insn>>28];
 	return kprobe_decode_insn(insn, asi, kprobe_decode_arm_table, false,
 				  actions);
 }
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 6cf168b..f954e14 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -838,7 +838,7 @@ EXPORT_SYMBOL_GPL(kprobe_decode_thumb16_table);
 static unsigned long __kprobes thumb_check_cc(unsigned long cpsr)
 {
 	if (unlikely(in_it_block(cpsr)))
-		return kprobe_condition_checks[current_cond(cpsr)](cpsr);
+		return probes_condition_checks[current_cond(cpsr)](cpsr);
 	return true;
 }
 
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index 35a3a26..139c08f 100644
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
index 383d42d..a8231fa 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -406,7 +406,7 @@ extern const union decode_item kprobe_decode_arm_table[];
 extern const union decode_action kprobes_arm_actions[];
 #endif
 
-extern kprobe_check_cc * const kprobe_condition_checks[16];
+extern probes_check_cc * const probes_condition_checks[16];
 
 
 int kprobe_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-- 
1.8.1.2

