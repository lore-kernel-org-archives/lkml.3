Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3HPWLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:11:01 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:65233 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3HPWK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:10:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1375804317-10576-3-git-send-email-s.nawrocki@samsung.com>
Cc: linux@arm.linux.org.uk, jiada_wang@mentor.com, broonie@kernel.org,
        vapier@gentoo.org, ralf@linux-mips.org, lethal@linux-sh.org,
        kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1375804317-10576-1-git-send-email-s.nawrocki@samsung.com>
 <1375804317-10576-3-git-send-email-s.nawrocki@samsung.com>
Message-ID: <20130816214841.4443.10515@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC 2/2] clk: implement clk_unregister
Date: Fri, 16 Aug 2013 14:48:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sylwester Nawrocki (2013-08-06 08:51:57)
> +/*
> + * Empty clk_ops for unregistered clocks. These are used temporarily
> + * after clk_unregister() was called on a clock and until last clock
> + * consumer calls clk_put() and the struct clk object is freed.
> + */
> +static int clk_dummy_prepare_enable(struct clk_hw *hw)
> +{
> +       return -ENXIO;
> +}
> +
> +static void clk_dummy_disable_unprepare(struct clk_hw *hw)
> +{
> +       WARN_ON(1);
> +}
> +
> +static int clk_dummy_set_rate(struct clk_hw *hw, unsigned long rate,
> +                                       unsigned long parent_rate)
> +{
> +       return -ENXIO;
> +}
> +
> +static int clk_dummy_set_parent(struct clk_hw *hw, u8 index)
> +{
> +       return -ENXIO;
> +}
> +
> +static const struct clk_ops clk_dummy_ops = {
> +       .enable         = clk_dummy_prepare_enable,
> +       .disable        = clk_dummy_disable_unprepare,
> +       .prepare        = clk_dummy_prepare_enable,
> +       .unprepare      = clk_dummy_disable_unprepare,
> +       .set_rate       = clk_dummy_set_rate,
> +       .set_parent     = clk_dummy_set_parent,
> +};

Don't use "clk_dummy_*" here. The use of dummy often implies that
operations will return success in the absence of actual hardware but
these return an error, and rightly so. So maybe rename the functions and
clk_ops instance to something like "clk_nodev_*" or "clk_missing_*"?

> +
>  /**
>   * clk_unregister - unregister a currently registered clock
>   * @clk: clock to unregister
> - *
> - * Currently unimplemented.
>   */
> -void clk_unregister(struct clk *clk) {}
> +void clk_unregister(struct clk *clk)
> +{
> +       unsigned long flags;
> +
> +       clk_prepare_lock();
> +
> +       if (!clk || IS_ERR(clk)) {
> +               pr_err("%s: invalid clock: %p\n", __func__, clk);
> +               goto out;
> +       }
> +
> +       if (clk->ops == &clk_dummy_ops) {
> +               pr_err("%s: unregistered clock: %s\n", __func__, clk->name);
> +               goto out;
> +       }
> +       /*
> +        * Assign dummy clock ops for consumers that might still hold
> +        * a reference to this clock.
> +        */
> +       flags = clk_enable_lock();
> +       clk->ops = &clk_dummy_ops;
> +       clk_enable_unlock(flags);
> +
> +       if (!hlist_empty(&clk->children)) {
> +               struct clk *child;
> +
> +               /* Reparent all children to the orphan list. */
> +               hlist_for_each_entry(child, &clk->children, child_node)
> +                       clk_set_parent(child, NULL);
> +       }

This looks pretty good. A remaining problem is re-loading the clock
provider module will have string name conflicts with the old
unregistered clocks (but not yet released) clocks during calls to
__clk_lookup.

The best solution would be to refactor clk.c to not use string name
lookups but that is probably too big of an issue for the purpose of this
series (but it will happen some day).

A short term solution would be to poison the clock's string name here.
Reallocate the clk->name string with some poison data so that name
conflicts don't occur. What do you think?

Regards,
Mike

> +
> +       clk_debug_unregister(clk);
> +
> +       hlist_del_init(&clk->child_node);
> +
> +       if (clk->prepare_count)
> +               pr_warn("%s: unregistering prepared clock: %s\n",
> +                                       __func__, clk->name);
> +
> +       kref_put(&clk->ref, __clk_release);
> +out:
> +       clk_prepare_unlock();
> +}
>  EXPORT_SYMBOL_GPL(clk_unregister);
> 
>  static void devm_clk_release(struct device *dev, void *res)
> @@ -1861,6 +1973,7 @@ int __clk_get(struct clk *clk)
>         if (!try_module_get(clk->owner))
>                 return 0;
> 
> +       kref_get(&clk->ref);
>         return 1;
>  }
>  EXPORT_SYMBOL(__clk_get);
> @@ -1870,6 +1983,10 @@ void __clk_put(struct clk *clk)
>         if (!clk || IS_ERR(clk))
>                 return;
> 
> +       clk_prepare_lock();
> +       kref_put(&clk->ref, __clk_release);
> +       clk_prepare_unlock();
> +
>         module_put(clk->owner);
>  }
>  EXPORT_SYMBOL(__clk_put);
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index b7c0b58..36c1fc8 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -12,6 +12,7 @@
>  #define __LINUX_CLK_PRIVATE_H
> 
>  #include <linux/clk-provider.h>
> +#include <linux/kref.h>
>  #include <linux/list.h>
> 
>  /*
> @@ -47,6 +48,7 @@ struct clk {
>  #ifdef CONFIG_COMMON_CLK_DEBUG
>         struct dentry           *dentry;
>  #endif
> +       struct kref             ref;
>  };
> 
>  /*
> --
> 1.7.9.5
