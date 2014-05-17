Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbaEQNmC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:42:02 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43060 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaEQNmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:42:00 -0400
Date: Sat, 17 May 2014 15:41:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/5] workqueue: Allow changing attributions of ordered
 workqueues
Message-ID: <20140517134151.GA32371@localhost.localdomain>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
 <20140516201225.GL5379@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516201225.GL5379@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 04:12:25PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 16, 2014 at 06:16:51PM +0200, Frederic Weisbecker wrote:
> > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Changing the attributions of a workqueue imply the addition of new pwqs
> > to replace the old ones. But the current implementation doesn't handle
> > ordered workqueues because they can't carry multi-pwqs without breaking
> > ordering. Hence ordered workqueues currently aren't allowed to call
> > apply_workqueue_attrs().
> ...
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Mike Galbraith <bitbucket@online.de>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Do you mind touching up the description and comment a bit as it's
> going through you?  They have gotten a lot better (kudos to Lai :) but
> I still feel the need to touch them up a bit before applying.  I'd
> really appreciate if you can do it as part of your series.

Sure, I mean I actually seldom apply other's patches as is. I actually edited,
reworded and reorganized this changelog a lot. Same for some comments.

But since I was still not sure that the direction was the final one, I probably
left some parts with light explanations.

I'll have a second pass, just don't hesitate to point me out comments or anything
that need improvement.

> 
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index c3f076f..c68e84f 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -1355,8 +1355,16 @@ retry:
> >  	 * If @work was previously on a different pool, it might still be
> >  	 * running there, in which case the work needs to be queued on that
> >  	 * pool to guarantee non-reentrancy.
> > +	 *
> > +	 * We guarantee that only one pwq is active on an ordered workqueue.
> > +	 * That alone enforces non-reentrancy for works. So ordered works don't
> 
> Let's use "work items" instead of "works".

Ok.

> 
> > +	 * need to be requeued to their previous pool. Not to mention that
> > +	 * an ordered work requeing itself over and over on the same pool may
> > +	 * prevent a pwq from being released in case of a pool switch. The
> > +	 * newest pool in that case couldn't switch in and its pending works
> > +	 * would starve.
> >  	 */
> > -	last_pool = get_work_pool(work);
> > +	last_pool = wq->flags & __WQ_ORDERED ? NULL : get_work_pool(work);
> >  	if (last_pool && last_pool != pwq->pool) {
> >  		struct worker *worker;
> 
> I'm not a big fan of the fact that ordered queues need to be handled
> differently when queueing, but as the code is currently written, this
> is pretty much necessary to maintain execution order, right?
>
> Otherwise, you end up with requeueing work items targeting the pwq it
> was executing on and new ones targeting the newest one screwing up the
> ordering.  I think that'd be a lot more important to note in the
> comment.  This is a correctness measure.  Back-to-back requeueing
> being affected by this is just a side-effect.

In the case of ordered workqueues it actually doesn't matter much in
term of ordering. But it's needed when pwqs are replaced (as it happens
in apply_workqueue_attrs(). We must make sure works requeueing themselves
don't always requeue to the old pwq otherwise it will never be able to
switch and be released. Also the next work items will be queued on the next
pwq but this one will never be able to run due to the old workqueue still
being used by the item requeing itself. So we also risk starvation on the
new workqueue.

But the ordering itself is actually fine for ordered workqueue. It's actually
enforced by the fact that only one pwq can run at a time for a given workqueue.

OTOH non-ordered workqueues still depend on the above machinery to ensure
ordering at the work item scope. Which is what we rather call re-entrancy.

So I think the comment is not misleading. But it may deserve to be rephrased.

> 
> Also, can you please use plain if/else instead of "?:"?  This isn't a
> simple logic and I don't think compressing it with ?: is a good idea.

Agreed, will do.

> 
> > @@ -3708,6 +3712,13 @@ static void rcu_free_pwq(struct rcu_head *rcu)
> >  			container_of(rcu, struct pool_workqueue, rcu));
> >  }
> >  
> > +static struct pool_workqueue *oldest_pwq(struct workqueue_struct *wq)
> > +{
> > +	return list_last_entry(&wq->pwqs, struct pool_workqueue, pwqs_node);
> > +}
> > +
> > +static void pwq_adjust_max_active(struct pool_workqueue *pwq);
> > +
> >  /*
> >   * Scheduled on system_wq by put_pwq() when an unbound pwq hits zero refcnt
> >   * and needs to be destroyed.
> > @@ -3723,14 +3734,12 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
> >  	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
> >  		return;
> >  
> > -	/*
> > -	 * Unlink @pwq.  Synchronization against wq->mutex isn't strictly
> > -	 * necessary on release but do it anyway.  It's easier to verify
> > -	 * and consistent with the linking path.
> > -	 */
> >  	mutex_lock(&wq->mutex);
> >  	list_del_rcu(&pwq->pwqs_node);
> >  	is_last = list_empty(&wq->pwqs);
> > +	/* try to activate the oldest pwq when needed */
> > +	if (!is_last && (wq->flags & __WQ_ORDERED))
> 
> Why bother with @is_last when it's used only once and the test is
> trivial?  Is the test even necessary?  Invoking
> pwq_adjust_max_active() directly should work, no?

It should work with is_last(). Just adjusting max_active if the
whole wq is going to be released sounds couter-intuitive. So
I find the if (!is_last && ordered) helps the code to be self-explained.

> Also, this needs
> whole lot more comment explaining what's going on.

Agreed, I'll add some details.

> 
> > +		pwq_adjust_max_active(oldest_pwq(wq));
> >  	mutex_unlock(&wq->mutex);
> >  
> >  	mutex_lock(&wq_pool_mutex);
> > @@ -3749,6 +3758,16 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
> >  	}
> >  }
> >  
> > +static bool pwq_active(struct pool_workqueue *pwq)
> > +{
> > +	/* Only the oldest pwq is active in the ordered wq */
> > +	if (pwq->wq->flags & __WQ_ORDERED)
> > +		return pwq == oldest_pwq(pwq->wq);
> > +
> > +	/* All pwqs in the non-ordered wq are active */
> > +	return true;
> > +}
> 
> Just collapse it into the calling function.  This obfuscates more than
> helps.

Yeah but the condition is already big. Lets hope the result won't be too ugly.

> 
> Thanks.
> 
> -- 
> tejun
