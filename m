Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaHDRXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:23:46 -0400
Received: from shelob.surriel.com ([74.92.59.67]:57980 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHDRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:23:43 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, mingo@kernel.org,
        vincent.guittot@linaro.org, Morten.Rasmussen@arm.com,
        nicolas.pitre@linaro.org, efault@gmx.de
Subject: [PATCH 2/2] sched,numa: fix numa capacity computation
Date: Mon,  4 Aug 2014 13:23:28 -0400
Message-Id: <1407173008-9334-3-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407173008-9334-1-git-send-email-riel@redhat.com>
References: <1407173008-9334-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Commit c61037e9 fixes the phenomenon of 'fantom' cores due to
N*frac(smt_power) >= 1 by limiting the capacity to the actual
number of cores in the load balancing code.

This patch applies the same correction to the NUMA balancing
code.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 678ed03..376bc07c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1038,7 +1038,8 @@ struct numa_stats {
  */
 static void update_numa_stats(struct numa_stats *ns, int nid)
 {
-	int cpu, cpus = 0;
+	int smt, cpu, cpus = 0;
+	unsigned long capacity;
 
 	memset(ns, 0, sizeof(*ns));
 	for_each_cpu(cpu, cpumask_of_node(nid)) {
@@ -1062,8 +1063,12 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->task_capacity =
-		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE);
+	/* smt := ceil(cpus / capacity), assumes: 1 < smt_power < 2 */
+	smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, ns->compute_capacity);
+	capacity = cpus / smt; /* cores */
+
+	ns->task_capacity = min_t(unsigned, capacity,
+		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE));
 	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
 }
 
-- 
1.9.3

