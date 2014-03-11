Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaCKLLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:11:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:14953 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaCKLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:11:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="470128319"
Date: Tue, 11 Mar 2014 16:36:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: hongbo.zhang@freescale.com
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        scottwood@freescale.com, LeoLi@freescale.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] DMA: Freescale: add fsl_dma_free_descriptor() to
 reduce code duplication
Message-ID: <20140311110616.GV1976@intel.com>
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>
 <1389851246-8564-4-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389851246-8564-4-git-send-email-hongbo.zhang@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 01:47:22PM +0800, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> There are several places where descriptors are freed using identical code.
> This patch puts this code into a function to reduce code duplication.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/dma/fsldma.c |   38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 95236e6..ad73538 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -418,6 +418,21 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
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
> +#ifdef FSL_DMA_LD_DEBUG
> +	chan_dbg(chan, "LD %p free\n", desc);
> +#endif
why not wrap the define stuff in the defination of chan_dbg rather than its
usage :(

-- 
~Vinod

> +	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> +}
> +
> +/**
>   * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
>   * @chan : Freescale DMA channel
>   *
> @@ -491,13 +506,8 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
>  {
>  	struct fsl_desc_sw *desc, *_desc;
>  
> -	list_for_each_entry_safe(desc, _desc, list, node) {
> -		list_del(&desc->node);
> -#ifdef FSL_DMA_LD_DEBUG
> -		chan_dbg(chan, "LD %p free\n", desc);
> -#endif
> -		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> -	}
> +	list_for_each_entry_safe(desc, _desc, list, node)
> +		fsl_dma_free_descriptor(chan, desc);
>  }
>  
>  static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
> @@ -505,13 +515,8 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
>  {
>  	struct fsl_desc_sw *desc, *_desc;
>  
> -	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
> -		list_del(&desc->node);
> -#ifdef FSL_DMA_LD_DEBUG
> -		chan_dbg(chan, "LD %p free\n", desc);
> -#endif
> -		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> -	}
> +	list_for_each_entry_safe_reverse(desc, _desc, list, node)
> +		fsl_dma_free_descriptor(chan, desc);
>  }
>  
>  /**
> @@ -827,10 +832,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
>  	dma_run_dependencies(txd);
>  
>  	dma_descriptor_unmap(txd);
> -#ifdef FSL_DMA_LD_DEBUG
> -	chan_dbg(chan, "LD %p free\n", desc);
> -#endif
> -	dma_pool_free(chan->desc_pool, desc, txd->phys);
> +	fsl_dma_free_descriptor(chan, desc);
>  }
>  
>  /**
> -- 
> 1.7.9.5
> 
> 
> 

-- 
