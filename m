Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab3HTLfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:35:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62344 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab3HTLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:35:36 -0400
Date: Tue, 20 Aug 2013 12:35:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] iommu/arm: replace devm_request_and_ioremap by
 devm_ioremap_resource
Message-ID: <20130820113503.GC23007@mudshark.cambridge.arm.com>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-4-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376911241-27720-4-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Mon, Aug 19, 2013 at 12:20:37PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use devm_ioremap_resource instead of devm_request_and_ioremap.
> 
> This was partly done using the semantic patch
> scripts/coccinelle/api/devm_ioremap_resource.cocci
> 
> The error-handling code on the call to platform_get_resource was removed
> manually, and the initialization of smmu->size was manually moved lower, to
> take advantage of the NULL test on res performed by devm_ioremap_resource.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/iommu/arm-smmu.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index ebd0a4c..dd91465 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1761,15 +1761,10 @@ static int arm_smmu_device_dt_probe(struct platform_device *pdev)
>  	smmu->dev = dev;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(dev, "missing base address/size\n");
> -		return -ENODEV;
> -	}
> -
> +	smmu->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(smmu->base))
> +		return PTR_ERR(smmu->base);
>  	smmu->size = resource_size(res);
> -	smmu->base = devm_request_and_ioremap(dev, res);
> -	if (!smmu->base)
> -		return -EADDRNOTAVAIL;

This does mean we trade arguably more useful error codes for the catch-all
-EINVAL, but the code ends up looking neater so I can be swayed either way.

Is this part of a series you're dealing with, or would you like me to take
this (I already sent my SMMU patches for 3.12)?

Cheers,

Will
