Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbaGOR0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:26:10 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52191 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbaGORCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:08 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@linaro.org>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 17/94] ARM: kprobes: Disallow instructions with PC and register specified shift
Date: Tue, 15 Jul 2014 20:00:32 +0300
Message-Id: <1405443709-15288-17-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Medhurst <tixy@linaro.org>

ARM data processing instructions which have a register specified shift
are defined as UNPREDICTABLE if PC is used for any register, not just
the shift value as the code was previous assuming. This issue manifests
on A15 devices as either test case failures or undefined instructions
aborts.

Reported-by: David Long <dave.long@linaro.org>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/kernel/kprobes-test-arm.c |   22 ++++++++++++----------
 arch/arm/kernel/probes-arm.c       |    6 +++---
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 9db4b65..e73f9cf 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -74,8 +74,6 @@ void kprobe_arm_test_cases(void)
 	TEST_RRR( op "lt" s "	r11, r",11,VAL1,", r",14,N(val),", asr r",7, 6,"")\
 	TEST_RR(  op "gt" s "	r12, r13"       ", r",14,val, ", ror r",14,7,"")\
 	TEST_RR(  op "le" s "	r14, r",0, val, ", r13"       ", lsl r",14,8,"")\
-	TEST_RR(  op s "	r12, pc"        ", r",14,val, ", ror r",14,7,"")\
-	TEST_RR(  op s "	r14, r",0, val, ", pc"        ", lsl r",14,8,"")\
 	TEST_R(   op "eq" s "	r0,  r",11,VAL1,", #0xf5")			\
 	TEST_R(   op "ne" s "	r11, r",0, VAL1,", #0xf5000000")		\
 	TEST_R(   op s "	r7,  r",8, VAL2,", #0x000af000")		\
@@ -103,8 +101,6 @@ void kprobe_arm_test_cases(void)
 	TEST_RRR( op "ge	r",11,VAL1,", r",14,N(val),", asr r",7, 6,"")	\
 	TEST_RR(  op "le	r13"       ", r",14,val, ", ror r",14,7,"")	\
 	TEST_RR(  op "gt	r",0, val, ", r13"       ", lsl r",14,8,"")	\
-	TEST_RR(  op "	pc"        ", r",14,val, ", ror r",14,7,"")		\
-	TEST_RR(  op "	r",0, val, ", pc"        ", lsl r",14,8,"")		\
 	TEST_R(   op "eq	r",11,VAL1,", #0xf5")				\
 	TEST_R(   op "ne	r",0, VAL1,", #0xf5000000")			\
 	TEST_R(   op "	r",8, VAL2,", #0x000af000")
@@ -125,7 +121,6 @@ void kprobe_arm_test_cases(void)
 	TEST_RR(  op "ge" s "	r11, r",11,N(val),", asr r",7, 6,"")	\
 	TEST_RR(  op "lt" s "	r12, r",11,val, ", ror r",14,7,"")	\
 	TEST_R(   op "gt" s "	r14, r13"       ", lsl r",14,8,"")	\
-	TEST_R(   op "le" s "	r14, pc"        ", lsl r",14,8,"")	\
 	TEST(     op "eq" s "	r0,  #0xf5")				\
 	TEST(     op "ne" s "	r11, #0xf5000000")			\
 	TEST(     op s "	r7,  #0x000af000")			\
@@ -159,12 +154,19 @@ void kprobe_arm_test_cases(void)
 	TEST_SUPPORTED("cmp	pc, #0x1000");
 	TEST_SUPPORTED("cmp	sp, #0x1000");
 
-	/* Data-processing with PC as shift*/
+	/* Data-processing with PC and a shift count in a register */
 	TEST_UNSUPPORTED(__inst_arm(0xe15c0f1e) "	@ cmp	r12, r14, asl pc")
 	TEST_UNSUPPORTED(__inst_arm(0xe1a0cf1e) "	@ mov	r12, r14, asl pc")
 	TEST_UNSUPPORTED(__inst_arm(0xe08caf1e) "	@ add	r10, r12, r14, asl pc")
