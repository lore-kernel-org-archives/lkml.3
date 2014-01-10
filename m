Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaAJR67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:58:59 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45243 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaAJR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:58:45 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Jon Medhurst <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] ARM: kprobes-test: use <asm/opcodes.h> for Thumb instruction building
Date: Fri, 10 Jan 2014 19:58:25 +0200
Message-Id: <1389376706-30051-5-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

The kprobes test will build certain instructions incorrectly if building
big endian as .word/.short output gets endian-swapped by the linker.
Change to using <asm/opcodes.h> and __inst_thumbXX() to produce instructions.

Acked-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/kernel/kprobes-test-thumb.c |  447 +++++++++++++++++-----------------
 1 file changed, 224 insertions(+), 223 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test-thumb.c b/arch/arm/kernel/kprobes-test-thumb.c
index 5d8b857..844dd10 100644
--- a/arch/arm/kernel/kprobes-test-thumb.c
+++ b/arch/arm/kernel/kprobes-test-thumb.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <asm/opcodes.h>
 
 #include "kprobes-test.h"
 
@@ -119,7 +120,7 @@ void kprobe_thumb16_test_cases(void)
 	TEST_R(   "add	sp"        ", r",8,-8,  "")
 	TEST_R(   "add	r",14,VAL1,", pc")
 	TEST_BF_R("add	pc"        ", r",0,2f-1f-8,"")
-	TEST_UNSUPPORTED(".short 0x44ff	@ add pc, pc")
+	TEST_UNSUPPORTED(__inst_thumb16(0x44ff) "	@ add pc, pc")
 
 	TEST_RR(  "cmp	r",3,VAL1,", r",8,VAL2,"")
 	TEST_RR(  "cmp	r",8,VAL2,", r",0,VAL1,"")
@@ -150,7 +151,7 @@ void kprobe_thumb16_test_cases(void)
 
 	TEST_BF_R("blx	r",0, 2f+1,"")
 	TEST_BB_R("blx	r",14,2f+1,"")
-	TEST_UNSUPPORTED(".short 0x47f8	@ blx pc")
+	TEST_UNSUPPORTED(__inst_thumb16(0x47f8) "	@ blx pc")
 
 	TEST_GROUP("Load from Literal Pool")
 
@@ -237,8 +238,8 @@ DONT_TEST_IN_ITBLOCK(
 	TEST_R("rev	r7, r",0, VAL2,"")
 	TEST_R("rev16	r0, r",7, VAL1,"")
 	TEST_R("rev16	r7, r",0, VAL2,"")
-	TEST_UNSUPPORTED(".short 0xba80")
-	TEST_UNSUPPORTED(".short 0xbabf")
+	TEST_UNSUPPORTED(__inst_thumb16(0xba80) "")
+	TEST_UNSUPPORTED(__inst_thumb16(0xbabf) "")
 	TEST_R("revsh	r0, r",7, VAL1,"")
 	TEST_R("revsh	r7, r",0, VAL2,"")
 
@@ -272,8 +273,8 @@ DONT_TEST_IN_ITBLOCK(
 	TEST("nop")
 	TEST("wfi")
 	TEST_SUPPORTED("wfe")
-	TEST_UNSUPPORTED(".short 0xbf50") /* Unassigned hints */
-	TEST_UNSUPPORTED(".short 0xbff0") /* Unassigned hints */
+	TEST_UNSUPPORTED(__inst_thumb16(0xbf50) "") /* Unassigned hints */
+	TEST_UNSUPPORTED(__inst_thumb16(0xbff0) "") /* Unassigned hints */
 
 #define TEST_IT(code, code2)			\
 	TESTCASE_START(code)			\
@@ -310,8 +311,8 @@ CONDITION_INSTRUCTIONS(8,
 	TEST_BF("bgt	2f")
 	TEST_BB("blt	2b")
 )
-	TEST_UNSUPPORTED(".short 0xde00")
-	TEST_UNSUPPORTED(".short 0xdeff")
+	TEST_UNSUPPORTED(__inst_thumb16(0xde00) "")
+	TEST_UNSUPPORTED(__inst_thumb16(0xdeff) "")
 	TEST_UNSUPPORTED("svc	#0x00")
 	TEST_UNSUPPORTED("svc	#0xff")
 
@@ -380,13 +381,13 @@ void kprobe_thumb32_test_cases(void)
 	TEST_THUMB_TO_ARM_INTERWORK_P("ldmia	r",0,14*4,", {r12,pc}")
 	TEST_THUMB_TO_ARM_INTERWORK_P("ldmia	r",13,2*4,", {r0-r12,pc}")
 
-	TEST_UNSUPPORTED(".short 0xe88f,0x0101	@ stmia	pc, {r0,r8}")
-	TEST_UNSUPPORTED(".short 0xe92f,0x5f00	@ stmdb	pc!, {r8-r12,r14}")
-	TEST_UNSUPPORTED(".short 0xe8bd,0xc000	@ ldmia	r13!, {r14,pc}")
-	TEST_UNSUPPORTED(".short 0xe93e,0xc000	@ ldmdb	r14!, {r14,pc}")
-	TEST_UNSUPPORTED(".short 0xe8a7,0x3f00	@ stmia	r7!, {r8-r12,sp}")
-	TEST_UNSUPPORTED(".short 0xe8a7,0x9f00	@ stmia	r7!, {r8-r12,pc}")
-	TEST_UNSUPPORTED(".short 0xe93e,0x2010	@ ldmdb	r14!, {r4,sp}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe88f0101) "	@ stmia	pc, {r0,r8}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe92f5f00) "	@ stmdb	pc!, {r8-r12,r14}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8bdc000) "	@ ldmia	r13!, {r14,pc}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe93ec000) "	@ ldmdb	r14!, {r14,pc}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8a73f00) "	@ stmia	r7!, {r8-r12,sp}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8a79f00) "	@ stmia	r7!, {r8-r12,pc}")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe93e2010) "	@ ldmdb	r14!, {r4,sp}")
 
 	TEST_GROUP("Load/store double or exclusive, table branch")
 
