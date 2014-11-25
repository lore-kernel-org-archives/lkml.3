Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaKYKpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:45:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaKYKny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 251/254] x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit
Date: Tue, 25 Nov 2014 10:40:01 +0000
Message-Id: <1416912004-5928-252-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 81f49a8fd7088cfcb588d182eeede862c0e3303e upstream.

is_compat_task() is the wrong check for audit arch; the check should
be is_ia32_task(): x32 syscalls should be AUDIT_ARCH_X86_64, not
AUDIT_ARCH_I386.

CONFIG_AUDITSYSCALL is currently incompatible with x32, so this has
no visible effect.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/a0138ed8c709882aec06e4acc30bfa9b623b8717.1409954077.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/ptrace.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 678c0ada3b3c..b1a5dfa24789 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1441,15 +1441,6 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 	force_sig_info(SIGTRAP, &info, tsk);
 }
 
-
-#ifdef CONFIG_X86_32
-# define IS_IA32	1
-#elif defined CONFIG_IA32_EMULATION
-# define IS_IA32	is_compat_task()
-#else
-# define IS_IA32	0
-#endif
-
 /*
  * We must return the syscall number to actually look up in the table.
  * This can be -1L to skip running any syscall at all.
@@ -1487,7 +1478,7 @@ long syscall_trace_enter(struct pt_regs *regs)
 	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
 		trace_sys_enter(regs, regs->orig_ax);
 
-	if (IS_IA32)
+	if (is_ia32_task())
 		audit_syscall_entry(AUDIT_ARCH_I386,
 				    regs->orig_ax,
 				    regs->bx, regs->cx,
-- 
2.1.0

