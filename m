Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbbAQBCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:02:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33262 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbAQBCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:02:42 -0500
Date: Fri, 16 Jan 2015 17:02:38 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND v8 1/2] clk: Make clk API return per-user struct
 clk instances
Message-ID: <20150117010238.GA27202@codeaurora.org>
References: <1421071809-17402-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421071809-17402-2-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421071809-17402-2-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Tomeu Vizoso wrote:
> Moves clock state to struct clk_core, but takes care to change as little API as
> possible.
> 
> struct clk_hw still has a pointer to a struct clk, which is the
> implementation's per-user clk instance, for backwards compatibility.
> 
> The struct clk that clk_get_parent() returns isn't owned by the caller, but by
> the clock implementation, so the former shouldn't call clk_put() on it.
> 
> Because some boards in mach-omap2 still register clocks statically, their clock
> registration had to be updated to take into account that the clock information
> is stored in struct clk_core now.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> 

Looks mostly good. Missing some NULL checks mostly.

> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index f4963b7..7eddfd8 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -114,7 +123,7 @@ static struct hlist_head *orphan_list[] = {
> +static void clk_summary_show_one(struct seq_file *s, struct clk_core *c, int level)
>  {
>  	if (!c)
>  		return;
> @@ -122,14 +131,14 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
[...]
> -static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
> +static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
>  				     int level)
>  {
> -	struct clk *child;
> +	struct clk_core *child;
>  
>  	if (!c)
>  		return;
> @@ -172,7 +181,7 @@ static const struct file_operations clk_summary_fops = {
>  	.release	= single_release,
>  };
>  
> -static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
> +static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
>  {
>  	if (!c)
>  		return;
> @@ -180,14 +189,14 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
[...]
> -static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
> +static void clk_dump_subtree(struct seq_file *s, struct clk_core *c, int level)
>  {
> -	struct clk *child;
> +	struct clk_core *child;
>  
>  	if (!c)
>  		return;
> @@ -418,19 +427,20 @@ static int __init clk_debug_init(void)
[...]
>  
>  /* caller must hold prepare_lock */
> -static void clk_unprepare_unused_subtree(struct clk *clk)
> +static void clk_unprepare_unused_subtree(struct clk_core *clk)
>  {
> -	struct clk *child;
> +	struct clk_core *child;
>  
>  	if (!clk)
>  		return;
> @@ -453,9 +463,9 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
>  }
>  
>  /* caller must hold prepare_lock */
> -static void clk_disable_unused_subtree(struct clk *clk)
> +static void clk_disable_unused_subtree(struct clk_core *clk)
>  {
> -	struct clk *child;
> +	struct clk_core *child;
>  	unsigned long flags;
>  
>  	if (!clk)

Note: These NULL checks look bogus. No need to fix them here, but
a patch to remove them would be nice.

> @@ -532,48 +542,59 @@ late_initcall_sync(clk_disable_unused);
[...]
> +
> +struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
> +{
> +	struct clk_core *parent;
> +
> +	parent = clk_core_get_parent_by_index(clk->core, index);

I suppose clk could be NULL here (although this is mostly a
clk-provider function). At least before we would return NULL in
such a case so we should keep the same behavior instead of NULL
deref.

> +
> +	return !parent ? NULL : parent->hw->clk;
> +}
>  EXPORT_SYMBOL_GPL(clk_get_parent_by_index);
>  
> @@ -593,9 +614,14 @@ unsigned long __clk_get_rate(struct clk *clk)
>  out:
>  	return ret;
>  }
> +
> +unsigned long __clk_get_rate(struct clk *clk)
> +{
> +	return clk_core_get_rate_nolock(clk->core);

Oops. clk can be NULL here. We should check for that and return
0.

> +}
>  EXPORT_SYMBOL_GPL(__clk_get_rate);
>  
> @@ -630,7 +656,12 @@ out:
>  	return !!ret;
>  }
>  
> -bool __clk_is_enabled(struct clk *clk)
> +bool __clk_is_prepared(struct clk *clk)
> +{
> +	return clk_core_is_prepared(clk->core);

Oops. clk can be NULL here. Return false if so. Or drop the
function entirely? It looks like it may become unused.

> +}
> @@ -650,12 +681,17 @@ bool __clk_is_enabled(struct clk *clk)
>  out:
>  	return !!ret;
>  }
> +
> +bool __clk_is_enabled(struct clk *clk)
> +{
> +	return clk_core_is_enabled(clk->core);

Oops. clk can be NULL here. Return false if so.

> +}
>  EXPORT_SYMBOL_GPL(__clk_is_enabled);
>  
> @@ -762,7 +805,12 @@ void __clk_unprepare(struct clk *clk)
>  	if (clk->ops->unprepare)
>  		clk->ops->unprepare(clk->hw);
>  
> -	__clk_unprepare(clk->parent);
> +	clk_core_unprepare(clk->parent);
> +}
> +
> +void __clk_unprepare(struct clk *clk)
> +{
> +	clk_core_unprepare(clk->core);

OOps. clk can be NULL here. Bail early if so.

>  }
>  
>  /**
> @@ -813,6 +861,11 @@ int __clk_prepare(struct clk *clk)
>  	return 0;
>  }
>  
> +int __clk_prepare(struct clk *clk)
> +{
> +	return clk_core_prepare(clk->core);

Oops. clk can be NULL here. Return 0 if so.

> +}
> +
> @@ -851,7 +904,12 @@ static void __clk_disable(struct clk *clk)
[...]
> +
> +static void __clk_disable(struct clk *clk)
> +{
> +	clk_core_disable(clk->core);

Oops. clk can be NULL here. Bail early if so. Is this function
used though?

>  }
>  
>  /**
> @@ -908,6 +966,11 @@ static int __clk_enable(struct clk *clk)
>  	return 0;
>  }
>  
> +static int __clk_enable(struct clk *clk)
> +{
> +	return clk_core_enable(clk->core);
> +}

Same problem. Is this function used either?

> +
>  /**
>   * clk_enable - ungate a clock
>   * @clk: the clk being ungated
> @@ -961,12 +1018,35 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
[...]
> +unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	return clk_core_round_rate_nolock(clk->core, rate);

Oops. clk can be NULL here. Return 0 if so.

> +}
>  EXPORT_SYMBOL_GPL(__clk_round_rate);
>  
> @@ -978,13 +1058,7 @@ EXPORT_SYMBOL_GPL(__clk_round_rate);
>   */
>  long clk_round_rate(struct clk *clk, unsigned long rate)
>  {
> -	unsigned long ret;
> -
> -	clk_prepare_lock();
> -	ret = __clk_round_rate(clk, rate);
> -	clk_prepare_unlock();
> -
> -	return ret;
> +	return clk_core_round_rate(clk->core, rate);

Oops. clk can be NULL here. Return 0 if so.

>  }
>  EXPORT_SYMBOL_GPL(clk_round_rate);
>  
> @@ -1002,22 +1076,21 @@ EXPORT_SYMBOL_GPL(clk_round_rate);
>   * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
>   * a driver returns that.
>   */
> -static int __clk_notify(struct clk *clk, unsigned long msg,
> +static int __clk_notify(struct clk_core *clk, unsigned long msg,
>  		unsigned long old_rate, unsigned long new_rate)
>  {
>  	struct clk_notifier *cn;
>  	struct clk_notifier_data cnd;
>  	int ret = NOTIFY_DONE;
>  
> -	cnd.clk = clk;
>  	cnd.old_rate = old_rate;
>  	cnd.new_rate = new_rate;
>  
>  	list_for_each_entry(cn, &clk_notifier_list, node) {
> -		if (cn->clk == clk) {
> +		if (cn->clk->core == clk) {
> +			cnd.clk = cn->clk;
>  			ret = srcu_notifier_call_chain(&cn->notifier_head, msg,
>  					&cnd);
> -			break;

Ah now the list is full of struct clk pointers that are unique so
we drop the break here? It would be good if someone:

 1) Made a notifier_head per clk_core structure
 2) Hooked up clk notifiers to that head instead of a global list
 3) Hid struct clk_notifier in clk.c

This way when we notify the chain we don't have to loop through
all possible notifiers to find blocks containing clks that we care about
and then notify that chain which is probably only ever going to
be a single notifier long because struct clk is unique now.

>  		}
>  	}
>  
> @@ -1139,14 +1210,29 @@ unsigned long clk_get_rate(struct clk *clk)
>  	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
>  		__clk_recalc_rates(clk, 0);
>  
> -	rate = __clk_get_rate(clk);
> +	rate = clk_core_get_rate_nolock(clk);
>  	clk_prepare_unlock();
>  
>  	return rate;
>  }
> +EXPORT_SYMBOL_GPL(clk_core_get_rate);
> +
> +/**
> + * clk_get_rate - return the rate of clk
> + * @clk: the clk whose rate is being returned
> + *
> + * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
> + * is set, which means a recalc_rate will be issued.
> + * If clk is NULL then returns 0.
> + */
> +unsigned long clk_get_rate(struct clk *clk)
> +{
> +	return clk_core_get_rate(clk->core);
> +}
>  EXPORT_SYMBOL_GPL(clk_get_rate);
>  
> -static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
> +static int clk_fetch_parent_index(struct clk_core *clk,
> +				  struct clk_core *parent)
>  {
>  	int i;
>  
> @@ -1366,7 +1457,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>  		new_rate = clk->ops->determine_rate(clk->hw, rate,
>  						    &best_parent_rate,
>  						    &parent_hw);
> -		parent = parent_hw->clk;
> +		parent = parent_hw ? parent_hw->core : NULL;

Here's the fix!

>  	} else if (clk->ops->round_rate) {
>  		new_rate = clk->ops->round_rate(clk->hw, rate,
>  						&best_parent_rate);
> @@ -1574,6 +1667,18 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(clk_set_rate);
>  
> +static struct clk_core *clk_core_get_parent(struct clk_core *core)
> +{
> +	struct clk_core *parent;
> +
> +	clk_prepare_lock();
> +	parent = !core ? NULL : core->parent;

Looks wrong. core should never be NULL?

> +	clk_prepare_unlock();
> +
> +	return parent;
> +}
> +EXPORT_SYMBOL_GPL(clk_core_get_parent);
> +
>  /**
>   * clk_get_parent - return the parent of a clk
>   * @clk: the clk whose parent gets returned
> @@ -1582,13 +1687,11 @@ EXPORT_SYMBOL_GPL(clk_set_rate);
>   */
>  struct clk *clk_get_parent(struct clk *clk)
>  {
> -	struct clk *parent;
> +	struct clk_core *parent;
>  
> -	clk_prepare_lock();
> -	parent = __clk_get_parent(clk);
> -	clk_prepare_unlock();
> +	parent = clk_core_get_parent(clk->core);

Oops if clk is NULL. So far we've allowed that and returned NULL.

>  
> -	return parent;
> +	return !parent ? NULL : parent->hw->clk;
>  }
>  EXPORT_SYMBOL_GPL(clk_get_parent);
> @@ -2258,33 +2381,42 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
>  }
>  EXPORT_SYMBOL_GPL(devm_clk_unregister);
>  
> +static void clk_core_put(struct clk_core *core)
> +{
> +	struct module *owner;
> +
> +	if (!core || WARN_ON_ONCE(IS_ERR(core)))
> +		return;

This doesn't look right. When would the clk_core structure ever
be NULL or some error pointer? I would think we want to leave
this check in __clk_put() and leave it checking the struct clk
instance that we may get from some random driver.

> +
> +	owner = core->owner;
> +
> +	clk_prepare_lock();
> +	kref_put(&core->ref, __clk_release);
> +	clk_prepare_unlock();
> +
> +	module_put(owner);
> +}

Can you also move this next to __clk_put() and after __clk_get() please?

> +
>  /*
>   * clkdev helpers
>   */
>  int __clk_get(struct clk *clk)
>  {
> -	if (clk) {
> -		if (!try_module_get(clk->owner))
> +	struct clk_core *core = !clk ? NULL : clk->core;
> +
> +	if (core) {
> +		if (!try_module_get(core->owner))
>  			return 0;
>  
> -		kref_get(&clk->ref);
> +		kref_get(&core->ref);
>  	}
>  	return 1;
>  }
>  
>  void __clk_put(struct clk *clk)
>  {
> -	struct module *owner;
> -
> -	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> -		return;
> -
> -	clk_prepare_lock();
> -	owner = clk->owner;
> -	kref_put(&clk->ref, __clk_release);
> -	clk_prepare_unlock();
> -
> -	module_put(owner);
> +	clk_core_put(clk->core);

clk can be NULL here.

> +	kfree(clk);
>  }
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
