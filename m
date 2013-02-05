Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3BEWQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:16:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab3BEWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 81/93] ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
Date: Tue,  5 Feb 2013 20:07:10 -0200
Message-Id: <1360102042-10732-82-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 9899d11f654474d2d54ea52ceaa2a1f4db3abd68 upstream.

putreg() assumes that the tracee is not running and pt_regs_access() can
safely play with its stack.  However a killed tracee can return from
ptrace_stop() to the low-level asm code and do RESTORE_REST, this means
that debugger can actually read/modify the kernel stack until the tracee
does SAVE_REST again.

set_task_blockstep() can race with SIGKILL too and in some sense this
race is even worse, the very fact the tracee can be woken up breaks the
logic.

As Linus suggested we can clear TASK_WAKEKILL around the arch_ptrace()
call, this ensures that nobody can ever wakeup the tracee while the
debugger looks at it.  Not only this fixes the mentioned problems, we
can do some cleanups/simplifications in arch_ptrace() paths.

Probably ptrace_unfreeze_traced() needs more callers, for example it
makes sense to make the tracee killable for oom-killer before
access_process_vm().

While at it, add the comment into may_ptrace_stop() to explain why
ptrace_stop() still can't rely on SIGKILL and signal_pending_state().

Reported-by: Salman Qazi <sqazi@google.com>
Reported-by: Suleiman Souhlal <suleiman@google.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ herton: drop comment change to set_task_blockstep, the function
  doesn't exist on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/ptrace.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++---------
 kernel/signal.c |    5 +++++
 2 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 901df1e..b96de86b4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -122,6 +122,40 @@ void __ptrace_unlink(struct task_struct *child)
 	spin_unlock(&child->sighand->siglock);
 }
 
+/* Ensure that nothing can wake it up, even SIGKILL */
+static bool ptrace_freeze_traced(struct task_struct *task)
+{
+	bool ret = false;
+
+	/* Lockless, nobody but us can set this flag */
+	if (task->jobctl & JOBCTL_LISTENING)
+		return ret;
+
+	spin_lock_irq(&task->sighand->siglock);
+	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
+		task->state = __TASK_TRACED;
+		ret = true;
+	}
+	spin_unlock_irq(&task->sighand->siglock);
+
+	return ret;
+}
+
+static void ptrace_unfreeze_traced(struct task_struct *task)
+{
+	if (task->state != __TASK_TRACED)
+		return;
+
+	WARN_ON(!task->ptrace || task->parent != current);
+
+	spin_lock_irq(&task->sighand->siglock);
+	if (__fatal_signal_pending(task))
+		wake_up_state(task, __TASK_TRACED);
+	else
+		task->state = TASK_TRACED;
+	spin_unlock_irq(&task->sighand->siglock);
+}
+
 /**
  * ptrace_check_attach - check whether ptracee is ready for ptrace operation
  * @child: ptracee to check for
@@ -151,24 +185,29 @@ int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent == current) {
+	if (child->ptrace && child->parent == current) {
+		WARN_ON(child->state == __TASK_TRACED);
 		/*
 		 * child->sighand can't be NULL, release_task()
 		 * does ptrace_unlink() before __exit_signal().
 		 */
-		spin_lock_irq(&child->sighand->siglock);
-		WARN_ON_ONCE(task_is_stopped(child));
-		if (ignore_state || (task_is_traced(child) &&
-				     !(child->jobctl & JOBCTL_LISTENING)))
+		if (ignore_state || ptrace_freeze_traced(child))
 			ret = 0;
-		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
 
-	if (!ret && !ignore_state)
-		ret = wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
+	if (!ret && !ignore_state) {
+		if (!wait_task_inactive(child, __TASK_TRACED)) {
+			/*
+			 * This can only happen if may_ptrace_stop() fails and
+			 * ptrace_stop() changes ->state back to TASK_RUNNING,
+			 * so we should not worry about leaking __TASK_TRACED.
+			 */
+			WARN_ON(child->state == __TASK_TRACED);
+			ret = -ESRCH;
+		}
+	}
 
-	/* All systems go.. */
 	return ret;
 }
 
@@ -890,6 +929,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 		goto out_put_task_struct;
 
 	ret = arch_ptrace(child, request, addr, data);
+	if (ret || request != PTRACE_DETACH)
+		ptrace_unfreeze_traced(child);
 
  out_put_task_struct:
 	put_task_struct(child);
@@ -1029,8 +1070,11 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 
 	ret = ptrace_check_attach(child, request == PTRACE_KILL ||
 				  request == PTRACE_INTERRUPT);
-	if (!ret)
+	if (!ret) {
 		ret = compat_arch_ptrace(child, request, addr, data);
+		if (ret || request != PTRACE_DETACH)
+			ptrace_unfreeze_traced(child);
+	}
 
  out_put_task_struct:
 	put_task_struct(child);
diff --git a/kernel/signal.c b/kernel/signal.c
index 47c8e05..97116c9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1791,6 +1791,10 @@ static inline int may_ptrace_stop(void)
 	 * If SIGKILL was already sent before the caller unlocked
 	 * ->siglock we must see ->core_state != NULL. Otherwise it
 	 * is safe to enter schedule().
+	 *
+	 * This is almost outdated, a task with the pending SIGKILL can't
+	 * block in TASK_TRACED. But PTRACE_EVENT_EXIT can be reported
+	 * after SIGKILL was already dequeued.
 	 */
 	if (unlikely(current->mm->core_state) &&
 	    unlikely(current->mm == current->parent->mm))
@@ -1916,6 +1920,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		if (gstop_done)
 			do_notify_parent_cldstop(current, false, why);
 
+		/* tasklist protects us from ptrace_freeze_traced() */
 		__set_current_state(TASK_RUNNING);
 		if (clear_code)
 			current->exit_code = 0;
-- 
1.7.9.5

