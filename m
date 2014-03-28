Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaC1Map (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:30:45 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45582 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaC1M3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:29:50 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Cc: rjw@rjwysocki.net, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose the idlest cpu
Date: Fri, 28 Mar 2014 13:29:56 +0100
Message-Id: <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we know in which idle state the cpu is, we can investigate the following:

1. when did the cpu entered the idle state ? the longer the cpu is idle, the
deeper it is idle
2. what exit latency is ? the greater the exit latency is, the deeper it is

With both information, when all cpus are idle, we can choose the idlest cpu.

When one cpu is not idle, the old check against weighted load applies.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |   46 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 16042b5..068e503 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -23,6 +23,7 @@
 #include <linux/latencytop.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
+#include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
@@ -4336,20 +4337,53 @@ static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
+	unsigned int min_exit_latency = UINT_MAX;
+	u64 idle_stamp, min_idle_stamp = ULONG_MAX;
+
+	struct rq *rq;
+	struct cpuidle_power *power;
+
+	int cpu_idle = -1;
+	int cpu_busy = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		load = weighted_cpuload(i);
 
-		if (load < min_load || (load == min_load && i == this_cpu)) {
-			min_load = load;
-			idlest = i;
+		if (idle_cpu(i)) {
+
+			rq = cpu_rq(i);
+			power = rq->power;
+			idle_stamp = rq->idle_stamp;
+
+			/* The cpu is idle since a shorter time */
+			if (idle_stamp < min_idle_stamp) {
+				min_idle_stamp = idle_stamp;
+				cpu_idle = i;
+				continue;
+			}
+
+			/* The cpu is idle but the exit_latency is shorter */
+			if (power && power->exit_latency < min_exit_latency) {
+				min_exit_latency = power->exit_latency;
+				cpu_idle = i;
+				continue;
+			}
+		} else {
+
+			load = weighted_cpuload(i);
+
+			if (load < min_load ||
+			    (load == min_load && i == this_cpu)) {
+				min_load = load;
+				cpu_busy = i;
+				continue;
+			}
 		}
 	}
 
-	return idlest;
+	/* Busy cpus are considered less idle than idle cpus ;) */
+	return cpu_busy != -1 ? cpu_busy : cpu_idle;
 }
 
 /*
-- 
1.7.9.5

