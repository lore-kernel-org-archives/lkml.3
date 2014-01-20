Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaATMmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:42:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51659 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaATMkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:06 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 05/11] sched: add a name to sched_domain_topology_info
Date: Mon, 20 Jan 2014 12:39:42 +0000
Message-Id: <1390221588-20473-6-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:03.0816 (UTC) FILETIME=[BDCA1680:01CF15DC]
X-MC-Unique: 114012012400408501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KChKpi003826

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

With this patch, an arbitrary name for a sd level has to be specified in
the topology info table. This feature is still only active if
CONFIG_SCHED_DEBUG is set.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |   11 ++++++++++-
 kernel/sched/core.c   |   23 +++++++----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index bf2ee608af67..f79a0d5041fb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2784,9 +2784,18 @@ typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 struct sched_domain_topology_info {
 	sched_domain_mask_f mask;
-	int		    flags;
+	int flags;
+#ifdef CONFIG_SCHED_DEBUG
+	char *name;
+#endif
 };
 
+#ifdef CONFIG_SCHED_DEBUG
+# define SD_NAME(n)		.name = #n
+#else
+# define SD_NAME(n)
+#endif
+
 extern void
 set_sd_topology_info(struct sched_domain_topology_info *ti, unsigned int s);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 90aa7c3d3a00..798a4d2c9d7b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5243,12 +5243,6 @@ int __weak arch_sd_sibling_asym_packing(void)
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
  */
 
-#ifdef CONFIG_SCHED_DEBUG
-# define SD_INIT_NAME(sd, type)		sd->name = #type
-#else
-# define SD_INIT_NAME(sd, type)		do { } while (0)
-#endif
-
 static int default_relax_domain_level = -1;
 int sched_domain_level_max;
 
@@ -5341,15 +5335,15 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
  */
 static struct sched_domain_topology_info default_topology_info[] = {
 #ifdef CONFIG_SCHED_SMT
-	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES },
+	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES, SD_NAME(SIBLING) },
 #endif
 #ifdef CONFIG_SCHED_MC
-	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
+	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_NAME(MC) },
 #endif
 #ifdef CONFIG_SCHED_BOOK
-	{ cpu_book_mask, },
+	{ cpu_book_mask, SD_NAME(BOOK) },
 #endif
-	{ cpu_cpu_mask, },
+	{ cpu_cpu_mask, SD_NAME(CPU) },
 };
 
 static struct sched_domain_topology_level *sched_domain_topology;
@@ -5676,6 +5670,9 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 
 				.last_balance     = jiffies,
 				.balance_interval = sd_weight,
+#ifdef CONFIG_SCHED_DEBUG
+				.name             = tl->info.name,
+#endif
 	};
 
 	/*
@@ -5693,13 +5690,9 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 		 * setup.
 		 */
 		sd->flags |= arch_sd_sibling_asym_packing();
-
-		SD_INIT_NAME(sd, SMT);
 	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
 		sd->cache_nice_tries = 1;
 		sd->busy_idx = 2;
-
-		SD_INIT_NAME(sd, MC);
 #ifdef CONFIG_NUMA
 	} else if (sd->flags & SD_NUMA) {
 		sd->busy_factor = 32,
@@ -5719,8 +5712,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 		sd->busy_idx = 2;
 		sd->idle_idx = 1;
 		sd->flags |= SD_PREFER_SIBLING;
-
-		SD_INIT_NAME(sd, CPU);
 	}
 
 	sd->private = &tl->data;
-- 
1.7.9.5


