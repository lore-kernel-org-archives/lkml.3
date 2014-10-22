Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbaJVLeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:34:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25527 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbaJVLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:34:08 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v6 2/7] ARM: kprobes: seprates load and store actions
Date: Wed, 22 Oct 2014 19:32:00 +0800
Message-ID: <1413977525-51480-3-git-send-email-wangnan0@huawei.com>
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

This patch seprates actions for load and store. Following patches will
check store instructions for more informations.

Coverage test complains register test coverage missing after this
sepration. This patch introduces one testcase for it.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/kernel/kprobes-arm.c        |  6 ++-
 arch/arm/kernel/kprobes-test-arm.c   |  1 +
 arch/arm/kernel/kprobes-test-thumb.c | 13 ++++++
 arch/arm/kernel/kprobes-thumb.c      | 18 ++++++---
 arch/arm/kernel/probes-arm.c         | 11 +++--
 arch/arm/kernel/probes-arm.h         |  6 ++-
 arch/arm/kernel/probes-thumb.c       | 78 +++++++++++++++++++++++++++---------
 arch/arm/kernel/probes-thumb.h       | 18 ++++++---
 arch/arm/kernel/uprobes-arm.c        |  6 ++-
 9 files changed, 116 insertions(+), 41 deletions(-)

diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/kernel/kprobes-arm.c
index 6df9f1f..1094ff1 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/kernel/kprobes-arm.c
@@ -315,7 +315,8 @@ const struct decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_MUL1] = {.handler = emulate_rdlo12rdhi16rn0rm8_rwflags_nopc},
 	[PROBES_MUL2] = {.handler = emulate_rd16rn12rm0rs8_rwflags_nopc},
 	[PROBES_SWP] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
-	[PROBES_LDRSTRD] = {.handler = emulate_ldrdstrd},
+	[PROBES_LDRD] = {.handler = emulate_ldrdstrd},
+	[PROBES_STRD] = {.handler = emulate_ldrdstrd},
 	[PROBES_LOAD_EXTRA] = {.handler = emulate_ldr},
 	[PROBES_LOAD] = {.handler = emulate_ldr},
 	[PROBES_STORE_EXTRA] = {.handler = emulate_str},
@@ -339,5 +340,6 @@ const struct decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 	[PROBES_MUL_ADD] = {.handler = emulate_rd16rn12rm0rs8_rwflags_nopc},
 	[PROBES_BITFIELD] = {.handler = emulate_rd12rm0_noflags_nopc},
 	[PROBES_BRANCH] = {.handler = simulate_bbl},
-	[PROBES_LDMSTM] = {.decoder = kprobe_decode_ldmstm}
+	[PROBES_LDM] = {.decoder = kprobe_decode_ldmstm},
+	[PROBES_STM] = {.decoder = kprobe_decode_ldmstm},
 };
diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index cb14242..264c064 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -571,6 +571,7 @@ void kprobe_arm_test_cases(void)
 	TEST_RPR(  "strd	r",2, VAL1,", [r",5, 24,"], r",4,48,"")
 	TEST_RPR(  "strd	r",10,VAL2,", [r",9, 48,"], -r",7,24,"")
 	TEST_UNSUPPORTED(__inst_arm(0xe1afc0fa) "	@ strd r12, [pc, r10]!")
+	TEST_UNSUPPORTED(__inst_arm(0xe1aac0ff) "	@ strd r12, [r10, pc]!")
 
 	TEST_PR(   "ldrd	r0, [r",0, 48,", -r",2,24,"]")
 	TEST_PR(   "ldrmid	r8, [r",13,0, ", r",12,48,"]")
