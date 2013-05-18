Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3ERCSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3ERCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:17:00 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aviXYUDioTYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FbYpnvf426MA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=Z4Rwk6OoAAAA:8 a=fkDjwhCSIEbFmp57uqsA:9 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=hPjdaMEvmhQA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=fTglsbG41o2r14ZQ:21 a=iRGE1CqDR6Pms78-:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021651.777964588@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 062/136 ] exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0062-exec-do-not-abuse-cred_guard_mutex-in-threadgroup_lo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit e56fb2874015370e3b7f8d85051f6dce26051df9 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/exec.c             |    3 +++
 include/linux/sched.h |   18 ++++--------------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5b0d397..39b6a3c 100644
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
index 23bddac..46bac3e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2455,27 +2455,18 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
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
 
@@ -2488,7 +2479,6 @@ static inline void threadgroup_lock(struct task_struct *tsk)
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
-- 
1.7.10.4


