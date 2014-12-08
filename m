Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaLHONV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:13:21 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:3357 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaLHONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:13:17 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RESEND][PATCH v15 5/7] ARM: kprobes: Add test cases for stack consuming instructions
Date: Mon, 8 Dec 2014 22:09:23 +0800
Message-ID: <1418047765-53197-6-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A0B0202.5485B1FB.032D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 3dd40051b84870083e2aa21b1b6bbacf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Medhurst <tixy@linaro.org>

These have extra 'checker' functions associated with them so
lets make sure those get covered by testing.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
v1 -> v2:
 - Move to arch/arm/probes/ .
---
 arch/arm/probes/kprobes/test-arm.c   | 17 +++++++++++++++--
 arch/arm/probes/kprobes/test-thumb.c | 12 ++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm/probes/kprobes/test-arm.c b/arch/arm/probes/kprobes/test-arm.c
index fdeb300..9b3b1b4 100644
--- a/arch/arm/probes/kprobes/test-arm.c
+++ b/arch/arm/probes/kprobes/test-arm.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <asm/system_info.h>
 #include <asm/opcodes.h>
+#include <asm/probes.h>
 
 #include "test-core.h"
 
@@ -478,6 +479,7 @@ void kprobe_arm_test_cases(void)
 	TEST_RPR(  "strh	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")
 	TEST_RPR(  "streqh	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")
 	TEST_UNSUPPORTED(  "streqh	r14, [r13, r12]")
