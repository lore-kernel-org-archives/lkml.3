Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaD1WqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:46:01 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:17596 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaD1Wp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:45:59 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com
Subject: [PATCH 1/2] sched: Fix updating rq->max_idle_balance_cost and rq->next_balance in idle_balance()
Date: Mon, 28 Apr 2014 15:45:54 -0700
Message-Id: <1398725155-7591-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
References: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e5fc6611 can potentially cause rq->max_idle_balance_cost to not be
updated, even when load_balance(NEWLY_IDLE) is attempted and the per-sd
max cost value is updated.

Preeti noticed a similar issue with updating rq->next_balance.

In this patch, we fix this by making sure we still check/update those values
even if a task gets enqueued while browsing the domains.

Cc: daniel.lezcano@linaro.org
Cc: alex.shi@linaro.org   
Cc: efault@gmx.de
Cc: vincent.guittot@linaro.org
Cc: morten.rasmussen@arm.com
Cc: aswin@hp.com
Cc: mingo@kernel.org
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index af47873..e0f3019 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6658,6 +6658,7 @@ static int idle_balance(struct rq *this_rq)
 	int this_cpu = this_rq->cpu;
 
 	idle_enter_fair(this_rq);
+
 	/*
 	 * We must set idle_stamp _before_ calling idle_balance(), such that we
 	 * measure the duration of idle_balance() as idle time.
@@ -6714,14 +6715,16 @@ static int idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
+
 	/*
-	 * While browsing the domains, we released the rq lock.
-	 * A task could have be enqueued in the meantime
+	 * While browsing the domains, we released the rq lock, a task could
+	 * have been enqueued in the meantime. Since we're not going idle,
+	 * pretend we pulled a task.
 	 */
-	if (this_rq->cfs.h_nr_running && !pulled_task) {
+	if (this_rq->cfs.h_nr_running && !pulled_task)
 		pulled_task = 1;
-		goto out;
-	}
 
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
@@ -6731,9 +6734,6 @@ static int idle_balance(struct rq *this_rq)
 		this_rq->next_balance = next_balance;
 	}
 
-	if (curr_cost > this_rq->max_idle_balance_cost)
-		this_rq->max_idle_balance_cost = curr_cost;
-
 out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
-- 
1.7.1

