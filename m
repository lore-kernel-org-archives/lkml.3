Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3KTS3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:29:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab3KTS3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:29:14 -0500
Date: Wed, 20 Nov 2013 19:30:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] proc: don't (ab)use ->group_leader in
	proc_task_readdir() paths
Message-ID: <20131120183027.GA12219@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120183009.GA12193@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_task_readdir() does not really need "leader", first_tid() has
to revalidate it anyway. Just pass proc_pid(inode) to first_tid()
instead, it can do pid_task(PIDTYPE_PID) itself and read
->group_leader only if necessary.

The patch also extracts the "inode is dead" code from
pid_delete_dentry(dentry) into the new trivial helper,
proc_inode_is_dead(inode), proc_task_readdir() uses it to return
-ENOENT if this dir was removed.

This is a bit racy, but the race is very inlikely and the getdents()
after openndir() can see the empty "." + ".." dir only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |   52 ++++++++++++++++++++++++----------------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7ab3785..912ae60 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1652,13 +1652,18 @@ int pid_revalidate(struct dentry *dentry, unsigned int flags)
 	return 0;
 }
 
+static inline bool proc_inode_is_dead(struct inode *inode)
+{
+	return !proc_pid(inode)->tasks[PIDTYPE_PID].first;
+}
+
 int pid_delete_dentry(const struct dentry *dentry)
 {
 	/* Is the task we represent dead?
 	 * If so, then don't put the dentry on the lru list,
 	 * kill it immediately.
 	 */
-	return !proc_pid(dentry->d_inode)->tasks[PIDTYPE_PID].first;
+	return proc_inode_is_dead(dentry->d_inode);
 }
 
 const struct dentry_operations pid_dentry_operations =
@@ -3086,34 +3091,35 @@ out_no_task:
  * In the case of a seek we start with the leader and walk nr
  * threads past it.
  */
-static struct task_struct *first_tid(struct task_struct *leader,
-		int tid, int nr, struct pid_namespace *ns)
+static struct task_struct *first_tid(struct pid *pid, int tid,
+					int nr, struct pid_namespace *ns)
 {
-	struct task_struct *pos;
+	struct task_struct *pos, *task;
 
 	rcu_read_lock();
-	/* Attempt to start with the pid of a thread */
+	task = pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		goto fail;
+
+	/* Attempt to start with the tid of a thread */
 	if (tid && (nr > 0)) {
 		pos = find_task_by_pid_ns(tid, ns);
-		if (pos && (pos->group_leader == leader))
+		if (pos && same_thread_group(pos, task))
 			goto found;
 	}
 
 	/* If nr exceeds the number of threads there is nothing todo */
-	if (nr && nr >= get_nr_threads(leader))
-		goto fail;
-	/* It could be unhashed before we take rcu lock */
-	if (!pid_alive(leader))
+	if (nr && nr >= get_nr_threads(task))
 		goto fail;
 
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
 	 */
-	pos = leader;
+	pos = task = task->group_leader;
 	do {
 		if (nr-- <= 0)
 			goto found;
-	} while_each_thread(leader, pos);
+	} while_each_thread(task, pos);
 fail:
 	pos = NULL;
 	goto out;
@@ -3149,25 +3155,16 @@ static struct task_struct *next_tid(struct task_struct *start)
 /* for the /proc/TGID/task/ directories */
 static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct task_struct *leader = NULL;
-	struct task_struct *task = get_proc_task(file_inode(file));
+	struct inode *inode = file_inode(file);
+	struct task_struct *task;
 	struct pid_namespace *ns;
 	int tid;
 
-	if (!task)
-		return -ENOENT;
-	rcu_read_lock();
-	if (pid_alive(task)) {
-		leader = task->group_leader;
-		get_task_struct(leader);
-	}
-	rcu_read_unlock();
-	put_task_struct(task);
-	if (!leader)
+	if (proc_inode_is_dead(inode))
 		return -ENOENT;
 
 	if (!dir_emit_dots(file, ctx))
-		goto out;
+		return 0;
 
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
@@ -3175,7 +3172,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	ns = file->f_dentry->d_sb->s_fs_info;
 	tid = (int)file->f_version;
 	file->f_version = 0;
-	for (task = first_tid(leader, tid, ctx->pos - 2, ns);
+	for (task = first_tid(proc_pid(inode), tid, ctx->pos - 2, ns);
 	     task;
 	     task = next_tid(task), ctx->pos++) {
 		char name[PROC_NUMBUF];
@@ -3191,8 +3188,7 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 			break;
 		}
 	}
-out:
-	put_task_struct(leader);
+
 	return 0;
 }
 
-- 
1.5.5.1

