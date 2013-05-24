Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3EXFyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:54:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:42528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab3EXFyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:54:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,732,1363158000"; 
   d="scan'208";a="342441768"
Date: Fri, 24 May 2013 10:44:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Li Yang <leoli@freescale.com>, "'Zhang Wei'" <zw@zh-kernel.org>
Subject: Re: [PATCH] dma: use platform_{get,set}_drvdata()
Message-ID: <20130524051420.GO30200@intel.com>
References: <000301ce581b$720da060$5628e120$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301ce581b$720da060$5628e120$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 10:10:13AM +0900, Jingoo Han wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Also, unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Applied thanks

--
~Vinod
> ---
>  drivers/dma/fsldma.c      |    5 ++---
>  drivers/dma/ppc4xx/adma.c |    5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 4fc2980..49e8fbd 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -1368,7 +1368,7 @@ static int fsldma_of_probe(struct platform_device *op)
>  
>  	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
>  
> -	dev_set_drvdata(&op->dev, fdev);
> +	platform_set_drvdata(op, fdev);
>  
>  	/*
>  	 * We cannot use of_platform_bus_probe() because there is no
> @@ -1417,7 +1417,7 @@ static int fsldma_of_remove(struct platform_device *op)
>  	struct fsldma_device *fdev;
>  	unsigned int i;
>  
> -	fdev = dev_get_drvdata(&op->dev);
> +	fdev = platform_get_drvdata(op);
>  	dma_async_device_unregister(&fdev->common);
>  
>  	fsldma_free_irqs(fdev);
> @@ -1428,7 +1428,6 @@ static int fsldma_of_remove(struct platform_device *op)
>  	}
>  
>  	iounmap(fdev->regs);
> -	dev_set_drvdata(&op->dev, NULL);
>  	kfree(fdev);
>  
>  	return 0;
> diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
> index 5d3d955..e68c51d 100644
> --- a/drivers/dma/ppc4xx/adma.c
> +++ b/drivers/dma/ppc4xx/adma.c
> @@ -4481,7 +4481,7 @@ static int ppc440spe_adma_probe(struct platform_device *ofdev)
>  	adev->dev = &ofdev->dev;
>  	adev->common.dev = &ofdev->dev;
>  	INIT_LIST_HEAD(&adev->common.channels);
> -	dev_set_drvdata(&ofdev->dev, adev);
> +	platform_set_drvdata(ofdev, adev);
>  
>  	/* create a channel */
>  	chan = kzalloc(sizeof(*chan), GFP_KERNEL);
> @@ -4594,14 +4594,13 @@ out:
>   */
>  static int ppc440spe_adma_remove(struct platform_device *ofdev)
>  {
> -	struct ppc440spe_adma_device *adev = dev_get_drvdata(&ofdev->dev);
> +	struct ppc440spe_adma_device *adev = platform_get_drvdata(ofdev);
>  	struct device_node *np = ofdev->dev.of_node;
>  	struct resource res;
>  	struct dma_chan *chan, *_chan;
>  	struct ppc_dma_chan_ref *ref, *_ref;
>  	struct ppc440spe_adma_chan *ppc440spe_chan;
>  
> -	dev_set_drvdata(&ofdev->dev, NULL);
>  	if (adev->id < PPC440SPE_ADMA_ENGINES_NUM)
>  		ppc440spe_adma_devices[adev->id] = -1;
>  
> -- 
> 1.7.10.4
> 
> 
