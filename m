Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaJYSxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:53:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:47857 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaJYSx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:53:26 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>, <dave.long@linaro.org>,
        <taras.kondratiuk@linaro.org>, <ben.dooks@codethink.co.uk>,
        <cl@linux.com>, <rabin@rab.in>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH 2/4] ARM: kprobes: introduces checker
Date: Sat, 25 Oct 2014 14:42:51 +0800
Message-ID: <1414219373-20070-3-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1414219373-20070-1-git-send-email-wangnan0@huawei.com>
References: <1414219373-20070-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.544B46E0.013E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: ce07e409a22d2694ea1933fa38f6e503
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introdces 'checker' to decoding phase, and calls checkers
when instruction decoding. This allows further analysis for specific
instructions.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/kernel/kprobes.c      |  2 +-
 arch/arm/kernel/kprobes.h      |  3 ++-
 arch/arm/kernel/probes-arm.c   |  5 +++--
 arch/arm/kernel/probes-arm.h   |  3 ++-
 arch/arm/kernel/probes-thumb.c | 10 +++++----
 arch/arm/kernel/probes-thumb.h |  6 +++--
 arch/arm/kernel/probes.c       | 51 +++++++++++++++++++++++++++++++++++++++++-
 arch/arm/kernel/probes.h       | 11 ++++++++-
 arch/arm/kernel/uprobes.c      |  2 +-
 9 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 6d64420..3302983 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -90,7 +90,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn, true, actions)) {
+	switch ((*decode_insn)(insn, &p->ainsn, true, actions, NULL)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/kernel/kprobes.h
index 9a2712e..632fe0b 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/kernel/kprobes.h
@@ -36,7 +36,8 @@ kprobe_decode_ldmstm(kprobe_opcode_t insn, struct arch_probes_insn *asi,
 typedef enum probes_insn (kprobe_decode_insn_t)(probes_opcode_t,
 						struct arch_probes_insn *,
 						bool,
-						const union decode_action *);
+						const union decode_action *,
+						const struct decode_checker *[*]);
 
 #ifdef CONFIG_THUMB2_KERNEL
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index a17899f..d280e825 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -730,10 +730,11 @@ static void __kprobes arm_singlestep(probes_opcode_t insn,
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
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 74c7f97..185adaf 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -70,6 +70,7 @@ extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
 		struct arch_probes_insn *, bool emulate,
-		const union decode_action *actions);
+		const union decode_action *actions,
+		const struct decode_checker *checkers[]);
 
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index ac27d63..56925e4 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -901,20 +901,22 @@ static void __kprobes thumb32_singlestep(probes_opcode_t opcode,
 
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
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index f36aa21..2277744 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -95,9 +95,11 @@ extern const union decode_item probes_decode_thumb16_table[];
 
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
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index a8ab540..02598da 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
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
@@ -422,18 +453,36 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		}
 
 		case DECODE_TYPE_CUSTOM: {
+			int err;
 			struct decode_custom *d = (struct decode_custom *)h;
+			int action = d->decoder.action;
+
+			err = run_checkers(checkers, action, origin_insn, asi, h);
+			if (err == INSN_REJECTED)
+				return INSN_REJECTED;
 			return actions[d->decoder.action].decoder(insn, asi, h);
 		}
 
 		case DECODE_TYPE_SIMULATE: {
+			int err;
 			struct decode_simulate *d = (struct decode_simulate *)h;
+			int action = d->handler.action;
+
+			err = run_checkers(checkers, action, origin_insn, asi, h);
+			if (err == INSN_REJECTED)
+				return INSN_REJECTED;
 			asi->insn_handler = actions[d->handler.action].handler;
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
 				return actions[d->handler.action].decoder(insn,
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index dba9f24..b4bf1f5 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
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
diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/kernel/uprobes.c
index 56adf9c..372585a 100644
--- a/arch/arm/kernel/uprobes.c
+++ b/arch/arm/kernel/uprobes.c
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

