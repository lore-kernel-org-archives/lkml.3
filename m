Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3CEIIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:08:23 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:37484 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3CEIIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:08:15 -0500
Message-ID: <5135A7C5.3000708@huawei.com>
Date: Tue, 5 Mar 2013 16:07:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/9] sched: Move group scheduling functions out of include/linux/sched.h
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Make sched_group_{set_,}runtime(), sched_group_{set_,}period() and
sched_rt_can_attach() static.

- Move sched_{create,destroy,online,offline}_group() to kernel/sched/sched.h.

- Remove declaration of sched_group_shares().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 21 ---------------------
 kernel/sched/core.c   | 10 +++++-----
 kernel/sched/sched.h  | 12 ++++++++++++
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index eadd113..fc039ce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2512,28 +2512,7 @@ extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
 extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
 #ifdef CONFIG_CGROUP_SCHED
-
 extern struct task_group root_task_group;
-
-extern struct task_group *sched_create_group(struct task_group *parent);
-extern void sched_online_group(struct task_group *tg,
-			       struct task_group *parent);
-extern void sched_destroy_group(struct task_group *tg);
-extern void sched_offline_group(struct task_group *tg);
-extern void sched_move_task(struct task_struct *tsk);
-#ifdef CONFIG_FAIR_GROUP_SCHED
-extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
-extern unsigned long sched_group_shares(struct task_group *tg);
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-extern int sched_group_set_rt_runtime(struct task_group *tg,
-				      long rt_runtime_us);
-extern long sched_group_rt_runtime(struct task_group *tg);
-extern int sched_group_set_rt_period(struct task_group *tg,
-				      long rt_period_us);
-extern long sched_group_rt_period(struct task_group *tg);
-extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
-#endif
 #endif /* CONFIG_CGROUP_SCHED */
 
 extern int task_can_switch_user(struct user_struct *up,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..9ad26c9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7455,7 +7455,7 @@ unlock:
 	return err;
 }
 
-int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
+static int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 
@@ -7467,7 +7467,7 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
-long sched_group_rt_runtime(struct task_group *tg)
+static long sched_group_rt_runtime(struct task_group *tg)
 {
 	u64 rt_runtime_us;
 
@@ -7479,7 +7479,7 @@ long sched_group_rt_runtime(struct task_group *tg)
 	return rt_runtime_us;
 }
 
-int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
+static int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 {
 	u64 rt_runtime, rt_period;
 
@@ -7492,7 +7492,7 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
 }
 
-long sched_group_rt_period(struct task_group *tg)
+static long sched_group_rt_period(struct task_group *tg)
 {
 	u64 rt_period_us;
 
@@ -7527,7 +7527,7 @@ static int sched_rt_global_constraints(void)
 	return ret;
 }
 
-int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
+static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
 	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eca526d..304fc1c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -221,6 +221,18 @@ extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);
 
+extern struct task_group *sched_create_group(struct task_group *parent);
+extern void sched_online_group(struct task_group *tg,
+			       struct task_group *parent);
+extern void sched_destroy_group(struct task_group *tg);
+extern void sched_offline_group(struct task_group *tg);
+
+extern void sched_move_task(struct task_struct *tsk);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
+#endif
+
 #else /* CONFIG_CGROUP_SCHED */
 
 struct cfs_bandwidth { };
-- 
1.8.0.2
