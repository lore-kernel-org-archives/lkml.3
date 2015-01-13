Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbbAMQN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:13:56 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:45611 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbbAMQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:13:54 -0500
Message-ID: <1421165628.4215.63.camel@linaro.org>
Subject: [PATCH] ARM: kprobes: check register usage for probed instruction
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, lizefan@huawei.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 13 Jan 2015 16:13:48 +0000
In-Reply-To: <1421161268.4215.56.camel@linaro.org>
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
	 <1420457384-77449-1-git-send-email-wangnan0@huawei.com>
	 <1421161268.4215.56.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch utilizes the previously introduced checker to check
register usage for probed ARM instruction and saves it in a mask.
A further patch will use such information to avoid simulation or
emulation.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Reviewed-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
---

This patch applies my review comments on "[PATCH v19 10/11] ARM:
kprobes: check register usage for probed instruction."

It is also rebased on top of the kprobes-opt branch at
git://git.linaro.org/people/tixy/kernel.git

 arch/arm/include/asm/probes.h          |  1 +
 arch/arm/probes/decode.c               |  7 +++
 arch/arm/probes/kprobes/actions-arm.c  |  2 +-
 arch/arm/probes/kprobes/checkers-arm.c | 93 ++++++++++++++++++++++++++++++++++
 arch/arm/probes/kprobes/checkers.h     |  1 +
 5 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index cd9e815..b668e60 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -41,6 +41,7 @@ struct arch_probes_insn {
 	probes_insn_singlestep_t	*insn_singlestep;
 	probes_insn_fn_t		*insn_fn;
 	int				stack_space;
+	unsigned long			register_usage_flags;
 };
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/probes/decode.c b/arch/arm/probes/decode.c
index f9d7c42..880ebe0 100644
--- a/arch/arm/probes/decode.c
+++ b/arch/arm/probes/decode.c
@@ -435,6 +435,13 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 	 */
 	asi->stack_space = 0;
 
+	/*
+	 * Similarly to stack_space, register_usage_flags is filled by
+	 * checkers. Its default value is set to ~0, which is 'all
+	 * registers are used', to prevent any potential optimization.
+	 */
+	asi->register_usage_flags = ~0UL;
+
 	if (emulate)
 		insn = prepare_emulated_insn(insn, asi, thumb);
 
diff --git a/arch/arm/probes/kprobes/actions-arm.c b/arch/arm/probes/kprobes/actions-arm.c
index 06988ef..b9056d6 100644
--- a/arch/arm/probes/kprobes/actions-arm.c
+++ b/arch/arm/probes/kprobes/actions-arm.c
@@ -341,4 +341,4 @@ const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
 };
 
-const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, NULL};
+const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, arm_regs_checker, NULL};
diff --git a/arch/arm/probes/kprobes/checkers-arm.c b/arch/arm/probes/kprobes/checkers-arm.c
index f817663..7b98173 100644
--- a/arch/arm/probes/kprobes/checkers-arm.c
+++ b/arch/arm/probes/kprobes/checkers-arm.c
@@ -97,3 +97,96 @@ const struct decode_checker arm_stack_checker[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_STORE] = {.checker = arm_check_stack},
 	[PROBES_LDMSTM] = {.checker = arm_check_stack},
 };
