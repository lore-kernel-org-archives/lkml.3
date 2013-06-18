Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3FRNHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:07:42 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:42143 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644Ab3FRNHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:07:41 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/4] sched: adjust fix_small_imbalance moving task condition
Date: Tue, 18 Jun 2013 21:04:19 +0800
Message-ID: <1371560659-4686-5-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
References: <1371560659-4686-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose here we have such example, in current domain, there are two
cpus. CPU A with 4 task, while CPU B with 5 tasks. All tasks over two
runqueue are the same priority.

Let say the load for CPU A is 4096, and CPU B is 5120, then avg_load
should be 4608. Suppose sgp->power == SCHED_POWER_SCALE.
Then the imbalance value should be 512, less then the
busiest_load_per_task, which is 1024. From the logic we enter into
fix_small_imbalance adjustment.

For busiest_per_task==this_load_per_task, imbn's value is equal to 2.
Thus below statement would be true, and load balance would move one task
from CPU B to CPU A.
      if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
                        (scaled_busy_load_per_task * imbn)) {

When CPU B issue load balance later, it would move one task back again,
which bring infinite end...
Kill the >=, and make it as >, to stop this loop.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c478022..3be7844 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4717,7 +4717,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds,
 					<< SCHED_POWER_SHIFT;
 	scaled_this_load_per_task /= sds->this->sgp->power;
 
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
+	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >
 			(scaled_busy_load_per_task * imbn)) {
 		env->imbalance = sds->busiest_load_per_task;
 		return;
-- 
1.7.10.4

