Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3LPVNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:13:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3LPVNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:13:54 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] pid: change task_struct::pid to read-only
Date: Mon, 16 Dec 2013 16:03:38 -0500
Message-Id: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
In-Reply-To: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->pid is only ever assigned once (well ok, twice).  For system health and
secure logging confidence, make it const to make it much more intentional when
it is being changed.
---

Peter, as you had suggested, does this approach work for you in terms of making
task_struct::pid a lot more difficult to accidentally change to try to preserve
its integrity?

Is the use of memcpy() significantly different from *p = *q ?


 arch/x86/kernel/process.c |    2 +-
 fs/exec.c                 |    4 +++-
 include/linux/sched.h     |    2 +-
 kernel/fork.c             |    8 ++++++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c83516b..4170026 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -66,7 +66,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	int ret;
 
-	*dst = *src;
+	memcpy(dst, src, sizeof(struct task_struct));
 	if (fpu_allocated(&src->thread.fpu)) {
 		memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
 		ret = fpu_alloc(&dst->thread.fpu);
diff --git a/fs/exec.c b/fs/exec.c
index 47d7edb..c8d0159 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -908,6 +908,8 @@ static int de_thread(struct task_struct *tsk)
 	 */
 	if (!thread_group_leader(tsk)) {
 		struct task_struct *leader = tsk->group_leader;
+		/* tast_struct::pid is const pid_t, hence the ugly cast */
+		pid_t *pid_p = (pid_t*)&(tsk->pid);
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
@@ -950,7 +952,7 @@ static int de_thread(struct task_struct *tsk)
 		 * Note: The old leader also uses this pid until release_task
 		 *       is called.  Odd but simple and correct.
 		 */
-		tsk->pid = leader->pid;
+		*pid_p = leader->pid;
 		change_pid(tsk, PIDTYPE_PID, task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d9ada71..45069c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1112,7 +1112,7 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
-	pid_t pid;
+	const pid_t pid;
 	pid_t tgid;
 
 #ifdef CONFIG_CC_STACKPROTECTOR
diff --git a/kernel/fork.c b/kernel/fork.c
index 086fe73..ec0683d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -286,7 +286,7 @@ void __init fork_init(unsigned long mempages)
 int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
 					       struct task_struct *src)
 {
-	*dst = *src;
+	memcpy(dst, src, sizeof(struct task_struct));
 	return 0;
 }
 
@@ -1137,6 +1137,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
+	pid_t *pid_p;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1392,7 +1393,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	clear_all_latency_tracing(p);
 
 	/* ok, now we should be set up.. */
-	p->pid = pid_nr(pid);
+
+	/* tast_struct::pid is const pid_t, hence the ugly cast */
+	pid_p = (pid_t*)&(p->pid);
+	*pid_p = pid_nr(pid);
 	if (clone_flags & CLONE_THREAD) {
 		p->exit_signal = -1;
 		p->group_leader = current->group_leader;
-- 
1.7.1