+
+static enum probes_insn __kprobes arm_check_regs_nouse(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	asi->register_usage_flags = 0;
+	return INSN_GOOD;
+}
+
+static enum probes_insn arm_check_regs_normal(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
+	int i;
+
+	asi->register_usage_flags = 0;
+	for (i = 0; i < 5; regs >>= 4, insn >>= 4, i++)
+		if (regs & 0xf)
+			asi->register_usage_flags |= 1 << (insn & 0xf);
+
+	return INSN_GOOD;
+}
+
+
+static enum probes_insn arm_check_regs_ldmstm(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	unsigned int reglist = insn & 0xffff;
+	unsigned int rn = (insn >> 16) & 0xf;
+	asi->register_usage_flags = reglist | (1 << rn);
+	return INSN_GOOD;
+}
+
+static enum probes_insn arm_check_regs_mov_ip_sp(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	/* Instruction is 'mov ip, sp' i.e. 'mov r12, r13' */
+	asi->register_usage_flags = (1 << 12) | (1<< 13);
+	return INSN_GOOD;
+}
+
+/*
+ *                                    | Rn |Rt/d|         | Rm |
+ * LDRD (register)      cccc 000x x0x0 xxxx xxxx xxxx 1101 xxxx
+ * STRD (register)      cccc 000x x0x0 xxxx xxxx xxxx 1111 xxxx
+ *                                    | Rn |Rt/d|         |imm4L|
+ * LDRD (immediate)     cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx
+ * STRD (immediate)     cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx
+ *
+ * Such instructions access Rt/d and its next register, so different
+ * from others, a specific checker is required to handle this extra
+ * implicit register usage.
+ */
+static enum probes_insn arm_check_regs_ldrdstrd(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	int rdt = (insn >> 12) & 0xf;
+	arm_check_regs_normal(insn, asi, h);
+	asi->register_usage_flags |= 1 << (rdt + 1);
+	return INSN_GOOD;
+}
+
+
+const struct decode_checker arm_regs_checker[NUM_PROBES_ARM_ACTIONS] = {
+	[PROBES_MRS] = {.checker = arm_check_regs_normal},
+	[PROBES_SATURATING_ARITHMETIC] = {.checker = arm_check_regs_normal},
+	[PROBES_MUL1] = {.checker = arm_check_regs_normal},
+	[PROBES_MUL2] = {.checker = arm_check_regs_normal},
+	[PROBES_MUL_ADD_LONG] = {.checker = arm_check_regs_normal},
+	[PROBES_MUL_ADD] = {.checker = arm_check_regs_normal},
+	[PROBES_LOAD] = {.checker = arm_check_regs_normal},
+	[PROBES_LOAD_EXTRA] = {.checker = arm_check_regs_normal},
+	[PROBES_STORE] = {.checker = arm_check_regs_normal},
+	[PROBES_STORE_EXTRA] = {.checker = arm_check_regs_normal},
+	[PROBES_DATA_PROCESSING_REG] = {.checker = arm_check_regs_normal},
+	[PROBES_DATA_PROCESSING_IMM] = {.checker = arm_check_regs_normal},
+	[PROBES_SEV] = {.checker = arm_check_regs_nouse},
+	[PROBES_WFE] = {.checker = arm_check_regs_nouse},
+	[PROBES_SATURATE] = {.checker = arm_check_regs_normal},
+	[PROBES_REV] = {.checker = arm_check_regs_normal},
+	[PROBES_MMI] = {.checker = arm_check_regs_normal},
+	[PROBES_PACK] = {.checker = arm_check_regs_normal},
+	[PROBES_EXTEND] = {.checker = arm_check_regs_normal},
+	[PROBES_EXTEND_ADD] = {.checker = arm_check_regs_normal},
+	[PROBES_BITFIELD] = {.checker = arm_check_regs_normal},
+	[PROBES_LDMSTM] = {.checker = arm_check_regs_ldmstm},
+	[PROBES_MOV_IP_SP] = {.checker = arm_check_regs_mov_ip_sp},
+	[PROBES_LDRSTRD] = {.checker = arm_check_regs_ldrdstrd},
+};
diff --git a/arch/arm/probes/kprobes/checkers.h b/arch/arm/probes/kprobes/checkers.h
index bddfa0e..cf6c9e7 100644
--- a/arch/arm/probes/kprobes/checkers.h
+++ b/arch/arm/probes/kprobes/checkers.h
@@ -47,6 +47,7 @@ extern const union decode_action stack_check_actions[];
 
 #ifndef CONFIG_THUMB2_KERNEL
 extern const struct decode_checker arm_stack_checker[];
+extern const struct decode_checker arm_regs_checker[];
 #else
 #endif
 extern const struct decode_checker t32_stack_checker[];
-- 
2.1.4