@@ -402,12 +403,12 @@ void kprobe_thumb32_test_cases(void)
 		"3:	.word	"__stringify(VAL1)"	\n\t"
 		"	.word	"__stringify(VAL2))
 
-	TEST_UNSUPPORTED(".short 0xe9ff,0xec04	@ ldrd	r14, r12, [pc, #16]!")
-	TEST_UNSUPPORTED(".short 0xe8ff,0xec04	@ ldrd	r14, r12, [pc], #16")
-	TEST_UNSUPPORTED(".short 0xe9d4,0xd800	@ ldrd	sp, r8, [r4]")
-	TEST_UNSUPPORTED(".short 0xe9d4,0xf800	@ ldrd	pc, r8, [r4]")
-	TEST_UNSUPPORTED(".short 0xe9d4,0x7d00	@ ldrd	r7, sp, [r4]")
-	TEST_UNSUPPORTED(".short 0xe9d4,0x7f00	@ ldrd	r7, pc, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9ffec04) "	@ ldrd	r14, r12, [pc, #16]!")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8ffec04) "	@ ldrd	r14, r12, [pc], #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9d4d800) "	@ ldrd	sp, r8, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9d4f800) "	@ ldrd	pc, r8, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9d47d00) "	@ ldrd	r7, sp, [r4]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9d47f00) "	@ ldrd	r7, pc, [r4]")
 
 	TEST_RRP("strd	r",0, VAL1,", r",1, VAL2,", [r",1, 24,", #-16]")
 	TEST_RR( "strd	r",12,VAL2,", r",14,VAL1,", [sp, #16]")
@@ -415,8 +416,8 @@ void kprobe_thumb32_test_cases(void)
 	TEST_RR( "strd	r",14,VAL2,", r",12,VAL1,", [sp, #16]!")
 	TEST_RRP("strd	r",1, VAL1,", r",0, VAL2,", [r",7, 24,"], #16")
 	TEST_RR( "strd	r",7, VAL2,", r",8, VAL1,", [sp], #-16")
-	TEST_UNSUPPORTED(".short 0xe9ef,0xec04	@ strd	r14, r12, [pc, #16]!")
-	TEST_UNSUPPORTED(".short 0xe8ef,0xec04	@ strd	r14, r12, [pc], #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe9efec04) "	@ strd	r14, r12, [pc, #16]!")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8efec04) "	@ strd	r14, r12, [pc], #16")
 
 	TEST_RX("tbb	[pc, r",0, (9f-(1f+4)),"]",
 		"9:			\n\t"
@@ -460,9 +461,9 @@ void kprobe_thumb32_test_cases(void)
 		"3:	mvn	r0, r0	\n\t"
 		"2:	nop		\n\t")
 
-	TEST_UNSUPPORTED(".short 0xe8d1,0xf01f	@ tbh [r1, pc]")
-	TEST_UNSUPPORTED(".short 0xe8d1,0xf01d	@ tbh [r1, sp]")
-	TEST_UNSUPPORTED(".short 0xe8dd,0xf012	@ tbh [sp, r2]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8d1f01f) "	@ tbh [r1, pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8d1f01d) "	@ tbh [r1, sp]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xe8ddf012) "	@ tbh [sp, r2]")
 
 	TEST_UNSUPPORTED("strexb	r0, r1, [r2]")
 	TEST_UNSUPPORTED("strexh	r0, r1, [r2]")
@@ -540,40 +541,40 @@ void kprobe_thumb32_test_cases(void)
 	TEST_RR("pkhtb	r0, r",0,  HH1,", r",1, HH2,"")
 	TEST_RR("pkhtb	r14,r",12, HH1,", r",10,HH2,", asr #2")
 
-	TEST_UNSUPPORTED(".short 0xea17,0x0f0d	@ tst.w r7, sp")
-	TEST_UNSUPPORTED(".short 0xea17,0x0f0f	@ tst.w r7, pc")
-	TEST_UNSUPPORTED(".short 0xea1d,0x0f07	@ tst.w sp, r7")
-	TEST_UNSUPPORTED(".short 0xea1f,0x0f07	@ tst.w pc, r7")
-	TEST_UNSUPPORTED(".short 0xf01d,0x1f08	@ tst sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf01f,0x1f08	@ tst pc, #0x00080008")
-
-	TEST_UNSUPPORTED(".short 0xea97,0x0f0d	@ teq.w r7, sp")
-	TEST_UNSUPPORTED(".short 0xea97,0x0f0f	@ teq.w r7, pc")
-	TEST_UNSUPPORTED(".short 0xea9d,0x0f07	@ teq.w sp, r7")
-	TEST_UNSUPPORTED(".short 0xea9f,0x0f07	@ teq.w pc, r7")
-	TEST_UNSUPPORTED(".short 0xf09d,0x1f08	@ tst sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf09f,0x1f08	@ tst pc, #0x00080008")
-
-	TEST_UNSUPPORTED(".short 0xeb17,0x0f0d	@ cmn.w r7, sp")
-	TEST_UNSUPPORTED(".short 0xeb17,0x0f0f	@ cmn.w r7, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea170f0d) "	@ tst.w r7, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea170f0f) "	@ tst.w r7, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea1d0f07) "	@ tst.w sp, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea1f0f07) "	@ tst.w pc, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf01d1f08) "	@ tst sp, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf01f1f08) "	@ tst pc, #0x00080008")
+
+	TEST_UNSUPPORTED(__inst_thumb32(0xea970f0d) "	@ teq.w r7, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea970f0f) "	@ teq.w r7, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea9d0f07) "	@ teq.w sp, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea9f0f07) "	@ teq.w pc, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf09d1f08) "	@ tst sp, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf09f1f08) "	@ tst pc, #0x00080008")
+
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb170f0d) "	@ cmn.w r7, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb170f0f) "	@ cmn.w r7, pc")
 	TEST_P("cmn.w	sp, r",7,0,"")
