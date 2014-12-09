Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaLIRLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:11:21 -0500
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:57914 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153AbaLIRLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:11:20 -0500
Message-ID: <1418145071.3641.60.camel@linaro.org>
Subject: [PATCH v3] ARM: kprobes: Add test cases for stack consuming
 instructions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, lizefan@huawei.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 09 Dec 2014 17:11:11 +0000
In-Reply-To: <1418143407.3641.47.camel@linaro.org>
References: <1418047765-53197-1-git-send-email-wangnan0@huawei.com>
	 <1418047765-53197-6-git-send-email-wangnan0@huawei.com>
	 <1418143407.3641.47.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These have extra 'checker' functions associated with them so lets make
sure those get covered by testing. As they may create uninitialised
space on the stack we also update the test code to ensure such space is
consistent between test runs. This is done by disabling interrupts in
setup_test_context().

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---

Sorry for the extra noise, sent this new version to correct whitespace
and spelling errors in previous one.

 arch/arm/probes/kprobes/test-arm.c   | 17 +++++++++++++++--
 arch/arm/probes/kprobes/test-core.c  |  9 +++++++++
 arch/arm/probes/kprobes/test-thumb.c | 12 ++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

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
diff --git a/arch/arm/probes/kprobes/test-core.c b/arch/arm/probes/kprobes/test-core.c
index 7ab633d..7c5ddd5 100644
--- a/arch/arm/probes/kprobes/test-core.c
+++ b/arch/arm/probes/kprobes/test-core.c
@@ -1196,6 +1196,13 @@ static void setup_test_context(struct pt_regs *regs)
 			regs->uregs[arg->reg] =
 				(unsigned long)current_stack + arg->val;
 			memory_needs_checking = true;
+			/*
+			 * Test memory at an address below SP is in danger of
+			 * being altered by an interrupt occurring and pushing
+			 * data onto the stack. Disable interrupts to stop this.
+			 */
+			if (arg->reg == 13)
+				regs->ARM_cpsr |= PSR_I_BIT;
 			break;
 		}
 		case ARG_TYPE_MEM: {
@@ -1272,6 +1279,8 @@ test_after_pre_handler(struct kprobe *p, struct pt_regs *regs)
 
 	/* Undo any changes done to SP by the test case */
 	regs->ARM_sp = (unsigned long)current_stack;
+	/* Enable interrupts in case setup_test_context disabled them */
+	regs->ARM_cpsr &= ~PSR_I_BIT;
 
 	container_of(p, struct test_probe, kprobe)->hit = test_instance;
 	return 0;
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
2.1.3



