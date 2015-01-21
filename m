Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbbAUArB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:47:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35378 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAUAq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:46:59 -0500
Date: Tue, 20 Jan 2015 16:46:55 -0800
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
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Bintian Wang <bintian.wang@huawei.com>,
        Chao Xie <chao.xie@marvell.com>, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v10 3/3] clk: Add rate constraints to clocks
Message-ID: <20150121004655.GG27202@codeaurora.org>
References: <1421760306-6301-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421760306-6301-4-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421760306-6301-4-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's looking fairly close. Thanks for keeping up with the review
comments.

On 01/20, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index e867d6a..f241e27 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2143,6 +2280,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
>  	else
>  		clk->owner = NULL;
>  
> +	INIT_HLIST_HEAD(&clk->clks);
> +
> +	hw->clk = __clk_create_clk(hw, NULL, NULL);
> +
>  	ret = __clk_init(dev, hw->clk);
>  	if (ret)
>  		return ERR_PTR(ret);

Don't we need to __clk_free_clk() here too?

> @@ -2151,6 +2292,19 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
>  }
>  EXPORT_SYMBOL_GPL(__clk_register);
>  
> +static void __clk_free_clk(struct clk *clk)
> +{
> +	struct clk_core *core = clk->core;
> +
> +	clk_prepare_lock();
> +	hlist_del(&clk->child_node);
> +	clk_prepare_unlock();
> +
> +	kfree(clk);
> +
> +	clk_core_set_rate(core, core->req_rate);

Is it safe to call this during clock registration? I hope that it
will just bail out and do nothing because core->rate ==
core->req_rate. Maybe we can avoid this given my next comment
below.

> +}
> +
>  /**
>   * clk_register - allocate a new clock, register it and return an opaque cookie
>   * @dev: device that is registering this clock
> @@ -2210,12 +2364,14 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
>  		}
>  	}
>  
> +	INIT_HLIST_HEAD(&clk->clks);
> +
>  	hw->clk = __clk_create_clk(hw, NULL, NULL);
>  	ret = __clk_init(dev, hw->clk);
>  	if (!ret)
>  		return hw->clk;
>  
> -	kfree(hw->clk);
> +	__clk_free_clk(hw->clk);
>  fail_parent_names_copy:
>  	while (--i >= 0)
>  		kfree(clk->parent_names[i]);
> @@ -2421,7 +2577,7 @@ void __clk_put(struct clk *clk)
>  		return;
>  
>  	clk_core_put(clk->core);
> -	kfree(clk);
> +	__clk_free_clk(clk);

This doesn't look right. First we drop the core reference here
with clk_core_put() and then we call __clk_free_clk() which will
go and call clk_core_set_rate() on the clk->core which may or may
not exist anymore. I'd think we want to do these steps:

 1. Unlink clk from clks list
 2. Recalculate rate and set if changed
 3. Drop kref on core with clk_core_put()
 4. kfree the clk

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