diff --git a/arch/arm/kernel/kprobes-test-thumb.c b/arch/arm/kernel/kprobes-test-thumb.c
index 844dd10..ed863c4 100644
--- a/arch/arm/kernel/kprobes-test-thumb.c
+++ b/arch/arm/kernel/kprobes-test-thumb.c
@@ -410,6 +410,13 @@ void kprobe_thumb32_test_cases(void)
 	TEST_UNSUPPORTED(__inst_thumb32(0xe9d47d00) "	@ ldrd	r7, sp, [r4]")
 	TEST_UNSUPPORTED(__inst_thumb32(0xe9d47f00) "	@ ldrd	r7, pc, [r4]")
 
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9efec04) "	@ strd	r14, r12, [pc, #16]!")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8efec04) "	@ strd	r14, r12, [pc], #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9c4d800) "	@ strd	sp, r8, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9c4f800) "	@ strd	pc, r8, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9c47d00) "	@ strd	r7, sp, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9c47f00) "	@ strd	r7, pc, [r4]")
+
 	TEST_RRP("strd	r",0, VAL1,", r",1, VAL2,", [r",1, 24,", #-16]")
 	TEST_RR( "strd	r",12,VAL2,", r",14,VAL1,", [sp, #16]")
 	TEST_RRP("strd	r",1, VAL1,", r",0, VAL2,", [r",7, 24,", #-16]!")
@@ -832,6 +839,12 @@ CONDITION_INSTRUCTIONS(22,
 	TEST("str	sp, [sp]")
 	TEST_UNSUPPORTED(__inst_thumb32(0xf8cfe000) "	@ str	r14, [pc]")
 	TEST_UNSUPPORTED(__inst_thumb32(0xf8cef000) "	@ str	pc, [r14]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf841100f) "	@ str	r1, [r1, pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf841100d) "	@ str	r1, [r1, sp]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf8a1d000) "	@ strh	sp, [r1]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf821d002) "	@ strh	sp, [r1, r2]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf822100f) "	@ strh	r1, [r2, pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf822100d) "	@ strh	r1, [r2, sp]")
 
 	TEST_GROUP("Advanced SIMD element or structure load/store instructions")
 
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/kernel/kprobes-thumb.c
index 0672457..c6426b6 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/kernel/kprobes-thumb.c
@@ -626,17 +626,22 @@ const struct decode_action kprobes_t16_actions[NUM_PROBES_T16_ACTIONS] = {
 	[PROBES_T16_LDR_LIT] = {.handler = t16_simulate_ldr_literal},
 	[PROBES_T16_BLX] = {.handler = t16_simulate_bxblx},
 	[PROBES_T16_HIREGOPS] = {.decoder = t16_decode_hiregs},
-	[PROBES_T16_LDRHSTRH] = {.handler = t16_emulate_loregs_rwflags},
-	[PROBES_T16_LDRSTR] = {.handler = t16_simulate_ldrstr_sp_relative},
+	[PROBES_T16_LDRH] = {.handler = t16_emulate_loregs_rwflags},
+	[PROBES_T16_STRH] = {.handler = t16_emulate_loregs_rwflags},
+	[PROBES_T16_LDR] = {.handler = t16_simulate_ldrstr_sp_relative},
+	[PROBES_T16_STR] = {.handler = t16_simulate_ldrstr_sp_relative},
 	[PROBES_T16_ADR] = {.handler = t16_simulate_reladr},
-	[PROBES_T16_LDMSTM] = {.handler = t16_emulate_loregs_rwflags},
+	[PROBES_T16_LDM] = {.handler = t16_emulate_loregs_rwflags},
+	[PROBES_T16_STM] = {.handler = t16_emulate_loregs_rwflags},
 	[PROBES_T16_BRANCH_COND] = {.decoder = t16_decode_cond_branch},
 	[PROBES_T16_BRANCH] = {.handler = t16_simulate_branch},
 };
 
 const struct decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
-	[PROBES_T32_LDMSTM] = {.decoder = t32_decode_ldmstm},
-	[PROBES_T32_LDRDSTRD] = {.handler = t32_emulate_ldrdstrd},
+	[PROBES_T32_LDM] = {.decoder = t32_decode_ldmstm},
+	[PROBES_T32_STM] = {.decoder = t32_decode_ldmstm},
+	[PROBES_T32_LDRD] = {.handler = t32_emulate_ldrdstrd},
+	[PROBES_T32_STRD] = {.handler = t32_emulate_ldrdstrd},
 	[PROBES_T32_TABLE_BRANCH] = {.handler = t32_simulate_table_branch},
 	[PROBES_T32_TST] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_MOV] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
