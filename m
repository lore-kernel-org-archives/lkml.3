Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaGDHcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:32:46 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41730 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbaGDHcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:32:43 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [RESEND PATCH v4 2/2] arm64: Add seccomp support
Date: Fri,  4 Jul 2014 16:31:55 +0900
Message-Id: <1404459115-8292-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404459115-8292-1-git-send-email-takahiro.akashi@linaro.org>
References: <1404459115-8292-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

secure_computing() should always be called first in syscall_trace_enter().
If it returns non-zero, we should stop further handling. Then that system
call may eventually fail, be trapped or the process itself be killed
depending on loaded rules.
In this case, syscall_trace_enter() returns a dedicated value in order to
skip a normal syscall table lookup because a seccomp rule may have already
overridden errno.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |   14 ++++++++++++++
 arch/arm64/include/asm/seccomp.h |   25 +++++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h  |    3 +++
 arch/arm64/kernel/entry.S        |    4 ++++
 arch/arm64/kernel/ptrace.c       |    6 ++++++
 5 files changed, 52 insertions(+)
 create mode 100644 arch/arm64/include/asm/seccomp.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3a18571..eeac003 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -32,6 +32,7 @@ config ARM64
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_BUGVERBOSE
@@ -259,6 +260,19 @@ config ARCH_HAS_CACHE_LINE_SIZE
 
 source "mm/Kconfig"
 
+config SECCOMP
+	bool "Enable seccomp to safely compute untrusted bytecode"
+	---help---
+	  This kernel feature is useful for number crunching applications
+	  that may need to compute untrusted bytecode during their
+	  execution. By using pipes or other transports made available to
+	  the process as file descriptors supporting the read/write
+	  syscalls, it's possible to isolate those applications in
+	  their own address space using seccomp. Once seccomp is
+	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
+	  and the task is only allowed to execute a few safe syscalls
+	  defined by each seccomp mode.
+
 config XEN_DOM0
 	def_bool y
 	depends on XEN
diff --git a/arch/arm64/include/asm/seccomp.h b/arch/arm64/include/asm/seccomp.h
new file mode 100644
index 0000000..c76fac9
--- /dev/null
+++ b/arch/arm64/include/asm/seccomp.h
@@ -0,0 +1,25 @@
+/*
+ * arch/arm64/include/asm/seccomp.h
+ *
+ * Copyright (C) 2014 Linaro Limited
+ * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_SECCOMP_H
+#define _ASM_SECCOMP_H
+
+#include <asm/unistd.h>
+
+#ifdef CONFIG_COMPAT
+#define __NR_seccomp_read_32		__NR_compat_read
+#define __NR_seccomp_write_32		__NR_compat_write
+#define __NR_seccomp_exit_32		__NR_compat_exit
+#define __NR_seccomp_sigreturn_32	__NR_compat_rt_sigreturn
+#endif /* CONFIG_COMPAT */
+
+#include <asm-generic/seccomp.h>
+
+#endif /* _ASM_SECCOMP_H */
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index c980ab7..729c155 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -31,6 +31,9 @@
  * Compat syscall numbers used by the AArch64 kernel.
  */
 #define __NR_compat_restart_syscall	0
+#define __NR_compat_exit		1
+#define __NR_compat_read		3
+#define __NR_compat_write		4
 #define __NR_compat_sigreturn		119
 #define __NR_compat_rt_sigreturn	173
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5141e79..fe55b4c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -628,6 +628,10 @@ ENDPROC(el0_svc)
 __sys_trace:
 	mov	x0, sp
 	bl	syscall_trace_enter
+#ifdef CONFIG_SECCOMP
+	cmp	w0, #-EPERM			// check seccomp result
+	b.eq	ret_to_user			// -EPERM means 'rejected'
+#endif
 	adr	lr, __sys_trace_return		// return address
 	uxtw	scno, w0			// syscall number (possibly new)
 	mov	x1, sp				// pointer to regs
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 70526cf..baab5fc 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -21,12 +21,14 @@
 
 #include <linux/audit.h>
 #include <linux/compat.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
+#include <linux/seccomp.h>
 #include <linux/security.h>
 #include <linux/init.h>
 #include <linux/signal.h>
@@ -1109,6 +1111,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 
 asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
+	if (secure_computing(regs->syscallno) == -1)
+		/* seccomp failures shouldn't expose any additional code. */
+		return -EPERM;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
-- 
1.7.9.5

