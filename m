Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3HPKYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:24:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44340 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HPKWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:22:25 -0400
Message-Id: <20130816101544.994911608@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 16 Aug 2013 12:12:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/6] sched: Remove one division operation in find_busiest_queue()
References: <20130816101221.028189677@chello.nl>
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


