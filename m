Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3LMMLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:11:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50773 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3LMMLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:22 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 1/8] sched: arch interface for scheduler domain setup
Date: Fri, 13 Dec 2013 12:11:21 +0000
Message-Id: <1386936688-29113-2-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:19.0725 (UTC) FILETIME=[6E742DD0:01CEF7FC]
X-MC-Unique: 113121312112010601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCCX1w009918

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch defines an arch interface to provide the number of scheduler
domain levels, the pointer to the function returning the cpu mask and the
topology flags for each scheduler domain level.
The cpu mask getter functions for the smt and cpu level as well as the
function pointer sched_domain_mask_f have been moved from the scheduler
code into the topology header file.
The arch has to provide the arch_sched_domain_info array with an entry for
each scheduler domain level specifying the pointer to the cpu mask getter
function and the topology flags.
This patch covers all scheduler domain levels except NUMA levels.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/topology.h |   41 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c      |   13 -------------
 2 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 12ae6ce997d6..d147f63c2b1f 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -295,4 +295,45 @@ static inline int cpu_to_mem(int cpu)
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
+#ifdef CONFIG_SCHED_SMT
+static inline const struct cpumask *cpu_smt_mask(int cpu)
+{
+	return topology_thread_cpumask(cpu);
+}
+#endif
+
+static inline const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
+
+typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+
+typedef struct {
+	sched_domain_mask_f mask;
+	unsigned int flags;
+} arch_sched_domain_info_t;
+
+extern arch_sched_domain_info_t arch_sched_domain_info[];
+
+static inline unsigned int arch_sd_levels(void)
+{
+	unsigned int i;
+
+	for (i = 0; arch_sched_domain_info[i].mask; i++)
+		;
+
+	return i;
+}
+
+static inline sched_domain_mask_f arch_sd_mask(unsigned int i)
+{
+	return arch_sched_domain_info[i].mask;
+}
+
+static inline unsigned int arch_sd_flags(unsigned int i)
+{
+	return arch_sched_domain_info[i].flags;
+}
+
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e85cda20ab2b..fe21f7efb2ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4987,11 +4987,6 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-static const struct cpumask *cpu_cpu_mask(int cpu)
-{
-	return cpumask_of_node(cpu_to_node(cpu));
-}
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
@@ -5013,7 +5008,6 @@ enum s_alloc {
 struct sched_domain_topology_level;
 
 typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
-typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 #define SDTL_OVERLAP	0x01
 
@@ -5367,13 +5361,6 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 }
 
-#ifdef CONFIG_SCHED_SMT
-static const struct cpumask *cpu_smt_mask(int cpu)
-{
-	return topology_thread_cpumask(cpu);
-}
-#endif
-
 /*
  * Topology list, bottom-up.
  */
-- 
1.7.9.5


