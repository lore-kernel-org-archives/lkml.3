Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab3ICFn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:43:27 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:44049
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749Ab3ICFnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:43:25 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz103dK1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: Vinod Koul <vinod.koul@intel.com>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v4 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOmk6HmvW+8Uz+BkmoowcYjqk1XpmqWYUAgAAO9YCAB5LmAIAAJBEQ///5soCAAA2oYIAAPxUAgAEsl2A=
Date: Tue, 3 Sep 2013 05:43:21 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E852102A1@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1376633274-17850-1-git-send-email-b35083@freescale.com>
 <20130828081742.GC11414@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520A8C7@039-SN1MPN1-003.039d.mgd.msft.net>
 <20130902045050.GE7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520D0D4@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902063721.GK7376@intel.com>
 <B56CDBE15CE27145A4B77D2D24263E8520F101@039-SN1MPN1-004.039d.mgd.msft.net>
 <20130902111200.GP7376@intel.com>
In-Reply-To: <20130902111200.GP7376@intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r835hWtU012095

> > How about change the filter_fn to follow:
> > static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
> > {
> >         struct fsl_edma_filter_param *fparam = fn_param;
> >         struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> >         unsigned char val;
> >
> >         if (fsl_chan->edmamux->mux_id != fparam->mux_id)
> >                 return false;
> >
> >         val = EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(fparam-
> >slot_id);
> >         fsl_edmamux_config_chan(fsl_chan, val);
> >         return true;
> > }
> > In fact the slot_id isn't need elsewhere, and if the filter return true,
> > This channel should be to this request. So no need to save the slave id,
> Right?
> something like
> 
> static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
> {
> 	struct fsl_edma_filter_param *fparam = fn_param;
> 	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> 
> 	if (fsl_chan->edmamux->mux_id != fparam->mux_id)
> 		return false;
> 	return true;
> }
> 
> in thedriver which calls this:
> 
> before prep:
> 
> 	config->slave_id = val;
> 
> 	dma_set_slave_config(chan, slave);
> 
  Do you mean the DMA_SLAVE_CONFIG device_control? Yeah, the slave driver could pass
the slave_id. But the DMA_SLAVE_CONFIG may be called more than once, and the eDMA
driver just needs to set the slave id once for any given channel, after that the 
transfer is transparent to the device. 
  On the other hand, the DMAMUX's setting procedure requires first disable the dmamux
before setting, then if it is set in DMA_SLAVE_CONFIG, the repeated setting may be
complex and unnecessary. The channel is occupied exclusively by the peripheral.
  So, according the HW feature, I think the eDMA needs only set the slave id once,
and since the of_dma helper has pass the slave id in on xlate, we can get and set
the slave id here. How do you think about this?
  Thanks!









Best Regards,
Jingchang



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
