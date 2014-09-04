Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaIDQgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:36:39 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52244 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbaIDQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:36:34 -0400
X-Yandex-Uniq: e6771ddc-b398-457c-87dd-e7e345371364
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 01/19] smart: define and build per-core data structures
Date: Thu,  4 Sep 2014 20:30:47 +0400
Message-Id: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <77161409833206@webcorp01h.yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

First, this patch introduces the smart_core_data structure.
This structure contains following fields:
cpu_core_id - per-cpu core id (first SMT thread on this core)
core_next - id of next core on local node
core_node_sibling - id of corresponding core on next node
core_locked - per-core lock used for synchronizing core selection

The following macros/functions are introduced to access smart data:
cpu_core_id(cpu) - returns core id of CPU
smart_data(cpu) - returns per-core smart_data (macro)
core_next(cpu) - returns next core id of CPU
core_node_sibling(cpu) - returns id of sibling core on next node

Also, this patch introduces build_smart_topology() function,
which fills smart_core_data for each cpu.
Below is the illustration of how it's should look on 2-nodes CPU
with 8 physical cores and 16 SMT threads.

cpu    cpu_core_id
0,8              0
1,9              1
2,10             2
3,11             3
4,12             4
5,13             5
6,14             6
7,15             7

           node 0                              node 1
------------------------------      ------------------------------
core         0  core         1      core         4  core         5
core_next    1  core_next    2      core_next    5  core_next    6
node_sibling 4  node_sibling 5      node_sibling 0  node_sibling 1

core         2  core         3      core         6  core         7
core_next    3  core_next    0      core_next    7  core_next    4
node_sibling 6  node_sibling 7      node_sibling 2  node_sibling 3
------------------------------      ------------------------------

build_smart_topology() uses sched_domains data and is called
each time sched domains are rebuilt. If smart topology is built
successfully (checked by check_smart_data()),
__smart_initialized static key is set to true.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/core.c  |   3 +
 kernel/sched/rt.c    | 169 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |  40 ++++++++++++
 3 files changed, 212 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c771f25..14bcdd6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6671,6 +6671,7 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	err = build_sched_domains(doms_cur[0], NULL);
+	build_smart_topology();
 	register_sched_domain_sysctl();
 
 	return err;
@@ -6791,6 +6792,8 @@ match2:
 
 	register_sched_domain_sysctl();
 
+	build_smart_topology();
+
 	mutex_unlock(&sched_domains_mutex);
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2dffc7b..fed3992 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -7,6 +7,15 @@
 
 #include <linux/slab.h>
 