-	TEST_UNSUPPORTED(".short 0xeb1f,0x0f07	@ cmn.w pc, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb1f0f07) "	@ cmn.w pc, r7")
 	TEST(  "cmn	sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf11f,0x1f08	@ cmn pc, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf11f1f08) "	@ cmn pc, #0x00080008")
 
-	TEST_UNSUPPORTED(".short 0xebb7,0x0f0d	@ cmp.w r7, sp")
-	TEST_UNSUPPORTED(".short 0xebb7,0x0f0f	@ cmp.w r7, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebb70f0d) "	@ cmp.w r7, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebb70f0f) "	@ cmp.w r7, pc")
 	TEST_P("cmp.w	sp, r",7,0,"")
-	TEST_UNSUPPORTED(".short 0xebbf,0x0f07	@ cmp.w pc, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebbf0f07) "	@ cmp.w pc, r7")
 	TEST(  "cmp	sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf1bf,0x1f08	@ cmp pc, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf1bf1f08) "	@ cmp pc, #0x00080008")
 
-	TEST_UNSUPPORTED(".short 0xea5f,0x070d	@ movs.w r7, sp")
-	TEST_UNSUPPORTED(".short 0xea5f,0x070f	@ movs.w r7, pc")
-	TEST_UNSUPPORTED(".short 0xea5f,0x0d07	@ movs.w sp, r7")
-	TEST_UNSUPPORTED(".short 0xea4f,0x0f07	@ mov.w  pc, r7")
-	TEST_UNSUPPORTED(".short 0xf04f,0x1d08	@ mov sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf04f,0x1f08	@ mov pc, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea5f070d) "	@ movs.w r7, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea5f070f) "	@ movs.w r7, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea5f0d07) "	@ movs.w sp, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea4f0f07) "	@ mov.w  pc, r7")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf04f1d08) "	@ mov sp, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf04f1f08) "	@ mov pc, #0x00080008")
 
 	TEST_R("add.w	r0, sp, r",1, 4,"")
 	TEST_R("adds	r0, sp, r",1, 4,", asl #3")
@@ -581,15 +582,15 @@ void kprobe_thumb32_test_cases(void)
 	TEST_R("add	r0, sp, r",1, 16,", ror #1")
 	TEST_R("add.w	sp, sp, r",1, 4,"")
 	TEST_R("add	sp, sp, r",1, 4,", asl #3")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x1d01	@ add sp, sp, r1, asl #4")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x0d71	@ add sp, sp, r1, ror #1")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d1d01) "	@ add sp, sp, r1, asl #4")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d0d71) "	@ add sp, sp, r1, ror #1")
 	TEST(  "add.w	r0, sp, #24")
 	TEST(  "add.w	sp, sp, #24")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x0f01	@ add pc, sp, r1")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x000f	@ add r0, sp, pc")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x000d	@ add r0, sp, sp")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x0d0f	@ add sp, sp, pc")
-	TEST_UNSUPPORTED(".short 0xeb0d,0x0d0d	@ add sp, sp, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d0f01) "	@ add pc, sp, r1")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d000f) "	@ add r0, sp, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d000d) "	@ add r0, sp, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d0d0f) "	@ add sp, sp, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0d0d0d) "	@ add sp, sp, sp")
 
 	TEST_R("sub.w	r0, sp, r",1, 4,"")
 	TEST_R("subs	r0, sp, r",1, 4,", asl #3")
@@ -597,54 +598,54 @@ void kprobe_thumb32_test_cases(void)
 	TEST_R("sub	r0, sp, r",1, 16,", ror #1")
 	TEST_R("sub.w	sp, sp, r",1, 4,"")
 	TEST_R("sub	sp, sp, r",1, 4,", asl #3")
-	TEST_UNSUPPORTED(".short 0xebad,0x1d01	@ sub sp, sp, r1, asl #4")
-	TEST_UNSUPPORTED(".short 0xebad,0x0d71	@ sub sp, sp, r1, ror #1")
-	TEST_UNSUPPORTED(".short 0xebad,0x0f01	@ sub pc, sp, r1")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebad1d01) "	@ sub sp, sp, r1, asl #4")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebad0d71) "	@ sub sp, sp, r1, ror #1")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebad0f01) "	@ sub pc, sp, r1")
 	TEST(  "sub.w	r0, sp, #24")
 	TEST(  "sub.w	sp, sp, #24")
 
