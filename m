Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaAWUGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:06:25 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:49954 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaAWUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:06:22 -0500
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
Subject: [PATCH v5 13/16] ARM: Add an emulate flag to the kprobes/uprobes instruction decode functions
Date: Thu, 23 Jan 2014 15:05:56 -0500
Message-Id: <1390507559-4697-14-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Add an emulate flag into the instruction interpreter, primarily for uprobes
support.

Signed-off-by: David A. Long <dave.long@linaro.org>
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
index db040ad..9421c0d 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -87,7 +87,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn, actions)) {
+	switch ((*decode_insn)(insn, &p->ainsn, true, actions)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index f612e8e..7fa5984 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -35,6 +35,7 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						struct arch_specific_insn *,
+						bool,
 						const union decode_action *);
 
 #ifdef CONFIG_THUMB2_KERNEL
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 0faa4b2..a4f6914 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -723,10 +723,10 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
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
index 69d4de5..1a3ddf8 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -862,20 +862,20 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 
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
index b26411e..dd95866 100644
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
index 492c5fd..2831401 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -253,7 +253,7 @@ set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
  * non-zero value, the corresponding nibble in pinsn is validated and modified
  * according to the type.
  */
-static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
+static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
 {
 	probes_opcode_t insn = *pinsn;
 	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
@@ -319,7 +319,9 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
 		insn |= new_bits & mask;
 	}
 
-	*pinsn = insn;
+	if (modify)
+		*pinsn = insn;
+
 	return true;
 
 reject:
@@ -381,13 +383,14 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		   const union decode_item *table, bool thumb,
-		   const union decode_action *actions)
+		   bool emulate, const union decode_action *actions)
 {
 	struct decode_header *h = (struct decode_header *)table;
 	struct decode_header *next;
 	bool matched = false;
 
-	insn = prepare_emulated_insn(insn, asi, thumb);
+	if (emulate)
+		insn = prepare_emulated_insn(insn, asi, thumb);
 
 	for (;; h = next) {
 		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
@@ -402,7 +405,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		if (!matched && (insn & h->mask.bits) != h->value.bits)
 			continue;
 
-		if (!decode_regs(&insn, regs))
+		if (!decode_regs(&insn, regs, emulate))
 			return INSN_REJECTED;
 
 		switch (type) {
@@ -426,6 +429,11 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 
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
index 785fcc1..3a1a5c6 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -399,7 +399,7 @@ probes_insn_handler_t probes_emulate_none;
 
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_item *table, bool thumb,
+		const union decode_item *table, bool thumb, bool emulate,
 		const union decode_action *actions);
 
 #endif
-- 
1.8.1.2

