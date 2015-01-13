Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbbAMDrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 22:47:52 -0500
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:53745
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750860AbbAMDru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 22:47:50 -0500
Date: Tue, 13 Jan 2015 11:55:16 +0800
From: Robin Gong <b38343@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <andriy.shevchenko@linux.jf.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] dma: imx-sdma: add support for sdma memory copy
Message-ID: <20150113035515.GA8251@Robin-OptiPlex-780>
References: <1414030940-15516-1-git-send-email-b38343@freescale.com>
 <1414030940-15516-2-git-send-email-b38343@freescale.com>
 <20141205163918.GO3411@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141205163918.GO3411@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(24454002)(189002)(51704005)(199003)(97756001)(47776003)(23726002)(87936001)(2950100001)(62966003)(33656002)(77156002)(64706001)(68736005)(106466001)(81156004)(77096005)(105606002)(54356999)(83506001)(76176999)(50986999)(33716001)(92566002)(110136001)(85426001)(97736003)(6806004)(46102003)(50466002)(46406003)(69596002)(104016003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0633;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB0633;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0633;
X-Forefront-PRVS: 045584D28C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 03:47:46.4473
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 10:09:18PM +0530, Vinod Koul wrote:
> On Thu, Oct 23, 2014 at 10:22:18AM +0800, Robin Gong wrote:
>  
> > -static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
> > -		struct dma_chan *chan, struct scatterlist *sgl,
> > -		unsigned int sg_len, enum dma_transfer_direction direction,
> > -		unsigned long flags, void *context)
> > +static struct dma_async_tx_descriptor *sdma_prep_memcpy(
> > +		struct dma_chan *chan, dma_addr_t dma_dst,
> > +		dma_addr_t dma_src, size_t len, unsigned long flags)
> > +{
> > +	struct sdma_channel *sdmac = to_sdma_chan(chan);
> > +	struct sdma_engine *sdma = sdmac->sdma;
> > +	int channel = sdmac->channel;
> > +	size_t count;
> > +	int i = 0, param, ret;
> > +	struct sdma_buffer_descriptor *bd;
> > +
> > +	if (!chan || !len || sdmac->status == DMA_IN_PROGRESS)
> > +		return NULL;
> why is this dependent on status. You can prepare a descriptor here!
Unfortunately, it is the limitation of imx-sdma driver, the driver can't support
process asynchronously.
> > +
> > +	if (len >= NUM_BD * SDMA_BD_MAX_CNT) {
> > +		dev_err(sdma->dev, "channel%d: maximum bytes exceeded:%d > %d\n",
> > +			channel, len, NUM_BD * SDMA_BD_MAX_CNT);
> > +		goto err_out;
> > +	}
> > +
> > +	sdmac->status = DMA_IN_PROGRESS;
> ??
> 
> > +
> > +	sdmac->buf_tail = 0;
> > +
> > +	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
> > +		dma_src, dma_dst, len, channel);
> > +
> > +	sdmac->direction = DMA_MEM_TO_MEM;
> > +
> > +	ret = sdma_load_context(sdmac);
> > +	if (ret)
> > +		goto err_out;
> > +
> > +	sdmac->chn_count = 0;
> > +
> > +	do {
> > +		count = min_t(size_t, len, SDMA_BD_MAX_CNT);
> > +		bd = &sdmac->bd[i];
> > +		bd->buffer_addr = dma_src;
> > +		bd->ext_buffer_addr = dma_dst;
> > +		bd->mode.count = count;
> > +
> > +		if (sdmac->word_size > DMA_SLAVE_BUSWIDTH_4_BYTES) {
> > +			ret =  -EINVAL;
> > +			goto err_out;
> > +		}
> > +
> > +		switch (sdmac->word_size) {
> > +		case DMA_SLAVE_BUSWIDTH_4_BYTES:
> So are you dependent of dma_slave_config to be set. Then it is wrong. for
> memcpy you shoudn't be!
> 
Yes. Will remove the constrain.
> >  		switch (sdmac->word_size) {
> >  		case DMA_SLAVE_BUSWIDTH_4_BYTES:
> >  			bd->mode.command = 0;
> > -			if (count & 3 || sg->dma_address & 3)
> > +			if ((count | sg_src->dma_address | (sg_dst &&
> > +				(sg_dst->dma_address))) & 3)
> >  				return NULL;
> >  			break;
> >  		case DMA_SLAVE_BUSWIDTH_2_BYTES:
> >  			bd->mode.command = 2;
> > -			if (count & 1 || sg->dma_address & 1)
> > +			if ((count | sg_src->dma_address |
> > +				(sg_dst && (sg_dst->dma_address))) & 1)
> >  				return NULL;
> this doesn't seem to have anything to do with memcpy, shouldn't this be
> independent change here?
> 
Yes, will split the re-org patch clearly.
> >  			break;
> >  		case DMA_SLAVE_BUSWIDTH_1_BYTE:
> > @@ -1099,21 +1214,23 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
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
> > +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
> > +				i, count, sg_src->dma_address,
> >  				param & BD_WRAP ? "wrap" : "",
> >  				param & BD_INTR ? " intr" : "");
> ditto
> 
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
> > @@ -1122,6 +1239,24 @@ err_out:
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
> you should have done this first and then added memcpy
> 
> -- 
> ~Vinod 
Ok, do the re-org patch firstly, and then add new feature.

