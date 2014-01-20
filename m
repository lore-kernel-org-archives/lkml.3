Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaATJGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 04:06:51 -0500
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:30886
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750765AbaATJGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 04:06:46 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>
Subject: RE: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPE1IcCA6lalTOXEyjRgC6v+JOLpqNPxeAgAAUL1A=
Date: Mon, 20 Jan 2014 09:06:43 +0000
Message-ID: <43d79ce905e24e9bb58ef49ac19db7d7@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1389938684-29467-1-git-send-email-b35083@freescale.com>
 <1389938684-29467-3-git-send-email-b35083@freescale.com>
 <20140120074019.GF26823@intel.com>
In-Reply-To: <20140120074019.GF26823@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377454003)(199002)(189002)(24454002)(13464003)(51704005)(63696002)(53806001)(4396001)(79102001)(47736001)(54356001)(33646001)(46102001)(51856001)(50986001)(47976001)(49866001)(54316002)(80022001)(69226001)(74366001)(81542001)(74706001)(83322001)(66066001)(47446002)(76796001)(81342001)(56776001)(81686001)(76786001)(74502001)(74662001)(2656002)(76576001)(92566001)(81816001)(56816005)(87266001)(83072002)(85306002)(19580405001)(76482001)(74316001)(65816001)(551934002)(59766001)(19580395003)(85852003)(87936001)(93136001)(77982001)(93516002)(90146001)(80976001)(31966008)(86362001)(74876001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB212;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0K97pLW002443



> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Monday, January 20, 2014 3:40 PM
> To: Lu Jingchang-B35083
> Cc: dan.j.williams@intel.com; arnd@arndb.de; shawn.guo@linaro.org;
> pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; Wang Huan-B18965
> Subject: Re: [PATCHv10 2/2] dma: Add Freescale eDMA engine driver support
> 
> On Fri, Jan 17, 2014 at 02:04:44PM +0800, Jingchang Lu wrote:
> > Add Freescale enhanced direct memory(eDMA) controller support.
> > This module can be found on Vybrid and LS-1 SoCs.
> >
> > Signed-off-by: Alison Wang <b18965@freescale.com>
> > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> > +static int fsl_edma_control(struct dma_chan *chan, enum dma_ctrl_cmd
> cmd,
> > +		unsigned long arg)
> > +{
> > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > +	struct dma_slave_config *cfg = (void *)arg;
> > +	unsigned long flags;
> > +	LIST_HEAD(head);
> > +
> > +	switch (cmd) {
> > +	case DMA_TERMINATE_ALL:
> > +		spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> > +		fsl_edma_disable_request(fsl_chan);
> > +		fsl_chan->edesc = NULL;
> > +		vchan_get_all_descriptors(&fsl_chan->vchan, &head);
> > +		spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> > +		vchan_dma_desc_free_list(&fsl_chan->vchan, &head);
> > +		return 0;
> well what happens to the current ongoing transactions, i don't see those
> getting
> terminated?
The fsl_edma_disable_request(fsl_chan) would end the channel's ongoing transaction, then
the eDMA would not response to device dma request, and the vchan_dma_desc_free_list()
will release all associate memory. Thanks.

> 
> > +
> > +	case DMA_SLAVE_CONFIG:
> > +		fsl_chan->fsc.dir = cfg->direction;
> > +		if (cfg->direction == DMA_DEV_TO_MEM) {
> > +			fsl_chan->fsc.dev_addr = cfg->src_addr;
> > +			fsl_chan->fsc.addr_width = cfg->src_addr_width;
> > +			fsl_chan->fsc.burst = cfg->src_maxburst;
> > +			fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(cfg-
> >src_addr_width);
> > +		} else if (cfg->direction == DMA_MEM_TO_DEV) {
> > +			fsl_chan->fsc.dev_addr = cfg->dst_addr;
> > +			fsl_chan->fsc.addr_width = cfg->dst_addr_width;
> > +			fsl_chan->fsc.burst = cfg->dst_maxburst;
> > +			fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(cfg-
> >dst_addr_width);
> okay atrr is address width, why not save this standard struct instead?
The value saved in fsc.attr is transferred by fsl_edma_get_tcd_attr(), it can
be set into the channel control register later directly. the edma driver doesn't
need to save all dma_slave_config parameters, so it only gets the necessaries.
Thanks.
 
> 
> > +		} else {
> > +			return -EINVAL;
> > +		}
> > +		return 0;
> > +
> > +	case DMA_PAUSE:
> > +		spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> > +		if (fsl_chan->edesc) {
> > +			fsl_edma_disable_request(fsl_chan);
> > +			fsl_chan->status = DMA_PAUSED;
> > +		}
> > +		spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> > +		return 0;
> > +
> > +	case DMA_RESUME:
> > +		spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> > +		if (fsl_chan->edesc) {
> > +			fsl_edma_enable_request(fsl_chan);
> > +			fsl_chan->status = DMA_IN_PROGRESS;
> > +		}
> > +		spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> > +		return 0;
> > +
> > +	default:
> > +		return -ENXIO;
> > +	}
> > +}
> > +
> 
> > +static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan
> *fsl_chan,
> > +		int sg_len)
> > +{
> > +	struct fsl_edma_desc *fsl_desc;
> > +	int i;
> > +
> > +	fsl_desc = kzalloc(sizeof(*fsl_desc) + sizeof(struct
> fsl_edma_sw_tcd) * sg_len,
> > +				GFP_NOWAIT);
> > +	if (!fsl_desc)
> > +		return NULL;
> > +
> > +	fsl_desc->echan = fsl_chan;
> > +	fsl_desc->n_tcds = sg_len;
> > +	for (i = 0; i < sg_len; i++) {
> > +		fsl_desc->tcd[i].vtcd = dma_pool_alloc(fsl_chan->tcd_pool,
> > +					GFP_NOWAIT, &fsl_desc->tcd[i].ptcd);
> > +		if (!fsl_desc->tcd[i].vtcd)
> > +			goto err;
> > +	}
> > +	return fsl_desc;
> > +
> > +err:
> > +	while (--i >= 0)
> > +		dma_pool_free(fsl_chan->tcd_pool, fsl_desc->tcd[i].vtcd,
> > +				fsl_desc->tcd[i].ptcd);
> > +	kfree(fsl_desc);
> > +	return NULL;
> > +}
> > +
> > +static struct dma_async_tx_descriptor *fsl_edma_prep_dma_cyclic(
> > +		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
> > +		size_t period_len, enum dma_transfer_direction direction,
> > +		unsigned long flags, void *context)
> > +{
> you may want to implement the capablities api subsequently for audio
> usage.
Do you mean the device_slave_caps function? If it is, I will add it.
Thanks.

> 
> > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > +	struct fsl_edma_desc *fsl_desc;
> > +	dma_addr_t dma_buf_next;
> > +	int sg_len, i;
> > +	u32 src_addr, dst_addr, last_sg, nbytes;
> > +	u16 soff, doff, iter;
> > +
> > +	if (!is_slave_direction(fsl_chan->fsc.dir))
> > +		return NULL;
> > +
> > +	sg_len = buf_len / period_len;
> > +	fsl_desc = fsl_edma_alloc_desc(fsl_chan, sg_len);
> > +	if (!fsl_desc)
> > +		return NULL;
> > +	fsl_desc->iscyclic = true;
> > +
> > +	dma_buf_next = dma_addr;
> > +	nbytes = fsl_chan->fsc.addr_width * fsl_chan->fsc.burst;
> > +	iter = period_len / nbytes;
> empty line here pls
Ok, thanks.


Best Regards,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
