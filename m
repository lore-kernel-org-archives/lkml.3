Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934566AbaLKKIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:08:38 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:54192 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934501AbaLKKHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:07:47 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v16 2/8] ARM: kprobes: introduces checker
Date: Thu, 11 Dec 2014 18:03:37 +0800
Message-ID: <1418292223-75148-3-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418292223-75148-1-git-send-email-wangnan0@huawei.com>
References: <1418292223-75148-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54896CFD.0288,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 79cbead4e5d05f15124691930d76ad83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introdces 'checker' to decoding phase, and calls checkers
when instruction decoding. This allows further decoding for specific
instructions.  This patch introduces a stub call of checkers in kprobe
arch_prepare_kprobe() as an example and for further expansion.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Reviewed-by: Jon Medhurst <tixy@linaro.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

v1 -> v2:
 - kprobe checker stubs are introduced in this patch.

v2 -> v3:
 - Code cleanups following Masami Hiramatsu and Tixy's advises.
 - Commit message improvements.

v3 -> v4:
 - Move to arch/arm/probes.
---
 arch/arm/probes/decode-arm.c            |  5 +--
 arch/arm/probes/decode-arm.h            |  3 +-
 arch/arm/probes/decode-thumb.c          | 10 +++---
 arch/arm/probes/decode-thumb.h          |  6 ++--
 arch/arm/probes/decode.c                | 60 +++++++++++++++++++++++++++++----
 arch/arm/probes/decode.h                | 11 +++++-
 arch/arm/probes/kprobes/actions-arm.c   |  2 ++
 arch/arm/probes/kprobes/actions-thumb.c |  3 ++
 arch/arm/probes/kprobes/core.c          |  6 +++-
 arch/arm/probes/kprobes/core.h          |  7 ++--
 arch/arm/probes/uprobes/core.c          |  2 +-
 11 files changed, 95 insertions(+), 20 deletions(-)

diff --git a/arch/arm/probes/decode-arm.c b/arch/arm/probes/decode-arm.c
index e39cc75..f46d8fc 100644
--- a/arch/arm/probes/decode-arm.c
+++ b/arch/arm/probes/decode-arm.c
@@ -726,10 +726,11 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
  */
 enum probes_insn __kprobes
 arm_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-		       bool emulate, const union decode_action *actions)
+		       bool emulate, const union decode_action *actions,
+		       const struct decode_checker *checkers[])
 {
 	asi->insn_singlestep = arm_singlestep;
 	asi->insn_check_cc = probes_condition_checks[insn>>28];
 	return probes_decode_insn(insn, asi, probes_decode_arm_table, false,
-				  emulate, actions);
+				  emulate, actions, checkers);
 }
diff --git a/arch/arm/probes/decode-arm.h b/arch/arm/probes/decode-arm.h
index 9c56b40..a7b0398 100644
--- a/arch/arm/probes/decode-arm.h
+++ b/arch/arm/probes/decode-arm.h
@@ -70,6 +70,7 @@ extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
 		struct arch_probes_insn *, bool emulate,
-		const union decode_action *actions);
+		const union decode_action *actions,
+		const struct decode_checker *checkers[]);
 
 #endif
diff --git a/arch/arm/probes/decode-thumb.c b/arch/arm/probes/decode-thumb.c
index 2f0453a..985e7dd 100644
--- a/arch/arm/probes/decode-thumb.c
+++ b/arch/arm/probes/decode-thumb.c
@@ -863,20 +863,22 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-			   bool emulate, const union decode_action *actions)
+			   bool emulate, const union decode_action *actions,
+			   const struct decode_checker *checkers[])
 {
 	asi->insn_singlestep = thumb16_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
 	return probes_decode_insn(insn, asi, probes_decode_thumb16_table, true,
-				  emulate, actions);
+				  emulate, actions, checkers);
 }
 
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-			   bool emulate, const union decode_action *actions)
+			   bool emulate, const union decode_action *actions,
+			   const struct decode_checker *checkers[])
 {
 	asi->insn_singlestep = thumb32_singlestep;
 	asi->insn_check_cc = thumb_check_cc;
 	return probes_decode_insn(insn, asi, probes_decode_thumb32_table, true,
-				  emulate, actions);
+				  emulate, actions, checkers);
 }
