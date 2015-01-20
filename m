Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbbATAAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:00:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35531 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbATAAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:00:21 -0500
Date: Mon, 19 Jan 2015 16:00:19 -0800
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
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bintian Wang <bintian.wang@huawei.com>,
        Chao Xie <chao.xie@marvell.com>, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v9 3/3] clk: Add floor and ceiling constraints to clock
 rates
Message-ID: <20150120000019.GD27202@codeaurora.org>
References: <1421688067-24426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421688067-24426-4-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421688067-24426-4-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Tomeu Vizoso wrote:
> Adds a way for clock consumers to set maximum and minimum rates. This can be
> used for thermal drivers to set ceiling rates, or by misc. drivers to set
> floor rates to assure a minimum performance level.
> 
> Changes the signature of the determine_rate callback by adding the
> parameters floor_rate and ceiling_rate.

Commit text needs the s/floor/min and s/ceiling/max treatment
too.

> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index f2a1ff3..55b3124 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1026,6 +1051,28 @@ static unsigned long clk_core_round_rate_nolock(struct clk_core *clk,
>  	else
>  		return clk->rate;
>  }
> +unsigned long __clk_determine_rate(struct clk_hw *hw,
> +				   unsigned long rate,
> +				   unsigned long min_rate,
> +				   unsigned long max_rate)
> +{
> +	unsigned long parent_rate = 0;
> +	struct clk_core *core = hw->core;
> +	struct clk_hw *parent_hw;
> +
> +	if (!core->ops->determine_rate)
> +		return 0;
> +
> +	if (core->parent) {
> +		parent_rate = core->parent->rate;
> +		parent_hw = core->parent->hw;
> +	}
> +
> +	return core->ops->determine_rate(core->hw, rate,
> +					min_rate, max_rate,
> +					&parent_rate, &parent_hw);
> +}
> +EXPORT_SYMBOL_GPL(__clk_determine_rate);

Maybe I misled you with the API name. I was thinking more along
the lines of clk_round_rate() and this new function ending up
calling clk_core_round_rate(), but clk_round_rate() would call it
with whatever range the clock is constrained to while this new
function would allow driver authors to specify the range. It
should be easy enough to add min/max to clk_core_round_rate()
given that it's a private API in this file.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
