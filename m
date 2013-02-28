Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3B1G0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:26:49 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52796 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3B1G0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:26:48 -0500
X-AuditID: 9c93016f-b7c56ae00000569b-8e-512ef8a48b07
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Turner <pjt@google.com>
Subject: [PATCH] sched: Fix calc_cfs_shares() to consider blocked_load_avg also
Date: Thu, 28 Feb 2013 15:26:02 +0900
Message-Id: <1362032762-20827-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The calc_tg_weight() and calc_cfs_shares() used cfs_rq->load.weight
but this is no longer valid for per-entity load tracking since
cfs_rq->tg_load_contrib consists of runnable_load_avg and blocked_
load_avg.  Simply using load.weight here will lose blocked_load_avg
part so will result in an inaccurate share.

Cc: Paul Turner <pjt@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/sched/fair.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e5986fc5..add7440bd02f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1032,13 +1032,13 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
 	long tg_weight;
 
 	/*
-	 * Use this CPU's actual weight instead of the last load_contribution
-	 * to gain a more accurate current total weight. See
-	 * update_cfs_rq_load_contribution().
+	 * Use this CPU's actual load instead of the last load_contribution
+	 * to gain a more accurate current total load. See
+	 * __update_cfs_rq_tg_load_contrib().
 	 */
 	tg_weight = atomic64_read(&tg->load_avg);
 	tg_weight -= cfs_rq->tg_load_contrib;
-	tg_weight += cfs_rq->load.weight;
+	tg_weight += cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 
 	return tg_weight;
 }
@@ -1048,7 +1048,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
 	long tg_weight, load, shares;
 
 	tg_weight = calc_tg_weight(tg, cfs_rq);
-	load = cfs_rq->load.weight;
+	load = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
 
 	shares = (tg->shares * load);
 	if (tg_weight)
-- 
1.7.11.7

