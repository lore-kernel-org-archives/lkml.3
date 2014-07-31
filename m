Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaGaMKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:10:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:3347 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaGaMKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:10:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="366182178"
Date: Thu, 31 Jul 2014 17:32:05 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Vignesh Raman <Vignesh_Raman@mentor.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiada_Wang@mentor.com
Subject: Re: [PATCH 2/2] dma: imx-sdma: Adding tasklet_kill() in
 sdma_remove function.
Message-ID: <20140731120205.GT8181@intel.com>
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
 <1406725875-9171-3-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406725875-9171-3-git-send-email-Vignesh_Raman@mentor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 06:41:15PM +0530, Vignesh Raman wrote:
> Several dma drivers calls tasklet_kill() in remove function. This is missing in
> imx driver, so adding tasklet_kill() in sdma_remove function.
And why should we do that ?

-- 
~Vinod

> 
> Signed-off-by: Vignesh Raman <Vignesh_Raman@mentor.com>
> ---
>  drivers/dma/imx-sdma.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 1360b9d..974337f 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -1636,12 +1636,19 @@ static int sdma_remove(struct platform_device *pdev)
>  	struct sdma_engine *sdma = platform_get_drvdata(pdev);
>  	struct resource *iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	int irq = platform_get_irq(pdev, 0);
> +	int i;
>  
>  	dma_async_device_unregister(&sdma->dma_device);
>  	kfree(sdma->script_addrs);
>  	free_irq(irq, sdma);
>  	iounmap(sdma->regs);
>  	release_mem_region(iores->start, resource_size(iores));
> +	/* Kill the tasklet */
> +	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
> +		struct sdma_channel *sdmac = &sdma->channel[i];
> +
> +		tasklet_kill(&sdmac->tasklet);
> +	}
>  	kfree(sdma);
>  
>  	platform_set_drvdata(pdev, NULL);
> -- 
> 1.7.9.5
> 

-- 