diff --git a/arch/arm/probes/decode-thumb.h b/arch/arm/probes/decode-thumb.h
index 039013c..8457add 100644
--- a/arch/arm/probes/decode-thumb.h
+++ b/arch/arm/probes/decode-thumb.h
@@ -91,9 +91,11 @@ extern const union decode_item probes_decode_thumb16_table[];
 
 enum probes_insn __kprobes
 thumb16_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-		bool emulate, const union decode_action *actions);
+		bool emulate, const union decode_action *actions,
+		const struct decode_checker *checkers[]);
 enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
-		bool emulate, const union decode_action *actions);
+		bool emulate, const union decode_action *actions,
+		const struct decode_checker *checkers[]);
 
 #endif
diff --git a/arch/arm/probes/decode.c b/arch/arm/probes/decode.c
index 3b05d57..c7d4420 100644
--- a/arch/arm/probes/decode.c
+++ b/arch/arm/probes/decode.c
@@ -342,6 +342,31 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 	[DECODE_TYPE_REJECT]	= sizeof(struct decode_reject)
 };
 
+static int run_checkers(const struct decode_checker *checkers[],
+		int action, probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	const struct decode_checker **p;
+
+	if (!checkers)
+		return INSN_GOOD;
+
+	p = checkers;
+	while (*p != NULL) {
+		int retval;
+		probes_check_t *checker_func = (*p)[action].checker;
+
+		retval = INSN_GOOD;
+		if (checker_func)
+			retval = checker_func(insn, asi, h);
+		if (retval == INSN_REJECTED)
+			return retval;
+		p++;
+	}
+	return INSN_GOOD;
+}
+
 /*
  * probes_decode_insn operates on data tables in order to decode an ARM
  * architecture instruction onto which a kprobe has been placed.
@@ -388,11 +413,17 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		   const union decode_item *table, bool thumb,
-		   bool emulate, const union decode_action *actions)
+		   bool emulate, const union decode_action *actions,
+		   const struct decode_checker *checkers[])
 {
 	const struct decode_header *h = (struct decode_header *)table;
 	const struct decode_header *next;
 	bool matched = false;
+	/*
+	 * @insn can be modified by decode_regs. Save its original
+	 * value for checkers.
+	 */
+	probes_opcode_t origin_insn = insn;
 
 	if (emulate)
 		insn = prepare_emulated_insn(insn, asi, thumb);
@@ -422,24 +453,41 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		}
 
 		case DECODE_TYPE_CUSTOM: {
+			int err;
 			struct decode_custom *d = (struct decode_custom *)h;
-			return actions[d->decoder.action].decoder(insn, asi, h);
+			int action = d->decoder.action;
+
+			err = run_checkers(checkers, action, origin_insn, asi, h);
+			if (err == INSN_REJECTED)
+				return INSN_REJECTED;
+			return actions[action].decoder(insn, asi, h);
 		}
 
 		case DECODE_TYPE_SIMULATE: {
+			int err;
 			struct decode_simulate *d = (struct decode_simulate *)h;
-			asi->insn_handler = actions[d->handler.action].handler;
+			int action = d->handler.action;
+
+			err = run_checkers(checkers, action, origin_insn, asi, h);
+			if (err == INSN_REJECTED)
+				return INSN_REJECTED;
+			asi->insn_handler = actions[action].handler;
 			return INSN_GOOD_NO_SLOT;
 		}
 
 		case DECODE_TYPE_EMULATE: {
+			int err;
 			struct decode_emulate *d = (struct decode_emulate *)h;
+			int action = d->handler.action;
+
+			err = run_checkers(checkers, action, origin_insn, asi, h);
+			if (err == INSN_REJECTED)
+				return INSN_REJECTED;
 
 			if (!emulate)
-				return actions[d->handler.action].decoder(insn,
-					asi, h);
+				return actions[action].decoder(insn, asi, h);
 
-			asi->insn_handler = actions[d->handler.action].handler;
+			asi->insn_handler = actions[action].handler;
 			set_emulated_insn(insn, asi, thumb);
 			return INSN_GOOD;
 		}
diff --git a/arch/arm/probes/decode.h b/arch/arm/probes/decode.h
index 1d0b531..f9b08ba 100644
--- a/arch/arm/probes/decode.h
+++ b/arch/arm/probes/decode.h
@@ -314,6 +314,14 @@ union decode_action {
 	probes_custom_decode_t	*decoder;
 };
 
