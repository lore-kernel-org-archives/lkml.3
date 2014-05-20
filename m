Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaETTdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:33:02 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56662 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaETTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:33:00 -0400
Date: Tue, 20 May 2014 21:32:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5/5] workqueue: Allow modifying low level unbound
 workqueue cpumask
Message-ID: <20140520193253.GF17741@localhost.localdomain>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-6-git-send-email-fweisbec@gmail.com>
 <20140516205050.GM5379@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516205050.GM5379@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 04:50:50PM -0400, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Fri, May 16, 2014 at 06:16:55PM +0200, Frederic Weisbecker wrote:
> > @@ -3643,6 +3643,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> >  {
> >  	struct workqueue_attrs *new_attrs, *tmp_attrs;
> >  	struct pool_workqueue **pwq_tbl, *dfl_pwq;
> > +	cpumask_var_t saved_cpumask;
> >  	int node, ret;
> >  
> >  	/* only unbound workqueues can change attributes */
> > @@ -3653,15 +3654,25 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> >  	if (WARN_ON((wq->flags & __WQ_ORDERED) && !attrs->no_numa))
> >  		return -EINVAL;
> >  
> > +	if (!alloc_cpumask_var(&saved_cpumask, GFP_KERNEL))
> > +		goto enomem;
> > +
> >  	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
> >  	new_attrs = alloc_workqueue_attrs(GFP_KERNEL);
> >  	tmp_attrs = alloc_workqueue_attrs(GFP_KERNEL);
> > +
> >  	if (!pwq_tbl || !new_attrs || !tmp_attrs)
> >  		goto enomem;
> >  
> >  	/* make a copy of @attrs and sanitize it */
> >  	copy_workqueue_attrs(new_attrs, attrs);
> > -	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, unbounds_cpumask);
> > +
> > +	/*
> > +	 * Apply unbounds_cpumask on the new attrs for pwq and worker pools
> > +	 * creation but save the wq proper cpumask for unbound attrs backup.
> > +	 */
> > +	cpumask_and(saved_cpumask, new_attrs->cpumask, cpu_possible_mask);
> > +	cpumask_and(new_attrs->cpumask, saved_cpumask, unbounds_cpumask);
> >  
> >  	/*
> >  	 * We may create multiple pwqs with differing cpumasks.  Make a
> > @@ -3693,6 +3704,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
> >  	/* all pwqs have been created successfully, let's install'em */
> >  	mutex_lock(&wq->mutex);
> >  
> > +	cpumask_copy(new_attrs->cpumask, saved_cpumask);
> >  	copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
> 
> Yeah, this seems like the correct behavior but it's a bit nasty.
> Wouldn't creating another application copy be cleaner?

I'm not sure, you mean an intermediate call to apply_workqueue_attrs()?
But still that wouldn't solve it.

Now if you mean a new intermediate attrs instead of a plain cpumask, then
yeah that works.

> If not, can we
> at least add more comment explaining why we're doing this?

Sure.

> Hmmmm... shouldn't we be able to apply the mask to tmp_attrs?

Ah maybe after all. We just need to create the dfl with the tmp attrs.

> Also, isn't the code block involving wq_calc_node_cpumask() kinda
> broken for this?  It uses @attrs which is not masked by
> @unbounds_cpumask.  This used to be okay as whatever it calculates
> would fall in @cpu_possible_mask anyway but that no longer is the
> case, right?

Good catch. I was somehow convinced it was using new_attrs there.
But then we must pass attrs that are and'ed against unbounds_cpumask.
tmp_attrs can't be used anymore for that so we must do the and on new_attrs.

So we still need the temporary cpumask (or attrs).

> 
> Another one, why is @unbounds_cpumask passed in as an argument?  Can't
> it use the global variable directly?

That's needed for the rolling back. The new mask is only copied if
we succeed on attrs application.

We can use a global variable but then we need to store the old cpumask,
when we apply a new one, to be able to rollback on failure.

> 
> > +static int unbounds_cpumask_apply(cpumask_var_t cpumask)
> > +{
> > +	struct workqueue_struct *wq;
> > +	int ret;
> > +
> > +	lockdep_assert_held(&wq_pool_mutex);
> > +
> > +	list_for_each_entry(wq, &workqueues, list) {
> > +		struct workqueue_attrs *attrs;
> > +
> > +		if (!(wq->flags & WQ_UNBOUND))
> > +			continue;
> > +
> > +		attrs = wq_sysfs_prep_attrs(wq);
> > +		if (!attrs)
> > +			return -ENOMEM;
> > +
> > +		ret = apply_workqueue_attrs_locked(wq, attrs, cpumask);
> > +		free_workqueue_attrs(attrs);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static ssize_t unbounds_cpumask_store(struct device *dev,
> > +				      struct device_attribute *attr,
> > +				      const char *buf, size_t count)
> > +{
> > +	cpumask_var_t cpumask;
> > +	int ret = -EINVAL;
> > +
> > +	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
> > +		return -ENOMEM;
> > +
> > +	ret = cpumask_parse(buf, cpumask);
> > +	if (ret)
> > +		goto out;
> > +
> > +	get_online_cpus();
> > +	if (cpumask_intersects(cpumask, cpu_online_mask)) {
> > +		mutex_lock(&wq_pool_mutex);
> > +		ret = unbounds_cpumask_apply(cpumask);
> > +		if (ret < 0) {
> > +			/* Warn if rollback itself fails */
> > +			WARN_ON_ONCE(unbounds_cpumask_apply(wq_unbound_cpumask));
> 
> Hmmm... but there's nothing which makes rolling back more likely to
> succeed compared to the original applications.  It's gonna allocate
> more pwqs.  Triggering WARN_ON_ONCE() seems weird.

Yeah but that's the least we can do. If we fail to even recover the old cpumask,
the user should know about the half state fail.

> 
> That said, yeah, short of splitting apply_workqueue_attrs_locked()
> into two stages - alloc and commit, I don't think proper error
> recovery is possible.
> 
> There are a couple options, I guess.
> 
> 1. Split apply_workqueue_attrs_locked() into two stages.  The first
>    stage creates new pwqs as necessary and cache it.  Each @wq would
>    need a pointer to remember these staged pwq_tbl.  The second stage
>    commits them, which obviously can't fail.

That's already what it does. The problem is not that apply_workqueue_attrs()
fails in he middle. It's rather when we succedded to apply the new cpumask
to some workqueues, but failed with some. Then if we also fail on rollback,
we end up with some workqueue affine to the new cpumask and some others
affine to the old one.

So the only way to enforce either the new or the old affinity is to do
what you suggest but for the whole list of workqueues. So we need to allocate
first all pwqs and then apply all of them.

But it's going to imply fun with double linked list of struct pwq_allocation_object
and stuff. Or maybe an array. This reminds be a bit generate_sched_domains(). It's
not going to be _that_ simple nor pretty :)

> 
> 2. Proper error handling is hard.  Just do pr_warn() on each failure
>    and continue to try to apply and always return 0.
> 
> If #1 isn't too complicated (would it be?), it'd be the better option;
> otherwise, well, #2 should work most of the time, eh?

Yeah I think #2 should be way enough 99% of the time :)
