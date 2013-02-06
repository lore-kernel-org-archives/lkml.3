Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3BFDEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:04:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19871 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3BFDEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:04:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 05 Feb 2013 19:02:23 -0800
Message-ID: <5111C840.3000003@nvidia.com>
Date: Wed, 6 Feb 2013 08:34:32 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com> <2204463.8bhhYZbxqK@amdc1227>
In-Reply-To: <2204463.8bhhYZbxqK@amdc1227>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 03:45 PM, Tomasz Figa wrote:
> Hi Prashant,
>
> Thank you for your patch. Please see some comments inline.
>
> On Monday 04 of February 2013 13:41:22 Prashant Gaikwad wrote:
>> Not all clocks are required to be decomposed into basic clock
>> types but at the same time want to use the functionality
>> provided by these basic clock types instead of duplicating.
>>
>> For example, Tegra SoC has ~100 clocks which can be decomposed
>> into Mux -> Div -> Gate clock types making the clock count to
>> ~300. Also, parent change operation can not be performed on gate
>> clock which forces to use mux clock in driver if want to change
>> the parent.
>>
>> Instead aggregate the basic clock types functionality into one
>> clock and just use this clock for all operations. This clock
>> type re-uses the functionality of basic clock types and not
>> limited to basic clock types but any hardware-specific
>> implementation.
>>
>> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
>> ---
>>
>> Changes from V1:
>> - 2nd patch dropped as the concept is acked by Mike.
>> - Fixed comments from Stephen.
>>
>> ---
>>   drivers/clk/Makefile         |    1 +
>>   drivers/clk/clk-composite.c  |  208
>> ++++++++++++++++++++++++++++++++++++++++++ include/linux/clk-provider.h
>> |   30 ++++++
>>   3 files changed, 239 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/clk/clk-composite.c
>>
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index ce77077..2287848 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -7,6 +7,7 @@ obj-$(CONFIG_COMMON_CLK)      += clk-fixed-factor.o
>>   obj-$(CONFIG_COMMON_CLK)     += clk-fixed-rate.o
>>   obj-$(CONFIG_COMMON_CLK)     += clk-gate.o
>>   obj-$(CONFIG_COMMON_CLK)     += clk-mux.o
>> +obj-$(CONFIG_COMMON_CLK)     += clk-composite.o
>>
>>   # SoCs specific
>>   obj-$(CONFIG_ARCH_BCM2835)   += clk-bcm2835.o
>> diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
>> new file mode 100644
>> index 0000000..5a6587f
>> --- /dev/null
>> +++ b/drivers/clk/clk-composite.c
>> @@ -0,0 +1,208 @@
>> +/*
>> + * Copyright (c) 2013 NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> it + * under the terms and conditions of the GNU General Public
>> License, + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but
>> WITHOUT + * ANY WARRANTY; without even the implied warranty of
>> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> General Public License for + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see
>> <http://www.gnu.org/licenses/>. + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/err.h>
>> +#include <linux/slab.h>
>> +
>> +#define to_clk_composite(_hw) container_of(_hw, struct clk_composite,
>> hw) +
>> +static u8 clk_composite_get_parent(struct clk_hw *hw)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *mux_ops = composite->mux_ops;
>> +     struct clk_hw *mux_hw = composite->mux_hw;
>> +
>> +     mux_hw->clk = hw->clk;
> Why is this needed? Looks like this filed is already being initialized in
> clk_register_composite.

Some ops will get called during clk_init where this clk is not populated 
hence doing here. I have done it for all ops to make sure that any 
future change in clock framework don't break this clock.
Now, why duplicate it in clk_register_composite? It is possible that 
none of these ops get called in clk_init.
For example, recalc_rate is called during init and this ops is supported 
by div clock type, but what if div clock is not added.

I hope this explains the need.

>> +
>> +     return mux_ops->get_parent(mux_hw);
>> +}
>> +
>> +static int clk_composite_set_parent(struct clk_hw *hw, u8 index)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *mux_ops = composite->mux_ops;
>> +     struct clk_hw *mux_hw = composite->mux_hw;
>> +
>> +     mux_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     return mux_ops->set_parent(mux_hw, index);
>> +}
>> +
>> +static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
>> +                                         unsigned long parent_rate)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *div_ops = composite->div_ops;
>> +     struct clk_hw *div_hw = composite->div_hw;
>> +
>> +     div_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     return div_ops->recalc_rate(div_hw, parent_rate);
>> +}
>> +
>> +static long clk_composite_round_rate(struct clk_hw *hw, unsigned long
>> rate, +                                 unsigned long *prate)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *div_ops = composite->div_ops;
>> +     struct clk_hw *div_hw = composite->div_hw;
>> +
>> +     div_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     return div_ops->round_rate(div_hw, rate, prate);
>> +}
>> +
>> +static int clk_composite_set_rate(struct clk_hw *hw, unsigned long
>> rate, +                              unsigned long parent_rate)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *div_ops = composite->div_ops;
>> +     struct clk_hw *div_hw = composite->div_hw;
>> +
>> +     div_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     return div_ops->set_rate(div_hw, rate, parent_rate);
>> +}
>> +
>> +static int clk_composite_is_enabled(struct clk_hw *hw)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *gate_ops = composite->gate_ops;
>> +     struct clk_hw *gate_hw = composite->gate_hw;
>> +
>> +     gate_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     return gate_ops->is_enabled(gate_hw);
>> +}
>> +
>> +static int clk_composite_enable(struct clk_hw *hw)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *gate_ops = composite->gate_ops;
>> +     struct clk_hw *gate_hw = composite->gate_hw;
>> +
>> +     gate_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     return gate_ops->enable(gate_hw);
>> +}
>> +
>> +static void clk_composite_disable(struct clk_hw *hw)
>> +{
>> +     struct clk_composite *composite = to_clk_composite(hw);
>> +     const struct clk_ops *gate_ops = composite->gate_ops;
>> +     struct clk_hw *gate_hw = composite->gate_hw;
>> +
>> +     gate_hw->clk = hw->clk;
> Ditto.
>
>> +
>> +     gate_ops->disable(gate_hw);
>> +}
>> +
>> +struct clk *clk_register_composite(struct device *dev, const char
>> *name, +                      const char **parent_names, int num_parents,
>> +                     struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
>> +                     struct clk_hw *div_hw, const struct clk_ops *div_ops,
>> +                     struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
>> +                     unsigned long flags)
>> +{
>> +     struct clk *clk;
>> +     struct clk_init_data init;
>> +     struct clk_composite *composite;
>> +     struct clk_ops *clk_composite_ops;
>> +
>> +     composite = kzalloc(sizeof(*composite), GFP_KERNEL);
>> +     if (!composite) {
>> +             pr_err("%s: could not allocate composite clk\n", __func__);
>> +             return ERR_PTR(-ENOMEM);
>> +     }
>> +
>> +     init.name = name;
>> +     init.flags = flags | CLK_IS_BASIC;
>> +     init.parent_names = parent_names;
>> +     init.num_parents = num_parents;
>> +
>> +     /* allocate the clock ops */
>> +     clk_composite_ops = kzalloc(sizeof(*clk_composite_ops), GFP_KERNEL);
>> +     if (!clk_composite_ops) {
>> +             pr_err("%s: could not allocate clk ops\n", __func__);
>> +             kfree(composite);
>> +             return ERR_PTR(-ENOMEM);
>> +     }
> Maybe it would be better to embed this struct clk_ops inside struct
> clk_composite? This would allow to get rid of this allocation.
>
>> +
>> +     if (mux_hw && mux_ops) {
>> +             if (!mux_ops->get_parent || !mux_ops->set_parent) {
>> +                     clk = ERR_PTR(-EINVAL);
>> +                     goto err;
>> +             }
>> +
>> +             composite->mux_hw = mux_hw;
>> +             composite->mux_ops = mux_ops;
>> +             clk_composite_ops->get_parent = clk_composite_get_parent;
>> +             clk_composite_ops->set_parent = clk_composite_set_parent;
>> +     }
>> +
>> +     if (div_hw && div_ops) {
>> +             if (!div_ops->recalc_rate || !div_ops->round_rate ||
>> +                 !div_ops->set_rate) {
>> +                     clk = ERR_PTR(-EINVAL);
>> +                     goto err;
>> +             }
>> +
>> +             composite->div_hw = div_hw;
>> +             composite->div_ops = div_ops;
>> +             clk_composite_ops->recalc_rate = clk_composite_recalc_rate;
>> +             clk_composite_ops->round_rate = clk_composite_round_rate;
>> +             clk_composite_ops->set_rate = clk_composite_set_rate;
>> +     }
>> +
>> +     if (gate_hw && gate_ops) {
>> +             if (!gate_ops->is_enabled || !gate_ops->enable ||
>> +                 !gate_ops->disable) {
>> +                     clk = ERR_PTR(-EINVAL);
>> +                     goto err;
>> +             }
>> +
>> +             composite->gate_hw = gate_hw;
>> +             composite->gate_ops = gate_ops;
>> +             clk_composite_ops->is_enabled = clk_composite_is_enabled;
>> +             clk_composite_ops->enable = clk_composite_enable;
>> +             clk_composite_ops->disable = clk_composite_disable;
>> +     }
>> +
>> +     init.ops = clk_composite_ops;
>> +     composite->hw.init = &init;
>> +
>> +     clk = clk_register(dev, &composite->hw);
>> +     if (IS_ERR(clk))
>> +             goto err;
>> +
>> +     if (composite->mux_hw)
>> +             composite->mux_hw->clk = clk;
>> +
>> +     if (composite->div_hw)
>> +             composite->div_hw->clk = clk;
>> +
>> +     if (composite->gate_hw)
>> +             composite->gate_hw->clk = clk;
>> +
>> +     return clk;
>> +
>> +err:
>> +     kfree(clk_composite_ops);
>> +     kfree(composite);
>> +     return clk;
>> +}
>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>> index 7f197d7..f1a36aa 100644
>> --- a/include/linux/clk-provider.h
>> +++ b/include/linux/clk-provider.h
>> @@ -325,6 +325,36 @@ struct clk *clk_register_fixed_factor(struct device
>> *dev, const char *name, const char *parent_name, unsigned long flags,
>>                unsigned int mult, unsigned int div);
>>
>> +/***
>> + * struct clk_composite - aggregate clock of mux, divider and gate
>> clocks + *
>> + * @hw:              handle between common and hardware-specific interfaces
>> + * @mux_hw:  handle between composite and hardware-specifix mux clock
>> + * @div_hw:  handle between composite and hardware-specifix divider
>> clock + * @gate_hw:   handle between composite and hardware-specifix gate
>> clock + * @mux_ops:   clock ops for mux
>> + * @div_ops: clock ops for divider
>> + * @gate_ops:        clock ops for gate
>> + */
>> +struct clk_composite {
>> +     struct clk_hw   hw;
> As I suggested above:
>
>          struct clk_ops  ops;
>
>> +
>> +     struct clk_hw   *mux_hw;
>> +     struct clk_hw   *div_hw;
>> +     struct clk_hw   *gate_hw;
>> +
>> +     const struct clk_ops    *mux_ops;
>> +     const struct clk_ops    *div_ops;
>> +     const struct clk_ops    *gate_ops;
>> +};
>> +
>> +struct clk *clk_register_composite(struct device *dev, const char
>> *name, +              const char **parent_names, int num_parents,
>> +             struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
>> +             struct clk_hw *div_hw, const struct clk_ops *div_ops,
>> +             struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
>> +             unsigned long flags);
>> +
>>   /**
>>    * clk_register - allocate a new clock, register it and return an
>> opaque cookie * @dev: device that is registering this clock
> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
> SW Solution Development, Linux Platform
>