@@ -655,7 +660,8 @@ const struct decode_action kprobes_t32_actions[NUM_PROBES_T32_ACTIONS] = {
 	[PROBES_T32_BRANCH] = {.handler = t32_simulate_branch},
 	[PROBES_T32_PLDI] = {.handler = probes_simulate_nop},
 	[PROBES_T32_LDR_LIT] = {.handler = t32_simulate_ldr_literal},
-	[PROBES_T32_LDRSTR] = {.handler = t32_emulate_ldrstr},
+	[PROBES_T32_LDR] = {.handler = t32_emulate_ldrstr},
+	[PROBES_T32_STR] = {.handler = t32_emulate_ldrstr},
 	[PROBES_T32_SIGN_EXTEND] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_MEDIA] = {.handler = t32_emulate_rd8rn16rm0_rwflags},
 	[PROBES_T32_REVERSE] = {.handler = t32_emulate_rd8rn16_noflags},
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 3d00aa7..148153e 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -270,13 +270,17 @@ static const union decode_item arm_cccc_000x_____1xx1_table[] = {
 	DECODE_REJECT	(0x0e10e0d0, 0x0000e0d0),
 
 	/* LDRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1101 xxxx */
+	DECODE_EMULATEX	(0x0e5000f0, 0x000000d0, PROBES_LDRD,
+						 REGS(NOPCWB, NOPCX, 0, 0, NOPC)),
 	/* STRD (register)	cccc 000x x0x0 xxxx xxxx xxxx 1111 xxxx */
-	DECODE_EMULATEX	(0x0e5000d0, 0x000000d0, PROBES_LDRSTRD,
+	DECODE_EMULATEX	(0x0e5000f0, 0x000000f0, PROBES_STRD,
 						 REGS(NOPCWB, NOPCX, 0, 0, NOPC)),
 
 	/* LDRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx */
+	DECODE_EMULATEX	(0x0e5000f0, 0x004000d0, PROBES_LDRD,
+						 REGS(NOPCWB, NOPCX, 0, 0, 0)),
 	/* STRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx */
-	DECODE_EMULATEX	(0x0e5000d0, 0x004000d0, PROBES_LDRSTRD,
+	DECODE_EMULATEX	(0x0e5000f0, 0x004000f0, PROBES_STRD,
 						 REGS(NOPCWB, NOPCX, 0, 0, 0)),
 
 	/* STRH (register)	cccc 000x x0x0 xxxx xxxx xxxx 1011 xxxx */
@@ -601,8 +605,9 @@ static const union decode_item arm_cccc_100x_table[] = {
 	/* Block data transfer instructions				*/
 
 	/* LDM			cccc 100x x0x1 xxxx xxxx xxxx xxxx xxxx */
+	DECODE_CUSTOM	(0x0e500000, 0x08100000, PROBES_LDM),
 	/* STM			cccc 100x x0x0 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_CUSTOM	(0x0e400000, 0x08000000, PROBES_LDMSTM),
+	DECODE_CUSTOM	(0x0e500000, 0x08000000, PROBES_STM),
 
 	/* STM (user registers)	cccc 100x x1x0 xxxx xxxx xxxx xxxx xxxx */
 	/* LDM (user registers)	cccc 100x x1x1 xxxx 0xxx xxxx xxxx xxxx */
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/kernel/probes-arm.h
index 6ecc25a..18ffc9a 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/kernel/probes-arm.h
@@ -28,7 +28,8 @@ enum probes_arm_action {
 	PROBES_MUL1,
 	PROBES_MUL2,
 	PROBES_SWP,
-	PROBES_LDRSTRD,
+	PROBES_LDRD,
+	PROBES_STRD,
 	PROBES_LOAD,
 	PROBES_STORE,
 	PROBES_LOAD_EXTRA,
@@ -49,7 +50,8 @@ enum probes_arm_action {
 	PROBES_MUL_ADD,
 	PROBES_BITFIELD,
 	PROBES_BRANCH,
-	PROBES_LDMSTM,
+	PROBES_LDM,
+	PROBES_STM,
 	NUM_PROBES_ARM_ACTIONS
 };
 
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/kernel/probes-thumb.c
index 72aa217..749d4cd 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/kernel/probes-thumb.c
@@ -37,10 +37,11 @@ static const union decode_item t32_table_1110_100x_x0xx[] = {
 	DECODE_REJECT	(0xfe402000, 0xe8002000),
 
 	/* STMIA		1110 1000 10x0 xxxx xxxx xxxx xxxx xxxx */
-	/* LDMIA		1110 1000 10x1 xxxx xxxx xxxx xxxx xxxx */
 	/* STMDB		1110 1001 00x0 xxxx xxxx xxxx xxxx xxxx */
+	DECODE_CUSTOM	(0xfe500000, 0xe8000000, PROBES_T32_STM),
+	/* LDMIA		1110 1000 10x1 xxxx xxxx xxxx xxxx xxxx */
 	/* LDMDB		1110 1001 00x1 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_CUSTOM	(0xfe400000, 0xe8000000, PROBES_T32_LDMSTM),
+	DECODE_CUSTOM	(0xfe500000, 0xe8100000, PROBES_T32_LDM),
 
 	DECODE_END
 };
@@ -49,11 +50,15 @@ static const union decode_item t32_table_1110_100x_x1xx[] = {
 	/* Load/store dual, load/store exclusive, table branch */
 
 	/* STRD (immediate)	1110 1000 x110 xxxx xxxx xxxx xxxx xxxx */
-	/* LDRD (immediate)	1110 1000 x111 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_OR	(0xff600000, 0xe8600000),
+	DECODE_OR	(0xff700000, 0xe8600000),
 	/* STRD (immediate)	1110 1001 x1x0 xxxx xxxx xxxx xxxx xxxx */
+	DECODE_EMULATEX	(0xff500000, 0xe9400000, PROBES_T32_STRD,
+						 REGS(NOPCWB, NOSPPC, NOSPPC, 0, 0)),
+
+	/* LDRD (immediate)	1110 1000 x111 xxxx xxxx xxxx xxxx xxxx */
+	DECODE_OR	(0xff700000, 0xe8700000),
 	/* LDRD (immediate)	1110 1001 x1x1 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_EMULATEX	(0xff400000, 0xe9400000, PROBES_T32_LDRDSTRD,
+	DECODE_EMULATEX	(0xff500000, 0xe9500000, PROBES_T32_LDRD,
 						 REGS(NOPCWB, NOSPPC, NOSPPC, 0, 0)),
 
 	/* TBB			1110 1000 1101 xxxx xxxx xxxx 0000 xxxx */
@@ -340,16 +345,29 @@ static const union decode_item t32_table_1111_100x[] = {
 						 REGS(PC, ANY, 0, 0, 0)),
 
 	/* STR (immediate)	1111 1000 0100 xxxx xxxx 1xxx xxxx xxxx */
-	/* LDR (immediate)	1111 1000 0101 xxxx xxxx 1xxx xxxx xxxx */
-	DECODE_OR	(0xffe00800, 0xf8400800),
+	DECODE_OR	(0xfff00800, 0xf8400800),
 	/* STR (immediate)	1111 1000 1100 xxxx xxxx xxxx xxxx xxxx */
+	/*
+	 * Reject PC for Rt. PC has already rejected by
+	 * 0xff1f0000, 0xf80f0000 and 0xff10f000, 0xf800f000.
+	 * Suppress complain on coverage in test code.
+	 */
+	DECODE_EMULATEX	(0xfff00000, 0xf8c00000, PROBES_T32_STR,
+						 REGS(NOPCX, NOPCX, 0, 0, 0)),
+	/* LDR (immediate)	1111 1000 0101 xxxx xxxx 1xxx xxxx xxxx */
+	DECODE_OR	(0xfff00800, 0xf8500800),
 	/* LDR (immediate)	1111 1000 1101 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_EMULATEX	(0xffe00000, 0xf8c00000, PROBES_T32_LDRSTR,
+	DECODE_EMULATEX	(0xfff00000, 0xf8d00000, PROBES_T32_LDR,
 						 REGS(NOPCX, ANY, 0, 0, 0)),
-
 	/* STR (register)	1111 1000 0100 xxxx xxxx 0000 00xx xxxx */
+	/*
+	 * Rt == PC and Rn == PC have already been rejected by
+	 * 0xff1f0000, 0xf80f0000 and 0xff10f000, 0xf800f000
+	 */
+	DECODE_EMULATEX	(0xfff00fc0, 0xf8400000, PROBES_T32_STR,
+						 REGS(NOPCX, NOPCX, 0, 0, NOSPPC)),
 	/* LDR (register)	1111 1000 0101 xxxx xxxx 0000 00xx xxxx */
-	DECODE_EMULATEX	(0xffe00fc0, 0xf8400000, PROBES_T32_LDRSTR,
+	DECODE_EMULATEX	(0xfff00fc0, 0xf8500000, PROBES_T32_LDR,
 						 REGS(NOPCX, ANY, 0, 0, NOSPPC)),
 
 	/* LDRB (literal)	1111 1000 x001 1111 xxxx xxxx xxxx xxxx */
@@ -361,27 +379,35 @@ static const union decode_item t32_table_1111_100x[] = {
 
 	/* STRB (immediate)	1111 1000 0000 xxxx xxxx 1xxx xxxx xxxx */
 	/* STRH (immediate)	1111 1000 0010 xxxx xxxx 1xxx xxxx xxxx */
+	DECODE_OR	(0xffd00800, 0xf8000800),
+	/* STRB (immediate)	1111 1000 1000 xxxx xxxx xxxx xxxx xxxx */
+	/* STRH (immediate)	1111 1000 1010 xxxx xxxx xxxx xxxx xxxx */
+	DECODE_EMULATEX	(0xffd00000, 0xf8800000, PROBES_T32_STR,
+						 REGS(NOPCX, NOSPPCX, 0, 0, 0)),
+
 	/* LDRB (immediate)	1111 1000 0001 xxxx xxxx 1xxx xxxx xxxx */
 	/* LDRSB (immediate)	1111 1001 0001 xxxx xxxx 1xxx xxxx xxxx */
 	/* LDRH (immediate)	1111 1000 0011 xxxx xxxx 1xxx xxxx xxxx */
 	/* LDRSH (immediate)	1111 1001 0011 xxxx xxxx 1xxx xxxx xxxx */
-	DECODE_OR	(0xfec00800, 0xf8000800),
-	/* STRB (immediate)	1111 1000 1000 xxxx xxxx xxxx xxxx xxxx */
-	/* STRH (immediate)	1111 1000 1010 xxxx xxxx xxxx xxxx xxxx */
+	DECODE_OR	(0xfed00800, 0xf8100800),
+
 	/* LDRB (immediate)	1111 1000 1001 xxxx xxxx xxxx xxxx xxxx */
 	/* LDRSB (immediate)	1111 1001 1001 xxxx xxxx xxxx xxxx xxxx */
 	/* LDRH (immediate)	1111 1000 1011 xxxx xxxx xxxx xxxx xxxx */
 	/* LDRSH (immediate)	1111 1001 1011 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_EMULATEX	(0xfec00000, 0xf8800000, PROBES_T32_LDRSTR,
+	DECODE_EMULATEX	(0xfed00000, 0xf8900000, PROBES_T32_LDR,
 						 REGS(NOPCX, NOSPPCX, 0, 0, 0)),
 
 	/* STRB (register)	1111 1000 0000 xxxx xxxx 0000 00xx xxxx */
 	/* STRH (register)	1111 1000 0010 xxxx xxxx 0000 00xx xxxx */
+	DECODE_EMULATEX	(0xffd00fc0, 0xf8000000, PROBES_T32_STR,
+						 REGS(NOPCX, NOSPPCX, 0, 0, NOSPPC)),
+
 	/* LDRB (register)	1111 1000 0001 xxxx xxxx 0000 00xx xxxx */
 	/* LDRSB (register)	1111 1001 0001 xxxx xxxx 0000 00xx xxxx */
 	/* LDRH (register)	1111 1000 0011 xxxx xxxx 0000 00xx xxxx */
 	/* LDRSH (register)	1111 1001 0011 xxxx xxxx 0000 00xx xxxx */
-	DECODE_EMULATEX	(0xfe800fc0, 0xf8000000, PROBES_T32_LDRSTR,
+	DECODE_EMULATEX	(0xfed00fc0, 0xf8100000, PROBES_T32_LDR,
 						 REGS(NOPCX, NOSPPCX, 0, 0, NOSPPC)),
 
 	/* Other unallocated instructions...				*/
@@ -778,23 +804,34 @@ const union decode_item probes_decode_thumb16_table[] = {
 
 	/* STR (register)		0101 000x xxxx xxxx */
 	/* STRH (register)		0101 001x xxxx xxxx */
+	DECODE_EMULATE	(0xfc00, 0x5000, PROBES_T16_STRH),
 	/* STRB (register)		0101 010x xxxx xxxx */
+	DECODE_EMULATE	(0xfe00, 0x5400, PROBES_T16_STRH),
 	/* LDRSB (register)		0101 011x xxxx xxxx */
+	DECODE_EMULATE	(0xfe00, 0x5600, PROBES_T16_LDRH),
+
 	/* LDR (register)		0101 100x xxxx xxxx */
 	/* LDRH (register)		0101 101x xxxx xxxx */
 	/* LDRB (register)		0101 110x xxxx xxxx */
 	/* LDRSH (register)		0101 111x xxxx xxxx */
+	DECODE_EMULATE	(0xf800, 0x5800, PROBES_T16_LDRH),
+
 	/* STR (immediate, Thumb)	0110 0xxx xxxx xxxx */
-	/* LDR (immediate, Thumb)	0110 1xxx xxxx xxxx */
 	/* STRB (immediate, Thumb)	0111 0xxx xxxx xxxx */
+	DECODE_EMULATE	(0xe800, 0x6000, PROBES_T16_STRH),
+
+	/* LDR (immediate, Thumb)	0110 1xxx xxxx xxxx */
 	/* LDRB (immediate, Thumb)	0111 1xxx xxxx xxxx */
-	DECODE_EMULATE	(0xc000, 0x4000, PROBES_T16_LDRHSTRH),
+	DECODE_EMULATE	(0xe800, 0x6800, PROBES_T16_LDRH),
+
 	/* STRH (immediate, Thumb)	1000 0xxx xxxx xxxx */
+	DECODE_EMULATE	(0xf800, 0x8000, PROBES_T16_STRH),
 	/* LDRH (immediate, Thumb)	1000 1xxx xxxx xxxx */
-	DECODE_EMULATE	(0xf000, 0x8000, PROBES_T16_LDRHSTRH),
+	DECODE_EMULATE	(0xf800, 0x8800, PROBES_T16_LDRH),
 	/* STR (immediate, Thumb)	1001 0xxx xxxx xxxx */
+	DECODE_SIMULATE	(0xf800, 0x9000, PROBES_T16_STR),
 	/* LDR (immediate, Thumb)	1001 1xxx xxxx xxxx */
-	DECODE_SIMULATE	(0xf000, 0x9000, PROBES_T16_LDRSTR),
+	DECODE_SIMULATE	(0xf800, 0x9800, PROBES_T16_LDR),
 
 	/*
 	 * Generate PC-/SP-relative address
@@ -810,8 +847,9 @@ const union decode_item probes_decode_thumb16_table[] = {
 	DECODE_TABLE	(0xf000, 0xb000, t16_table_1011),
 
 	/* STM				1100 0xxx xxxx xxxx */
+	DECODE_EMULATE	(0xf800, 0xc000, PROBES_T16_STM),
 	/* LDM				1100 1xxx xxxx xxxx */
-	DECODE_EMULATE	(0xf000, 0xc000, PROBES_T16_LDMSTM),
+	DECODE_EMULATE	(0xf800, 0xc800, PROBES_T16_LDM),
 
 	/*
 	 * Conditional branch, and Supervisor Call
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
index 2658d95..a9c65c9 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/kernel/probes-thumb.h
@@ -30,8 +30,10 @@
 enum probes_t32_action {
 	PROBES_T32_EMULATE_NONE,
 	PROBES_T32_SIMULATE_NOP,
-	PROBES_T32_LDMSTM,
-	PROBES_T32_LDRDSTRD,
+	PROBES_T32_LDM,
+	PROBES_T32_STM,
+	PROBES_T32_LDRD,
+	PROBES_T32_STRD,
 	PROBES_T32_TABLE_BRANCH,
 	PROBES_T32_TST,
 	PROBES_T32_CMP,
@@ -50,7 +52,8 @@ enum probes_t32_action {
 	PROBES_T32_BRANCH,
 	PROBES_T32_PLDI,
 	PROBES_T32_LDR_LIT,
-	PROBES_T32_LDRSTR,
+	PROBES_T32_LDR,
+	PROBES_T32_STR,
 	PROBES_T32_SIGN_EXTEND,
 	PROBES_T32_MEDIA,
 	PROBES_T32_REVERSE,
@@ -75,10 +78,13 @@ enum probes_t16_action {
 	PROBES_T16_BLX,
 	PROBES_T16_HIREGOPS,
 	PROBES_T16_LDR_LIT,
-	PROBES_T16_LDRHSTRH,
-	PROBES_T16_LDRSTR,
+	PROBES_T16_LDRH,
+	PROBES_T16_STRH,
+	PROBES_T16_LDR,
+	PROBES_T16_STR,
 	PROBES_T16_ADR,
-	PROBES_T16_LDMSTM,
+	PROBES_T16_LDM,
+	PROBES_T16_STM,
 	PROBES_T16_BRANCH_COND,
 	PROBES_T16_BRANCH,
 	NUM_PROBES_T16_ACTIONS
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/kernel/uprobes-arm.c
index 0c0f299..0a8caa3 100644
--- a/arch/arm/kernel/uprobes-arm.c
+++ b/arch/arm/kernel/uprobes-arm.c
@@ -207,7 +207,8 @@ const struct decode_action uprobes_probes_actions[] = {
 	[PROBES_MUL1] = {.handler = probes_simulate_nop},
 	[PROBES_MUL2] = {.handler = probes_simulate_nop},
 	[PROBES_SWP] = {.handler = probes_simulate_nop},
-	[PROBES_LDRSTRD] = {.decoder = decode_pc_ro},
+	[PROBES_LDRD] = {.decoder = decode_pc_ro},
+	[PROBES_STRD] = {.decoder = decode_pc_ro},
 	[PROBES_LOAD_EXTRA] = {.decoder = decode_pc_ro},
 	[PROBES_LOAD] = {.decoder = decode_ldr},
 	[PROBES_STORE_EXTRA] = {.decoder = decode_pc_ro},
@@ -230,5 +231,6 @@ const struct decode_action uprobes_probes_actions[] = {
 	[PROBES_MUL_ADD] = {.handler = probes_simulate_nop},
 	[PROBES_BITFIELD] = {.handler = probes_simulate_nop},
 	[PROBES_BRANCH] = {.handler = simulate_bbl},
-	[PROBES_LDMSTM] = {.decoder = uprobe_decode_ldmstm}
+	[PROBES_LDM] = {.decoder = uprobe_decode_ldmstm},
+	[PROBES_STM] = {.decoder = uprobe_decode_ldmstm}
 };
-- 
1.8.4