-	TEST_UNSUPPORTED(".short 0xea02,0x010f	@ and r1, r2, pc")
-	TEST_UNSUPPORTED(".short 0xea0f,0x0103	@ and r1, pc, r3")
-	TEST_UNSUPPORTED(".short 0xea02,0x0f03	@ and pc, r2, r3")
-	TEST_UNSUPPORTED(".short 0xea02,0x010d	@ and r1, r2, sp")
-	TEST_UNSUPPORTED(".short 0xea0d,0x0103	@ and r1, sp, r3")
-	TEST_UNSUPPORTED(".short 0xea02,0x0d03	@ and sp, r2, r3")
-	TEST_UNSUPPORTED(".short 0xf00d,0x1108	@ and r1, sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf00f,0x1108	@ and r1, pc, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf002,0x1d08	@ and sp, r8, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf002,0x1f08	@ and pc, r8, #0x00080008")
-
-	TEST_UNSUPPORTED(".short 0xeb02,0x010f	@ add r1, r2, pc")
-	TEST_UNSUPPORTED(".short 0xeb0f,0x0103	@ add r1, pc, r3")
-	TEST_UNSUPPORTED(".short 0xeb02,0x0f03	@ add pc, r2, r3")
-	TEST_UNSUPPORTED(".short 0xeb02,0x010d	@ add r1, r2, sp")
-	TEST_SUPPORTED(  ".short 0xeb0d,0x0103	@ add r1, sp, r3")
-	TEST_UNSUPPORTED(".short 0xeb02,0x0d03	@ add sp, r2, r3")
-	TEST_SUPPORTED(  ".short 0xf10d,0x1108	@ add r1, sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf10d,0x1f08	@ add pc, sp, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf10f,0x1108	@ add r1, pc, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf102,0x1d08	@ add sp, r8, #0x00080008")
-	TEST_UNSUPPORTED(".short 0xf102,0x1f08	@ add pc, r8, #0x00080008")
-
-	TEST_UNSUPPORTED(".short 0xeaa0,0x0000")
-	TEST_UNSUPPORTED(".short 0xeaf0,0x0000")
-	TEST_UNSUPPORTED(".short 0xeb20,0x0000")
-	TEST_UNSUPPORTED(".short 0xeb80,0x0000")
-	TEST_UNSUPPORTED(".short 0xebe0,0x0000")
-
-	TEST_UNSUPPORTED(".short 0xf0a0,0x0000")
-	TEST_UNSUPPORTED(".short 0xf0c0,0x0000")
-	TEST_UNSUPPORTED(".short 0xf0f0,0x0000")
-	TEST_UNSUPPORTED(".short 0xf120,0x0000")
-	TEST_UNSUPPORTED(".short 0xf180,0x0000")
-	TEST_UNSUPPORTED(".short 0xf1e0,0x0000")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea02010f) "	@ and r1, r2, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea0f0103) "	@ and r1, pc, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea020f03) "	@ and pc, r2, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea02010d) "	@ and r1, r2, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea0d0103) "	@ and r1, sp, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xea020d03) "	@ and sp, r2, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf00d1108) "	@ and r1, sp, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf00f1108) "	@ and r1, pc, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf0021d08) "	@ and sp, r8, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf0021f08) "	@ and pc, r8, #0x00080008")
+
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb02010f) "	@ add r1, r2, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb0f0103) "	@ add r1, pc, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb020f03) "	@ add pc, r2, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb02010d) "	@ add r1, r2, sp")
+	TEST_SUPPORTED(  __inst_thumb32(0xeb0d0103) "	@ add r1, sp, r3")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb020d03) "	@ add sp, r2, r3")
+	TEST_SUPPORTED(  __inst_thumb32(0xf10d1108) "	@ add r1, sp, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf10d1f08) "	@ add pc, sp, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf10f1108) "	@ add r1, pc, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf1021d08) "	@ add sp, r8, #0x00080008")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf1021f08) "	@ add pc, r8, #0x00080008")
+
+	TEST_UNSUPPORTED(__inst_thumb32(0xeaa00000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeaf00000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb200000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeb800000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xebe00000) "")
+
+	TEST_UNSUPPORTED(__inst_thumb32(0xf0a00000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf0c00000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf0f00000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf1200000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf1800000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf1e00000) "")
 
 	TEST_GROUP("Coprocessor instructions")
 
-	TEST_UNSUPPORTED(".short 0xec00,0x0000")
-	TEST_UNSUPPORTED(".short 0xeff0,0x0000")
-	TEST_UNSUPPORTED(".short 0xfc00,0x0000")
-	TEST_UNSUPPORTED(".short 0xfff0,0x0000")
+	TEST_UNSUPPORTED(__inst_thumb32(0xec000000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xeff00000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfc000000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfff00000) "")
 
 	TEST_GROUP("Data-processing (plain binary immediate)")
 
@@ -652,92 +653,92 @@ void kprobe_thumb32_test_cases(void)
 	TEST(  "addw	r14, sp, #0xf5a")
 	TEST(  "addw	sp, sp, #0x20")
 	TEST(  "addw	r7,  pc, #0x888")
-	TEST_UNSUPPORTED(".short 0xf20f,0x1f20	@ addw pc, pc, #0x120")
-	TEST_UNSUPPORTED(".short 0xf20d,0x1f20	@ addw pc, sp, #0x120")
-	TEST_UNSUPPORTED(".short 0xf20f,0x1d20	@ addw sp, pc, #0x120")
-	TEST_UNSUPPORTED(".short 0xf200,0x1d20	@ addw sp, r0, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf20f1f20) "	@ addw pc, pc, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf20d1f20) "	@ addw pc, sp, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf20f1d20) "	@ addw sp, pc, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2001d20) "	@ addw sp, r0, #0x120")
 
 	TEST_R("subw	r0,  r",1, VAL1,", #0x123")
 	TEST(  "subw	r14, sp, #0xf5a")
 	TEST(  "subw	sp, sp, #0x20")
 	TEST(  "subw	r7,  pc, #0x888")
-	TEST_UNSUPPORTED(".short 0xf2af,0x1f20	@ subw pc, pc, #0x120")
-	TEST_UNSUPPORTED(".short 0xf2ad,0x1f20	@ subw pc, sp, #0x120")
-	TEST_UNSUPPORTED(".short 0xf2af,0x1d20	@ subw sp, pc, #0x120")
-	TEST_UNSUPPORTED(".short 0xf2a0,0x1d20	@ subw sp, r0, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2af1f20) "	@ subw pc, pc, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2ad1f20) "	@ subw pc, sp, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2af1d20) "	@ subw sp, pc, #0x120")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2a01d20) "	@ subw sp, r0, #0x120")
 
 	TEST("movw	r0, #0")
 	TEST("movw	r0, #0xffff")
 	TEST("movw	lr, #0xffff")
-	TEST_UNSUPPORTED(".short 0xf240,0x0d00	@ movw sp, #0")
-	TEST_UNSUPPORTED(".short 0xf240,0x0f00	@ movw pc, #0")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2400d00) "	@ movw sp, #0")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2400f00) "	@ movw pc, #0")
 
 	TEST_R("movt	r",0, VAL1,", #0")
 	TEST_R("movt	r",0, VAL2,", #0xffff")
 	TEST_R("movt	r",14,VAL1,", #0xffff")
