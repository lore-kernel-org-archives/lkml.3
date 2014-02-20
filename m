Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaBTRjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbaBTRjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:39:06 -0500
Date: Thu, 20 Feb 2014 18:38:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE
	race
Message-ID: <20140220173858.GA21844@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220173838.GA21825@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_task_zombie() first does EXIT_ZOMBIE->EXIT_DEAD transition and
drops tasklist_lock. If this task is not the natural child and it is
traced, we change its state back to EXIT_ZOMBIE for ->real_parent.

The last transition is racy, this is even documented in 50b8d257486a
"ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE
race". wait_consider_task() tries to detect this transition and clear
->notask_error but we can't rely on ptrace_reparented(), debugger can
exit and do ptrace_unlink() before its sub-thread sets EXIT_ZOMBIE.

And there is another problem which were missed before: this transition
can also race with reparent_leader() which doesn't reset >exit_signal
if EXIT_DEAD, assuming that this task must be reaped by someone else.
So the tracee can be re-parented with ->exit_signal != SIGCHLD, and
if /sbin/init doesn't use __WALL it becomes unreapable.

Change reparent_leader() to update ->exit_signal even if EXIT_DEAD.
Note: this is the simple temporary hack for -stable, it doesn't try
to solve all problems, it will be reverted by the next changes.

Cc: stable@vger.kernel.org
Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Reported-and-tested-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 1e77fc6..5281522 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -560,9 +560,6 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
 	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (p->exit_state == EXIT_DEAD)
-		return;
 	/*
 	 * If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -570,9 +567,19 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	if (same_thread_group(p->real_parent, father))
 		return;
 
-	/* We don't want people slaying init.  */
+	/*
+	 * We don't want people slaying init.
+	 *
+	 * Note: we do this even if it is EXIT_DEAD, wait_task_zombie()
+	 * can change ->exit_state to EXIT_ZOMBIE. If this is the final
+	 * state, do_notify_parent() was already called and ->exit_signal
+	 * doesn't matter.
+	 */
 	p->exit_signal = SIGCHLD;
 
+	if (p->exit_state == EXIT_DEAD)
+		return;
+
 	/* If it has exited notify the new parent about this child's death. */
 	if (!p->ptrace &&
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
-- 
1.5.5.1

