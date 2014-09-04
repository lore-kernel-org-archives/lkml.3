Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaIDQbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:31:42 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:49876 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbaIDQbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:22 -0400
X-Yandex-Uniq: e9d95a82-965a-4e2b-b09c-16dedb354c3a
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 12/19] smart: cgroup interface for smart
Date: Thu,  4 Sep 2014 20:30:58 +0400
Message-Id: <1409848265-17150-12-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch extends cpu cgroup controller to provide convenient interface
for using smart.
The interface contains one simple knob: smart. If it's set to 1,
SCHED_RR scheduling policy (with priority 10) is assigned to all non-rt
tasks in the group. If it's set to 0, scheduling policy of all rt tasks
is reset to SCHED_NORMAL.
Global enabling/disabling smart doesn't affect per-cgroup smart knob
state, but tasks in the smart cgroup will actually scheduled by CFS if
smart is disabled globally. In other words, tasks in a cgroup with smart
knob set are scheduled by real-time scheduler only if smart is enabled.
If smart is temporarily disabled globally (due to cpu hotplug, for
instance), all tasks in smart cgroups will be temporarily scheduled by
CFS and than rt scheduling policy will be restored. Such behavior
guarantees graceful degradation if something is wrong with smart.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/core.c  | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/rt.c    |   8 ++++
 kernel/sched/sched.h |   6 +++
 3 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2b988c..0f25fe0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7413,6 +7413,10 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+#ifdef CONFIG_SMART
+	tg->smart = parent->smart;
+#endif
+
 	return tg;
 
 err:
@@ -7877,13 +7881,119 @@ static int cpu_cgroup_can_attach(struct cgroup *cgrp,
 	return 0;
 }
 
+#ifdef CONFIG_SMART
+
+int sched_smart_prio = 10;
+
+static void __update_task_smart(struct task_struct *task,
+				struct cgroup *cgrp)
+{
+	struct task_group *tg;
+	int policy;
+	struct sched_param param;
+
+	if (!task->mm)
+		return;
+
+	tg = cgroup_tg(cgrp);
+
+	if (!rt_task(task) && tg->smart > 0) {
+		policy = SCHED_RR;
+		param.sched_priority = sched_smart_prio;
+	} else if (rt_task(task) && tg->smart <= 0) {
+		policy = SCHED_NORMAL;
+		param.sched_priority = 0;
+	} else
+		return;
+
+	WARN_ON(sched_setscheduler_nocheck(task, policy, &param));
+}
+
+static void update_task_smart(struct task_struct *task,
+			      struct cgroup_scanner *scan)
+{
+	__update_task_smart(task, scan->cg);
+}
+
+static int update_cgrp_smart(struct cgroup *cgrp)
+{
+	struct cgroup_scanner scan;
+
+	scan.cg = cgrp;
+	scan.test_task = NULL;
+	scan.process_task = update_task_smart;
+	scan.heap = NULL;
+
+	return cgroup_scan_tasks(&scan);
+}
+
+static u64 cpu_smart_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return cgroup_tg(cgrp)->smart == 1 ? 1 : 0;
+}
+
+static int cpu_smart_write(struct cgroup *cgrp, struct cftype *cftype,
+			   u64 enable)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+
+	if (enable != 0 && enable != 1)
+		return -EINVAL;
+
+	/* Don't allow to enable smart for root cgroup */
+	if (!tg->se[0])
+		return -EINVAL;
+
+	mutex_lock(&smart_mutex);
+	tg->smart = (smart_enabled() ? 1 : -1) * enable;
+	update_cgrp_smart(cgrp);
+	mutex_unlock(&smart_mutex);
+
+	return 0;
+}
+
+static int update_smart_tg(struct task_group *tg, void *data)
+{
+	int ret = 0;
+	int enabled = smart_enabled();
+
+	if (enabled && tg->smart < 0) {
+		tg->smart = 1;
+		ret = update_cgrp_smart(tg->css.cgroup);
+	} else if (!enabled && tg->smart > 0) {
+		tg->smart = -1;
+		ret = update_cgrp_smart(tg->css.cgroup);
+	}
+
+	return ret;
+}
+
+int smart_update_globally(void)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = walk_tg_tree(update_smart_tg, tg_nop, NULL);
+	rcu_read_unlock();
+
+	return ret;
+}
+#else /* CONFIG_SMART */
+static void __update_task_smart(struct task_struct *task,
+				struct cgroup *cgrp)
+{
+}
+#endif  /* CONFIG_SMART */
+
 static void cpu_cgroup_attach(struct cgroup *cgrp,
 			      struct cgroup_taskset *tset)
 {
 	struct task_struct *task;
 
-	cgroup_taskset_for_each(task, cgrp, tset)
+	cgroup_taskset_for_each(task, cgrp, tset) {
 		sched_move_task(task);
+		__update_task_smart(task, cgrp);
+	}
 }
 
 static void
@@ -8214,6 +8324,13 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
+#ifdef CONFIG_SMART
+	{
+		.name = "smart",
+		.read_u64 = cpu_smart_read,
+		.write_u64 = cpu_smart_write,
+	},
+#endif
 	{ }	/* terminate */
 };
 
@@ -8231,6 +8348,13 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.early_init	= 1,
 };
 
+#else /* CONFIG_CGROUP_SCHED */
+#ifdef CONFIG_SMART
+int smart_update_globally(void)
+{
+	return 0;
+}
+#endif
 #endif	/* CONFIG_CGROUP_SCHED */
 
 void dump_cpu_task(int cpu)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 14acd51..a3fd83c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2405,6 +2405,14 @@ void build_smart_topology(void)
 	if (!check_smart_data()) {
 		printk(KERN_INFO "smart: enabled\n");
 		static_key_slow_inc(&__smart_initialized);
+		if (!was_initialized) {
+			smart_update_globally();
+			printk(KERN_INFO "smart: enabled globally\n");
+		}
+	} else if (was_initialized) {
+		printk(KERN_ALERT "smart: can't build smart topology\n");
+		smart_update_globally();
+		printk(KERN_ALERT "smart: disabled globally\n");
 	}
 
 	rcu_read_unlock();
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d450b8f..6ab02dd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -165,6 +165,10 @@ struct task_group {
 #endif
 
 	struct cfs_bandwidth cfs_bandwidth;
+
+#ifdef CONFIG_SMART
+	int smart;
+#endif
 };
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1434,6 +1438,7 @@ struct smart_gathering {
 
 extern struct static_key __smart_initialized;
 extern struct static_key __smart_enabled;
+extern struct mutex smart_mutex;
 extern struct static_key smart_cfs_gather;
 extern struct static_key smart_cfs_throttle;
 
@@ -1636,6 +1641,7 @@ static inline void reset_smart_score(struct sched_rt_entity *rt_se)
 void smart_tick(int cpu);
 int smart_migrate_task(struct task_struct *p, int prev_cpu, int dest_cpu);
 void build_smart_topology(void);
+int smart_update_globally(void);
 
 #else /* CONFIG_SMART */
 static inline void build_smart_topology(void)
-- 
1.9.3

