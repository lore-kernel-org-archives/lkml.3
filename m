Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3BFCzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:55:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3933 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFCzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:55:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Feb 2013 18:52:05 -0800
Message-ID: <5111C604.8070104@nvidia.com>
Date: Wed, 6 Feb 2013 08:25:00 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com><20130204.113739.2227266298512077917.hdoyu@nvidia.com><5110C3E5.2010503@nvidia.com> <20130205.122252.570646990867457667.hdoyu@nvidia.com>
In-Reply-To: <20130205.122252.570646990867457667.hdoyu@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 03:52 PM, Hiroshi Doyu wrote:
> Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Tue, 5 Feb 2013 09:33:41 +0100:
>
>>> The members of "clk_composite_ops" seems to be always assigned
>>> statically. Istead of dynamically allocating/assigning, can't we just
>>> have "clk_composite_ops" statically as below?
>>>
>>> static struct clk_ops clk_composite_ops = {
>>> 	.get_parent = clk_composite_get_parent;
>>> 	.set_parent = clk_composite_set_parent;
>>> 	.recalc_rate = clk_composite_recalc_rate;
>>> 	.round_rate = clk_composite_round_rate;
>>> 	.set_rate = clk_composite_set_rate;
>>> 	.is_enabled = clk_composite_is_enabled;
>>> 	.enable = clk_composite_enable;
>>> 	.disable = clk_composite_disable;
>>> };
>>>
>>> struct clk *clk_register_composite(struct device *dev, const char *name,
>>> 		       const char **parent_names, int num_parents,
>>> 		       struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
>>> 		       struct clk_hw *div_hw, const struct clk_ops *div_ops,
>>> 		       struct clk_hw *gate_hw, const struct clk_ops *gate_ops,
>>> 		       unsigned long flags)
>>> {
>>> 	.....
>>>
>>> 	init.ops = &clk_composite_ops;
>> No, clk_ops depends on the clocks you are using. There could be a clock
>> with mux and gate while another one with mux and div.
> You are right. What about the following? We don't have to have similar
> copy of clk_composite_ops for each instances.

Clock framework takes decision depending on the ops availability and it 
does not know if the clock is mux or gate.

For example,

                 if (clk->ops->enable) {
                         ret = clk->ops->enable(clk->hw);
                         if (ret) {
                                 __clk_disable(clk->parent);
                                 return ret;
                         }
                 }

in above case if clk_composite does not have gate clock then as per your 
suggestion if it returns error value then it will fail and it is wrong.

Hence clock ops are populated depending on the clock types.

> diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
> index f30fb4b..8f88805 100644
> --- a/drivers/clk/clk-composite.c
> +++ b/drivers/clk/clk-composite.c
> @@ -27,6 +27,9 @@ static u8 clk_composite_get_parent(struct clk_hw *hw)
>          const struct clk_ops *mux_ops = composite->mux_ops;
>          struct clk_hw *mux_hw = composite->mux_hw;
>   
> +       if (!mux_hw->clk)
> +	       return -EINVAL;
> +
>          mux_hw->clk = hw->clk;
>   

It is wrong.

>          return mux_ops->get_parent(mux_hw);
> @@ -38,6 +41,9 @@ static int clk_composite_set_parent(struct clk_hw *hw, u8 index)
>          const struct clk_ops *mux_ops = composite->mux_ops;
>          struct clk_hw *mux_hw = composite->mux_hw;
>   
> +       if (!mux_hw->clk)
> +	       return -EINVAL;
> +
>          mux_hw->clk = hw->clk;
>   
>          return mux_ops->set_parent(mux_hw, index);
> @@ -50,6 +56,9 @@ static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
>          const struct clk_ops *div_ops = composite->div_ops;
>          struct clk_hw *div_hw = composite->div_hw;
>   
> +       if (!div_hw->clk)
> +	       return -EINVAL;
> +
>          div_hw->clk = hw->clk;
>   
>          return div_ops->recalc_rate(div_hw, parent_rate);
> @@ -62,6 +71,9 @@ static long clk_composite_round_rate(struct clk_hw *hw, unsigned long rate,
>          const struct clk_ops *div_ops = composite->div_ops;
>          struct clk_hw *div_hw = composite->div_hw;
>   
> +       if (!div_hw->clk)
> +	       return -EINVAL;
> +
>          div_hw->clk = hw->clk;
>   
>          return div_ops->round_rate(div_hw, rate, prate);
> @@ -74,6 +86,9 @@ static int clk_composite_set_rate(struct clk_hw *hw, unsigned long rate,
>          const struct clk_ops *div_ops = composite->div_ops;
>          struct clk_hw *div_hw = composite->div_hw;
>   
> +       if (!div_hw->clk)
> +	       return -EINVAL;
> +
>          div_hw->clk = hw->clk;
>   
>          return div_ops->set_rate(div_hw, rate, parent_rate);
> @@ -85,6 +100,9 @@ static int clk_composite_is_enabled(struct clk_hw *hw)
>          const struct clk_ops *gate_ops = composite->gate_ops;
>          struct clk_hw *gate_hw = composite->gate_hw;
>   
> +       if (!gate_hw->clk)
> +	       return -EINVAL;
> +
>          gate_hw->clk = hw->clk;
>   
>          return gate_ops->is_enabled(gate_hw);
> @@ -96,6 +114,9 @@ static int clk_composite_enable(struct clk_hw *hw)
>          const struct clk_ops *gate_ops = composite->gate_ops;
>          struct clk_hw *gate_hw = composite->gate_hw;
>   
> +       if (!gate_hw->clk)
> +	       return -EINVAL;
> +
>          gate_hw->clk = hw->clk;
>   
>          return gate_ops->enable(gate_hw);
> @@ -107,11 +128,25 @@ static void clk_composite_disable(struct clk_hw *hw)
>          const struct clk_ops *gate_ops = composite->gate_ops;
>          struct clk_hw *gate_hw = composite->gate_hw;
>   
> +       if (!gate_hw->clk)
> +	       return -EINVAL;
> +
>          gate_hw->clk = hw->clk;
>   
>          gate_ops->disable(gate_hw);
>   }
>   
> +static struct clk_ops clk_composite_ops = {
> +	.get_parent = clk_composite_get_parent,
> +	.set_parent = clk_composite_set_parent,
> +	.recalc_rate = clk_composite_recalc_rate,
> +	.round_rate = clk_composite_round_rate,
> +	.set_rate = clk_composite_set_rate,
> +	.is_enabled = clk_composite_is_enabled,
> +	.enable = clk_composite_enable,
> +	.disable = clk_composite_disable,
> +};
> +
>   struct clk *clk_register_composite(struct device *dev, const char *name,
>                          const char **parent_names, int num_parents,
>                          struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
> @@ -135,14 +170,6 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
>          init.parent_names = parent_names;
>          init.num_parents = num_parents;
>   
> -       /* allocate the clock ops */
> -       clk_composite_ops = kzalloc(sizeof(*clk_composite_ops), GFP_KERNEL);
> -       if (!clk_composite_ops) {
> -               pr_err("%s: could not allocate clk ops\n", __func__);
> -               kfree(composite);
> -               return ERR_PTR(-ENOMEM);
> -       }
> -
>          if (mux_hw && mux_ops) {
>                  if (!mux_ops->get_parent || !mux_ops->set_parent) {
>                          clk = ERR_PTR(-EINVAL);
> @@ -151,8 +178,6 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
>   
>                  composite->mux_hw = mux_hw;
>                  composite->mux_ops = mux_ops;
> -               clk_composite_ops->get_parent = clk_composite_get_parent;
> -               clk_composite_ops->set_parent = clk_composite_set_parent;
>          }
>   
>          if (div_hw && div_ops) {
> @@ -164,9 +189,6 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
>   
>                  composite->div_hw = div_hw;
>                  composite->div_ops = div_ops;
> -               clk_composite_ops->recalc_rate = clk_composite_recalc_rate;
> -               clk_composite_ops->round_rate = clk_composite_round_rate;
> -               clk_composite_ops->set_rate = clk_composite_set_rate;
>          }
>   
>          if (gate_hw && gate_ops) {
> @@ -178,12 +200,9 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
>   
>                  composite->gate_hw = gate_hw;
>                  composite->gate_ops = gate_ops;
> -               clk_composite_ops->is_enabled = clk_composite_is_enabled;
> -               clk_composite_ops->enable = clk_composite_enable;
> -               clk_composite_ops->disable = clk_composite_disable;
>          }
>   
> -       init.ops = clk_composite_ops;
> +       init.ops = &clk_composite_ops;
>          composite->hw.init = &init;
>   
>          clk = clk_register(dev, &composite->hw);
> @@ -202,7 +221,6 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
>          return clk;
>   
>   err:
> -       kfree(clk_composite_ops);
>          kfree(composite);
>          return clk;
>   }

