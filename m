Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3JXIKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:10:48 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56405 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3JXIKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:10:44 -0400
Message-ID: <5268D54A.9060604@linux.vnet.ibm.com>
Date: Thu, 24 Oct 2013 13:37:38 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
References: <20131021114002.13291.31478.stgit@drishya> <20131021114442.13291.99344.stgit@drishya> <20131022221138.GJ2490@laptop.programming.kicks-ass.net> <52679BD6.6090507@linux.vnet.ibm.com> <CAKfTPtAUFdmc7PasebNksYztMwRrWsGWPgN6JJJurddu+UP-hQ@mail.gmail.com>
In-Reply-To: <CAKfTPtAUFdmc7PasebNksYztMwRrWsGWPgN6JJJurddu+UP-hQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102408-5490-0000-0000-00000460D26F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

I have addressed your comments and below is the fresh patch. This patch
applies on PATCH 2/3 posted in this thread.

Regards
Preeti U Murthy


sched:Remove un-necessary iterations over sched domains to update/query nr_busy_cpus

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

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
 kernel/sched/core.c  |    5 +++++
 kernel/sched/fair.c  |   38 ++++++++++++++++++++------------------
 kernel/sched/sched.h |    1 +
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c06b8d3..c540392 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5271,6 +5271,7 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 DEFINE_PER_CPU(struct sched_domain *, sd_numa);
+DEFINE_PER_CPU(struct sched_domain *, sd_busy);
 
 static void update_top_cache_domain(int cpu)
 {
@@ -5290,6 +5291,10 @@ static void update_top_cache_domain(int cpu)
 
 	sd = lowest_flag_domain(cpu, SD_NUMA);
 	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
+
+	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
+	if (sd)
+		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
 }
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e9c9549..f66cfd9 100644
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
+	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
+
+	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
+				  sched_domain_span(sd)) < cpu))
+		goto need_kick_unlock;
+
 	rcu_read_unlock();
 	return 0;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ffc7087..0f1253f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -623,6 +623,7 @@ DECLARE_PER_CPU(struct sched_domain *, sd_llc);
 DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
 DECLARE_PER_CPU(struct sched_domain *, sd_numa);
+DECLARE_PER_CPU(struct sched_domain *, sd_busy);
 
 struct sched_group_power {
 	atomic_t ref;

