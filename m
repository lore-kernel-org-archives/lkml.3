Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbaEFMpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:45:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52332 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbaEFMoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:44:37 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz,
        arozansk@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] cgroup: convert "tasks" and "cgroup.procs" handle to use cftype->write()
Date: Tue,  6 May 2014 08:44:25 -0400
Message-Id: <1399380266-3324-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_tasks_write() and cgroup_procs_write() are currently using
cftype->write_u64().  This patch converts them to use cftype->write()
instead.  This allows access to the associated kernfs_open_file which
will be necessary to implement the planned kernfs active protection
manipulation for these files.

This shifts buffer parsing to attach_task_by_pid() and makes it return
@nbytes on success.  Let's rename it to __cgroup_procs_write() to
clearly indicate that this is a write handler implementation.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4b340c3..06ad484 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2232,12 +2232,18 @@ static int cgroup_attach_task(struct cgroup *dst_cgrp,
  * function to attach either it or all tasks in its threadgroup. Will lock
  * cgroup_mutex and threadgroup.
  */
-static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
+static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
+				    size_t nbytes, loff_t off, bool threadgroup)
 {
 	struct task_struct *tsk;
 	const struct cred *cred = current_cred(), *tcred;
+	struct cgroup *cgrp = of_css(of)->cgroup;
+	pid_t pid;
 	int ret;
 
+	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
+		return -EINVAL;
+
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 
@@ -2305,7 +2311,7 @@ retry_find_task:
 	put_task_struct(tsk);
 out_unlock_cgroup:
 	mutex_unlock(&cgroup_mutex);
-	return ret;
+	return ret ?: nbytes;
 }
 
 /**
@@ -2339,16 +2345,16 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
 
-static int cgroup_tasks_write(struct cgroup_subsys_state *css,
-			      struct cftype *cft, u64 pid)
+static ssize_t cgroup_tasks_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
 {
-	return attach_task_by_pid(css->cgroup, pid, false);
+	return __cgroup_procs_write(of, buf, nbytes, off, false);
 }
 
-static int cgroup_procs_write(struct cgroup_subsys_state *css,
-			      struct cftype *cft, u64 tgid)
+static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
 {
-	return attach_task_by_pid(css->cgroup, tgid, true);
+	return __cgroup_procs_write(of, buf, nbytes, off, true);
 }
 
 static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
@@ -3951,7 +3957,7 @@ static struct cftype cgroup_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_PROCS,
-		.write_u64 = cgroup_procs_write,
+		.write = cgroup_procs_write,
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
@@ -4000,7 +4006,7 @@ static struct cftype cgroup_base_files[] = {
 		.seq_stop = cgroup_pidlist_stop,
 		.seq_show = cgroup_pidlist_show,
 		.private = CGROUP_FILE_TASKS,
-		.write_u64 = cgroup_tasks_write,
+		.write = cgroup_tasks_write,
 		.mode = S_IRUGO | S_IWUSR,
 	},
 	{
-- 
1.9.0

