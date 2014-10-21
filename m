Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaJUJfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:35:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:6223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaJUJfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,761,1406617200"; 
   d="scan'208";a="617761688"
Message-ID: <1413884128.2396.21.camel@linux.intel.com>
Subject: Re: [PATCH v4 1/3] dma: imx-sdma: add support for sdma memory copy
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Robin Gong <b38343@freescale.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 12:35:28 +0300
In-Reply-To: <1413853781-18384-2-git-send-email-b38343@freescale.com>
References: <1413853781-18384-1-git-send-email-b38343@freescale.com>
	 <1413853781-18384-2-git-send-email-b38343@freescale.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 09:09 +0800, Robin Gong wrote:

Few words as commit message?

> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  drivers/dma/imx-sdma.c | 188 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 164 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index f7626e3..fc4a0df 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -229,6 +229,7 @@ struct sdma_context_data {
>  } __attribute__ ((packed));
>  
>  #define NUM_BD (int)(PAGE_SIZE / sizeof(struct sdma_buffer_descriptor))
> +#define SDMA_BD_MAX_CNT	(0xfffc) /* align with 4 bytes */

Do you need parentheses?

>  
>  struct sdma_engine;
>  
> @@ -261,6 +262,7 @@ struct sdma_channel {
>  	unsigned int			pc_from_device, pc_to_device;
>  	unsigned long			flags;
>  	dma_addr_t			per_address;
> +	unsigned int                    pc_to_pc;
>  	unsigned long			event_mask[2];
>  	unsigned long			watermark_level;
>  	u32				shp_addr, per_addr;
> @@ -701,6 +703,7 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
>  
>  	sdmac->pc_from_device = 0;
>  	sdmac->pc_to_device = 0;
> +	sdmac->pc_to_pc = 0;
>  
>  	switch (peripheral_type) {
>  	case IMX_DMATYPE_MEMORY:
> @@ -775,6 +778,7 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
>  
>  	sdmac->pc_from_device = per_2_emi;
>  	sdmac->pc_to_device = emi_2_per;
> +	sdmac->pc_to_pc = emi_2_emi;
>  }
>  
>  static int sdma_load_context(struct sdma_channel *sdmac)
> @@ -787,11 +791,12 @@ static int sdma_load_context(struct sdma_channel *sdmac)
>  	int ret;
>  	unsigned long flags;
>  
> -	if (sdmac->direction == DMA_DEV_TO_MEM) {
> +	if (sdmac->direction == DMA_DEV_TO_MEM)
>  		load_address = sdmac->pc_from_device;
> -	} else {
> +	else if (sdmac->direction == DMA_MEM_TO_MEM)
> +		load_address = sdmac->pc_to_pc;
> +	else
>  		load_address = sdmac->pc_to_device;
> -	}
>  
>  	if (load_address < 0)
>  		return load_address;
> @@ -1021,16 +1026,118 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
>  	clk_disable(sdma->clk_ahb);
>  }
>  
> -static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
> -		struct dma_chan *chan, struct scatterlist *sgl,
> -		unsigned int sg_len, enum dma_transfer_direction direction,
> -		unsigned long flags, void *context)
> +static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> +		struct dma_chan *chan, dma_addr_t dma_dst,
> +		dma_addr_t dma_src, size_t len, unsigned long flags)
> +{
> +	struct sdma_channel *sdmac = to_sdma_chan(chan);
> +	struct sdma_engine *sdma = sdmac->sdma;
> +	int channel = sdmac->channel;
> +	size_t count;
> +	int i = 0, param, ret;
> +	struct sdma_buffer_descriptor *bd;
> +
> +	if (!chan || !len || sdmac->status == DMA_IN_PROGRESS)
> +		return NULL;
> +
> +	if (len >= NUM_BD * SDMA_BD_MAX_CNT) {
> +		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%d > %d\n"
> +			, channel, len, NUM_BD * SDMA_BD_MAX_CNT);

I believe  comma is a part of previous line.

Have you run checkpatch.pl?

> +		goto err_out;
> +	}
> +
> +	sdmac->status = DMA_IN_PROGRESS;
> +
> +	sdmac->buf_tail = 0;
> +
> +	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
> +		dma_src, dma_dst, len, channel);

Please, %pad for DMA addresses here and later on.

