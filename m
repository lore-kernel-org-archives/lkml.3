Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaAQJEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:04:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39236 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAQJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:04:08 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        alex.shi@linaro.org
Subject: [PATCH 2/4] sched: Fix race in idle_balance()
Date: Fri, 17 Jan 2014 10:04:02 +0100
Message-Id: <1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
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

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/fair.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d601df3..502c51c 100644
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
-- 
1.7.9.5

