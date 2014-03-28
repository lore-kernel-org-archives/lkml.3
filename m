Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaC1HYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 03:24:34 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:9840 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaC1HYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 03:24:32 -0400
Message-ID: <5335232B.70401@huawei.com>
Date: Fri, 28 Mar 2014 15:22:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/2] cgroup: remove useless argument from cgroup_exit()
References: <53352243.80805@huawei.com>
In-Reply-To: <53352243.80805@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 4 ++--
 kernel/cgroup.c        | 5 ++---
 kernel/exit.c          | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index acbb9a4..13ffb06 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -33,7 +33,7 @@ extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_fork(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
-extern void cgroup_exit(struct task_struct *p, int run_callbacks);
+extern void cgroup_exit(struct task_struct *p);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 
@@ -848,7 +848,7 @@ static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
 static inline void cgroup_post_fork(struct task_struct *p) {}
-static inline void cgroup_exit(struct task_struct *p, int callbacks) {}
+static inline void cgroup_exit(struct task_struct *p) {}
 
 static inline int cgroupstats_build(struct cgroupstats *stats,
 					struct dentry *dentry)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a53dbc6..775a90d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4324,7 +4324,6 @@ void cgroup_post_fork(struct task_struct *child)
 /**
  * cgroup_exit - detach cgroup from exiting task
  * @tsk: pointer to task_struct of exiting process
- * @run_callback: run exit callbacks?
  *
  * Description: Detach cgroup from @tsk and release it.
  *
@@ -4341,7 +4340,7 @@ void cgroup_post_fork(struct task_struct *child)
  * init_css_set refcnting.  init_css_set never goes away and we can't race
  * with migration path - PF_EXITING is visible to migration path.
  */
-void cgroup_exit(struct task_struct *tsk, int run_callbacks)
+void cgroup_exit(struct task_struct *tsk)
 {
 	struct cgroup_subsys *ss;
 	struct css_set *cset;
@@ -4363,7 +4362,7 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
 	cset = task_css_set(tsk);
 	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
 
-	if (run_callbacks && need_forkexit_callback) {
+	if (need_forkexit_callback) {
 		/* see cgroup_post_fork() for details */
 		for_each_subsys(ss, i) {
 			if (ss->exit) {
diff --git a/kernel/exit.c b/kernel/exit.c
index c3af836..c2ae892 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -797,7 +797,7 @@ void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
-	cgroup_exit(tsk, 1);
+	cgroup_exit(tsk);
 
 	if (group_dead)
 		disassociate_ctty(1);
-- 
1.8.0.2

