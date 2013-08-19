Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3HSQOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:14:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36085 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HSQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:57 -0400
Message-Id: <20130819160425.383813199@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:01:03 +0200
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
Subject: [PATCH 05/10] sched, fair: Remove duplicate load_per_task computations
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=peterz-more-fbg-cleanups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we already compute (but don't store) the sgs load_per_task value
in update_sg_lb_stats() we might as well store it and not re-compute
it later on.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4504,7 +4504,6 @@ static inline void update_sg_lb_stats(st
 {
 	unsigned long nr_running, max_nr_running, min_nr_running;
 	unsigned long load, max_cpu_load, min_cpu_load;
-	unsigned long avg_load_per_task = 0;
 	int i;
 
 	/* Tally up the load of all CPUs in the group */
@@ -4559,9 +4558,9 @@ static inline void update_sg_lb_stats(st
 	 *      the hierarchy?
 	 */
 	if (sgs->sum_nr_running)
-		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
+		sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
-	if ((max_cpu_load - min_cpu_load) >= avg_load_per_task &&
+	if ((max_cpu_load - min_cpu_load) >= sgs->load_per_task &&
 	    (max_nr_running - min_nr_running) > 1)
 		sgs->group_imb = 1;
 
@@ -4807,15 +4806,7 @@ static inline void calculate_imbalance(s
 	struct sg_lb_stats *this, *busiest;
 
 	this = &sds->this_stat;
-	if (this->sum_nr_running) {
-		this->load_per_task =
-			this->sum_weighted_load / this->sum_nr_running;
-	}
-
 	busiest = &sds->busiest_stat;
-	/* busiest must have some tasks */
-	busiest->load_per_task =
-		busiest->sum_weighted_load / busiest->sum_nr_running;
 
 	if (busiest->group_imb) {
 		busiest->load_per_task =


