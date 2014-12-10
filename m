Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaLJPyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:54:50 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:33733 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbaLJPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:21 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 08/12] cpuset: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:50 -0500
Message-Id: <1418226774-30215-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

* kernel/cpuset.c::cpuset_print_task_mems_allowed() used a static
  buffer which is protected by a dedicated spinlock.  Replaced with
  plain pr_conts.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index fdf1759..6a7f466 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2614,8 +2614,6 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
-#define CPUSET_NODELIST_LEN	(256)
-
 /**
  * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
  * @tsk: pointer to task_struct of some task.
@@ -2625,23 +2623,18 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
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
+	pr_cont(" mems_allowed=");
+	nodelist_pr_cont(tsk->mems_allowed);
+	pr_cont("\n");
 
 	rcu_read_unlock();
-	spin_unlock(&cpuset_buffer_lock);
 }
 
 /*
-- 
2.1.0

