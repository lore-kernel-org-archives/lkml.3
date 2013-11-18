Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab3KRLPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:15:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47871 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab3KRLP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:15:28 -0500
Date: Mon, 18 Nov 2013 11:14:51 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Huan Wang <Huan.Wang@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
Message-ID: <20131118111451.GA30853@e106331-lin.cambridge.arm.com>
References: <1379498279-16096-1-git-send-email-b35083@freescale.com>
 <20131114104620.GB16396@e106331-lin.cambridge.arm.com>
 <B56CDBE15CE27145A4B77D2D24263E852409CE@039-SN1MPN1-003.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B56CDBE15CE27145A4B77D2D24263E852409CE@039-SN1MPN1-003.039d.mgd.msft.net>
Thread-Topic: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 07:43:04AM +0000, Jingchang Lu wrote:
> 
> 
> > -----Original Message-----
> > From: Mark Rutland [mailto:mark.rutland@arm.com]
> > Sent: Thursday, November 14, 2013 6:46 PM
> > To: Lu Jingchang-B35083
> > Cc: vinod.koul@intel.com; devicetree@vger.kernel.org; Wang Huan-B18965;
> > linux-kernel@vger.kernel.org; shawn.guo@linaro.org; linux-arm-
> > kernel@lists.infradead.org
> > Subject: Re: [PATCH v6 3/3] dma: Add Freescale eDMA engine driver support
> > 
> > On Wed, Sep 18, 2013 at 10:57:59AM +0100, Jingchang Lu wrote:
> > > Add Freescale enhanced direct memory(eDMA) controller support.
> > > The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> > > to eDMA channels.
> > > This module can be found on Vybrid and LS-1 SoCs.
> > >
> > > Signed-off-by: Alison Wang <b18965@freescale.com>
> > > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> [...] 
> > > +* DMAMUX
> > > +Required properties:
> > 
> > No compatible?
> > 
> > Where are DMAMUX nodes expected to live?
> > 
> > How to they relate to the eDMA controller in HW? Are they a
> > subcomponent, or a logically separate unit that happens to be connected?
> [Lu Jingchang-b35083] 
> DMAMUX is a multiplexer between dma controller channels and peripheral deivces,
> each DMAMUX provides 16 independently selectable DMA channel routers, and each 
> channel router can be assigned to one of the possible peripheral DMA slots.
> So it's not a standalone device, it's just required by the DMA controller to
> connect the channels and slaves, So it's got by DMA controller's "fsl,dma-mux" property.
> Thanks!

Ok.

I'm not so sure on the way this is described, from the point of view of
the device, its DMA channel is wired to the MUX, not to the DMA engine
directly:

                       +-------+
             /---------|DEVICE0|
             |         +-------+
+-----+   +------+
| DMA |===|DMAMUX|
+-----+   +------+
             |         +-------+
             \---------|DEVICE1|
                       +-------+

If that's the case, I'd expect the DMAMUX to have a #dma-cells and
describe each device as being wired to the mux, and then the mux as
being wired to the DMA. If the MUXes are sub-blocks of the DMA, then I'm
not sure why they need to be described at all.

Currently, the DMA code is handling information that's specific to the
MUX (i.e. the channel ID that's specific to the MUX), and that feels odd
unless the MUX is a component of the DMA (which if true I'd expect it to
be described differently).

> > 
> > > +- reg : Should contain DMAMUX registers location and length
> > > +- fsl,dmamux-id : DMAMUX ID. DMAMUX IDs are unique in each eDMA
> > controller.
> > > +  inside one eDMA controller, specific request source can only be
> > routed by
> > > +  one of its DMAMUXs.
> > > +  However Specific request source may be routed to different eDMA
> > controller,
> > > +  thus all the DMAMUXs sharing a the same request sources have the
> > same ID.
> > > +- clocks : Phandle of the clock used by the DMAMUX
> > > +- clock-names : The clock names
> > 
> > _which_ clock names do you expect? From the looks of the example, you
> > expect "dmamux".
> > 
> > From the view of the DMAMUX, what is its clock input called? "dmamux"
> > doesn't look like what I'd expect for a clock name, but if the
> > documentation for the eDMA doesn't provide a name for it, "dmamux" is
> > fine.
> > 
> > If you're not using clock-names, it's useless. You _must_ define the set
> > of names you expect or it's unusable. If you do define a set of names,
> > then you should request clocks by name in the driver.
> > 
> [Lu Jingchang-b35083] [Lu Jingchang-b35083] 
> The clock here is from the platform bus clock, I will remove this property for
> compatible between SoCs. Thanks!
> > > +

Ok, if it's already on and you don't need it for now, nto describing it
is fine.

[...]

> > > +               fsl_edmamux->clk = of_clk_get(phandle, 0);
> > > +               if (IS_ERR(fsl_edmamux->clk)) {
> > > +                       dev_err(&pdev->dev, "Missing DMAMUX clock.\n");
> > > +                       return PTR_ERR(fsl_edmamux->clk);
> > > +               }
> > 
> > Please acquire the clock by name:
> [Lu Jingchang-b35083] 
> I will remove the node name property for reuse the driver between SoCs,
> for they may have different clock names. Thanks!

The clock-names property describes the clock from the view of the
_device_, not the _system_. The set of possible clock-names should not
vary from system to system, but it may vary from generation to
generation of the device.

See the last portion of
http://www.spinics.net/lists/devicetree/msg08993.html for a description
of clock-names.

Thanks,
Mark.
