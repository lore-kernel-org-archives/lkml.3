Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaIDQbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:31:24 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:49861 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbaIDQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:19 -0400
X-Yandex-Uniq: 899a36d1-17e8-4a73-ae39-3ba63491e7b8
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 07/19] smart: balance load between nodes
Date: Thu,  4 Sep 2014 20:30:53 +0400
Message-Id: <1409848265-17150-7-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

Although previously introduced CPU selection logic isn't limited by
local node, if the number of rt tasks is smaller than the number of
physical cores per node, significant load imbalance can occur.

Modern CPUs tends to scale their's frequency depending on the number
of loaded CPUs, so such imbalance can lead to decreased per-CPU
performance on the more loaded node.

To solve this problem, this commit adds the following logic to CPU
selection logic: if the number of running rt processes on current node
is greater than on a remote node and the difference is more than 1/4 of
the number of rt tasks on local node, start search with corresponding
core on the remote node.

The number of rt tasks on each node is tracked with per-node atomic count.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/rt.c    | 22 ++++++++++++++++++++++
 kernel/sched/sched.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1993c47..3202ab4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -15,6 +15,7 @@ struct static_key __smart_enabled = STATIC_KEY_INIT_TRUE;
 DEFINE_MUTEX(smart_mutex);
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
+struct smart_node_data smart_node_data[MAX_NUMNODES] ____cacheline_aligned_in_smp;
 
 static int smart_find_lowest_rq(struct task_struct *task, bool wakeup);
 
@@ -1218,6 +1219,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 
+	inc_node_running(cpu_of(rq));
 	inc_nr_running(rq);
 	release_core(cpu_of(rq));
 }
@@ -1231,6 +1233,7 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	dequeue_pushable_task(rq, p);
 
+	dec_node_running(cpu_of(rq));
 	dec_nr_running(rq);
 }
 
@@ -2316,12 +2319,31 @@ static int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
 	int prev_cpu = task_cpu(task);
 	int best_cpu;
 	int attempts;
+	int this_node_rt, other_node_rt;
+	int node, this_node;
 
 	if (task->nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
 	rcu_read_lock();
 
+	if (wakeup) {
+		this_node = cpu_to_node(prev_cpu);
+		this_node_rt = node_running(this_node);
+
+		for_each_online_node(node) {
+			if (node == this_node)
+				continue;
+
+			other_node_rt = node_running(node);
+
+			if (this_node_rt > other_node_rt &&
+			    ((this_node_rt - other_node_rt) * 4 > this_node_rt)) {
+				this_node_rt = other_node_rt;
+				prev_cpu = core_node_sibling(prev_cpu);
+			}
+		}
+	}
 
 	for (attempts = 3; attempts; attempts--) {
 		best_cpu = find_rt_free_core(prev_cpu, task);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b662a89..dd539ca 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1390,10 +1390,15 @@ struct smart_core_data {
 	atomic_t core_locked;
 } ____cacheline_aligned_in_smp;
 
+struct smart_node_data {
+	atomic_t nr_rt_running;
+} ____cacheline_aligned_in_smp;
+
 extern struct static_key __smart_initialized;
 extern struct static_key __smart_enabled;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
+extern struct smart_node_data smart_node_data[MAX_NUMNODES];
 
 static inline int cpu_core_id(int cpu)
 {
@@ -1401,6 +1406,7 @@ static inline int cpu_core_id(int cpu)
 }
 
 #define smart_data(cpu) per_cpu(smart_core_data, cpu_core_id(cpu))
+#define smart_node_ptr(cpu) smart_node_data[cpu_to_node(cpu)]
 
 static inline bool smart_enabled(void)
 {
@@ -1433,6 +1439,21 @@ static inline int core_acquired(int cpu)
 	return atomic_read(&smart_data(cpu).core_locked);
 }
 
+static inline void inc_node_running(int cpu)
+{
+	atomic_inc(&smart_node_ptr(cpu).nr_rt_running);
+}
+
+static inline void dec_node_running(int cpu)
+{
+	atomic_dec(&smart_node_ptr(cpu).nr_rt_running);
+}
+
+static inline int node_running(int node)
+{
+	return atomic_read(&smart_node_data[node].nr_rt_running);
+}
+
 static inline int core_is_rt_free(int core)
 {
 	struct rq *rq;
@@ -1560,4 +1581,12 @@ static inline void release_core(int cpu)
 {
 }
 
+static inline void inc_node_running(int cpu)
+{
+}
+
+static inline void dec_node_running(int cpu)
+{
+}
+
 #endif /* CONFIG_SMART */
-- 
1.9.3