> +
> +	sdmac->direction = DMA_MEM_TO_MEM;
> +
> +	ret = sdma_load_context(sdmac);
> +	if (ret)
> +		goto err_out;
> +
> +	sdmac->chn_count = 0;
> +
> +	do {
> +		count = min_t(size_t, len, SDMA_BD_MAX_CNT);
> +		bd = &sdmac->bd[i];
> +		bd->buffer_addr = dma_src;
> +		bd->ext_buffer_addr = dma_dst;
> +		bd->mode.count = count;
> +
> +		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES) {
> +			ret =  -EINVAL;
> +			goto err_out;
> +		}
> +
> +		switch (sdmac->word_size) {
> +		case DMA_SLAVE_BUSWIDTH_4_BYTES:
> +			bd->mode.command = 0;
> +			if ((count | dma_dst | dma_src) & 3)
> +				return NULL;
> +			break;
> +		case DMA_SLAVE_BUSWIDTH_2_BYTES:
> +			bd->mode.command = 2;
> +			if ((count | dma_dst | dma_src) & 1)
> +				return NULL;
> +			break;
> +		case DMA_SLAVE_BUSWIDTH_1_BYTE:
> +			bd->mode.command = 1;
> +			break;
> +		default:
> +			return NULL;
> +		}
> +
> +		dma_src += count;
> +		dma_dst += count;
> +		len -= count;
> +		i++;
> +
> +		param = BD_DONE | BD_EXTD | BD_CONT;
> +		/* last bd */
> +		if (!len) {
> +			param |= BD_INTR;
> +			param |= BD_LAST;
> +			param &= ~BD_CONT;
> +		}
> +
> +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",

%pad ?

