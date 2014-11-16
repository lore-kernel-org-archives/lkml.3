Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaKPWAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:00:44 -0500
Received: from 1wt.eu ([62.212.114.60]:47895 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbaKPWAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:42 -0500
Message-Id: <20141116215329.185574412@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 13/48] ptrace,x86: force IRET path after a ptrace_stop()
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit b9cd18de4db3c9ffa7e17b0dc0ca99ed5aa4d43a ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[wt: fixes CVE-2014-4699]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/ptrace.h | 16 ++++++++++++++++
 include/linux/ptrace.h        |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 1ec926d..a2f3597 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -227,6 +227,22 @@ extern void user_enable_block_step(struct task_struct *);
 #define arch_has_block_step()	(boot_cpu_data.x86 >= 6)
 #endif
 
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
+#define arch_ptrace_stop_needed(code, info)                            \
+({                                                                     \
+       set_thread_flag(TIF_NOTIFY_RESUME);                             \
+       false;                                                          \
+})
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 7456d7d..486d27f 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -292,6 +292,9 @@ static inline void user_enable_block_step(struct task_struct *task)
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
1.7.12.2.21.g234cd45.dirty



