Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaGaMIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:08:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:41259 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaGaMIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,771,1400050800"; 
   d="scan'208";a="463548489"
Date: Thu, 31 Jul 2014 17:30:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Vignesh Raman <Vignesh_Raman@mentor.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiada_Wang@mentor.com
Subject: Re: [PATCH 1/2] dma: imx-sdma: use module_platform_driver for SDMA
 driver
Message-ID: <20140731120011.GS8181@intel.com>
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
 <1406725875-9171-2-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406725875-9171-2-git-send-email-Vignesh_Raman@mentor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 06:41:14PM +0530, Vignesh Raman wrote:
> Currently there is no module_exit declared in SDMA driver, so that once
> sdma module is inserted, it's shown with permanent attribute by lsmod,
> and it can't be removed.
> Use module_platform_driver to register/unregister SDMA driver and modify
> SDMA's remove operation, to make SDMA driver possible to be removed.
where is this bit below?

-- 
~Vinod
> 
> Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
> ---
>  drivers/dma/imx-sdma.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 14867e3..1360b9d 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1633,7 +1633,21 @@ err_irq:
>  
>  static int sdma_remove(struct platform_device *pdev)
>  {
> -	return -EBUSY;
> +	struct sdma_engine *sdma = platform_get_drvdata(pdev);
> +	struct resource *iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	int irq = platform_get_irq(pdev, 0);
> +
> +	dma_async_device_unregister(&sdma->dma_device);
> +	kfree(sdma->script_addrs);
> +	free_irq(irq, sdma);
> +	iounmap(sdma->regs);
> +	release_mem_region(iores->start, resource_size(iores));
> +	kfree(sdma);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	dev_info(&pdev->dev, "Removed...\n");
> +	return 0;
>  }
>  
>  static struct platform_driver sdma_driver = {
> -- 
> 1.7.9.5
> 

-- 
