Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaFMTSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:18:54 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:38671 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaFMTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:18:52 -0400
Message-ID: <1402687127.2431.6.camel@j-VirtualBox>
Subject: Re: [PATCH] sched: Fast idling of CPU when system is partially
 loaded
From: Jason Low <jason.low2@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueson <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2014 12:18:47 -0700
In-Reply-To: <1402676882.2970.564.camel@schen9-DESK>
References: <1402608359.2970.548.camel@schen9-DESK>
	 <1402639311.9617.84.camel@j-VirtualBox>
	 <1402676882.2970.564.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 09:28 -0700, Tim Chen wrote:
> On Thu, 2014-06-12 at 23:01 -0700, Jason Low wrote:
> > On Thu, 2014-06-12 at 14:25 -0700, Tim Chen wrote:
> > 
> > > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > ---
> > >  kernel/sched/core.c  | 12 ++++++++----
> > >  kernel/sched/fair.c  | 23 +++++++++++++++++++++--
> > >  kernel/sched/sched.h | 10 ++++++++--
> > >  3 files changed, 37 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index c6b9879..4f57221 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -2630,7 +2630,7 @@ static inline struct task_struct *
> > >  pick_next_task(struct rq *rq, struct task_struct *prev)
> > >  {
> > >  	const struct sched_class *class = &fair_sched_class;
> > > -	struct task_struct *p;
> > > +	struct task_struct *p = NULL;
> > >  
> > >  	/*
> > >  	 * Optimization: we know that if all tasks are in
> > > @@ -2638,9 +2638,13 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
> > >  	 */
> > >  	if (likely(prev->sched_class == class &&
> > >  		   rq->nr_running == rq->cfs.h_nr_running)) {
> > > -		p = fair_sched_class.pick_next_task(rq, prev);
> > > -		if (unlikely(p == RETRY_TASK))
> > > -			goto again;
> > > +
> > > +		/* If no cpu has more than 1 task, skip */
> > > +		if (rq->nr_running > 0 || rq->rd->overload) {
> > 
> > Hi Tim,
> > 
> > If it is skipping if no cpu has more than 1 task, should the
> > above have the additional check for (rq->nr_running > 1) instead
> > of (rq->nr_running > 0)?
> 
> If you have a job on your local cpu, you do want to have the scheduler
> pick the task to run.

I see. In that case, if a CPU is going idle, it still needs to call
idle_balance() to update rq->idle_stamp and rq->next_balance (even if we
skip calling the expensive load_balance).

What do you think about moving the overload check to the top of
idle_balance():

        this_rq->idle_stamp = rq_clock(this_rq);
 
-       if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+       if (this_rq->avg_idle < sysctl_sched_migration_cost ||
+           !this_rq->rd->overload) {
                rcu_read_lock();
                sd = rcu_dereference_check_sched_domain(this_rq->sd);
                if (sd)


