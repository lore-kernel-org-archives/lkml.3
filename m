Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3K0CzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:55:09 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:61341 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3K0CyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:54:00 -0500
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
Subject: [PATCH v3 13/15] ARM: Add an emulate flag to the kprobes/uprobes instruction decode functions
Date: Tue, 26 Nov 2013 21:53:32 -0500
Message-Id: <1385520814-10663-14-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

Add an emulate flag into the instruction interpreter, primarily for uprobes
support.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/kernel/kprobes.c      |  3 ++-
 arch/arm/kernel/kprobes.h      |  1 +
 arch/arm/kernel/probes-arm.c   |  4 ++--
 arch/arm/kernel/probes-arm.h   |  2 +-
 arch/arm/kernel/probes-thumb.c |  8 ++++----
 arch/arm/kernel/probes-thumb.h |  4 ++--
 arch/arm/kernel/probes.c       | 32 +++++++++++++++++++++++---------
 arch/arm/kernel/probes.h       |  2 +-
 8 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 0d9d49b..04690f9 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -87,7 +87,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn, actions)) {
+	switch ((*decode_insn)(insn, &p->ainsn,
+			       true, actions)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index e1305a8..580d82c 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -35,6 +35,7 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_specific_insn *asi,
 
 typedef enum probes_insn (kprobe_decode_insn_t)(kprobe_opcode_t,
 			struct arch_specific_insn *,
+			bool,
 			const union decode_item *);
 
 #ifdef CONFIG_THUMB2_KERNEL
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index a44c3ad..01e99f7 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -723,10 +723,10 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  */
 enum probes_insn __kprobes
 arm_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_item *actions)
+		bool emulate, const union decode_item *actions)
 {
 	asi->insn_singlestep = arm_singlestep;
 	asi->insn_check_cc = probes_condition_checks[insn>>28];
 	return probes_decode_insn(insn, asi, probes_decode_arm_table, false,
-			actions);
+			emulate, actions);
 }
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 7f81199..904033c 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -66,7 +66,7 @@ void __kprobes simulate_mov_ipsp(probes_opcode_t opcode,
 extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
-		struct arch_specific_insn *,
+		struct arch_specific_insn *, bool emulate,
 		const union decode_item *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 3f250e9..2ad0880 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -861,20 +861,20 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			   const union decode_item *actions)
+			   bool emulate, const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
 	return probes_decode_insn(insn, asi, probes_decode_thumb16_table, true,
-				  actions);
+				  emulate, actions);
 }
 
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-			   const union decode_item *actions)
+			   bool emulate, const union decode_item *actions)
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
 	return probes_decode_insn(insn, asi, probes_decode_thumb32_table, true,
-				  actions);
+				  emulate, actions);
 }
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index 556f067..78be667 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -87,9 +87,9 @@ extern const union decode_item probes_decode_thumb16_table[];
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_item *actions);
+		bool emulate, const union decode_item *actions);
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_item *actions);
+		bool emulate, const union decode_item *actions);
 
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index a0a4220..e691e12 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -193,7 +193,7 @@ void __kprobes probes_emulate_none(probes_opcode_t opcode,
  */
 static probes_opcode_t __kprobes
 prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-								bool thumb)
+			bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
 	if (thumb) {
@@ -218,7 +218,7 @@ prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
  */
 static void  __kprobes
 set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-								bool thumb)
+			bool thumb)
 {
 #ifdef CONFIG_THUMB2_KERNEL
 	if (thumb) {
@@ -253,7 +253,7 @@ set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
  * non-zero value, the corresponding nibble in pinsn is validated and modified
  * according to the type.
  */
-static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
+static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
 {
 	probes_opcode_t insn = *pinsn;
 	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
@@ -317,9 +317,16 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
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
@@ -380,14 +387,15 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
  */
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-				const union decode_item *table, bool thumb,
-				const union decode_item *actions)
+		   const union decode_item *table, bool thumb,
+		   bool emulate, const union decode_item *actions)
 {
 	struct decode_header *h = (struct decode_header *)table;
 	struct decode_header *next;
 	bool matched = false;
 
-	insn = prepare_emulated_insn(insn, asi, thumb);
+	if (emulate)
+		insn = prepare_emulated_insn(insn, asi, thumb);
 
 	for (;; h = next) {
 		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
@@ -402,7 +410,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 		if (!matched && (insn & h->mask.bits) != h->value.bits)
 			continue;
 
-		if (!decode_regs(&insn, regs))
+		if (!decode_regs(&insn, regs, emulate))
 			return INSN_REJECTED;
 
 		switch (type) {
@@ -415,7 +423,8 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_CUSTOM: {
 			struct decode_custom *d = (struct decode_custom *)h;
-			return actions[d->decoder.bits].decoder(insn, asi, h);
+			return actions[d->decoder.bits].decoder(insn,
+					asi, h);
 		}
 
 		case DECODE_TYPE_SIMULATE: {
@@ -426,6 +435,11 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
 
 		case DECODE_TYPE_EMULATE: {
 			struct decode_emulate *d = (struct decode_emulate *)h;
+
+			if (!emulate)
+				return actions[d->handler.bits].decoder(insn,
+								asi, h);
+
 			asi->insn_handler = actions[d->handler.bits].handler;
 			set_emulated_insn(insn, asi, thumb);
 			return INSN_GOOD;
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 9591c2c..233ab7b 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -389,7 +389,7 @@ probes_insn_handler_t probes_emulate_none;
 
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
-		const union decode_item *table, bool thumb,
+		const union decode_item *table, bool thumb, bool emulate,
 		const union decode_item *actions);
 
 #endif
-- 
1.8.1.2

