Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3AUTs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:48:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab3AUTs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:48:26 -0500
Date: Mon, 21 Jan 2013 20:47:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Roland McGrath <roland@hack.frob.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 1/3] ptrace: introduce signal_wake_up_state() and
	ptrace_signal_wake_up()
Message-ID: <20130121194741.GB18775@redhat.com>
References: <20130118175224.GA520@redhat.com> <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com> <20130118185559.GA3773@redhat.com> <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com> <20130120192448.GA6771@redhat.com> <20130120192527.GC6771@redhat.com> <CA+55aFx1+hFSCa4nX80C30BkEOugXRvBZ=7LA+u+KOq_qSaJsg@mail.gmail.com> <20130121172151.GA4691@redhat.com> <CA+55aFwRkvEP5YJy+a=TFgDX==YuU7CJ+D_U+B2s4e1LX-nz3g@mail.gmail.com> <20130121194723.GA18775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130121194723.GA18775@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 include/linux/sched.h |   11 ++++++++++-
 kernel/ptrace.c       |    8 ++++----
 kernel/signal.c       |   14 ++++----------
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..48b4151 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2713,7 +2713,16 @@ static inline void thread_group_cputime_init(struct signal_struct *sig)
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
index 612a561..62f7c27 100644
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
@@ -317,7 +317,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	 */
 	if (task_is_stopped(task) &&
 	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING))
-		signal_wake_up(task, 1);
+		signal_wake_up_state(task, __TASK_STOPPED);
 
 	spin_unlock(&task->sighand->siglock);
 
@@ -737,7 +737,7 @@ int ptrace_request(struct task_struct *child, long request,
 		 * tracee into STOP.
 		 */
 		if (likely(task_set_jobctl_pending(child, JOBCTL_TRAP_STOP)))
-			signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
+			ptrace_signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
 
 		unlock_task_sighand(child, &flags);
 		ret = 0;
@@ -763,7 +763,7 @@ int ptrace_request(struct task_struct *child, long request,
 			 * start of this trap and now.  Trigger re-trap.
 			 */
 			if (child->jobctl & JOBCTL_TRAP_NOTIFY)
-				signal_wake_up(child, true);
+				ptrace_signal_wake_up(child, true);
 			ret = 0;
 		}
 		unlock_task_sighand(child, &flags);
diff --git a/kernel/signal.c b/kernel/signal.c
index 372771e..2bf2731 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -680,23 +680,17 @@ int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
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
 
@@ -844,7 +838,7 @@ static void ptrace_trap_notify(struct task_struct *t)
 	assert_spin_locked(&t->sighand->siglock);
 
 	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
-	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
+	ptrace_signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
 }
 
 /*
-- 
1.5.5.1


