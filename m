Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaD3J6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:58:45 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:58089 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaD3J6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:58:43 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, rgb@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v9 2/2] arm64: audit: Add audit hook in syscall_trace_enter/exit()
Date: Wed, 30 Apr 2014 18:57:23 +0900
Message-Id: <1398851843-16435-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851843-16435-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394862548-29060-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851843-16435-1-git-send-email-takahiro.akashi@linaro.org>
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
index 0bf1955..0568dc9 100644
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
 
@@ -1097,11 +1099,16 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
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

