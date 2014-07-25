Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761068AbaGYTcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761035AbaGYTcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:32:51 -0400
Date: Fri, 25 Jul 2014 15:32:10 -0400
From: Rik van Riel <riel@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH v2] sched: make update_sd_pick_busiest return true on a
 busier sd
Message-ID: <20140725153210.47c09bfe@annuminas.surriel.com>
In-Reply-To: <CAKfTPtBVTgTYmgRKbuhKNZZRuCRK126YVvsG1+a-hjfKao08=g@mail.gmail.com>
References: <20140722144559.382c5243@annuminas.surriel.com>
	<20140725152728.GB6758@twins.programming.kicks-ass.net>
	<53D27B7E.8090404@redhat.com>
	<20140725160549.GD6758@twins.programming.kicks-ass.net>
	<53D28457.202@redhat.com>
	<CAKfTPtBVTgTYmgRKbuhKNZZRuCRK126YVvsG1+a-hjfKao08=g@mail.gmail.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: make update_sd_pick_busiest return true on a busier sd

Currently update_sd_pick_busiest only identifies the busiest sd
that is either overloaded, or has a group imbalance. When no
sd is imbalanced or overloaded, the load balancer fails to find
the busiest domain.

This breaks load balancing between domains that are not overloaded,
in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
return true when the busiest sd yet is encountered.

Behaviour for SD_ASYM_PACKING does not seem to match the comment,
but I have no hardware to test that so I have left the behaviour
of that code unchanged.

It is unclear what to do with the group_imb condition.
Should group_imb override a busier load? If so, should we fix
calculate_imbalance to return a sensible number when the "busiest"
node found has a below average load? We probably need to fix
calculate_imbalance anyway, to deal with an overloaded group that
happens to have a below average load...

Cc: mikey@neuling.org
Cc: peterz@infradead.org
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 45943b2..c96044f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5949,6 +5949,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 		sgs->group_has_free_capacity = 1;
 }
 
+static bool group_overloaded(struct sg_lb_stats *sgs)
+{
+	return sgs->sum_nr_running > sgs->group_capacity_factor;
+}
+
 /**
  * update_sd_pick_busiest - return 1 on busiest group
  * @env: The load balancing environment.
@@ -5957,7 +5962,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
  * @sgs: sched_group statistics
  *
  * Determine if @sg is a busier group than the previously selected
- * busiest group.
+ * busiest group. 
  *
  * Return: %true if @sg is a busier group than the previously selected
  * busiest group. %false otherwise.
@@ -5967,13 +5972,17 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
+	if (group_overloaded(sgs) && !group_overloaded(&sds->busiest_stat))
+		return true;
+
 	if (sgs->avg_load <= sds->busiest_stat.avg_load)
 		return false;
 
-	if (sgs->sum_nr_running > sgs->group_capacity_factor)
+	if (sgs->group_imb)
 		return true;
 
-	if (sgs->group_imb)
+	/* This is the busiest node. */
+	if (!(env->sd->flags & SD_ASYM_PACKING))
 		return true;
 
 	/*
@@ -5981,8 +5990,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * numbered CPUs in the group, therefore mark all groups
 	 * higher than ourself as busy.
 	 */
-	if ((env->sd->flags & SD_ASYM_PACKING) && sgs->sum_nr_running &&
-	    env->dst_cpu < group_first_cpu(sg)) {
+	if (sgs->sum_nr_running && env->dst_cpu < group_first_cpu(sg)) {
 		if (!sds->busiest)
 			return true;
 

