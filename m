Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaIDQbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:31:22 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:49857 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbaIDQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:17 -0400
X-Yandex-Uniq: 59566a5b-5f9f-4380-a06f-338d0324c0df
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 04/19] smart: helper functions for smart_data manipulations
Date: Thu,  4 Sep 2014 20:30:50 +0400
Message-Id: <1409848265-17150-4-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This commit adds the following helper functions:
acquire_core() - acquires per-core lock
release_core() - releases per-core lock
core_acquired() - checks if per-core lock is acquired
core_is_rt_free() - checks if there are no rt tasks on specified core
core_rt_free_thread() - finds free SMT thread on specified core
find_rt_free_core() - finds free core starting with specified core

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/sched.h | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7e26454..4603096 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1418,6 +1418,89 @@ static inline int next_core(int cpu)
 	return smart_data(cpu).core_next;
 }
 
+static inline int acquire_core(int cpu)
+{
+	return (0 == atomic_cmpxchg(&smart_data(cpu).core_locked, 0, 1));
+}
+
+static inline void release_core(int cpu)
+{
+	atomic_set(&smart_data(cpu).core_locked, 0);
+}
+
+static inline int core_acquired(int cpu)
+{
+	return atomic_read(&smart_data(cpu).core_locked);
+}
+
+static inline int core_is_rt_free(int core)
+{
+	struct rq *rq;
+	int cpu;
+	unsigned int nr_rt;
+	struct task_struct *task;
+
+	for_each_cpu(cpu, topology_thread_cpumask(core)) {
+		rq = cpu_rq(cpu);
+
+		if (rq->rt.rt_throttled)
+			return 0;
+
+		nr_rt = rq->rt.rt_nr_running;
+		if (nr_rt) {
+			if (nr_rt > 1)
+				return 0;
+
+			task = ACCESS_ONCE(rq->curr);
+			if (task->mm)
+				return 0;
+		}
+	}
+
+	return 1;
+}
+
+static inline int core_rt_free_thread(int core)
+{
+	struct rq *rq;
+	int cpu;
+
+	for_each_cpu(cpu, topology_thread_cpumask(core)) {
+		rq = cpu_rq(cpu);
+
+		if (rq->rt.rt_throttled)
+			continue;
+
+		if (!rq->rt.rt_nr_running)
+			return cpu;
+	}
+
+	return -1;
+}
+
+static inline int find_rt_free_core(int start_cpu, struct task_struct *task)
+{
+	int core;
+
+	/* Local cores */
+	core = cpu_core_id(start_cpu);
+	do {
+		if (!core_acquired(core) && core_is_rt_free(core) &&
+		    cpumask_test_cpu(core, tsk_cpus_allowed(task)))
+			return core;
+	} while (core = next_core(core), core != cpu_core_id(start_cpu));
+
+	/* Remote cores */
+	core = core_node_sibling(start_cpu);
+	do {
+		if (!core_acquired(core) && core_is_rt_free(core) &&
+		    cpumask_test_cpu(core, tsk_cpus_allowed(task)))
+			return core;
+	} while (core = next_core(core), core != core_node_sibling(start_cpu));
+
+	return -1;
+}
+
 void build_smart_topology(void);
 
 #else /* CONFIG_SMART */
@@ -1430,4 +1513,8 @@ static inline bool smart_enabled(void)
 	return false;
 }
 
+static inline void release_core(int cpu)
+{
+}
+
 #endif /* CONFIG_SMART */
-- 
1.9.3

