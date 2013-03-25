Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3CYPjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:39:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49248 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414Ab3CYPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:39:22 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        vincent.guittot@linaro.org
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, corbet@lwn.net, amit.kucheria@linaro.org,
        robin.randhawa@arm.com, morten.rasmussen@arm.com
Subject: [RFC PATCH 1/2] sched: Force migration on a better cpu
Date: Mon, 25 Mar 2013 15:40:05 +0000
Message-Id: <1364226006-21419-2-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364226006-21419-1-git-send-email-morten.rasmussen@arm.com>
References: <1364226006-21419-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 25 Mar 2013 15:39:20.0619 (UTC) FILETIME=[EB0137B0:01CE296E]
X-MC-Unique: 113032515392013801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PFdZ9k028451

From: Vincent Guittot <vincent.guittot@linaro.org>

In a system with different cpu_power for cpus, we can fall in a
situation where a heavy task runs on a cpu with a lower cpu_power
which by definition means lower compute capacity and lower
performance. We can detect this scenario and force the task to migrate
to a cpu with higher compute capacity to improve performance for
demanding tasks.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4243143..4781cdd 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4444,7 +4444,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
 	unsigned long load, max_cpu_load, min_cpu_load;
-	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned int balance_cpu = -1, first_idle_cpu = 0, overloaded_cpu = 0;
 	unsigned long avg_load_per_task = 0;
 	int i;
 
@@ -4482,6 +4482,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 				max_nr_running = nr_running;
 			if (min_nr_running > nr_running)
 				min_nr_running = nr_running;
+
+			if ((load > rq->cpu_power)
+			 && ((rq->cpu_power*env->sd->imbalance_pct) < (env->dst_rq->cpu_power*100))
+			 && (load > target_load(env->dst_cpu, load_idx)))
+				overloaded_cpu = 1;
 		}
 
 		sgs->group_load += load;
@@ -4527,6 +4532,13 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
+	/*
+	 * The load contrib of a CPU exceeds its capacity, we should try to
+	 * find a better CPU with more capacity
+	 */
+	if (overloaded_cpu)
+		sgs->group_imb = 1;
+
 	sgs->group_capacity = DIV_ROUND_CLOSEST(group->sgp->power,
 						SCHED_POWER_SCALE);
 	if (!sgs->group_capacity)
@@ -4940,6 +4952,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
+	struct rq *overloaded = NULL, *dst_rq = cpu_rq(env->dst_cpu);
 	unsigned long max_load = 0;
 	int i;
 
@@ -4959,6 +4972,17 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		wl = weighted_cpuload(i);
 
 		/*
+		 * If the task requires more power than the current CPU
+		 * capacity and the dst_cpu has more capacity, keep the
+		 * dst_cpu in mind
+		 */
+		if ((rq->nr_running == 1)
+		 && (rq->cfs.runnable_load_avg > rq->cpu_power)
+		 && (rq->cfs.runnable_load_avg > dst_rq->cfs.runnable_load_avg)
+		 && ((rq->cpu_power*env->sd->imbalance_pct) < (dst_rq->cpu_power*100)))
+			overloaded = rq;
+
+		/*
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
@@ -4979,6 +5003,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		}
 	}
 
+	if (!busiest)
+		busiest = overloaded;
+
 	return busiest;
 }
 
@@ -5006,6 +5033,9 @@ static int need_active_balance(struct lb_env *env)
 			return 1;
 	}
 
+	if ((power_of(env->src_cpu)*sd->imbalance_pct) < (power_of(env->dst_cpu)*100))
+		return 1;
+
 	return unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2);
 }
 
@@ -5650,6 +5680,10 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (rq->nr_running >= 2)
 		goto need_kick;
 
+	/* load contrib is higher than cpu capacity */
+	if (rq->cfs.runnable_load_avg > rq->cpu_power)
+		goto need_kick;
+
 	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		struct sched_group *sg = sd->groups;
-- 
1.7.9.5


