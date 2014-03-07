Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaCGULz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:11:55 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49075 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaCGULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:11:51 -0500
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
Subject: [PATCH v7 13/15] ARM: Add an emulate flag to the kprobes/uprobes instruction decode functions
Date: Fri,  7 Mar 2014 15:10:38 -0500
Message-Id: <1394223040-17129-14-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Add an emulate flag into the instruction interpreter, primarily for uprobes
support.

Signed-off-by: David A. Long <dave.long@linaro.org>
Acked-by: Jon Medhurst <tixy@linaro.org>
---
 arch/arm/kernel/kprobes.c      |  2 +-
 arch/arm/kernel/kprobes.h      |  1 +
 arch/arm/kernel/probes-arm.c   |  4 ++--
 arch/arm/kernel/probes-arm.h   |  2 +-
 arch/arm/kernel/probes-thumb.c |  8 ++++----
 arch/arm/kernel/probes-thumb.h |  4 ++--
 arch/arm/kernel/probes.c       | 18 +++++++++++++-----
 arch/arm/kernel/probes.h       |  2 +-
 8 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 468d4a9..8795f9f 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -89,7 +89,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn, actions)) {
+	switch ((*decode_insn)(insn, &p->ainsn, true, actions)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index eee8089..d0a24b7 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -35,6 +35,7 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						struct arch_specific_insn *,
+						bool,
 						const union decode_action *);
 
 #ifdef CONFIG_THUMB2_KERNEL
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 738e5fc..8e7fde8 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -725,10 +725,10 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  */
 enum probes_insn __kprobes
 arm_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		       const union decode_action *actions)
+		       bool emulate, const union decode_action *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
 	asi->insn_check_cc = probes_condition_checks[insn>>28];
 	return probes_decode_insn(insn, asi, probes_decode_arm_table, false,
-				  actions);
+				  emulate, actions);
 }
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 7a5cce4..ea614dc 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -67,7 +67,7 @@ void __kprobes simulate_mov_ipsp(probes_opcode_t opcode,
 extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
-		struct arch_specific_insn *,
+		struct arch_specific_insn *, bool emulate,
 		const union decode_action *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index eab440f..23e2cbd 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -863,20 +863,20 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			   const union decode_action *actions)
+			   bool emulate, const union decode_action *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
 	return probes_decode_insn(insn, asi, probes_decode_thumb16_table, true,
-				  actions);
+				  emulate, actions);
 }
 
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			   const union decode_action *actions)
+			   bool emulate, const union decode_action *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
 	return probes_decode_insn(insn, asi, probes_decode_thumb32_table, true,
-				  actions);
+				  emulate, actions);
 }
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index d6f67c1d..65e4250 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -89,9 +89,9 @@ extern const union decode_item probes_decode_thumb16_table[];
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_action *actions);
+		bool emulate, const union decode_action *actions);
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_action *actions);
+		bool emulate, const union decode_action *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index b6d9b85..f9dff12 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -257,7 +257,7 @@ set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
  * non-zero value, the corresponding nibble in pinsn is validated and modified
  * according to the type.
  */
-static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
+static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
 {
 	probes_opcode_t insn = *pinsn;
 	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
@@ -323,7 +323,9 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
 		insn |= new_bits & mask;
 	}
 
-	*pinsn = insn;
+	if (modify)
+		*pinsn = insn;
+
 	return true;
 
 reject:
@@ -385,13 +387,14 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		   const union decode_item *table, bool thumb,
-		   const union decode_action *actions)
+		   bool emulate, const union decode_action *actions)
 {
 	const struct decode_header *h = (struct decode_header *)table;
 	const struct decode_header *next;
 	bool matched = false;
 
-	insn = prepare_emulated_insn(insn, asi, thumb);
+	if (emulate)
+		insn = prepare_emulated_insn(insn, asi, thumb);
 
 	for (;; h = next) {
 		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
@@ -406,7 +409,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		if (!matched && (insn & h->mask.bits) != h->value.bits)
 			continue;
 
-		if (!decode_regs(&insn, regs))
+		if (!decode_regs(&insn, regs, emulate))
 			return INSN_REJECTED;
 
 		switch (type) {
@@ -430,6 +433,11 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_EMULATE: {
 			struct decode_emulate *d = (struct decode_emulate *)h;
+
+			if (!emulate)
+				return actions[d->handler.action].decoder(insn,
+					asi, h);
+
 			asi->insn_handler = actions[d->handler.action].handler;
 			set_emulated_insn(insn, asi, thumb);
 			return INSN_GOOD;
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 0c72e54..33cc30c 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -401,7 +401,7 @@ probes_insn_handler_t probes_emulate_none;
 
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_item *table, bool thumb,
+		const union decode_item *table, bool thumb, bool emulate,
 		const union decode_action *actions);
 
 #endif
-- 
1.8.1.2

