Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbaJaItF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:49:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43322 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbaJaIsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:48:21 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v8 10/10] sched: make scale_rt invariant with frequency
Date: Fri, 31 Oct 2014 09:47:32 +0100
Message-Id: <1414745252-4895-11-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The average running time of RT tasks is used to estimate the remaining compute
capacity for CFS tasks. This remaining capacity is the original capacity scaled
down by a factor (aka scale_rt_capacity). This estimation of available capacity
must also be invariant with frequency scaling.

A frequency scaling factor is applied on the running time of the RT tasks for
computing scale_rt_capacity.

In sched_rt_avg_update, we scale the RT execution time like below:
rq->rt_avg += rt_delta * arch_scale_freq_capacity() >> SCHED_CAPACITY_SHIFT

Then, scale_rt_capacity can be summarized by:
scale_rt_capacity = SCHED_CAPACITY_SCALE -
		((rq->rt_avg << SCHED_CAPACITY_SHIFT) / period)

We can optimize by removing right and left shift in the computation of rq->rt_avg
and scale_rt_capacity

The call to arch_scale_frequency_capacity in the rt scheduling path might be
a concern for RT folks because I'm not sure whether we can rely on
arch_scale_freq_capacity to be short and efficient ?

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c  | 17 +++++------------
 kernel/sched/sched.h |  4 +++-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 31c3ec2..02e8f7f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5817,7 +5817,7 @@ unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
 static unsigned long scale_rt_capacity(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	u64 total, available, age_stamp, avg;
+	u64 total, used, age_stamp, avg;
 	s64 delta;
 
 	/*
@@ -5833,19 +5833,12 @@ static unsigned long scale_rt_capacity(int cpu)
 
 	total = sched_avg_period() + delta;
 
-	if (unlikely(total < avg)) {
-		/* Ensures that capacity won't end up being negative */
-		available = 0;
-	} else {
-		available = total - avg;
-	}
+	used = div_u64(avg, total);
 
-	if (unlikely((s64)total < SCHED_CAPACITY_SCALE))
-		total = SCHED_CAPACITY_SCALE;
+	if (likely(used < SCHED_CAPACITY_SCALE))
+		return SCHED_CAPACITY_SCALE - used;
 
-	total >>= SCHED_CAPACITY_SHIFT;
-
-	return div_u64(available, total);
+	return 1;
 }
 
 static void update_cpu_capacity(struct sched_domain *sd, int cpu)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7963981..8fd30c1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1313,9 +1313,11 @@ static inline int hrtick_enabled(struct rq *rq)
 
 #ifdef CONFIG_SMP
 extern void sched_avg_update(struct rq *rq);
+extern unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu);
+
 static inline void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
 {
-	rq->rt_avg += rt_delta;
+	rq->rt_avg += rt_delta * arch_scale_freq_capacity(NULL, cpu_of(rq));
 	sched_avg_update(rq);
 }
 #else
-- 
1.9.1

