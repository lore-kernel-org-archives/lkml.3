Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaHUI60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:58:26 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43425 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaHUI6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:58:20 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v6 6/6] arm64: add seccomp support
Date: Thu, 21 Aug 2014 17:56:45 +0900
Message-Id: <1408611405-8943-7-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
References: <1408611405-8943-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

secure_computing() is called first in syscall_trace_enter() so that a system
call will be aborted quickly without doing succeeding syscall tracing,
contrary to other cases, if seccomp rules deny that system call.

On compat task, syscall numbers for system calls allowed in seccomp mode 1
are different from those on normal tasks, and so _NR_seccomp_xxx_32's need
to be redefined.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |   14 ++++++++++++++
 arch/arm64/include/asm/ptrace.h  |    1 +
 arch/arm64/include/asm/seccomp.h |   25 +++++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h  |    3 +++
 arch/arm64/kernel/entry.S        |    2 ++
 arch/arm64/kernel/ptrace.c       |    5 +++++
 6 files changed, 50 insertions(+)
 create mode 100644 arch/arm64/include/asm/seccomp.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..d6dc436 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -34,6 +34,7 @@ config ARM64
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_CC_STACKPROTECTOR
@@ -312,6 +313,19 @@ config ARCH_HAS_CACHE_LINE_SIZE
 
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
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index a58cf62..a844d06 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -71,6 +71,7 @@
  * with ptrace(PTRACE_SET_SYSCALL)
  */
 #define RET_SKIP_SYSCALL	-1
+#define RET_SKIP_SYSCALL_TRACE	-2
 #define IS_SKIP_SYSCALL(no)	((int)(no & 0xffffffff) == -1)
 
 #ifndef __ASSEMBLY__
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
index cf6ee31..7c73059 100644
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
index fdd6eae..d5eb447 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -672,6 +672,8 @@ ENDPROC(el0_svc)
 __sys_trace:
 	mov	x0, sp
 	bl	syscall_trace_enter
+	cmp	w0, #RET_SKIP_SYSCALL_TRACE	// skip syscall and tracing?
+	b.eq	ret_to_user
 	cmp	w0, #RET_SKIP_SYSCALL		// skip syscall?
 	b.eq	__sys_trace_return_skipped
 	adr	lr, __sys_trace_return		// return address
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index c54dbcc..4287d68 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -27,6 +27,7 @@
 #include <linux/smp.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
+#include <linux/seccomp.h>
 #include <linux/security.h>
 #include <linux/init.h>
 #include <linux/signal.h>
@@ -1123,6 +1124,10 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 {
 	unsigned int saved_syscallno = regs->syscallno;
 
+	/* Do the secure computing check first; failures should be fast. */
+	if (secure_computing(regs->syscallno) == -1)
+		return RET_SKIP_SYSCALL_TRACE;
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
-- 
1.7.9.5

