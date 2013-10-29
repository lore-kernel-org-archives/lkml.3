Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3J2W2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:28:15 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38653 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3J2W2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:28:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v7 1/5] omap3isp: Modify clocks registration to avoid circular references
Date: Tue, 29 Oct 2013 23:28:37 +0100
Message-ID: <16467881.81yEf9zq68@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383076268-8984-2-git-send-email-s.nawrocki@samsung.com>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com> <1383076268-8984-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Thank you for the patch.

On Tuesday 29 October 2013 20:51:04 Sylwester Nawrocki wrote:
> The clock core code is going to be modified so clk_get() takes
> reference on the clock provider module. Until the potential circular
> reference issue is properly addressed, we pass NULL as as the first
> argument to clk_register(), in order to disallow sub-devices taking
> a reference on the ISP module back trough clk_get(). This should
> prevent locking the modules in memory.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Do you plan to push this to mainline as part of this patch series ? I don't 
have pending patches for the omap3isp that would conflict with this patch, so 
that would be fine with me.

> ---
> This patch has been "compile tested" only.
> 
> ---
>  drivers/media/platform/omap3isp/isp.c |   22 ++++++++++++++++------
>  drivers/media/platform/omap3isp/isp.h |    1 +
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index df3a0ec..286027a 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -290,9 +290,11 @@ static int isp_xclk_init(struct isp_device *isp)
>  	struct clk_init_data init;
>  	unsigned int i;
> 
> +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
> +		isp->xclks[i].clk = ERR_PTR(-EINVAL);
> +
>  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
>  		struct isp_xclk *xclk = &isp->xclks[i];
> -		struct clk *clk;
> 
>  		xclk->isp = isp;
>  		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
> @@ -305,10 +307,15 @@ static int isp_xclk_init(struct isp_device *isp)
>  		init.num_parents = 1;
> 
>  		xclk->hw.init = &init;
> -
> -		clk = devm_clk_register(isp->dev, &xclk->hw);
> -		if (IS_ERR(clk))
> -			return PTR_ERR(clk);
> +		/*
> +		 * The first argument is NULL in order to avoid circular
> +		 * reference, as this driver takes reference on the
> +		 * sensor subdevice modules and the sensors would take
> +		 * reference on this module through clk_get().
> +		 */
> +		xclk->clk = clk_register(NULL, &xclk->hw);
> +		if (IS_ERR(xclk->clk))
> +			return PTR_ERR(xclk->clk);
> 
>  		if (pdata->xclks[i].con_id == NULL &&
>  		    pdata->xclks[i].dev_id == NULL)
> @@ -320,7 +327,7 @@ static int isp_xclk_init(struct isp_device *isp)
> 
>  		xclk->lookup->con_id = pdata->xclks[i].con_id;
>  		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
> -		xclk->lookup->clk = clk;
> +		xclk->lookup->clk = xclk->clk;
> 
>  		clkdev_add(xclk->lookup);
>  	}
> @@ -335,6 +342,9 @@ static void isp_xclk_cleanup(struct isp_device *isp)
>  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
>  		struct isp_xclk *xclk = &isp->xclks[i];
> 
> +		if (!IS_ERR(xclk->clk))
> +			clk_unregister(xclk->clk);
> +
>  		if (xclk->lookup)
>  			clkdev_drop(xclk->lookup);
>  	}
> diff --git a/drivers/media/platform/omap3isp/isp.h
> b/drivers/media/platform/omap3isp/isp.h index cd3eff4..1498f2b 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -135,6 +135,7 @@ struct isp_xclk {
>  	struct isp_device *isp;
>  	struct clk_hw hw;
>  	struct clk_lookup *lookup;
> +	struct clk *clk;
>  	enum isp_xclk_id id;
> 
>  	spinlock_t lock;	/* Protects enabled and divider */

-- 
Regards,

Laurent Pinchart

