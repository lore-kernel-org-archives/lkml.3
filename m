Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaETT5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:57:00 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34246 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaETT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:56:59 -0400
Date: Tue, 20 May 2014 15:56:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5/5] workqueue: Allow modifying low level unbound
 workqueue cpumask
Message-ID: <20140520195656.GA5586@htj.dyndns.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-6-git-send-email-fweisbec@gmail.com>
 <20140516205050.GM5379@htj.dyndns.org>
 <20140520193253.GF17741@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520193253.GF17741@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 20, 2014 at 09:32:55PM +0200, Frederic Weisbecker wrote:
> > > +	cpumask_copy(new_attrs->cpumask, saved_cpumask);
> > >  	copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
> > 
> > Yeah, this seems like the correct behavior but it's a bit nasty.
> > Wouldn't creating another application copy be cleaner?
> 
> I'm not sure, you mean an intermediate call to apply_workqueue_attrs()?
> But still that wouldn't solve it.

Oh I meant making anohter copy of attrs for application so that we
don't have to modify @new_attrs and then revert it.

> Now if you mean a new intermediate attrs instead of a plain cpumask, then
> yeah that works.

Yeap.

> > If not, can we
> > at least add more comment explaining why we're doing this?
> 
> Sure.
> 
> > Hmmmm... shouldn't we be able to apply the mask to tmp_attrs?
> 
> Ah maybe after all. We just need to create the dfl with the tmp attrs.
> 
> > Also, isn't the code block involving wq_calc_node_cpumask() kinda
> > broken for this?  It uses @attrs which is not masked by
> > @unbounds_cpumask.  This used to be okay as whatever it calculates
> > would fall in @cpu_possible_mask anyway but that no longer is the
> > case, right?
> 
> Good catch. I was somehow convinced it was using new_attrs there.
> But then we must pass attrs that are and'ed against unbounds_cpumask.
> tmp_attrs can't be used anymore for that so we must do the and on new_attrs.
> 
> So we still need the temporary cpumask (or attrs).
> 
> > Another one, why is @unbounds_cpumask passed in as an argument?  Can't
> > it use the global variable directly?
> 
> That's needed for the rolling back. The new mask is only copied if
> we succeed on attrs application.
> 
> We can use a global variable but then we need to store the old cpumask,
> when we apply a new one, to be able to rollback on failure.

I see.

> > > +	if (cpumask_intersects(cpumask, cpu_online_mask)) {
> > > +		mutex_lock(&wq_pool_mutex);
> > > +		ret = unbounds_cpumask_apply(cpumask);
> > > +		if (ret < 0) {
> > > +			/* Warn if rollback itself fails */
> > > +			WARN_ON_ONCE(unbounds_cpumask_apply(wq_unbound_cpumask));
> > 
> > Hmmm... but there's nothing which makes rolling back more likely to
> > succeed compared to the original applications.  It's gonna allocate
> > more pwqs.  Triggering WARN_ON_ONCE() seems weird.
> 
> Yeah but that's the least we can do. If we fail to even recover the old cpumask,
> the user should know about the half state fail.

I'm failing to see how it'd be better than just going through applying
the new mask if we're likely to end up with half-updated states
anyway.  What's the point of another layer of best effort logic which
is more likely to fail?

> > 1. Split apply_workqueue_attrs_locked() into two stages.  The first
> >    stage creates new pwqs as necessary and cache it.  Each @wq would
> >    need a pointer to remember these staged pwq_tbl.  The second stage
> >    commits them, which obviously can't fail.
> 
> That's already what it does. The problem is not that apply_workqueue_attrs()
> fails in he middle. It's rather when we succedded to apply the new cpumask
> to some workqueues, but failed with some. Then if we also fail on rollback,
> we end up with some workqueue affine to the new cpumask and some others
> affine to the old one.

No, what I mean is split apply_workqueue_attrs() itself into two
stages so that it can do all the allocations up-front and then do a
separate commit stage which can't fail.  That way, either all changes
are applied or none.

> So the only way to enforce either the new or the old affinity is to do
> what you suggest but for the whole list of workqueues. So we need to allocate
> first all pwqs and then apply all of them.

Yes yes. :)

> But it's going to imply fun with double linked list of struct pwq_allocation_object
> and stuff. Or maybe an array. This reminds be a bit generate_sched_domains(). It's
> not going to be _that_ simple nor pretty :)

Is it tho?  Don't we just need to keep a separate staging copy of
prepared pwq_tbl?  The commit stage can be pwq_tbl installation.
Looks like it shouldn't be too much of problem.  Am I missing
something?

> > 2. Proper error handling is hard.  Just do pr_warn() on each failure
> >    and continue to try to apply and always return 0.
> > 
> > If #1 isn't too complicated (would it be?), it'd be the better option;
> > otherwise, well, #2 should work most of the time, eh?
> 
> Yeah I think #2 should be way enough 99% of the time :)

Yeah, if #1 gets too hairy, #2 can be a reluctant option but if #1 is
doable without too much complication, I'd much prefer proper error
handling.

Thanks.

-- 
tejun
