Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaJGMQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:16:43 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45519 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbaJGMPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:15:16 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: [PATCH 4/7] sched: Track group sched_entity usage contributions
Date: Tue,  7 Oct 2014 14:13:34 +0200
Message-Id: <1412684017-16595-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Morten Rasmussen <morten.rasmussen@arm.com>

Adds usage contribution tracking for group entities. Unlike
se->avg.load_avg_contrib, se->avg.utilization_avg_contrib for group
entities is the sum of se->avg.utilization_avg_contrib for all entities on the
group runqueue. It is _not_ influenced in any way by the task group
h_load. Hence it is representing the actual cpu usage of the group, not
its intended load contribution which may differ significantly from the
utilization on lightly utilized systems.

cc: Paul Turner <pjt@google.com>
cc: Ben Segall <bsegall@google.com>

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/debug.c | 3 +++
 kernel/sched/fair.c  | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e0fbc0f..efb47ed 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -94,8 +94,10 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
 	P(se->load.weight);
 #ifdef CONFIG_SMP
 	P(se->avg.runnable_avg_sum);
+	P(se->avg.running_avg_sum);
 	P(se->avg.avg_period);
 	P(se->avg.load_avg_contrib);
+	P(se->avg.utilization_avg_contrib);
 	P(se->avg.decay_count);
 #endif
 #undef PN
@@ -633,6 +635,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.avg.running_avg_sum);
 	P(se.avg.avg_period);
 	P(se.avg.load_avg_contrib);
+	P(se.avg.utilization_avg_contrib);
 	P(se.avg.decay_count);
 #endif
 	P(policy);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d6de526..d3e9067 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2381,6 +2381,8 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
+	se->avg.utilization_avg_contrib =
+			decay_load(se->avg.utilization_avg_contrib, decays);
 	se->avg.decay_count = 0;
 
 	return decays;
@@ -2525,6 +2527,9 @@ static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
 
 	if (entity_is_task(se))
 		__update_task_entity_utilization(se);
+	else
+		se->avg.utilization_avg_contrib =
+					group_cfs_rq(se)->utilization_load_avg;
 
 	return se->avg.utilization_avg_contrib - old_contrib;
 }
-- 
1.9.1

