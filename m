Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbbAVBBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:01:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41738 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbbAVBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:01:38 -0500
Date: Wed, 21 Jan 2015 17:01:36 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 2/4] clk: Make clk API return per-user struct clk
 instances
Message-ID: <20150122010136.GH27202@codeaurora.org>
References: <1421847039-29544-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421847039-29544-3-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421847039-29544-3-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Tomeu Vizoso wrote:
> @@ -2075,10 +2210,12 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
>  		}
>  	}
>  
> -	ret = __clk_init(dev, clk);
> +	hw->clk = __clk_create_clk(hw, NULL, NULL);
> +	ret = __clk_init(dev, hw->clk);
>  	if (!ret)
> -		return clk;
> +		return hw->clk;
>  
> +	kfree(hw->clk);
>  fail_parent_names_copy:
>  	while (--i >= 0)
>  		kfree(clk->parent_names[i]);

Sigh, this patch is so huge I keep finding more things. Sorry. It
looks like __clk_create_clk() can return an error pointer, which
we then send directly to __clk_init. First off, we shouldn't
kfree() that pointer if it's an error pointer. Second, we
shouldn't crash in __clk_init() in such a situation so there
needs to be some sort of check somewhere.

BTW, please try and fixup checkpatch warnings.

> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index da4bda8..fac3244 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -69,20 +70,22 @@ struct clk *of_clk_get(struct device_node *np, int index)
[...]
> -struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
> +static struct clk *__of_clk_get_by_name(struct device_node *np, const char *name)

It would be nice if this returned an already __clk_create_clk()ed
pointer.

>  {
>  	struct clk *clk = ERR_PTR(-ENOENT);
>  
> @@ -119,7 +122,33 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
[...]
> +struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
> +{
> +	struct clk *clk = __of_clk_get_by_name(np, name);
> +
> +	if (!IS_ERR(clk))
> +		clk = __clk_create_clk(__clk_get_hw(clk), np->full_name, name);

Because we do it here where we know we're CONFIG_COMMON_CLK=y.

> +
> +	return clk;
> +}
>  EXPORT_SYMBOL(of_clk_get_by_name);
> +
> +#else /* defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK) */
> +
> +static struct clk *__of_clk_get_by_name(struct device_node *np, const char *name)
> +{
> +	return ERR_PTR(-ENOENT);
> +}
>  #endif
>  
>  /*
> @@ -185,9 +229,13 @@ struct clk *clk_get(struct device *dev, const char *con_id)
>  	struct clk *clk;
>  
>  	if (dev) {
> -		clk = of_clk_get_by_name(dev->of_node, con_id);
> -		if (!IS_ERR(clk))
> +		clk = __of_clk_get_by_name(dev->of_node, con_id);
> +		if (!IS_ERR(clk)) {
> +#if defined(CONFIG_COMMON_CLK)
> +			clk = __clk_create_clk(__clk_get_hw(clk), dev_id, con_id);
> +#endif

And we do it here where we could remove the #ifdef.

>  			return clk;
> +		}
>  		if (PTR_ERR(clk) == -EPROBE_DEFER)
>  			return clk;
>  	}

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
