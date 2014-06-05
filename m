Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaFEOgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:36:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaFEOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:36:21 -0400
Date: Thu, 5 Jun 2014 07:35:13 -0700
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-2e2ndymj5gyshyjq8am79f20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, morten.rasmussen@arm.com, nico@linaro.org,
        vincent.guittot@linaro.org, rjw@rjwysocki.net, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Remove "power" from '
 struct numa_stats'
Git-Commit-ID: 5ef20ca181ec592e4684a45f4d5f1385f6055534
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

Commit-ID:  5ef20ca181ec592e4684a45f4d5f1385f6055534
Gitweb:     http://git.kernel.org/tip/5ef20ca181ec592e4684a45f4d5f1385f6055534
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Mon, 26 May 2014 18:19:34 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:14 +0200

sched/fair: Remove "power" from 'struct numa_stats'

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linaro-kernel@lists.linaro.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-2e2ndymj5gyshyjq8am79f20@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c63dde9..1cfe5a2 100644
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
