Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3I3HwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 03:52:21 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63840 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3I3HwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 03:52:19 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Zhang <yong.zhang@windriver.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched:rt: don't try to pull a running task
Date: Mon, 30 Sep 2013 15:52:09 +0800
Message-Id: <1380527529-31272-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we happen to pull a running task on other cpu, a WARNING
will happen. But the very task will be pulled to this cpu
finally. This pulling is dangerous since the task's private
data could be broken. Fix it by skipping this kind of task.

Signed-off-by: Yong Zhang <yong.zhang@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/rt.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..e76d278 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1665,7 +1665,15 @@ static int pull_rt_task(struct rq *this_rq)
 		 * the to-be-scheduled task?
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
-			WARN_ON(p == src_rq->curr);
+			/*
+			 * if we happen to choose a running task on other
+			 * cpu, skip it and find another one.
+			 */
+			if (unlikely(p == src_rq->curr)) {
+				WARN_ON_ONCE(1);
+				goto skip;
+			}
+
 			WARN_ON(!p->on_rq);
 
 			/*
-- 
1.7.9.5

