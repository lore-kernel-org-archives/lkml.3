Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965666Ab3FTQkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:40:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54716 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297Ab3FTQkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:40:53 -0400
Date: Thu, 20 Jun 2013 09:40:51 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 05/12] msm: iommu: Convert to
 clk_prepare/unprepare
Message-ID: <20130620164051.GC6300@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371490999-15501-6-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending to correct Joerg address.

On 06/17, Stephen Boyd wrote:
> Add calls to clk_prepare and unprepare so that MSM can migrate to
> the common clock framework. We never unprepare the clocks until
> driver remove because the clocks are enabled and disabled in irq
> context. Finer grained power management is possible in the future
> via runtime power management techniques.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/iommu/msm_iommu_dev.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
> index 8e8fb07..d344f6a 100644
> --- a/drivers/iommu/msm_iommu_dev.c
> +++ b/drivers/iommu/msm_iommu_dev.c
> @@ -160,7 +160,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
>  		goto fail;
>  	}
>  
> -	ret = clk_enable(iommu_pclk);
> +	ret = clk_prepare_enable(iommu_pclk);
>  	if (ret)
>  		goto fail_enable;
>  
> @@ -170,7 +170,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
>  		if (clk_get_rate(iommu_clk) == 0)
>  			clk_set_min_rate(iommu_clk, 1);
>  
> -		ret = clk_enable(iommu_clk);
> +		ret = clk_prepare_enable(iommu_clk);
>  		if (ret) {
>  			clk_put(iommu_clk);
>  			goto fail_pclk;
> @@ -261,7 +261,7 @@ fail_clk:
>  		clk_put(iommu_clk);
>  	}
>  fail_pclk:
> -	clk_disable(iommu_pclk);
> +	clk_disable_unprepare(iommu_pclk);
>  fail_enable:
>  	clk_put(iommu_pclk);
>  fail:
> @@ -275,8 +275,11 @@ static int msm_iommu_remove(struct platform_device *pdev)
>  
>  	drv = platform_get_drvdata(pdev);
>  	if (drv) {
> -		if (drv->clk)
> +		if (drv->clk) {
> +			clk_unprepare(drv->clk);
>  			clk_put(drv->clk);
> +		}
> +		clk_unprepare(drv->pclk);
>  		clk_put(drv->pclk);
>  		memset(drv, 0, sizeof(*drv));
>  		kfree(drv);
> @@ -314,14 +317,14 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&ctx_drvdata->attached_elm);
>  	platform_set_drvdata(pdev, ctx_drvdata);
>  
> -	ret = clk_enable(drvdata->pclk);
> +	ret = clk_prepare_enable(drvdata->pclk);
>  	if (ret)
>  		goto fail;
>  
>  	if (drvdata->clk) {
> -		ret = clk_enable(drvdata->clk);
> +		ret = clk_prepare_enable(drvdata->clk);
>  		if (ret) {
> -			clk_disable(drvdata->pclk);
> +			clk_disable_unprepare(drvdata->pclk);
>  			goto fail;
>  		}
>  	}
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
