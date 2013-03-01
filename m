Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3CATuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:50:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3CATqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, Suleiman Souhlal <suleiman@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>
Subject: [ 19/30] ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
Date: Fri,  1 Mar 2013 11:45:40 -0800
Message-Id: <20130301194530.049390845@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Oleg Nesterov <oleg@redhat.com>

Upstream commit 9899d11f654474d2d54ea52ceaa2a1f4db3abd68.

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
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/ptrace.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++---------
 kernel/signal.c |    5 ++++
 2 files changed, 55 insertions(+), 9 deletions(-)

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -38,6 +38,36 @@ void __ptrace_link(struct task_struct *c
 	child->parent = new_parent;
 }
 
+/* Ensure that nothing can wake it up, even SIGKILL */
+static bool ptrace_freeze_traced(struct task_struct *task)
+{
+	bool ret = false;
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
  * __ptrace_unlink - unlink ptracee and restore its execution state
  * @child: ptracee to be unlinked
@@ -112,23 +142,29 @@ int ptrace_check_attach(struct task_stru
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
-		if (task_is_traced(child) || kill)
+		if (kill || ptrace_freeze_traced(child))
 			ret = 0;
-		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
 
-	if (!ret && !kill)
-		ret = wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
+	if (!ret && !kill) {
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
 
@@ -777,6 +813,8 @@ SYSCALL_DEFINE4(ptrace, long, request, l
 		goto out_put_task_struct;
 
 	ret = arch_ptrace(child, request, addr, data);
+	if (ret || request != PTRACE_DETACH)
+		ptrace_unfreeze_traced(child);
 
  out_put_task_struct:
 	put_task_struct(child);
@@ -915,8 +953,11 @@ asmlinkage long compat_sys_ptrace(compat
 	}
 
 	ret = ptrace_check_attach(child, request == PTRACE_KILL);
-	if (!ret)
+	if (!ret) {
 		ret = compat_arch_ptrace(child, request, addr, data);
+		if (ret || request != PTRACE_DETACH)
+			ptrace_unfreeze_traced(child);
+	}
 
  out_put_task_struct:
 	put_task_struct(child);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1669,6 +1669,10 @@ static inline int may_ptrace_stop(void)
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
@@ -1800,6 +1804,7 @@ static void ptrace_stop(int exit_code, i
 		if (gstop_done)
 			do_notify_parent_cldstop(current, false, why);
 
+		/* tasklist protects us from ptrace_freeze_traced() */
 		__set_current_state(TASK_RUNNING);
 		if (clear_code)
 			current->exit_code = 0;


