Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaJYS4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:56:03 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:48681 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaJYSz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:55:59 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>
CC: <linux@arm.linux.org.uk>, <will.deacon@arm.com>, <dave.long@linaro.org>,
        <taras.kondratiuk@linaro.org>, <ben.dooks@codethink.co.uk>,
        <cl@linux.com>, <rabin@rab.in>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH 3/4] ARM: kprobes: collects stack consumption for store instructions
Date: Sat, 25 Oct 2014 14:42:52 +0800
Message-ID: <1414219373-20070-4-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1414219373-20070-1-git-send-email-wangnan0@huawei.com>
References: <1414219373-20070-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.544B46E0.012C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: e8172fc82fe2d29389878911cb2d8861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use previous introduced checker on store instructions,
record stack consumption informations to arch_probes_insn. With such
information, kprobe opt can decide how much stack needs to be
protected.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/include/asm/probes.h  |  1 +
 arch/arm/kernel/kprobes.c      | 15 +++++++-
 arch/arm/kernel/probes-arm.c   | 25 +++++++++++++
 arch/arm/kernel/probes-arm.h   |  1 +
 arch/arm/kernel/probes-thumb.c | 80 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/probes-thumb.h |  2 ++
 arch/arm/kernel/probes.c       | 64 +++++++++++++++++++++++++++++++++
 arch/arm/kernel/probes.h       | 13 +++++++
 8 files changed, 200 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index 806cfe6..ccf9af3 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -38,6 +38,7 @@ struct arch_probes_insn {
 	probes_check_cc			*insn_check_cc;
 	probes_insn_singlestep_t	*insn_singlestep;
 	probes_insn_fn_t		*insn_fn;
+	int stack_space;
 };
 
 #endif
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 3302983..618531d 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -61,6 +61,16 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	kprobe_decode_insn_t *decode_insn;
 	const union decode_action *actions;
 	int is;
+	const struct decode_checker **checkers;
+#ifdef CONFIG_THUMB2_KERNEL
+	const struct decode_checker *t32_checkers[] =
+		{t32_stack_checker, NULL};
+	const struct decode_checker *t16_checkers[] =
+		{t16_stack_checker, NULL};
+#else
+	const struct decode_checker *arm_checkers[] =
+		{arm_stack_checker, NULL};
+#endif
 
 	if (in_exception_text(addr))
 		return -EINVAL;
@@ -74,9 +84,11 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		insn = __opcode_thumb32_compose(insn, inst2);
 		decode_insn = thumb32_probes_decode_insn;
 		actions = kprobes_t32_actions;
+		checkers = t32_checkers;
 	} else {
 		decode_insn = thumb16_probes_decode_insn;
 		actions = kprobes_t16_actions;
+		checkers = t16_checkers;
 	}
 #else /* !CONFIG_THUMB2_KERNEL */
 	thumb = false;
@@ -85,12 +97,13 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	insn = __mem_to_opcode_arm(*p->addr);
 	decode_insn = arm_probes_decode_insn;
 	actions = kprobes_arm_actions;
+	checkers = arm_checkers;
 #endif
 
 	p->opcode = insn;
 	p->ainsn.insn = tmp_insn;
 
