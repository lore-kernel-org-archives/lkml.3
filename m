Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaL0Hkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 02:40:42 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:21284 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaL0Hki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 02:40:38 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v17 10/11] ARM: kprobes: check register usage for probed instruction.
Date: Sat, 27 Dec 2014 15:35:54 +0800
Message-ID: <1419665754-13283-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1419665637-12744-1-git-send-email-wangnan0@huawei.com>
References: <1419665637-12744-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.549E6275.0119,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1ebb210be439f2a1c969a619bfe4de64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch utilizes previous introduced checker to check register usage
for probed ARM instruction and saves it in a mask. Futher patch will
use such information to avoid simuation or emulation.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/include/asm/probes.h          |   9 +++
 arch/arm/probes/decode.c               |   7 ++
 arch/arm/probes/kprobes/actions-arm.c  |   2 +-
 arch/arm/probes/kprobes/checkers-arm.c | 124 +++++++++++++++++++++++++++++++++
 arch/arm/probes/kprobes/checkers.h     |   1 +
 5 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/probes.h b/arch/arm/include/asm/probes.h
index f0a1ee8..ee8725c 100644
--- a/arch/arm/include/asm/probes.h
+++ b/arch/arm/include/asm/probes.h
@@ -41,6 +41,15 @@ struct arch_probes_insn {
 	probes_insn_singlestep_t	*insn_singlestep;
 	probes_insn_fn_t		*insn_fn;
 	int stack_space;
+
+	/* Use 2 bits for a register. One more bit for extension */
+#define REG_NO_USE	(0)
+#define REG_USE		(1)
+#define __set_register_flag(m, n, f)	do {(m) = (m) | ((f) << ((n) * 2));} while(0)
+#define __clear_register_flag(m, n, f)	do {(m) = (m) & (~((f) << ((n) * 2)));} while(0)
+#define set_register_nouse(m, n)	__clear_register_flag(m, n, REG_NO_USE)
+#define set_register_use(m, n)	__set_register_flag(m, n, REG_USE)
+	int register_usage_mask;
 };
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/arm/probes/decode.c b/arch/arm/probes/decode.c
index f9d7c42..d60a1b2 100644
--- a/arch/arm/probes/decode.c
+++ b/arch/arm/probes/decode.c
@@ -435,6 +435,13 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 	 */
 	asi->stack_space = 0;
 
+	/*
+	 * Similay to stack_space, register_usage_mask is filled by
+	 * checkers. Its default value is set to ~0, which is 'all
+	 * registers are used', to prevent any potential optimization.
+	 */
+	asi->register_usage_mask = ~(0UL);
+
 	if (emulate)
 		insn = prepare_emulated_insn(insn, asi, thumb);
 
diff --git a/arch/arm/probes/kprobes/actions-arm.c b/arch/arm/probes/kprobes/actions-arm.c
index 4fedd4c..26e435b 100644
--- a/arch/arm/probes/kprobes/actions-arm.c
+++ b/arch/arm/probes/kprobes/actions-arm.c
@@ -340,4 +340,4 @@ const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
 };
 
-const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, NULL};
+const struct decode_checker *kprobes_arm_checkers[] = {arm_stack_checker, arm_regs_checker, NULL};
diff --git a/arch/arm/probes/kprobes/checkers-arm.c b/arch/arm/probes/kprobes/checkers-arm.c
index f817663..df1d77b 100644
--- a/arch/arm/probes/kprobes/checkers-arm.c
+++ b/arch/arm/probes/kprobes/checkers-arm.c
@@ -97,3 +97,127 @@ const struct decode_checker arm_stack_checker[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_STORE] = {.checker = arm_check_stack},
 	[PROBES_LDMSTM] = {.checker = arm_check_stack},
 };
+
+static enum probes_insn __kprobes arm_check_regs_nouse(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	asi->register_usage_mask = 0;
+	return INSN_GOOD;
+}
+
+static void __arm_check_regs(probes_opcode_t insn,
+		const struct decode_header *h,
+		int *quintuple)
+{
+	int i;
+	u32 regs = h->type_regs.bits >> DECODE_TYPE_BITS;
+	probes_opcode_t mask, shifted;
+
+	memset(quintuple, 0xff, sizeof(int) * 5);
+	for (i = 0, shifted = insn, mask = 0xf; regs != 0;
+			regs >>= 4, mask <<= 4, shifted >>= 4, i++)
+		if (regs & 0xf)
+			quintuple[i] = shifted & 0xf;
+}
+
+static enum probes_insn arm_check_regs_normal(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	int quintuple[5], i;
+	asi->register_usage_mask = 0;
+	__arm_check_regs(insn, h, quintuple);
+	for (i = 0; i < 5; i++) {
+		int r = quintuple[i];
+		if (r < 0)
+			continue;
+		set_register_use(asi->register_usage_mask, r);
+	}
+
+	return INSN_GOOD;
+}
+
+static enum probes_insn arm_check_regs_ldmstm(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	unsigned int reglist = insn & 0xffff;
+	unsigned int rn = (insn >> 16) & 0xf;
+	int i;
+
+	set_register_use(asi->register_usage_mask, rn);
+	for (i = 0; reglist > 0; i++, reglist >>= 1)
+		if (reglist & 1)
+			set_register_use(asi->register_usage_mask, i);
+	return INSN_GOOD;
+}
+
+static enum probes_insn arm_check_regs_mov_ip_sp(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	/* should be 'mov ip, sp' */
+	set_register_use(asi->register_usage_mask, 12);
+	set_register_use(asi->register_usage_mask, 13);
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
+ * from others, a specific checker is required for Rt/d and Rt2/d2.
+ */
+static enum probes_insn arm_check_regs_ldrdstrd(probes_opcode_t insn,
+		struct arch_probes_insn *asi,
+		const struct decode_header *h)
+{
+	int quintuple[5], rn, rdt, rm;
+	asi->register_usage_mask = 0;
+	__arm_check_regs(insn, h, quintuple);
+
+	rn = quintuple[4];
+	rdt = quintuple[3];
+	rm = quintuple[0];
+        set_register_use(asi->register_usage_mask, rn);
+        set_register_use(asi->register_usage_mask, rdt);
+        set_register_use(asi->register_usage_mask, rdt + 1);
+	if (rm >= 0)
+		set_register_use(asi->register_usage_mask, rm);
+
+	return INSN_GOOD;
+}
+
+
+const struct decode_checker arm_regs_checker[NUM_PROBES_ARM_ACTIONS] = {
+	[PROBES_EMULATE_NONE] = {.checker = arm_check_regs_nouse},
+	[PROBES_SIMULATE_NOP] = {.checker = arm_check_regs_nouse},
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
1.8.4

