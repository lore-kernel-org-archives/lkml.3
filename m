Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3DNQIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:08:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3DNQIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:08:36 -0400
Date: Sun, 14 Apr 2013 18:05:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ptrace: Revert "Prepare to fix racy accesses on task
	breakpoints"
Message-ID: <20130414160541.GA7660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160501.GA7612@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit bf26c018490c2fce7fe9b629083b96ce0e6ad019.

The patch was fine but we can no longer race with SIGKILL after
9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
with SIGKILL", the __TASK_TRACED tracee can't be woken up and
->ptrace_bps[] can't go away.

Now that ptrace_get_breakpoints/ptrace_put_breakpoints have no
callers, we can kill them and remove task->ptrace_bp_refcnt.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h |   10 ----------
 include/linux/sched.h  |    3 ---
 kernel/exit.c          |    2 +-
 kernel/ptrace.c        |   16 ----------------
 4 files changed, 1 insertions(+), 30 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 89573a3..07d0df6 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -142,9 +142,6 @@ static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_set(&child->ptrace_bp_refcnt, 1);
-#endif
 	child->jobctl = 0;
 	child->ptrace = 0;
 	child->parent = child->real_parent;
@@ -351,11 +348,4 @@ extern int task_current_syscall(struct task_struct *target, long *callno,
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-extern int ptrace_get_breakpoints(struct task_struct *tsk);
-extern void ptrace_put_breakpoints(struct task_struct *tsk);
-#else
-static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
-
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..89dc3e4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1570,9 +1570,6 @@ struct task_struct {
 	} memcg_batch;
 	unsigned int memcg_kmem_skip_account;
 #endif
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_t ptrace_bp_refcnt;
-#endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index 60bc027..0a66f6d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -819,7 +819,7 @@ void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	ptrace_put_breakpoints(tsk);
+	flush_ptrace_hw_breakpoint(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index acbd284..776ab3b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1098,19 +1098,3 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 	return ret;
 }
 #endif	/* CONFIG_COMPAT */
-
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-int ptrace_get_breakpoints(struct task_struct *tsk)
-{
-	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
-		return 0;
-
-	return -1;
-}
-
-void ptrace_put_breakpoints(struct task_struct *tsk)
-{
-	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
-		flush_ptrace_hw_breakpoint(tsk);
-}
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
-- 
1.5.5.1