-	TEST_UNSUPPORTED(".short 0xf2c0,0x0d00	@ movt sp, #0")
-	TEST_UNSUPPORTED(".short 0xf2c0,0x0f00	@ movt pc, #0")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2c00d00) "	@ movt sp, #0")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf2c00f00) "	@ movt pc, #0")
 
 	TEST_R(     "ssat	r0, #24, r",0,   VAL1,"")
 	TEST_R(     "ssat	r14, #24, r",12, VAL2,"")
 	TEST_R(     "ssat	r0, #24, r",0,   VAL1,", lsl #8")
 	TEST_R(     "ssat	r14, #24, r",12, VAL2,", asr #8")
-	TEST_UNSUPPORTED(".short 0xf30c,0x0d17	@ ssat	sp, #24, r12")
-	TEST_UNSUPPORTED(".short 0xf30c,0x0f17	@ ssat	pc, #24, r12")
-	TEST_UNSUPPORTED(".short 0xf30d,0x0c17	@ ssat	r12, #24, sp")
-	TEST_UNSUPPORTED(".short 0xf30f,0x0c17	@ ssat	r12, #24, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf30c0d17) "	@ ssat	sp, #24, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf30c0f17) "	@ ssat	pc, #24, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf30d0c17) "	@ ssat	r12, #24, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf30f0c17) "	@ ssat	r12, #24, pc")
 
 	TEST_R(     "usat	r0, #24, r",0,   VAL1,"")
 	TEST_R(     "usat	r14, #24, r",12, VAL2,"")
 	TEST_R(     "usat	r0, #24, r",0,   VAL1,", lsl #8")
 	TEST_R(     "usat	r14, #24, r",12, VAL2,", asr #8")
-	TEST_UNSUPPORTED(".short 0xf38c,0x0d17	@ usat	sp, #24, r12")
-	TEST_UNSUPPORTED(".short 0xf38c,0x0f17	@ usat	pc, #24, r12")
-	TEST_UNSUPPORTED(".short 0xf38d,0x0c17	@ usat	r12, #24, sp")
-	TEST_UNSUPPORTED(".short 0xf38f,0x0c17	@ usat	r12, #24, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf38c0d17) "	@ usat	sp, #24, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf38c0f17) "	@ usat	pc, #24, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf38d0c17) "	@ usat	r12, #24, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf38f0c17) "	@ usat	r12, #24, pc")
 
 	TEST_R(     "ssat16	r0, #12, r",0,   HH1,"")
 	TEST_R(     "ssat16	r14, #12, r",12, HH2,"")
-	TEST_UNSUPPORTED(".short 0xf32c,0x0d0b	@ ssat16	sp, #12, r12")
-	TEST_UNSUPPORTED(".short 0xf32c,0x0f0b	@ ssat16	pc, #12, r12")
-	TEST_UNSUPPORTED(".short 0xf32d,0x0c0b	@ ssat16	r12, #12, sp")
-	TEST_UNSUPPORTED(".short 0xf32f,0x0c0b	@ ssat16	r12, #12, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf32c0d0b) "	@ ssat16	sp, #12, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf32c0f0b) "	@ ssat16	pc, #12, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf32d0c0b) "	@ ssat16	r12, #12, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf32f0c0b) "	@ ssat16	r12, #12, pc")
 
 	TEST_R(     "usat16	r0, #12, r",0,   HH1,"")
 	TEST_R(     "usat16	r14, #12, r",12, HH2,"")
-	TEST_UNSUPPORTED(".short 0xf3ac,0x0d0b	@ usat16	sp, #12, r12")
-	TEST_UNSUPPORTED(".short 0xf3ac,0x0f0b	@ usat16	pc, #12, r12")
-	TEST_UNSUPPORTED(".short 0xf3ad,0x0c0b	@ usat16	r12, #12, sp")
-	TEST_UNSUPPORTED(".short 0xf3af,0x0c0b	@ usat16	r12, #12, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3ac0d0b) "	@ usat16	sp, #12, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3ac0f0b) "	@ usat16	pc, #12, r12")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3ad0c0b) "	@ usat16	r12, #12, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3af0c0b) "	@ usat16	r12, #12, pc")
 
 	TEST_R(     "sbfx	r0, r",0  , VAL1,", #0, #31")
 	TEST_R(     "sbfx	r14, r",12, VAL2,", #8, #16")
 	TEST_R(     "sbfx	r4, r",10,  VAL1,", #16, #15")
-	TEST_UNSUPPORTED(".short 0xf34c,0x2d0f	@ sbfx	sp, r12, #8, #16")
-	TEST_UNSUPPORTED(".short 0xf34c,0x2f0f	@ sbfx	pc, r12, #8, #16")
-	TEST_UNSUPPORTED(".short 0xf34d,0x2c0f	@ sbfx	r12, sp, #8, #16")
-	TEST_UNSUPPORTED(".short 0xf34f,0x2c0f	@ sbfx	r12, pc, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf34c2d0f) "	@ sbfx	sp, r12, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf34c2f0f) "	@ sbfx	pc, r12, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf34d2c0f) "	@ sbfx	r12, sp, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf34f2c0f) "	@ sbfx	r12, pc, #8, #16")
 
 	TEST_R(     "ubfx	r0, r",0  , VAL1,", #0, #31")
 	TEST_R(     "ubfx	r14, r",12, VAL2,", #8, #16")
 	TEST_R(     "ubfx	r4, r",10,  VAL1,", #16, #15")
-	TEST_UNSUPPORTED(".short 0xf3cc,0x2d0f	@ ubfx	sp, r12, #8, #16")
-	TEST_UNSUPPORTED(".short 0xf3cc,0x2f0f	@ ubfx	pc, r12, #8, #16")
-	TEST_UNSUPPORTED(".short 0xf3cd,0x2c0f	@ ubfx	r12, sp, #8, #16")
-	TEST_UNSUPPORTED(".short 0xf3cf,0x2c0f	@ ubfx	r12, pc, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3cc2d0f) "	@ ubfx	sp, r12, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3cc2f0f) "	@ ubfx	pc, r12, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3cd2c0f) "	@ ubfx	r12, sp, #8, #16")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3cf2c0f) "	@ ubfx	r12, pc, #8, #16")
 
 	TEST_R(     "bfc	r",0, VAL1,", #4, #20")
 	TEST_R(     "bfc	r",14,VAL2,", #4, #20")
 	TEST_R(     "bfc	r",7, VAL1,", #0, #31")
 	TEST_R(     "bfc	r",8, VAL2,", #0, #31")
-	TEST_UNSUPPORTED(".short 0xf36f,0x0d1e	@ bfc	sp, #0, #31")
-	TEST_UNSUPPORTED(".short 0xf36f,0x0f1e	@ bfc	pc, #0, #31")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf36f0d1e) "	@ bfc	sp, #0, #31")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf36f0f1e) "	@ bfc	pc, #0, #31")
 
 	TEST_RR(    "bfi	r",0, VAL1,", r",0  , VAL2,", #0, #31")
 	TEST_RR(    "bfi	r",12,VAL1,", r",14 , VAL2,", #4, #20")
