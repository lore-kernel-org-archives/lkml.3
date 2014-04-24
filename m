Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaDXBbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:31:09 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:42529 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaDXBbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:31:06 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@kernel.org, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Subject: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost whenever newidle balance is attempted
Date: Wed, 23 Apr 2014 18:30:33 -0700
Message-Id: <1398303035-18255-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e5fc6611 can potentially cause rq->max_idle_balance_cost to not be
updated, even when load_balance(NEWLY_IDLE) is attempted and the per-sd
max cost value is updated.

In this patch, we update the rq->max_idle_balance_cost regardless of
whether or not a task has been enqueued while browsing the domains.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43232b8..3e3ffb8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6658,6 +6658,7 @@ static int idle_balance(struct rq *this_rq)
 	int this_cpu = this_rq->cpu;
 
 	idle_enter_fair(this_rq);
+
 	/*
 	 * We must set idle_stamp _before_ calling idle_balance(), such that we
 	 * measure the duration of idle_balance() as idle time.
@@ -6710,9 +6711,12 @@ static int idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
+
 	/*
 	 * While browsing the domains, we released the rq lock.
-	 * A task could have be enqueued in the meantime
+	 * A task could have been enqueued in the meantime.
 	 */
 	if (this_rq->cfs.h_nr_running && !pulled_task) {
 		pulled_task = 1;
@@ -6727,9 +6731,6 @@ static int idle_balance(struct rq *this_rq)
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

