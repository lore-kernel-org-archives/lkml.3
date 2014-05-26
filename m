Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaEZWTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:19:48 -0400
Received: from relais.videotron.ca ([24.201.245.36]:61825 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaEZWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:19:45 -0400
Content-transfer-encoding: 7BIT
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v2 1/6] sched/fair.c: remove "power" from struct numa_stats
Date: Mon, 26 May 2014 18:19:34 -0400
Message-id: <1401142779-6633-2-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: git-send-email 1.8.4.108.g55ea5f6
In-reply-to: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
References: <1401142779-6633-1-git-send-email-nicolas.pitre@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better not to think about compute capacity as being equivalent
to "CPU power".  The upcoming "power aware" scheduler work may create
confusion with the notion of energy consumption if "power" is used too
liberally.

To make things explicit and not create more confusion with the existing
"capacity" member, let's rename things as follows:

	power    -> compute_capacity
	capacity -> task_capacity

Note: none of those fields are actually used outside update_numa_stats().

Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 kernel/sched/fair.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c9617b73bc..16f0dddb70 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1026,10 +1026,10 @@ struct numa_stats {
 	unsigned long load;
 
 	/* Total compute capacity of CPUs on a node */
-	unsigned long power;
+	unsigned long compute_capacity;
 
 	/* Approximate capacity in terms of runnable tasks on a node */
-	unsigned long capacity;
+	unsigned long task_capacity;
 	int has_capacity;
 };
 
@@ -1046,7 +1046,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 
 		ns->nr_running += rq->nr_running;
 		ns->load += weighted_cpuload(cpu);
-		ns->power += power_of(cpu);
+		ns->compute_capacity += power_of(cpu);
 
 		cpus++;
 	}
@@ -1062,9 +1062,10 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->power;
-	ns->capacity = DIV_ROUND_CLOSEST(ns->power, SCHED_POWER_SCALE);
-	ns->has_capacity = (ns->nr_running < ns->capacity);
+	ns->load = (ns->load * SCHED_POWER_SCALE) / ns->compute_capacity;
+	ns->task_capacity =
+		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_POWER_SCALE);
+	ns->has_capacity = (ns->nr_running < ns->task_capacity);
 }
 
 struct task_numa_env {
-- 
1.8.4.108.g55ea5f6

