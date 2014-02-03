Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBCG5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:57:24 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47598 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaBCG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:57:20 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, patches@linaro.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 3/3] arm64: audit: Add audit hook in ptrace/syscall_trace
Date: Mon,  3 Feb 2014 15:56:30 +0900
Message-Id: <1391410590-4884-4-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1391410590-4884-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds auditing functions on entry to or exit from
every system call invocation.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/include/asm/thread_info.h |    1 +
 arch/arm64/kernel/entry.S            |    3 +++
 arch/arm64/kernel/ptrace.c           |   10 ++++++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 720e70b..7468388 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -101,6 +101,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
+#define TIF_SYSCALL_AUDIT	9
 #define TIF_POLLING_NRFLAG	16
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 827cbad..83c4b29 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -630,6 +630,9 @@ el0_svc_naked:					// compat entry point
 	get_thread_info tsk
 	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
 	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
+#ifdef CONFIG_AUDITSYSCALL
+	tbnz	x16, #TIF_SYSCALL_AUDIT, __sys_trace // auditing syscalls?
+#endif
 	adr	lr, ret_fast_syscall		// return address
 	cmp     scno, sc_nr                     // check upper syscall limit
 	b.hs	ni_sys
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6777a21..75a3f23 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -19,6 +19,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/audit.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
@@ -38,6 +39,7 @@
 #include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
+#include <asm/syscall.h>
 #include <asm/traps.h>
 #include <asm/system_misc.h>
 
@@ -1064,6 +1066,14 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 {
 	unsigned long saved_reg;
 
+	if (dir)
+		audit_syscall_exit(regs);
+	else
+		audit_syscall_entry(syscall_get_arch(current, regs),
+			(int)regs->syscallno,
+			regs->orig_x0, regs->regs[1],
+			regs->regs[2], regs->regs[3]);
+
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))
 		return regs->syscallno;
 
-- 
1.7.9.5

