Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaD1Bcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:32:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42963 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michal Schmidt" <mschmidt@redhat.com>,
        "Lennart Poettering" <lpoetter@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Jan Kratochvil" <jan.kratochvil@redhat.com>,
        "Tejun Heo" <tj@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Roland McGrath" <roland@hack.frob.com>,
        "Al Viro" <viro@ZenIV.linux.org.uk>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.333293991@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 82/94] wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE
 race
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit dfccbb5e49a621c1b21a62527d61fc4305617aca upstream.

wait_task_zombie() first does EXIT_ZOMBIE->EXIT_DEAD transition and
drops tasklist_lock.  If this task is not the natural child and it is
traced, we change its state back to EXIT_ZOMBIE for ->real_parent.

The last transition is racy, this is even documented in 50b8d257486a
"ptrace: partially fix the do_wait(WEXITED) vs EXIT_DEAD->EXIT_ZOMBIE
race".  wait_consider_task() tries to detect this transition and clear
->notask_error but we can't rely on ptrace_reparented(), debugger can
exit and do ptrace_unlink() before its sub-thread sets EXIT_ZOMBIE.

And there is another problem which were missed before: this transition
can also race with reparent_leader() which doesn't reset >exit_signal if
EXIT_DEAD, assuming that this task must be reaped by someone else.  So
the tracee can be re-parented with ->exit_signal != SIGCHLD, and if
/sbin/init doesn't use __WALL it becomes unreapable.

Change reparent_leader() to update ->exit_signal even if EXIT_DEAD.
Note: this is the simple temporary hack for -stable, it doesn't try to
solve all problems, it will be reverted by the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Reported-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/exit.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -734,9 +734,6 @@ static void reparent_leader(struct task_
 				struct list_head *dead)
 {
 	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (p->exit_state == EXIT_DEAD)
-		return;
 	/*
 	 * If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -744,9 +741,19 @@ static void reparent_leader(struct task_
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

