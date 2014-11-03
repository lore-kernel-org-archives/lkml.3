Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaKCQ7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:59:16 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55809 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaKCQ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:56:03 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v9 02/10] sched: Track group sched_entity usage contributions
Date: Mon,  3 Nov 2014 17:54:39 +0100
Message-Id: <1415033687-23294-3-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
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
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/debug.c | 2 ++
 kernel/sched/fair.c  | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index f384452..efb47ed 100644
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
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3a91ae6..a171e1b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2529,6 +2529,9 @@ static long __update_entity_utilization_avg_contrib(struct sched_entity *se)
 
 	if (entity_is_task(se))
 		__update_task_entity_utilization(se);
+	else
+		se->avg.utilization_avg_contrib =
+					group_cfs_rq(se)->utilization_load_avg;
 
 	return se->avg.utilization_avg_contrib - old_contrib;
 }
-- 
1.9.1

