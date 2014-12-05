Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaLEO0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:26:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:18652 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaLEO0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:26:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="619216258"
Date: Fri, 5 Dec 2014 19:57:02 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de
Subject: Re: [PATCH v5 34/61] dmaengine: omap: Split device_control
Message-ID: <20141205142702.GF3411@intel.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
 <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:42:28PM +0100, Maxime Ripard wrote:
> Split the device_control callback of the TI OMAP DMA driver to make use
> of the newly introduced callbacks, that will eventually be used to retrieve
> slave capabilities.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/dma/omap-dma.c | 51 +++++++++++++++-----------------------------------
>  1 file changed, 15 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
> index a8aa5b6bb5e2..1cadf812f3b3 100644
> --- a/drivers/dma/omap-dma.c
> +++ b/drivers/dma/omap-dma.c
> @@ -948,8 +948,10 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
>  	return vchan_tx_prep(&c->vc, &d->vd, flags);
>  }
>  
> -static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave_config *cfg)
> +static int omap_dma_slave_config(struct dma_chan *chan, struct dma_slave_config *cfg)
>  {
> +	struct omap_chan *c = to_omap_dma_chan(chan);
> +
>  	if (cfg->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
>  	    cfg->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
>  		return -EINVAL;
> @@ -959,8 +961,9 @@ static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave_config *c
>  	return 0;
>  }
>  
> -static int omap_dma_terminate_all(struct omap_chan *c)
> +static int omap_dma_terminate_all(struct dma_chan *chan)
>  {
> +	struct omap_chan *c = to_omap_dma_chan(chan);
>  	struct omap_dmadev *d = to_omap_dma_dev(c->vc.chan.device);
>  	unsigned long flags;
>  	LIST_HEAD(head);
> @@ -996,8 +999,10 @@ static int omap_dma_terminate_all(struct omap_chan *c)
>  	return 0;
>  }
>  
> -static int omap_dma_pause(struct omap_chan *c)
> +static int omap_dma_pause(struct dma_chan *chan)
>  {
> +	struct omap_chan *c = to_omap_dma_chan(chan);
> +
>  	/* Pause/Resume only allowed with cyclic mode */
>  	if (!c->cyclic)
>  		return -EINVAL;
> @@ -1010,8 +1015,10 @@ static int omap_dma_pause(struct omap_chan *c)
>  	return 0;
>  }
>  
> -static int omap_dma_resume(struct omap_chan *c)
> +static int omap_dma_resume(struct dma_chan *chan)
>  {
> +	struct omap_chan *c = to_omap_dma_chan(chan);
> +
>  	/* Pause/Resume only allowed with cyclic mode */
>  	if (!c->cyclic)
>  		return -EINVAL;
> @@ -1029,37 +1036,6 @@ static int omap_dma_resume(struct omap_chan *c)
>  	return 0;
>  }
>  
> -static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> -	unsigned long arg)
> -{
> -	struct omap_chan *c = to_omap_dma_chan(chan);
> -	int ret;
> -
> -	switch (cmd) {
> -	case DMA_SLAVE_CONFIG:
> -		ret = omap_dma_slave_config(c, (struct dma_slave_config *)arg);
> -		break;
> -
> -	case DMA_TERMINATE_ALL:
> -		ret = omap_dma_terminate_all(c);
> -		break;
> -
> -	case DMA_PAUSE:
> -		ret = omap_dma_pause(c);
> -		break;
> -
> -	case DMA_RESUME:
> -		ret = omap_dma_resume(c);
> -		break;
> -
> -	default:
> -		ret = -ENXIO;
> -		break;
> -	}
> -
> -	return ret;
> -}
> -
>  static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
>  {
>  	struct omap_chan *c;
> @@ -1136,7 +1112,10 @@ static int omap_dma_probe(struct platform_device *pdev)
>  	od->ddev.device_issue_pending = omap_dma_issue_pending;
>  	od->ddev.device_prep_slave_sg = omap_dma_prep_slave_sg;
>  	od->ddev.device_prep_dma_cyclic = omap_dma_prep_dma_cyclic;
> -	od->ddev.device_control = omap_dma_control;
this should be assigned to omap_dma_slave_config. omap_dma_control is not
here :(

-- 
~Vinod

> +	od->ddev.device_config = omap_dma_config;
> +	od->ddev.device_pause = omap_dma_pause;
> +	od->ddev.device_resume = omap_dma_resume;
> +	od->ddev.device_terminate_all = omap_dma_terminate_all;
>  	od->ddev.device_slave_caps = omap_dma_device_slave_caps;
>  	od->ddev.dev = &pdev->dev;
>  	INIT_LIST_HEAD(&od->ddev.channels);
> -- 
> 2.1.1
> 

-- 
