Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaJIUog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:44:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46575 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJIUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:44:35 -0400
Date: Thu, 9 Oct 2014 13:44:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Jiri Kosina <jkosina@suse.cz>, Ralf Baechle <ralf@linux-mips.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Manuel Lauss <manuel.lauss@gmail.com>, Alex Elder <elder@linaro.org>,
        Matt Porter <mporter@linaro.org>, Tim Kryger <tim.kryger@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 6/8] clk: Change clk_ops->determine_rate to return a
 clk_hw as the best parent
Message-ID: <20141009204433.GE5493@codeaurora.org>
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412866903-6970-7-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412866903-6970-7-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Tomeu Vizoso wrote:
> @@ -946,6 +946,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
>  {
>  	unsigned long parent_rate = 0;
>  	struct clk *parent;
> +	struct clk_hw *parent_hw;
>  
>  	if (!clk)
>  		return 0;
> @@ -956,7 +957,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
>  
>  	if (clk->ops->determine_rate)
>  		return clk->ops->determine_rate(clk->hw, rate, &parent_rate,
> -						&parent);
> +						&parent_hw);

We should assign the value of parent_hw somewhere here so that
drivers don't need to if they want the current parent. This would
match the current behavior where parent is already assigned the
current parent.

>  	else if (clk->ops->round_rate)
>  		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
>  	else if (clk->flags & CLK_SET_RATE_PARENT)
> @@ -1345,6 +1346,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>  {
>  	struct clk *top = clk;
>  	struct clk *old_parent, *parent;
> +	struct clk_hw *parent_hw;
>  	unsigned long best_parent_rate = 0;
>  	unsigned long new_rate;
>  	int p_index = 0;
> @@ -1362,7 +1364,8 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
>  	if (clk->ops->determine_rate) {
>  		new_rate = clk->ops->determine_rate(clk->hw, rate,
>  						    &best_parent_rate,
> -						    &parent);
> +						    &parent_hw);
> +		parent = parent_hw->clk;

Same comment here.

>  	} else if (clk->ops->round_rate) {
>  		new_rate = clk->ops->round_rate(clk->hw, rate,
>  						&best_parent_rate);
> 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
