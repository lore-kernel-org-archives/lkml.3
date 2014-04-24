Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaDXMow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:44:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaDXMot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:44:49 -0400
Date: Thu, 24 Apr 2014 14:44:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
Message-ID: <20140424124438.GT13658@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
 <5358E417.8090503@linux.vnet.ibm.com>
 <20140424120415.GS11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424120415.GS11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 02:04:15PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 03:44:47PM +0530, Preeti U Murthy wrote:
> > What about the update of next_balance field? See the code snippet below.
> > This will also be skipped as a consequence of the commit e5fc6611 right?
> > 
> > 	   if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
> >                  /*
> >                   * We are going idle. next_balance may be set based on
> >                   * a busy processor. So reset next_balance.
> >                   */
> >                  this_rq->next_balance = next_balance;
> >          }
> > 
> > Also the comment in the above snippet does not look right to me.
> > It says "we are going idle" but the condition checks for pulled_task.
> 
> Yeah, that's odd indeed. Ingo did that back in dd41f596cda0d, I suspect
> its an error, but..
> 
> So I think that should become !pulled_task || time_after().

Hmm, no, I missed that the for_each_domain() loop pushes next_balance
ahead if it did a balance on the domain.

So it actually makes sense and the comment is wrong, but then you're
also right that we want to not skip that.

So how about something like so?

---
Subject: sched,fair: Fix idle_balance()'s pulled_task logic
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu Apr 24 14:24:20 CEST 2014

Jason reported that we can fail to update max_idle_balance_cost, even
if we actually did try to find one.

Preeti then noticed that the next_balance update logic was equally
flawed.

So fix both and update the comments.

Fixes: e5fc66119ec9 ("sched: Fix race in idle_balance()")
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Reported-by: Jason Low <jason.low2@hp.com>
Reported-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6711,21 +6711,18 @@ static int idle_balance(struct rq *this_
 	raw_spin_lock(&this_rq->lock);
 
 	/*
-	 * While browsing the domains, we released the rq lock.
-	 * A task could have be enqueued in the meantime
+	 * If we pulled a task (or if the interval expired), we did a balance
+	 * pass, so update next_balance.
 	 */
-	if (this_rq->cfs.h_nr_running && !pulled_task) {
-		pulled_task = 1;
-		goto out;
-	}
-
-	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
-		/*
-		 * We are going idle. next_balance may be set based on
-		 * a busy processor. So reset next_balance.
-		 */
+	if (pulled_task || time_after(jiffies, this_rq->next_balance))
 		this_rq->next_balance = next_balance;
-	}
+
+	/*
+	 * While browsing the domains, we released the rq lock, a task could
+	 * have been enqueued in the meantime.
+	 */
+	if (this_rq->cfs.h_nr_running && !pulled_task)
+		pulled_task = 1;
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
