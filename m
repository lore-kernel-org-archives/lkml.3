Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FIRE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:04:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab3FIRE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:04:29 -0400
Date: Sun, 9 Jun 2013 19:00:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] copy_process: don't add the uninitialized child to
	thread/task/pid lists
Message-ID: <20130609170028.GA5243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609170007.GA5215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_process() adds the new child to thread_group/init_task.tasks
list and then does attach_pid(child, PIDTYPE_PID). This means that
the lockless next_thread() or next_task() can see this thread with
the wrong pid. Say, "ls /proc/pid/task" can list the same inode
twice.

We could move attach_pid(child, PIDTYPE_PID) up, but in this case
find_task_by_vpid() can find the new thread before it was fully
initialized. And this is already true for PIDTYPE_PGID/PIDTYPE_SID,

With this patch copy_process() initializes child->pids[*].pid first,
then calls attach_pid() to insert the task into the pid->tasks list.

attach_pid() no longer need the "struct pid*" argument, it is always
called after pid_link->pid was already set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/pid.h |    6 ++----
 kernel/fork.c       |   16 +++++++++++++---
 kernel/pid.c        |   12 ++++--------
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index a089a3c..23705a5 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -86,11 +86,9 @@ extern struct task_struct *get_pid_task(struct pid *pid, enum pid_type);
 extern struct pid *get_task_pid(struct task_struct *task, enum pid_type type);
 
 /*
- * attach_pid() and detach_pid() must be called with the tasklist_lock
- * write-held.
+ * these helpers must be called with the tasklist_lock write-held.
  */
-extern void attach_pid(struct task_struct *task, enum pid_type type,
-			struct pid *pid);
+extern void attach_pid(struct task_struct *task, enum pid_type);
 extern void detach_pid(struct task_struct *task, enum pid_type);
 extern void change_pid(struct task_struct *task, enum pid_type,
 			struct pid *pid);
diff --git a/kernel/fork.c b/kernel/fork.c
index 7bc4146..c836e3c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1121,6 +1121,12 @@ static void posix_cpu_timers_init(struct task_struct *tsk)
 	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
 }
 
+static inline void
+init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
+{
+	 task->pids[type].pid = pid;
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -1449,7 +1455,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
 
+		init_task_pid(p, PIDTYPE_PID, pid);
 		if (thread_group_leader(p)) {
+			init_task_pid(p, PIDTYPE_PGID, task_pgrp(current));
+			init_task_pid(p, PIDTYPE_SID, task_session(current));
+
 			if (is_child_reaper(pid)) {
 				ns_of_pid(pid)->child_reaper = p;
 				p->signal->flags |= SIGNAL_UNKILLABLE;
@@ -1457,10 +1467,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 			p->signal->leader_pid = pid;
 			p->signal->tty = tty_kref_get(current->signal->tty);
-			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
-			attach_pid(p, PIDTYPE_SID, task_session(current));
 			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
+			attach_pid(p, PIDTYPE_PGID);
+			attach_pid(p, PIDTYPE_SID);
 			__this_cpu_inc(process_counts);
 		} else {
 			current->signal->nr_threads++;
@@ -1470,7 +1480,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			list_add_tail_rcu(&p->thread_group,
 					  &p->group_leader->thread_group);
 		}
-		attach_pid(p, PIDTYPE_PID, pid);
+		attach_pid(p, PIDTYPE_PID);
 		nr_threads++;
 	}
 
diff --git a/kernel/pid.c b/kernel/pid.c
index 0db3e79..61980ce 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -373,14 +373,10 @@ EXPORT_SYMBOL_GPL(find_vpid);
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
-void attach_pid(struct task_struct *task, enum pid_type type,
-		struct pid *pid)
+void attach_pid(struct task_struct *task, enum pid_type type)
 {
-	struct pid_link *link;
-
-	link = &task->pids[type];
-	link->pid = pid;
-	hlist_add_head_rcu(&link->node, &pid->tasks[type]);
+	struct pid_link *link = &task->pids[type];
+	hlist_add_head_rcu(&link->node, &link->pid->tasks[type]);
 }
 
 static void __change_pid(struct task_struct *task, enum pid_type type,
@@ -412,7 +408,7 @@ void change_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
 	__change_pid(task, type, pid);
-	attach_pid(task, type, pid);
+	attach_pid(task, type);
 }
 
 /* transfer_pid is an optimization of attach_pid(new), detach_pid(old) */
-- 
1.5.5.1

