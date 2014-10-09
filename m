Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaJIXXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:23:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57357 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaJIXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:23:00 -0400
Date: Thu, 9 Oct 2014 16:22:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] clk: Make clk API return per-user struct clk
 instances
Message-ID: <20141009232258.GG5493@codeaurora.org>
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412866903-6970-8-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412866903-6970-8-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Tomeu Vizoso wrote:
>  arch/arm/mach-omap2/cclock3xxx_data.c   | 108 ++++--
>  arch/arm/mach-omap2/clock.h             |  11 +-
>  arch/arm/mach-omap2/clock_common_data.c |   5 +-
>  drivers/clk/clk.c                       | 630 ++++++++++++++++++++------------
>  drivers/clk/clk.h                       |   5 +
>  drivers/clk/clkdev.c                    |  24 +-
>  include/linux/clk-private.h             |  35 +-
>  include/linux/clk-provider.h            |  22 +-
>  8 files changed, 549 insertions(+), 291 deletions(-)

The difstat looks good.

> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index fb820bf..4db918a 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -695,6 +731,13 @@ struct clk *__clk_lookup(const char *name)
>  	return NULL;
>  }
>  
> +struct clk *__clk_lookup(const char *name)
> +{
> +	struct clk_core *clk = clk_core_lookup(name);
> +
> +	return !clk ? NULL : clk->hw->clk;

This just looks weird with clk->hw->clk. I know we're trying to
keep the diff small by not renaming clk to core when it's used
extensively throughout the code, but for small little additions
like this I would prefer we use core for clk_core pointers and
clk for clk pointers. Then a patch at the end can rename
everything to be consistent. This thing also threw me off because
I searched for kfree(core) but couldn't find it so I thought we
leaked the clk_core structure.

> +}
> +
>  /*
>   * Helper for finding best parent to provide a given frequency. This can be used
>   * directly as a determine_rate callback (e.g. for a mux), or from a more
> @@ -2175,24 +2298,24 @@ void clk_unregister(struct clk *clk)
>  	 * a reference to this clock.
>  	 */
>  	flags = clk_enable_lock();
> -	clk->ops = &clk_nodrv_ops;
> +	clk->core->ops = &clk_nodrv_ops;
>  	clk_enable_unlock(flags);
>  
> -	if (!hlist_empty(&clk->children)) {
> -		struct clk *child;
> +	if (!hlist_empty(&clk->core->children)) {
> +		struct clk_core *child;
>  		struct hlist_node *t;
>  
>  		/* Reparent all children to the orphan list. */
> -		hlist_for_each_entry_safe(child, t, &clk->children, child_node)
> -			clk_set_parent(child, NULL);
> +		hlist_for_each_entry_safe(child, t, &clk->core->children, child_node)
> +			clk_core_set_parent(child, NULL);
>  	}
>  
> -	hlist_del_init(&clk->child_node);
> +	hlist_del_init(&clk->core->child_node);
>  
> -	if (clk->prepare_count)
> +	if (clk->core->prepare_count)
>  		pr_warn("%s: unregistering prepared clock: %s\n",
> -					__func__, clk->name);
> -	kref_put(&clk->ref, __clk_release);
> +					__func__, clk->core->name);
> +	kref_put(&clk->core->ref, __clk_release);
>  
>  	clk_prepare_unlock();

It might be worth it to make a "core" local variable in this
function.

