Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaLRQbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:31:35 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47795 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaLRQbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:31:34 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH] sched/deadline: Add update_rq_clock() in yield_task_dl()
Date: Fri, 19 Dec 2014 00:31:03 +0800
Message-Id: <1418920263-21358-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yield_task_dl() calls update_curr_dl() which calls start_dl_timer()
to throttle current task. But yield_task_dl() doesn't update the rq
clock which will cause start_dl_timer() to set the wrong dl_timer
which may be much later than current deadline time.

For instance, in systems with 100HZ tick, if there're few dl-tasks,
then rq clock will mainly depend on the tick to update its value.
If we choose the CONFIG_NO_HZ_FULL_ALL feature, things may get even
worse.

Moreover, there're some statistics in update_curr_dl() also relying
on rq clock, like rq_clock_task().

Thus, in yield_task_dl(), we should add update_rq_clock() before
update_curr_dl().

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 kernel/sched/deadline.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e5db8c6..5648e62 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -915,7 +915,11 @@ static void yield_task_dl(struct rq *rq)
 		rq->curr->dl.dl_yielded = 1;
 		p->dl.runtime = 0;
 	}
+
+	update_rq_clock(rq);
 	update_curr_dl(rq);
+	/* Will go to schedule(), to avoid another clock update. */
+	rq->skip_clock_update = 1;
 }
 
 #ifdef CONFIG_SMP
-- 
1.9.1

