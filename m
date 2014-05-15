Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaEOQx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:53:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62618 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaEOQx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:53:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1400161226-24067-4-git-send-email-heikki.krogerus@linux.intel.com>
Cc: "Mika Westerberg" <mika.westerberg@linux.intel.com>,
        "Jin Yao" <yao.jin@linux.intel.com>,
        "Li Aubrey" <aubrey.li@linux.intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1400161226-24067-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1400161226-24067-4-git-send-email-heikki.krogerus@linux.intel.com>
Message-ID: <20140515165349.9521.75672@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCHv2 3/4] clk: new basic clk type for fractional divider
Date: Thu, 15 May 2014 09:53:49 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Heikki Krogerus (2014-05-15 06:40:25)
> Fractional divider clocks are fairly common. This adds basic
> type for them.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Taken into clk-next.

Just FYI, there was some talk at Embedded Linux Conference on providing
a better abstraction layer for some of these "basic" clock types. This
abstraction would allow the basic clock types to implement the
machine-agnostic logic (e.g. an incoming rate is divided by a value) and
then platforms and drivers could plug in the machine-specific parts
(e.g. divider is made up of m/n, or divider is power-of-two, or divider
is a simple integer with min == 1 and max == 5).

All of that is to say that in time this fractional divider could go away
once the abstraction layer allows us to fold the m/n divider stuff into
a core divider implementation.

Nothing wrong with the patch for now, so I've taken it for 3.16.

Regards,
Mike

