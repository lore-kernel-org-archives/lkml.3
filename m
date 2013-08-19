Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3HSQPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:15:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36057 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3HSQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:27 -0400
Message-Id: <20130819160425.310264395@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:01:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/10] sched, fair: Shrink sg_lb_stats and play memset games
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=peterz-more-bfg-cleanups-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can shrink sg_lb_stats because rq::nr_running is an 'unsigned int'
and cpu numbers are 'int'

Before:
  sgs:        /* size: 72, cachelines: 2, members: 10 */
  sds:        /* size: 184, cachelines: 3, members: 7 */

After:
  sgs:        /* size: 56, cachelines: 1, members: 10 */
  sds:        /* size: 152, cachelines: 3, members: 7 */

Further we can avoid clearing all of sds since we do a total
clear/assignment of sg_stats in update_sg_lb_stats() with exception of
busiest_stat.avg_load which is referenced in update_sd_pick_busiest().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4282,12 +4282,12 @@ static unsigned long task_h_load(struct
 struct sg_lb_stats {
 	unsigned long avg_load; /*Avg load across the CPUs of the group */
 	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_nr_running; /* Nr tasks running in the group */
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long load_per_task;
-	unsigned long group_capacity;
-	unsigned long idle_cpus;
-	unsigned long group_weight;
+	unsigned int sum_nr_running; /* Nr tasks running in the group */
+	unsigned int group_capacity;
+	unsigned int idle_cpus;
+	unsigned int group_weight;
 	int group_imb; /* Is there an imbalance in the group ? */
 	int group_has_capacity; /* Is there extra capacity in the group? */
 };
@@ -4303,10 +4303,38 @@ struct sd_lb_stats {
 	unsigned long total_pwr;	/* Total power of all groups in sd */
 	unsigned long avg_load;	/* Average load across all groups in sd */
 
-	struct sg_lb_stats this_stat;	/* Statistics of this group */
 	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
+	struct sg_lb_stats this_stat;	/* Statistics of this group */
 };
 
+static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
+{
+	/*
+	 * struct sd_lb_stats {
+	 *	   struct sched_group *       busiest;             //     0  8
+	 *	   struct sched_group *       this;                //     8  8
+	 *	   long unsigned int          total_load;          //    16  8
+	 *	   long unsigned int          total_pwr;           //    24  8
+	 *	   long unsigned int          avg_load;            //    32  8
+	 *	   struct sg_lb_stats {
+	 *		   long unsigned int  avg_load;            //    40  8
+	 *		   long unsigned int  group_load;          //    48  8
+	 *	           ...
+	 *	   } busiest_stat;                                 //    40 56
+	 *	   struct sg_lb_stats	      this_stat;	   //    96 56
+	 *
+	 *	   // size: 152, cachelines: 3, members: 7
+	 *	   // last cacheline: 24 bytes
+	 * };
+	 *
+	 * Skimp on the clearing to avoid duplicate work. We can avoid clearing
+	 * this_stat because update_sg_lb_stats() does a full clear/assignment.
+	 * We must however clear busiest_stat::avg_load because
+	 * update_sd_pick_busiest() reads this before assignment.
+	 */
+	memset(sds, 0, offsetof(struct sd_lb_stats, busiest_stat.group_load));
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4665,7 +4693,7 @@ static inline void update_sd_lb_stats(st
 		 */
 		if (prefer_sibling && !local_group &&
 				sds->this && sds->this_stat.group_has_capacity)
-			sgs->group_capacity = min(sgs->group_capacity, 1UL);
+			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
@@ -4896,7 +4924,7 @@ static struct sched_group *find_busiest_
 	struct sg_lb_stats *this, *busiest;
 	struct sd_lb_stats sds;
 
-	memset(&sds, 0, sizeof(sds));
+	init_sd_lb_stats(&sds);
 
 	/*
 	 * Compute the various statistics relavent for load balancing at


