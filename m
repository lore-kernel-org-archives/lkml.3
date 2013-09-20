Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3ITO1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 10:27:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:21142 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3ITO1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 10:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,944,1371106800"; 
   d="scan'208";a="297311415"
Message-ID: <1379687206.10899.5.camel@smile>
Subject: Re: [PATCH 30/51] DMA-API: dma: dw_dmac.c: convert to use
 dma_coerce_mask_and_coherent()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.linux@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Date: Fri, 20 Sep 2013 17:26:46 +0300
In-Reply-To: <E1VMmBi-0007iw-MP@rmk-PC.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
	 <E1VMmBi-0007iw-MP@rmk-PC.arm.linux.org.uk>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 22:55 +0100, Russell King wrote:
> This code sequence:
> 	if (!pdev->dev.dma_mask) {
> 		pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> 	}
> bypasses the architectures check on the DMA mask.  It can be replaced
> with dma_coerce_mask_and_coherent(), avoiding the direct initialization
> of this mask.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  drivers/dma/dw/platform.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
> index e35d975..453822c 100644
> --- a/drivers/dma/dw/platform.c
> +++ b/drivers/dma/dw/platform.c
> @@ -191,11 +191,9 @@ static int dw_probe(struct platform_device *pdev)
>  	if (IS_ERR(chip->regs))
>  		return PTR_ERR(chip->regs);
>  
> -	/* Apply default dma_mask if needed */
> -	if (!dev->dma_mask) {
> -		dev->dma_mask = &dev->coherent_dma_mask;
> -		dev->coherent_dma_mask = DMA_BIT_MASK(32);
> -	}
> +	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	if (err)
> +		return err;

I have at least one question.

In case of new code you always assign dev->dma_mask.

static inline int dma_coerce_mask_and_coherent(struct device *dev, u64
mask)
{
       dev->dma_mask = &dev->coherent_dma_mask;
       return dma_set_mask_and_coherent(dev, mask);
}

So, the question is how keep the initialized dma_mask (and should we do
so by your opinion)?

Additional question, who will free memory allocated for dma_mask in case
if it was allocated, dma_mask initialized and then your code just
substitute the address to some new value?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
