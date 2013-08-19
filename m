Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3HSQQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:16:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3HSQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:26 -0400
Message-Id: <20130819160425.088015040@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:00:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/10] sched: Remove one division operation in find_busiest_queue()
References: <20130819160058.539049611@infradead.org>
Content-Disposition: inline; filename=joonsoo_kim-sched-remove_one_division_operation_in_find_buiest_queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Remove one division operation in find_busiest_queue() by using
crosswise multiplication:

	wl_i / power_i > wl_j / power_j := 
	wl_i * power_j > wl_j * power_i

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
[peterz: expanded changelog]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375778203-31343-2-git-send-email-iamjoonsoo.kim@lge.com
---
 kernel/sched/fair.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5018,7 +5018,7 @@ static struct rq *find_busiest_queue(str
 				     struct sched_group *group)
 {
 	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
+	unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
@@ -5049,10 +5049,9 @@ static struct rq *find_busiest_queue(str
 		 * the load can be moved away from the cpu that is potentially
 		 * running at a lower capacity.
 		 */
-		wl = (wl * SCHED_POWER_SCALE) / power;
-
-		if (wl > max_load) {
-			max_load = wl;
+		if (wl * busiest_power > busiest_load * power) {
+			busiest_load = wl;
+			busiest_power = power;
 			busiest = rq;
 		}
 	}


