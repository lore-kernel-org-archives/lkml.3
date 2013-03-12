Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3CLMHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:07:38 -0400
Received: from [207.46.163.26] ([207.46.163.26]:22458 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab3CLMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:07:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 12 Mar 2013 20:06:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
CC: <FlorianSchandinat@gmx.de>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] video: mxsfb: Convert to devm_ioremap_resource()
Message-ID: <20130312120648.GB27461@S2101-09.ap.freescale.net>
References: <1363045937-6740-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363045937-6740-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:52:17PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Converting to devm_ioremap_resource() can make the code cleaner and smaller.
> 
While you are there, you may want to use devm_kzalloc() and
devm_clk_get() as well.

Shawn

> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/video/mxsfb.c |   19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index 755556c..26cbc56 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -801,22 +801,17 @@ static int mxsfb_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	if (!request_mem_region(res->start, resource_size(res), pdev->name))
> -		return -EBUSY;
> -
>  	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
>  	if (!fb_info) {
>  		dev_err(&pdev->dev, "Failed to allocate fbdev\n");
> -		ret = -ENOMEM;
> -		goto error_alloc_info;
> +		return -ENOMEM;
>  	}
>  
>  	host = to_imxfb_host(fb_info);
>  
> -	host->base = ioremap(res->start, resource_size(res));
> -	if (!host->base) {
> -		dev_err(&pdev->dev, "ioremap failed\n");
> -		ret = -ENOMEM;
> +	host->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(host->base)) {
> +		return PTR_ERR(host->base);
>  		goto error_ioremap;
>  	}
>  
> @@ -904,11 +899,8 @@ error_panel_enable:
>  	clk_put(host->clk);
>  error_getclock:
>  error_getpin:
> -	iounmap(host->base);
>  error_ioremap:
>  	framebuffer_release(fb_info);
> -error_alloc_info:
> -	release_mem_region(res->start, resource_size(res));
>  
>  	return ret;
>  }
> @@ -917,7 +909,6 @@ static int mxsfb_remove(struct platform_device *pdev)
>  {
>  	struct fb_info *fb_info = platform_get_drvdata(pdev);
>  	struct mxsfb_info *host = to_imxfb_host(fb_info);
> -	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  
>  	if (host->enabled)
>  		mxsfb_disable_controller(fb_info);
> @@ -925,11 +916,9 @@ static int mxsfb_remove(struct platform_device *pdev)
>  	unregister_framebuffer(fb_info);
>  	kfree(fb_info->pseudo_palette);
>  	mxsfb_free_videomem(host);
> -	iounmap(host->base);
>  	clk_put(host->clk);
>  
>  	framebuffer_release(fb_info);
> -	release_mem_region(res->start, resource_size(res));
>  
>  	platform_set_drvdata(pdev, NULL);
>  
> -- 
> 1.7.9.5
> 