-	TEST_UNSUPPORTED(".short 0xf36e,0x1d17	@ bfi	sp, r14, #4, #20")
-	TEST_UNSUPPORTED(".short 0xf36e,0x1f17	@ bfi	pc, r14, #4, #20")
-	TEST_UNSUPPORTED(".short 0xf36d,0x1e17	@ bfi	r14, sp, #4, #20")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf36e1d17) "	@ bfi	sp, r14, #4, #20")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf36e1f17) "	@ bfi	pc, r14, #4, #20")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf36d1e17) "	@ bfi	r14, sp, #4, #20")
 
 	TEST_GROUP("Branches and miscellaneous control")
 
@@ -775,14 +776,14 @@ CONDITION_INSTRUCTIONS(22,
 
 	TEST("mrs	r0, cpsr")
 	TEST("mrs	r14, cpsr")
-	TEST_UNSUPPORTED(".short 0xf3ef,0x8d00	@ mrs	sp, spsr")
-	TEST_UNSUPPORTED(".short 0xf3ef,0x8f00	@ mrs	pc, spsr")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3ef8d00) "	@ mrs	sp, spsr")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf3ef8f00) "	@ mrs	pc, spsr")
 	TEST_UNSUPPORTED("mrs	r0, spsr")
 	TEST_UNSUPPORTED("mrs	lr, spsr")
 
-	TEST_UNSUPPORTED(".short 0xf7f0,0x8000 @ smc #0")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf7f08000) " @ smc #0")
 
-	TEST_UNSUPPORTED(".short 0xf7f0,0xa000 @ undefeined")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf7f0a000) " @ undefeined")
 
 	TEST_BF(  "b.w	2f")
 	TEST_BB(  "b.w	2b")
@@ -829,15 +830,15 @@ CONDITION_INSTRUCTIONS(22,
 	SINGLE_STORE("")
 
 	TEST("str	sp, [sp]")
-	TEST_UNSUPPORTED(".short 0xf8cf,0xe000	@ str	r14, [pc]")
-	TEST_UNSUPPORTED(".short 0xf8ce,0xf000	@ str	pc, [r14]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf8cfe000) "	@ str	r14, [pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf8cef000) "	@ str	pc, [r14]")
 
 	TEST_GROUP("Advanced SIMD element or structure load/store instructions")
 
-	TEST_UNSUPPORTED(".short 0xf900,0x0000")
-	TEST_UNSUPPORTED(".short 0xf92f,0xffff")
-	TEST_UNSUPPORTED(".short 0xf980,0x0000")
-	TEST_UNSUPPORTED(".short 0xf9ef,0xffff")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf9000000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf92fffff) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf9800000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf9efffff) "")
 
 	TEST_GROUP("Load single data item and memory hints")
 
@@ -881,20 +882,20 @@ CONDITION_INSTRUCTIONS(22,
 	TEST_SUPPORTED("ldr	sp, 99f")
 	TEST_SUPPORTED("ldr	pc, 99f")
 
-	TEST_UNSUPPORTED(".short 0xf854,0x700d	@ ldr	r7, [r4, sp]")
-	TEST_UNSUPPORTED(".short 0xf854,0x700f	@ ldr	r7, [r4, pc]")
-	TEST_UNSUPPORTED(".short 0xf814,0x700d	@ ldrb	r7, [r4, sp]")
-	TEST_UNSUPPORTED(".short 0xf814,0x700f	@ ldrb	r7, [r4, pc]")
-	TEST_UNSUPPORTED(".short 0xf89f,0xd004	@ ldrb	sp, 99f")
-	TEST_UNSUPPORTED(".short 0xf814,0xd008	@ ldrb	sp, [r4, r8]")
-	TEST_UNSUPPORTED(".short 0xf894,0xd000	@ ldrb	sp, [r4]")
-
-	TEST_UNSUPPORTED(".short 0xf860,0x0000") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xf9ff,0xffff") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xf950,0x0000") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xf95f,0xffff") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xf800,0x0800") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xf97f,0xfaff") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xf854700d) "	@ ldr	r7, [r4, sp]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf854700f) "	@ ldr	r7, [r4, pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf814700d) "	@ ldrb	r7, [r4, sp]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf814700f) "	@ ldrb	r7, [r4, pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf89fd004) "	@ ldrb	sp, 99f")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf814d008) "	@ ldrb	sp, [r4, r8]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf894d000) "	@ ldrb	sp, [r4]")
+
+	TEST_UNSUPPORTED(__inst_thumb32(0xf8600000) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xf9ffffff) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xf9500000) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xf95fffff) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xf8000800) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xf97ffaff) "") /* Unallocated space */
 
 	TEST(   "pli	[pc, #4]")
 	TEST(   "pli	[pc, #-4]")
