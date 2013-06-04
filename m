Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3FDXUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:20:03 -0400
Received: from 1wt.eu ([62.212.114.60]:35313 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3FDWls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:48 -0400
Message-Id: <20130604172131.094632049@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 019/184] ptrace: introduce signal_wake_up_state() and
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 ptrace_signal_wake_up()

From: Oleg Nesterov <oleg@redhat.com>

ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()

CVE-2013-0871

BugLink: http://bugs.launchpad.net/bugs/1129192

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
(backported from commit 910ffdb18a6408e14febbb6e4b6840fd2c928c82)

Conflicts:
	kernel/ptrace.c
	kernel/signal.c

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Colin King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/linux/sched.h | 11 ++++++++++-
 kernel/ptrace.c       |  2 +-
 kernel/signal.c       | 12 +++---------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 71849bf..73c3b9b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2459,7 +2459,16 @@ static inline void thread_group_cputime_free(struct signal_struct *sig)
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
index d8184b5..37850f9 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -56,7 +56,7 @@ static void ptrace_untrace(struct task_struct *child)
 		    child->signal->group_stop_count)
 			__set_task_state(child, TASK_STOPPED);
 		else
-			signal_wake_up(child, 1);
+			ptrace_signal_wake_up(child, true);
 	}
 	spin_unlock(&child->sighand->siglock);
 }
diff --git a/kernel/signal.c b/kernel/signal.c
index df993fd..b40f4f0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -516,23 +516,17 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
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
 
-- 
1.7.12.2.21.g234cd45.dirty



