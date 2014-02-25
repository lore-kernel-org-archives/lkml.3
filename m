Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaBYJVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:21:07 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48402 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBYJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:21:00 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: wad@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v2 2/3] arm64: Add seccomp support
Date: Tue, 25 Feb 2014 18:20:24 +0900
Message-Id: <1393320025-2855-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

secure_computing() should always be called first in syscall_trace(), and
if it returns non-zero, we should stop further handling. Then that system
call may eventually fail, be trapped or the process itself be killed
depending on loaded rules.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |   17 +++++++++++++++++
 arch/arm64/include/asm/seccomp.h |   25 +++++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h  |    3 +++
 arch/arm64/kernel/entry.S        |    4 ++++
 arch/arm64/kernel/ptrace.c       |    6 ++++++
 5 files changed, 55 insertions(+)
 create mode 100644 arch/arm64/include/asm/seccomp.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a21455e..a0102f7 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -27,6 +27,7 @@ config ARM64
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
@@ -222,6 +223,22 @@ config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 
 source "mm/Kconfig"
 
+config SECCOMP
+	def_bool y
+	prompt "Enable seccomp to safely compute untrusted bytecode"
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
+	  If unsure, say Y. Only embedded should say N here.
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
index 4a09fdb..05f2db3 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -30,6 +30,9 @@
  * Compat syscall numbers used by the AArch64 kernel.
  */
 #define __NR_compat_restart_syscall	0
+#define __NR_compat_exit		1
+#define __NR_compat_read		3
+#define __NR_compat_write		4
 #define __NR_compat_sigreturn		119
 #define __NR_compat_rt_sigreturn	173
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 96c2d03..7f3cbaf 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -651,6 +651,10 @@ __sys_trace:
 	mov	x1, sp
 	mov	w0, #0				// trace entry
 	bl	syscall_trace
+#ifdef CONFIG_SECCOMP
+	cmp	w0, #-EPERM			// check seccomp result
+	b.eq	ret_to_user			// -EPERM means 'rejected'
+#endif
 	adr	lr, __sys_trace_return		// return address
 	uxtw	scno, w0			// syscall number (possibly new)
 	mov	x1, sp				// pointer to regs
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index d4ce70e..f2a74bc 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -20,12 +20,14 @@
  */
 
 #include <linux/audit.h>
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
@@ -1064,6 +1066,10 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 {
 	unsigned long saved_reg;
 
+	if (!dir && secure_computing((int)regs->syscallno))
+		/* seccomp failures shouldn't expose any additional code. */
+		return -EPERM;
+
 	if (dir && test_thread_flag(TIF_SYSCALL_AUDIT))
 		audit_syscall_exit(regs);
 
-- 
1.7.9.5

