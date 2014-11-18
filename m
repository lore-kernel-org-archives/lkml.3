Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaKRBLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:11:37 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65099 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaKRBLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:11:34 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v8 1/6] arm64: ptrace: add NT_ARM_SYSTEM_CALL regset
Date: Tue, 18 Nov 2014 10:10:33 +0900
Message-Id: <1416273038-15590-2-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This regeset is intended to be used to get and set a system call number
while tracing.
There was some discussion about possible approaches to do so:

(1) modify x8 register with ptrace(PTRACE_SETREGSET) indirectly,
    and update regs->syscallno later on in syscall_trace_enter(), or
(2) define a dedicated regset for this purpose as on s390, or
(3) support ptrace(PTRACE_SET_SYSCALL) as on arch/arm

Thinking of the fact that user_pt_regs doesn't expose 'syscallno' to
tracer as well as that secure_computing() expects a changed syscall number,
especially case of -1, to be visible before this function returns in
syscall_trace_enter(), (1) doesn't work well.
We will take (2) since it looks much cleaner.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/ptrace.c |   35 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h   |    1 +
 2 files changed, 36 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 8a4ae8e..8b98781 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -551,6 +551,32 @@ static int tls_set(struct task_struct *target, const struct user_regset *regset,
 	return ret;
 }
 
+static int system_call_get(struct task_struct *target,
+			   const struct user_regset *regset,
+			   unsigned int pos, unsigned int count,
+			   void *kbuf, void __user *ubuf)
+{
+	struct pt_regs *regs = task_pt_regs(target);
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				   &regs->syscallno, 0, -1);
+}
+
+static int system_call_set(struct task_struct *target,
+			   const struct user_regset *regset,
+			   unsigned int pos, unsigned int count,
+			   const void *kbuf, const void __user *ubuf)
+{
+	int syscallno, ret;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &syscallno, 0, -1);
+	if (ret)
+		return ret;
+
+	task_pt_regs(target)->syscallno = syscallno;
+	return ret;
+}
+
 enum aarch64_regset {
 	REGSET_GPR,
 	REGSET_FPR,
@@ -559,6 +585,7 @@ enum aarch64_regset {
 	REGSET_HW_BREAK,
 	REGSET_HW_WATCH,
 #endif
+	REGSET_SYSTEM_CALL,
 };
 
 static const struct user_regset aarch64_regsets[] = {
@@ -608,6 +635,14 @@ static const struct user_regset aarch64_regsets[] = {
 		.set = hw_break_set,
 	},
 #endif
+	[REGSET_SYSTEM_CALL] = {
+		.core_note_type = NT_ARM_SYSTEM_CALL,
+		.n = 1,
+		.size = sizeof(int),
+		.align = sizeof(int),
+		.get = system_call_get,
+		.set = system_call_set,
+	},
 };
 
 static const struct user_regset_view user_aarch64_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ea9bf25..71e1d0e 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -397,6 +397,7 @@ typedef struct elf64_shdr {
 #define NT_ARM_TLS	0x401		/* ARM TLS register */
 #define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
+#define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
 #define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
 #define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
 #define NT_METAG_TLS	0x502		/* Metag TLS pointer */
-- 
1.7.9.5

