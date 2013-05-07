Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab3EGNmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab3EGNmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 114/118] exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
Date: Tue,  7 May 2013 14:39:20 +0100
Message-Id: <1367933964-1564-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit e56fb2874015370e3b7f8d85051f6dce26051df9 upstream.

threadgroup_lock() takes signal->cred_guard_mutex to ensure that
thread_group_leader() is stable.  This doesn't look nice, the scope of
this lock in do_execve() is huge.

And as Dave pointed out this can lead to deadlock, we have the
following dependencies:

	do_execve:		cred_guard_mutex -> i_mutex
	cgroup_mount:		i_mutex -> cgroup_mutex
	attach_task_by_pid:	cgroup_mutex -> cred_guard_mutex

Change de_thread() to take threadgroup_change_begin() around the
switch-the-leader code and change threadgroup_lock() to avoid
->cred_guard_mutex.

Note that de_thread() can't sleep with ->group_rwsem held, this can
obviously deadlock with the exiting leader if the writer is active, so it
does threadgroup_change_end() before schedule().

Reported-by: Dave Jones <davej@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/exec.c             |  3 +++
 include/linux/sched.h | 18 ++++--------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2013724..5a76464 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -905,11 +905,13 @@ static int de_thread(struct task_struct *tsk)
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end(tsk);
 			schedule();
 		}
 
@@ -965,6 +967,7 @@ static int de_thread(struct task_struct *tsk)
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end(tsk);
 
 		release_task(leader);
 	}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3a9e314..ebd15f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2445,27 +2445,18 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
  *
  * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
  * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * perform exec.  This is useful for cases where the threadgroup needs to
- * stay stable across blockable operations.
+ * change ->group_leader/pid.  This is useful for cases where the threadgroup
+ * needs to stay stable across blockable operations.
  *
  * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
  * synchronization.  While held, no new task will be added to threadgroup
  * and no existing live task will have its PF_EXITING set.
  *
- * During exec, a task goes and puts its thread group through unusual
- * changes.  After de-threading, exclusive access is assumed to resources
- * which are usually shared by tasks in the same group - e.g. sighand may
- * be replaced with a new one.  Also, the exec'ing task takes over group
- * leader role including its pid.  Exclude these changes while locked by
- * grabbing cred_guard_mutex which is used to synchronize exec path.
+ * de_thread() does threadgroup_change_{begin|end}() when a non-leader
+ * sub-thread becomes a new leader.
  */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
-	/*
-	 * exec uses exit for de-threading nesting group_rwsem inside
-	 * cred_guard_mutex. Grab cred_guard_mutex first.
-	 */
-	mutex_lock(&tsk->signal->cred_guard_mutex);
 	down_write(&tsk->signal->group_rwsem);
 }
 
@@ -2478,7 +2469,6 @@ static inline void threadgroup_lock(struct task_struct *tsk)
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
-- 
1.8.1.2

