Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab3CFOmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:42:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269Ab3CFOmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:42:32 -0500
Date: Wed, 6 Mar 2013 06:41:16 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-25cc7da7e6336d3bb6a5bad3d3fa96fce9a81d5b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A7C5.3000708@huawei.com>
References: <5135A7C5.3000708@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Move group scheduling functions out of include/linux/sched.h
Git-Commit-ID: 25cc7da7e6336d3bb6a5bad3d3fa96fce9a81d5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:41:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25cc7da7e6336d3bb6a5bad3d3fa96fce9a81d5b
Gitweb:     http://git.kernel.org/tip/25cc7da7e6336d3bb6a5bad3d3fa96fce9a81d5b
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:07:33 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:34 +0100

sched: Move group scheduling functions out of include/linux/sched.h

- Make sched_group_{set_,}runtime(), sched_group_{set_,}period()
and sched_rt_can_attach() static.

- Move sched_{create,destroy,online,offline}_group() to
kernel/sched/sched.h.

- Remove declaration of sched_group_shares().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A7C5.3000708@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
