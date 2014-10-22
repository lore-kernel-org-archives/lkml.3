Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbaJVLeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:34:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25525 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaJVLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:34:07 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v6 4/7] ARM: kprobes: collects stack consumption for store instructions
Date: Wed, 22 Oct 2014 19:32:02 +0800
Message-ID: <1413977525-51480-5-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
References: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use previous introduced checker on store instructions,
record stack consumption informations to arch_probes_insn. With such
information, kprobe opt can decide how much stack needs to be
protected.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/include/asm/probes.h   |  1 +
 arch/arm/kernel/kprobes-arm.c   |  8 ++---
 arch/arm/kernel/kprobes-thumb.c |  8 ++---
 arch/arm/kernel/probes-arm.c    | 19 +++++++++++
 arch/arm/kernel/probes-arm.h    |  7 +++++
 arch/arm/kernel/probes-thumb.c  | 70 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/probes-thumb.h  |  9 ++++++
 arch/arm/kernel/probes.c        | 64 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/probes.h        | 13 ++++++++
 arch/arm/kernel/uprobes-arm.c   |  8 ++---
 10 files changed, 195 insertions(+), 12 deletions(-)

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
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index 1094ff1..bb1bec3 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -316,11 +316,11 @@ const struct decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_MUL2] = {.handler = emulate_rd16rn12rm0rs8_rwflags_nopc},
 	[PROBES_SWP] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
 	[PROBES_LDRD] = {.handler = emulate_ldrdstrd},
-	[PROBES_STRD] = {.handler = emulate_ldrdstrd},
+	[PROBES_STRD] = {.checker = probes_check_arm_store_extra, .handler = emulate_ldrdstrd},
 	[PROBES_LOAD_EXTRA] = {.handler = emulate_ldr},
 	[PROBES_LOAD] = {.handler = emulate_ldr},
-	[PROBES_STORE_EXTRA] = {.handler = emulate_str},
-	[PROBES_STORE] = {.handler = emulate_str},
+	[PROBES_STORE_EXTRA] = {.checker = probes_check_arm_store_extra, .handler = emulate_str},
+	[PROBES_STORE] = {.checker = probes_check_arm_store, .handler = emulate_str},
 	[PROBES_MOV_IP_SP] = {.handler = simulate_mov_ipsp},
 	[PROBES_DATA_PROCESSING_REG] = {
 		.handler = emulate_rd12rn16rm0rs8_rwflags},
@@ -341,5 +341,5 @@ const struct decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_BITFIELD] = {.handler = emulate_rd12rm0_noflags_nopc},
 	[PROBES_BRANCH] = {.handler = simulate_bbl},
 	[PROBES_LDM] = {.decoder = kprobe_decode_ldmstm},
-	[PROBES_STM] = {.decoder = kprobe_decode_ldmstm},
+	[PROBES_STM] = {.checker = probes_check_stm, .decoder = kprobe_decode_ldmstm},
 };
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index c6426b6..5da4231 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -615,7 +615,7 @@ const struct decode_action kprobes_t16_actions[NUM_PROBES_T16_ACTIONS] = {
 	[PROBES_T16_ADD_SP] = {.handler = t16_simulate_add_sp_imm},
 	[PROBES_T16_CBZ] = {.handler = t16_simulate_cbz},
 	[PROBES_T16_SIGN_EXTEND] = {.handler = t16_emulate_loregs_rwflags},
-	[PROBES_T16_PUSH] = {.decoder = t16_decode_push},
+	[PROBES_T16_PUSH] = {.checker = t16_check_push, .decoder = t16_decode_push},
 	[PROBES_T16_POP] = {.decoder = t16_decode_pop},
 	[PROBES_T16_SEV] = {.handler = probes_emulate_none},
 	[PROBES_T16_WFE] = {.handler = probes_simulate_nop},
@@ -639,9 +639,9 @@ const struct decode_action kprobes_t16_actions[NUM_PROBES_T16_ACTIONS] = {
 
 const struct decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
 	[PROBES_T32_LDM] = {.decoder = t32_decode_ldmstm},
-	[PROBES_T32_STM] = {.decoder = t32_decode_ldmstm},
+	[PROBES_T32_STM] = {.checker = probes_check_stm, .decoder = t32_decode_ldmstm},
 	[PROBES_T32_LDRD] = {.handler = t32_emulate_ldrdstrd},
-	[PROBES_T32_STRD] = {.handler = t32_emulate_ldrdstrd},
+	[PROBES_T32_STRD] = {.checker = t32_check_strd, .handler = t32_emulate_ldrdstrd},
 	[PROBES_T32_TABLE_BRANCH] = {.handler = t32_simulate_table_branch},
 	[PROBES_T32_TST] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_MOV] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
@@ -661,7 +661,7 @@ const struct decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
 	[PROBES_T32_PLDI] = {.handler = probes_simulate_nop},
 	[PROBES_T32_LDR_LIT] = {.handler = t32_simulate_ldr_literal},
 	[PROBES_T32_LDR] = {.handler = t32_emulate_ldrstr},
-	[PROBES_T32_STR] = {.handler = t32_emulate_ldrstr},
+	[PROBES_T32_STR] = {.checker = t32_check_str, .handler = t32_emulate_ldrstr},
 	[PROBES_T32_SIGN_EXTEND] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_MEDIA] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_REVERSE] = {.handler = t32_emulate_rd8rn16_noflags},
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 148153e..90d2f29 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -109,6 +109,25 @@ void __kprobes simulate_mov_ipsp(probes_opcode_t insn,
 	regs->uregs[12] = regs->uregs[13];
 }
 
