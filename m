Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3INVbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 17:31:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab3INVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 17:31:37 -0400
Date: Sat, 14 Sep 2013 23:31:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: djbw@fb.com, vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, max.filippov@cogentembedded.com
Subject: Re: [PATCH v3] dma: add driver for R-Car HPB-DMAC
In-Reply-To: <5234B33A.8040409@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1309142327410.32052@axis700.grange>
References: <201308250033.24936.sergei.shtylyov@cogentembedded.com>
 <Pine.LNX.4.64.1309142017040.28905@axis700.grange> <5234B33A.8040409@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:pYrjlHRKIswlr+EvHSD4X0y8cegM5PXScfqlQ5ya8vU
 7Cbpc69OWXIVdN9+Wy9xnMC3WcB91eNjvqY6SJc7VAyhFF5+eB
 rjKkueVWe34FLEIGywoWwQxQ2jkfNs0mhLAMiR4TnzJGMebjA6
 wXFB4oMVqWaRN0A9S1X1X4zOVcEc5iwCpGiXalgd7zUzm8iOSX
 bw4DYs31QF1ci3c6v996g05OFHlG5+6PDkbFiXXSpwylGZR2zH
 A+m5xo21IiUi0R0/PSUR9r1iE25mHlGToXw845/jB87fuapN7Y
 qjZ+U3VtJDKX2k3Phz+PAkqk5Fit89WFzpAXYJ1m9kScMF0muq
 hiGzzfAgUHtOcWl9fRPe2mCKpEMaBKiOgkxEyMjAkv5rZPFxQp
 T4Arei0+L0iZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei

On Sat, 14 Sep 2013, Sergei Shtylyov wrote:

> Hello.
> 
> On 09/14/2013 10:33 PM, Guennadi Liakhovetski wrote:
> 
> > > From: Max Filippov <max.filippov@cogentembedded.com>
> 
> > > Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base'
> > > DMA
> > > driver framework.
> 
> > > Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> > > Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
> > > [Sergei: removed useless #include, sorted #include's, fixed
> > > HPB_DMA_TCR_MAX,
> > > fixed formats and removed line breaks in the dev_dbg() calls, rephrased
> > > and
> > > added IRQ # to the shdma_request_irq() failure message, added
> > > MODULE_AUTHOR(),
> > > removed '__init'/'__exit' annotations from the probe()/remove() methods,
> > > removed
> > > '__initdata' annotation from 'hpb_dmae_driver', fixed guard macro name in
> > > the
> > > header file, fixed #define ASYNCRSTR_ASRST20, added #define
> > > ASYNCRSTR_ASRST24,
> > > added the necessary runtime PM calls to the probe() and remove() methods,
> > > handled errors returned by dma_async_device_register(), beautified
> > > comments
> > > and #define's.]
> > > Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> > > ---
> 
> > [snip]
> 
> > > Index: slave-dma/drivers/dma/sh/rcar-hpbdma.c
> > > ===================================================================
> > > --- /dev/null
> > > +++ slave-dma/drivers/dma/sh/rcar-hpbdma.c
> > > @@ -0,0 +1,655 @@
> 
> > [snip]
> 
> > > +static int hpb_dmae_chan_probe(struct hpb_dmae_device *hpbdev, int id)
> > > +{
> > > +	struct shdma_dev *sdev = &hpbdev->shdma_dev;
> > > +	struct platform_device *pdev =
> > > +		to_platform_device(hpbdev->shdma_dev.dma_dev.dev);
> > > +	struct hpb_dmae_chan *new_hpb_chan;
> > > +	struct shdma_chan *schan;
> > > +
> > > +	/* Alloc channel */
> > > +	new_hpb_chan = devm_kzalloc(&pdev->dev,
> > > +				    sizeof(struct hpb_dmae_chan), GFP_KERNEL);
> > > +	if (!new_hpb_chan) {
> > > +		dev_err(hpbdev->shdma_dev.dma_dev.dev,
> > > +			"No free memory for allocating DMA channels!\n");
> > > +		return -ENOMEM;
> > > +	}
> > > +
> > > +	schan = &new_hpb_chan->shdma_chan;
> 
> > A suggestion for an incremental patch - you might want to initialise the
> > max_xfer_len field like
> 
> > 	schan->max_xfer_len = 64 * 1024 * 1024 - 1;
> 
>    IIRC, the HPB-DMAC's maximum transfer length is 16 MiB, without -1. You
> probably mixed it with LBSC-DMAC which is indeed capable of 64 MiB.

Sorry, no idea what the correct value for HPB DMAC is. This was just an 
example.

Thanks
Guennadi

> > because if it isn't initialised your max transfer length will be 4k,
> > which will hurt your performance. I think you should get a better
> > throughput after that
> 
>    OK, note taken. We'll look into it.
> 
> WBR, Sergei

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
