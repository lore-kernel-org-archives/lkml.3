Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3LMMLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:11:45 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50952 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3LMML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:26 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 8/8] sched: remove scheduler domain naming
Date: Fri, 13 Dec 2013 12:11:28 +0000
Message-Id: <1386936688-29113-9-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:22.0929 (UTC) FILETIME=[705D1210:01CEF7FC]
X-MC-Unique: 113121312112410801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCBulw009906

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

In case the arch is allowed to define the conventional scheduler domain
topology level (i.e. the one without SD_NUMA topology flag) layout, it is
not feasible any more for the scheduler to name these levels.  Therefore,
this patch gets rid of of the sched_domain_topology_level structure
member 'name' and the corresponding SD_INIT_NAME macro.  It was only used
when CONFIG_SCHED_DEBUG was set any way.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |    3 ---
 kernel/sched/core.c   |   20 ++++----------------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 768b037dfacb..511700ddd7f7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -866,9 +866,6 @@ struct sched_domain {
 	unsigned int ttwu_move_affine;
 	unsigned int ttwu_move_balance;
 #endif
-#ifdef CONFIG_SCHED_DEBUG
-	char *name;
-#endif
 	union {
 		void *private;		/* used during construction */
 		struct rcu_head rcu;	/* used during destruction */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bb8e3e2e58a..e4f6a184333a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4302,7 +4302,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(13);
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
 
 	if (table == NULL)
 		return NULL;
@@ -4330,9 +4330,7 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[11], "name", sd->name,
-		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[12] is terminator */
+	/* &table[11] is terminator */
 
 	return table;
 }
@@ -4573,7 +4571,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
 
-	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
+	printk(KERN_DEBUG "%*s domain level %d: ", level, "", level);
 
 	if (!(sd->flags & SD_LOAD_BALANCE)) {
 		printk("does not load-balance\n");
@@ -4583,7 +4581,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span %s\n", str);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -5241,12 +5239,6 @@ int __weak arch_sd_sibling_asym_packing(void)
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
 
@@ -5494,7 +5486,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	if (sd->flags & SD_SHARE_CPUPOWER) {
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
-		SD_INIT_NAME(sd, SMT);
 	} else if (sd->flags & SD_SHARE_PKG_RESOURCES) {
 		sd->cache_nice_tries = 1;
 		sd->busy_idx = 2;
@@ -5507,7 +5498,6 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 		 */
 		sd->flags |= arch_sd_sibling_asym_packing();
 
-		SD_INIT_NAME(sd, MC);
 #ifdef CONFIG_NUMA
 	} else if (sd->flags & SD_NUMA) {
 		sd->busy_factor = 32,
@@ -5521,13 +5511,11 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 				       SD_BALANCE_FORK |
 				       SD_WAKE_AFFINE);
 		}
-		SD_INIT_NAME(sd, NUMA);
 #endif
 	} else {
 		sd->cache_nice_tries = 1;
 		sd->busy_idx = 2;
 		sd->idle_idx = 1;
-		SD_INIT_NAME(sd, CPU);
 	}
 
 	sd->private = &tl->data;
-- 
1.7.9.5


