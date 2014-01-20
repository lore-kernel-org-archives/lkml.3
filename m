Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaATMlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:41:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51718 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaATMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:07 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 07/11] sched: consolidate sched_init_numa() and sched_init_conv()
Date: Mon, 20 Jan 2014 12:39:44 +0000
Message-Id: <1390221588-20473-8-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:04.0722 (UTC) FILETIME=[BE545520:01CF15DC]
X-MC-Unique: 114012012400516901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCfu9v003806

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Consolidate sched_init_numa() and sched_init_conv() into one function
sched_init_topology().

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |  164 +++++++++++++++++++++------------------------------
 1 file changed, 68 insertions(+), 96 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 798a4d2c9d7b..9edd1d511f3c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5410,13 +5410,72 @@ static bool find_numa_distance(int distance)
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
+static void sched_init_topology(void)
 {
-	int next_distance, curr_distance = node_distance(0, 0);
 	struct sched_domain_topology_level *tl;
 	struct sched_domain_topology_info *ti = sched_domain_topology_info;
 	int level = 0;
-	int i, j, k;
+	int i;
+
+#ifdef CONFIG_NUMA
+	int next_distance, curr_distance = node_distance(0, 0);
+	int j, k;
 
 	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
 	if (!sched_domains_numa_distance)
@@ -5512,6 +5571,7 @@ static void sched_init_numa(void)
 			}
 		}
 	}
+#endif /* CONFIG_NUMA */
 
 	/*
 	 * An extra empty struct sched_domain_topology_level element at the end
@@ -5529,6 +5589,9 @@ static void sched_init_numa(void)
 	for (i = 0; i < sched_domain_topology_info_size; i++)
 		tl[i].info = ti[i];
 
+	sched_domain_topology = tl;
+
+#ifdef CONFIG_NUMA
 	/*
 	 * .. and append 'j' levels of NUMA goodness.
 	 */
@@ -5541,99 +5604,9 @@ static void sched_init_numa(void)
 		};
 	}
 
-	sched_domain_topology = tl;
-
 	sched_domains_numa_levels = level;
-}
-
-static void sched_init_conv(void)
-{
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
-static void sched_init_conv(void)
-{
-	struct sched_domain_topology_level *tl;
-	struct sched_domain_topology_info *ti = sched_domain_topology_info;
-	int i;
-
-	/*
-	 * An extra empty struct sched_domain_topology_level element at the end
-	 * of the array is needed to let for_each_sd_topology() work correctly.
-	 */
-	tl = kzalloc((sched_domain_topology_info_size + 1) *
-		sizeof(struct sched_domain_topology_level),
-		GFP_KERNEL);
-	if (!tl)
-		return;
-
-	/*
-	 * Copy the topology info bits..
-	 */
-	for (i = 0; i < sched_domain_topology_info_size; i++)
-		tl[i].info = ti[i];
-
-	sched_domain_topology = tl;
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
 
 static struct sched_domain *
 sd_init(struct sched_domain_topology_level *tl, int cpu)
@@ -6151,8 +6124,7 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
-	sched_init_conv();
-	sched_init_numa();
+	sched_init_topology();
 
 	/*
 	 * There's no userspace yet to cause hotplug operations; hence all the
-- 
1.7.9.5


