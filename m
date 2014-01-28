Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaA1Rdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:33:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60571 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbaA1Rds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:33:48 -0500
Message-Id: <20140128171947.942449330@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 Jan 2014 18:16:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, daniel.lezcano@linaro.org, pjt@google.com,
        bsegall@google.com, Steven Rostedt <rostedt@goodmis.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/9] sched: Fix race in idle_balance()
References: <20140128171634.974847076@infradead.org>
Content-Disposition: inline; filename=daniel_lezcano-2_sched-fix_race_in_idle_balance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

The scheduler main function 'schedule()' checks if there are no more tasks
on the runqueue. Then it checks if a task should be pulled in the current
runqueue in idle_balance() assuming it will go to idle otherwise.

But the idle_balance() releases the rq->lock in order to lookup in the sched
domains and takes the lock again right after. That opens a window where
another cpu may put a task in our runqueue, so we won't go to idle but
we have filled the idle_stamp, thinking we will.

This patch closes the window by checking if the runqueue has been modified
but without pulling a task after taking the lock again, so we won't go to idle
right after in the __schedule() function.

Cc: alex.shi@linaro.org
Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6417,6 +6417,13 @@ void idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	/*
+	 * While browsing the domains, we released the rq lock.
+	 * A task could have be enqueued in the meantime
+	 */
+	if (this_rq->nr_running && !pulled_task)
+		return;
+
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
 		 * We are going idle. next_balance may be set based on


