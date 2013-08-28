Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3H1LQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:16:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60768 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3H1LQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:16:49 -0400
Date: Wed, 28 Aug 2013 13:16:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: [RFC][PATCH 14/10] sched, fair: Fix the group_capacity computation
Message-ID: <20130828111638.GO10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160058.539049611@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched, fair: Fix the group_capacity computation
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Aug 28 12:40:38 CEST 2013

Do away with 'phantom' cores due to N*frac(smt_power) >= 1 by limiting
the capacity to the actual number of cores.

The assumption of 1 < smt_power < 2 is an actual requirement because
of what SMT is so this should work regardless of the SMT
implementation.

It can still be defeated by creative use of cpu hotplug, but if you're
one of those freaks, you get to live with it.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4554,18 +4554,24 @@ static inline int sg_imbalanced(struct s
 /*
  * Compute the group capacity.
  *
- * For now the capacity is simply the number of power units in the group_power.
- * A power unit represents a full core.
- *
- * This has an issue where N*frac(smt_power) >= 1, in that case we'll see extra
- * 'cores' that aren't actually there.
+ * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
+ * first dividing out the smt factor and computing the actual number of cores
+ * and limit power unit capacity with that.
  */
 static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
 {
+	unsigned int capacity, smt, cpus;
+	unsigned int power, power_orig;
+
+	power = group->sgp->power;
+	power_orig = group->sgp->power_orig;
+	cpus = group->group_weight;
 
-	unsigned int power = group->sgp->power;
-	unsigned int capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
+	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
+	smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
+	capacity = cpus / smt; /* cores */
 
+	capacity = min_t(capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
 	if (!capacity)
 		capacity = fix_small_capacity(env->sd, group);
 
