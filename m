Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3KHAvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:51:55 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48076 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3KHAvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:51:51 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1381684631-10835-2-git-send-email-b.brezillon@overkiz.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
References: <1381684631-10835-1-git-send-email-b.brezillon@overkiz.com>
 <1381684631-10835-2-git-send-email-b.brezillon@overkiz.com>
Message-ID: <20131108005147.19193.42349@quantum>
User-Agent: alot/0.3.4
Subject: Re: [RFC PATCH RESEND 1/2] clk: add clk accuracy retrieval support
Date: Thu, 07 Nov 2013 16:51:47 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2013-10-13 10:17:10)
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
>  Documentation/clk.txt        |    4 ++
>  drivers/clk/Kconfig          |    4 ++
>  drivers/clk/clk.c            |   92 ++++++++++++++++++++++++++++++++++++++++--
>  include/linux/clk-private.h  |    1 +
>  include/linux/clk-provider.h |   11 +++++
>  include/linux/clk.h          |   17 ++++++++
>  6 files changed, 125 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/clk.txt b/Documentation/clk.txt
> index 3aeb5c4..dc52da1 100644
> --- a/Documentation/clk.txt
> +++ b/Documentation/clk.txt
> @@ -77,6 +77,8 @@ the operations defined in clk.h:
>                 int             (*set_parent)(struct clk_hw *hw, u8 index);
>                 u8              (*get_parent)(struct clk_hw *hw);
>                 int             (*set_rate)(struct clk_hw *hw, unsigned long);
> +               unsigned long   (*recalc_accuracy)(struct clk_hw *hw,
> +                                                  unsigned long parent_accuracy);
>                 void            (*init)(struct clk_hw *hw);
>         };
>  
> @@ -202,6 +204,8 @@ optional or must be evaluated on a case-by-case basis.
>  .set_parent     |      |             | n             | y           | n    |
>  .get_parent     |      |             | n             | y           | n    |
>                  |      |             |               |             |      |
> +.recalc_rate    |      |             |               |             |      |

s/recalc_rate/recalc_accuracy/

> +                |      |             |               |             |      |
>  .init           |      |             |               |             |      |
>                  -----------------------------------------------------------
>  [1] either one of round_rate or determine_rate is required.
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 279407a..4d12ae7 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -6,12 +6,16 @@ config CLKDEV_LOOKUP
>  config HAVE_CLK_PREPARE
>         bool
>  
> +config HAVE_CLK_GET_ACCURACY
> +       bool
> +

This sort of thing gets messy. For platforms converted to common struct
clk we select HAVE_CLK_PREPARE and we let legacy platforms select it on
a case-by-case basis.

For something like HAVE_CLK_GET_ACCURACY I am inclined to only add it
for platforms converted to the common struct clk and not even expose it
to legacy clock framework implementations. In those cases the call to
clk_get_accuracy would return -EINVAL or -EPERM or something.

Russell, any thoughts on that approach?

>  config HAVE_MACH_CLKDEV
>         bool
>  
>  config COMMON_CLK
>         bool
>         select HAVE_CLK_PREPARE
> +       select HAVE_CLK_GET_ACCURACY
>         select CLKDEV_LOOKUP
>         ---help---
>           The common clock framework is a single definition of struct
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index a004769..6a8f3ef 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -104,10 +104,11 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
>         if (!c)
>                 return;
>  
> -       seq_printf(s, "%*s%-*s %-11d %-12d %-10lu",
> +       seq_printf(s, "%*s%-*s %-11d %-12d %-10lu %-11lu",
>                    level * 3 + 1, "",
>                    30 - level * 3, c->name,
> -                  c->enable_count, c->prepare_count, clk_get_rate(c));
> +                  c->enable_count, c->prepare_count, clk_get_rate(c),
> +                  clk_get_accuracy(c));
>         seq_printf(s, "\n");
>  }
>  
> @@ -129,8 +130,8 @@ static int clk_summary_show(struct seq_file *s, void *data)
>  {
>         struct clk *c;
>  
> -       seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
> -       seq_printf(s, "---------------------------------------------------------------------\n");
> +       seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate        accuracy\n");
> +       seq_printf(s, "---------------------------------------------------------------------------------\n");
>  
>         clk_prepare_lock();
>  
> @@ -167,6 +168,7 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
>         seq_printf(s, "\"enable_count\": %d,", c->enable_count);
>         seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
>         seq_printf(s, "\"rate\": %lu", clk_get_rate(c));
> +       seq_printf(s, "\"accuracy\": %lu", clk_get_accuracy(c));
>  }
>  
>  static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
> @@ -248,6 +250,11 @@ static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
>         if (!d)
>                 goto err_out;
>  
> +       d = debugfs_create_u32("clk_accuracy", S_IRUGO, clk->dentry,
> +                       (u32 *)&clk->accuracy);
> +       if (!d)
> +               goto err_out;
> +
>         d = debugfs_create_x32("clk_flags", S_IRUGO, clk->dentry,
>                         (u32 *)&clk->flags);
>         if (!d)
> @@ -602,6 +609,11 @@ out:
>         return ret;
>  }
>  
> +unsigned long __clk_get_accuracy(struct clk *clk)
> +{
> +       return !clk ? 0 : clk->accuracy;
> +}
> +
>  unsigned long __clk_get_flags(struct clk *clk)
>  {
>         return !clk ? 0 : clk->flags;
> @@ -1016,6 +1028,59 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
>  }
>  
>  /**
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
> +       unsigned long parent_accuracy = 0;
> +       struct clk *child;
> +
> +       if (clk->parent)
> +               parent_accuracy = clk->parent->accuracy;
> +
> +       if (clk->ops->recalc_accuracy)
> +               clk->accuracy = clk->ops->recalc_accuracy(clk->hw,
> +                                                         parent_accuracy);
> +       else
> +               clk->accuracy = parent_accuracy;
> +
> +       hlist_for_each_entry(child, &clk->children, child_node)
> +               __clk_recalc_accuracies(child);
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
> +       unsigned long accuracy;
> +       clk_prepare_lock();
> +
> +       if (clk && (clk->flags & CLK_GET_ACCURACY_NOCACHE))
> +               __clk_recalc_accuracies(clk);

I think that there is some overlap between recalculating the accuracy
here and simply getting it. You only provide clk_get_accuracy and it
serves both purposes. It would be better if clk_recalc_accuracy walked
the subtree of children and if clk_get_accuracy simply returned a cached
value.

> +
> +       accuracy = __clk_get_accuracy(clk);
> +       clk_prepare_unlock();
> +
> +       return accuracy;
> +}
> +EXPORT_SYMBOL_GPL(clk_get_accuracy);
> +
> +/**
>   * __clk_recalc_rates
>   * @clk: first clk in the subtree
>   * @msg: notification type (see include/linux/clk.h)
> @@ -1545,6 +1610,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  {
>         clk_reparent(clk, new_parent);
>         clk_debug_reparent(clk, new_parent);
> +       __clk_recalc_accuracies(clk);

Similar to the above statement. Why do this here? We do this for rates
since calls to clk_get_rate will return the cached rate (unless the
NOCACHE flag is set). But since a call to clk_get_accuracy will always
recalculate it then there is no benefit to doing that here.

>         __clk_recalc_rates(clk, POST_RATE_CHANGE);
>  }
>  
> @@ -1615,6 +1681,9 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>         /* do the re-parent */
>         ret = __clk_set_parent(clk, parent, p_index);
>  
> +       /* propagate accuracy recalculation */
> +       __clk_recalc_accuracies(clk);