> +				i, count, bd->buffer_addr,
> +				param & BD_WRAP ? "wrap" : "",
> +				param & BD_INTR ? " intr" : "");
> +
> +		bd->mode.status = param;
> +		sdmac->chn_count += count;
> +	} while (len);
> +
> +	sdmac->num_bd = i;
> +	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
> +
> +	return &sdmac->desc;
> +err_out:
> +	sdmac->status = DMA_ERROR;
> +	return NULL;
> +}
> +
> +/*
> + * Please ensure dst_nents no smaller than src_nents , also every sg_len of
> + * dst_sg node no smaller than src_sg. To simply things, please use the same
> + * size of dst_sg as src_sg.
> + */
> +static struct dma_async_tx_descriptor *sdma_prep_sg(
> +		struct dma_chan *chan,
> +		struct scatterlist *dst_sg, unsigned int dst_nents,
> +		struct scatterlist *src_sg, unsigned int src_nents,
> +		enum dma_transfer_direction direction)
>  {
>  	struct sdma_channel *sdmac = to_sdma_chan(chan);
>  	struct sdma_engine *sdma = sdmac->sdma;
>  	int ret, i, count;
>  	int channel = sdmac->channel;
> -	struct scatterlist *sg;
> +	struct scatterlist *sg_src = src_sg, *sg_dst = dst_sg;
>  
>  	if (sdmac->status == DMA_IN_PROGRESS)
>  		return NULL;
> @@ -1041,32 +1148,38 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
>  	sdmac->buf_tail = 0;
>  
>  	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
> -			sg_len, channel);
> +			src_nents, channel);
>  
>  	sdmac->direction = direction;
> +
>  	ret = sdma_load_context(sdmac);
>  	if (ret)
>  		goto err_out;
>  
> -	if (sg_len > NUM_BD) {
> +	if (src_nents > NUM_BD) {
>  		dev_err(sdma->dev, "SDMA channel %d: maximum number of sg exceeded: %d > %d\n",
> -				channel, sg_len, NUM_BD);
> +				channel, src_nents, NUM_BD);
>  		ret = -EINVAL;
>  		goto err_out;
>  	}
>  
>  	sdmac->chn_count = 0;
> -	for_each_sg(sgl, sg, sg_len, i) {
> +	for_each_sg(src_sg, sg_src, src_nents, i) {
>  		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
>  		int param;
>  
> -		bd->buffer_addr = sg->dma_address;
> +		bd->buffer_addr = sg_src->dma_address;
> +
> +		if (direction == DMA_MEM_TO_MEM) {
> +			BUG_ON(!sg_dst);
> +			bd->ext_buffer_addr = sg_dst->dma_address;
> +		}
>  
> -		count = sg_dma_len(sg);
> +		count = sg_dma_len(sg_src);
>  
> -		if (count > 0xffff) {
> +		if (count > SDMA_BD_MAX_CNT) {
>  			dev_err(sdma->dev, "SDMA channel %d: maximum bytes for sg entry exceeded: %d > %d\n",
> -					channel, count, 0xffff);
> +					channel, count, SDMA_BD_MAX_CNT);
>  			ret = -EINVAL;
>  			goto err_out;
>  		}
> @@ -1082,12 +1195,14 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
>  		switch (sdmac->word_size) {
>  		case DMA_SLAVE_BUSWIDTH_4_BYTES:
>  			bd->mode.command = 0;
> -			if (count & 3 || sg->dma_address & 3)
> +			if ((count | sg_src->dma_address | (sg_dst &&
> +				(sg_dst->dma_address))) & 3)
>  				return NULL;
>  			break;
>  		case DMA_SLAVE_BUSWIDTH_2_BYTES:
>  			bd->mode.command = 2;
> -			if (count & 1 || sg->dma_address & 1)
> +			if ((count | sg_src->dma_address |
> +				(sg_dst && (sg_dst->dma_address))) & 1)
>  				return NULL;
>  			break;
>  		case DMA_SLAVE_BUSWIDTH_1_BYTE:
> @@ -1099,21 +1214,23 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
>  
>  		param = BD_DONE | BD_EXTD | BD_CONT;
>  
> -		if (i + 1 == sg_len) {
> +		if (i + 1 == src_nents) {
>  			param |= BD_INTR;
>  			param |= BD_LAST;
>  			param &= ~BD_CONT;
>  		}
>  
> -		dev_dbg(sdma->dev, "entry %d: count: %d dma: %#llx %s%s\n",
> -				i, count, (u64)sg->dma_address,
> +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",

%pad ?

> +				i, count, sg_src->dma_address,
>  				param & BD_WRAP ? "wrap" : "",
>  				param & BD_INTR ? " intr" : "");
>  
>  		bd->mode.status = param;
> +		if (direction == DMA_MEM_TO_MEM)
> +			sg_dst = sg_next(sg_dst);
>  	}
>  
> -	sdmac->num_bd = sg_len;
> +	sdmac->num_bd = src_nents;
>  	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
>  
>  	return &sdmac->desc;
> @@ -1122,6 +1239,24 @@ err_out:
>  	return NULL;
>  }
>  
> +static struct dma_async_tx_descriptor *sdma_prep_memcpy_sg(
> +		struct dma_chan *chan,
> +		struct scatterlist *dst_sg, unsigned int dst_nents,
> +		struct scatterlist *src_sg, unsigned int src_nents,
> +		unsigned long flags)
> +{
> +	return sdma_prep_sg(chan, dst_sg, dst_nents, src_sg, src_nents,
> +			   DMA_MEM_TO_MEM);
> +}
> +
> +static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
> +		struct dma_chan *chan, struct scatterlist *sgl,
> +		unsigned int sg_len, enum dma_transfer_direction direction,
> +		unsigned long flags, void *context)
> +{
> +	return sdma_prep_sg(chan, NULL, 0, sgl, sg_len, direction);
> +}
> +
>  static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
>  		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
>  		size_t period_len, enum dma_transfer_direction direction,
> @@ -1155,9 +1290,9 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
>  		goto err_out;
>  	}
>  
> -	if (period_len > 0xffff) {
> +	if (period_len > SDMA_BD_MAX_CNT) {
>  		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %d > %d\n",
> -				channel, period_len, 0xffff);
> +				channel, period_len, SDMA_BD_MAX_CNT);
>  		goto err_out;
>  	}
>  
> @@ -1218,6 +1353,8 @@ static int sdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  			sdmac->watermark_level = dmaengine_cfg->src_maxburst *
>  						dmaengine_cfg->src_addr_width;
>  			sdmac->word_size = dmaengine_cfg->src_addr_width;
> +		} else if (dmaengine_cfg->direction == DMA_MEM_TO_MEM) {
> +			sdmac->word_size = dmaengine_cfg->dst_addr_width;
>  		} else {
>  			sdmac->per_address = dmaengine_cfg->dst_addr;
>  			sdmac->watermark_level = dmaengine_cfg->dst_maxburst *
> @@ -1536,6 +1673,7 @@ static int __init sdma_probe(struct platform_device *pdev)
>  
>  	dma_cap_set(DMA_SLAVE, sdma->dma_device.cap_mask);
>  	dma_cap_set(DMA_CYCLIC, sdma->dma_device.cap_mask);
> +	dma_cap_set(DMA_MEMCPY, sdma->dma_device.cap_mask);
>  
>  	INIT_LIST_HEAD(&sdma->dma_device.channels);
>  	/* Initialize channel parameters */
> @@ -1598,6 +1736,8 @@ static int __init sdma_probe(struct platform_device *pdev)
>  	sdma->dma_device.device_tx_status = sdma_tx_status;
>  	sdma->dma_device.device_prep_slave_sg = sdma_prep_slave_sg;
>  	sdma->dma_device.device_prep_dma_cyclic = sdma_prep_dma_cyclic;
> +	sdma->dma_device.device_prep_dma_memcpy = sdma_prep_memcpy;
> +	sdma->dma_device.device_prep_dma_sg = sdma_prep_memcpy_sg;
>  	sdma->dma_device.device_control = sdma_control;
>  	sdma->dma_device.device_issue_pending = sdma_issue_pending;
>  	sdma->dma_device.dev->dma_parms = &sdma->dma_parms;


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

