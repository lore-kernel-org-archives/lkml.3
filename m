Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3JVWMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:12:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34060 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3JVWMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:12:00 -0400
Date: Wed, 23 Oct 2013 00:11:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
Message-ID: <20131022221138.GJ2490@laptop.programming.kicks-ass.net>
References: <20131021114002.13291.31478.stgit@drishya>
 <20131021114442.13291.99344.stgit@drishya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021114442.13291.99344.stgit@drishya>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:14:42PM +0530, Vaidyanathan Srinivasan wrote:
>  kernel/sched/fair.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7c70201..12f0eab 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5807,12 +5807,19 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
> +		struct sched_domain *sd_parent = sd->parent;
> +		struct sched_group *sg;
> +		struct sched_group_power *sgp;
> +		int nr_busy;
> +
> +		if (sd_parent) {
> +			sg = sd_parent->groups;
> +			sgp = sg->sgp;
> +			nr_busy = atomic_read(&sgp->nr_busy_cpus);
> +
> +			if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
> +				goto need_kick_unlock;
> +		}
>  
>  		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
>  		    && (cpumask_first_and(nohz.idle_cpus_mask,
> 

Almost I'd say; what happens on !sd_parent && SD_ASYM_PACKING ?

Also, this made me look at the nr_busy stuff again, and somehow that
entire thing makes me a little sad.

Can't we do something like the below and cut that nr_busy sd iteration
short?

This nohz stuff really needs to be re-thought and made more scalable --
its a royal pain :/


 kernel/sched/core.c  |  4 ++++
 kernel/sched/fair.c  | 21 +++++++++++++++------
 kernel/sched/sched.h |  5 ++---
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c06b8d3..89db8dc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5271,6 +5271,7 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 DEFINE_PER_CPU(struct sched_domain *, sd_numa);
+DEFINE_PER_CPU(struct sched_domain *, sd_busy);
 
 static void update_top_cache_domain(int cpu)
 {
@@ -5290,6 +5291,9 @@ static void update_top_cache_domain(int cpu)
 
 	sd = lowest_flag_domain(cpu, SD_NUMA);
 	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
+
+	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING);
+	rcu_assign_pointer(per_cpu(sd_busy, cpu), sd);
 }
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 813dd61..3d5141e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6512,19 +6512,23 @@ static inline void nohz_balance_exit_idle(int cpu)
 	}
 }
 
-static inline void set_cpu_sd_state_busy(void)
+static inline void set_cpu_sd_state_busy(int cpu)
 {
 	struct sched_domain *sd;
+	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
+	sd = rcu_dereference_check_sched_domain(rq->sd);
 
 	if (!sd || !sd->nohz_idle)
 		goto unlock;
 	sd->nohz_idle = 0;
 
-	for (; sd; sd = sd->parent)
+	for (; sd; sd = sd->parent) {
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+		if (sd == per_cpu(sd_busy, cpu))
+			break;
+	}
 unlock:
 	rcu_read_unlock();
 }
@@ -6532,16 +6536,21 @@ static inline void set_cpu_sd_state_busy(void)
 void set_cpu_sd_state_idle(void)
 {
 	struct sched_domain *sd;
+	int cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
-	sd = rcu_dereference_check_sched_domain(this_rq()->sd);
+	sd = rcu_dereference_check_sched_domain(rq->sd);
 
 	if (!sd || sd->nohz_idle)
 		goto unlock;
 	sd->nohz_idle = 1;
 
-	for (; sd; sd = sd->parent)
+	for (; sd; sd = sd->parent) {
 		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+		if (sd == per_cpu(sd_busy, cpu))
+			break;
+	}
 unlock:
 	rcu_read_unlock();
 }
@@ -6756,7 +6765,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	* We may be recently in ticked or tickless idle mode. At the first
 	* busy tick after returning from idle, we will update the busy stats.
 	*/
-	set_cpu_sd_state_busy();
+	set_cpu_sd_state_busy(cpu);
 	nohz_balance_exit_idle(cpu);
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ffc7087..80c5fd2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -599,9 +599,8 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 	struct sched_domain *sd, *hsd = NULL;
 
 	for_each_domain(cpu, sd) {
-		if (!(sd->flags & flag))
-			break;
-		hsd = sd;
+		if (sd->flags & flag)
+			hsd = sd;
 	}
 
 	return hsd;

