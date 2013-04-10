Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765547Ab3DJFdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:33:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:6972 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab3DJFdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:33:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,444,1363158000"; 
   d="scan'208";a="225374759"
Date: Wed, 10 Apr 2013 10:34:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Meerwald <pmeerw@pmeerw.net>, patches@linaro.org,
        stable@vger.kernel.org.#.v3.7+
Subject: Re: [PATCH] dmaengine: omap-dma: Start DMA without delay for
 cyclic channels
Message-ID: <20130410050441.GJ31193@intel.com>
References: <1365517986-9401-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365517986-9401-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 04:33:06PM +0200, Peter Ujfalusi wrote:
> cyclic DMA is only used by audio which needs DMA to be started without a
> delay.
> If the DMA for audio is started using the tasklet we experience random
> channel switch (to be more precise: channel shift).
> 
> Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
> CC: stable@vger.kernel.org  # v3.7+
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
> Hi Vinod,
> 
> Would it be possible to send this patch for 3.9. The channel shift (or switch)
> issue in audio has been noticed recently and it turns out that it has been
> present since 3.7 kernel.
> It would be great if 3.9 kernel could work correctly out of box...
Applied to fixes. I will send this to linus in a day...

--
~Vinod
> 
> Changes since RFCv2:
> - added Acked-by from Santosh and Russell
> 
> Thank you,
> Peter
> 
>  drivers/dma/omap-dma.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> index 2ea3d7e..ec3fc4f 100644
> --- a/drivers/dma/omap-dma.c
> +++ b/drivers/dma/omap-dma.c
> @@ -282,12 +282,20 @@ static void omap_dma_issue_pending(struct dma_chan *chan)
>  
>  	spin_lock_irqsave(&c->vc.lock, flags);
>  	if (vchan_issue_pending(&c->vc) && !c->desc) {
> -		struct omap_dmadev *d = to_omap_dma_dev(chan->device);
> -		spin_lock(&d->lock);
> -		if (list_empty(&c->node))
> -			list_add_tail(&c->node, &d->pending);
> -		spin_unlock(&d->lock);
> -		tasklet_schedule(&d->task);
> +		/*
> +		 * c->cyclic is used only by audio and in this case the DMA need
> +		 * to be started without delay.
> +		 */
> +		if (!c->cyclic) {
> +			struct omap_dmadev *d = to_omap_dma_dev(chan->device);
> +			spin_lock(&d->lock);
> +			if (list_empty(&c->node))
> +				list_add_tail(&c->node, &d->pending);
> +			spin_unlock(&d->lock);
> +			tasklet_schedule(&d->task);
> +		} else {
> +			omap_dma_start_desc(c);
> +		}
>  	}
>  	spin_unlock_irqrestore(&c->vc.lock, flags);
>  }
> -- 
> 1.8.1.5
> 
