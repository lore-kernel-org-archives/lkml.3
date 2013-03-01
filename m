Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3CATuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:50:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3CATqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: [ 18/30] ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
Date: Fri,  1 Mar 2013 11:45:39 -0800
Message-Id: <20130301194529.950634145@linuxfoundation.org>
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

Upstream commit 910ffdb18a6408e14febbb6e4b6840fd2c928c82.

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
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/sched.h |   11 ++++++++++-
 kernel/ptrace.c       |    4 ++--
 kernel/signal.c       |   12 +++---------
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2564,7 +2564,16 @@ static inline void thread_group_cputime_
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
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -92,7 +92,7 @@ void __ptrace_unlink(struct task_struct
 	 * TASK_KILLABLE sleeps.
 	 */
 	if (child->group_stop & GROUP_STOP_PENDING || task_is_traced(child))
-		signal_wake_up(child, task_is_traced(child));
+		ptrace_signal_wake_up(child, true);
 
 	spin_unlock(&child->sighand->siglock);
 }
@@ -245,7 +245,7 @@ static int ptrace_attach(struct task_str
 	 */
 	if (task_is_stopped(task)) {
 		task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
-		signal_wake_up(task, 1);
+		signal_wake_up_state(task, __TASK_STOPPED);
 		wait_trap = true;
 	}
 
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -631,23 +631,17 @@ int dequeue_signal(struct task_struct *t
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
 


