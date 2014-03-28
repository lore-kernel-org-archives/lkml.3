Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaC1HTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:19:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16046 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaC1HTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:19:33 -0400
Message-ID: <53352243.80805@huawei.com>
Date: Fri, 28 Mar 2014 15:18:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/2] cgroup: fix spurious lockdep warning in cgroup_exit()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_exit() is called in fork and exit path. If it's called in the
failure path during fork, PF_EXITING isn't set, and then lockdep will
complain.

Fix this by removing cgroup_exit() in that failure path. cgroup_fork()
does nothing that needs cleanup.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 3 +--
 kernel/fork.c   | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8f4ddbe..a53dbc6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4339,8 +4339,7 @@ void cgroup_post_fork(struct task_struct *child)
  * notify_on_release(), then leave the task attached to the root cgroup in
  * each hierarchy for the remainder of its exit.  No need to bother with
  * init_css_set refcnting.  init_css_set never goes away and we can't race
- * with migration path - either PF_EXITING is visible to migration path or
- * @tsk never got on the tasklist.
+ * with migration path - PF_EXITING is visible to migration path.
  */
 void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 3e02737..0477657 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1274,7 +1274,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (IS_ERR(p->mempolicy)) {
 		retval = PTR_ERR(p->mempolicy);
 		p->mempolicy = NULL;
-		goto bad_fork_cleanup_cgroup;
+		goto bad_fork_cleanup_threadgroup_lock;
 	}
 #endif
 #ifdef CONFIG_CPUSETS
@@ -1526,11 +1526,10 @@ bad_fork_cleanup_policy:
 	perf_event_free_task(p);
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
-bad_fork_cleanup_cgroup:
+bad_fork_cleanup_threadgroup_lock:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
-	cgroup_exit(p, 0);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.8.0.2

