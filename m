Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3BEWMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:12:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48238 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3BEWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 80/93] ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
Date: Tue,  5 Feb 2013 20:07:09 -0200
Message-Id: <1360102042-10732-81-git-send-email-herton.krzesinski@canonical.com>
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

commit 910ffdb18a6408e14febbb6e4b6840fd2c928c82 upstream.

Cleanup and preparation for the next change.

signal_wake_up(resume => true) is overused. None of ptrace/jctl callers
actually want to wakeup a TASK_WAKEKILL task, but they can't specify the
necessary mask.

Turn signal_wake_up() into signal_wake_up_state(state), reintroduce
signal_wake_up() as a trivial helper, and add ptrace_signal_wake_up()
which adds __TASK_TRACED.

This way ptrace_signal_wake_up() can work "inside" ptrace_request()
even if the tracee doesn't have the TASK_WAKEKILL bit set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/sched.h |   11 ++++++++++-
 kernel/ptrace.c       |    8 ++++----
 kernel/signal.c       |   14 ++++----------
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e63650f..3a9e314 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2674,7 +2674,16 @@ static inline void thread_group_cputime_init(struct signal_struct *sig)
 extern void recalc_sigpending_and_wake(struct task_struct *t);
 extern void recalc_sigpending(void);
 
-extern void signal_wake_up(struct task_struct *t, int resume_stopped);
+extern void signal_wake_up_state(struct task_struct *t, unsigned int state);
+
+static inline void signal_wake_up(struct task_struct *t, bool resume)
+{
+	signal_wake_up_state(t, resume ? TASK_WAKEKILL : 0);
+}
+static inline void ptrace_signal_wake_up(struct task_struct *t, bool resume)
+{
+	signal_wake_up_state(t, resume ? __TASK_TRACED : 0);
+}
 
 /*
  * Wrappers for p->thread_info->cpu access. No-op on UP.
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a232bb5..901df1e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -117,7 +117,7 @@ void __ptrace_unlink(struct task_struct *child)
 	 * TASK_KILLABLE sleeps.
 	 */
 	if (child->jobctl & JOBCTL_STOP_PENDING || task_is_traced(child))
-		signal_wake_up(child, task_is_traced(child));
+		ptrace_signal_wake_up(child, true);
 
 	spin_unlock(&child->sighand->siglock);
 }
@@ -310,7 +310,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	 */
 	if (task_is_stopped(task) &&
 	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING))
-		signal_wake_up(task, 1);
+		signal_wake_up_state(task, __TASK_STOPPED);
 
 	spin_unlock(&task->sighand->siglock);
 
@@ -727,7 +727,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * tracee into STOP.
 		 */
 		if (likely(task_set_jobctl_pending(child, JOBCTL_TRAP_STOP)))
-			signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
+			ptrace_signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
 
 		unlock_task_sighand(child, &flags);
 		ret = 0;
@@ -753,7 +753,7 @@ int ptrace_request(struct task_struct *child, long request,
 			 * start of this trap and now.  Trigger re-trap.
 			 */
 			if (child->jobctl & JOBCTL_TRAP_NOTIFY)
-				signal_wake_up(child, true);
+				ptrace_signal_wake_up(child, true);
 			ret = 0;
 		}
 		unlock_task_sighand(child, &flags);
diff --git a/kernel/signal.c b/kernel/signal.c
index e9d3270..47c8e05 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -678,23 +678,17 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
  * No need to set need_resched since signal event passing
  * goes through ->blocked
  */
-void signal_wake_up(struct task_struct *t, int resume)
+void signal_wake_up_state(struct task_struct *t, unsigned int state)
 {
-	unsigned int mask;
-
 	set_tsk_thread_flag(t, TIF_SIGPENDING);
-
 	/*
-	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
+	 * TASK_WAKEKILL also means wake it up in the stopped/traced/killable
 	 * case. We don't check t->state here because there is a race with it
 	 * executing another processor and just now entering stopped state.
 	 * By using wake_up_state, we ensure the process will wake up and
 	 * handle its death signal.
 	 */
-	mask = TASK_INTERRUPTIBLE;
-	if (resume)
-		mask |= TASK_WAKEKILL;
-	if (!wake_up_state(t, mask))
+	if (!wake_up_state(t, state | TASK_INTERRUPTIBLE))
 		kick_process(t);
 }
 
@@ -842,7 +836,7 @@ static void ptrace_trap_notify(struct task_struct *t)
 	assert_spin_locked(&t->sighand->siglock);
 
 	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
-	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
+	ptrace_signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
 }
 
 /*
-- 
1.7.9.5

