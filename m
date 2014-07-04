Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031554AbaGDW1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:27:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760795AbaGDWWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:22:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 52/59] ptrace,x86: force IRET path after a ptrace_stop()
Date: Fri,  4 Jul 2014 15:19:41 -0700
Message-Id: <20140704221542.023281594@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/ptrace.h |   16 ++++++++++++++++
 include/linux/ptrace.h        |    3 +++
 2 files changed, 19 insertions(+)

--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -231,6 +231,22 @@ static inline unsigned long regs_get_ker
 
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
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -334,6 +334,9 @@ static inline void user_single_step_sigi
  * calling arch_ptrace_stop() when it would be superfluous.  For example,
  * if the thread has not been back to user mode since the last stop, the
  * thread state might indicate that nothing needs to be done.
+ *
+ * This is guaranteed to be invoked once before a task stops for ptrace and
+ * may include arch-specific operations necessary prior to a ptrace stop.
  */
 #define arch_ptrace_stop_needed(code, info)	(0)
 #endif


