Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaKEQZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:25:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKEQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:25:40 -0500
Date: Wed, 5 Nov 2014 17:25:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
Message-ID: <20141105162531.GV3337@twins.programming.kicks-ass.net>
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com>
 <1415193240.28592.14.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415193240.28592.14.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:14:00PM +0300, Kirill Tkhai wrote:
> > @@ -538,6 +539,39 @@ again:
> >  	update_rq_clock(rq);
> >  	dl_se->dl_throttled = 0;
> >  	dl_se->dl_yielded = 0;
> > +
> > +	/*
> > +	 * So if we find that the rq the task was on is no longer
> > +	 * available, we need to select a new rq.
> > +	 */
> > +	if (!rq->online) {
> > +		struct rq *later_rq = NULL;
> > +
> > +		/* We will release rq lock */
> > +		get_task_struct(p);

No need for this, due to task_dead_dl() -> hrtimer_cancel() this task
cannot go away while the timer callback is running.

> > +		raw_spin_unlock(&rq->lock);
> > +
> > +		later_rq = find_lock_later_rq(p, rq);
> > +
> > +		if (!later_rq) {
> > +			put_task_struct(p);
> > +			goto out;
> > +		}

This is wrong I think, we _must_ migrate the task, if we let it reside
on this offline rq it will never come back to us.

find_lock_later_rq() will fail for tasks that aren't currently eligible
to run. You could either try and change/parameterize it to return the
latest rq in that case, or just punt and pick any online cpu.

> isn't this too complicated?
> 
> Can't we simply queue throttled tasks in rq_offline_dl() (without clearing
> of dl_throttled() status)? migrate_tasks() will do the migration right.

We can't find these tasks, we'd have to add extra lists etc. And it
seems consistent with the normal ttwu thing, which migrates tasks when
they wake up.


