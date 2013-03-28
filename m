Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3C1Nim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:38:42 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54776 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3C1Nil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:38:41 -0400
From: Charles Wang <muming.wq@gmail.com>
To: mingo@kernel.org, gaoyang.zyh@taobao.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Precise load checking in get_rr_interval_fair
Date: Thu, 28 Mar 2013 21:37:45 +0800
Message-Id: <1364477865-1777-1-git-send-email-muming.wq@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Wang <muming.wq@taobao.com>

Positive load weight of rq.cfs can not represent positive load weight
of se->cfs_rq. And when se->cfs_rq's load is 0, the slice calculated 
by sched_slice is not that sensible.

Use se->cfs_rq for load checking instead of rq->cfs. And correct the
comments.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>
Signed-off-by: Charles Wang <muming.wq@taobao.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 539760e..5d58ac9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6086,14 +6086,15 @@ void unregister_fair_sched_group(struct task_group *tg, int cpu) { }
 static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 	unsigned int rr_interval = 0;
 
 	/*
 	 * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
-	 * idle runqueue:
+	 * idle cfs_rq:
 	 */
-	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
+	if (cfs_rq->load.weight)
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq, se));
 
 	return rr_interval;
 }
-- 
1.7.9.5

