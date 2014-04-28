Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaD1C5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:57:54 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51713 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaD1C5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:57:53 -0400
X-Original-SENDERIP: 10.186.119.240
X-Original-MAILFROM: yjay.kim@lge.com
From: "yjay.kim" <yjay.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, "yjay.kim" <yjay.kim@lge.com>
Subject: [PATCH] sched/deadline: remove dl_new checking condition from dl_task_timer()
Date: Mon, 28 Apr 2014 11:57:25 +0900
Message-Id: <1398653845-22615-1-git-send-email-yjay.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "yjay.kim" <yjay.kim@lge.com>

yield_task_dl() sets dl.dl_new as 1 and dequeue current dl task.
After that it expects that next bandwidth timer callback `dl_task_timer()` will
replenish budget of dl task and enqueue it again.

But current dl_task_timer() does nothing in case dl.dl_new is 1.
So when dl task calls sched_yield(), it will never be scheduled again.

dl_task_timer() should works in case dl_new is 1.

Signed-off-by: yjay.kim <yjay.kim@lge.com>
---
 kernel/sched/deadline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 27ef409..6fb4004 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -522,7 +522,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * different from SCHED_DEADLINE or changed its reservation
 	 * parameters (through sched_setscheduler()).
 	 */
-	if (!dl_task(p) || dl_se->dl_new)
+	if (!dl_task(p))
 		goto unlock;
 
 	sched_clock_tick();
-- 
1.7.9.5

