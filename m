Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaDUEhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:37:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaDUEfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:35:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Lennart Poettering <lpoetter@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 31/32] wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race
Date: Sun, 20 Apr 2014 19:13:48 -0700
Message-Id: <20140421021138.094644395@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/exit.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -559,9 +559,6 @@ static void reparent_leader(struct task_
 				struct list_head *dead)
 {
 	list_move_tail(&p->sibling, &p->real_parent->children);
-
-	if (p->exit_state == EXIT_DEAD)
-		return;
 	/*
 	 * If this is a threaded reparent there is no need to
 	 * notify anyone anything has happened.
@@ -569,9 +566,19 @@ static void reparent_leader(struct task_
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


