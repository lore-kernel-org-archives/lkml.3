Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3DKXvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:51:32 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:43003 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3DKXva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:51:30 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 4/5] sched: Update rq clock earlier in unthrottle_cfs_rq
Date: Fri, 12 Apr 2013 01:51:01 +0200
Message-Id: <1365724262-20142-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
References: <1365724262-20142-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this function we are making use of rq->clock right before the
update of the rq clock, let's just call update_rq_clock() just
before that to avoid using a stale rq clock value.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched/fair.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c23dde4..fc7d01a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2280,12 +2280,14 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
 	cfs_rq->throttled = 0;
+
+	update_rq_clock(rq);
+
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
-	update_rq_clock(rq);
 	/* update hierarchical throttle state */
 	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
 
-- 
1.7.5.4

