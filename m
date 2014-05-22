Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaEVCH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:07:26 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:1151
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750965AbaEVCHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:07:25 -0400
Date: Thu, 22 May 2014 10:13:21 +0800
From: Robin Gong <b38343@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andriy.shevchenko@linux.jf.intel.com>
Subject: Re: [PATCH v3] dma: imx-sdma: add support for sdma memory copy
Message-ID: <20140522021318.GA3997@Robin-OptiPlex-780>
References: <1399342368-15217-1-git-send-email-b38343@freescale.com>
 <20140521105652.GO21128@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140521105652.GO21128@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(199002)(189002)(51704005)(76482001)(46406003)(77982001)(74502001)(81542001)(31966008)(81342001)(74662001)(83322001)(33656002)(6806004)(19580395003)(87936001)(44976005)(19580405001)(50466002)(83072002)(26826002)(85852003)(77096999)(92566001)(92726001)(79102001)(54356999)(76176999)(47776003)(20776003)(23726002)(102836001)(99396002)(97756001)(83506001)(4396001)(46102001)(33716001)(80022001)(21056001)(64706001)(50986999)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB479;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 021975AE46
Authentication-Results: spf=fail (sender IP is 192.88.158.246)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 04:26:52PM +0530, Vinod Koul wrote:
> On Tue, May 06, 2014 at 10:12:48AM +0800, Robin Gong wrote:
> > add "device_prep_dma_memcpy" and "device_prep_dma_sg" for memory copy by sdma.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > 
> > ---
> > change:
> > --v3:
> >   1. remove redundant check for bus width
> > 
> > --v2:
> >   1. correct some printk format, such as %pad for dma_addr_t
> >   2. split duplicated code in prep_dma_memcpy and prep_dma_sg to make code clean.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  drivers/dma/imx-sdma.c |  250 ++++++++++++++++++++++++++++++++++++-----------
> >  1 files changed, 191 insertions(+), 59 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index 4e79183..9abc164 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -229,6 +229,7 @@ struct sdma_context_data {
> >  } __attribute__ ((packed));
> >  
> >  #define NUM_BD (int)(PAGE_SIZE / sizeof(struct sdma_buffer_descriptor))
> > +#define SDMA_BD_MAX_CNT	(0xfffc) /* align with 4 bytes */
> >  
> >  struct sdma_engine;
> >  
> > @@ -260,6 +261,7 @@ struct sdma_channel {
> >  	unsigned int			pc_from_device, pc_to_device;
> >  	unsigned long			flags;
> >  	dma_addr_t			per_address;
> > +	unsigned int                    pc_to_pc;
> >  	unsigned long			event_mask[2];
> >  	unsigned long			watermark_level;
> >  	u32				shp_addr, per_addr;
> > @@ -694,6 +696,7 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
> >  
> >  	sdmac->pc_from_device = 0;
> >  	sdmac->pc_to_device = 0;
> > +	sdmac->pc_to_pc = 0;
> >  
> >  	switch (peripheral_type) {
> >  	case IMX_DMATYPE_MEMORY:
> > @@ -763,6 +766,7 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
> >  
> >  	sdmac->pc_from_device = per_2_emi;
> >  	sdmac->pc_to_device = emi_2_per;
> > +	sdmac->pc_to_pc = emi_2_emi;
> >  }
> >  
> >  static int sdma_load_context(struct sdma_channel *sdmac)
> > @@ -775,11 +779,12 @@ static int sdma_load_context(struct sdma_channel *sdmac)
> >  	int ret;
> >  	unsigned long flags;
> >  
> > -	if (sdmac->direction == DMA_DEV_TO_MEM) {
> > +	if (sdmac->direction == DMA_DEV_TO_MEM)
> >  		load_address = sdmac->pc_from_device;
> > -	} else {
> > +	else if (sdmac->direction == DMA_MEM_TO_MEM)
> > +		load_address = sdmac->pc_to_pc;
> > +	else
> else is not proper here as enum defines one more field. So else-if would be apt.
> 
I only keep the same logic as before here...but I agree with you, will split it into
another patch.

> >  		load_address = sdmac->pc_to_device;
> > -	}
> >  
> >  	if (load_address < 0)
> >  		return load_address;
> > @@ -1010,99 +1015,203 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
> >  	clk_disable(sdma->clk_ahb);
> >  }
> >  
> > -static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
> > -		struct dma_chan *chan, struct scatterlist *sgl,
> > -		unsigned int sg_len, enum dma_transfer_direction direction,
> > -		unsigned long flags, void *context)
> > +static int sdma_transfer_init(struct sdma_channel *sdmac,
> > +			      enum dma_transfer_direction direction)
> > +{
> > +	int ret = 0;
> > +
> > +	sdmac->status = DMA_IN_PROGRESS;
> > +	sdmac->buf_tail = 0;
> > +	sdmac->flags = 0;
> > +	sdmac->direction = direction;
> > +
> > +	ret = sdma_load_context(sdmac);
> > +	if (ret)
> > +		return ret;
> > +
> > +	sdmac->chn_count = 0;
> > +
> > +	return ret;
> > +}
> > +
> > +static int check_bd_buswidth(struct sdma_buffer_descriptor *bd,
> > +			     struct sdma_channel *sdmac, int count,
> > +			     dma_addr_t dma_dst, dma_addr_t dma_src)
> > +{
> > +	int ret = 0;
> > +
> > +	switch (sdmac->word_size) {
> > +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> > +		bd->mode.command = 0;
> > +		if ((count | dma_dst | dma_src) & 3)
> > +			ret = -EINVAL;
> > +		break;
> > +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> > +		bd->mode.command = 2;
> > +		if ((count | dma_dst | dma_src) & 1)
> > +			ret = -EINVAL;
> > +		break;
> > +	case DMA_SLAVE_BUSWIDTH_1_BYTE:
> > +		bd->mode.command = 1;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> This looks like a code reorg change, perhpas another patch?
>
 ok, will split it into another patch.
> > +
> > +static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> > +		struct dma_chan *chan, dma_addr_t dma_dst,
> > +		dma_addr_t dma_src, size_t len, unsigned long flags)
> >  {
> >  	struct sdma_channel *sdmac = to_sdma_chan(chan);
> >  	struct sdma_engine *sdma = sdmac->sdma;
> > -	int ret, i, count;
> >  	int channel = sdmac->channel;
> > -	struct scatterlist *sg;
> > +	size_t count;
> > +	int i = 0, param;
> > +	struct sdma_buffer_descriptor *bd;
> >  
> > -	if (sdmac->status == DMA_IN_PROGRESS)
> > +	if (!chan || !len || sdmac->status == DMA_IN_PROGRESS)
> >  		return NULL;
> > -	sdmac->status = DMA_IN_PROGRESS;
> >  
> > -	sdmac->flags = 0;
> > -
> > -	sdmac->buf_tail = 0;
> > +	if (len >= NUM_BD * SDMA_BD_MAX_CNT) {
> > +		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%zu > %d\n"
> > +			, channel, len, NUM_BD * SDMA_BD_MAX_CNT);
> > +		goto err_out;
> > +	}
> >  
> > -	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
> > -			sg_len, channel);
> > +	dev_dbg(sdma->dev, "memcpy: %pad->%pad, len=%zu, channel=%d.\n",
> > +		&dma_src, &dma_dst, len, channel);
> >  
> > -	sdmac->direction = direction;
> > -	ret = sdma_load_context(sdmac);
> > -	if (ret)
> > +	if (sdma_transfer_init(sdmac, DMA_MEM_TO_MEM))
> >  		goto err_out;
> >  
> > -	if (sg_len > NUM_BD) {
> > +	do {
> > +		count = min_t(size_t, len, SDMA_BD_MAX_CNT);
> > +		bd = &sdmac->bd[i];
> > +		bd->buffer_addr = dma_src;
> > +		bd->ext_buffer_addr = dma_dst;
> > +		bd->mode.count = count;
> > +
> > +		if (check_bd_buswidth(bd, sdmac, count, dma_dst, dma_src))
> > +			goto err_out;
> > +
> > +		dma_src += count;
> > +		dma_dst += count;
> > +		len -= count;
> > +		i++;
> > +
> > +		param = BD_DONE | BD_EXTD | BD_CONT;
> > +		/* last bd */
> > +		if (!len) {
> > +			param |= BD_INTR;
> > +			param |= BD_LAST;
> > +			param &= ~BD_CONT;
> > +		}
> > +
> > +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%u %s%s\n",
> > +				i, count, bd->buffer_addr,
> > +				param & BD_WRAP ? "wrap" : "",
> > +				param & BD_INTR ? " intr" : "");
> > +
> > +		bd->mode.status = param;
> > +		sdmac->chn_count += count;
> > +	} while (len);
> > +
> > +	sdmac->num_bd = i;
> > +	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
> > +
> > +	return &sdmac->desc;
> > +err_out:
> > +	sdmac->status = DMA_ERROR;
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * Please ensure dst_nents no smaller than src_nents , also every sg_len of
> > + * dst_sg node no smaller than src_sg. To simply things, please use the same
> > + * size of dst_sg as src_sg.
> > + */
> > +static struct dma_async_tx_descriptor *sdma_prep_sg(
> > +		struct dma_chan *chan,
> > +		struct scatterlist *dst_sg, unsigned int dst_nents,
> > +		struct scatterlist *src_sg, unsigned int src_nents,
> > +		enum dma_transfer_direction direction)
> > +{
> > +	struct sdma_channel *sdmac = to_sdma_chan(chan);
> > +	struct sdma_engine *sdma = sdmac->sdma;
> > +	int ret, i, count;
> > +	int channel = sdmac->channel;
> > +	struct scatterlist *sg_src = src_sg, *sg_dst = dst_sg;
> > +
> > +	if (sdmac->status == DMA_IN_PROGRESS)
> > +		return NULL;
> > +
> > +	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
> > +			src_nents, channel);
> > +
> > +	if (src_nents > NUM_BD) {
> >  		dev_err(sdma->dev, "SDMA channel %d: maximum number of sg exceeded: %d > %d\n",
> > -				channel, sg_len, NUM_BD);
> > -		ret = -EINVAL;
> > +				channel, src_nents, NUM_BD);
> >  		goto err_out;
> >  	}
> >  
> > -	sdmac->chn_count = 0;
> > -	for_each_sg(sgl, sg, sg_len, i) {
> > +	if (sdma_transfer_init(sdmac, direction))
> > +		goto err_out;
> > +
> > +	for_each_sg(src_sg, sg_src, src_nents, i) {
> >  		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
> >  		int param;
> >  
> > -		bd->buffer_addr = sg->dma_address;
> > +		bd->buffer_addr = sg_src->dma_address;
> >  
> > -		count = sg_dma_len(sg);
> > +		if (direction == DMA_MEM_TO_MEM) {
> > +			BUG_ON(!sg_dst);
> why should this be direction specfic?
> 
we only need use ext_buffer_addr in case of MEM_TO_MEM.
> > +			bd->ext_buffer_addr = sg_dst->dma_address;
> > +		}
> > +
> > +		count = sg_dma_len(sg_src);
> >  
> > -		if (count > 0xffff) {
> > +		if (count > SDMA_BD_MAX_CNT) {
> >  			dev_err(sdma->dev, "SDMA channel %d: maximum bytes for sg entry exceeded: %d > %d\n",
> > -					channel, count, 0xffff);
> > -			ret = -EINVAL;
> > +					channel, count, SDMA_BD_MAX_CNT);
> >  			goto err_out;
> >  		}
> >  
> >  		bd->mode.count = count;
> >  		sdmac->chn_count += count;
> >  
> > -		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES) {
> > -			ret =  -EINVAL;
> > -			goto err_out;
> > -		}
> > +		if (direction == DMA_MEM_TO_MEM)
> > +			ret = check_bd_buswidth(bd, sdmac, count,
> > +						sg_dst->dma_address,
> > +						sg_src->dma_address);
> > +		else
> > +			ret = check_bd_buswidth(bd, sdmac, count, 0,
> > +						sg_src->dma_address);
> >  
> > -		switch (sdmac->word_size) {
> > -		case DMA_SLAVE_BUSWIDTH_4_BYTES:
> > -			bd->mode.command = 0;
> > -			if (count & 3 || sg->dma_address & 3)
> > -				return NULL;
> > -			break;
> > -		case DMA_SLAVE_BUSWIDTH_2_BYTES:
> > -			bd->mode.command = 2;
> > -			if (count & 1 || sg->dma_address & 1)
> > -				return NULL;
> > -			break;
> > -		case DMA_SLAVE_BUSWIDTH_1_BYTE:
> > -			bd->mode.command = 1;
> > -			break;
> > -		default:
> > -			return NULL;
> > -		}
> > +		if (ret)
> > +			goto err_out;
> >  
> >  		param = BD_DONE | BD_EXTD | BD_CONT;
> >  
> > -		if (i + 1 == sg_len) {
> > +		if (i + 1 == src_nents) {
> >  			param |= BD_INTR;
> >  			param |= BD_LAST;
> >  			param &= ~BD_CONT;
> >  		}
> >  
> > -		dev_dbg(sdma->dev, "entry %d: count: %d dma: %#llx %s%s\n",
> > -				i, count, (u64)sg->dma_address,
> > +		dev_dbg(sdma->dev, "entry %d: count: %d dma: %pad %s%s\n",
> > +				i, count, &sg_src->dma_address,
> >  				param & BD_WRAP ? "wrap" : "",
> >  				param & BD_INTR ? " intr" : "");
> >  
> >  		bd->mode.status = param;
> > +		if (direction == DMA_MEM_TO_MEM)
> > +			sg_dst = sg_next(sg_dst);
> >  	}
> >  
> > -	sdmac->num_bd = sg_len;
> > +	sdmac->num_bd = src_nents;
> >  	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
> >  
> >  	return &sdmac->desc;
> > @@ -1111,6 +1220,24 @@ err_out:
> >  	return NULL;
> >  }
> >  
> > +static struct dma_async_tx_descriptor *sdma_prep_memcpy_sg(
> > +		struct dma_chan *chan,
> > +		struct scatterlist *dst_sg, unsigned int dst_nents,
> > +		struct scatterlist *src_sg, unsigned int src_nents,
> > +		unsigned long flags)
> > +{
> > +	return sdma_prep_sg(chan, dst_sg, dst_nents, src_sg, src_nents,
> > +			   DMA_MEM_TO_MEM);
> > +}
> > +
> > +static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
> > +		struct dma_chan *chan, struct scatterlist *sgl,
> > +		unsigned int sg_len, enum dma_transfer_direction direction,
> > +		unsigned long flags, void *context)
> > +{
> > +	return sdma_prep_sg(chan, NULL, 0, sgl, sg_len, direction);
> > +}
> > +
> >  static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
> >  		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
> >  		size_t period_len, enum dma_transfer_direction direction,
> > @@ -1143,9 +1270,9 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
> >  		goto err_out;
> >  	}
> >  
> > -	if (period_len > 0xffff) {
> > -		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %d > %d\n",
> > -				channel, period_len, 0xffff);
> > +	if (period_len > SDMA_BD_MAX_CNT) {
> > +		dev_err(sdma->dev, "SDMA channel %d: maximum period size exceeded: %zu > %d\n",
> > +				channel, period_len, SDMA_BD_MAX_CNT);
> this macro change should have been another patch too...
> 
> 
ok, will split into another patch too.
> -- 
> ~Vinod
