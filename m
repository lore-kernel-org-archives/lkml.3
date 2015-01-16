Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbbAPW3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:29:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52160 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbbAPW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:29:16 -0500
Message-ID: <54B990B9.2020702@codeaurora.org>
Date: Fri, 16 Jan 2015 14:29:13 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: fractional-divider: prevent division by zero
References: <1421411870-115195-1-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1421411870-115195-1-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 04:37 AM, Heikki Krogerus wrote:
> Preventing division by zero condition by making sure that
> the initial n and m values are not 0.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/clk/clk-fractional-divider.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/clk/clk-fractional-divider.c b/drivers/clk/clk-fractional-divider.c
> index 82a59d0..dc91da7 100644
> --- a/drivers/clk/clk-fractional-divider.c
> +++ b/drivers/clk/clk-fractional-divider.c
> @@ -104,6 +104,7 @@ struct clk *clk_register_fractional_divider(struct device *dev,
>  	struct clk_fractional_divider *fd;
>  	struct clk_init_data init;
>  	struct clk *clk;
> +	u32 val;
>  
>  	fd = kzalloc(sizeof(*fd), GFP_KERNEL);
>  	if (!fd) {
> @@ -126,6 +127,14 @@ struct clk *clk_register_fractional_divider(struct device *dev,
>  	fd->lock = lock;
>  	fd->hw.init = &init;
>  
> +	/* Prevent division by zero */
> +	val = clk_readl(fd->reg);
> +	if (!(val & fd->nmask))
> +		val |= 1 << fd->nshift;
> +	if (!(val & fd->mmask))
> +		val |= 1 << fd->mshift;
> +	clk_writel(val, fd->reg);
> +
>  	clk = clk_register(dev, &fd->hw);
>  	if (IS_ERR(clk))
>  		kfree(fd);

Sorry I don't understand this at all. Does your hardware support a value
of 0 in the register? Doesn't that mean "bypass" so that the rate of the
parent bypasses the divider? If so, why aren't we fixing the
recalc_rate() logic to check for a special case of 0?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

