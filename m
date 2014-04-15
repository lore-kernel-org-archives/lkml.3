Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbaDOShn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:37:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbaDOShi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:37:38 -0400
Date: Tue, 15 Apr 2014 20:37:13 +0200
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
Subject: [PATCH RESEND2 10/11] signals: introduce kernel_sigaction()
Message-ID: <20140415183713.GA13436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415183625.GA13371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that allow_signal() is really trivial we can unify it with
disallow_signal(). Add the new helper, kernel_sigaction(), and
reimplement allow_signal/disallow_signal as a trivial wrappers.

This saves one EXPORT_SYMBOL() and the new helper can have more
users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/signal.h |   18 ++++++++++++++++--
 kernel/signal.c        |   36 ++++++++++++------------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index ac83c59..c9e6536 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -284,8 +284,22 @@ extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
-extern void allow_signal(int);
-extern void disallow_signal(int);
+extern void kernel_sigaction(int, __sighandler_t);
+
+static inline void allow_signal(int sig)
+{
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	kernel_sigaction(sig, (__force __sighandler_t)2);
+}
+
+static inline void disallow_signal(int sig)
+{
+	kernel_sigaction(sig, SIG_IGN);
+}
 
 /*
  * Eventually that'll replace get_signal_to_deliver(); macro for now,
diff --git a/kernel/signal.c b/kernel/signal.c
index 4bab1b7..45dba61 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3066,37 +3066,25 @@ COMPAT_SYSCALL_DEFINE4(rt_tgsigqueueinfo,
 #endif
 
 /*
- * Let kernel threads use this to say that they allow a certain signal.
- * Must not be used if kthread was cloned with CLONE_SIGHAND.
+ * For kthreads only, must not be used if cloned with CLONE_SIGHAND
  */
-void allow_signal(int sig)
+void kernel_sigaction(int sig, __sighandler_t action)
 {
-	/*
-	 * Kernel threads handle their own signals. Let the signal code
-	 * know it'll be handled, so that they don't get converted to
-	 * SIGKILL or just silently dropped.
-	 */
 	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	spin_unlock_irq(&current->sighand->siglock);
-}
-EXPORT_SYMBOL(allow_signal);
+	current->sighand->action[sig - 1].sa.sa_handler = action;
+	if (action == SIG_IGN) {
+		sigset_t mask;
 
-void disallow_signal(int sig)
-{
-	sigset_t mask;
+		sigemptyset(&mask);
+		sigaddset(&mask, sig);
 
-	sigemptyset(&mask);
-	sigaddset(&mask, sig);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[(sig)-1].sa.sa_handler = SIG_IGN;
-	flush_sigqueue_mask(&mask, &current->signal->shared_pending);
-	flush_sigqueue_mask(&mask, &current->pending);
-	recalc_sigpending();
+		flush_sigqueue_mask(&mask, &current->signal->shared_pending);
+		flush_sigqueue_mask(&mask, &current->pending);
+		recalc_sigpending();
+	}
 	spin_unlock_irq(&current->sighand->siglock);
 }
-EXPORT_SYMBOL(disallow_signal);
+EXPORT_SYMBOL(kernel_sigaction);
 
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
-- 
1.5.5.1

