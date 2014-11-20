Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbaKTSe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:34:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbaKTSe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:34:26 -0500
Date: Thu, 20 Nov 2014 19:34:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/3] exit: reparent: call forget_original_parent()
	under tasklist_lock
Message-ID: <20141120183426.GA10273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120183400.GA9622@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shift "release dead children" loop from forget_original_parent() to
its caller, exit_notify(). It is safe to reap them even if our parent
reaps us right after we drop tasklist_lock, those children no longer
have any connection to the exiting task.

And this allows us to avoid write_lock_irq(tasklist_lock) right after
it was released by forget_original_parent(), we can simply call it
with tasklist_lock held.

While at it, move the comment about forget_original_parent() up to
this function.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 81b62f8..ccf27cb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -560,19 +560,26 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	kill_orphaned_pgrp(p, father);
 }
 
-static void forget_original_parent(struct task_struct *father)
+/*
+ * This does two things:
+ *
+ * A.  Make init inherit all the child processes
+ * B.  Check to see if any process groups have become orphaned
+ *	as a result of our exiting, and if they have any stopped
+ *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
+ */
+static void forget_original_parent(struct task_struct *father,
+					struct list_head *dead)
 {
-	struct task_struct *p, *t, *n, *reaper;
-	LIST_HEAD(dead_children);
+	struct task_struct *p, *t, *reaper;
 
-	write_lock_irq(&tasklist_lock);
 	if (unlikely(!list_empty(&father->ptraced)))
-		exit_ptrace(father, &dead_children);
+		exit_ptrace(father, dead);
 
 	/* Can drop and reacquire tasklist_lock */
 	reaper = find_child_reaper(father);
 	if (list_empty(&father->children))
-		goto unlock;
+		return;
 
 	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
@@ -590,16 +597,9 @@ static void forget_original_parent(struct task_struct *father)
 		 * notify anyone anything has happened.
 		 */
 		if (!same_thread_group(reaper, father))
-			reparent_leader(father, p, &dead_children);
+			reparent_leader(father, p, dead);
 	}
 	list_splice_tail_init(&father->children, &reaper->children);
- unlock:
-	write_unlock_irq(&tasklist_lock);
-
-	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
-	}
 }
 
 /*
@@ -609,18 +609,12 @@ static void forget_original_parent(struct task_struct *father)
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
 	bool autoreap;
-
-	/*
-	 * This does two things:
-	 *
-	 * A.  Make init inherit all the child processes
-	 * B.  Check to see if any process groups have become orphaned
-	 *	as a result of our exiting, and if they have any stopped
-	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
-	 */
-	forget_original_parent(tsk);
+	struct task_struct *p, *n;
+	LIST_HEAD(dead);
 
 	write_lock_irq(&tasklist_lock);
+	forget_original_parent(tsk, &dead);
+
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
@@ -644,6 +638,11 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		wake_up_process(tsk->signal->group_exit_task);
 	write_unlock_irq(&tasklist_lock);
 
+	list_for_each_entry_safe(p, n, &dead, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
+		release_task(p);
+	}
+
 	/* If the process is dead, release it - nobody will wait for it */
 	if (autoreap)
 		release_task(tsk);
-- 
1.5.5.1

