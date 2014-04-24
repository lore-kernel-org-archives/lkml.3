Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbaDXRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:16:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:38373 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbaDXRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:16:24 -0400
Date: Thu, 24 Apr 2014 19:16:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] sched: Skip double execution of pick_next_task_fair
Message-ID: <20140424171619.GA11096@twins.programming.kicks-ass.net>
References: <1398292317.2970.63.camel@schen9-DESK>
 <20140424100047.GP11096@twins.programming.kicks-ass.net>
 <1398359167.2970.80.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398359167.2970.80.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:06:07AM -0700, Tim Chen wrote:
> Yes, this version is more concise.
> 
> > 
> > Its a little more contained.
> > 
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2636,8 +2636,14 @@ pick_next_task(struct rq *rq, struct tas
> >  	if (likely(prev->sched_class == class &&
> >  		   rq->nr_running == rq->cfs.h_nr_running)) {
> >  		p = fair_sched_class.pick_next_task(rq, prev);
> > -		if (likely(p && p != RETRY_TASK))
> > -			return p;
> > +		if (unlikely(p == RETRY_TASK))
> > +			goto again;
> > +
> > +		/* assumes fair_sched_class->next == idle_sched_class */
> > +		if (unlikely(!p))
> > +			p = pick_next_task_idle(rq, prev);
> Should be 
> 			  p = idle_sched_class.pick_next_task(rq, prev);

Indeed, already fixed that when my compiler complained.

> > +
> > +		return p;
> >  	}
> >  
> >  again:
> 
> I'll respin the patch with these changes.

No need; I have the following queued:

---
Subject: sched: Skip double execution of pick_next_task_fair
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 24 Apr 2014 12:00:47 +0200

Tim wrote:

The current code will call pick_next_task_fair a second time in the
slow path if we did not pull any task in our first try.  This is
really unnecessary as we already know no task can be pulled and it
doubles the delay for the cpu to enter idle.

We instrumented some network workloads and that saw that
pick_next_task_fair is frequently called twice before a cpu enters
idle.  The call to pick_next_task_fair can add non trivial latency as
it calls load_balance which runs find_busiest_group on an hierarchy of
sched domains spanning the cpus for a large system.  For some 4 socket
systems, we saw almost 0.25 msec spent per call of pick_next_task_fair
before a cpu can be idled.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Reported-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140424100047.GP11096@twins.programming.kicks-ass.net
---
---
 kernel/sched/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2605,8 +2605,14 @@ pick_next_task(struct rq *rq, struct tas
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
+			p = idle_sched_class.pick_next_task(rq, prev);
+
+		return p;
 	}
 
 again:
