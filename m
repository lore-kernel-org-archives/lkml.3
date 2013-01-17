Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab3AQFrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:47:48 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41161 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3AQFrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:47:47 -0500
Message-ID: <50F79079.504@linux.vnet.ibm.com>
Date: Thu, 17 Jan 2013 13:47:37 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Ram Pai <linuxram@us.ibm.com>
Subject: [RFC PATCH v2 1/3] sched: schedule balance map foundation
References: <50F79047.1080907@linux.vnet.ibm.com>
In-Reply-To: <50F79047.1080907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011705-6102-0000-0000-000002DDD1E3
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

This patch contain the foundation of schedule balance map in order
to serve the follow patches.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/core.c  |   44 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |   14 ++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..092c801 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5575,6 +5575,9 @@ static void update_top_cache_domain(int cpu)
 	per_cpu(sd_llc_id, cpu) = id;
 }
 
+static int sbm_max_level;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -6037,6 +6040,46 @@ static struct sched_domain_topology_level default_topology[] = {
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
 
+static void sched_init_sbm(void)
+{
+	size_t size;
+	int cpu, type, node;
+	struct sched_balance_map *sbm;
+	struct sched_domain_topology_level *tl;
+
+	/*
+	 * Inelegant method, any good idea?
+	 */
+	for (tl = sched_domain_topology; tl->init; tl++, sbm_max_level++)
+		;
+
+	for_each_possible_cpu(cpu) {
+		sbm = &per_cpu(sbm_array, cpu);
+		node = cpu_to_node(cpu);
+		size = sizeof(struct sched_domain *) * sbm_max_level;
+
+		for (type = 0; type < SBM_MAX_TYPE; type++) {
+			sbm->sd[type] = kmalloc_node(size, GFP_KERNEL, node);
+			WARN_ON(!sbm->sd[type]);
+			if (!sbm->sd[type])
+				goto failed;
+		}
+	}
+
+	return;
+
+failed:
+	for_each_possible_cpu(cpu) {
+		sbm = &per_cpu(sbm_array, cpu);
+
+		for (type = 0; type < SBM_MAX_TYPE; type++)
+			kfree(sbm->sd[type]);
+	}
+
+	/* prevent further work */
+	sbm_max_level = 0;
+}
+
 #ifdef CONFIG_NUMA
 
 static int sched_domains_numa_levels;
@@ -6765,6 +6808,7 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
 	sched_init_numa();
+	sched_init_sbm();
 
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..d060913 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -349,6 +349,19 @@ struct root_domain {
 
 extern struct root_domain def_root_domain;
 
+enum {
+	SBM_EXEC_TYPE,
+	SBM_FORK_TYPE,
+	SBM_WAKE_TYPE,
+	SBM_MAX_TYPE
+};
+
+struct sched_balance_map {
+	struct sched_domain **sd[SBM_MAX_TYPE];
+	int top_level[SBM_MAX_TYPE];
+	struct sched_domain *affine_map[NR_CPUS];
+};
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -416,6 +429,7 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
 	struct sched_domain *sd;
+	struct sched_balance_map *sbm;
 
 	unsigned long cpu_power;
 
-- 
1.7.4.1