@@ -902,22 +903,22 @@ CONDITION_INSTRUCTIONS(22,
 	TEST(   "pld	[pc, #-4]")
 
 	TEST_P( "pld	[r",0,-1024,", #1024]")
-	TEST(   ".short 0xf8b0,0xf400	@ pldw	[r0, #1024]")
+	TEST(   __inst_thumb32(0xf8b0f400) "	@ pldw	[r0, #1024]")
 	TEST_P( "pli	[r",4, 0b,", #1024]")
 	TEST_P( "pld	[r",7, 120,", #-120]")
-	TEST(   ".short 0xf837,0xfc78	@ pldw	[r7, #-120]")
+	TEST(   __inst_thumb32(0xf837fc78) "	@ pldw	[r7, #-120]")
 	TEST_P( "pli	[r",11,120,", #-120]")
 	TEST(   "pld	[sp, #0]")
 
 	TEST_PR("pld	[r",7, 24, ", r",0, 16,"]")
 	TEST_PR("pld	[r",8, 24, ", r",12,16,", lsl #3]")
-	TEST_SUPPORTED(".short 0xf837,0xf000	@ pldw	[r7, r0]")
-	TEST_SUPPORTED(".short 0xf838,0xf03c	@ pldw	[r8, r12, lsl #3]");
+	TEST_SUPPORTED(__inst_thumb32(0xf837f000) "	@ pldw	[r7, r0]")
+	TEST_SUPPORTED(__inst_thumb32(0xf838f03c) "	@ pldw	[r8, r12, lsl #3]");
 	TEST_RR("pli	[r",12,0b,", r",0, 16,"]")
 	TEST_RR("pli	[r",0, 0b,", r",12,16,", lsl #3]")
 	TEST_R( "pld	[sp, r",1, 16,"]")
-	TEST_UNSUPPORTED(".short 0xf817,0xf00d  @pld	[r7, sp]")
-	TEST_UNSUPPORTED(".short 0xf817,0xf00f  @pld	[r7, pc]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf817f00d) "  @pld	[r7, sp]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf817f00f) "  @pld	[r7, pc]")
 
 	TEST_GROUP("Data-processing (register)")
 
@@ -934,21 +935,21 @@ CONDITION_INSTRUCTIONS(22,
 	SHIFTS32("ror")
 	SHIFTS32("rors")
 
-	TEST_UNSUPPORTED(".short 0xfa01,0xff02	@ lsl	pc, r1, r2")
-	TEST_UNSUPPORTED(".short 0xfa01,0xfd02	@ lsl	sp, r1, r2")
-	TEST_UNSUPPORTED(".short 0xfa0f,0xf002	@ lsl	r0, pc, r2")
-	TEST_UNSUPPORTED(".short 0xfa0d,0xf002	@ lsl	r0, sp, r2")
-	TEST_UNSUPPORTED(".short 0xfa01,0xf00f	@ lsl	r0, r1, pc")
-	TEST_UNSUPPORTED(".short 0xfa01,0xf00d	@ lsl	r0, r1, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa01ff02) "	@ lsl	pc, r1, r2")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa01fd02) "	@ lsl	sp, r1, r2")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa0ff002) "	@ lsl	r0, pc, r2")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa0df002) "	@ lsl	r0, sp, r2")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa01f00f) "	@ lsl	r0, r1, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa01f00d) "	@ lsl	r0, r1, sp")
 
 	TEST_RR(    "sxtah	r0, r",0,  HH1,", r",1, HH2,"")
 	TEST_RR(    "sxtah	r14,r",12, HH2,", r",10,HH1,", ror #8")
 	TEST_R(     "sxth	r8, r",7,  HH1,"")
 
-	TEST_UNSUPPORTED(".short 0xfa0f,0xff87	@ sxth	pc, r7");
-	TEST_UNSUPPORTED(".short 0xfa0f,0xfd87	@ sxth	sp, r7");
-	TEST_UNSUPPORTED(".short 0xfa0f,0xf88f	@ sxth	r8, pc");
-	TEST_UNSUPPORTED(".short 0xfa0f,0xf88d	@ sxth	r8, sp");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa0fff87) "	@ sxth	pc, r7");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa0ffd87) "	@ sxth	sp, r7");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa0ff88f) "	@ sxth	r8, pc");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa0ff88d) "	@ sxth	r8, sp");
 
 	TEST_RR(    "uxtah	r0, r",0,  HH1,", r",1, HH2,"")
 	TEST_RR(    "uxtah	r14,r",12, HH2,", r",10,HH1,", ror #8")
@@ -970,8 +971,8 @@ CONDITION_INSTRUCTIONS(22,
 	TEST_RR(    "uxtab	r14,r",12, HH2,", r",10,HH1,", ror #8")
 	TEST_R(     "uxtb	r8, r",7,  HH1,"")
 
-	TEST_UNSUPPORTED(".short 0xfa60,0x00f0")
-	TEST_UNSUPPORTED(".short 0xfa7f,0xffff")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa6000f0) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa7fffff) "")
 
 #define PARALLEL_ADD_SUB(op)					\
 	TEST_RR(  op"add16	r0, r",0,  HH1,", r",1, HH2,"")	\
@@ -1019,10 +1020,10 @@ CONDITION_INSTRUCTIONS(22,
 	TEST_R("revsh.w	r0, r",0,   VAL1,"")
 	TEST_R("revsh	r14, r",12, VAL2,"")
 
-	TEST_UNSUPPORTED(".short 0xfa9c,0xff8c	@ rev	pc, r12");
-	TEST_UNSUPPORTED(".short 0xfa9c,0xfd8c	@ rev	sp, r12");
-	TEST_UNSUPPORTED(".short 0xfa9f,0xfe8f	@ rev	r14, pc");
-	TEST_UNSUPPORTED(".short 0xfa9d,0xfe8d	@ rev	r14, sp");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa9cff8c) "	@ rev	pc, r12");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa9cfd8c) "	@ rev	sp, r12");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa9ffe8f) "	@ rev	r14, pc");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa9dfe8d) "	@ rev	r14, sp");
 
 	TEST_RR("sel	r0, r",0,  VAL1,", r",1, VAL2,"")
 	TEST_RR("sel	r14, r",12,VAL1,", r",10, VAL2,"")
