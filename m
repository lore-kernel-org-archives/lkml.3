Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbaCMGAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:00:34 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56710 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaCMGAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:00:32 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: [PATCH 1/8] sched: shortcut to remove load_idx
Date: Thu, 13 Mar 2014 13:57:22 +0800
Message-Id: <1394690249-14130-2-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
References: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
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
index 7e9bd0b..1d8a908 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5506,34 +5506,6 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
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
@@ -5919,7 +5891,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	load_idx = get_sd_load_idx(env->sd, env->idle);
+	load_idx = 0;
 
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
-- 
1.8.1.2

