Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3LMMMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:12:32 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50866 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3LMMLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:24 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 5/8] sched: introduce common topology level init function
Date: Fri, 13 Dec 2013 12:11:25 +0000
Message-Id: <1386936688-29113-6-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:21.0475 (UTC) FILETIME=[6F7F3530:01CEF7FC]
X-MC-Unique: 113121312112300601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCCdoq009922

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch introduces the common scheduler domain level init function
sd_init and the definition of the topology related scheduler domain flags.
The sd_init function bases on the idea of Peter Zijlstra:
https://lkml.org/lkml/2013/11/5/239.
It should replace all default SD_FOO_INIT macros and the one defined in
the archs as well as the sd_numa_init function.  The [min|max]_interval
and the balance_interval values are now calculated based on the cpu mask
weight. Fine tuning of the scheduler domains is done based on topology
flags.
The topology information provided by the topology flags has to be
converted into scheduler behaviour, i.e. that based on the topology flags
the various struct sched_domain data members have to be tuned.
The related if/else condition construct works in the following order:
SD_SHARE_CPUPOWER flag indicates SMT level, SD_SHARE_PKG_RESOURCES
flag MC level, SD_NUMA flag one of the NUMA levels and the final else
condition indicates CPU level.  By providing the arch the possibility to
specify the topology flags, we obviously rely on correctly configured
arch_sched_domain_info array here.
The sd_init function still calls arch_sd_sibling_asym_packing which is
only used by the powerpc arch.  If the SD_ASYM_PACKING flag will be set
via the arch_sched_domain_info array the arch_sd_sibling_asym_packing
function can be deleted.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c  |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |   19 +++++++++++
 2 files changed, 105 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b36a4edddc37..37febb067bad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5542,6 +5542,92 @@ static int sched_domains_numa_masks_update(struct notifier_block *nfb,
 }
 #endif /* CONFIG_NUMA */
 
+static struct sched_domain *
+sd_init(struct sched_domain_topology_level *tl, int cpu)
+{
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
+	int sd_weight;
+
+#ifdef CONFIG_NUMA
+	/*
+	 * Ugly hack to pass state to sd_numa_mask()...
+	 */
+	sched_domains_curr_level = tl->numa_level;
+#endif
+
+	sd_weight = cpumask_weight(tl->mask(cpu));
+
+	if (WARN_ONCE((tl->flags & ~SDTL_OVERLAP) & ~TOPOLOGY_SD_FLAGS,
+			"wrong sd_flags in topology description\n"))
+		tl->flags &= ~TOPOLOGY_SD_FLAGS;
+
+	*sd = (struct sched_domain){
+				.min_interval  = sd_weight,
+				.max_interval  = 2*sd_weight,
+				.busy_factor   = 64,
+				.imbalance_pct = 125,
+
+				.flags =  1*SD_LOAD_BALANCE
+						| 1*SD_BALANCE_NEWIDLE
+						| 1*SD_BALANCE_EXEC
+						| 1*SD_BALANCE_FORK
+						| 1*SD_WAKE_AFFINE
+						,
+
+				.last_balance     = jiffies,
+				.balance_interval = sd_weight,
+	};
+
+	sd->flags |= (tl->flags & ~SDTL_OVERLAP);
+
+	/*
+	 * Convert topological properties into behaviour.
+	 */
+
+	if (sd->flags & SD_SHARE_CPUPOWER) {
+		sd->imbalance_pct = 110;
+		sd->smt_gain = 1178; /* ~15% */
+		SD_INIT_NAME(sd, SMT);
+	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+
+		/*
+		 * Call SMT specific arch topology function.
+		 * This goes away once the powerpc arch uses
+		 * the new interface for scheduler domain
+		 * setup.
+		 */
+		sd->flags |= arch_sd_sibling_asym_packing();
+
+		SD_INIT_NAME(sd, MC);
+#ifdef CONFIG_NUMA
+	} else if (sd->flags & SD_NUMA) {
+		sd->busy_factor = 32,
+		sd->cache_nice_tries = 2;
+		sd->busy_idx = 3;
+		sd->idle_idx = 2;
+		sd->flags |= SD_SERIALIZE;
+		if (sched_domains_numa_distance[tl->numa_level]
+				> RECLAIM_DISTANCE) {
+			sd->flags &= ~(SD_BALANCE_EXEC |
+				       SD_BALANCE_FORK |
+				       SD_WAKE_AFFINE);
+		}
+		SD_INIT_NAME(sd, NUMA);
+#endif
+	} else {
+		sd->cache_nice_tries = 1;
+		sd->busy_idx = 2;
+		sd->idle_idx = 1;
+		SD_INIT_NAME(sd, CPU);
+	}
+
+	sd->private = &tl->data;
+
+	return sd;
+}
+
 static void sched_alloc(void)
 {
 	struct sched_domain_topology_level *tl;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 88c85b21d633..d4d7dbe716db 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1414,3 +1414,22 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+/*
+ * SD_flags allowed in topology descriptions.
+ *
+ * SD_SHARE_CPUPOWER      - describes SMT topologies
+ * SD_SHARE_PKG_RESOURCES - describes shared caches
+ * SD_NUMA                - describes NUMA topologies
+ *
+ * Odd one out:
+ * SD_ASYM_PACKING        - describes SMT quirks
+ *
+ * SD_PREFER_SIBLING      - describes preference for sibling domain
+ */
+#define TOPOLOGY_SD_FLAGS         \
+	(SD_SHARE_CPUPOWER |      \
+	 SD_SHARE_PKG_RESOURCES | \
+	 SD_NUMA |                \
+	 SD_ASYM_PACKING |        \
+	 SD_PREFER_SIBLING)
-- 
1.7.9.5