+enum probes_insn __kprobes probes_check_arm_store(probes_opcode_t insn,
+		       struct arch_probes_insn *asi,
+		       const struct decode_header *h)
+{
+	int imm = insn & 0xfff;
+	check_insn_stack_regs(insn, asi, h, imm);
+	return INSN_GOOD;
+}
+
+enum probes_insn __kprobes probes_check_arm_store_extra(probes_opcode_t insn,
+		       struct arch_probes_insn *asi,
+		       const struct decode_header *h)
+{
+	int imm = ((insn & 0xf00) >> 4) + (insn & 0xf);
+	check_insn_stack_regs(insn, asi, h, imm);
+	return INSN_GOOD;
+}
+
+
 /*
  * For the instruction masking and comparisons in all the "space_*"
  * functions below, Do _not_ rearrange the order of tests unless
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 18ffc9a..d0ad9a4 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -66,6 +66,13 @@ void __kprobes simulate_mrs(probes_opcode_t opcode,
 void __kprobes simulate_mov_ipsp(probes_opcode_t opcode,
 	struct arch_probes_insn *asi, struct pt_regs *regs);
 
+enum probes_insn __kprobes probes_check_arm_store(probes_opcode_t,
+	struct arch_probes_insn *,
+	const struct decode_header *);
+enum probes_insn __kprobes probes_check_arm_store_extra(probes_opcode_t,
+	struct arch_probes_insn *,
+	const struct decode_header *);
+
 extern const union decode_item probes_decode_arm_table[];
 
 enum probes_insn arm_probes_decode_insn(probes_opcode_t,
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 749d4cd..5d0c936 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -15,6 +15,76 @@
 #include "probes.h"
 #include "probes-thumb.h"
 
+enum probes_insn __kprobes t32_check_strd(probes_opcode_t insn,
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
+enum probes_insn __kprobes t32_check_str(probes_opcode_t insn,
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
+enum probes_insn __kprobes t16_check_push(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	unsigned int reglist = insn & 0x1ff;
+	asi->stack_space = hweight32(reglist) * 4;
+	return INSN_GOOD;
+}
 
 static const union decode_item t32_table_1110_100x_x0xx[] = {
 	/* Load/store multiple instructions */
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index a9c65c9..f908b12 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -100,4 +100,13 @@ enum probes_insn __kprobes
 thumb32_probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		bool emulate, const struct decode_action *actions);
 
+enum probes_insn __kprobes t32_check_strd(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h);
+enum probes_insn __kprobes t32_check_str(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h);
+enum probes_insn __kprobes t16_check_push(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h);
 #endif
diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index 6164b4d..8428fe8 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -188,6 +188,25 @@ void __kprobes probes_emulate_none(probes_opcode_t opcode,
 	asi->insn_fn();
 }
 
+/* ARM and Thumb can share this checker */
+enum probes_insn __kprobes probes_check_stm(probes_opcode_t insn,
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
@@ -395,6 +414,8 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 	bool matched = false;
 	probes_opcode_t origin_insn = insn;
 
+	asi->stack_space = 0;
+
 	if (emulate)
 		insn = prepare_emulated_insn(insn, asi, thumb);
 
@@ -464,3 +485,46 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
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
index c56dd3d..4c0a04a 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -410,4 +410,17 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 		const union decode_item *table, bool thumb, bool emulate,
 		const struct decode_action *actions);
 
+enum probes_insn __kprobes probes_check_stm(probes_opcode_t,
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
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
index 0a8caa3..1da524d 100644
--- a/arch/arm/kernel/uprobes-arm.c
+++ b/arch/arm/kernel/uprobes-arm.c
@@ -208,11 +208,11 @@ const struct decode_action uprobes_probes_actions[] = {
 	[PROBES_MUL2] = {.handler = probes_simulate_nop},
 	[PROBES_SWP] = {.handler = probes_simulate_nop},
 	[PROBES_LDRD] = {.decoder = decode_pc_ro},
-	[PROBES_STRD] = {.decoder = decode_pc_ro},
+	[PROBES_STRD] = {.checker = probes_check_arm_store_extra, .decoder = decode_pc_ro},
 	[PROBES_LOAD_EXTRA] = {.decoder = decode_pc_ro},
 	[PROBES_LOAD] = {.decoder = decode_ldr},
-	[PROBES_STORE_EXTRA] = {.decoder = decode_pc_ro},
-	[PROBES_STORE] = {.decoder = decode_pc_ro},
+	[PROBES_STORE_EXTRA] = {.checker = probes_check_arm_store_extra, .decoder = decode_pc_ro},
+	[PROBES_STORE] = {.checker = probes_check_arm_store, .decoder = decode_pc_ro},
 	[PROBES_MOV_IP_SP] = {.handler = simulate_mov_ipsp},
 	[PROBES_DATA_PROCESSING_REG] = {
 		.decoder = decode_rd12rn16rm0rs8_rwflags},
@@ -232,5 +232,5 @@ const struct decode_action uprobes_probes_actions[] = {
 	[PROBES_BITFIELD] = {.handler = probes_simulate_nop},
 	[PROBES_BRANCH] = {.handler = simulate_bbl},
 	[PROBES_LDM] = {.decoder = uprobe_decode_ldmstm},
-	[PROBES_STM] = {.decoder = uprobe_decode_ldmstm}
+	[PROBES_STM] = {.checker = probes_check_stm, .decoder = uprobe_decode_ldmstm}
 };
-- 
1.8.4

