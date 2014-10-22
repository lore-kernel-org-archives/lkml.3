Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbaJVLe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:34:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25517 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbaJVLeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:34:06 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v6 5/7] ARM: kprobes: disallow probing stack consuming instructions
Date: Wed, 22 Oct 2014 19:32:03 +0800
Message-ID: <1413977525-51480-6-git-send-email-wangnan0@huawei.com>
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

This patch prohibit probing instructions for which the stack
requirement are unable to be determined statically. Some test cases
are found not work again after the modification, this patch also
removes them.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/kernel/kprobes-test-arm.c | 16 ++++++++++------
 arch/arm/kernel/kprobes.c          |  8 ++++++++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 264c064..59f9b25 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -476,7 +476,8 @@ void kprobe_arm_test_cases(void)
 	TEST_GROUP("Extra load/store instructions")
 
 	TEST_RPR(  "strh	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")
-	TEST_RPR(  "streqh	r",14,VAL2,", [r",13,0, ", r",12, 48,"]")
+	TEST_RPR(  "streqh	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")
+	TEST_UNSUPPORTED(  "streqh	r14, [r13, r12]")
 	TEST_RPR(  "strh	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")
 	TEST_RPR(  "strneh	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
 	TEST_RPR(  "strh	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")
@@ -565,7 +566,8 @@ void kprobe_arm_test_cases(void)
 
 #if __LINUX_ARM_ARCH__ >= 5
 	TEST_RPR(  "strd	r",0, VAL1,", [r",1, 48,", -r",2,24,"]")
-	TEST_RPR(  "strccd	r",8, VAL2,", [r",13,0, ", r",12,48,"]")
+	TEST_RPR(  "strccd	r",8, VAL2,", [r",11,0, ", r",12,48,"]")
+	TEST_UNSUPPORTED(  "strccd r8, [r13, r12]")
 	TEST_RPR(  "strd	r",4, VAL1,", [r",2, 24,", r",3, 48,"]!")
 	TEST_RPR(  "strcsd	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")
 	TEST_RPR(  "strd	r",2, VAL1,", [r",5, 24,"], r",4,48,"")
@@ -639,13 +641,15 @@ void kprobe_arm_test_cases(void)
 	TEST_RP( "str"byte"	r",2, VAL1,", [r",3, 24,"], #48")		\
 	TEST_RP( "str"byte"	r",10,VAL2,", [r",9, 64,"], #-48")		\
 	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")	\
-	TEST_RPR("str"byte"	r",14,VAL2,", [r",13,0, ", r",12, 48,"]")	\
+	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 48,"]")	\
+	TEST_UNSUPPORTED("str"byte" r14, [r13, r12]")	\
 	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  48,"]!")	\
 	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,48,", -r",10,24,"]!")	\
 	TEST_RPR("str"byte"	r",2, VAL1,", [r",3, 24,"], r",4, 48,"")	\
 	TEST_RPR("str"byte"	r",10,VAL2,", [r",9, 48,"], -r",11,24,"")	\
 	TEST_RPR("str"byte"	r",0, VAL1,", [r",1, 24,", r",2,  32,", asl #1]")\
-	TEST_RPR("str"byte"	r",14,VAL2,", [r",13,0, ", r",12, 32,", lsr #2]")\
+	TEST_RPR("str"byte"	r",14,VAL2,", [r",11,0, ", r",12, 32,", lsr #2]")\
+	TEST_UNSUPPORTED("str"byte"	r14, [r13, r12, lsr #2]")\
 	TEST_RPR("str"byte"	r",1, VAL1,", [r",2, 24,", r",3,  32,", asr #3]!")\
 	TEST_RPR("str"byte"	r",12,VAL2,", [r",11,24,", r",10, 4,", ror #31]!")\
 	TEST_P(  "ldr"byte"	r0, [r",0,  24,", #-2]")			\
@@ -669,12 +673,12 @@ void kprobe_arm_test_cases(void)
 
 	LOAD_STORE("")
 	TEST_P(   "str	pc, [r",0,0,", #15*4]")
-	TEST_R(   "str	pc, [sp, r",2,15*4,"]")
+	TEST_UNSUPPORTED(   "str	pc, [sp, r2]")
 	TEST_BF(  "ldr	pc, [sp, #15*4]")
 	TEST_BF_R("ldr	pc, [sp, r",2,15*4,"]")
 
 	TEST_P(   "str	sp, [r",0,0,", #13*4]")
-	TEST_R(   "str	sp, [sp, r",2,13*4,"]")
+	TEST_UNSUPPORTED(   "str	sp, [sp, r2]")
 	TEST_BF(  "ldr	sp, [sp, #13*4]")
 	TEST_BF_R("ldr	sp, [sp, r",2,13*4,"]")
 
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 028159c..afbb3e5 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -111,6 +111,14 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		break;
 	}
 
+	/*
+	 * Unable to instrument insn like 'str r0, [sp, +/-r1]'.
+	 * __und_svc protects 64 bytes stack, so instrumenting insn
+	 * likes 'str r0, [sp, #-68]' should be prohibited.
+	 */
+	if ((p->ainsn.stack_space < 0) || (p->ainsn.stack_space > 64))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
1.8.4

