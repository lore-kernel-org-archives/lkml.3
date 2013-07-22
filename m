Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3GVXWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:22:53 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42151 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3GVXWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:22:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 05/15] DMA: shdma: pass SoC-specific configuration to the driver via OF matching
Date: Tue, 23 Jul 2013 01:23:40 +0200
Message-ID: <2097756.PJRdecDxfm@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1307220912380.7852@axis700.grange>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de> <1625139.lQ0AJJW8Dp@avalon> <Pine.LNX.4.64.1307220912380.7852@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Monday 22 July 2013 09:29:40 Guennadi Liakhovetski wrote:
> On Mon, 22 Jul 2013, Laurent Pinchart wrote:
> > On Friday 19 July 2013 18:29:30 Guennadi Liakhovetski wrote:
> > > Similar to the non-DT case, this patch passes SoC-specific configuration
> > > to the driver via device ID matching, instead of platform data.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > ---
> > > 
> > > v2: adjust spacing within array definitions to keep a uniform style.
> > > 
> > >  Documentation/devicetree/bindings/dma/shdma.txt |    7 +++++--
> > >  drivers/dma/sh/shdmac.c                         |   22
> > >  +++++++++++++-------
> > >  2 files changed, 20 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/dma/shdma.txt
> > > b/Documentation/devicetree/bindings/dma/shdma.txt index c15994a..7702e35
> > > 100644
> > > --- a/Documentation/devicetree/bindings/dma/shdma.txt
> > > +++ b/Documentation/devicetree/bindings/dma/shdma.txt
> > > 
> > > @@ -22,7 +22,10 @@ Optional properties (currently unused):
> > >  * DMA controller
> > > 
> > >  Required properties:
> > > -- compatible:	should be "renesas,shdma"
> > > +- compatible:	should be one of
> > > +		"renesas,shdma-r8a73a4" for the system DMAC on r8a73a4 SoC
> > > +		"renesas,shdma-r8a7740" for the DMACs (not RTDMAC) on r8a7740
> > > +		"renesas,shdma" for a generic DMAC
> > > 
> > >  Example:
> > >  	dmac: dma-mux0 {
> > > 
> > > @@ -36,7 +39,7 @@ Example:
> > >  		ranges;
> > >  		
> > >  		dma0: shdma@fe008020 {
> > > 
> > > -			compatible = "renesas,shdma";
> > > +			compatible = "renesas,shdma-r8a7740";
> > > 
> > >  			reg = <0xfe008020 0x270>,
> > >  			
> > >  				<0xfe009000 0xc>;
> > >  			
> > >  			interrupt-parent = <&gic>;
> > > 
> > > diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
> > > index 859ddbe..f80543c 100644
> > > --- a/drivers/dma/sh/shdmac.c
> > > +++ b/drivers/dma/sh/shdmac.c
> > > @@ -20,6 +20,8 @@
> > > 
> > >  #include <linux/init.h>
> > >  #include <linux/module.h>
> > > 
> > > +#include <linux/of.h>
> > > +#include <linux/of_device.h>
> > > 
> > >  #include <linux/slab.h>
> > >  #include <linux/interrupt.h>
> > >  #include <linux/dmaengine.h>
> > > 
> > > @@ -663,6 +665,14 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
> > > 
> > >  	.get_partial = sh_dmae_get_partial,
> > >  
> > >  };
> > > 
> > > +static const struct of_device_id sh_dmae_of_match[] = {
> > > +	{.compatible = "renesas,shdma",},
> > > +	{.compatible = "renesas,shdma-r8a73a4", .data = 
r8a73a4_shdma_devid,},
> > > +	{.compatible = "renesas,shdma-r8a7740", .data = 
r8a7740_shdma_devid,},
> > 
> > Nit-picking here, OF device ID entries are usually ordered from most
> > specific to most generic compatible strings. It's up to you.
> 
> Yeah, in fact, I'm not even sure we need the generic line, so far I think
> we always need SoC configuration. Maybe I shall just remove it. Could do
> in an incremental patch.

If you end up sending a v3 you could remove the generic entry. Otherwise let's 
not bother for now.

> > > +	{}
> > > +};
> > > +MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
> > 
> > Shouldn't you guard the table with #ifdef CONFIG_OF ? If the driver can
> > only be used on ARM platforms it might not be worth it, but if it can be
> > used on SH as well that would make sense.
> 
> Well, it is a pretty common practice, I admit, but what exactly does it
> bring us apart from saving a couple of bytes? I just tried a SuperH build
> - no problem.

Exactly that, saving a couple of bytes :-)

-- 
Regards,

Laurent Pinchart

