Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3IYSDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:03:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50103 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3IYSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:03:47 -0400
Date: Wed, 25 Sep 2013 20:03:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130925180343.GA16530@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 7e3115ef5149fc502e3a2e80719dba54a8e7409d sched/balancing: Fix cfs_rq->task_h_load calculation

Three small fixes.

 Thanks,

	Ingo

------------------>
Vladimir Davydov (3):
      sched/balancing: Fix 'local->avg_load > sds->avg_load' case in calculate_imbalance()
      sched/balancing: Fix 'local->avg_load > busiest->avg_load' case in fix_small_imbalance()
      sched/balancing: Fix cfs_rq->task_h_load calculation


 kernel/sched/fair.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 11cd136..7c70201 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4242,7 +4242,7 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 	}
 
 	if (!se) {
-		cfs_rq->h_load = rq->avg.load_avg_contrib;
+		cfs_rq->h_load = cfs_rq->runnable_load_avg;
 		cfs_rq->last_h_load_update = now;
 	}
 
@@ -4823,8 +4823,8 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 		(busiest->load_per_task * SCHED_POWER_SCALE) /
 		busiest->group_power;
 
-	if (busiest->avg_load - local->avg_load + scaled_busy_load_per_task >=
-	    (scaled_busy_load_per_task * imbn)) {
+	if (busiest->avg_load + scaled_busy_load_per_task >=
+	    local->avg_load + (scaled_busy_load_per_task * imbn)) {
 		env->imbalance = busiest->load_per_task;
 		return;
 	}
@@ -4896,7 +4896,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (busiest->avg_load < sds->avg_load) {
+	if (busiest->avg_load <= sds->avg_load ||
+	    local->avg_load >= sds->avg_load) {
 		env->imbalance = 0;
 		return fix_small_imbalance(env, sds);
 	}
