Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaBFXLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:11:14 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45078 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaBFXKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:10:47 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: alex.shi@linaro.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH V2 2/3] sched: Fix race in idle_balance()
Date: Thu,  6 Feb 2014 23:10:36 +0000
Message-Id: <1391728237-4441-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 428bc9d..5ebc681 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6589,6 +6589,13 @@ void idle_balance(struct rq *this_rq)
 
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
-- 
1.7.9.5

