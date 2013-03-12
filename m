Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3CLMFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:05:43 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:40540
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755144Ab3CLMFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:05:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 12 Mar 2013 20:04:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <vinod.koul@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: mxs-dma: Convert to devm_ioremap_resource()
Message-ID: <20130312120446.GA27461@S2101-09.ap.freescale.net>
References: <1363045833-6690-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363045833-6690-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:50:33PM -0300, Fabio Estevam wrote:
> Converting to devm_ioremap_resource() can make the code cleaner and smaller.
> 
While you are there, you may want to use devm_kzalloc() and
devm_clk_get() as well.

Shawn

> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
>  drivers/dma/mxs-dma.c |   18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> index 8f6d30d..8a9939e4 100644
> --- a/drivers/dma/mxs-dma.c
> +++ b/drivers/dma/mxs-dma.c
> @@ -689,16 +689,9 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
>  	mxs_dma->dev_id = dma_type->id;
>  
>  	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -
> -	if (!request_mem_region(iores->start, resource_size(iores),
> -				pdev->name)) {
> -		ret = -EBUSY;
> -		goto err_request_region;
> -	}
> -
> -	mxs_dma->base = ioremap(iores->start, resource_size(iores));
> -	if (!mxs_dma->base) {
> -		ret = -ENOMEM;
> +	mxs_dma->base = devm_ioremap_resource(&pdev->dev, iores);
> +	if (IS_ERR(mxs_dma->base)) {
> +		ret = PTR_ERR(mxs_dma->base);
>  		goto err_ioremap;
>  	}
>  
> @@ -761,10 +754,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
>  err_init:
>  	clk_put(mxs_dma->clk);
>  err_clk:
> -	iounmap(mxs_dma->base);
> -err_ioremap:
> -	release_mem_region(iores->start, resource_size(iores));
> -err_request_region:
> +err_ioremap:
>  	kfree(mxs_dma);
>  	return ret;
>  }
> -- 
> 1.7.9.5
> 

