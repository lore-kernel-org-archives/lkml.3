Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3IQHyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:54:10 -0400
Received: from [213.199.154.205] ([213.199.154.205]:7314 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab3IQHyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:54:08 -0400
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2013 03:54:08 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz9371I103dK542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>, "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOqh42n/m/IZ+OnUOyyFvNQ0U/dpnJb5uAgAAsX6A=
Date: Tue, 17 Sep 2013 07:37:48 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E85223E0C@039-SN1MPN1-003.039d.mgd.msft.net>
References: <1378374799-16357-1-git-send-email-b35083@freescale.com>
 <20130917045359.GN17188@intel.com>
In-Reply-To: <20130917045359.GN17188@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.98]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8H7sTli010063



> -----Original Message-----
> From: Vinod Koul [mailto:vinod.koul@intel.com]
> Sent: Tuesday, September 17, 2013 12:54 PM
> To: Lu Jingchang-B35083
> Cc: djbw@fb.com; shawn.guo@linaro.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; devicetree@vger.kernel.org; Wang
> Huan-B18965
> Subject: Re: [PATCH 3/3] dma: Add Freescale eDMA engine driver support
> 
> I need ACK from DT maintainers on the above parts
Should I cc this to one of the DT maintainers? Thanks.

> 
> > +static int fsl_edma_control(struct dma_chan *chan, enum dma_ctrl_cmd
> cmd,
> > +		unsigned long arg)
> > +{
> > +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> > +	struct dma_slave_config *cfg = (void *)arg;
> > +
> > +	switch (cmd) {
> > +	case DMA_TERMINATE_ALL:
> > +		fsl_edma_disable_request(fsl_chan);
> > +		fsl_chan->edesc = NULL;
> you need to hold the lock here to prevent race here!
Thanks, I will fix this in the next version of the patch.

> 
> > +		vchan_free_chan_resources(&fsl_chan->vchan);
> > +		return 0;
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
> > +		} else {
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (!cfg->slave_id) {
> > +			return -EINVAL;
> should you check for this first, you wrote the channel with config above
> and now
> returning error?
Yes, the slave id should be checked first, thanks!

> > +	spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> > +	vdesc = vchan_find_desc(&fsl_chan->vchan, cookie);
> > +	if (fsl_chan->edesc && cookie == fsl_chan->edesc->vdesc.tx.cookie)
> > +		txstate->residue = fsl_edma_desc_residue(fsl_chan, vdesc, 1);
> why not use true/false for the last bool arg?
Thanks, I will use true/false instead.






Best Regards,
Jingchang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
