Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3LMMNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:13:01 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50833 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3LMMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:24 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 4/8] sched: allocate the entire topology array dynamically
Date: Fri, 13 Dec 2013 12:11:24 +0000
Message-Id: <1386936688-29113-5-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:21.0038 (UTC) FILETIME=[6F3C86E0:01CEF7FC]
X-MC-Unique: 113121312112204701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCD67t009930

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch prepares the scheduler domain level set up code to be able to
not rely on the default_topology[] any more.
The NUMA specific function sched_init_numa, renamed to sched_alloc(), is
now for all systems to allocate the memory for the
sched_domain_topology_level structures.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |  134 ++++++++++++++++++++++++++-------------------------
 1 file changed, 68 insertions(+), 66 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fe21f7efb2ee..b36a4edddc37 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5486,12 +5486,71 @@ static bool find_numa_distance(int distance)
 	return false;
 }
 
-static void sched_init_numa(void)
+static void sched_domains_numa_masks_set(int cpu)
+{
+	int i, j;
+	int node = cpu_to_node(cpu);
+
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++) {
+			if (node_distance(j, node) <= sched_domains_numa_distance[i])
+				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
+		}
+	}
+}
+
+static void sched_domains_numa_masks_clear(int cpu)
+{
+	int i, j;
+	for (i = 0; i < sched_domains_numa_levels; i++) {
+		for (j = 0; j < nr_node_ids; j++)
+			cpumask_clear_cpu(cpu, sched_domains_numa_masks[i][j]);
+	}
+}
+
+/*
+ * Update sched_domains_numa_masks[level][node] array when new cpus
+ * are onlined.
+ */
+static int sched_domains_numa_masks_update(struct notifier_block *nfb,
+					   unsigned long action,
+					   void *hcpu)
+{
+	int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+		sched_domains_numa_masks_set(cpu);
+		break;
+
+	case CPU_DEAD:
+		sched_domains_numa_masks_clear(cpu);
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+#else
+static int sched_domains_numa_masks_update(struct notifier_block *nfb,
+					   unsigned long action,
+					   void *hcpu)
+{
+	return 0;
+}
+#endif /* CONFIG_NUMA */
+
+static void sched_alloc(void)
 {
-	int next_distance, curr_distance = node_distance(0, 0);
 	struct sched_domain_topology_level *tl;
 	int level = 0;
-	int i, j, k;
+	int i;
+
+#ifdef CONFIG_NUMA
+	int next_distance, curr_distance = node_distance(0, 0);
+	int j, k;
 
 	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
 	if (!sched_domains_numa_distance)
@@ -5587,18 +5646,22 @@ static void sched_init_numa(void)
 			}
 		}
 	}
+#endif /* CONFIG_NUMA */
 
 	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
 
+	sched_domain_topology = tl;
+
 	/*
 	 * Copy the default topology bits..
 	 */
 	for (i = 0; default_topology[i].init; i++)
 		tl[i] = default_topology[i];
 
+#ifdef CONFIG_NUMA
 	/*
 	 * .. and append 'j' levels of NUMA goodness.
 	 */
@@ -5611,70 +5674,9 @@ static void sched_init_numa(void)
 		};
 	}
 
-	sched_domain_topology = tl;
-
 	sched_domains_numa_levels = level;
-}
-
-static void sched_domains_numa_masks_set(int cpu)
-{
-	int i, j;
-	int node = cpu_to_node(cpu);
-
-	for (i = 0; i < sched_domains_numa_levels; i++) {
-		for (j = 0; j < nr_node_ids; j++) {
-			if (node_distance(j, node) <= sched_domains_numa_distance[i])
-				cpumask_set_cpu(cpu, sched_domains_numa_masks[i][j]);
-		}
-	}
-}
-
-static void sched_domains_numa_masks_clear(int cpu)
-{
-	int i, j;
-	for (i = 0; i < sched_domains_numa_levels; i++) {
-		for (j = 0; j < nr_node_ids; j++)
-			cpumask_clear_cpu(cpu, sched_domains_numa_masks[i][j]);
-	}
-}
-
-/*
- * Update sched_domains_numa_masks[level][node] array when new cpus
- * are onlined.
- */
-static int sched_domains_numa_masks_update(struct notifier_block *nfb,
-					   unsigned long action,
-					   void *hcpu)
-{
-	int cpu = (long)hcpu;
-
-	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_ONLINE:
-		sched_domains_numa_masks_set(cpu);
-		break;
-
-	case CPU_DEAD:
-		sched_domains_numa_masks_clear(cpu);
-		break;
-
-	default:
-		return NOTIFY_DONE;
-	}
-
-	return NOTIFY_OK;
-}
-#else
-static inline void sched_init_numa(void)
-{
-}
-
-static int sched_domains_numa_masks_update(struct notifier_block *nfb,
-					   unsigned long action,
-					   void *hcpu)
-{
-	return 0;
-}
 #endif /* CONFIG_NUMA */
+}
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
@@ -6108,7 +6110,7 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
-	sched_init_numa();
+	sched_alloc();
 
 	/*
 	 * There's no userspace yet to cause hotplug operations; hence all the
-- 
1.7.9.5