Ditto.

Regards,
Mike

> +
>         /* propagate rate recalculation accordingly */
>         if (ret)
>                 __clk_recalc_rates(clk, ABORT_RATE_CHANGE);
> @@ -1724,6 +1793,21 @@ int __clk_init(struct device *dev, struct clk *clk)
>                 hlist_add_head(&clk->child_node, &clk_orphan_list);
>  
>         /*
> +        * Set clk's accuracy.  The preferred method is to use
> +        * .recalc_accuracy. For simple clocks and lazy developers the default
> +        * fallback is to use the parent's accuracy.  If a clock doesn't have a
> +        * parent (or is orphaned) then accuracy is set to zero (perfect
> +        * clock).
> +        */
> +       if (clk->ops->recalc_accuracy)
> +               clk->accuracy = clk->ops->recalc_accuracy(clk->hw,
> +                                       __clk_get_accuracy(clk->parent));
> +       else if (clk->parent)
> +               clk->accuracy = clk->parent->accuracy;
> +       else
> +               clk->accuracy = 0;
> +
> +       /*
>          * Set clk's rate.  The preferred method is to use .recalc_rate.  For
>          * simple clocks and lazy developers the default fallback is to use the
>          * parent's rate.  If a clock doesn't have a parent (or is orphaned)
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 8138c94..accb517 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -41,6 +41,7 @@ struct clk {
>         unsigned long           flags;
>         unsigned int            enable_count;
>         unsigned int            prepare_count;
> +       unsigned long           accuracy;
>         struct hlist_head       children;
>         struct hlist_node       child_node;
>         unsigned int            notifier_count;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 73bdb69..942811d 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -29,6 +29,7 @@
>  #define CLK_IS_BASIC           BIT(5) /* Basic clk, can't do a to_clk_foo() */
>  #define CLK_GET_RATE_NOCACHE   BIT(6) /* do not use the cached clk rate */
>  #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
> +#define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
>  
>  struct clk_hw;
>  
> @@ -108,6 +109,13 @@ struct clk_hw;
>   *             which is likely helpful for most .set_rate implementation.
>   *             Returns 0 on success, -EERROR otherwise.
>   *
> + * @recalc_accuracy: Recalculate the accuracy of this clock. The clock accuracy
> + *             is expressed in ppb (parts per billion). The parent accuracy is
> + *             an input parameter.
> + *             Returns the calculated accuracy.  Optional - if this op is not
> + *             set then clock accuracy will be initialized to parent accuracy
> + *             or 0 (perfect clock) if clock has no parent.
> + *
>   * The clk_enable/clk_disable and clk_prepare/clk_unprepare pairs allow
>   * implementations to split any work between atomic (enable) and sleepable
>   * (prepare) contexts.  If enabling a clock requires code that might sleep,
> @@ -139,6 +147,8 @@ struct clk_ops {
>         u8              (*get_parent)(struct clk_hw *hw);
>         int             (*set_rate)(struct clk_hw *hw, unsigned long,
>                                     unsigned long);
> +       unsigned long   (*recalc_accuracy)(struct clk_hw *hw,
> +                                          unsigned long parent_accuracy);
>         void            (*init)(struct clk_hw *hw);
>  };
>  
> @@ -194,6 +204,7 @@ struct clk_hw {
>  struct clk_fixed_rate {
>         struct          clk_hw hw;
>         unsigned long   fixed_rate;
> +       unsigned long   fixed_accuracy;
>         u8              flags;
>  };
>  
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 9a6d045..2fe3b54 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -85,6 +85,23 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
>  #endif
>  
>  /**
> + * clk_get_accuracy - obtain the clock accuracy in ppb (parts per billion)
> + *                   for a clock source.
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
> +       return 0;
> +}
> +#endif
> +
> +/**
>   * clk_prepare - prepare a clock source
>   * @clk: clock source
>   *
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
