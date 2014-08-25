Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaHYQ5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:57:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59880 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbaHYQzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:55:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 12/13] ptrace,x86: force IRET path after a ptrace_stop()
Date: Mon, 25 Aug 2014 09:54:58 -0700
Message-Id: <1408985699-31838-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408985699-31838-1-git-send-email-kamal@canonical.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit b9cd18de4db3c9ffa7e17b0dc0ca99ed5aa4d43a upstream.

The 'sysret' fastpath does not correctly restore even all regular
registers, much less any segment registers or reflags values.  That is
very much part of why it's faster than 'iret'.

Normally that isn't a problem, because the normal ptrace() interface
catches the process using the signal handler infrastructure, which
always returns with an iret.

However, some paths can get caught using ptrace_event() instead of the
signal path, and for those we need to make sure that we aren't going to
return to user space using 'sysret'.  Otherwise the modifications that
may have been done to the register set by the tracer wouldn't
necessarily take effect.

Fix it by forcing IRET path by setting TIF_NOTIFY_RESUME from
arch_ptrace_stop_needed() which is invoked from ptrace_stop().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CVE-2014-4699
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/ptrace.h | 16 ++++++++++++++++
 include/linux/ptrace.h        |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 942a086..68e9f00 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -232,6 +232,22 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 
 #define ARCH_HAS_USER_SINGLE_STEP_INFO
 
+/*
+ * When hitting ptrace_stop(), we cannot return using SYSRET because
+ * that does not restore the full CPU state, only a minimal set.  The
+ * ptracer can change arbitrary register values, which is usually okay
+ * because the usual ptrace stops run off the signal delivery path which
+ * forces IRET; however, ptrace_event() stops happen in arbitrary places
+ * in the kernel and don't force IRET path.
+ *
+ * So force IRET path after a ptrace stop.
+ */
+#define arch_ptrace_stop_needed(code, info)				\
+({									\
+	set_thread_flag(TIF_NOTIFY_RESUME);				\
+	false;								\
+})
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 2e99b8e..bb980ae 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -337,6 +337,9 @@ static inline void user_single_step_siginfo(struct task_struct *tsk,
  * calling arch_ptrace_stop() when it would be superfluous.  For example,
  * if the thread has not been back to user mode since the last stop, the
  * thread state might indicate that nothing needs to be done.
+ *
+ * This is guaranteed to be invoked once before a task stops for ptrace and
+ * may include arch-specific operations necessary prior to a ptrace stop.
  */
 #define arch_ptrace_stop_needed(code, info)	(0)
 #endif
-- 
1.9.1

