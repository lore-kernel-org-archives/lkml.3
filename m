Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3IBHoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:44:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3IBHlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:09 -0400
Date: Mon, 2 Sep 2013 00:40:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-0klzmz9okll8wc0nsudguc9p@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Shrink sg_lb_stats and play memset games
Git-Commit-ID: 147c5fc2bad780d8093b547f2baa204e78107faf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:40:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  147c5fc2bad780d8093b547f2baa204e78107faf
Gitweb:     http://git.kernel.org/tip/147c5fc2bad780d8093b547f2baa204e78107faf
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 19 Aug 2013 15:22:57 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:35 +0200

sched/fair: Shrink sg_lb_stats and play memset games

We can shrink sg_lb_stats because rq::nr_running is an unsigned int
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
Link: http://lkml.kernel.org/n/tip-0klzmz9okll8wc0nsudguc9p@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2da80a5..4c6a8a5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4237,12 +4237,12 @@ static unsigned long task_h_load(struct task_struct *p)
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
@@ -4258,10 +4258,29 @@ struct sd_lb_stats {
 	unsigned long total_pwr;	/* Total power of all groups in sd */
 	unsigned long avg_load;	/* Average load across all groups in sd */
 
-	struct sg_lb_stats local_stat;	/* Statistics of the local group */
 	struct sg_lb_stats busiest_stat;/* Statistics of the busiest group */
+	struct sg_lb_stats local_stat;	/* Statistics of the local group */
 };
 
+static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
+{
+	/*
+	 * Skimp on the clearing to avoid duplicate work. We can avoid clearing
+	 * local_stat because update_sg_lb_stats() does a full clear/assignment.
+	 * We must however clear busiest_stat::avg_load because
+	 * update_sd_pick_busiest() reads this before assignment.
+	 */
+	*sds = (struct sd_lb_stats){
+		.busiest = NULL,
+		.local = NULL,
+		.total_load = 0UL,
+		.total_pwr = 0UL,
+		.busiest_stat = {
+			.avg_load = 0UL,
+		},
+	};
+}
+
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
@@ -4615,7 +4634,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 		 */
 		if (prefer_sibling && !local_group &&
 				sds->local && sds->local_stat.group_has_capacity)
-			sgs->group_capacity = min(sgs->group_capacity, 1UL);
+			sgs->group_capacity = min(sgs->group_capacity, 1U);
 
 		/* Now, start updating sd_lb_stats */
 		sds->total_load += sgs->group_load;
@@ -4846,7 +4865,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
 	struct sg_lb_stats *local, *busiest;
 	struct sd_lb_stats sds;
 
-	memset(&sds, 0, sizeof(sds));
+	init_sd_lb_stats(&sds);
 
 	/*
 	 * Compute the various statistics relavent for load balancing at