-	switch ((*decode_insn)(insn, &p->ainsn, true, actions, NULL)) {
+	switch ((*decode_insn)(insn, &p->ainsn, true, actions, checkers)) {
 	case INSN_REJECTED:	/* not supported */
 		return -EINVAL;
 
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index d280e825..20e95c0 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -109,6 +109,31 @@ void __kprobes simulate_mov_ipsp(probes_opcode_t insn,
 	regs->uregs[12] = regs->uregs[13];
 }
 
+enum probes_insn __kprobes chk_stack_arm_store(probes_opcode_t insn,
+		       struct arch_probes_insn *asi,
+		       const struct decode_header *h)
+{
+	int imm = insn & 0xfff;
+	check_insn_stack_regs(insn, asi, h, imm);
+	return INSN_GOOD;
+}
+
+enum probes_insn __kprobes chk_stack_arm_store_extra(probes_opcode_t insn,
+		       struct arch_probes_insn *asi,
+		       const struct decode_header *h)
+{
+	int imm = ((insn & 0xf00) >> 4) + (insn & 0xf);
+	check_insn_stack_regs(insn, asi, h, imm);
+	return INSN_GOOD;
+}
+
+const struct decode_checker arm_stack_checker[NUM_PROBES_ARM_ACTIONS] = {
+	[PROBES_STRD] = {.checker = chk_stack_arm_store_extra},
+	[PROBES_STORE_EXTRA] = {.checker = chk_stack_arm_store_extra},
+	[PROBES_STRD] = {.checker = chk_stack_arm_store},
+	[PROBES_STM] = {.checker = chk_stack_stm},
+};
+
 /*
  * For the instruction masking and comparisons in all the "space_*"
  * functions below, Do _not_ rearrange the order of tests unless
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 185adaf..4d63cf8 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -73,4 +73,5 @@ enum probes_insn arm_probes_decode_insn(probes_opcode_t,
 		const union decode_action *actions,
 		const struct decode_checker *checkers[]);
 
+extern const struct decode_checker arm_stack_checker[];
 #endif
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 56925e4..8e7c5be 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -15,6 +15,86 @@
 #include "probes.h"
 #include "probes-thumb.h"
 
+enum probes_insn __kprobes chk_stack_t32_strd(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	int imm = insn & 0xff;
+	check_insn_stack_regs(insn, asi, h, imm);
+	return INSN_GOOD;
+}
+
+/*
+ * Note: This function doesn't process PROBES_T32_STRD.
+ */
+enum probes_insn __kprobes chk_stack_t32_check_str(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	int rn = -1, rm = -1;
+	u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
+	int index, add;
+
+	/* Rn is used in every cases */
+	BUG_ON((regs & 0xf0000) == 0);
+	rn = (insn & 0xf0000) >> 16;
+	if ((regs & 0xf) != 0)
+		rm = insn & 0xf;
+
+	/*
+	 * Rn is not SP. Rm can't be sp in any case.
+	 * So it is not a stack store.
+	 */
+	if (rn != 0xd)
+		return INSN_GOOD;
+
+	/*
+	 * For 'str? rx, [sp, ry]', ry can be negative. In addition,
+	 * index is true in every cases, so unable to determine stack
+	 * consumption.
+	 */
+	if (rm != -1) {
+		asi->stack_space = -1;
+		return INSN_GOOD;
+	}
+
+	/*
+	 * For 'str? rx, [sp, #+/-<imm>]', if bit 23 is set, index
+	 * and add are both set. Else, index and add are determined
+	 * by P bit and U bit (bit 10, 9)
+	 */
+	if (insn & 0x800000)
+		index = add = 1;
+	else {
+		index = (insn & (1 << 10));
+		add = (insn &(1 << 9));
+	}
+
+	if (!index || add)
+		return INSN_GOOD;
+
+	asi->stack_space = insn & 0xff;
+	return INSN_GOOD;
+}
+
+enum probes_insn __kprobes chk_stack_t16_push(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	unsigned int reglist = insn & 0x1ff;
+	asi->stack_space = hweight32(reglist) * 4;
+	return INSN_GOOD;
+}
+
+const struct decode_checker t32_stack_checker[NUM_PROBES_T32_ACTIONS] = {
+	[PROBES_T32_STM] = {.checker = chk_stack_stm},
+	[PROBES_T32_STRD] = {.checker = chk_stack_t32_strd},
+	[PROBES_T32_STR] = {.checker = chk_stack_t32_check_str},
+};
+
+const struct decode_checker t16_stack_checker[NUM_PROBES_T16_ACTIONS] = {
+	[PROBES_T16_PUSH] = {.checker = chk_stack_t16_push},
+};
 
 static const union decode_item t32_table_1110_100x_x0xx[] = {
 	/* Load/store multiple instructions */
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index 2277744..a5783d0 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -102,4 +102,6 @@ thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		bool emulate, const union decode_action *actions,
 		const struct decode_checker *checkers[]);
 
+extern const struct decode_checker t32_stack_checker[];
+extern const struct decode_checker t16_stack_checker[];
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index 02598da..4ef4087 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -188,6 +188,25 @@ void __kprobes probes_emulate_none(probes_opcode_t opcode,
 	asi->insn_fn();
 }
 
+/* ARM and Thumb can share this checker */
+enum probes_insn __kprobes chk_stack_stm(probes_opcode_t insn,
+		       struct arch_probes_insn *asi,
+		       const struct decode_header *h)
+{
+	unsigned int reglist = insn & 0xffff;
+	int ubit = insn & (1 << 23);
+	int pbit = insn & (1 << 24);
+	int rn = (insn >> 16) & 0xf;
+
+	/* This is stmi?, doesn't require extra stack */
+	if (ubit)
+		return INSN_GOOD;
+	/* If pbit == ubit (== 0), this is stmda, one dword is saved */
+	asi->stack_space = (rn == 0xd) ?
+		(hweight32(reglist) - ((!pbit == !ubit) ? 1 : 0)) * 4 : 0;
+	return INSN_GOOD;
+}
+
 /*
  * Prepare an instruction slot to receive an instruction for emulating.
  * This is done by placing a subroutine return after the location where the
@@ -425,6 +444,8 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 	 */
 	probes_opcode_t origin_insn = insn;
 
+	asi->stack_space = 0;
+
 	if (emulate)
 		insn = prepare_emulated_insn(insn, asi, thumb);
 
@@ -503,3 +524,46 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		}
 	}
 }
+
+int __kprobes check_insn_stack_regs(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h,
+		int imm)
+{
+	u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
+	int rn = -1, rm = -1, index, add;
+	asi->stack_space = 0;
+
+	if (((regs >> 16) & 0xf) != REG_TYPE_NONE)
+		rn = (insn >> 16) & 0xf;
+
+	if ((regs & 0xf) != REG_TYPE_NONE)
+		rm = insn & 0xf;
+
+	if ((rn != 13) && (rm != 13))
+		return NOT_STACK_STORE;
+
+	index = insn & (1 << 24);
+	add = insn & (1 << 23);
+
+	if (!index)
+		return NOT_STACK_STORE;
+
+	/*
+	 * Even if insn is 'str r0, [sp], +<Rm>', Rm may less than 0.
+	 * Therefore if both Rn and Rm are registers and !index,
+	 * We are unable to determine whether it is a stack store.
+	 */
+	if ((rn != -1) && (rm != -1)) {
+		asi->stack_space = -1;
+		return STACK_REG;
+	}
+
+	/*    'str(d/h) r0, [sp], #+/-<imm>' */
+	/* or 'str(d/h) r0, [sp, #+<imm>'] */
+	if (add)
+		return NOT_STACK_STORE;
+
+	asi->stack_space = imm;
+	return STACK_IMM;
+}
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index b4bf1f5..b52629c 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -413,4 +413,17 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		const union decode_action *actions,
 		const struct decode_checker **checkers);
 
+enum probes_insn __kprobes chk_stack_stm(probes_opcode_t,
+	struct arch_probes_insn *,
+	const struct decode_header *);
+
+enum {
+	NOT_STACK_STORE,
+	STACK_REG,
+	STACK_IMM,
+};
+int __kprobes check_insn_stack_regs(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h,
+		int imm);
 #endif
-- 
1.8.4

