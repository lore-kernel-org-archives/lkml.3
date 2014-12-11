Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066AbaLKKKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:10:11 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:54858 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550AbaLKKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:08:38 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v16 8/8] ARM: kprobes: Fix unreliable MRS instruction tests
Date: Thu, 11 Dec 2014 18:04:36 +0800
Message-ID: <1418292276-75255-9-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418292276-75255-1-git-send-email-wangnan0@huawei.com>
References: <1418292276-75255-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54896D28.0347,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5e2fa58c74011308554dc2586f6d2b48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jon Medhurst (Tixy)" <tixy@linaro.org>

For the instruction 'mrs Rn, cpsr' the resulting value of Rn can vary due to
external factors we can't control. So get the test code to mask out these
indeterminate bits.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---
 arch/arm/probes/kprobes/test-arm.c   |  6 +++---
 arch/arm/probes/kprobes/test-core.c  | 19 ++++++++++---------
 arch/arm/probes/kprobes/test-core.h  | 33 ++++++++++++++++++++++++++++-----
 arch/arm/probes/kprobes/test-thumb.c |  4 ++--
 4 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/arm/probes/kprobes/test-arm.c b/arch/arm/probes/kprobes/test-arm.c
index 9b3b1b4..e72b07e 100644
--- a/arch/arm/probes/kprobes/test-arm.c
+++ b/arch/arm/probes/kprobes/test-arm.c
@@ -204,9 +204,9 @@ void kprobe_arm_test_cases(void)
 #endif
 	TEST_GROUP("Miscellaneous instructions")
 
-	TEST("mrs	r0, cpsr")
-	TEST("mrspl	r7, cpsr")
-	TEST("mrs	r14, cpsr")
+	TEST_RMASKED("mrs	r",0,~PSR_IGNORE_BITS,", cpsr")
+	TEST_RMASKED("mrspl	r",7,~PSR_IGNORE_BITS,", cpsr")
+	TEST_RMASKED("mrs	r",14,~PSR_IGNORE_BITS,", cpsr")
 	TEST_UNSUPPORTED(__inst_arm(0xe10ff000) "	@ mrs r15, cpsr")
 	TEST_UNSUPPORTED("mrs	r0, spsr")
 	TEST_UNSUPPORTED("mrs	lr, spsr")
diff --git a/arch/arm/probes/kprobes/test-core.c b/arch/arm/probes/kprobes/test-core.c
index 7c5ddd5..e495127 100644
--- a/arch/arm/probes/kprobes/test-core.c
+++ b/arch/arm/probes/kprobes/test-core.c
@@ -1056,15 +1056,6 @@ static int test_case_run_count;
 static bool test_case_is_thumb;
 static int test_instance;
 
