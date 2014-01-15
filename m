Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaAOPds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:33:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaAOPdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:33:42 -0500
Date: Wed, 15 Jan 2014 16:33:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: [PATCH] sched: Fixup scheduler syscall LTP fails
Message-ID: <20140115153320.GH31570@twins.programming.kicks-ass.net>
References: <20140115124739.GB19419@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115124739.GB19419@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Fixup scheduler syscall LTP fails

Wu reported:

> ltp.sched_setparam02.1.TFAIL
> ltp.sched_setparam02.2.TFAIL
> ltp.sched_setparam02.3.TFAIL
> ltp.sched_setparam03.1.TFAIL

There were 2 things wrong; firstly __setscheduler() failed on
sched_setparam()'s policy = -1, fix that by reading from p->policy in
that case.

Secondly, getparam() (and getattr()) would still report !0
sched_priority for !FIFO/RR tasks after having been such. So
unconditionally set p->rt_priority.

Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0326c06953eb..50e99f2cf98b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3183,15 +3183,23 @@ static void __setscheduler(struct rq *rq, struct task_struct *p,
 {
 	int policy = attr->sched_policy;
 
+	if (policy == -1) /* setparam */
+		policy = p->policy;
+
 	p->policy = policy;
 
 	if (dl_policy(policy))
 		__setparam_dl(p, attr);
-	else if (rt_policy(policy))
-		p->rt_priority = attr->sched_priority;
-	else
+	else if (fair_policy(policy))
 		p->static_prio = NICE_TO_PRIO(attr->sched_nice);
 
+	/*
+	 * __sched_setscheduler() ensures attr->sched_priority == 0 when
+	 * !rt_policy. Always setting this ensures that things like
+	 * getparam()/getattr() don't report silly values for !rt tasks.
+	 */
+	p->rt_priority = attr->sched_priority;
+
 	p->normal_prio = normal_prio(p);
 	p->prio = rt_mutex_getprio(p);
 
