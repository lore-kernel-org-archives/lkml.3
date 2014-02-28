Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaB1FUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:20:11 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54398 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaB1FUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:20:06 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 5/7] arm64: ftrace: Add system call tracepoint
Date: Fri, 28 Feb 2014 14:18:42 +0900
Message-Id: <1393564724-3966-6-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
 <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows system call entry or exit to be traced as ftrace events,
ie. sys_enter_*/sys_exit_*, if CONFIG_FTRACE_SYSCALLS is enabled.
Those events appear and can be controlled under
    ${sysfs}/tracing/events/syscalls/

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |    1 +
 arch/arm64/include/asm/syscall.h |    1 +
 arch/arm64/include/asm/unistd.h  |    2 ++
 arch/arm64/kernel/ptrace.c       |   52 ++++++++++++++++++++++----------------
 4 files changed, 34 insertions(+), 22 deletions(-)

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
index 6a8928b..dc90f9f 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -41,6 +41,9 @@
 #include <asm/traps.h>
 #include <asm/system_misc.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/syscalls.h>
+
 /*
  * TODO: does not yet catch signals sent when the child dies.
  * in exit.c or in signal.c.
@@ -1062,31 +1065,36 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 {
 	unsigned long saved_reg;
 
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return regs->syscallno;
+	if (dir && unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_exit(regs, regs_return_value(regs));
+
+	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
+		if (is_compat_task()) {
+			/* AArch32 uses ip (r12) for scratch */
+			saved_reg = regs->regs[12];
+			regs->regs[12] = dir;
+		} else {
+			/*
+			 * Save X7. X7 is used to denote syscall entry/exit:
+			 *   X7 = 0 -> entry, = 1 -> exit
+			 */
+			saved_reg = regs->regs[7];
+			regs->regs[7] = dir;
+		}
 
-	if (is_compat_task()) {
-		/* AArch32 uses ip (r12) for scratch */
-		saved_reg = regs->regs[12];
-		regs->regs[12] = dir;
-	} else {
-		/*
-		 * Save X7. X7 is used to denote syscall entry/exit:
-		 *   X7 = 0 -> entry, = 1 -> exit
-		 */
-		saved_reg = regs->regs[7];
-		regs->regs[7] = dir;
-	}
+		if (dir)
+			tracehook_report_syscall_exit(regs, 0);
+		else if (tracehook_report_syscall_entry(regs))
+			regs->syscallno = ~0UL;
 
-	if (dir)
-		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
-		regs->syscallno = ~0UL;
+		if (is_compat_task())
+			regs->regs[12] = saved_reg;
+		else
+			regs->regs[7] = saved_reg;
+	}
 
-	if (is_compat_task())
-		regs->regs[12] = saved_reg;
-	else
-		regs->regs[7] = saved_reg;
+	if (!dir && unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
+		trace_sys_enter(regs, regs->syscallno);
 
 	return regs->syscallno;
 }
-- 
1.7.9.5

