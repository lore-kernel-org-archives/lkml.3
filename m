Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaIXPHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:07:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59598 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIXO4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:10 -0400
Date: Wed, 24 Sep 2014 07:55:37 -0700
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-83a0a96a5f26d974580fd7251043ff70c8f1823d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, nico@linaro.org, rjw@rjwysocki.net,
        tglx@linutronix.de, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Leverage the idle state info when choosing the "idlest" cpu
Git-Commit-ID: 83a0a96a5f26d974580fd7251043ff70c8f1823d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83a0a96a5f26d974580fd7251043ff70c8f1823d
Gitweb:     http://git.kernel.org/tip/83a0a96a5f26d974580fd7251043ff70c8f1823d
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Thu, 4 Sep 2014 11:32:10 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:46:59 +0200

sched/fair: Leverage the idle state info when choosing the "idlest" cpu

The code in find_idlest_cpu() looks for the CPU with the smallest load.
However, if multiple CPUs are idle, the first idle CPU is selected
irrespective of the depth of its idle state.

Among the idle CPUs we should pick the one with with the shallowest idle
state, or the latest to have gone idle if all idle CPUs are in the same
state.  The later applies even when cpuidle is configured out.

This patch doesn't cover the following issues:

- The idle exit latency of a CPU might be larger than the time needed
  to migrate the waking task to an already running CPU with sufficient
  capacity, and therefore performance would benefit from task packing
  in such case (in most cases task packing is about power saving).

- Some idle states have a non negligible and non abortable entry latency
  which needs to run to completion before the exit latency can start.
  A concurrent patch series is making this info available to the cpuidle
  core.  Once available, the entry latency with the idle timestamp could
  determine when the exit latency may be effective.

Those issues will be handled in due course.  In the mean time, what
is implemented here should improve things already compared to the current
state of affairs.

Based on an initial patch from Daniel Lezcano.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org
Link: http://lkml.kernel.org/n/tip-@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9ee3d4f..8cb32f8 100644
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
@@ -4415,20 +4416,46 @@ static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
-	int idlest = -1;
+	unsigned int min_exit_latency = UINT_MAX;
+	u64 latest_idle_timestamp = 0;
+	int least_loaded_cpu = this_cpu;
+	int shallowest_idle_cpu = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
-		load = weighted_cpuload(i);
-
-		if (load < min_load || (load == min_load && i == this_cpu)) {
-			min_load = load;
-			idlest = i;
+		if (idle_cpu(i)) {
+			struct rq *rq = cpu_rq(i);
+			struct cpuidle_state *idle = idle_get_state(rq);
+			if (idle && idle->exit_latency < min_exit_latency) {
+				/*
+				 * We give priority to a CPU whose idle state
+				 * has the smallest exit latency irrespective
+				 * of any idle timestamp.
+				 */
+				min_exit_latency = idle->exit_latency;
+				latest_idle_timestamp = rq->idle_stamp;
+				shallowest_idle_cpu = i;
+			} else if ((!idle || idle->exit_latency == min_exit_latency) &&
+				   rq->idle_stamp > latest_idle_timestamp) {
+				/*
+				 * If equal or no active idle state, then
+				 * the most recently idled CPU might have
+				 * a warmer cache.
+				 */
+				latest_idle_timestamp = rq->idle_stamp;
+				shallowest_idle_cpu = i;
+			}
+		} else {
+			load = weighted_cpuload(i);
+			if (load < min_load || (load == min_load && i == this_cpu)) {
+				min_load = load;
+				least_loaded_cpu = i;
+			}
 		}
 	}
 
-	return idlest;
+	return shallowest_idle_cpu != -1 ? shallowest_idle_cpu : least_loaded_cpu;
 }
 
 /*
