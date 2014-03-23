Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaCWTiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaCWTiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:38:52 -0400
Date: Sun, 23 Mar 2014 20:37:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] signals: cleanup the usage of t/current in
	do_sigaction()
Message-ID: <20140323193756.GA10498@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323193730.GA10464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of "task_struct *t" and "current" in do_sigaction() looks
really annoying and chaotic. Initially "t" is used as a cached value
of current but not consistently, then it is reused as a loop variable
and we have to use "current" again.

Cleanup this mess and also convert the code to use for_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d8d8b23..37b2858 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3065,16 +3065,16 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
 
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
-	struct task_struct *t = current;
+	struct task_struct *p = current, *t;
 	struct k_sigaction *k;
 	sigset_t mask;
 
 	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
-	k = &t->sighand->action[sig-1];
+	k = &p->sighand->action[sig-1];
 
-	spin_lock_irq(&current->sighand->siglock);
+	spin_lock_irq(&p->sighand->siglock);
 	if (oact)
 		*oact = *k;
 
@@ -3093,17 +3093,16 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
+		if (sig_handler_ignored(sig_handler(p, sig), sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
-			flush_sigqueue_mask(&mask, &t->signal->shared_pending);
-			do {
+			flush_sigqueue_mask(&mask, &p->signal->shared_pending);
+			for_each_thread(p, t)
 				flush_sigqueue_mask(&mask, &t->pending);
-			} while_each_thread(current, t);
 		}
 	}
 
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&p->sighand->siglock);
 	return 0;
 }
 
-- 
1.5.5.1

