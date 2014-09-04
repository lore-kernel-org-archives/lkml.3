Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaIDQgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:36:36 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52242 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbaIDQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:36:34 -0400
X-Yandex-Uniq: 992f9b73-9246-4026-b77f-be0013cbc4f3
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 05/19] smart: CPU selection logic
Date: Thu,  4 Sep 2014 20:30:51 +0400
Message-Id: <1409848265-17150-5-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This commit contains the most important code: CPU selection logic.
It's implemented by smart_find_lowest_rq() function and some helper
functions.

The logic is relatively simple:
1) try to find free core on local node (starting with previous task's CPU)
2) try to find free core on next remote node
3) try to find free SMT thread on local node
4) try to find free SMT thread on remote node
5) try to find SMT thread with minimum rt tasks

If we find free CPU on any step we try to acquire it and if it's successful we
stop further processing and quit; otherwise, if CPU is locked, we restart the
search.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/rt.c    | 32 ++++++++++++++++++++++++++++++++
 kernel/sched/sched.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c71b9a3..805951b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2286,4 +2286,36 @@ void build_smart_topology(void)
 	mutex_unlock(&smart_mutex);
 }
 
+static int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
+{
+	int prev_cpu = task_cpu(task);
+	int best_cpu;
+	int attempts;
+
+	if (task->nr_cpus_allowed == 1)
+		return -1; /* No other targets possible */
+
+	rcu_read_lock();
+
+
+	for (attempts = 3; attempts; attempts--) {
+		best_cpu = find_rt_free_core(prev_cpu, task);
+		if (best_cpu == -1) {
+			best_cpu = find_rt_best_thread(prev_cpu, task);
+
+			break;
+		}
+
+		if (!acquire_core(best_cpu))
+			continue;
+
+		if (likely(core_is_rt_free(best_cpu)))
+			break;
+
+		release_core(best_cpu);
+	}
+
+	rcu_read_unlock();
+	return best_cpu;
+}
 #endif /* CONFIG_SMART */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4603096..b662a89 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1501,6 +1501,49 @@ static inline int find_rt_free_core(int start_cpu, struct task_struct *task)
 	return -1;
 }
 
+static inline int find_rt_best_thread(int start_cpu, struct task_struct *task)
+{
+	int core;
+	int cpu;
+	struct rq *rq;
+	unsigned int min_running = 2;
+	int best_cpu = -1;
+	int nr_running;
+
+	/* Local cores */
+	core = cpu_core_id(start_cpu);
+	do {
+		cpu = core_rt_free_thread(core);
+		if (cpu != -1 && cpumask_test_cpu(cpu, tsk_cpus_allowed(task)))
+			return cpu;
+	} while (core = next_core(core), core != cpu_core_id(start_cpu));
+
+	/* Remote cores */
+	core = core_node_sibling(start_cpu);
+	do {
+		cpu = core_rt_free_thread(core);
+		if (cpu != -1 && cpumask_test_cpu(cpu, tsk_cpus_allowed(task)))
+			return cpu;
+	} while (core = next_core(core), core != core_node_sibling(start_cpu));
+
+	/* Find local thread with min. number of tasks */
+	for_each_cpu(cpu, topology_core_cpumask(start_cpu)) {
+		rq = cpu_rq(cpu);
+		nr_running = rq->rt.rt_nr_running;
+		if (nr_running < min_running &&
+		    cpumask_test_cpu(cpu, tsk_cpus_allowed(task))) {
+			min_running = nr_running;
+			best_cpu = cpu;
+		}
+	}
+
+	if (best_cpu != -1 &&
+	    min_running == cpu_rq(start_cpu)->rt.rt_nr_running)
+		best_cpu = -1;
+
+	return best_cpu;
+}
+
 void build_smart_topology(void);
 
 #else /* CONFIG_SMART */
-- 
1.9.3

