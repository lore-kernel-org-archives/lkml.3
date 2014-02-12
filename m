Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaBLJtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:49:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58984 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBLJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:49:41 -0500
Date: Wed, 12 Feb 2014 10:49:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Fix rt/dl hotplug condition
Message-ID: <20140212094930.GB3545@laptop.programming.kicks-ass.net>
References: <20140212090222.GK26776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212090222.GK26776@mwanda>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter reported:

> kernel/sched/rt.c:1347 pick_next_task_rt() warn: variable dereferenced before check 'prev' (see line 1338)
> kernel/sched/deadline.c:1011 pick_next_task_dl() warn: variable dereferenced before check 'prev' (see line 1005)

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Fixes: 38033c37faab ("sched: Push down pre_schedule() and idle_balance()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/deadline.c | 2 +-
 kernel/sched/rt.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ed31ef66ab9d..d60008e4bce9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1001,7 +1001,7 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 	dl_rq = &rq->dl;
 
 #ifdef CONFIG_SMP
-	if (dl_task(prev))
+	if (prev && dl_task(prev))
 		pull_dl_task(rq);
 #endif
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 72f9ec759972..7294b498b2c1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1334,7 +1334,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 
 #ifdef CONFIG_SMP
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (rq->rt.highest_prio.curr > prev->prio)
+	if (prev && (rq->rt.highest_prio.curr > prev->prio))
 		pull_rt_task(rq);
 #endif
 
