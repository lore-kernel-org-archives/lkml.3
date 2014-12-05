Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLEQiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:38:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:38016 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaLEQiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:38:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="633328472"
Date: Fri, 5 Dec 2014 22:09:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Robin Gong <b38343@freescale.com>
Cc: dan.j.williams@intel.com, andriy.shevchenko@linux.jf.intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] dma: imx-sdma: add support for sdma memory copy
Message-ID: <20141205163918.GO3411@intel.com>
References: <1414030940-15516-1-git-send-email-b38343@freescale.com>
 <1414030940-15516-2-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414030940-15516-2-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:22:18AM +0800, Robin Gong wrote:
 
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
why is this dependent on status. You can prepare a descriptor here!
> +
> +	if (len >= NUM_BD * SDMA_BD_MAX_CNT) {
> +		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%d > %d\n",
> +			channel, len, NUM_BD * SDMA_BD_MAX_CNT);
> +		goto err_out;
> +	}
> +
> +	sdmac->status = DMA_IN_PROGRESS;
??

> +
> +	sdmac->buf_tail = 0;
> +
> +	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
> +		dma_src, dma_dst, len, channel);
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
So are you dependent of dma_slave_config to be set. Then it is wrong. for
memcpy you shoudn't be!

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
this doesn't seem to have anything to do with memcpy, shouldn't this be
independent change here?

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
> +				i, count, sg_src->dma_address,
>  				param & BD_WRAP ? "wrap" : "",
>  				param & BD_INTR ? " intr" : "");
ditto

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
you should have done this first and then added memcpy

-- 
~Vinod