+	TEST_UNSUPPORTED(  "streqh	r14, [r12, r13]")
 	TEST_RPR(  "strh	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")
 	TEST_RPR(  "strneh	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
 	TEST_RPR(  "strh	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")
@@ -502,6 +504,9 @@ void kprobe_arm_test_cases(void)
 	TEST_RP(   "strplh	r",12,VAL2,", [r",11,24,", #-4]!")
 	TEST_RP(   "strh	r",2, VAL1,", [r",3, 24,"], #48")
 	TEST_RP(   "strh	r",10,VAL2,", [r",9, 64,"], #-48")
+	TEST_RP(   "strh	r",3, VAL1,", [r",13,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!")
+	TEST_UNSUPPORTED("strh r3, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")
+	TEST_RP(   "strh	r",4, VAL1,", [r",14,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!")
 	TEST_UNSUPPORTED(__inst_arm(0xe1efc3b0) "	@ strh r12, [pc, #48]!")
 	TEST_UNSUPPORTED(__inst_arm(0xe0c9f3b0) "	@ strh pc, [r9], #48")
 
@@ -568,6 +573,7 @@ void kprobe_arm_test_cases(void)
 	TEST_RPR(  "strd	r",0, VAL1,", [r",1, 48,", -r",2,24,"]")
 	TEST_RPR(  "strccd	r",8, VAL2,", [r",11,0, ", r",12,48,"]")
 	TEST_UNSUPPORTED(  "strccd r8, [r13, r12]")
+	TEST_UNSUPPORTED(  "strccd r8, [r12, r13]")
 	TEST_RPR(  "strd	r",4, VAL1,", [r",2, 24,", r",3, 48,"]!")
 	TEST_RPR(  "strcsd	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
 	TEST_RPR(  "strd	r",2, VAL1,", [r",5, 24,"], r",4,48,"")
@@ -591,6 +597,9 @@ void kprobe_arm_test_cases(void)
 	TEST_RP(   "strvcd	r",12,VAL2,", [r",11,24,", #-16]!")
 	TEST_RP(   "strd	r",2, VAL1,", [r",4, 24,"], #48")
 	TEST_RP(   "strd	r",10,VAL2,", [r",9, 64,"], #-48")
+	TEST_RP(   "strd	r",6, VAL1,", [r",13,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!")
+	TEST_UNSUPPORTED("strd r6, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")
+	TEST_RP(   "strd	r",4, VAL1,", [r",12,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!")
 	TEST_UNSUPPORTED(__inst_arm(0xe1efc3f0) "	@ strd r12, [pc, #48]!")
 
 	TEST_P(	   "ldrd	r0, [r",0, 24,", #-8]")
@@ -639,16 +648,20 @@ void kprobe_arm_test_cases(void)
 	TEST_RP( "str"byte"	r",12,VAL2,", [r",11,24,", #-4]!")		\
 	TEST_RP( "str"byte"	r",2, VAL1,", [r",3, 24,"], #48")		\
 	TEST_RP( "str"byte"	r",10,VAL2,", [r",9, 64,"], #-48")		\
+	TEST_RP( "str"byte"	r",3, VAL1,", [r",13,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!") \
+	TEST_UNSUPPORTED("str"byte" r3, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")				\
+	TEST_RP( "str"byte"	r",4, VAL1,", [r",10,TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!") \
 	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")	\
 	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")	\
-	TEST_UNSUPPORTED("str"byte" r14, [r13, r12]")	\
+	TEST_UNSUPPORTED("str"byte" r14, [r13, r12]")				\
+	TEST_UNSUPPORTED("str"byte" r14, [r12, r13]")				\
 	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")	\
 	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")	\
 	TEST_RPR("str"byte"	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")	\
 	TEST_RPR("str"byte"	r",10,VAL2,", [r",9, 48,"], -r",11,24,"")	\
 	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 24,", r",2,  32,", asl #1]")\
 	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 32,", lsr #2]")\
-	TEST_UNSUPPORTED("str"byte"	r14, [r13, r12, lsr #2]")\
+	TEST_UNSUPPORTED("str"byte"	r14, [r13, r12, lsr #2]")		\
 	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  32,", asr #3]!")\
 	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,24,", r",10, 4,", ror #31]!")\
 	TEST_P(  "ldr"byte"	r0, [r",0,  24,", #-2]")			\
diff --git a/arch/arm/probes/kprobes/test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
index 6c6e9a9..e8cf193 100644
--- a/arch/arm/probes/kprobes/test-thumb.c
+++ b/arch/arm/probes/kprobes/test-thumb.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/opcodes.h>
+#include <asm/probes.h>
 
 #include "test-core.h"
 
@@ -416,6 +417,9 @@ void kprobe_thumb32_test_cases(void)
 	TEST_RR( "strd	r",14,VAL2,", r",12,VAL1,", [sp, #16]!")
 	TEST_RRP("strd	r",1, VAL1,", r",0, VAL2,", [r",7, 24,"], #16")
 	TEST_RR( "strd	r",7, VAL2,", r",8, VAL1,", [sp], #-16")
+	TEST_RRP("strd	r",6, VAL1,", r",7, VAL2,", [r",13, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!")
+	TEST_UNSUPPORTED("strd r6, r7, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")
+	TEST_RRP("strd	r",4, VAL1,", r",5, VAL2,", [r",14, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!")
 	TEST_UNSUPPORTED(__inst_thumb32(0xe9efec04) "	@ strd	r14, r12, [pc, #16]!")
 	TEST_UNSUPPORTED(__inst_thumb32(0xe8efec04) "	@ strd	r14, r12, [pc], #16")
 
@@ -821,14 +825,22 @@ CONDITION_INSTRUCTIONS(22,
 	TEST_RP( "str"size"	r",14,VAL2,", [r",1, 256,  ", #-128]!")		\
 	TEST_RPR("str"size".w	r",0, VAL1,", [r",1, 0,", r",2, 4,"]")		\
 	TEST_RPR("str"size"	r",14,VAL2,", [r",10,0,", r",11,4,", lsl #1]")	\
+	TEST_UNSUPPORTED("str"size"	r0, [r13, r1]")				\
 	TEST_R(  "str"size".w	r",7, VAL1,", [sp, #24]")			\
 	TEST_RP( "str"size".w	r",0, VAL2,", [r",0,0, "]")			\
+	TEST_RP( "str"size"	r",6, VAL1,", [r",13, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"]!") \
+	TEST_UNSUPPORTED("str"size"	r6, [r13, #-"__stringify(MAX_STACK_SIZE)"-8]!")			\
+	TEST_RP( "str"size"	r",4, VAL2,", [r",12, TEST_MEMORY_SIZE,", #-"__stringify(MAX_STACK_SIZE)"-8]!") \
 	TEST_UNSUPPORTED("str"size"t	r0, [r1, #4]")
 
 	SINGLE_STORE("b")
 	SINGLE_STORE("h")
 	SINGLE_STORE("")
 
+	TEST_UNSUPPORTED(__inst_thumb32(0xf801000d) "	@ strb	r0, [r1, r13]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf821000d) "	@ strh	r0, [r1, r13]")
+	TEST_UNSUPPORTED(__inst_thumb32(0xf841000d) "	@ str	r0, [r1, r13]")
+
 	TEST("str	sp, [sp]")
 	TEST_UNSUPPORTED(__inst_thumb32(0xf8cfe000) "	@ str	r14, [pc]")
 	TEST_UNSUPPORTED(__inst_thumb32(0xf8cef000) "	@ str	pc, [r14]")
-- 
1.8.4