+typedef enum probes_insn (probes_check_t)(probes_opcode_t,
+					   struct arch_probes_insn *,
+					   const struct decode_header *);
+
+struct decode_checker {
+	probes_check_t	*checker;
+};
+
 #define DECODE_END			\
 	{.bits = DECODE_TYPE_END}
 
@@ -402,6 +410,7 @@ probes_insn_handler_t probes_emulate_none;
 int __kprobes
 probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		const union decode_item *table, bool thumb, bool emulate,
-		const union decode_action *actions);
+		const union decode_action *actions,
+		const struct decode_checker **checkers);
 
 #endif
diff --git a/arch/arm/probes/kprobes/actions-arm.c b/arch/arm/probes/kprobes/actions-arm.c
index 8797879..3c3afa4 100644
--- a/arch/arm/probes/kprobes/actions-arm.c
+++ b/arch/arm/probes/kprobes/actions-arm.c
@@ -341,3 +341,5 @@ const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_BRANCH] = {.handler = simulate_bbl},
 	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
 };
+
+const struct decode_checker *kprobes_arm_checkers[] = {NULL};
diff --git a/arch/arm/probes/kprobes/actions-thumb.c b/arch/arm/probes/kprobes/actions-thumb.c
index 6c4e60b..2796121 100644
--- a/arch/arm/probes/kprobes/actions-thumb.c
+++ b/arch/arm/probes/kprobes/actions-thumb.c
@@ -664,3 +664,6 @@ const union decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
 	[PROBES_T32_MUL_ADD_LONG] = {
 		.handler = t32_emulate_rdlo12rdhi8rn16rm0_noflags},
 };
+
+const struct decode_checker *kprobes_t32_checkers[] = {NULL};
+const struct decode_checker *kprobes_t16_checkers[] = {NULL};
diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
index 701f49d..74f3dc3 100644
--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -61,6 +61,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	kprobe_decode_insn_t *decode_insn;
 	const union decode_action *actions;
 	int is;
+	const struct decode_checker **checkers;
 
 	if (in_exception_text(addr))
 		return -EINVAL;
@@ -74,9 +75,11 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		insn = __opcode_thumb32_compose(insn, inst2);
 		decode_insn = thumb32_probes_decode_insn;
 		actions = kprobes_t32_actions;
+		checkers = kprobes_t32_checkers;
 	} else {
 		decode_insn = thumb16_probes_decode_insn;
 		actions = kprobes_t16_actions;
+		checkers = kprobes_t16_checkers;
 	}
 #else /* !CONFIG_THUMB2_KERNEL */
 	thumb = false;
@@ -85,12 +88,13 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	insn = __mem_to_opcode_arm(*p->addr);
 	decode_insn = arm_probes_decode_insn;
 	actions = kprobes_arm_actions;
+	checkers = kprobes_arm_checkers;
 #endif
 
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn, true, actions)) {
+	switch ((*decode_insn)(insn, &p->ainsn, true, actions, checkers)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/probes/kprobes/core.h b/arch/arm/probes/kprobes/core.h
index 2e1e5a3..f88c79f 100644
--- a/arch/arm/probes/kprobes/core.h
+++ b/arch/arm/probes/kprobes/core.h
@@ -37,16 +37,19 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_probes_insn *asi,
 typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						struct arch_probes_insn *,
 						bool,
-						const union decode_action *);
+						const union decode_action *,
+						const struct decode_checker *[*]);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
 extern const union decode_action kprobes_t32_actions[];
 extern const union decode_action kprobes_t16_actions[];
-
+extern const struct decode_checker *kprobes_t32_checkers[];
+extern const struct decode_checker *kprobes_t16_checkers[];
 #else /* !CONFIG_THUMB2_KERNEL */
 
 extern const union decode_action kprobes_arm_actions[];
+extern const struct decode_checker *kprobes_arm_checkers[];
 
 #endif
 
diff --git a/arch/arm/probes/uprobes/core.c b/arch/arm/probes/uprobes/core.c
index b2954f6..d1329f1 100644
--- a/arch/arm/probes/uprobes/core.c
+++ b/arch/arm/probes/uprobes/core.c
@@ -88,7 +88,7 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	auprobe->ixol[1] = __opcode_to_mem_arm(UPROBE_SS_ARM_INSN);
 
 	ret = arm_probes_decode_insn(insn, &auprobe->asi, false,
-				     uprobes_probes_actions);
+				     uprobes_probes_actions, NULL);
 	switch (ret) {
 	case INSN_REJECTED:
 		return -EINVAL;
-- 
1.8.4