+#ifdef CONFIG_SMART
+#include <linux/jump_label.h>
+
+struct static_key __smart_initialized = STATIC_KEY_INIT_FALSE;
+DEFINE_MUTEX(smart_mutex);
+
+DEFINE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
+#endif /* CONFIG_SMART */
+
 int sched_rr_timeslice = RR_TIMESLICE;
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
@@ -2114,3 +2123,163 @@ void print_rt_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
+
+#ifdef CONFIG_SMART
+int check_smart_data(void)
+{
+	int cpu, core;
+	int iterations;
+
+	for_each_online_cpu(cpu) {
+		if (cpu_core_id(cpu) == -1 || next_core(cpu) == -1 ||
+		    core_node_sibling(cpu) == -1)
+			goto error;
+
+		if (!cpumask_test_cpu(cpu_core_id(cpu), cpu_online_mask))
+			goto error;
+
+		if (!cpumask_test_cpu(core_node_sibling(cpu), cpu_online_mask))
+			goto error;
+
+		iterations = 0;
+		core = cpu_core_id(cpu);
+		do {
+			if (core == -1)
+				goto error;
+			if (++iterations > NR_CPUS)
+				goto error;
+		} while (core = next_core(core), core != cpu_core_id(cpu));
+
+		iterations = 0;
+		core = core_node_sibling(cpu);
+		do {
+			if (core == -1)
+				goto error;
+			if (++iterations > NR_CPUS)
+				goto error;
+		} while (core = next_core(core), core != core_node_sibling(cpu));
+
+	}
+
+	return 0;
+
+error:
+	printk(KERN_INFO "smart: init error (cpu %d core %d next %d sibling %d)\n",
+	       cpu, cpu_core_id(cpu), next_core(cpu),  core_node_sibling(cpu));
+	return -1;
+}
+
+static int number_of_cpu(int cpu, cpumask_t *mask)
+{
+	int tmp;
+	int count = 0;
+
+	for_each_cpu(tmp, mask) {
+		if (tmp == cpu)
+			return count;
+		count++;
+	}
+
+	return -1;
+}
+
+static int cpu_with_number(int number, cpumask_t *mask)
+{
+	int tmp;
+	int count = 0;
+
+	for_each_cpu(tmp, mask) {
+		if (count == number)
+			return tmp;
+		count++;
+	}
+
+	return -1;
+}
+
+void build_smart_topology(void)
+{
+	int cpu;
+	int was_initialized;
+
+	mutex_lock(&smart_mutex);
+
+	was_initialized = static_key_enabled(&__smart_initialized);
+	if (was_initialized)
+		static_key_slow_dec(&__smart_initialized);
+	synchronize_rcu();
+
+	if (was_initialized)
+		printk(KERN_INFO "smart: disabled\n");
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		/* __cpu_core_id */
+		per_cpu(smart_core_data, cpu).cpu_core_id =
+			cpumask_first(topology_thread_cpumask(cpu));
+		if (per_cpu(smart_core_data, cpu).cpu_core_id < 0 ||
+		    per_cpu(smart_core_data, cpu).cpu_core_id >= nr_cpu_ids)
+			per_cpu(smart_core_data, cpu).cpu_core_id = cpu;
+
+		atomic_set(&per_cpu(smart_core_data, cpu).core_locked, 0);
+	}
+
+	rcu_read_lock();
+	for_each_online_cpu(cpu) {
+		struct sched_domain *sd;
+
+		/* core_node_sibling */
+		smart_data(cpu).core_node_sibling = -1;
+		for_each_domain(cpu, sd) {
+			struct sched_group *sg, *next_sg;
+			int number;
+
+			if (sd->flags & SD_SHARE_PKG_RESOURCES)
+				continue;
+
+			sg = sd->groups;
+			next_sg = sg->next;
+
+			if (sg == next_sg)
+				continue;
+
+			number = number_of_cpu(cpu, sched_group_cpus(sg));
+			if (number != -1) {
+				int sibling = cpu_with_number(number,
+							      sched_group_cpus(next_sg));
+				if (sibling != -1)
+					smart_data(cpu).core_node_sibling = cpu_core_id(sibling);
+			}
+		}
+
+		/* local_core_list */
+		smart_data(cpu).core_next = -1;
+		for_each_domain(cpu, sd) {
+			if (sd->flags & SD_SHARE_CPUPOWER)
+				continue;
+
+			if (likely(sd->groups)) {
+				struct sched_group *sg = sd->groups->next;
+				int next = group_first_cpu(sg);
+
+				if (next < nr_cpu_ids)
+					smart_data(cpu).core_next = cpu_core_id(next);
+			}
+
+			break;
+		}
+	}
+
+	if (!check_smart_data()) {
+		printk(KERN_INFO "smart: enabled\n");
+		static_key_slow_inc(&__smart_initialized);
+	}
+
+	rcu_read_unlock();
+
+	put_online_cpus();
+
+	mutex_unlock(&smart_mutex);
+}
+
+#endif /* CONFIG_SMART */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index dfa31d5..357736b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1378,3 +1378,43 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+#ifdef CONFIG_SMART
+struct smart_core_data {
+	int cpu_core_id;
+
+	/* Per core data, use smart_data macro for access */
+	int core_next;
+	int core_node_sibling;
+	atomic_t core_locked;
+} ____cacheline_aligned_in_smp;
+
+extern struct static_key __smart_initialized;
+
+DECLARE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
+
+static inline int cpu_core_id(int cpu)
+{
+	return per_cpu(smart_core_data, cpu).cpu_core_id;
+}
+
+#define smart_data(cpu) per_cpu(smart_core_data, cpu_core_id(cpu))
+
+static inline int core_node_sibling(int cpu)
+{
+	return smart_data(cpu).core_node_sibling;
+}
+
+static inline int next_core(int cpu)
+{
+	return smart_data(cpu).core_next;
+}
+
+void build_smart_topology(void);
+
+#else /* CONFIG_SMART */
+static inline void build_smart_topology(void)
+{
+}
+
+#endif /* CONFIG_SMART */
-- 
1.9.3

