Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab3BLRd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:33:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:28879 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329Ab3BLRdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:33:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290164004"
Date: Tue, 12 Feb 2013 09:08:44 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Matt Porter <mporter@ti.com>
Cc: Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] dmaengine: add dma_get_slave_sg_caps()
Message-ID: <20130212170844.GS3789@intel.com>
References: <1360007224-21735-1-git-send-email-mporter@ti.com>
 <1360007224-21735-2-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360007224-21735-2-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 02:47:02PM -0500, Matt Porter wrote:
> Add a dmaengine API to retrieve slave SG transfer capabilities.
> 
> The API is optionally implemented by dmaengine drivers and when
> unimplemented will return a NULL pointer. A client driver using
> this API provides the required dma channel, address width, and
> burst size of the transfer. dma_get_slave_sg_caps() returns an
> SG caps structure with the maximum number and size of SG segments
> that the given channel can handle.
Okay this sounds much better :-)

few points though:
- you added API for caps, but is actually calculating for given configuration
  the max allowed range. IMHO that is not caps, perhaps renaming to get_max_sg
  /some_better_name would be more apt.
- Still I like the idea of caps, but it should give H/W support capablity. If
  you want to add that, pls develop on same line...

--
~Vinod

> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  include/linux/dmaengine.h |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index d3201e4..5b5b220 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -371,6 +371,19 @@ struct dma_slave_config {
>  	unsigned int slave_id;
>  };
>  
> +/* struct dma_slave_sg_caps - expose SG transfer capability of a
> + * channel.
> + *
> + * @max_seg_nr: maximum number of SG segments supported on a SG/SLAVE
> + *	    channel (0 for no maximum or not a SG/SLAVE channel)
> + * @max_seg_len: maximum length of SG segments supported on a SG/SLAVE
> + *	     channel (0 for no maximum or not a SG/SLAVE channel)
> + */
> +struct dma_slave_sg_caps {
> +	u32 max_seg_nr;
> +	u32 max_seg_len;
> +};
> +
>  static inline const char *dma_chan_name(struct dma_chan *chan)
>  {
>  	return dev_name(&chan->dev->device);
> @@ -534,6 +547,7 @@ struct dma_tx_state {
>   *	struct with auxiliary transfer status information, otherwise the call
>   *	will just return a simple status code
>   * @device_issue_pending: push pending transactions to hardware
> + * @device_slave_sg_caps: return the slave SG capabilities
>   */
>  struct dma_device {
>  
> @@ -602,6 +616,9 @@ struct dma_device {
>  					    dma_cookie_t cookie,
>  					    struct dma_tx_state *txstate);
>  	void (*device_issue_pending)(struct dma_chan *chan);
> +	struct dma_slave_sg_caps *(*device_slave_sg_caps)(
> +		struct dma_chan *chan, enum dma_slave_buswidth addr_width,
> +		u32 maxburst);
>  };
>  
>  static inline int dmaengine_device_control(struct dma_chan *chan,
> @@ -969,6 +986,29 @@ dma_set_tx_state(struct dma_tx_state *st, dma_cookie_t last, dma_cookie_t used,
>  	}
>  }
>  
> +/**
> + * dma_get_slave_sg_caps - get DMAC SG transfer capabilities
> + * @chan: target DMA channel
> + * @addr_width: address width of the DMA transfer
> + * @maxburst: maximum DMA transfer burst size
> + *
> + * Get SG transfer capabilities for a specified channel. If the dmaengine
> + * driver does not implement SG transfer capabilities then NULL is
> + * returned.
> + */
> +static inline struct dma_slave_sg_caps
> +*dma_get_slave_sg_caps(struct dma_chan *chan,
> +		       enum dma_slave_buswidth addr_width,
> +		       u32 maxburst)
> +{
> +	if (chan->device->device_slave_sg_caps)
> +		return chan->device->device_slave_sg_caps(chan,
> +							  addr_width,
> +							  maxburst);
> +
> +	return NULL;
> +}
> +
>  enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  #ifdef CONFIG_DMA_ENGINE
>  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
> -- 
> 1.7.9.5
> 