> ---
>  drivers/clk/Makefile                 |   1 +
>  drivers/clk/clk-fractional-divider.c | 135 +++++++++++++++++++++++++++++++++++
>  include/linux/clk-provider.h         |  31 ++++++++
>  3 files changed, 167 insertions(+)
>  create mode 100644 drivers/clk/clk-fractional-divider.c
> 
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index f651b2a..33bc79e 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)        += clk-fixed-rate.o
>  obj-$(CONFIG_COMMON_CLK)       += clk-gate.o
>  obj-$(CONFIG_COMMON_CLK)       += clk-mux.o
>  obj-$(CONFIG_COMMON_CLK)       += clk-composite.o
> +obj-$(CONFIG_COMMON_CLK)       += clk-fractional-divider.o
>  
>  # hardware specific clock types
>  # please keep this section sorted lexicographically by file/directory path name
> diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
> new file mode 100644
> index 0000000..ede685c
> --- /dev/null
> +++ b/drivers/clk/clk-fractional-divider.c
> @@ -0,0 +1,135 @@
> +/*
> + * Copyright (C) 2014 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Adjustable fractional divider clock implementation.
> + * Output rate = (m / n) * parent_rate.
> + */
> +
> +#include <linux/clk-provider.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/gcd.h>
> +
> +#define to_clk_fd(_hw) container_of(_hw, struct clk_fractional_divider, hw)
> +
> +static unsigned long clk_fd_recalc_rate(struct clk_hw *hw,
> +                                       unsigned long parent_rate)
> +{
> +       struct clk_fractional_divider *fd = to_clk_fd(hw);
> +       unsigned long flags = 0;
> +       u32 val, m, n;
> +       u64 ret;
> +
> +       if (fd->lock)
> +               spin_lock_irqsave(fd->lock, flags);
> +
> +       val = clk_readl(fd->reg);
> +
> +       if (fd->lock)
> +               spin_unlock_irqrestore(fd->lock, flags);
> +
> +       m = (val & fd->mmask) >> fd->mshift;
> +       n = (val & fd->nmask) >> fd->nshift;
> +
> +       ret = parent_rate * m;
> +       do_div(ret, n);
> +
> +       return ret;
> +}
> +
> +static long clk_fd_round_rate(struct clk_hw *hw, unsigned long rate,
> +                             unsigned long *prate)
> +{
> +       struct clk_fractional_divider *fd = to_clk_fd(hw);
> +       unsigned maxn = (fd->nmask >> fd->nshift) + 1;
> +       unsigned div;
> +
> +       if (!rate || rate >= *prate)
> +               return *prate;
> +
> +       div = gcd(*prate, rate);
> +
> +       while ((*prate / div) > maxn) {
> +               div <<= 1;
> +               rate <<= 1;
> +       }
> +
> +       return rate;
> +}
> +
> +static int clk_fd_set_rate(struct clk_hw *hw, unsigned long rate,
> +                          unsigned long parent_rate)
> +{
> +       struct clk_fractional_divider *fd = to_clk_fd(hw);
> +       unsigned long flags = 0;
> +       unsigned long div;
> +       unsigned n, m;
> +       u32 val;
> +
> +       div = gcd(parent_rate, rate);
> +       m = rate / div;
> +       n = parent_rate / div;
> +
> +       if (fd->lock)
> +               spin_lock_irqsave(fd->lock, flags);
> +
> +       val = clk_readl(fd->reg);
> +       val &= ~(fd->mmask | fd->nmask);
> +       val |= (m << fd->mshift) | (n << fd->nshift);
> +       clk_writel(val, fd->reg);
> +
> +       if (fd->lock)
> +               spin_unlock_irqrestore(fd->lock, flags);
> +
> +       return 0;
> +}
> +
> +const struct clk_ops clk_fractional_divider_ops = {
> +       .recalc_rate = clk_fd_recalc_rate,
> +       .round_rate = clk_fd_round_rate,
> +       .set_rate = clk_fd_set_rate,
> +};
> +EXPORT_SYMBOL_GPL(clk_fractional_divider_ops);
> +
> +struct clk *clk_register_fractional_divider(struct device *dev,
> +               const char *name, const char *parent_name, unsigned long flags,
> +               void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
> +               u8 clk_divider_flags, spinlock_t *lock)
> +{
> +       struct clk_fractional_divider *fd;
> +       struct clk_init_data init;
> +       struct clk *clk;
> +
> +       fd = kzalloc(sizeof(*fd), GFP_KERNEL);
> +       if (!fd) {
> +               dev_err(dev, "could not allocate fractional divider clk\n");
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       init.name = name;
> +       init.ops = &clk_fractional_divider_ops;
> +       init.flags = flags | CLK_IS_BASIC;
> +       init.parent_names = parent_name ? &parent_name : NULL;
> +       init.num_parents = parent_name ? 1 : 0;
> +
> +       fd->reg = reg;
> +       fd->mshift = mshift;
> +       fd->mmask = (BIT(mwidth) - 1) << mshift;
> +       fd->nshift = nshift;
> +       fd->nmask = (BIT(nwidth) - 1) << nshift;
> +       fd->flags = clk_divider_flags;
> +       fd->lock = lock;
> +       fd->hw.init = &init;
> +
> +       clk = clk_register(dev, &fd->hw);
> +       if (IS_ERR(clk))
> +               kfree(fd);
> +
> +       return clk;
> +}
> +EXPORT_SYMBOL_GPL(clk_register_fractional_divider);
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 4080943..d76188a 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -422,6 +422,37 @@ struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
>                 const char *parent_name, unsigned long flags,
>                 unsigned int mult, unsigned int div);
>  
> +/**
> + * struct clk_fractional_divider - adjustable fractional divider clock
> + *
> + * @hw:                handle between common and hardware-specific interfaces
> + * @reg:       register containing the divider
> + * @mshift:    shift to the numerator bit field
> + * @mwidth:    width of the numerator bit field
> + * @nshift:    shift to the denominator bit field
> + * @nwidth:    width of the denominator bit field
> + * @lock:      register lock
> + *
> + * Clock with adjustable fractional divider affecting its output frequency.
> + */
> +
> +struct clk_fractional_divider {
> +       struct clk_hw   hw;
> +       void __iomem    *reg;
> +       u8              mshift;
> +       u32             mmask;
> +       u8              nshift;
> +       u32             nmask;
> +       u8              flags;
> +       spinlock_t      *lock;
> +};
> +
> +extern const struct clk_ops clk_fractional_divider_ops;
> +struct clk *clk_register_fractional_divider(struct device *dev,
> +               const char *name, const char *parent_name, unsigned long flags,
> +               void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
> +               u8 clk_divider_flags, spinlock_t *lock);
> +
>  /***
>   * struct clk_composite - aggregate clock of mux, divider and gate clocks
>   *
> -- 
> 2.0.0.rc2
> 
