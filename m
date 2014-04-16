Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaDPCol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:44:41 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57536 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaDPCoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:12 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 1/8] sched: shortcut to remove load_idx
Date: Wed, 16 Apr 2014 10:43:22 +0800
Message-Id: <1397616209-27275-2-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shortcut to remove rq->cpu_load[load_idx] effect in scheduler.
In five load idx, only busy_idx, idle_idx are not zero.
Newidle_idx, wake_idx and fork_idx are all zero in all archs.

So, change the idx to zero here can fully remove load_idx effect.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f14a65..ddff32a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5507,34 +5507,6 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 	};
 }
 
-/**
- * get_sd_load_idx - Obtain the load index for a given sched domain.
- * @sd: The sched_domain whose load_idx is to be obtained.
- * @idle: The idle status of the CPU for whose sd load_idx is obtained.
- *
- * Return: The load index.
- */
-static inline int get_sd_load_idx(struct sched_domain *sd,
-					enum cpu_idle_type idle)
-{
-	int load_idx;
-
-	switch (idle) {
-	case CPU_NOT_IDLE:
-		load_idx = sd->busy_idx;
-		break;
-
-	case CPU_NEWLY_IDLE:
-		load_idx = sd->newidle_idx;
-		break;
-	default:
-		load_idx = sd->idle_idx;
-		break;
-	}
-
-	return load_idx;
-}
-
 static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
 {
 	return SCHED_POWER_SCALE;
@@ -5920,7 +5892,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	load_idx = get_sd_load_idx(env->sd, env->idle);
+	load_idx = 0;
 
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
-- 
1.8.3.2

