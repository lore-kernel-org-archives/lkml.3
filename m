Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3BQTUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:20:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab3BQTUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:20:43 -0500
Date: Sun, 17 Feb 2013 20:19:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] coredump: ensure that SIGKILL always kills the dumping
	thread
Message-ID: <20130217191902.GA21817@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217191819.GA21778@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare_signal() blesses SIGKILL sent to the dumping process but
this signal can be "lost" anyway. The problems is, complete_signal()
sees SIGNAL_GROUP_EXIT and skips the "kill them all" logic. And even
if the dumping process is single-threaded (so the target is always
"correct"), the group-wide SIGKILL is not recorded in task->pending
and thus __fatal_signal_pending() won't be true. A multi-threaded
case has even more problems.

And even ignoring all technical details, SIGNAL_GROUP_EXIT doesn't
look right to me. This coredumping process is not exiting yet, it can
do a lot of work dumping the core.

With this patch the dumping process doesn't have SIGNAL_GROUP_EXIT,
we set signal->group_exit_task instead. This makes signal_group_exit()
true and thus this should equally close the races with exit/exec/stop
but allows to kill the dumping thread reliably.

Notes:
	- It is not clear what should we do with ->group_exit_code
	  if the dumper was killed, see the next change.

	- we need more (hopefully straightforward) changes to ensure
	  that SIGKILL actually interrupts the coredump. Basically we
	  need to check __fatal_signal_pending() in dump_write() and
	  dump_seek().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 2c1ef6a..835d731 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -263,7 +263,6 @@ static int zap_process(struct task_struct *start, int exit_code)
 	struct task_struct *t;
 	int nr = 0;
 
-	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
@@ -291,8 +290,9 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		nr = zap_process(tsk, exit_code);
+		tsk->signal->group_exit_task = tsk;
 		/* ignore all signals except SIGKILL, see prepare_signal() */
-		tsk->signal->flags |= SIGNAL_GROUP_COREDUMP;
+		tsk->signal->flags = SIGNAL_GROUP_COREDUMP;
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -343,6 +343,7 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
 					nr += zap_process(p, exit_code);
+					p->signal->flags = SIGNAL_GROUP_EXIT;
 					unlock_task_sighand(p, &flags);
 				}
 				break;
@@ -394,6 +395,11 @@ static void coredump_finish(struct mm_struct *mm)
 	struct core_thread *curr, *next;
 	struct task_struct *task;
 
+	spin_lock_irq(&current->sighand->siglock);
+	current->signal->group_exit_task = NULL;
+	current->signal->flags = SIGNAL_GROUP_EXIT;
+	spin_unlock_irq(&current->sighand->siglock);
+
 	next = mm->core_state->dumper.next;
 	while ((curr = next) != NULL) {
 		next = curr->next;
-- 
1.5.5.1

