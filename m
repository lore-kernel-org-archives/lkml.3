Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3AKES0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:18:26 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60991 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3AKESZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:18:25 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: added DSCR support to ptrace
Date: Fri, 11 Jan 2013 15:18:11 +1100
Message-Id: <1357877891-28219-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DSCR (aka Data Stream Control Register) is supported on some
server PowerPC chips and allow some control over the prefetch
of data streams.

The kernel already supports DSCR value per thread but there is also
a need in a ability to change it from an external process for
the specific pid.

The patch adds new register index PT_DSCR (index=44) which can be
set/get by:
  ptrace(PTRACE_POKEUSER, traced_process, PT_DSCR << 3, dscr);
  dscr = ptrace(PTRACE_PEEKUSER, traced_process, PT_DSCR << 3, NULL);

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/ptrace.h |    3 +++
 arch/powerpc/kernel/ptrace.c      |   23 ++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 48223f9..85eefa8 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -261,6 +261,9 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 #define PT_DAR	41
 #define PT_DSISR 42
 #define PT_RESULT 43
+#ifdef __powerpc64__
+#define PT_DSCR 44
+#endif
 #define PT_REGS_COUNT 44
 
 #define PT_FPR0	48	/* each FP reg occupies 2 slots in this space */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 05b7dd2..444f22a 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -182,6 +182,20 @@ static int set_user_msr(struct task_struct *task, unsigned long msr)
 	return 0;
 }
 
+#ifdef CONFIG_PPC64
+static unsigned long get_user_dscr(struct task_struct *task)
+{
+	return task->thread.dscr;
+}
+
+static int set_user_dscr(struct task_struct *task, unsigned long dscr)
+{
+	task->thread.dscr = dscr;
+	task->thread.dscr_inherit = 1;
+	return 0;
+}
+#endif
+
 /*
  * We prevent mucking around with the reserved area of trap
  * which are used internally by the kernel.
@@ -203,6 +217,10 @@ unsigned long ptrace_get_reg(struct task_struct *task, int regno)
 	if (regno == PT_MSR)
 		return get_user_msr(task);
 
+#ifdef CONFIG_PPC64
+	if (regno == PT_DSCR)
+		return get_user_dscr(task);
+#endif
 	if (regno < (sizeof(struct pt_regs) / sizeof(unsigned long)))
 		return ((unsigned long *)task->thread.regs)[regno];
 
@@ -221,7 +239,10 @@ int ptrace_put_reg(struct task_struct *task, int regno, unsigned long data)
 		return set_user_msr(task, data);
 	if (regno == PT_TRAP)
 		return set_user_trap(task, data);
-
+#ifdef CONFIG_PPC64
+	if (regno == PT_DSCR)
+		return set_user_dscr(task, data);
+#endif
 	if (regno <= PT_MAX_PUT_REG) {
 		((unsigned long *)task->thread.regs)[regno] = data;
 		return 0;
-- 
1.7.10.4

