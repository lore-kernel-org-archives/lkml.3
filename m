Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaDOShR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:37:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbaDOShN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:13 -0400
Date: Tue, 15 Apr 2014 20:36:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND2 03/11] signals: kill rm_from_queue(), change
	prepare_signal() to use for_each_thread()
Message-ID: <20140415183645.GA13399@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rm_from_queue() doesn't make sense. The only caller, prepare_signal(),
can use rm_from_queue_full() with the same effect.

While at it, change prepare_signal() to use for_each_thread() instead
of do/while_each_thread.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   43 ++++++++++---------------------------------
 1 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index a717749..6072efa 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -727,29 +727,6 @@ static int rm_from_queue_full(sigset_t *mask, struct sigpending *s)
 	}
 	return 1;
 }
-/*
- * Remove signals in mask from the pending set and queue.
- * Returns 1 if any signals were found.
- *
- * All callers must be holding the siglock.
- */
-static int rm_from_queue(unsigned long mask, struct sigpending *s)
-{
-	struct sigqueue *q, *n;
-
-	if (!sigtestsetmask(&s->signal, mask))
-		return 0;
-
-	sigdelsetmask(&s->signal, mask);
-	list_for_each_entry_safe(q, n, &s->list, list) {
-		if (q->info.si_signo < SIGRTMIN &&
-		    (mask & sigmask(q->info.si_signo))) {
-			list_del_init(&q->list);
-			__sigqueue_free(q);
-		}
-	}
-	return 1;
-}
 
 static inline int is_si_special(const struct siginfo *info)
 {
@@ -861,6 +838,7 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
+	sigset_t flush;
 
 	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
 		if (signal->flags & SIGNAL_GROUP_COREDUMP)
@@ -872,26 +850,25 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
-		rm_from_queue(sigmask(SIGCONT), &signal->shared_pending);
-		t = p;
-		do {
-			rm_from_queue(sigmask(SIGCONT), &t->pending);
-		} while_each_thread(p, t);
+		siginitset(&flush, sigmask(SIGCONT));
+		rm_from_queue_full(&flush, &signal->shared_pending);
+		for_each_thread(p, t)
+			rm_from_queue_full(&flush, &t->pending);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues, wake all threads.
 		 */
-		rm_from_queue(SIG_KERNEL_STOP_MASK, &signal->shared_pending);
-		t = p;
-		do {
+		siginitset(&flush, SIG_KERNEL_STOP_MASK);
+		rm_from_queue_full(&flush, &signal->shared_pending);
+		for_each_thread(p, t) {
+			rm_from_queue_full(&flush, &t->pending);
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
-			rm_from_queue(SIG_KERNEL_STOP_MASK, &t->pending);
 			if (likely(!(t->ptrace & PT_SEIZED)))
 				wake_up_state(t, __TASK_STOPPED);
 			else
 				ptrace_trap_notify(t);
-		} while_each_thread(p, t);
+		}
 
 		/*
 		 * Notify the parent with CLD_CONTINUED if we were stopped.
-- 
1.5.5.1

