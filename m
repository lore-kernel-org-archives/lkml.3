Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaEWSTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:19:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36200 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaEWSQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:54 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 09/16] sched, cpufreq: Introduce current cpu compute capacity into scheduler
Date: Fri, 23 May 2014 19:16:36 +0100
Message-Id: <1400869003-27769-10-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:52.0291 (UTC) FILETIME=[2BC9E930:01CF76B3]
X-MC-Unique: 114052319165215601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIJRqE005191

The scheduler is currently unaware of frequency changes and the current
compute capacity offered by the cpus. This patch is not the solution.
It is a hack to give us something to experiment with for now.

A proper solution could be based on the frequency invariant load
tracking proposed in the past: https://lkml.org/lkml/2013/4/16/289

This patch should _not_ be considered safe.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 drivers/cpufreq/cpufreq.c |    2 ++
 include/linux/sched.h     |    2 ++
 kernel/sched/fair.c       |    6 ++++++
 kernel/sched/sched.h      |    2 ++
 4 files changed, 12 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index abda660..a2b788d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/suspend.h>
 #include <linux/tick.h>
+#include <linux/sched.h>
 #include <trace/events/power.h>
 
 /**
@@ -315,6 +316,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		pr_debug("FREQ: %lu - CPU: %lu\n",
 			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
 		trace_cpu_frequency(freqs->new, freqs->cpu);
+		set_curr_capacity(freqs->cpu, (freqs->new*1024)/policy->max);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 62d61b5..727b936 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -3068,4 +3068,6 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+void set_curr_capacity(int cpu, long capacity);
+
 #endif
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..3a2aeee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7410,9 +7410,15 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
 	atomic_long_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->curr_capacity, 1024);
 #endif
 }
 
+void set_curr_capacity(int cpu, long capacity)
+{
+	atomic_long_set(&cpu_rq(cpu)->cfs.curr_capacity, capacity);
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9ff67a7..5a117b8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -341,6 +341,8 @@ struct cfs_rq {
 	u64 last_decay;
 	atomic_long_t removed_load;
 
+	atomic_long_t curr_capacity;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* Required to track per-cpu representation of a task_group */
 	u32 tg_runnable_contrib;
-- 
1.7.9.5


