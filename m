Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab3FCTK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:10:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab3FCTKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:10:54 -0400
Date: Mon, 3 Jun 2013 21:07:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] proc: simplify proc_task_readdir/first_tid paths
Message-ID: <20130603190702.GA11510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603190640.GA11481@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_task_readdir() does not really need "leader", first_tid()
has to revalidate it anyway. Just pass proc_pid(inode) to
first_tid() instead, it can do pid_task(PIDTYPE_PID) itself
and read ->group_leader only if necessary.

The patch also extracts the "inode is dead" code
from pid_delete_dentry(dentry) into the new trivial helper,
proc_inode_is_dead(inode), proc_task_readdir() uses it to return
-ENOENT if this dir was removed. This is a bit racy, but the race
is very inlikely and the getdents() after openndir() can see the
empty "." + ".." dir only once.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |   53 ++++++++++++++++++++++-------------------------------
 1 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index bed1096..5e0e02f 100644
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
@@ -3173,34 +3178,35 @@ out_no_task:
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
@@ -3247,26 +3253,13 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct task_struct *leader = NULL;
 	struct task_struct *task;
-	int retval = -ENOENT;
 	ino_t ino;
 	int tid;
 	struct pid_namespace *ns;
 
-	task = get_proc_task(inode);
-	if (!task)
-		goto out_no_task;
-	rcu_read_lock();
-	if (pid_alive(task)) {
-		leader = task->group_leader;
-		get_task_struct(leader);
-	}
-	rcu_read_unlock();
-	put_task_struct(task);
-	if (!leader)
-		goto out_no_task;
-	retval = 0;
+	if (proc_inode_is_dead(inode))
+		return -ENOENT;
 
 	switch ((unsigned long)filp->f_pos) {
 	case 0:
@@ -3289,7 +3282,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 	ns = filp->f_dentry->d_sb->s_fs_info;
 	tid = (int)filp->f_version;
 	filp->f_version = 0;
-	for (task = first_tid(leader, tid, filp->f_pos - 2, ns);
+	for (task = first_tid(proc_pid(inode), tid, filp->f_pos - 2, ns);
 	     task;
 	     task = next_tid(task), filp->f_pos++) {
 		tid = task_pid_nr_ns(task, ns);
@@ -3302,9 +3295,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 		}
 	}
 out:
-	put_task_struct(leader);
-out_no_task:
-	return retval;
+	return 0;
 }
 
 static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
-- 
1.5.5.1