@@ -1031,31 +1032,31 @@ CONDITION_INSTRUCTIONS(22,
 	TEST_R("clz	r7, r",14,0x1,"")
 	TEST_R("clz	lr, r",7, 0xffffffff,"")
 
-	TEST_UNSUPPORTED(".short 0xfa80,0xf030") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfaff,0xff7f") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfab0,0xf000") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfaff,0xff7f") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfa80f030) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfaffff7f) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfab0f000) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfaffff7f) "") /* Unallocated space */
 
 	TEST_GROUP("Multiply, multiply accumulate, and absolute difference operations")
 
 	TEST_RR(    "mul	r0, r",1, VAL1,", r",2, VAL2,"")
 	TEST_RR(    "mul	r7, r",8, VAL2,", r",9, VAL2,"")
-	TEST_UNSUPPORTED(".short 0xfb08,0xff09	@ mul	pc, r8, r9")
-	TEST_UNSUPPORTED(".short 0xfb08,0xfd09	@ mul	sp, r8, r9")
-	TEST_UNSUPPORTED(".short 0xfb0f,0xf709	@ mul	r7, pc, r9")
-	TEST_UNSUPPORTED(".short 0xfb0d,0xf709	@ mul	r7, sp, r9")
-	TEST_UNSUPPORTED(".short 0xfb08,0xf70f	@ mul	r7, r8, pc")
-	TEST_UNSUPPORTED(".short 0xfb08,0xf70d	@ mul	r7, r8, sp")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08ff09) "	@ mul	pc, r8, r9")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08fd09) "	@ mul	sp, r8, r9")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb0ff709) "	@ mul	r7, pc, r9")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb0df709) "	@ mul	r7, sp, r9")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08f70f) "	@ mul	r7, r8, pc")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08f70d) "	@ mul	r7, r8, sp")
 
 	TEST_RRR(   "mla	r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
 	TEST_RRR(   "mla	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
-	TEST_UNSUPPORTED(".short 0xfb08,0xaf09	@ mla	pc, r8, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb08,0xad09	@ mla	sp, r8, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb0f,0xa709	@ mla	r7, pc, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb0d,0xa709	@ mla	r7, sp, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb08,0xa70f	@ mla	r7, r8, pc, r10");
-	TEST_UNSUPPORTED(".short 0xfb08,0xa70d	@ mla	r7, r8, sp, r10");
-	TEST_UNSUPPORTED(".short 0xfb08,0xd709	@ mla	r7, r8, r9, sp");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08af09) "	@ mla	pc, r8, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08ad09) "	@ mla	sp, r8, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb0fa709) "	@ mla	r7, pc, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb0da709) "	@ mla	r7, sp, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08a70f) "	@ mla	r7, r8, pc, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08a70d) "	@ mla	r7, r8, sp, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb08d709) "	@ mla	r7, r8, r9, sp");
 
 	TEST_RRR(   "mls	r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
 	TEST_RRR(   "mls	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
@@ -1123,25 +1124,25 @@ CONDITION_INSTRUCTIONS(22,
 	TEST_RR(    "usad8	r0, r",0,  VAL1,", r",1, VAL2,"")
 	TEST_RR(    "usad8	r14, r",12,VAL2,", r",10,VAL1,"")
 
-	TEST_UNSUPPORTED(".short 0xfb00,0xf010") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfb0f,0xff1f") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfb70,0xf010") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfb7f,0xff1f") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfb70,0x0010") /* Unallocated space */
-	TEST_UNSUPPORTED(".short 0xfb7f,0xff1f") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb00f010) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb0fff1f) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb70f010) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb7fff1f) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb700010) "") /* Unallocated space */
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb7fff1f) "") /* Unallocated space */
 
 	TEST_GROUP("Long multiply, long multiply accumulate, and divide")
 
 	TEST_RR(   "smull	r0, r1, r",2, VAL1,", r",3, VAL2,"")
 	TEST_RR(   "smull	r7, r8, r",9, VAL2,", r",10, VAL1,"")
-	TEST_UNSUPPORTED(".short 0xfb89,0xf80a	@ smull	pc, r8, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb89,0xd80a	@ smull	sp, r8, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb89,0x7f0a	@ smull	r7, pc, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb89,0x7d0a	@ smull	r7, sp, r9, r10");
-	TEST_UNSUPPORTED(".short 0xfb8f,0x780a	@ smull	r7, r8, pc, r10");
-	TEST_UNSUPPORTED(".short 0xfb8d,0x780a	@ smull	r7, r8, sp, r10");
-	TEST_UNSUPPORTED(".short 0xfb89,0x780f	@ smull	r7, r8, r9, pc");
-	TEST_UNSUPPORTED(".short 0xfb89,0x780d	@ smull	r7, r8, r9, sp");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb89f80a) "	@ smull	pc, r8, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb89d80a) "	@ smull	sp, r8, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb897f0a) "	@ smull	r7, pc, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb897d0a) "	@ smull	r7, sp, r9, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb8f780a) "	@ smull	r7, r8, pc, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb8d780a) "	@ smull	r7, r8, sp, r10");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb89780f) "	@ smull	r7, r8, r9, pc");
+	TEST_UNSUPPORTED(__inst_thumb32(0xfb89780d) "	@ smull	r7, r8, r9, sp");
 
 	TEST_RR(   "umull	r0, r1, r",2, VAL1,", r",3, VAL2,"")
 	TEST_RR(   "umull	r7, r8, r",9, VAL2,", r",10, VAL1,"")
@@ -1175,8 +1176,8 @@ CONDITION_INSTRUCTIONS(22,
 
 	TEST_GROUP("Coprocessor instructions")
 
-	TEST_UNSUPPORTED(".short 0xfc00,0x0000")
-	TEST_UNSUPPORTED(".short 0xffff,0xffff")
+	TEST_UNSUPPORTED(__inst_thumb32(0xfc000000) "")
+	TEST_UNSUPPORTED(__inst_thumb32(0xffffffff) "")
 
 	TEST_GROUP("Testing instructions in IT blocks")
 
-- 
1.7.9.5

