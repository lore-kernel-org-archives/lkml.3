Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3FQCV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 22:21:56 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:48608 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab3FQCVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 22:21:55 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: add heuristic logic to pick idle peers
Date: Mon, 17 Jun 2013 10:21:32 +0800
Message-ID: <1371435692-18831-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_busy_cpus in sched_group_power structure cannot present the purpose
for judging below statement:
"this cpu's scheduler group has multiple busy cpu's exceeding
 the group's power."

But only could tell how many cpus is doing their jobs for currently.

However, the original purpose to add this logic still looks good.
So we move this kind of logic to find_new_ilb, so that we could pick
out peer from our sharing resource domain whenever possible.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..64f9120 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5368,10 +5368,31 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
+/*
+ * Add the heuristic logic to try waking up idle cpu from
+ * those peers who share resources with us, so that the
+ * cost would be brought to minimum.
+ */
 static inline int find_new_ilb(int call_cpu)
 {
-	int ilb = cpumask_first(nohz.idle_cpus_mask);
+	int ilb = nr_cpu_ids;
+	struct sched_domain *sd;
+
+	rcu_read_lock();
+	for_each_domain(call_cpu, sd) {
+		/* We loop till sched_domain no longer share resource */
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
+			ilb = cpumask_first(nohz.idle_cpus_mask);
+			break;
+		}
 
+		/* else, we would try to pick the idle cpu from peers first */
+		ilb = cpumask_first_and(nohz.idle_cpus_mask,
+				sched_domain_span(sd));
+		if (ilb < nr_cpu_ids)
+			break;
+	}
+	rcu_read_unlock();
 	if (ilb < nr_cpu_ids && idle_cpu(ilb))
 		return ilb;
 
@@ -5620,8 +5641,6 @@ end:
  * Current heuristic for kicking the idle load balancer in the presence
  * of an idle cpu is the system.
  *   - This rq has more than one task.
- *   - At any scheduler domain level, this cpu's scheduler group has multiple
- *     busy cpu's exceeding the group's power.
  *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
  *     domain span are idle.
  */
@@ -5659,9 +5678,6 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 		struct sched_group_power *sgp = sg->sgp;
 		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
 
-		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
-			goto need_kick_unlock;
-
 		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
 		    && (cpumask_first_and(nohz.idle_cpus_mask,
 					  sched_domain_span(sd)) < cpu))
-- 
1.7.10.4

