Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaAWTe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:34:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbaAWTe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:27 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com
Subject: [PATCH 3/7] pid: use the CONST_CAST macro instead to write to const task_struct::pid
Date: Thu, 23 Jan 2014 14:32:36 -0500
Message-Id: <d7307cfb4bac25729cb42764668d5e9ac037e502.1390495874.git.rgb@redhat.com>
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
References: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <cover.1390495874.git.rgb@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONST_CAST macro is a cleaner and more reliable way to write to the const
task_struct::pid.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/exec.c     |    4 +---
 kernel/fork.c |    5 +----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a6b585e..1d2369d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -906,8 +906,6 @@ static int de_thread(struct task_struct *tsk)
 	 */
 	if (!thread_group_leader(tsk)) {
 		struct task_struct *leader = tsk->group_leader;
-		/* tast_struct::pid is const pid_t, hence the ugly cast */
-		pid_t *pid_p = (pid_t*)&(tsk->pid);
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -950,7 +948,7 @@ static int de_thread(struct task_struct *tsk)
 		 * Note: The old leader also uses this pid until release_task
 		 *       is called.  Odd but simple and correct.
 		 */
-		*pid_p = leader->pid;
+		CONST_CAST(pid_t, tsk->pid) = leader->pid;
 		change_pid(tsk, PIDTYPE_PID, task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
diff --git a/kernel/fork.c b/kernel/fork.c
index 296e564..207c543 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1135,7 +1135,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
-	pid_t *pid_p;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1391,9 +1390,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	/* ok, now we should be set up.. */
 
-	/* tast_struct::pid is const pid_t, hence the ugly cast */
-	pid_p = (pid_t*)&(p->pid);
-	*pid_p = pid_nr(pid);
+	CONST_CAST(pid_t, p->pid) = pid_nr(pid);
 	if (clone_flags & CLONE_THREAD) {
 		p->exit_signal = -1;
 		p->group_leader = current->group_leader;
-- 
1.7.1

