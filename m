Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3J3DP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:15:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54181 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab3J3DP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:15:57 -0400
Subject: [PATCH V2 2/2] sched: Remove un-necessary iteration over sched
 domains to update nr_busy_cpus
To: peterz@infradead.org, mikey@neuling.org, svaidy@linux.vnet.ibm.com,
        mingo@kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: vincent.guittot@linaro.org, bitbucket@online.de, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, anton@samba.org,
        linuxppc-dev@lists.ozlabs.org, Morten.Rasmussen@arm.com,
        pjt@google.com
Date: Wed, 30 Oct 2013 08:42:52 +0530
Message-ID: <20131030031252.23426.4417.stgit@preeti.in.ibm.com>
In-Reply-To: <20131030031145.23426.22930.stgit@preeti.in.ibm.com>
References: <20131030031145.23426.22930.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103003-7182-0000-0000-000008F0B1A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_busy_cpus parameter is used by nohz_kick_needed() to find out the number
of busy cpus in a sched domain which has SD_SHARE_PKG_RESOURCES flag set.
Therefore instead of updating nr_busy_cpus at every level of sched domain,
since it is irrelevant, we can update this parameter only at the parent
domain of the sd which has this flag set. Introduce a per-cpu parameter
sd_busy which represents this parent domain.

In nohz_kick_needed() we directly query the nr_busy_cpus parameter
associated with the groups of sd_busy.

By associating sd_busy with the highest domain which has
SD_SHARE_PKG_RESOURCES flag set, we cover all lower level domains which could
have this flag set and trigger nohz_idle_balancing if any of the levels have
more than one busy cpu.

sd_busy is irrelevant for asymmetric load balancing.

While we are at it, we might as well change the nohz_idle parameter to be
updated at the sd_busy domain level alone and not the base domain level of a CPU.
This will unify the concept of busy cpus at just one level of sched domain
where it is currently used.

Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
---

 kernel/sched/core.c  |    6 ++++++
 kernel/sched/fair.c  |   38 ++++++++++++++++++++------------------
 kernel/sched/sched.h |    2 ++
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c06b8d3..e6a6244 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5271,6 +5271,8 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 DEFINE_PER_CPU(struct sched_domain *, sd_numa);
+DEFINE_PER_CPU(struct sched_domain *, sd_busy);
+DEFINE_PER_CPU(struct sched_domain *, sd_asym);
 
 static void update_top_cache_domain(int cpu)
 {
@@ -5282,6 +5284,7 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
+		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
 	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
@@ -5290,6 +5293,9 @@ static void update_top_cache_domain(int cpu)
 
 	sd = lowest_flag_domain(cpu, SD_NUMA);
 	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
+
+	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
+	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e9c9549..8602b2c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6515,16 +6515,16 @@ static inline void nohz_balance_exit_idle(int cpu)
 static inline void set_cpu_sd_state_busy(void)
 {
 	struct sched_domain *sd;
+	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
+	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
 	if (!sd || !sd->nohz_idle)
 		goto unlock;
 	sd->nohz_idle = 0;
 
-	for (; sd; sd = sd->parent)
-		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+	atomic_inc(&sd->groups->sgp->nr_busy_cpus);
 unlock:
 	rcu_read_unlock();
 }
@@ -6532,16 +6532,16 @@ unlock:
 void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
+	int cpu = smp_processor_id();
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
+	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
 	if (!sd || sd->nohz_idle)
 		goto unlock;
 	sd->nohz_idle = 1;
 
-	for (; sd; sd = sd->parent)
-		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+	atomic_dec(&sd->groups->sgp->nr_busy_cpus);
 unlock:
 	rcu_read_unlock();
 }
@@ -6748,6 +6748,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
+	struct sched_group_power *sgp;
+	int nr_busy;
 
 	if (unlikely(idle_cpu(cpu)))
 		return 0;
@@ -6773,22 +6775,22 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 		goto need_kick;
 
 	rcu_read_lock();
-	for_each_domain(cpu, sd) {
-		struct sched_group *sg = sd->groups;
-		struct sched_group_power *sgp = sg->sgp;
-		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
+	sd = rcu_dereference(per_cpu(sd_busy, cpu));
 
-		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
-			goto need_kick_unlock;
+	if (sd) {
+		sgp = sd->groups->sgp;
+		nr_busy = atomic_read(&sgp->nr_busy_cpus);
 
-		if (sd->flags & SD_ASYM_PACKING
-		    && (cpumask_first_and(nohz.idle_cpus_mask,
-					  sched_domain_span(sd)) < cpu))
+		if (nr_busy > 1)
 			goto need_kick_unlock;
-
-		if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
-			break;
 	}
+
+	sd = rcu_dereference(per_cpu(sd_asym, cpu));
+
+	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
+				  sched_domain_span(sd)) < cpu))
+		goto need_kick_unlock;
+
 	rcu_read_unlock();
 	return 0;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ffc7087..c8cb145 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -623,6 +623,8 @@ DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
 DECLARE_PER_CPU(struct sched_domain *, sd_numa);
+DECLARE_PER_CPU(struct sched_domain *, sd_busy);
+DECLARE_PER_CPU(struct sched_domain *, sd_asym);
 
 struct sched_group_power {
 	atomic_t ref;

