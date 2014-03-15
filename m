Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaCOFrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:47:37 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36992 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaCOFrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:47:33 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v7 7/7] arm64: ftrace: Add system call tracepoint
Date: Sat, 15 Mar 2014 14:45:53 +0900
Message-Id: <1394862353-28963-8-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows system call entry or exit to be traced as ftrace events,
ie. sys_enter_*/sys_exit_*, if CONFIG_FTRACE_SYSCALLS is enabled.
Those events appear and can be controlled under
    ${sysfs}/tracing/events/syscalls/

Please note that we can't trace compat system calls here because
AArch32 mode does not share the same syscall table with AArch64.
Just define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS in order to avoid unexpected
results (bogus syscalls reported or even hang-up).

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |  1 +
 arch/arm64/include/asm/ftrace.h  | 18 ++++++++++++++++++
 arch/arm64/include/asm/syscall.h |  1 +
 arch/arm64/include/asm/unistd.h  |  2 ++
 arch/arm64/kernel/ptrace.c       |  9 +++++++++
 5 files changed, 31 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6954959..b1dcdb4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -43,6 +43,7 @@ config ARM64
 	select HAVE_MEMBLOCK
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
+	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_DOMAIN
 	select MODULES_USE_ELF_RELA
 	select NO_BOOTMEM
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index c44c4b1..7616255 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -44,6 +44,24 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 #define CALLER_ADDR4 ((unsigned long)return_address(4))
 #define CALLER_ADDR5 ((unsigned long)return_address(5))
 #define CALLER_ADDR6 ((unsigned long)return_address(6))
+
+#include <linux/compat.h>
+
+/*
+ * Because AArch32 mode does not share the same syscall table with AArch64,
+ * tracing compat syscalls may result in reporting bogus syscalls or even
+ * hang-up, so just do not trace them.
+ * See kernel/trace/trace_syscalls.c
+ *
+ * x86 code says:
+ * If the user realy wants these, then they should use the
+ * raw syscall tracepoints with filtering.
+ */
+#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
+static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return is_compat_task();
+}
 #endif /* ifndef __ASSEMBLY__ */
 
 #endif /* __ASM_FTRACE_H */
diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 70ba9d4..383771e 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -18,6 +18,7 @@
 
 #include <linux/err.h>
 
+extern const void *sys_call_table[];
 
 static inline int syscall_get_nr(struct task_struct *task,
 				 struct pt_regs *regs)
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 82ce217..c335479 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -28,3 +28,5 @@
 #endif
 #define __ARCH_WANT_SYS_CLONE
 #include <uapi/asm/unistd.h>
+
+#define NR_syscalls (__NR_syscalls)
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index c47a3ed..3ee76ed 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -42,6 +42,9 @@
 #include <asm/traps.h>
 #include <asm/system_misc.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 /*
  * TODO: does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
@@ -1091,11 +1094,17 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
 
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		trace_sys_enter(regs, regs->syscallno);
+
 	return regs->syscallno;
 }
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		trace_sys_exit(regs, regs_return_value(regs));
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
 }
-- 
1.8.3.2