-/*
- * We ignore the state of the imprecise abort disable flag (CPSR.A) because this
- * can change randomly as the kernel doesn't take care to preserve or initialise
- * this across context switches. Also, with Security Extentions, the flag may
- * not be under control of the kernel; for this reason we ignore the state of
- * the FIQ disable flag CPSR.F as well.
- */
-#define PSR_IGNORE_BITS (PSR_A_BIT | PSR_F_BIT)
-
 static unsigned long test_check_cc(int cc, unsigned long cpsr)
 {
 	int ret = arm_check_condition(cc << 28, cpsr);
@@ -1271,11 +1262,21 @@ test_case_pre_handler(struct kprobe *p, struct pt_regs *regs)
 static int __kprobes
 test_after_pre_handler(struct kprobe *p, struct pt_regs *regs)
 {
+	struct test_arg *args;
+
 	if (container_of(p, struct test_probe, kprobe)->hit == test_instance)
 		return 0; /* Already run for this test instance */
 
 	result_regs = *regs;
+
+	/* Mask out results which are indeterminate */
 	result_regs.ARM_cpsr &= ~PSR_IGNORE_BITS;
+	for (args = current_args; args[0].type != ARG_TYPE_END; ++args)
+		if (args[0].type == ARG_TYPE_REG_MASKED) {
+			struct test_arg_regptr *arg =
+				(struct test_arg_regptr *)args;
+			result_regs.uregs[arg->reg] &= arg->val;
+		}
 
 	/* Undo any changes done to SP by the test case */
 	regs->ARM_sp = (unsigned long)current_stack;
diff --git a/arch/arm/probes/kprobes/test-core.h b/arch/arm/probes/kprobes/test-core.h
index 9991754..9428520 100644
--- a/arch/arm/probes/kprobes/test-core.h
+++ b/arch/arm/probes/kprobes/test-core.h
@@ -45,10 +45,11 @@ extern int kprobe_test_cc_position;
  *
  */
 
-#define	ARG_TYPE_END	0
-#define	ARG_TYPE_REG	1
-#define	ARG_TYPE_PTR	2
-#define	ARG_TYPE_MEM	3
+#define	ARG_TYPE_END		0
+#define	ARG_TYPE_REG		1
+#define	ARG_TYPE_PTR		2
+#define	ARG_TYPE_MEM		3
+#define	ARG_TYPE_REG_MASKED	4
 
 #define ARG_FLAG_UNSUPPORTED	0x01
 #define ARG_FLAG_SUPPORTED	0x02
@@ -61,7 +62,7 @@ struct test_arg {
 };
 
 struct test_arg_regptr {
-	u8	type;		/* ARG_TYPE_REG or ARG_TYPE_PTR */
+	u8	type;		/* ARG_TYPE_REG or ARG_TYPE_PTR or ARG_TYPE_REG_MASKED */
 	u8	reg;
 	u8	_padding[2];
 	u32	val;
@@ -138,6 +139,12 @@ struct test_arg_end {
 	".short	0					\n\t"	\
 	".word	"#val"					\n\t"
 
+#define	TEST_ARG_REG_MASKED(reg, val)				\
+	".byte	"__stringify(ARG_TYPE_REG_MASKED)"	\n\t"	\
+	".byte	"#reg"					\n\t"	\
+	".short	0					\n\t"	\
+	".word	"#val"					\n\t"
+
 #define	TEST_ARG_END(flags)					\
 	".byte	"__stringify(ARG_TYPE_END)"		\n\t"	\
 	".byte	"TEST_ISA flags"			\n\t"	\
@@ -395,6 +402,22 @@ struct test_arg_end {
 	"	"codex"			\n\t"					\
 	TESTCASE_END
 
+#define TEST_RMASKED(code1, reg, mask, code2)		\
+	TESTCASE_START(code1 #reg code2)		\
+	TEST_ARG_REG_MASKED(reg, mask)			\
+	TEST_ARG_END("")				\
+	TEST_INSTRUCTION(code1 #reg code2)		\
+	TESTCASE_END
+
+/*
+ * We ignore the state of the imprecise abort disable flag (CPSR.A) because this
+ * can change randomly as the kernel doesn't take care to preserve or initialise
+ * this across context switches. Also, with Security Extensions, the flag may
+ * not be under control of the kernel; for this reason we ignore the state of
+ * the FIQ disable flag CPSR.F as well.
+ */
+#define PSR_IGNORE_BITS (PSR_A_BIT | PSR_F_BIT)
+
 
 /*
  * Macros for defining space directives spread over multiple lines.
diff --git a/arch/arm/probes/kprobes/test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
index e8cf193..b683b45 100644
--- a/arch/arm/probes/kprobes/test-thumb.c
+++ b/arch/arm/probes/kprobes/test-thumb.c
@@ -778,8 +778,8 @@ CONDITION_INSTRUCTIONS(22,
 
 	TEST_UNSUPPORTED("subs	pc, lr, #4")
 
-	TEST("mrs	r0, cpsr")
-	TEST("mrs	r14, cpsr")
+	TEST_RMASKED("mrs	r",0,~PSR_IGNORE_BITS,", cpsr")
+	TEST_RMASKED("mrs	r",14,~PSR_IGNORE_BITS,", cpsr")
 	TEST_UNSUPPORTED(__inst_thumb32(0xf3ef8d00) "	@ mrs	sp, spsr")
 	TEST_UNSUPPORTED(__inst_thumb32(0xf3ef8f00) "	@ mrs	pc, spsr")
 	TEST_UNSUPPORTED("mrs	r0, spsr")
-- 
1.8.4

