Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaJJXzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:55:44 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52148 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaJJXzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:55:43 -0400
Date: Fri, 10 Oct 2014 16:55:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/8] clk: Add floor and ceiling constraints to clock
 rates
Message-ID: <20141010235541.GH5493@codeaurora.org>
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412866903-6970-9-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412866903-6970-9-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 4db918a..97cf1a3 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1629,18 +1609,27 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
>  	/* prevent racing with updates to the clock topology */
>  	clk_prepare_lock();
>  
> +	hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
> +		rate = max(rate, clk_user->floor_constraint);
> +	}
> +
> +	hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
> +		if (clk_user->ceiling_constraint > 0)
> +			rate = min(rate, clk_user->ceiling_constraint);
> +	}
> +
>  	/* bail early if nothing to do */
> -	if (rate == clk_get_rate(clk))
> +	if (rate == clk_core_get_rate(clk))

Can we use the nolock variant here? As an aside, this is going to
make my per-clock locking series complicated. I'm not even sure
how the two series will work together. In the per-clock locking
series I was hoping we could check if rate == current rate
without holding any locks. Otherwise we get into a recursive lock
situation. Need to think more about that one.

>  		goto out;
>  
> -	if ((clk->core->flags & CLK_SET_RATE_GATE) &&
> -	    clk->core->prepare_count) {
> +	if ((clk->flags & CLK_SET_RATE_GATE) &&
> +	    clk->prepare_count) {
>  		ret = -EBUSY;
>  		goto out;
>  	}
>  
>  	/* calculate new rates and get the topmost changed clock */
> -	top = clk_calc_new_rates(clk->core, rate);
> +	top = clk_calc_new_rates(clk, rate);
>  	if (!top) {
>  		ret = -EINVAL;
>  		goto out;
> @@ -1664,8 +1653,69 @@ out:
[...]
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	return clk_core_set_rate(clk->core, rate);
> +}
>  EXPORT_SYMBOL_GPL(clk_set_rate);
>  

What about clk_round_rate()? That needs to tell us what the rate
will be if we call clk_set_rate() with whatever value is passed
here. I would expect that the rate aggregation logic would be
somewhere in that codepath but I don't see it.


> +int clk_set_floor_rate(struct clk *clk, unsigned long rate)

We need some documentation for these new functions. I see we have
them in the header, maybe we can copy that here.

> +{
> +	int ret;
> +
> +	clk_prepare_lock();
> +
> +	clk->floor_constraint = rate;

No check for ceiling being less than floor?

> +	ret = clk_set_rate(clk, clk_get_rate(clk));
> +
> +	clk_prepare_unlock();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_floor_rate);
> +
> +int clk_set_ceiling_rate(struct clk *clk, unsigned long rate)
> +{
> +	int ret;
> +
> +	clk_prepare_lock();

We don't need to grab the lock this early right? Presumably the
caller is doing any required locking so they don't call different
clk APIs for the same clk pointer at the same time. So we should
be able to grab this lock after checking for this error
condition.

> +
> +	WARN(rate > 0 && rate < clk->floor_constraint,
> +	     "clk %s dev %s con %s: new ceiling %lu lower than existing floor %lu\n",
> +	     clk->core->name, clk->dev_id, clk->con_id, rate,
> +	     clk->floor_constraint);
> +
> +	clk->ceiling_constraint = rate;
> +	ret = clk_set_rate(clk, clk_get_rate(clk));

Why not just pass 0 as the second argument? The same comment
applies in the floor function.

> +
> +	clk_prepare_unlock();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
> +
>  static struct clk_core *clk_core_get_parent(struct clk_core *clk)
>  {
>  	struct clk_core *parent;
> @@ -2143,6 +2195,12 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
>  }
>  EXPORT_SYMBOL_GPL(__clk_register);
>  
> +static void __clk_free_clk(struct clk *clk_user)
> +{
> +	hlist_del(&clk_user->child_node);
> +	kfree(clk_user);

We need to re-evaluate the rate when a user is removed, right?

This leads to another question though. What does it means for a
per-user clock to be disabled and change it's floor or ceiling?
Should that count in the aggregation logic?

So far we haven't required drivers to explicitly call
clk_set_rate() with 0 so they can "drop" their rate request
because there isn't any other user and disabling the clock is
pretty much the same. With multiple users it looks like we're
going to require them to set the floor or ceiling to 0 or INT_MAX
if they want to remove their request. Alternatively we could
track the prepare/unprepare state of the per-user clock and drop
the constraint when that instance is unprepared (or reapply it
when prepared). It's pretty much a semantic difference, but one
benefit would be that we don't have to make two (or three?) calls
to the clock framework if we want to drop the rate constraints
and disable the clock.

> +}
> +
>  /**
>   * clk_register - allocate a new clock, register it and return an opaque cookie
>   * @dev: device that is registering this clock
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 1cdb727..025aca2 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -50,6 +50,7 @@ struct clk_core {
>  	struct hlist_head	children;
>  	struct hlist_node	child_node;
>  	struct hlist_node	debug_node;
> +	struct hlist_head	per_user_clks;

Can we just call it 'clks'?

>  	unsigned int		notifier_count;
>  #ifdef CONFIG_DEBUG_FS
>  	struct dentry		*dentry;
> @@ -61,6 +62,10 @@ struct clk {
>  	struct clk_core	*core;
>  	const char *dev_id;
>  	const char *con_id;
> +
> +	unsigned long	floor_constraint;
> +	unsigned long	ceiling_constraint;
> +	struct hlist_node child_node;
>  };
>  

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
