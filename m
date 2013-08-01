Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3HAPGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:06:55 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:59420 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755442Ab3HAPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:06:54 -0400
Message-ID: <51FA798A.7090500@overkiz.com>
Date: Thu, 01 Aug 2013 17:06:50 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [RFC PATCH 1/2] clk: add clk accuracy retrieval support
References: <1375369339-27942-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375369339-27942-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8829870019777886329
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -85
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, I forgot to add "--in-reply-to" option.

On 01/08/2013 17:02, Boris BREZILLON wrote:
> The clock accuracy is expressed in ppb (parts per billion) and represents
> the possible clock drift.
> Say you have a clock (e.g. an oscillator) which provides a fixed clock of
> 20MHz with an accuracy of +- 20Hz. This accuracy expressed in ppb is
> 20Hz/20MHz = 1000 ppb (or 1 ppm).
>
> Clock users may need the clock accuracy information in order to choose
> the best clock (the one with the best accuracy) across several available
> clocks.
>
> This patch adds clk accuracy retrieval support for common clk framework by
> means of a new function called clk_get_accuracy.
> This function returns the given clock accuracy expressed in ppb.
>
> In order to get the clock accuracy, this implementation adds one callback
> called recalc_accuracy to the clk_ops structure.
> This callback is given the parent clock accuracy (if the clock is not a
> root clock) and should recalculate the given clock accuracy.
>
> This callback is optional and may be implemented if the clock is not
> a perfect clock (accuracy != 0 ppb).
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   Documentation/clk.txt        |    4 ++
>   drivers/clk/Kconfig          |    4 ++
>   drivers/clk/clk.c            |   91 ++++++++++++++++++++++++++++++++++++++++--
>   include/linux/clk-private.h  |    1 +
>   include/linux/clk-provider.h |   11 +++++
>   include/linux/clk.h          |   17 ++++++++
>   6 files changed, 124 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index 6f68ba0..869a4a3 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -73,6 +73,8 @@ the operations defined in clk.h:
>   		int		(*set_parent)(struct clk_hw *hw, u8 index);
>   		u8		(*get_parent)(struct clk_hw *hw);
>   		int		(*set_rate)(struct clk_hw *hw, unsigned long);
> +		unsigned long	(*recalc_accuracy)(struct clk_hw *hw,
> +						   unsigned long parent_accuracy);
>   		void		(*init)(struct clk_hw *hw);
>   	};
>   
> @@ -197,6 +199,8 @@ optional or must be evaluated on a case-by-case basis.
>   .set_parent  |      |             | n             | y           | n    |
>   .get_parent  |      |             | n             | y           | n    |
>                |      |             |               |             |      |
> +.recalc_rate |      |             |               |             |      |
> +             |      |             |               |             |      |
>   .init        |      |             |               |             |      |
>   	     -----------------------------------------------------------
>   
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 51380d6..205a19b 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -6,12 +6,16 @@ config CLKDEV_LOOKUP
>   config HAVE_CLK_PREPARE
>   	bool
>   
> +config HAVE_CLK_GET_ACCURACY
> +	bool
> +
>   config HAVE_MACH_CLKDEV
>   	bool
>   
>   config COMMON_CLK
>   	bool
>   	select HAVE_CLK_PREPARE
> +	select HAVE_CLK_GET_ACCURACY
>   	select CLKDEV_LOOKUP
>   	---help---
>   	  The common clock framework is a single definition of struct
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 54a191c..f8e68ca 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -104,10 +104,11 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
>   	if (!c)
>   		return;
>   
> -	seq_printf(s, "%*s%-*s %-11d %-12d %-10lu",
> +	seq_printf(s, "%*s%-*s %-11d %-12d %-10lu %-11lu",
>   		   level * 3 + 1, "",
>   		   30 - level * 3, c->name,
> -		   c->enable_count, c->prepare_count, clk_get_rate(c));
> +		   c->enable_count, c->prepare_count, clk_get_rate(c),
> +		   clk_get_accuracy(c));
>   	seq_printf(s, "\n");
>   }
>   
> @@ -129,8 +130,8 @@ static int clk_summary_show(struct seq_file *s, void *data)
>   {
>   	struct clk *c;
>   
> -	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
> -	seq_printf(s, "---------------------------------------------------------------------\n");
> +	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate        accuracy\n");
> +	seq_printf(s, "---------------------------------------------------------------------------------\n");
>   
>   	clk_prepare_lock();
>   
> @@ -167,6 +168,7 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
>   	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
>   	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
>   	seq_printf(s, "\"rate\": %lu", clk_get_rate(c));
> +	seq_printf(s, "\"accuracy\": %lu", clk_get_accuracy(c));
>   }
>   
>   static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
> @@ -248,6 +250,11 @@ static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
>   	if (!d)
>   		goto err_out;
>   
> +	d = debugfs_create_u32("clk_accuracy", S_IRUGO, clk->dentry,
> +			(u32 *)&clk->accuracy);
> +	if (!d)
> +		goto err_out;
> +
>   	d = debugfs_create_x32("clk_flags", S_IRUGO, clk->dentry,
>   			(u32 *)&clk->flags);
>   	if (!d)
> @@ -590,6 +597,11 @@ out:
>   	return ret;
>   }
>   
> +unsigned long __clk_get_accuracy(struct clk *clk)
> +{
> +	return !clk ? 0 : clk->accuracy;
> +}
> +
>   unsigned long __clk_get_flags(struct clk *clk)
>   {
>   	return !clk ? 0 : clk->flags;
> @@ -950,6 +962,58 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
>   }
>   
>   /**
> + * __clk_recalc_accuracies
> + * @clk: first clk in the subtree
> + * @msg: notification type (see include/linux/clk.h)
> + *
> + * Walks the subtree of clks starting with clk and recalculates accuracies as
> + * it goes.  Note that if a clk does not implement the .recalc_rate callback
> + * then it is assumed that the clock will take on the rate of it's parent.
> + *
> + * Caller must hold prepare_lock.
> + */
> +static void __clk_recalc_accuracies(struct clk *clk)
> +{
> +	unsigned long parent_accuracy = 0;
> +	struct clk *child;
> +
> +	if (clk->parent)
> +		parent_accuracy = clk->parent->accuracy;
> +
> +	if (clk->ops->recalc_accuracy)
> +		clk->accuracy = clk->ops->recalc_accuracy(clk->hw, parent_accuracy);
> +	else
> +		clk->accuracy = parent_accuracy;
> +
> +	hlist_for_each_entry(child, &clk->children, child_node)
> +		__clk_recalc_accuracies(child);
> +}
> +
> +/**
> + * clk_get_accuracy - return the accuracy of clk
> + * @clk: the clk whose accuracy is being returned
> + *
> + * Simply returns the cached accuracy of the clk, unless
> + * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
> + * issued.
> + * If clk is NULL then returns 0.
> + */
> +unsigned long clk_get_accuracy(struct clk *clk)
> +{
> +	unsigned long accuracy;
> +	clk_prepare_lock();
> +
> +	if (clk && (clk->flags & CLK_GET_ACCURACY_NOCACHE))
> +		__clk_recalc_accuracies(clk);
> +
> +	accuracy = __clk_get_accuracy(clk);
> +	clk_prepare_unlock();
> +
> +	return accuracy;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_accuracy);
> +
> +/**
>    * __clk_recalc_rates
>    * @clk: first clk in the subtree
>    * @msg: notification type (see include/linux/clk.h)
> @@ -1343,6 +1407,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>   {
>   	clk_reparent(clk, new_parent);
>   	clk_debug_reparent(clk, new_parent);
> +	__clk_recalc_accuracies(clk);
>   	__clk_recalc_rates(clk, POST_RATE_CHANGE);
>   }
>   
> @@ -1502,6 +1567,9 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>   	/* do the re-parent */
>   	ret = __clk_set_parent(clk, parent, p_index);
>   
> +	/* propagate accuracy recalculation */
> +	__clk_recalc_accuracies(clk);
> +
>   	/* propagate rate recalculation accordingly */
>   	if (ret)
>   		__clk_recalc_rates(clk, ABORT_RATE_CHANGE);
> @@ -1610,6 +1678,21 @@ int __clk_init(struct device *dev, struct clk *clk)
>   		hlist_add_head(&clk->child_node, &clk_orphan_list);
>   
>   	/*
> +	 * Set clk's accuracy.  The preferred method is to use
> +	 * .recalc_accuracy. For simple clocks and lazy developers the default
> +	 * fallback is to use the parent's accuracy.  If a clock doesn't have a
> +	 * parent (or is orphaned) then accuracy is set to zero (perfect
> +	 * clock).
> +	 */
> +	if (clk->ops->recalc_accuracy)
> +		clk->accuracy = clk->ops->recalc_accuracy(clk->hw,
> +					__clk_get_accuracy(clk->parent));
> +	else if (clk->parent)
> +		clk->accuracy = clk->parent->accuracy;
> +	else
> +		clk->accuracy = 0;
> +
> +	/*
>   	 * Set clk's rate.  The preferred method is to use .recalc_rate.  For
>   	 * simple clocks and lazy developers the default fallback is to use the
>   	 * parent's rate.  If a clock doesn't have a parent (or is orphaned)
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index dd7adff..dbbd0cf 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -38,6 +38,7 @@ struct clk {
>   	unsigned long		flags;
>   	unsigned int		enable_count;
>   	unsigned int		prepare_count;
> +	unsigned long		accuracy;
>   	struct hlist_head	children;
>   	struct hlist_node	child_node;
>   	unsigned int		notifier_count;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 1ec14a7..2127fbc 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -27,6 +27,7 @@
>   #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
>   #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
>   #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
> +#define CLK_GET_ACCURACY_NOCACHE	BIT(7) /* do not use the cached clk accuracy */
>   
>   struct clk_hw;
>   
> @@ -102,6 +103,13 @@ struct clk_hw;
>    *		which is likely helpful for most .set_rate implementation.
>    *		Returns 0 on success, -EERROR otherwise.
>    *
> + * @recalc_accuracy: Recalculate the accuracy of this clock. The clock accuracy
> + * 		is expressed in ppb (parts per billion). The parent accuracy is
> + * 		an input parameter.
> + * 		Returns the calculated accuracy.  Optional - if	this op is not
> + * 		set then clock accuracy will be initialized to parent accuracy
> + * 		or 0 (perfect clock) if clock has no parent.
> + *
>    * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
>    * implementations to split any work between atomic (enable) and sleepable
>    * (prepare) contexts.  If enabling a clock requires code that might sleep,
> @@ -130,6 +138,8 @@ struct clk_ops {
>   	u8		(*get_parent)(struct clk_hw *hw);
>   	int		(*set_rate)(struct clk_hw *hw, unsigned long,
>   				    unsigned long);
> +	unsigned long	(*recalc_accuracy)(struct clk_hw *hw,
> +					   unsigned long parent_accuracy);
>   	void		(*init)(struct clk_hw *hw);
>   };
>   
> @@ -185,6 +195,7 @@ struct clk_hw {
>   struct clk_fixed_rate {
>   	struct		clk_hw hw;
>   	unsigned long	fixed_rate;
> +	unsigned long	fixed_accuracy;
>   	u8		flags;
>   };
>   
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 9a6d045..44fd65a 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -85,6 +85,23 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
>   #endif
>   
>   /**
> + * clk_get_accuracy - obtain the clock accuracy in ppb (parts per billion)
> + * 		      for a clock source.
> + * @clk: clock source
> + *
> + * This gets the clock source accuracy expressed in ppb.
> + * A perfect clock returns 0.
> + */
> +#ifdef CONFIG_HAVE_CLK_GET_ACCURACY
> +unsigned long clk_get_accuracy(struct clk *clk);
> +#else
> +static inline unsigned long clk_get_accuracy(struct clk *clk)
> +{
> +	return 0;
> +}
> +#endif
> +
> +/**
>    * clk_prepare - prepare a clock source
>    * @clk: clock source
>    *

