Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3H1LPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:15:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60695 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3H1LPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:15:07 -0400
Date: Wed, 28 Aug 2013 13:14:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>,
        Michael Neuling <mikey@neuling.org>
Subject: [PATCH 12/10] sched, fair: Fix group power_orig computation
Message-ID: <20130828111445.GM10002@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160058.539049611@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched, fair: Fix group power_orig computation
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Aug 28 11:44:39 CEST 2013

When looking at the code I noticed we don't actually compute
sgp->power_orig correctly for groups, fix that.

Currently the only consumer of that value is fix_small_capacity()
which is only used on POWER7+ and that code excludes this case by
being limited to SD_SHARE_CPUPOWER which is only ever set on the SMT
domain which must be the lowest domain and this has singleton groups.

So nothing should be affected by this change.

Cc: Michael Neuling <mikey@neuling.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4448,7 +4448,7 @@ void update_group_power(struct sched_dom
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power;
+	unsigned long power, power_orig;
 	unsigned long interval;
 
 	interval = msecs_to_jiffies(sd->balance_interval);
@@ -4460,7 +4460,7 @@ void update_group_power(struct sched_dom
 		return;
 	}
 
-	power = 0;
+	power_orig = power = 0;
 
 	if (child->flags & SD_OVERLAP) {
 		/*
@@ -4468,8 +4468,12 @@ void update_group_power(struct sched_dom
 		 * span the current group.
 		 */
 
-		for_each_cpu(cpu, sched_group_cpus(sdg))
-			power += power_of(cpu);
+		for_each_cpu(cpu, sched_group_cpus(sdg)) {
+			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+
+			power_orig += sg->sgp->power_orig;
+			power += sg->sgp->power;
+		}
 	} else  {
 		/*
 		 * !SD_OVERLAP domains can assume that child groups
@@ -4478,12 +4482,14 @@ void update_group_power(struct sched_dom
 
 		group = child->groups;
 		do {
+			power_orig += group->sgp->power_orig;
 			power += group->sgp->power;
 			group = group->next;
 		} while (group != child->groups);
 	}
 
-	sdg->sgp->power_orig = sdg->sgp->power = power;
+	sdg->sgp->power_orig = power_orig;
+	sdg->sgp->power = power;
 }
 
 /*
