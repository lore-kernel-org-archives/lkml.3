Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3AKG32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:29:28 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:51493 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3AKG30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:29:26 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: added DSCR support to ptrace
Date: Fri, 11 Jan 2013 17:29:09 +1100
Message-Id: <1357885749-14042-1-git-send-email-aik@ozlabs.ru>
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

The patch does not increase PT_REGS_COUNT as the pt_regs struct has not
been changed.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/uapi/asm/ptrace.h |    1 +
 arch/powerpc/kernel/ptrace.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/arch/powerpc/include/uapi/asm/ptrace.h b/arch/powerpc/include/uapi/asm/ptrace.h
index ee67a2b..5a4863c 100644
--- a/arch/powerpc/include/uapi/asm/ptrace.h
+++ b/arch/powerpc/include/uapi/asm/ptrace.h
@@ -108,6 +108,7 @@ struct pt_regs {
 #define PT_DAR	41
 #define PT_DSISR 42
 #define PT_RESULT 43
+#define PT_DSCR 44
 #define PT_REGS_COUNT 44
 
 #define PT_FPR0	48	/* each FP reg occupies 2 slots in this space */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index d4afccc..245c1b6 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -179,6 +179,30 @@ static int set_user_msr(struct task_struct *task, unsigned long msr)
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
+#else
+static unsigned long get_user_dscr(struct task_struct *task)
+{
+	return -EIO;
+}
+
+static int set_user_dscr(struct task_struct *task, unsigned long dscr)
+{
+	return -EIO;
+}
+#endif
+
 /*
  * We prevent mucking around with the reserved area of trap
  * which are used internally by the kernel.
@@ -200,6 +224,9 @@ unsigned long ptrace_get_reg(struct task_struct *task, int regno)
 	if (regno == PT_MSR)
 		return get_user_msr(task);
 
+	if (regno == PT_DSCR)
+		return get_user_dscr(task);
+
 	if (regno < (sizeof(struct pt_regs) / sizeof(unsigned long)))
 		return ((unsigned long *)task->thread.regs)[regno];
 
@@ -218,6 +245,8 @@ int ptrace_put_reg(struct task_struct *task, int regno, unsigned long data)
 		return set_user_msr(task, data);
 	if (regno == PT_TRAP)
 		return set_user_trap(task, data);
+	if (regno == PT_DSCR)
+		return set_user_dscr(task, data);
 
 	if (regno <= PT_MAX_PUT_REG) {
 		((unsigned long *)task->thread.regs)[regno] = data;
-- 
1.7.10.4

