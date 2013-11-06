Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab3KFNUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:20:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3KFNUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:52 -0500
Date: Wed, 6 Nov 2013 05:20:18 -0800
From: tip-bot for Preeti U Murthy <tipbot@zytor.com>
Message-ID: <tip-37dc6b50cee97954c4e6edcd5b1fa614b76038ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131030031252.23426.4417.stgit@preeti.in.ibm.com>
References: <20131030031252.23426.4417.stgit@preeti.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove unnecessary iteration over sched domains to update nr_busy_cpus
Git-Commit-ID: 37dc6b50cee97954c4e6edcd5b1fa614b76038ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:20:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37dc6b50cee97954c4e6edcd5b1fa614b76038ee
Gitweb:     http://git.kernel.org/tip/37dc6b50cee97954c4e6edcd5b1fa614b76038ee
Author:     Preeti U Murthy <preeti@linux.vnet.ibm.com>
AuthorDate: Wed, 30 Oct 2013 08:42:52 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:37:55 +0100

sched: Remove unnecessary iteration over sched domains to update nr_busy_cpus

nr_busy_cpus parameter is used by nohz_kick_needed() to find out the
number of busy cpus in a sched domain which has SD_SHARE_PKG_RESOURCES
flag set.  Therefore instead of updating nr_busy_cpus at every level
of sched domain, since it is irrelevant, we can update this parameter
only at the parent domain of the sd which has this flag set. Introduce
a per-cpu parameter sd_busy which represents this parent domain.

In nohz_kick_needed() we directly query the nr_busy_cpus parameter
associated with the groups of sd_busy.

By associating sd_busy with the highest domain which has
SD_SHARE_PKG_RESOURCES flag set, we cover all lower level domains
which could have this flag set and trigger nohz_idle_balancing if any
of the levels have more than one busy cpu.

sd_busy is irrelevant for asymmetric load balancing. However sd_asym
has been introduced to represent the highest sched domain which has
SD_ASYM_PACKING flag set so that it can be queried directly when
required.

While we are at it, we might as well change the nohz_idle parameter to
be updated at the sd_busy domain level alone and not the base domain
level of a CPU.  This will unify the concept of busy cpus at just one
level of sched domain where it is currently used.

Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: svaidy@linux.vnet.ibm.com
Cc: vincent.guittot@linaro.org
Cc: bitbucket@online.de
Cc: benh@kernel.crashing.org
Cc: anton@samba.org
Cc: Morten.Rasmussen@arm.com
Cc: pjt@google.com
Cc: peterz@infradead.org
Cc: mikey@neuling.org
Link: http://lkml.kernel.org/r/20131030031252.23426.4417.stgit@preeti.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c  |  6 ++++++
 kernel/sched/fair.c  | 38 ++++++++++++++++++++------------------
 kernel/sched/sched.h |  2 ++
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aa066f3..1deccd7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4883,6 +4883,8 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
 DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 DEFINE_PER_CPU(struct sched_domain *, sd_numa);
+DEFINE_PER_CPU(struct sched_domain *, sd_busy);
+DEFINE_PER_CPU(struct sched_domain *, sd_asym);
 
 static void update_top_cache_domain(int cpu)
 {
@@ -4894,6 +4896,7 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
+		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
 	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
@@ -4902,6 +4905,9 @@ static void update_top_cache_domain(int cpu)
 
 	sd = lowest_flag_domain(cpu, SD_NUMA);
 	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
+
+	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
+	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 074551a..df77c60 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6534,16 +6534,16 @@ static inline void nohz_balance_exit_idle(int cpu)
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
@@ -6551,16 +6551,16 @@ unlock:
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
@@ -6767,6 +6767,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
 	unsigned long now = jiffies;
 	struct sched_domain *sd;
+	struct sched_group_power *sgp;
+	int nr_busy;
 
 	if (unlikely(idle_cpu(cpu)))
 		return 0;
@@ -6792,22 +6794,22 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
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
index 4e650ac..88c85b2 100644
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
