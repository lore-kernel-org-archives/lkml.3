Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab3JSBGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 21:06:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:3214 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387Ab3JSBGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 21:06:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,526,1378882800"; 
   d="scan'208";a="419224926"
Date: Fri, 18 Oct 2013 18:06:02 -0700
From: Jon Mason <jon.mason@intel.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, dave.jiang@intel.com,
        t.figa@samsung.com, kyungmin.park@samsung.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH v2 11/13] NTB: convert to dmaengine_unmap_data
Message-ID: <20131019010601.GH25432@jonmason-lab>
References: <1382117733-16720-1-git-send-email-b.zolnierkie@samsung.com>
 <1382117733-16720-12-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382117733-16720-12-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 07:35:31PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Use the generic unmap object to unmap dma buffers.
> 
> As NTB can be compiled without DMA_ENGINE support add

Seems like the stubs should be added outside of this patch.  Also, the
comment implies that NTB could not be compiled without DMA_ENGINE
support before, which it could be.

> stub functions to <linux/dmaengine.h> for dma_set_unmap(),
> dmaengine_get_unmap_data() and dmaengine_unmap_put().
> 
> Cc: Dan Williams <djbw@fb.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Jon Mason <jon.mason@intel.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/ntb/ntb_transport.c | 63 +++++++++++++++++++++++++++++++++------------
>  include/linux/dmaengine.h   | 15 +++++++++++
>  2 files changed, 61 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
> index 12a9e83..fc6bbf1 100644
> --- a/drivers/ntb/ntb_transport.c
> +++ b/drivers/ntb/ntb_transport.c
> @@ -1034,7 +1034,7 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
>  	struct dma_chan *chan = qp->dma_chan;
>  	struct dma_device *device;
>  	size_t pay_off, buff_off;
> -	dma_addr_t src, dest;
> +	struct dmaengine_unmap_data *unmap;
>  	dma_cookie_t cookie;
>  	void *buf = entry->buf;
>  	unsigned long flags;
> @@ -1054,27 +1054,41 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
>  	if (!is_dma_copy_aligned(device, pay_off, buff_off, len))
>  		goto err1;
>  
> -	dest = dma_map_single(device->dev, buf, len, DMA_FROM_DEVICE);
> -	if (dma_mapping_error(device->dev, dest))
> +	unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
> +	if (!unmap)
>  		goto err1;
>  
> -	src = dma_map_single(device->dev, offset, len, DMA_TO_DEVICE);
> -	if (dma_mapping_error(device->dev, src))
> +	unmap->addr[0] = dma_map_page(device->dev, virt_to_page(offset),
> +				      pay_off, len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(device->dev, unmap->addr[0]))
>  		goto err2;
>  
> -	flags = DMA_COMPL_DEST_UNMAP_SINGLE | DMA_COMPL_SRC_UNMAP_SINGLE |
> +	unmap->to_cnt = 1;
> +
> +	unmap->addr[1] = dma_map_page(device->dev, virt_to_page(buf),
> +				      buff_off, len, DMA_FROM_DEVICE);
> +	if (dma_mapping_error(device->dev, unmap->addr[1]))
> +		goto err2;
> +
> +	unmap->from_cnt = 1;
> +
> +	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
>  		DMA_PREP_INTERRUPT;
> -	txd = device->device_prep_dma_memcpy(chan, dest, src, len, flags);
> +	txd = device->device_prep_dma_memcpy(chan, unmap->addr[1],
> +					     unmap->addr[0], len, flags);

I must say, as a user I dislike this interface much less than the
previous.  Can we abstract all of this away in a helper function
that simply takes the src, dest, and len, then maps and calls
device_prep_dma_memcpy?  The driver does not keep track of the
dmaengine_unmap_data, so the helper function could simply return an
error if something isn't happy.  Thoughts?

Thanks,
Jon

