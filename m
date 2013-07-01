Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3GAQj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3GAQj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:39:26 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH] Define WTERMSIG{,_MASK} and WCOREDUMP and use where appropriate
Date: Mon,  1 Jul 2013 18:39:15 +0200
Message-Id: <1372696755-17427-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grepping for numeric constants is inconvenient.

No code changes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 include/linux/wait.h |  4 ++++
 kernel/exit.c        | 14 +++++++-------
 kernel/signal.c      |  6 +++---
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index f487a47..0e04586 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -8,6 +8,10 @@
 #include <asm/current.h>
 #include <uapi/linux/wait.h>
 
+#define WTERMSIG_MASK     0x7f
+#define WTERMSIG(status)  ((status) & WTERMSIG_MASK)
+#define WCOREDUMP(status) ((status) & 0x80)
+
 typedef struct __wait_queue wait_queue_t;
 typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
diff --git a/kernel/exit.c b/kernel/exit.c
index a949819..41effa0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -899,7 +899,7 @@ do_group_exit(int exit_code)
 {
 	struct signal_struct *sig = current->signal;
 
-	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
+	BUG_ON(WCOREDUMP(exit_code)); /* core dumps don't get here */
 
 	if (signal_group_exit(sig))
 		exit_code = sig->group_exit_code;
@@ -1027,12 +1027,12 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
-		if ((exit_code & 0x7f) == 0) {
+		if (!WTERMSIG(exit_code)) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
 		} else {
-			why = (exit_code & 0x80) ? CLD_DUMPED : CLD_KILLED;
-			status = exit_code & 0x7f;
+			why = WCOREDUMP(exit_code) ? CLD_DUMPED : CLD_KILLED;
+			status = WTERMSIG(exit_code);
 		}
 		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
@@ -1127,12 +1127,12 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	if (!retval && infop) {
 		int why;
 
-		if ((status & 0x7f) == 0) {
+		if ((status & WTERMSIG_MASK) == 0) {
 			why = CLD_EXITED;
 			status >>= 8;
 		} else {
-			why = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
-			status &= 0x7f;
+			why = WCOREDUMP(status) ? CLD_DUMPED : CLD_KILLED;
+			status &= WTERMSIG_MASK;
 		}
 		retval = put_user((short)why, &infop->si_code);
 		if (!retval)
diff --git a/kernel/signal.c b/kernel/signal.c
index 50e4107..2ad0e7d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1679,10 +1679,10 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_utime = cputime_to_clock_t(utime + tsk->signal->utime);
 	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
 
-	info.si_status = tsk->exit_code & 0x7f;
-	if (tsk->exit_code & 0x80)
+	info.si_status = WTERMSIG(tsk->exit_code);
+	if (WCOREDUMP(tsk->exit_code))
 		info.si_code = CLD_DUMPED;
-	else if (tsk->exit_code & 0x7f)
+	else if (WTERMSIG(tsk->exit_code))
 		info.si_code = CLD_KILLED;
 	else {
 		info.si_code = CLD_EXITED;
-- 
1.8.1.4

