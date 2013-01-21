Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3AUJOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:14:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:38464 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3AUJOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:14:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="246421425"
Date: Mon, 21 Jan 2013 00:49:24 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
Message-ID: <20130121084924.GA26562@intel.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:00:44AM +0200, Andy Shevchenko wrote:
> Currently the driver returns full length of the active descriptor which is
> wrong. We have to go throught the active descriptor and sum up the length of
> unsent children in the chain along with the actual data in the DMA channel
why do you mean by children here?
> registers.
> 
> The cyclic case is not handled by this patch due to len field in the descriptor
> structure is left untouched by the original code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 92 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d1b9ba2..4325c68 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -941,6 +941,97 @@ err_desc_get:
>  	return NULL;
>  }
>  
> +/* --------------------- Calculate residue ---------------------------- */
> +
> +static inline size_t dwc_get_rest(struct dw_dma_chan *dwc, struct dw_desc *desc)
> +{
> +	enum dma_transfer_direction direction = dwc->direction;
> +
> +	if (direction == DMA_MEM_TO_DEV || direction == DMA_MEM_TO_MEM)
> +		return desc->len - (channel_readl(dwc, SAR) - desc->lli.sar);
> +	else if (direction == DMA_DEV_TO_MEM)
> +		return desc->len - (channel_readl(dwc, DAR) - desc->lli.dar);
> +
> +	return 0;
hmmm, why not use BLOCK_TS value. That way you dont need to look at direction
and along with burst can easily calculate residue...

--
~Vinod
