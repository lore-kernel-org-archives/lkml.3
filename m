Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3BUQLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:11:40 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51731 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3BUQLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:11:39 -0500
Date: Thu, 21 Feb 2013 21:36:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Skip looking at skip if next or last is set
Message-ID: <20130221160613.GA18617@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130218130146.GA7472@linux.vnet.ibm.com>
 <1361349985.10155.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1361349985.10155.1.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022116-7182-0000-0000-0000056D3635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2013-02-20 09:46:25]:

> On Mon, 2013-02-18 at 18:31 +0530, Srikar Dronamraju wrote:
> > pick_next_entity() prefers next, then last. However code checks if the
> > left entity can be skipped even if next / last is set.
> > 
> > Check if left entity should be skipped only if next/last is not set.
> 
> You fail to explain why its a problem and continue to make a horrid mess
> of the code..
> 

If we look at the comments above pick_next_entity(),  it states:
/*
 * Pick the next process, keeping these things in mind, in this order:
 * 1) keep things fair between processes/task groups
 * 2) pick the "next" process, since someone really wants that to run
 * 3) pick the "last" process, for cache locality
 * 4) do not run the "skip" process, if something else is available
 */ 

Currently the code checks in the reverse order, though the preference is
correctly maintained as listed in comments.  But in some cases, we might be
doing redundant checks.  Lets assume next is set, then we should avoid 
checking for skip, last and their fairness with left.

So what I intended to do was change the order, i.e check for last only if next
is not set (or was picking next was unfair wrt left) and check for "something
else (second from left)" if last is not set (or picking last was unfair wrt
left).

However after sending the patch, I stumbled across these links.
https://lkml.org/lkml/2012/1/16/500 and https://lkml.org/lkml/2012/1/25/195

> > Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > ---
> >  kernel/sched/fair.c |   31 +++++++++++++++----------------
> >  1 files changed, 15 insertions(+), 16 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index fdee793..cc97b12 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1900,27 +1900,26 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
> >  	struct sched_entity *left = se;
> >  
> >  	/*
> > -	 * Avoid running the skip buddy, if running something else can
> > -	 * be done without getting too unfair.
> > +	 * Someone really wants next to run. If it's not unfair, run it.
> >  	 */
> > -	if (cfs_rq->skip == se) {
> > -		struct sched_entity *second = __pick_next_entity(se);
> > +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> > +		se = cfs_rq->next;
> > +	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
> > +		/*
> > +		 * Prefer last buddy, try to return the CPU to a preempted
> > +		 * task.
> > +		 */
> > +		se = cfs_rq->last;
> > +	} else if (cfs_rq->skip == left) {
> > +		/*
> > +		 * Avoid running the skip buddy, if running something else
> > +		 * can be done without getting too unfair.
> > +		 */
> > +		struct sched_entity *second = __pick_next_entity(left);
> >  		if (second && wakeup_preempt_entity(second, left) < 1)
> >  			se = second;
> >  	}
> >  
> > -	/*
> > -	 * Prefer last buddy, try to return the CPU to a preempted task.
> > -	 */
> > -	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
> > -		se = cfs_rq->last;
> > -
> > -	/*
> > -	 * Someone really wants this to run. If it's not unfair, run it.
> > -	 */
> > -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
> > -		se = cfs_rq->next;
> > -
> >  	clear_buddies(cfs_rq, se);
> >  
> >  	return se;
> > 
> 
> 

-- 
Thanks and Regards
Srikar Dronamraju

