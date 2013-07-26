Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285Ab3GZVDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:03:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50617 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155Ab3GZVDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:03:32 -0400
Date: Fri, 26 Jul 2013 23:03:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Max Hailperin <max@gustavus.edu>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: PROBLEM: Persistent unfair sharing of a processor by auto groups
 in 3.11-rc2 (has twice regressed)
Message-ID: <20130726210317.GC20909@twins.programming.kicks-ass.net>
References: <9E84D12D-7389-4D9A-803A-91FD704A92FA@gustavus.edu>
 <20130725112123.GT27075@twins.programming.kicks-ass.net>
 <228E8D34-E1A9-4D82-B353-F095E473B8D7@gustavus.edu>
 <20130725164051.GZ27075@twins.programming.kicks-ass.net>
 <20130725211521.GE18254@gmail.com>
 <CAPM31RJNgDS+gCZobJCt138J6MfbYhwTuTH8MrhP7DEqHGqi5g@mail.gmail.com>
 <CAPM31RJ7Xh5A9cTT_-qd47RH3pRhCqiuh-uKx1gktDk0g-5NNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RJ7Xh5A9cTT_-qd47RH3pRhCqiuh-uKx1gktDk0g-5NNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



OK, so I have the below; however on a second look, Paul, shouldn't that
update_cfs_shares() call be in entity_tick(), right after calling
update_cfs_rq_blocked_load(). Because placing it in
update_cfs_rq_blocked_load() means its now called twice on the
enqueue/dequeue paths through:

  {en,de}queue_entity()
    {en,de}queue_entity_load_avg()
      update_cfs_rq_blocked_load()
        update_cfs_shares()



---
Subject: sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks
From: Max Hailperin <max@gustavus.edu>

We typically update a task_group's shares within the dequeue/enqueue
path.  However, continuously running tasks sharing a CPU are not
subject to these updates as they are only put/picked.  Unfortunately,
when we reverted f269ae046 (in 17bc14b7), we lost the augmenting
periodic update that was supposed to account for this; resulting in a
potential loss of fairness.

To fix this, re-introduce the explicit update in
update_cfs_rq_blocked_load() [called via entity_tick()].

Cc: stable@kernel.org
Reviewed-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1531,6 +1531,7 @@ static void update_cfs_rq_blocked_load(s
 	}
 
 	__update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
+	update_cfs_shares(cfs_rq);
 }
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
