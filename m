Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaGDHa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:30:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48206 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaGDHaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:30:19 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v10 3/3] arm64: audit: Add audit hook in syscall_trace_enter/exit()
Date: Fri,  4 Jul 2014 16:28:31 +0900
Message-Id: <1404458911-8214-4-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
References: <1404458911-8214-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds auditing functions on entry to or exit from
every system call invocation.

Acked-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by Will Deacon <will.deacon@arm.com>

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/kernel/ptrace.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 9fde010..70526cf 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -19,6 +19,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/audit.h>
 #include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -39,6 +40,7 @@
 #include <asm/compat.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
+#include <asm/syscall.h>
 #include <asm/traps.h>
 #include <asm/system_misc.h>
 
@@ -1113,11 +1115,16 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_enter(regs, regs->syscallno);
 
+	audit_syscall_entry(syscall_get_arch(), regs->syscallno,
+		regs->orig_x0, regs->regs[1], regs->regs[2], regs->regs[3]);
+
 	return regs->syscallno;
 }
 
 asmlinkage void syscall_trace_exit(struct pt_regs *regs)
 {
+	audit_syscall_exit(regs);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
 		trace_sys_exit(regs, regs_return_value(regs));
 
-- 
1.7.9.5

