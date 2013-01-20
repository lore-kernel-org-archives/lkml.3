Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3ATT0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 14:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab3ATT0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 14:26:30 -0500
Date: Sun, 20 Jan 2013 20:25:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@hack.frob.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] ia64: kill thread_matches(), unexport
	ptrace_check_attach()
Message-ID: <20130120192547.GD6771@redhat.com>
References: <20130116181830.GA6469@redhat.com> <CA+55aFzkWqSEzw9oa5JodrM2NWE0H_AF7xyzRhd+DQ=PB=ZT2A@mail.gmail.com> <20130118153700.GA27915@redhat.com> <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com> <20130118172854.GA29753@redhat.com> <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120192448.GA6771@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/ia64/kernel/ptrace.c:thread_matches() has no users since e868a55c
"[IA64] remove find_thread_for_addr()", remove it.

And this allows us to unexport ptrace_check_attach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/ia64/kernel/ptrace.c |   27 ---------------------------
 include/linux/ptrace.h    |    1 -
 kernel/ptrace.c           |    2 +-
 3 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index 4265ff6..b7a5fff 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -672,33 +672,6 @@ ptrace_attach_sync_user_rbs (struct task_struct *child)
 	read_unlock(&tasklist_lock);
 }
 
-static inline int
-thread_matches (struct task_struct *thread, unsigned long addr)
-{
-	unsigned long thread_rbs_end;
-	struct pt_regs *thread_regs;
-
-	if (ptrace_check_attach(thread, 0) < 0)
-		/*
-		 * If the thread is not in an attachable state, we'll
-		 * ignore it.  The net effect is that if ADDR happens
-		 * to overlap with the portion of the thread's
-		 * register backing store that is currently residing
-		 * on the thread's kernel stack, then ptrace() may end
-		 * up accessing a stale value.  But if the thread
-		 * isn't stopped, that's a problem anyhow, so we're
-		 * doing as well as we can...
-		 */
-		return 0;
-
-	thread_regs = task_pt_regs(thread);
-	thread_rbs_end = ia64_get_user_rbs_end(thread, thread_regs, NULL);
-	if (!on_kernel_rbs(addr, thread_regs->ar_bspstore, thread_rbs_end))
-		return 0;
-
-	return 1;	/* looks like we've got a winner */
-}
-
 /*
  * Write f32-f127 back to task->thread.fph if it has been modified.
  */
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 1693775..89573a3 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -45,7 +45,6 @@ extern long arch_ptrace(struct task_struct *child, long request,
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern void ptrace_disable(struct task_struct *);
-extern int ptrace_check_attach(struct task_struct *task, bool ignore_state);
 extern int ptrace_request(struct task_struct *child, long request,
 			  unsigned long addr, unsigned long data);
 extern void ptrace_notify(int exit_code);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 425ff24..6cfa950 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -174,7 +174,7 @@ static void ptrace_unfreeze_traced(struct task_struct *task)
  * RETURNS:
  * 0 on success, -ESRCH if %child is not ready.
  */
-int ptrace_check_attach(struct task_struct *child, bool ignore_state)
+static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 {
 	int ret = -ESRCH;
 
-- 
1.5.5.1


