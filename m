Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3A2JJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:09:58 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58348 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3A2JJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:09:55 -0500
Message-ID: <510791D9.1040202@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 17:09:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [RFC PATCH v3 2/3] sched: build schedule balance map
References: <51079178.3070002@linux.vnet.ibm.com>
In-Reply-To: <51079178.3070002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012909-1396-0000-0000-00000279A2DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will build schedule balance map as designed, now
cpu_sbm->sd[f][l] can directly locate the sd of cpu on level 'l'
with flag 'f' supported.

In order to quickly locate the lower sd while changing the base cpu,
the level with empty sd in map will be filled with the lower sd.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/core.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 092c801..c2a13bc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5578,6 +5578,59 @@ static void update_top_cache_domain(int cpu)
 static int sbm_max_level;
 DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
 
+static void build_sched_balance_map(int cpu)
+{
+	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+	struct sched_domain *sd = cpu_rq(cpu)->sd;
+	int i, type, level = 0;
+
+	memset(sbm->top_level, 0, sizeof((*sbm).top_level));
+	memset(sbm->affine_map, 0, sizeof((*sbm).affine_map));
+	for (type = 0; type < SBM_MAX_TYPE; type++) {
+		memset(sbm->sd[type], 0,
+			sizeof(struct sched_domain *) * sbm_max_level);
+	}
+
+	while (sd) {
+		if (!(sd->flags & SD_LOAD_BALANCE))
+			continue;
+
+		if (sd->flags & SD_BALANCE_EXEC) {
+			sbm->top_level[SBM_EXEC_TYPE] = sd->level;
+			sbm->sd[SBM_EXEC_TYPE][sd->level] = sd;
+		}
+
+		if (sd->flags & SD_BALANCE_FORK) {
+			sbm->top_level[SBM_FORK_TYPE] = sd->level;
+			sbm->sd[SBM_FORK_TYPE][sd->level] = sd;
+		}
+
+		if (sd->flags & SD_BALANCE_WAKE) {
+			sbm->top_level[SBM_WAKE_TYPE] = sd->level;
+			sbm->sd[SBM_WAKE_TYPE][sd->level] = sd;
+		}
+
+		if (sd->flags & SD_WAKE_AFFINE) {
+			for_each_cpu(i, sched_domain_span(sd)) {
+				if (!sbm->affine_map[i])
+					sbm->affine_map[i] = sd;
+			}
+		}
+
+		sd = sd->parent;
+	}
+
+	/*
+	 * fill the hole to get lower level sd easily.
+	 */
+	for (type = 0; type < SBM_MAX_TYPE; type++) {
+		for (level = 1; level < sbm_max_level; level++) {
+			if (!sbm->sd[type][level])
+				sbm->sd[type][level] = sbm->sd[type][level - 1];
+		}
+	}
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -5587,6 +5640,9 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
+	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
+
+	rcu_assign_pointer(rq->sbm, NULL);
 
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
@@ -5619,6 +5675,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	destroy_sched_domains(tmp, cpu);
 
 	update_top_cache_domain(cpu);
+
+	/* disable sbm if initialization failed or sd detached. */
+	if (!sbm_max_level || !sd)
+		return;
+
+	/*
+	 * synchronize_rcu() is unnecessary here since
+	 * destroy_sched_domains() already do the work.
+	 */
+	build_sched_balance_map(cpu);
+	rcu_assign_pointer(rq->sbm, sbm);
 }
 
 /* cpus with isolated domains */
-- 
1.7.4.1

