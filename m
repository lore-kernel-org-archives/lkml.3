Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaEWPyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:54:33 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:58711 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaEWPyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:24 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 10/11] sched: move cfs task on a CPU with higher capacity
Date: Fri, 23 May 2014 17:53:04 +0200
Message-Id: <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the CPU is used for handling lot of IRQs, trig a load balance to check if
it's worth moving its tasks on another CPU that has more capacity

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8a30f9..2501e49 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5948,6 +5948,13 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	if (sgs->sum_nr_running > sgs->group_capacity)
 		return true;
 
+	/*
+	 * The group capacity is reduced probably because of activity from other
+	 * sched class or interrupts which use part of the available capacity
+	 */
+	if ((sg->sgp->power_orig * 100) > (sgs->group_power * env->sd->imbalance_pct))
+		return true;
+
 	if (sgs->group_imb)
 		return true;
 
@@ -7282,6 +7289,12 @@ static inline int nohz_kick_needed(struct rq *rq)
 
 		if (nr_busy > 1)
 			goto need_kick_unlock;
+
+		if ((rq->cfs.h_nr_running >= 1)
+		 && ((rq->cpu_power * sd->imbalance_pct) <
+					(rq->cpu_power_orig * 100)))
+			goto need_kick_unlock;
+
 	}
 
 	sd = rcu_dereference(per_cpu(sd_asym, cpu));
-- 
1.9.1

