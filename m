Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaJULXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:23:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:25367 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbaJULXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:23:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,761,1406617200"; 
   d="scan'208";a="622502027"
Date: Tue, 21 Oct 2014 16:15:40 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ray Jui <rjui@broadcom.com>, Dan Williams <dan.j.williams@intel.com>,
        Scott Branden <sbranden@broadcom.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
Message-ID: <20141021104540.GL28745@intel.com>
References: <rjui@broadcom.com>
 <1413506896-4536-1-git-send-email-rjui@broadcom.com>
 <5440C929.9050906@metafoo.de>
 <20141017073535.GN1638@intel.com>
 <5440FA6B.6040303@metafoo.de>
 <54414153.70804@broadcom.com>
 <5441464D.8040303@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5441464D.8040303@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 06:39:41PM +0200, Lars-Peter Clausen wrote:
> On 10/17/2014 06:18 PM, Ray Jui wrote:
> >On 10/17/2014 4:15 AM, Lars-Peter Clausen wrote:
> >>On 10/17/2014 09:35 AM, Vinod Koul wrote:
> >>>On Fri, Oct 17, 2014 at 09:45:45AM +0200, Lars-Peter Clausen wrote:
> >>>>On 10/17/2014 02:48 AM, Ray Jui wrote:
> >>>>>As part of subsystem that many slave drivers depend on, it's more
> >>>>>appropriate for the pl330 DMA driver to be initialized at
> >>>>>subsys_initcall than device_initcall
> >>>>
> >>>>Well, we do have -EPROBE_DEFER these days to handle these kinds of
> >>>>dependencies so we no longer have to these kinds of manual init
> >>>>reordering tricks.
> >>>How ould that work?
> >>>
> >>>Consider for example SPI and dmanegine. SPI driver got probed, then to
> >>>start
> >>>a transaction requested a channel... while dmaengine driver is still
> >>>getting
> >>>probed/not probed yet. So SPI driver didnt get a channel.
> >>>
> >>
> >>Ideally the SPI driver requests the channel in probe function and if the
> >>DMA controller is not yet probed returns EPROBE_DEFER. If the SPI driver
> >>requests the channel in the transfer handler it needs to deal with being
> >>able to fall back to non DMA transfers anyway so this shouldn't be a
> >>problem.
> >So in the case of the spi-pl022 driver. It requests the channel in probe
> >function. And obviously DMA is not mandatory, so when the channel request
> >fails the probe won't fail and instead it falls back to PIO. In this case,
> >can you recommend a different way to solve this problem without having the
> >DMA driver probed earlier than its slaves?
> 
> 
> dma_request_slave_channel() has the problem that we can't
> differentiate between no channel provided and channel provided but
> the dma driver hasn't probed yet. The function will return NULL in
> both cases. But Stephen Warren added
> dma_request_slave_channel_reason() a while ago to solve this
> problem. This function returns a ERR_PTR. If it returns
> ERR_PTR(-EPROBE_DEFER) it means that a channel has been provided but
> the DMA driver hasn't probed yet. In this case the SPI driver should
> return -EPROBE_DEFER to try again later. If the function returns a
> different error code that means that it was not possible to get the
> DMA channel and it should fall back to PIO.
So when should the SPI here check, if dmaengine is available. The client
doesn't grab channel in its probe, so the client cannot return
-EPROBE_DEFER.

-- 
~Vinod

> 
> >
> >>
> >>But in any case fiddling around with the init sequences is just a quick
> >>hack and might makes the problem less likely to appear in some cases,
> >>but there is no guarantee that it works. And I think the proper solution
> >>at the moment is to use probe deferral.
> >I think it makes sense to have the DMA driver, as one of the core components
> >in various SoCs that a lot of peripheral drivers depend on, to be registered
> >at the level of subsys_init or somewhere close. We are not changing this
> >just to get SPI to work. We are changing this because we think DMA should be
> >ready before a lot of its slaves, which are typically done at device_initcall.
> 
> But if the DMA driver for example depends on a clock driver do you
> put the clock driver at a even earlier init level? The problem with
> using init levels for solving this problem is that there is only a
> small amount of init levels available and representing the
> dependency chains is neither possible with it nor were init level
> ever intended for solving this. EPROBE_DEFER on the other hand is.
> 
> >
> >I have no problem relying on EPROBE_DEFER for this, provided that it works.
> >The issue is, like I mentioned above, for a lot of slave devices DMA is not
> >mandatory, when DMA fails at probe they would fall back to PIO and never use
> >DMA. Another disadvantage I see with EPROBE_DEFER is delayed boot time.
> >
> 
> Yea, the EPROBE_DEFER implementation is not ideal, but that is a
> problem that should be solved rather than working around it. I think
> there are patches somewhere for example that build a device
> dependency graph from the phandles in the devicetree and than probe
> devices in the correct order to reduce the number of times probe
> deferral is necessary.
> 
> >>
> >>Other subsystems have seen patches which moved drivers from using
> >>subsys_initcall to device_initcall/module_..._driver/ with the reasoning
> >>that this is no longer necessary because of EPROBE_DEFER. So I don't
> >>think we should be doing the exact opposite in DMA framework. Also if
> >>we'd apply this patch it won't take to long until somebody suggest going
> >>back to module_platform_driver() instead of subsys_initcall.
> >>
> >>- Lars
> >There are currently 12 DMA drivers under drivers/dma registering themselves
> >at subsys_init. I don't see why pl330 cannot do the same. Is there any
> >concern that it may not work for some other SoCs when it's done at
> >subsys_init? So far I cannot think of any. The only dependency of pl330 is
> >the ARM apb_pclk, required during AMBA bus probe. But that's usually ready
> >before subsys_init.
> 
> Those other drivers should be converted to device_initcall rather
> than converting the PL330 driver to subsys_init. Using subsys_init
> for device drivers is a hack which was used to try to solve ordering
> problems. But it doesn't work that great, especially if you have
> more than two devices in your dependency chain. The solution that
> people have come up with to solve this problem in a better way is
> probe deferral by the means of -EPROBE_DEFER.
> 
> - Lars
> 

-- 
