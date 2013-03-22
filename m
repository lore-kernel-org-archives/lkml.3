Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab3CVMae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 08:30:34 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43614 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab3CVM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 08:29:43 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com
Cc: alex.shi@intel.com, preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC PATCH v3 4/6] sched: secure access to other CPU statistics
Date: Fri, 22 Mar 2013 13:25:53 +0100
Message-Id: <1363955155-18382-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a CPU accesses the runnable_avg_sum and runnable_avg_period fields of its
buddy CPU while the latter updates it, it can get the new version of a field
and the old version of the other one. This can generate erroneous decisions.
We don't want to use a lock mechanism for ensuring the coherency because of
the overhead in this critical path. The previous attempt can't ensure
coherency of both fields for 100% of the platform and use case as it will
depend of the toolchain and the platform architecture.
The runnable_avg_period of a runqueue tends to the max value in less than
345ms after plugging a CPU, which implies that we could use the max value
instead of reading runnable_avg_period after 345ms. During the starting phase,
we must ensure a minimum of coherency between the fields. A simple rule is
runnable_avg_sum <= runnable_avg_period.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 021c7b7..b636199 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3364,13 +3364,16 @@ done:
 static bool is_buddy_busy(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	u32 sum = rq->avg.runnable_avg_sum;
+	u32 period = rq->avg.runnable_avg_period;
+
+	sum = min(sum, period);
 
 	/*
 	 * A busy buddy is a CPU with a high load or a small load with a lot of
 	 * running tasks.
 	 */
-	return (rq->avg.runnable_avg_sum >
-			(rq->avg.runnable_avg_period / (rq->nr_running + 2)));
+	return (sum > (period / (rq->nr_running + 2)));
 }
 
 static bool is_light_task(struct task_struct *p)
-- 
1.7.9.5

