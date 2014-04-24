Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaDXKAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:00:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaDXKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:00:51 -0400
Date: Thu, 24 Apr 2014 12:00:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] sched: Skip double execution of pick_next_task_fair
Message-ID: <20140424100047.GP11096@twins.programming.kicks-ass.net>
References: <1398292317.2970.63.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398292317.2970.63.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:31:57PM -0700, Tim Chen wrote:
> The current code will call pick_next_task_fair a second time
> in the slow path if we did not pull any task in our first try.
> This is really unnecessary as we already know no task can
> be pulled and it doubles the delay for the cpu to enter idle.
> 
> We instrumented some network workloads and that saw that
> pick_next_task_fair is frequently called twice before a cpu enters idle.
> The call to pick_next_task_fair can add
> non trivial latency as it calls load_balance which runs find_busiest_group
> on an hierarchy of sched domains spanning the cpus for a large system.  For
> some 4 socket systems, we saw almost 0.25 msec spent per call
> of pick_next_task_fair before a cpu can be idled.
> 
> This patch skips pick_next_task_fair in the slow path if it
> has already been invoked.

How about something like so?

Its a little more contained.

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2636,8 +2636,14 @@ pick_next_task(struct rq *rq, struct tas
 	if (likely(prev->sched_class == class &&
 		   rq->nr_running == rq->cfs.h_nr_running)) {
 		p = fair_sched_class.pick_next_task(rq, prev);
-		if (likely(p && p != RETRY_TASK))
-			return p;
+		if (unlikely(p == RETRY_TASK))
+			goto again;
+
+		/* assumes fair_sched_class->next == idle_sched_class */
+		if (unlikely(!p))
+			p = pick_next_task_idle(rq, prev);
+
+		return p;
 	}
 
 again:
