Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaDOSsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbaDOShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:25 -0400
Date: Tue, 15 Apr 2014 20:36:56 +0200
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
Subject: [PATCH RESEND2 06/11] signals: mv {dis,}allow_signal() from
	sched.h/exit.c to signal.[ch]
Message-ID: <20140415183656.GA13416@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the declaration/definition of allow_signal/disallow_signal to
signal.h/signal.c. The new place is more logical and allows to use
the static helpers in signal.c (see the next changes).

While at it, make them return void and remove the valid_signal()
check. Nobody checks the returned value, and in-kernel users must
not pass the wrong signal number.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h  |    3 ---
 include/linux/signal.h |    2 ++
 kernel/exit.c          |   39 ---------------------------------------
 kernel/signal.c        |   29 +++++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a04214f..82fe3da 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2360,9 +2360,6 @@ extern void flush_itimer_signals(void);
 
 extern void do_group_exit(int);
 
-extern int allow_signal(int);
-extern int disallow_signal(int);
-
 extern int do_execve(struct filename *,
 		     const char __user * const __user *,
 		     const char __user * const __user *);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index ae744c3..ac83c59 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -284,6 +284,8 @@ extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
+extern void allow_signal(int);
+extern void disallow_signal(int);
 
 /*
  * Eventually that'll replace get_signal_to_deliver(); macro for now,
diff --git a/kernel/exit.c b/kernel/exit.c
index 6ed6a1d..ad7183a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -313,45 +313,6 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
 	}
 }
 
-/*
- * Let kernel threads use this to say that they allow a certain signal.
- * Must not be used if kthread was cloned with CLONE_SIGHAND.
- */
-int allow_signal(int sig)
-{
-	if (!valid_signal(sig) || sig < 1)
-		return -EINVAL;
-
-	spin_lock_irq(&current->sighand->siglock);
-	/* This is only needed for daemonize()'ed kthreads */
-	sigdelset(&current->blocked, sig);
-	/*
-	 * Kernel threads handle their own signals. Let the signal code
-	 * know it'll be handled, so that they don't get converted to
-	 * SIGKILL or just silently dropped.
-	 */
-	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-	return 0;
-}
-
-EXPORT_SYMBOL(allow_signal);
-
-int disallow_signal(int sig)
-{
-	if (!valid_signal(sig) || sig < 1)
-		return -EINVAL;
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
-	return 0;
-}
-
-EXPORT_SYMBOL(disallow_signal);
-
 #ifdef CONFIG_MM_OWNER
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
diff --git a/kernel/signal.c b/kernel/signal.c
index a58b0db..8a7ee44 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3065,6 +3065,35 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
 }
 #endif
 
+/*
+ * Let kernel threads use this to say that they allow a certain signal.
+ * Must not be used if kthread was cloned with CLONE_SIGHAND.
+ */
+void allow_signal(int sig)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	/* This is only needed for daemonize()'ed kthreads */
+	sigdelset(&current->blocked, sig);
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+EXPORT_SYMBOL(allow_signal);
+
+void disallow_signal(int sig)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+EXPORT_SYMBOL(disallow_signal);
+
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
 	struct task_struct *p = current, *t;
-- 
1.5.5.1

