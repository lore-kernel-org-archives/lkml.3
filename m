Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaE0Rus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:50:48 -0400
Received: from relais.videotron.ca ([24.201.245.36]:34714 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE0Rur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:50:47 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 7/6] sched: rename capacity related flags
Date: Tue, 27 May 2014 13:50:41 -0400
Message-id: <1401213041-18292-1-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better not to think about compute capacity as being equivalent
to "CPU power".  The upcoming "power aware" scheduler work may create
confusion with the notion of energy consumption if "power" is used too
liberally.

Let's rename the following feature flags since they do relate to capacity:

	SD_SHARE_CPUPOWER  -> SD_SHARE_CPUCAPACITY
	ARCH_POWER         -> ARCH_CAPACITY
	NONTASK_POWER      -> NONTASK_CAPACITY

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 arch/powerpc/kernel/smp.c |  2 +-
 include/linux/sched.h     |  4 ++--
 kernel/sched/core.c       | 14 +++++++-------
 kernel/sched/fair.c       |  8 ++++----
 kernel/sched/features.h   |  8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 10ffffef04..c51d16379c 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -770,7 +770,7 @@ int setup_profiling_timer(unsigned int multiplier)
 /* cpumask of CPUs with asymetric SMT dependancy */
 static const int powerpc_smt_flags(void)
 {
-	int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+	int flags = SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 
 	if (cpu_has_feature(CPU_FTR_ASYM_SMT)) {
 		printk_once(KERN_INFO "Enabling Asymmetric SMT scheduling\n");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c7f473a54d..2c4e58cbbf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -869,7 +869,7 @@ enum cpu_idle_type {
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-#define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_SHARE_CPUCAPACITY	0x0080	/* Domain members share cpu power */
 #define SD_SHARE_POWERDOMAIN	0x0100	/* Domain members share power domain */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
@@ -881,7 +881,7 @@ enum cpu_idle_type {
 #ifdef CONFIG_SCHED_SMT
 static inline const int cpu_smt_flags(void)
 {
-	return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
+	return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6d376d6560..f61769a885 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -888,7 +888,7 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
 	rq->clock_task += delta;
 
 #if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
-	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
+	if ((irq_delta + steal) && sched_feat(NONTASK_CAPACITY))
 		sched_rt_avg_update(rq, irq_delta + steal);
 #endif
 }
@@ -5333,7 +5333,7 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_NEWIDLE |
 			 SD_BALANCE_FORK |
 			 SD_BALANCE_EXEC |
-			 SD_SHARE_CPUPOWER |
+			 SD_SHARE_CPUCAPACITY |
 			 SD_SHARE_PKG_RESOURCES |
 			 SD_SHARE_POWERDOMAIN)) {
 		if (sd->groups != sd->groups->next)
@@ -5364,7 +5364,7 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 				SD_BALANCE_NEWIDLE |
 				SD_BALANCE_FORK |
 				SD_BALANCE_EXEC |
-				SD_SHARE_CPUPOWER |
+				SD_SHARE_CPUCAPACITY |
 				SD_SHARE_PKG_RESOURCES |
 				SD_PREFER_SIBLING |
 				SD_SHARE_POWERDOMAIN);
@@ -5971,7 +5971,7 @@ static int sched_domains_curr_level;
 /*
  * SD_flags allowed in topology descriptions.
  *
- * SD_SHARE_CPUPOWER      - describes SMT topologies
+ * SD_SHARE_CPUCAPACITY      - describes SMT topologies
  * SD_SHARE_PKG_RESOURCES - describes shared caches
  * SD_NUMA                - describes NUMA topologies
  * SD_SHARE_POWERDOMAIN   - describes shared power domain
@@ -5980,7 +5980,7 @@ static int sched_domains_curr_level;
  * SD_ASYM_PACKING        - describes SMT quirks
  */
 #define TOPOLOGY_SD_FLAGS		\
-	(SD_SHARE_CPUPOWER |		\
+	(SD_SHARE_CPUCAPACITY |		\
 	 SD_SHARE_PKG_RESOURCES |	\
 	 SD_NUMA |			\
 	 SD_ASYM_PACKING |		\
@@ -6026,7 +6026,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 					| 1*SD_BALANCE_FORK
 					| 0*SD_BALANCE_WAKE
 					| 1*SD_WAKE_AFFINE
-					| 0*SD_SHARE_CPUPOWER
+					| 0*SD_SHARE_CPUCAPACITY
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 0*SD_SERIALIZE
 					| 0*SD_PREFER_SIBLING
@@ -6048,7 +6048,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 	 * Convert topological properties into behaviour.
 	 */
 
-	if (sd->flags & SD_SHARE_CPUPOWER) {
+	if (sd->flags & SD_SHARE_CPUCAPACITY) {
 		sd->imbalance_pct = 110;
 		sd->smt_gain = 1178; /* ~15% */
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5b7e3465cf..665cc4ef82 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5670,8 +5670,8 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 	unsigned long capacity = SCHED_CAPACITY_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		if (sched_feat(ARCH_POWER))
+	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
+		if (sched_feat(ARCH_CAPACITY))
 			capacity *= arch_scale_smt_capacity(sd, cpu);
 		else
 			capacity *= default_scale_smt_capacity(sd, cpu);
@@ -5681,7 +5681,7 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
 
 	sdg->sgc->capacity_orig = capacity;
 
-	if (sched_feat(ARCH_POWER))
+	if (sched_feat(ARCH_CAPACITY))
 		capacity *= arch_scale_freq_capacity(sd, cpu);
 	else
 		capacity *= default_scale_capacity(sd, cpu);
@@ -5780,7 +5780,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	/*
 	 * Only siblings can have significantly less than SCHED_CAPACITY_SCALE
 	 */
-	if (!(sd->flags & SD_SHARE_CPUPOWER))
+	if (!(sd->flags & SD_SHARE_CPUCAPACITY))
 		return 0;
 
 	/*
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 5716929a2e..90284d117f 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -37,18 +37,18 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
 SCHED_FEAT(WAKEUP_PREEMPTION, true)
 
 /*
- * Use arch dependent cpu power functions
+ * Use arch dependent cpu capacity functions
  */
-SCHED_FEAT(ARCH_POWER, true)
+SCHED_FEAT(ARCH_CAPACITY, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
 SCHED_FEAT(LB_BIAS, true)
 
 /*
- * Decrement CPU power based on time not spent running tasks
+ * Decrement CPU capacity based on time not spent running tasks
  */
-SCHED_FEAT(NONTASK_POWER, true)
+SCHED_FEAT(NONTASK_CAPACITY, true)
 
 /*
  * Queue remote wakeups on the target CPU and process them
-- 
1.8.4.108.g55ea5f6

