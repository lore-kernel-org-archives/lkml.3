Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772Ab3EFXVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:21:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3EFXOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 080/104] exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
Date: Mon,  6 May 2013 16:12:39 -0700
Message-Id: <20130506230051.885926472@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exec.c             |    3 +++
 include/linux/sched.h |   18 ++++--------------
 2 files changed, 7 insertions(+), 14 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -898,11 +898,13 @@ static int de_thread(struct task_struct
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_KILLABLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end(tsk);
 			schedule();
 			if (unlikely(__fatal_signal_pending(tsk)))
 				goto killed;
@@ -960,6 +962,7 @@ static int de_thread(struct task_struct
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end(tsk);
 
 		release_task(leader);
 	}
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2486,27 +2486,18 @@ static inline void threadgroup_change_en
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
 
@@ -2519,7 +2510,6 @@ static inline void threadgroup_lock(stru
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}


