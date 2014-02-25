Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaBYJT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:19:59 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65478 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaBYJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:19:55 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 3/3] arm64: audit: Add audit hook in ptrace/syscall_trace
Date: Tue, 25 Feb 2014 18:18:54 +0900
Message-Id: <1393319934-2810-4-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391767803-5350-1-git-send-email-takahiro.akashi@linaro.org>
 <1393319934-2810-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds auditing functions on entry to or exit from
every system call invocation.

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
---
 arch/arm64/kernel/ptrace.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index c70133e..d4ce70e 100644
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
 
@@ -1062,6 +1064,9 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 {
 	unsigned long saved_reg;
 
+	if (dir && test_thread_flag(TIF_SYSCALL_AUDIT))
+		audit_syscall_exit(regs);
+
 	if (test_thread_flag(TIF_SYSCALL_TRACE)) {
 		if (is_compat_task()) {
 			/* AArch32 uses ip (r12) for scratch */
@@ -1087,5 +1092,11 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
 			regs->regs[7] = saved_reg;
 	}
 
+	if (!dir && test_thread_flag(TIF_SYSCALL_AUDIT))
+		audit_syscall_entry(syscall_get_arch(current, regs),
+			(int)regs->syscallno,
+			regs->orig_x0, regs->regs[1],
+			regs->regs[2], regs->regs[3]);
+
 	return regs->syscallno;
 }
-- 
1.7.9.5

