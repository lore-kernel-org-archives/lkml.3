Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3C1H7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:59:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53645 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3C1H7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:59:07 -0400
X-AuditID: 9c930197-b7c9dae000006959-c1-5153f846b490
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/5] sched: don't consider upper se in sched_slice()
Date: Thu, 28 Mar 2013 16:58:55 +0900
Message-Id: <1364457537-15114-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following-up upper se in sched_slice() should not be done,
because sched_slice() is used for checking that resched is needed
whithin *this* cfs_rq and there is one problem related to this
in current implementation.

The problem is that if we follow-up upper se in sched_slice(), it is
possible that we get a ideal slice which is lower than
sysctl_sched_min_granularity.

For example, we assume that we have 4 tg which is attached to root tg
with same share and each one have 20 runnable tasks on cpu0, respectivly.
In this case, __sched_period() return sysctl_sched_min_granularity * 20
and then go into loop. At first iteration, we compute a portion of slice
for this task on this cfs_rq, so get a slice, sysctl_sched_min_granularity.
Afterward, we enter second iteration and get a slice which is a quarter of
sysctl_sched_min_granularity, because there is 4 tgs with same share
in that cfs_rq.

Ensuring slice larger than min_granularity is important for performance
and there is no lower bound about this, except timer tick, we should
fix it not to consider upper se when calculating sched_slice.

Below is my testing result on my 4 cpus machine.

I did a test for verifying this effect in below environment.

CONFIG_HZ=1000 and CONFIG_SCHED_AUTOGROUP=y
/proc/sys/kernel/sched_min_granularity_ns is 2250000, that is, 2.25ms.

Did following command.

For each 4 sessions,
for i in `seq 20`; do taskset -c 3 sh -c 'while true; do :; done' & done

./perf sched record
./perf script -C 003 | grep sched_switch | cut -b -40 | less

Result is below.

*Vanilla*
              sh  2724 [003]   152.52801
              sh  2779 [003]   152.52900
              sh  2775 [003]   152.53000
              sh  2751 [003]   152.53100
              sh  2717 [003]   152.53201

*With this patch*
              sh  2640 [003]   147.48700
              sh  2662 [003]   147.49000
              sh  2601 [003]   147.49300
              sh  2633 [003]   147.49400

In vanilla case, min_granularity is lower than 1ms, so every tick trigger
reschedule. After patch appied, we can see min_granularity is ensured.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 204a9a9..e232421 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -631,23 +631,20 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	struct load_weight *load;
+	struct load_weight lw;
 	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
 
-	for_each_sched_entity(se) {
-		struct load_weight *load;
-		struct load_weight lw;
-
-		cfs_rq = cfs_rq_of(se);
-		load = &cfs_rq->load;
+	load = &cfs_rq->load;
 
-		if (unlikely(!se->on_rq)) {
-			lw = cfs_rq->load;
+	if (unlikely(!se->on_rq)) {
+		lw = cfs_rq->load;
 
-			update_load_add(&lw, se->load.weight);
-			load = &lw;
-		}
-		slice = calc_delta_mine(slice, se->load.weight, load);
+		update_load_add(&lw, se->load.weight);
+		load = &lw;
 	}
+	slice = calc_delta_mine(slice, se->load.weight, load);
+
 	return slice;
 }
 
-- 
1.7.9.5

