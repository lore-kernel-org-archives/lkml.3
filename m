Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaIRIDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:03:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:61847 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaIRIDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:03:31 -0400
Message-ID: <541A91C3.9000305@huawei.com>
Date: Thu, 18 Sep 2014 16:03:15 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: simplify proc_cgroup_show()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.541A91CC.00FF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1fbc8e91ce6a126f05ab1af8bd15e1d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the ONE macro instead of REG, and we can simplify proc_cgroup_show().

Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/proc/base.c         | 19 ++-----------------
 include/linux/cgroup.h |  3 ++-
 kernel/cgroup.c        | 18 +++---------------
 3 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index baf852b..6b96892 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -376,21 +376,6 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
-#ifdef CONFIG_CGROUPS
-static int cgroup_open(struct inode *inode, struct file *file)
-{
-	struct pid *pid = PROC_I(inode)->pid;
-	return single_open(file, proc_cgroup_show, pid);
-}
-
-static const struct file_operations proc_cgroup_operations = {
-	.open		= cgroup_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif
-
 #ifdef CONFIG_PROC_PID_CPUSET
 
 static int cpuset_open(struct inode *inode, struct file *file)
@@ -2576,7 +2561,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("cpuset",     S_IRUGO, proc_cpuset_operations),
 #endif
 #ifdef CONFIG_CGROUPS
-	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
+	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
 #endif
 	ONE("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adj_operations),
@@ -2922,7 +2907,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("cpuset",    S_IRUGO, proc_cpuset_operations),
 #endif
 #ifdef CONFIG_CGROUPS
-	REG("cgroup",  S_IRUGO, proc_cgroup_operations),
+	ONE("cgroup",  S_IRUGO, proc_cgroup_show),
 #endif
 	ONE("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adj_operations),
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f7898e0..a5d9b8f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -37,7 +37,8 @@ extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 
-extern int proc_cgroup_show(struct seq_file *, void *);
+extern int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *tsk);
 
 /* define the enumeration of all cgroup subsystems */
 #define SUBSYS(_x) _x ## _cgrp_id,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1abb554..e91bc3c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5040,12 +5040,9 @@ core_initcall(cgroup_wq_init);
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
  *  - Used for /proc/<pid>/cgroup.
  */
-
-/* TODO: Use a proper seq_file iterator */
-int proc_cgroup_show(struct seq_file *m, void *v)
+int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
+		     struct pid *pid, struct task_struct *tsk)
 {
-	struct pid *pid;
-	struct task_struct *tsk;
 	char *buf, *path;
 	int retval;
 	struct cgroup_root *root;
@@ -5055,14 +5052,6 @@ int proc_cgroup_show(struct seq_file *m, void *v)
 	if (!buf)
 		goto out;
 
-	retval = -ESRCH;
-	pid = m->private;
-	tsk = get_pid_task(pid, PIDTYPE_PID);
-	if (!tsk)
-		goto out_free;
-
-	retval = 0;
-
 	mutex_lock(&cgroup_mutex);
 	down_read(&css_set_rwsem);
 
@@ -5092,11 +5081,10 @@ int proc_cgroup_show(struct seq_file *m, void *v)
 		seq_putc(m, '\n');
 	}
 
+	retval = 0;
 out_unlock:
 	up_read(&css_set_rwsem);
 	mutex_unlock(&cgroup_mutex);
-	put_task_struct(tsk);
-out_free:
 	kfree(buf);
 out:
 	return retval;
-- 
1.8.0.2

