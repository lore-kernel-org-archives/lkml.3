Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaIWQOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:14:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:53554 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaIWQOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="390436624"
Date: Tue, 23 Sep 2014 21:10:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: cppi41: Switch to using managed resource in probe
Message-ID: <20140923154035.GP24663@intel.com>
References: <1411476646-16902-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411476646-16902-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:20:46PM +0530, Kiran Padwal wrote:
> This change uses managed resource APIs to allocate resources such as,
> mem, irq in order to simplify the driver unload or failure cases.
> 
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
> ---
>  drivers/dma/cppi41.c |   15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
> index 5921ce3..d3700fb 100644
> --- a/drivers/dma/cppi41.c
> +++ b/drivers/dma/cppi41.c
> @@ -938,7 +938,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>  	if (!glue_info)
>  		return -EINVAL;
>  
> -	cdd = kzalloc(sizeof(*cdd), GFP_KERNEL);
> +	cdd = devm_kzalloc(&pdev->dev, sizeof(*cdd), GFP_KERNEL);
>  	if (!cdd)
>  		return -ENOMEM;
>  
> @@ -959,10 +959,8 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>  	cdd->qmgr_mem = of_iomap(dev->of_node, 3);
>  
>  	if (!cdd->usbss_mem || !cdd->ctrl_mem || !cdd->sched_mem ||
> -			!cdd->qmgr_mem) {
> -		ret = -ENXIO;
> -		goto err_remap;
> -	}
> +			!cdd->qmgr_mem)
> +		return -ENXIO;
>  
>  	pm_runtime_enable(dev);
>  	ret = pm_runtime_get_sync(dev);
> @@ -989,7 +987,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>  
>  	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
>  
> -	ret = request_irq(irq, glue_info->isr, IRQF_SHARED,
> +	ret = devm_request_irq(&pdev->dev, irq, glue_info->isr, IRQF_SHARED,
>  			dev_name(dev), cdd);
>  	if (ret)
>  		goto err_irq;
> @@ -1009,7 +1007,6 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>  err_of:
>  	dma_async_device_unregister(&cdd->ddev);
>  err_dma_reg:
> -	free_irq(irq, cdd);
>  err_irq:
>  	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
>  	cleanup_chans(cdd);
> @@ -1023,8 +1020,6 @@ err_get_sync:
>  	iounmap(cdd->ctrl_mem);
>  	iounmap(cdd->sched_mem);
>  	iounmap(cdd->qmgr_mem);
> -err_remap:
> -	kfree(cdd);
>  	return ret;
>  }
>  
> @@ -1036,7 +1031,6 @@ static int cppi41_dma_remove(struct platform_device *pdev)
>  	dma_async_device_unregister(&cdd->ddev);
>  
>  	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
> -	free_irq(cdd->irq, cdd);
pls use devm_free_irq() explicitly here, other wise your controller is active and able
to send interrupts and driver object is getting removed. It is the role of
driver to quiesce device before releasing

-- 
~Vinod

>  	cleanup_chans(cdd);
>  	deinit_cppi41(&pdev->dev, cdd);
>  	iounmap(cdd->usbss_mem);
> @@ -1045,7 +1039,6 @@ static int cppi41_dma_remove(struct platform_device *pdev)
>  	iounmap(cdd->qmgr_mem);
>  	pm_runtime_put(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> -	kfree(cdd);
>  	return 0;
>  }
>  
> -- 
> 1.7.9.5
> 

-- 
