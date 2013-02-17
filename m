Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3BQTUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3BQTUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:20:32 -0500
Date: Sun, 17 Feb 2013 20:18:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] coredump: only SIGKILL should interrupt the
	coredumping task
Message-ID: <20130217191849.GA21806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217191819.GA21778@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 2 well known and ancient problems with coredump/signals,
and a lot of related bug reports:

- do_coredump() clears TIF_SIGPENDING but of course this can't help
  if, say, SIGCHLD comes after that.

  In this case the coredump can fail unexpectedly. See for example
  wait_for_dump_helper()->signal_pending() check but there are other
  reasons.

- At the same time, dumping a huge core on the slow media can take a
  lot of time/resources and there is no way to kill the coredumping
  task reliably. In particular this is not oom_kill-friendly.

This patch tries to fix the 1st problem, and makes the preparation
for the next changes.

We add the new SIGNAL_GROUP_COREDUMP flag set by zap_threads() to
indicate that this process dumps the core. prepare_signal() checks
this flag and nacks any signal except SIGKILL.

Note that this check tries to be conservative, in the long term we
should probably treat the SIGNAL_GROUP_EXIT case equally but this
needs more discussion. See marc.info/?l=linux-kernel&m=120508897917439

Notes:
	- recalc_sigpending() doesn't check SIGNAL_GROUP_COREDUMP.
	  The patch assumes that dump_write/etc paths should never
	  call it, but we can change it as well.

	- There is another source of TIF_SIGPENDING, freezer. This
	  will be addressed separately.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c         |   13 +++++--------
 include/linux/sched.h |    1 +
 kernel/signal.c       |    6 ++++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1774932..2c1ef6a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -280,8 +280,8 @@ static int zap_process(struct task_struct *start, int exit_code)
 	return nr;
 }
 
-static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
-				struct core_state *core_state, int exit_code)
+static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
+			struct core_state *core_state, int exit_code)
 {
 	struct task_struct *g, *p;
 	unsigned long flags;
@@ -291,6 +291,9 @@ static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		nr = zap_process(tsk, exit_code);
+		/* ignore all signals except SIGKILL, see prepare_signal() */
+		tsk->signal->flags |= SIGNAL_GROUP_COREDUMP;
+		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 	if (unlikely(nr < 0))
@@ -514,12 +517,6 @@ void do_coredump(siginfo_t *siginfo)
 
 	old_cred = override_creds(cred);
 
-	/*
-	 * Clear any false indication of pending signals that might
-	 * be seen by the filesystem code called to write the core file.
-	 */
-	clear_thread_flag(TIF_SIGPENDING);
-
 	ispipe = format_corename(&cn, &cprm);
 
  	if (ispipe) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..932a90c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -672,6 +672,7 @@ struct signal_struct {
 #define SIGNAL_STOP_STOPPED	0x00000001 /* job control stop in effect */
 #define SIGNAL_STOP_CONTINUED	0x00000002 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000004 /* group exit in progress */
+#define SIGNAL_GROUP_COREDUMP	0x00000008 /* coredump in progress */
 /*
  * Pending notifications to parent.
  */
diff --git a/kernel/signal.c b/kernel/signal.c
index 3d09cf6..ebae2e0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -851,12 +851,14 @@ static void ptrace_trap_notify(struct task_struct *t)
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p, bool force)
+static bool prepare_signal(int sig, struct task_struct *p, bool force)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
+	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
+		if (signal->flags & SIGNAL_GROUP_COREDUMP)
+			return sig == SIGKILL;
 		/*
 		 * The process is in the middle of dying, nothing to do.
 		 */
-- 
1.5.5.1

