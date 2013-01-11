Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3AKIRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:17:54 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46136 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3AKIRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:17:53 -0500
Message-ID: <50EFCAA7.8080302@linux.vnet.ibm.com>
Date: Fri, 11 Jan 2013 16:17:43 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 1/2] sched: schedule balance map foundation
References: <50EFCA29.8020801@linux.vnet.ibm.com>
In-Reply-To: <50EFCA29.8020801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011108-1396-0000-0000-000002671CBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get rid of the complex code in select_task_rq_fair(),
approach to directly get sd on each level with proper flag is
required.

Schedule balance map is the solution, which record the sd according
to it's flag and level.

For example, cpu_sbm->sd[wake][l] will locate the sd of cpu which
support wake up on level l.

In order to quickly locate the lower sd while changing the base cpu,
the level with empty sd in map will be filled with the lower sd.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/core.c  |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |   28 +++++++++++++++++++++++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..80810a3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5497,6 +5497,55 @@ static void update_top_cache_domain(int cpu)
 	per_cpu(sd_llc_id, cpu) = id;
 }
 
+DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
+
+static void build_sched_balance_map(int cpu)
+{
+	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+	struct sched_domain *sd = cpu_rq(cpu)->sd;
+	struct sched_domain *top_sd = NULL;
+	int i, type, level = 0;
+
+	while (sd) {
+		if (sd->flags & SD_LOAD_BALANCE) {
+			if (sd->flags & SD_BALANCE_EXEC) {
+				sbm->top_level[SBM_EXEC_TYPE] = sd->level;
+				sbm->sd[SBM_EXEC_TYPE][sd->level] = sd;
+			}
+
+			if (sd->flags & SD_BALANCE_FORK) {
+				sbm->top_level[SBM_FORK_TYPE] = sd->level;
+				sbm->sd[SBM_FORK_TYPE][sd->level] = sd;
+			}
+
+			if (sd->flags & SD_BALANCE_WAKE) {
+				sbm->top_level[SBM_WAKE_TYPE] = sd->level;
+				sbm->sd[SBM_WAKE_TYPE][sd->level] = sd;
+			}
+
+			if (sd->flags & SD_WAKE_AFFINE) {
+				for_each_cpu(i, sched_domain_span(sd)) {
+					if (!sbm->affine_map[i])
+						sbm->affine_map[i] = sd;
+				}
+			}
+		}
+		sd = sd->parent;
+	}
+
+	/*
+	 * fill the hole to get lower level sd easily.
+	 */
+	for (type = 0; type < SBM_MAX_TYPE; type++) {
+		level = sbm->top_level[type];
+		top_sd = sbm->sd[type][level];
+		if ((++level != SBM_MAX_LEVEL) && top_sd) {
+			for (; level < SBM_MAX_LEVEL; level++)
+				sbm->sd[type][level] = top_sd;
+		}
+	}
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -5506,6 +5555,9 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
+	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+
+	rcu_assign_pointer(rq->sbm, NULL);
 
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
@@ -5538,6 +5590,15 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	destroy_sched_domains(tmp, cpu);
 
 	update_top_cache_domain(cpu);
+
+	/*
+	 * synchronize_rcu() is unnecessary here since
+	 * destroy_sched_domains() already do the work.
+	 */
+	memset(sbm, 0, sizeof(*sbm));
+
+	build_sched_balance_map(cpu);
+	rcu_assign_pointer(rq->sbm, sbm);
 }
 
 /* cpus with isolated domains */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7a7db09..c91c6c7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -336,6 +336,33 @@ struct root_domain {
 
 extern struct root_domain def_root_domain;
 
+#ifdef CONFIG_SCHED_SMT
+#define SBM_MAX_LEVEL	4
+#else
+#ifdef CONFIG_SCHED_MC
+#define SBM_MAX_LEVEL	3
+#else
+#ifdef CONFIG_SCHED_BOOK
+#define SBM_MAX_LEVEL	2
+#else
+#define SBM_MAX_LEVEL	1
+#endif
+#endif
+#endif
+
+enum {
+	SBM_EXEC_TYPE,
+	SBM_FORK_TYPE,
+	SBM_WAKE_TYPE,
+	SBM_MAX_TYPE
+};
+
+struct sched_balance_map {
+	struct sched_domain *sd[SBM_MAX_TYPE][SBM_MAX_LEVEL];
+	int top_level[SBM_MAX_TYPE];
+	struct sched_domain *affine_map[NR_CPUS];
+};
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -403,6 +430,7 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
 	struct sched_domain *sd;
+	struct sched_balance_map *sbm;
 
 	unsigned long cpu_power;
 
-- 
1.7.4.1