>  	if (!txd)
> -		goto err3;
> +		goto err2;
>  
>  	txd->callback = ntb_rx_copy_callback;
>  	txd->callback_param = entry;
> +	dma_set_unmap(txd, unmap);
>  
>  	cookie = dmaengine_submit(txd);
>  	if (dma_submit_error(cookie))
>  		goto err3;
>  
> +	dmaengine_unmap_put(unmap);
> +
>  	qp->last_cookie = cookie;
>  
>  	qp->rx_async++;
> @@ -1082,9 +1096,9 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
>  	return;
>  
>  err3:
> -	dma_unmap_single(device->dev, src, len, DMA_TO_DEVICE);
> +	dmaengine_unmap_put(unmap);
>  err2:
> -	dma_unmap_single(device->dev, dest, len, DMA_FROM_DEVICE);
> +	dmaengine_unmap_put(unmap);
>  err1:
>  	/* If the callbacks come out of order, the writing of the index to the
>  	 * last completed will be out of order.  This may result in the
> @@ -1245,7 +1259,8 @@ static void ntb_async_tx(struct ntb_transport_qp *qp,
>  	struct dma_chan *chan = qp->dma_chan;
>  	struct dma_device *device;
>  	size_t dest_off, buff_off;
> -	dma_addr_t src, dest;
> +	struct dmaengine_unmap_data *unmap;
> +	dma_addr_t dest;
>  	dma_cookie_t cookie;
>  	void __iomem *offset;
>  	size_t len = entry->len;
> @@ -1273,28 +1288,42 @@ static void ntb_async_tx(struct ntb_transport_qp *qp,
>  	if (!is_dma_copy_aligned(device, buff_off, dest_off, len))
>  		goto err;
>  
> -	src = dma_map_single(device->dev, buf, len, DMA_TO_DEVICE);
> -	if (dma_mapping_error(device->dev, src))
> +	unmap = dmaengine_get_unmap_data(device->dev, 1, GFP_NOIO);
> +	if (!unmap)
>  		goto err;
>  
> -	flags = DMA_COMPL_SRC_UNMAP_SINGLE | DMA_PREP_INTERRUPT;
> -	txd = device->device_prep_dma_memcpy(chan, dest, src, len, flags);
> +	unmap->addr[0] = dma_map_page(device->dev, virt_to_page(buf),
> +				      buff_off, len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(device->dev, unmap->addr[0]))
> +		goto err1;
> +
> +	unmap->to_cnt = 1;
> +
> +	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
> +		DMA_PREP_INTERRUPT;
> +	txd = device->device_prep_dma_memcpy(chan, dest, unmap->addr[0], len,
> +					    flags);
>  	if (!txd)
>  		goto err1;
>  
>  	txd->callback = ntb_tx_copy_callback;
>  	txd->callback_param = entry;
> +	dma_set_unmap(txd, unmap);
>  
>  	cookie = dmaengine_submit(txd);
>  	if (dma_submit_error(cookie))
> -		goto err1;
> +		goto err2;
> +
> +	dmaengine_unmap_put(unmap);
>  
>  	dma_async_issue_pending(chan);
>  	qp->tx_async++;
>  
>  	return;
> +err2:
> +	dmaengine_unmap_put(unmap);
>  err1:
> -	dma_unmap_single(device->dev, src, len, DMA_TO_DEVICE);
> +	dmaengine_unmap_put(unmap);
>  err:
>  	ntb_memcpy_tx(entry, offset);
>  	qp->tx_memcpy++;
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index dc98bc5..3782cdb 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -457,6 +457,7 @@ struct dma_async_tx_descriptor {
>  #endif
>  };
>  
> +#ifdef CONFIG_DMA_ENGINE
>  static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
>  				 struct dmaengine_unmap_data *unmap)
>  {
> @@ -467,6 +468,20 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
>  struct dmaengine_unmap_data *
>  dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
>  void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
> +#else
> +static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
> +				 struct dmaengine_unmap_data *unmap)
> +{
> +}
> +static inline struct dmaengine_unmap_data *
> +dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
> +{
> +	return NULL;
> +}
> +static inline void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap)
> +{
> +}
> +#endif
>  
>  static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)
>  {
> -- 
> 1.8.2.3
> 