-
-	/* Data-processing with PC as shift*/
+	TEST_UNSUPPORTED(__inst_arm(0xe151021f) "	@ cmp	r1, pc, lsl r2")
+	TEST_UNSUPPORTED(__inst_arm(0xe17f0211) "	@ cmn	pc, r1, lsl r2")
+	TEST_UNSUPPORTED(__inst_arm(0xe1a0121f) "	@ mov	r1, pc, lsl r2")
+	TEST_UNSUPPORTED(__inst_arm(0xe1a0f211) "	@ mov	pc, r1, lsl r2")
+	TEST_UNSUPPORTED(__inst_arm(0xe042131f) "	@ sub	r1, r2, pc, lsl r3")
+	TEST_UNSUPPORTED(__inst_arm(0xe1cf1312) "	@ bic	r1, pc, r2, lsl r3")
+	TEST_UNSUPPORTED(__inst_arm(0xe081f312) "	@ add	pc, r1, r2, lsl r3")
+
+	/* Data-processing with PC as a target and status registers updated */
 	TEST_UNSUPPORTED("movs	pc, r1")
 	TEST_UNSUPPORTED("movs	pc, r1, lsl r2")
 	TEST_UNSUPPORTED("movs	pc, #0x10000")
@@ -187,14 +189,14 @@ void kprobe_arm_test_cases(void)
 	TEST_BF_R ("add	pc, pc, r",14,2f-1f-8,"")
 	TEST_BF_R ("add	pc, r",14,2f-1f-8,", pc")
 	TEST_BF_R ("mov	pc, r",0,2f,"")
-	TEST_BF_RR("mov	pc, r",0,2f,", asl r",1,0,"")
+	TEST_BF_R ("add	pc, pc, r",14,(2f-1f-8)*2,", asr #1")
 	TEST_BB(   "sub	pc, pc, #1b-2b+8")
 #if __LINUX_ARM_ARCH__ == 6 && !defined(CONFIG_CPU_V7)
 	TEST_BB(   "sub	pc, pc, #1b-2b+8-2") /* UNPREDICTABLE before and after ARMv6 */
 #endif
 	TEST_BB_R( "sub	pc, pc, r",14, 1f-2f+8,"")
 	TEST_BB_R( "rsb	pc, r",14,1f-2f+8,", pc")
-	TEST_RR(   "add	pc, pc, r",10,-2,", asl r",11,1,"")
+	TEST_R(    "add	pc, pc, r",10,-2,", asl #1")
 #ifdef CONFIG_THUMB2_KERNEL
 	TEST_ARM_TO_THUMB_INTERWORK_R("add	pc, pc, r",0,3f-1f-8+1,"")
 	TEST_ARM_TO_THUMB_INTERWORK_R("sub	pc, r",0,3f+8+1,", #8")
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/kernel/probes-arm.c
index 51a13a0..8eaef81 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/kernel/probes-arm.c
@@ -341,12 +341,12 @@ static const union decode_item arm_cccc_000x_table[] = {
 	/* CMP (reg-shift reg)	cccc 0001 0101 xxxx xxxx xxxx 0xx1 xxxx */
 	/* CMN (reg-shift reg)	cccc 0001 0111 xxxx xxxx xxxx 0xx1 xxxx */
 	DECODE_EMULATEX	(0x0f900090, 0x01100010, PROBES_DATA_PROCESSING_REG,
-						 REGS(ANY, 0, NOPC, 0, ANY)),
+						 REGS(NOPC, 0, NOPC, 0, NOPC)),
 
 	/* MOV (reg-shift reg)	cccc 0001 101x xxxx xxxx xxxx 0xx1 xxxx */
 	/* MVN (reg-shift reg)	cccc 0001 111x xxxx xxxx xxxx 0xx1 xxxx */
 	DECODE_EMULATEX	(0x0fa00090, 0x01a00010, PROBES_DATA_PROCESSING_REG,
-						 REGS(0, ANY, NOPC, 0, ANY)),
+						 REGS(0, NOPC, NOPC, 0, NOPC)),
 
 	/* AND (reg-shift reg)	cccc 0000 000x xxxx xxxx xxxx 0xx1 xxxx */
 	/* EOR (reg-shift reg)	cccc 0000 001x xxxx xxxx xxxx 0xx1 xxxx */
@@ -359,7 +359,7 @@ static const union decode_item arm_cccc_000x_table[] = {
 	/* ORR (reg-shift reg)	cccc 0001 100x xxxx xxxx xxxx 0xx1 xxxx */
 	/* BIC (reg-shift reg)	cccc 0001 110x xxxx xxxx xxxx 0xx1 xxxx */
 	DECODE_EMULATEX	(0x0e000090, 0x00000010, PROBES_DATA_PROCESSING_REG,
-						 REGS(ANY, ANY, NOPC, 0, ANY)),
+						 REGS(NOPC, NOPC, NOPC, 0, NOPC)),
 
 	DECODE_END
 };
-- 
1.7.10.4

