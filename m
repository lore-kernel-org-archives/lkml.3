Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaATMlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:41:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51745 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaATMkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:07 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 08/11] sched: introduce a func ptr for sd topology flags
Date: Mon, 20 Jan 2014 12:39:45 +0000
Message-Id: <1390221588-20473-9-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:05.0176 (UTC) FILETIME=[BE999B80:01CF15DC]
X-MC-Unique: 114012012400604801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCgOAb003814

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

To be able to set sd topology flags via the topology_info[] table
dependent on runtime information (cpu feature or per cpu), this patch
changes the provision of the sd topology flags from a simple int to a func
ptr.

The default flags func ptr for SMT and MC level are defined in
include/linux/sched.h.  Since there are no sd topology flags for BOOK and
CPU level in the default topology info table, no default flags func ptr
for these level are defined.  The function sd_init() can handle the fact
that there is no sd devel flags func ptr defined.

The sd topology flags func ptr definition has an int cpu argument which is
only necessary when we start to set up sd topology flags differently for
different sched groups.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |   15 ++++++++++++++-
 kernel/sched/core.c   |   19 +++++++++++++------
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f79a0d5041fb..055d79e594ef 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2781,10 +2781,11 @@ static inline unsigned long rlimit_max(unsigned int limit)
 }
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+typedef int (*sched_domain_flags_f)(int cpu);
 
 struct sched_domain_topology_info {
 	sched_domain_mask_f mask;
-	int flags;
+	sched_domain_flags_f flags;
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
 #endif
@@ -2799,4 +2800,16 @@ struct sched_domain_topology_info {
 extern void
 set_sd_topology_info(struct sched_domain_topology_info *ti, unsigned int s);
 
+#ifdef CONFIG_SCHED_SMT
+static inline int cpu_smt_flags(int cpu)
+{
+	return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+}
+#endif
+
+static inline int cpu_coregroup_flags(int cpu)
+{
+	return SD_SHARE_PKG_RESOURCES;
+}
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9edd1d511f3c..79f34cc5f547 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5335,10 +5335,10 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
  */
 static struct sched_domain_topology_info default_topology_info[] = {
 #ifdef CONFIG_SCHED_SMT
-	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES, SD_NAME(SIBLING) },
+	{ cpu_smt_mask, cpu_smt_flags, SD_NAME(SIBLING) },
 #endif
 #ifdef CONFIG_SCHED_MC
-	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES, SD_NAME(MC) },
+	{ cpu_coregroup_mask, cpu_coregroup_flags, SD_NAME(MC) },
 #endif
 #ifdef CONFIG_SCHED_BOOK
 	{ cpu_book_mask, SD_NAME(BOOK) },
@@ -5374,6 +5374,11 @@ static const struct cpumask *sd_numa_mask(int cpu)
 	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
 }
 
+static int sd_numa_flags(int cpu)
+{
+	return SD_NUMA;
+}
+
 static void sched_numa_warn(const char *str)
 {
 	static int done = false;
@@ -5598,7 +5603,7 @@ static void sched_init_topology(void)
 	for (j = 0; j < level; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
 			.info.mask = sd_numa_mask,
-			.info.flags = SD_NUMA,
+			.info.flags = sd_numa_flags,
 			.flags = SDTL_OVERLAP,
 			.numa_level = j,
 		};
@@ -5613,6 +5618,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 {
 	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
 	int sd_weight;
+	int flags;
 
 #ifdef CONFIG_NUMA
 	/*
@@ -5622,10 +5628,11 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 #endif
 
 	sd_weight = cpumask_weight(tl->info.mask(cpu));
+	flags = tl->info.flags ? tl->info.flags(cpu) : 0;
 
-	if (WARN_ONCE(tl->info.flags & ~TOPOLOGY_SD_FLAGS,
+	if (WARN_ONCE(flags & ~TOPOLOGY_SD_FLAGS,
 			"wrong flags in topology info\n"))
-		tl->info.flags &= ~TOPOLOGY_SD_FLAGS;
+		flags &= ~TOPOLOGY_SD_FLAGS;
 
 	*sd = (struct sched_domain){
 				.min_interval  = sd_weight,
@@ -5638,7 +5645,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 						| 1*SD_BALANCE_EXEC
 						| 1*SD_BALANCE_FORK
 						| 1*SD_WAKE_AFFINE
-						| tl->info.flags
+						| flags
 						,
 
 				.last_balance     = jiffies,
-- 
1.7.9.5