>  }
> @@ -2255,32 +2378,38 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
>  }
>  EXPORT_SYMBOL_GPL(devm_clk_unregister);
>  
> +static void clk_core_put(struct clk_core *clk)
> +{
> +	struct module *owner;
> +
> +	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +		return;
> +
> +	clk_prepare_lock();
> +	owner = clk->owner;

Same here too, we don't need to protect the access to owner so it
can move outside the lock.

> +	kref_put(&clk->ref, __clk_release);
> +	module_put(owner);
> +	clk_prepare_unlock();
> +}
> +
>  /*
>   * clkdev helpers
>   */
>  int __clk_get(struct clk *clk)
>  {
>  	if (clk) {
> -		if (!try_module_get(clk->owner))
> +		if (!try_module_get(clk->core->owner))
>  			return 0;
>  
> -		kref_get(&clk->ref);
> +		kref_get(&clk->core->ref);
>  	}
>  	return 1;

Grow a core pointer?

>  }
> @@ -2391,6 +2520,31 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL_GPL(clk_notifier_unregister);
>  
> +struct clk *__clk_create_clk(struct clk_hw *hw, const char *dev_id,

Curious, why the underscore?

> +			     const char *con_id)
> +{
> +	struct clk *clk;
> +
> +	/* This is to allow this function to be chained to others */
> +	if (!hw || IS_ERR(hw))
> +		return (struct clk *) hw;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return ERR_PTR(-ENOMEM);
> +
> +	clk->core = hw->core;
> +	clk->dev_id = dev_id;
> +	clk->con_id = con_id;
> +
> +	return clk;
> +}
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index da4bda8..4411db6 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -69,6 +70,10 @@ struct clk *of_clk_get(struct device_node *np, int index)
>  
>  	clk = of_clk_get_by_clkspec(&clkspec);
>  	of_node_put(clkspec.np);
> +
> +	if (!IS_ERR(clk))
> +		clk = __clk_create_clk(__clk_get_hw(clk), np->full_name, NULL);

We lost the debugging information here about the device
requesting this clock and the name they called it. We get the
device node name but that might not match the device name. We
probably need to make private functions in here that allow such
information to be passed without changing the API for
of_clk_get(), of_clk_get_by_name(), etc.

> +
>  	return clk;
>  }
>  EXPORT_SYMBOL(of_clk_get);
> @@ -168,14 +173,29 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
>  struct clk *clk_get_sys(const char *dev_id, const char *con_id)
>  {
>  	struct clk_lookup *cl;
> +	struct clk *clk = NULL;
>  
>  	mutex_lock(&clocks_mutex);
> +
>  	cl = clk_find(dev_id, con_id);
> -	if (cl && !__clk_get(cl->clk))
> +	if (!cl)
> +		goto out;
> +
> +	if (!__clk_get(cl->clk)) {
>  		cl = NULL;
> +		goto out;
> +	}
> +
> +#if defined(CONFIG_COMMON_CLK)
> +	clk = __clk_create_clk(__clk_get_hw(cl->clk), dev_id, con_id);

I was hoping we could put the clk_hw pointer next to the clk
pointer in the lookup structure. Then providers don't have to
deal with clk pointers at all and can just assign their clk_hw
pointer in the lookup. This would make most of the omap usage of
struct clk unnecessary. It doesn't seem necessary though so I
guess we can do that in another series?

> +#else
> +	clk = cl->clk;
> +#endif
> +
> +out:
>  	mutex_unlock(&clocks_mutex);
>  
> -	return cl ? cl->clk : ERR_PTR(-ENOENT);
> +	return cl ? clk : ERR_PTR(-ENOENT);
>  }
>  EXPORT_SYMBOL(clk_get_sys);
>  
> @@ -554,6 +559,19 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
>  			      unsigned long *best_parent_rate,
>  			      struct clk_hw **best_parent_p);
>  
> +/**
> + * __clk_core_to_clk - return per-user clk
> + * @clk: struct clk_core for which we want a per-user clk
> + *
> + * Returns a per-user clock that is owned by its provider. The caller shall not
> + * call clk_get() on it.
> + *
> + * This function should be only needed by implementors of
> + * clk_ops.determine_rate() and should be dropped once all have moved to a
> + * variant that returns **clk_core instead.
> + */
> +struct clk *__clk_core_to_clk(struct clk_core *clk);
> +

We can drop this now right?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
