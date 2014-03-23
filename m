Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaCWTiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:38:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbaCWTiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:38:52 -0400
Date: Sun, 23 Mar 2014 20:37:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] signals: rename rm_from_queue_full() to
	flush_sigqueue_mask()
Message-ID: <20140323193753.GA10495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323193730.GA10464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"rm_from_queue_full" looks ugly and misleading, especially now that
rm_from_queue() has gone away. Rename it to flush_sigqueue_mask(),
this matches flush_sigqueue() we already have.

Also remove the obsolete comment which explains the difference with
rm_from_queue() we already killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 9fb20cb..d8d8b23 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -703,11 +703,8 @@ void signal_wake_up_state(struct task_struct *t, unsigned int state)
  * Returns 1 if any signals were found.
  *
  * All callers must be holding the siglock.
- *
- * This version takes a sigset mask and looks at all signals,
- * not just those in the first mask word.
  */
-static int rm_from_queue_full(sigset_t *mask, struct sigpending *s)
+static int flush_sigqueue_mask(sigset_t *mask, struct sigpending *s)
 {
 	struct sigqueue *q, *n;
 	sigset_t m;
@@ -849,18 +846,18 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 		 * This is a stop signal.  Remove SIGCONT from all queues.
 		 */
 		siginitset(&flush, sigmask(SIGCONT));
-		rm_from_queue_full(&flush, &signal->shared_pending);
+		flush_sigqueue_mask(&flush, &signal->shared_pending);
 		for_each_thread(p, t)
-			rm_from_queue_full(&flush, &t->pending);
+			flush_sigqueue_mask(&flush, &t->pending);
 	} else if (sig == SIGCONT) {
 		unsigned int why;
 		/*
 		 * Remove all stop signals from all queues, wake all threads.
 		 */
 		siginitset(&flush, SIG_KERNEL_STOP_MASK);
-		rm_from_queue_full(&flush, &signal->shared_pending);
+		flush_sigqueue_mask(&flush, &signal->shared_pending);
 		for_each_thread(p, t) {
-			rm_from_queue_full(&flush, &t->pending);
+			flush_sigqueue_mask(&flush, &t->pending);
 			task_clear_jobctl_pending(t, JOBCTL_STOP_PENDING);
 			if (likely(!(t->ptrace & PT_SEIZED)))
 				wake_up_state(t, __TASK_STOPPED);
@@ -3099,9 +3096,9 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
-			rm_from_queue_full(&mask, &t->signal->shared_pending);
+			flush_sigqueue_mask(&mask, &t->signal->shared_pending);
 			do {
-				rm_from_queue_full(&mask, &t->pending);
+				flush_sigqueue_mask(&mask, &t->pending);
 			} while_each_thread(current, t);
 		}
 	}
@@ -3110,7 +3107,7 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 	return 0;
 }
 
-static int 
+static int
 do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
 {
 	stack_t oss;
-- 
1.5.5.1

