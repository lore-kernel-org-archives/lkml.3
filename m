Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbbAXOJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:09:23 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:43410 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbbAXOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:09 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 13/32] cpuset: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:19 -0500
Message-Id: <1422108218-25398-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* kernel/cpuset.c::cpuset_print_task_mems_allowed() used a static
  buffer which is protected by a dedicated spinlock.  Removed.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 42 +++++++++---------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 64b257f..d5a8769 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1707,40 +1707,27 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 {
 	struct cpuset *cs = css_cs(seq_css(sf));
 	cpuset_filetype_t type = seq_cft(sf)->private;
-	ssize_t count;
-	char *buf, *s;
 	int ret = 0;
 
-	count = seq_get_buf(sf, &buf);
-	s = buf;
-
 	spin_lock_irq(&callback_lock);
 
 	switch (type) {
 	case FILE_CPULIST:
-		s += cpulist_scnprintf(s, count, cs->cpus_allowed);
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->cpus_allowed));
 		break;
 	case FILE_MEMLIST:
-		s += nodelist_scnprintf(s, count, cs->mems_allowed);
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->mems_allowed));
 		break;
 	case FILE_EFFECTIVE_CPULIST:
-		s += cpulist_scnprintf(s, count, cs->effective_cpus);
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->effective_cpus));
 		break;
 	case FILE_EFFECTIVE_MEMLIST:
-		s += nodelist_scnprintf(s, count, cs->effective_mems);
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
 	default:
 		ret = -EINVAL;
-		goto out_unlock;
 	}
 
-	if (s < buf + count - 1) {
-		*s++ = '\n';
-		seq_commit(sf, s - buf);
-	} else {
-		seq_commit(sf, -1);
-	}
-out_unlock:
 	spin_unlock_irq(&callback_lock);
 	return ret;
 }
@@ -2610,8 +2597,6 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
-#define CPUSET_NODELIST_LEN	(256)
-
 /**
  * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
  * @tsk: pointer to task_struct of some task.
@@ -2621,23 +2606,16 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
  */
 void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
-	 /* Statically allocated to prevent using excess stack. */
-	static char cpuset_nodelist[CPUSET_NODELIST_LEN];
-	static DEFINE_SPINLOCK(cpuset_buffer_lock);
 	struct cgroup *cgrp;
 
-	spin_lock(&cpuset_buffer_lock);
 	rcu_read_lock();
 
 	cgrp = task_cs(tsk)->css.cgroup;
-	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
-			   tsk->mems_allowed);
 	pr_info("%s cpuset=", tsk->comm);
 	pr_cont_cgroup_name(cgrp);
-	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
+	pr_cont(" mems_allowed=%*pbl\n", nodemask_pr_args(&tsk->mems_allowed));
 
 	rcu_read_unlock();
-	spin_unlock(&cpuset_buffer_lock);
 }
 
 /*
@@ -2715,10 +2693,8 @@ out:
 /* Display task mems_allowed in /proc/<pid>/status file. */
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	seq_puts(m, "Mems_allowed:\t");
-	seq_nodemask(m, &task->mems_allowed);
-	seq_puts(m, "\n");
-	seq_puts(m, "Mems_allowed_list:\t");
-	seq_nodemask_list(m, &task->mems_allowed);
-	seq_puts(m, "\n");
+	seq_printf(m, "Mems_allowed:\t%*pb\n",
+		   nodemask_pr_args(&task->mems_allowed));
+	seq_printf(m, "Mems_allowed_list:\t%*pbl\n",
+		   nodemask_pr_args(&task->mems_allowed));
 }
-- 
2.1.0

