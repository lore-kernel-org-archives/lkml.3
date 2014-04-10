Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935518AbaDJL31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:29:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:59014 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935102AbaDJL3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:29:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,833,1389772800"; 
   d="scan'208";a="417327009"
Message-ID: <1397129361.11914.96.camel@smile.fi.intel.com>
Subject: Re: [PATCH v3 4/8] DMA: Freescale: add fsl_dma_free_descriptor() to
 reduce code duplication
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: hongbo.zhang@freescale.com
Cc: vkoul@infradead.org, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, leo.li@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Apr 2014 14:29:21 +0300
In-Reply-To: <1397113805-24171-5-git-send-email-hongbo.zhang@freescale.com>
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com>
	 <1397113805-24171-5-git-send-email-hongbo.zhang@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 15:10 +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> There are several places where descriptors are freed using identical code.
> This patch puts this code into a function to reduce code duplication.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/dma/fsldma.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index b71cc04..b5a0ffa 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -418,6 +418,19 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>  }
>  
>  /**
> + * fsl_dma_free_descriptor - Free descriptor from channel's DMA pool.
> + * @chan : Freescale DMA channel
> + * @desc: descriptor to be freed
> + */
> +static void fsl_dma_free_descriptor(struct fsldma_chan *chan,
> +		struct fsl_desc_sw *desc)
> +{
> +	list_del(&desc->node);
> +	chan_dbg(chan, "LD %p free\n", desc);
> +	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> +}
> +
> +/**
>   * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
>   * @chan : Freescale DMA channel
>   *
> @@ -489,11 +502,8 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
>  {
>  	struct fsl_desc_sw *desc, *_desc;
>  
> -	list_for_each_entry_safe(desc, _desc, list, node) {
> -		list_del(&desc->node);
> -		chan_dbg(chan, "LD %p free\n", desc);
> -		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> -	}
> +	list_for_each_entry_safe(desc, _desc, list, node)
> +		fsl_dma_free_descriptor(chan, desc);
>  }
>  
>  static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
> @@ -501,11 +511,8 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
>  {
>  	struct fsl_desc_sw *desc, *_desc;
>  
> -	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
> -		list_del(&desc->node);
> -		chan_dbg(chan, "LD %p free\n", desc);
> -		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> -	}
> +	list_for_each_entry_safe_reverse(desc, _desc, list, node)
> +		fsl_dma_free_descriptor(chan, desc);
>  }
>  
>  /**
> @@ -819,8 +826,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
>  	dma_run_dependencies(txd);
>  
>  	dma_descriptor_unmap(txd);
> -	chan_dbg(chan, "LD %p free\n", desc);
> -	dma_pool_free(chan->desc_pool, desc, txd->phys);
> +	fsl_dma_free_descriptor(chan, desc);

Here is no list_del() call since it's been called in dma_do_tasklet().
What will be the result of double list_del() against the same node?

>  }
>  
>  /**


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

