Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaLBOHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:07:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39591 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaLBOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:06:58 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: peterz@infradead.org, mingo@redhat.com
Cc: dietmar.eggemann@arm.com, vincent.guittot@linaro.org, pjt@google.com,
        bsegall@google.com, mturquette@linaro.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC PATCH 02/10] sched: Make usage and load tracking cpu scale-invariant
Date: Tue,  2 Dec 2014 14:06:24 +0000
Message-Id: <1417529192-11579-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 02 Dec 2014 14:06:54.0932 (UTC) FILETIME=[3A644940:01D00E39]
X-MC-Unique: 114120214065609101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB2E9vOw017002

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Besides the existing frequency scale-invariance correction factor, apply
cpu scale-invariance correction factor to usage and load tracking.

Cpu scale-invariance takes cpu performance deviations due to
micro-architectural differences (i.e. instructions per seconds) between
cpus in HMP systems (e.g. big.LITTLE) and differences in the frequency
value of the highest OPP between cpus in SMP systems into consideration.

Each segment of the sched_avg::{running_avg_sum, runnable_avg_sum}
geometric series is now scaled by the cpu performance factor too so the
sched_avg::{utilization_avg_contrib, load_avg_contrib} of each entity will
be invariant from the particular cpu of the HMP/SMP system it is gathered
on. As a result, cfs_rq::runnable_load_avg which is the sum of
sched_avg::load_avg_contrib, becomes cpu scale-invariant too.

So the {usage, load} level that is returned by {get_cpu_usage,
weighted_cpuload} stays relative to the max cpu performance of the system.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b41f03d..5c4c989 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2473,6 +2473,21 @@ static u32 __compute_runnable_contrib(u64 n)
 }
 
 unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu);
+unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu);
+
+static unsigned long contrib_scale_factor(int cpu)
+{
+	unsigned long scale_factor;
+
+	scale_factor = arch_scale_freq_capacity(NULL, cpu);
+	scale_factor *= arch_scale_cpu_capacity(NULL, cpu);
+	scale_factor >>= SCHED_CAPACITY_SHIFT;
+
+	return scale_factor;
+}
+
+#define scale_contrib(contrib, scale_factor) \
+	((contrib * scale_factor) >> SCHED_CAPACITY_SHIFT)
 
 /*
  * We can represent the historical contribution to runnable average as the
@@ -2510,7 +2525,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 	u64 delta, scaled_delta, periods;
 	u32 runnable_contrib, scaled_runnable_contrib;
 	int delta_w, scaled_delta_w, decayed = 0;
-	unsigned long scale_freq = arch_scale_freq_capacity(NULL, cpu);
+	unsigned long scale_factor;
 
 	delta = now - sa->last_runnable_update;
 	/*
@@ -2531,6 +2546,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 		return 0;
 	sa->last_runnable_update = now;
 
+	scale_factor = contrib_scale_factor(cpu);
+
 	/* delta_w is the amount already accumulated against our next period */
 	delta_w = sa->avg_period % 1024;
 	if (delta + delta_w >= 1024) {
@@ -2543,7 +2560,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 		 * period and accrue it.
 		 */
 		delta_w = 1024 - delta_w;
-		scaled_delta_w = (delta_w * scale_freq) >> SCHED_CAPACITY_SHIFT;
+		scaled_delta_w = scale_contrib(delta_w, scale_factor);
 
 		if (runnable)
 			sa->runnable_avg_sum += scaled_delta_w;
@@ -2566,8 +2583,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 
 		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
 		runnable_contrib = __compute_runnable_contrib(periods);
-		scaled_runnable_contrib = (runnable_contrib * scale_freq)
-						>> SCHED_CAPACITY_SHIFT;
+		scaled_runnable_contrib =
+			scale_contrib(runnable_contrib, scale_factor);
 
 		if (runnable)
 			sa->runnable_avg_sum += scaled_runnable_contrib;
@@ -2577,7 +2594,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
 	}
 
 	/* Remainder of delta accrued against u_0` */
-	scaled_delta = (delta * scale_freq) >> SCHED_CAPACITY_SHIFT;
+	scaled_delta = scale_contrib(delta, scale_factor);
 
 	if (runnable)
 		sa->runnable_avg_sum += scaled_delta;
-- 
1.9.1


