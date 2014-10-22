Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaJVFf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 01:35:57 -0400
Received: from [65.55.169.125] ([65.55.169.125]:42272 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752877AbaJVFf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 01:35:56 -0400
Date: Wed, 22 Oct 2014 13:42:39 +0800
From: Robin Gong <b38343@freescale.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] dma: imx-sdma: reorg code to make code clean
Message-ID: <20141022054238.GA3100@Robin-OptiPlex-780>
References: <1413853781-18384-1-git-send-email-b38343@freescale.com>
 <1413853781-18384-4-git-send-email-b38343@freescale.com>
 <1413884375.2396.23.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1413884375.2396.23.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(377424004)(24454002)(97736003)(23726002)(46102003)(76482002)(80022003)(99396003)(4396001)(76176999)(19580405001)(54356999)(104016003)(50986999)(33716001)(110136001)(64706001)(46406003)(47776003)(20776003)(120916001)(21056001)(84676001)(69596002)(50466002)(68736004)(85306004)(105606002)(33656002)(92726001)(92566001)(95666004)(102836001)(44976005)(85852003)(83506001)(26826002)(19580395003)(31966008)(81156004)(106466001)(6806004)(87936001)(107046002)(97756001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 037291602B
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments, I'll send the next verison.
On Tue, Oct 21, 2014 at 12:39:35PM +0300, Andy Shevchenko wrote:
> On Tue, 2014-10-21 at 09:09 +0800, Robin Gong wrote:
> > code reorg for transfer prepare and bus width check.
> 
> Fix style of commit message.
> 
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  drivers/dma/imx-sdma.c | 127 +++++++++++++++++++++++--------------------------
> >  1 file changed, 60 insertions(+), 67 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index 7e8aa2d..b0365c2 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -1026,6 +1026,52 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
> >  	clk_disable(sdma->clk_ahb);
> >  }
> >  
> > +static int sdma_transfer_init(struct sdma_channel *sdmac,
> > +			      enum dma_transfer_direction direction)
> > +{
> > +	int ret = 0;
> 
> Redundant assignment.
> 
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
> > +		 bd->mode.command = 1;
> > +		 break;
> > +	default:
> > +		 return -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> >  		struct dma_chan *chan, dma_addr_t dma_dst,
> >  		dma_addr_t dma_src, size_t len, unsigned long flags)
> > @@ -1034,7 +1080,7 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> >  	struct sdma_engine *sdma = sdmac->sdma;
> >  	int channel = sdmac->channel;
> >  	size_t count;
> > -	int i = 0, param, ret;
> > +	int i = 0, param;
> >  	struct sdma_buffer_descriptor *bd;
> >  
> >  	if (!chan || !len || sdmac->status == DMA_IN_PROGRESS)
> > @@ -1046,21 +1092,12 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> >  		goto err_out;
> >  	}
> >  
> > -	sdmac->status = DMA_IN_PROGRESS;
> > -
> > -	sdmac->buf_tail = 0;
> > -
> >  	dev_dbg(sdma->dev, "memcpy: %pad->%pad, len=%zu, channel=%d.\n",
> >  		&dma_src, &dma_dst, len, channel);
> >  
> > -	sdmac->direction = DMA_MEM_TO_MEM;
> > -
> > -	ret = sdma_load_context(sdmac);
> > -	if (ret)
> > +	if (sdma_transfer_init(sdmac, DMA_MEM_TO_MEM))
> >  		goto err_out;
> >  
> > -	sdmac->chn_count = 0;
> > -
> >  	do {
> >  		count = min_t(size_t, len, SDMA_BD_MAX_CNT);
> >  		bd = &sdmac->bd[i];
> > @@ -1068,28 +1105,8 @@ static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> >  		bd->ext_buffer_addr = dma_dst;
> >  		bd->mode.count = count;
> >  
> > -		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES) {
> > -			ret =  -EINVAL;
> > +		if (check_bd_buswidth(bd, sdmac, count, dma_dst, dma_src))
> >  			goto err_out;
> > -		}
> > -
> > -		switch (sdmac->word_size) {
> > -		case DMA_SLAVE_BUSWIDTH_4_BYTES:
> > -			bd->mode.command = 0;
> > -			if ((count | dma_dst | dma_src) & 3)
> > -				return NULL;
> > -			break;
> > -		case DMA_SLAVE_BUSWIDTH_2_BYTES:
> > -			bd->mode.command = 2;
> > -			if ((count | dma_dst | dma_src) & 1)
> > -				return NULL;
> > -			break;
> > -		case DMA_SLAVE_BUSWIDTH_1_BYTE:
> > -			bd->mode.command = 1;
> > -			break;
> > -		default:
> > -			return NULL;
> > -		}
> >  
> >  		dma_src += count;
> >  		dma_dst += count;
> > @@ -1141,21 +1158,10 @@ static struct dma_async_tx_descriptor *sdma_prep_sg(
> >  
> >  	if (sdmac->status == DMA_IN_PROGRESS)
> >  		return NULL;
> > -	sdmac->status = DMA_IN_PROGRESS;
> > -
> > -	sdmac->flags = 0;
> > -
> > -	sdmac->buf_tail = 0;
> >  
> >  	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
> >  			src_nents, channel);
> >  
> > -	sdmac->direction = direction;
> > -
> > -	ret = sdma_load_context(sdmac);
> > -	if (ret)
> > -		goto err_out;
> > -
> >  	if (src_nents > NUM_BD) {
> >  		dev_err(sdma->dev, "SDMA channel %d: maximum number of sg exceeded: %d > %d\n",
> >  				channel, src_nents, NUM_BD);
> > @@ -1163,7 +1169,9 @@ static struct dma_async_tx_descriptor *sdma_prep_sg(
> >  		goto err_out;
> >  	}
> >  
> > -	sdmac->chn_count = 0;
> > +	if (sdma_transfer_init(sdmac, direction))
> > +		goto err_out;
> > +
> >  	for_each_sg(src_sg, sg_src, src_nents, i) {
> >  		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
> >  		int param;
> > @@ -1187,30 +1195,15 @@ static struct dma_async_tx_descriptor *sdma_prep_sg(
> >  		bd->mode.count = count;
> >  		sdmac->chn_count += count;
> >  
> > -		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES) {
> > -			ret =  -EINVAL;
> > +		if (direction == DMA_MEM_TO_MEM)
> > +			ret = check_bd_buswidth(bd, sdmac, count,
> > +						sg_dst->dma_address,
> > +						sg_src->dma_address);
> > +		else
> > +			ret = check_bd_buswidth(bd, sdmac, count, 0,
> > +						sg_src->dma_address);
> > +		if (ret)
> >  			goto err_out;
> > -		}
> > -
> > -		switch (sdmac->word_size) {
> > -		case DMA_SLAVE_BUSWIDTH_4_BYTES:
> > -			bd->mode.command = 0;
> > -			if ((count | sg_src->dma_address | (sg_dst &&
> > -				(sg_dst->dma_address))) & 3)
> > -				return NULL;
> > -			break;
> > -		case DMA_SLAVE_BUSWIDTH_2_BYTES:
> > -			bd->mode.command = 2;
> > -			if ((count | sg_src->dma_address |
> > -				(sg_dst && (sg_dst->dma_address))) & 1)
> > -				return NULL;
> > -			break;
> > -		case DMA_SLAVE_BUSWIDTH_1_BYTE:
> > -			bd->mode.command = 1;
> > -			break;
> > -		default:
> > -			return NULL;
> > -		}
> >  
> >  		param = BD_DONE | BD_EXTD | BD_CONT;
> >  
> 
> 
> -- 
> Andy Shevchenko <andriy.shevchenko@intel.com>
> Intel Finland Oy
> 
