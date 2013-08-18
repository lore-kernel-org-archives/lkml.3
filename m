Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3HRI0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:26:32 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:41632 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab3HRI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:26:25 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] sched: change update_rq_runnable_avg using h_nr_running
Date: Sun, 18 Aug 2013 16:25:17 +0800
Message-ID: <1376814322-7320-4-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since update_rq_runnable_avg is used only by cfs scheduler, it
should not consider the task beyond the cfs type.

If one cfs task is running with one rt task, the only cfs task
should be no aware of the existence of rt task, and behavior
like one cfs task occasionly throttled by some bandwidth control
mechanism. Thus its sleep time should not being taken into
runnable avg load calculation.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e6b99b4..9869d4d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2893,7 +2893,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	if (!se) {
-		update_rq_runnable_avg(rq, rq->nr_running);
+		update_rq_runnable_avg(rq, rq->cfs.h_nr_running);
 		inc_nr_running(rq);
 	}
 	hrtick_update(rq);
@@ -4142,7 +4142,7 @@ static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
 			list_del_leaf_cfs_rq(cfs_rq);
 	} else {
 		struct rq *rq = rq_of(cfs_rq);
-		update_rq_runnable_avg(rq, rq->nr_running);
+		update_rq_runnable_avg(rq, rq->cfs.h_nr_running);
 	}
 }
 
-- 
1.7.5.4

