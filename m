Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab3IBHlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab3IBHlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:19 -0400
Date: Mon, 2 Sep 2013 00:40:48 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ym1vmljiwbzgdnnrwp9azftq@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Remove duplicate load_per_task computations
Git-Commit-ID: 38d0f7708543bcfa03d5ee55e8346f801b4a59c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:40:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38d0f7708543bcfa03d5ee55e8346f801b4a59c9
Gitweb:     http://git.kernel.org/tip/38d0f7708543bcfa03d5ee55e8346f801b4a59c9
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 15 Aug 2013 19:47:56 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:36 +0200

sched/fair: Remove duplicate load_per_task computations

Since we already compute (but don't store) the sgs load_per_task value
in update_sg_lb_stats() we might as well store it and not re-compute
it later on.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-ym1vmljiwbzgdnnrwp9azftq@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4c6a8a5..5795219 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4476,7 +4476,6 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
 	unsigned long load, max_cpu_load, min_cpu_load;
-	unsigned long avg_load_per_task = 0;
 	int i;
 
 	/* Tally up the load of all CPUs in the group */
@@ -4531,9 +4530,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	 *      the hierarchy?
 	 */
 	if (sgs->sum_nr_running)
-		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
+	if ((max_cpu_load - min_cpu_load) >= sgs->load_per_task &&
 	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
@@ -4776,15 +4775,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	struct sg_lb_stats *local, *busiest;
 
 	local = &sds->local_stat;
-	if (local->sum_nr_running) {
-		local->load_per_task =
-			local->sum_weighted_load / local->sum_nr_running;
-	}
-
 	busiest = &sds->busiest_stat;
-	/* busiest must have some tasks */
-	busiest->load_per_task =
-		busiest->sum_weighted_load / busiest->sum_nr_running;
 
 	if (busiest->group_imb) {
 		busiest->load_per_task =
