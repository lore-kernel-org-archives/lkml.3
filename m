Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbbAQB5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:57:07 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36665 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbbAQB5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:57:04 -0500
Date: Fri, 16 Jan 2015 17:57:01 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jonathan Corbet <corbet@lwn.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Tero Kristo <t-kristo@ti.com>, Manuel Lauss <manuel.lauss@gmail.com>,
        Alex Elder <elder@linaro.org>, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Bintian Wang <bintian.wang@huawei.com>,
        Chao Xie <chao.xie@marvell.com>, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH RESEND v8 2/2] clk: Add floor and ceiling constraints to
 clock rates
Message-ID: <20150117015701.GB27202@codeaurora.org>
References: <1421071809-17402-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421071809-17402-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421071809-17402-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 7eddfd8..2793bd7 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1013,8 +1015,8 @@ static unsigned long clk_core_round_rate_nolock(struct clk_core *clk,
>  
>  	if (clk->ops->determine_rate) {
>  		parent_hw = parent ? parent->hw : NULL;
> -		return clk->ops->determine_rate(clk->hw, rate, &parent_rate,
> -						&parent_hw);
> +		return clk->ops->determine_rate(clk->hw, rate, 0, ULONG_MAX,
> +						&parent_rate, &parent_hw);
>  	} else if (clk->ops->round_rate)
>  		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
>  	else if (clk->flags & CLK_SET_RATE_PARENT)
> @@ -1453,8 +1458,20 @@ static struct clk_core *clk_calc_new_rates(struct clk_core *clk,
>  
>  	/* find the closest rate and parent clk/rate */
>  	if (clk->ops->determine_rate) {
> +		hlist_for_each_entry(clk_user, &clk->clks, child_node) {
> +			floor_rate = max(floor_rate,
> +					 clk_user->floor_constraint);
> +		}
> +
> +		hlist_for_each_entry(clk_user, &clk->clks, child_node) {
> +			ceiling_rate = min(ceiling_rate,
> +					   clk_user->ceiling_constraint);
> +		}

I would think we need to do this in the clk_round_rate() path as
well. We can't just pass 0 and ULONG_MAX there or we'll determine
one rate here and another rate in round_rate(), violating the
contract between set_rate() and round_rate().

> +
>  		parent_hw = parent ? parent->hw : NULL;
>  		new_rate = clk->ops->determine_rate(clk->hw, rate,
> +						    floor_rate,
> +						    ceiling_rate,
>  						    &best_parent_rate,
>  						    &parent_hw);
>  		parent = parent_hw ? parent_hw->core : NULL;

We should enforce a constraint if the clk is using the
round_rate() op too. If the .round_rate() op returns some rate
within range it should be ok.  Otherwise we can fail the rate
change because it's out of range.

We'll also need to introduce some sort of
clk_core_determine_rate(core, rate, min, max) so that clock
providers can ask parent clocks to find a rate within some range
that they can tolerate. If we update __clk_mux_determine_rate()
we can see how that would work out.

> @@ -1660,13 +1657,92 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
[...]
> + */
> +int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	return clk_core_set_rate(clk->core, rate);

clk could be NULL.

> +}
>  EXPORT_SYMBOL_GPL(clk_set_rate);
>  
> +int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max)
> +{
> +	int ret = 0;

Check for NULL clk.

> +
> +/**
> + * clk_set_floor_rate - set a minimum clock rate for a clock source
> + * @clk: clock source
> + * @rate: desired minimum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_floor_rate(struct clk *clk, unsigned long rate)
> +{
> +	return clk_set_rate_range(clk, rate, clk->ceiling_constraint);

clk could be NULL.

> +}
> +EXPORT_SYMBOL_GPL(clk_set_floor_rate);
> +
> +/**
> + * clk_set_ceiling_rate - set a maximum clock rate for a clock source
> + * @clk: clock source
> + * @rate: desired maximum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_ceiling_rate(struct clk *clk, unsigned long rate)
> +{
> +	return clk_set_rate_range(clk, clk->floor_constraint, rate);

clk could be NULL.

> +}
> +EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
> +
>  static struct clk_core *clk_core_get_parent(struct clk_core *core)
>  {
>  	struct clk_core *parent;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 2e65419..ae5c800 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -175,9 +175,12 @@ struct clk_ops {
>  					unsigned long parent_rate);
>  	long		(*round_rate)(struct clk_hw *hw, unsigned long rate,
>  					unsigned long *parent_rate);
> -	long		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
> -					unsigned long *best_parent_rate,
> -					struct clk_hw **best_parent_hw);
> +	long		(*determine_rate)(struct clk_hw *hw,
> +					  unsigned long rate,
> +					  unsigned long floor_rate,
> +					  unsigned long ceiling_rate,

I wonder if we should call this min_rate and max_rate?

> +					  unsigned long *best_parent_rate,
> +					  struct clk_hw **best_parent_hw);
>  	int		(*set_parent)(struct clk_hw *hw, u8 index);
>  	u8		(*get_parent)(struct clk_hw *hw);
>  	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index c7f258a..f99ae67 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -302,6 +302,34 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
>  int clk_set_rate(struct clk *clk, unsigned long rate);
>  
>  /**
> + * clk_set_rate_range - set a rate range for a clock source
> + * @clk: clock source
> + * @min: desired minimum clock rate in Hz
> + * @max: desired maximum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max);
> +
> +/**
> + * clk_set_floor_rate - set a minimum clock rate for a clock source
> + * @clk: clock source
> + * @rate: desired minimum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_floor_rate(struct clk *clk, unsigned long rate);

And this called clk_set_max_rate()?

> +
> +/**
> + * clk_set_ceiling_rate - set a maximum clock rate for a clock source
> + * @clk: clock source
> + * @rate: desired maximum clock rate in Hz
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_set_ceiling_rate(struct clk *clk, unsigned long rate);

And this called clk_set_min_rate()?

> +
> +/**
>   * clk_set_parent - set the parent clock source for this clock
>   * @clk: clock source
>   * @parent: parent clock source

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
