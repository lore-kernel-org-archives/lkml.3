Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaJULUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:20:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:7590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbaJULUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:20:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="403471232"
Date: Tue, 21 Oct 2014 16:13:20 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ray Jui <rjui@broadcom.com>, Dan Williams <dan.j.williams@intel.com>,
        Scott Branden <sbranden@broadcom.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl330: use subsys_initcall
Message-ID: <20141021104320.GK28745@intel.com>
References: <rjui@broadcom.com>
 <1413506896-4536-1-git-send-email-rjui@broadcom.com>
 <5440C929.9050906@metafoo.de>
 <20141017073535.GN1638@intel.com>
 <5440FA6B.6040303@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5440FA6B.6040303@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 01:15:55PM +0200, Lars-Peter Clausen wrote:
> On 10/17/2014 09:35 AM, Vinod Koul wrote:
> >On Fri, Oct 17, 2014 at 09:45:45AM +0200, Lars-Peter Clausen wrote:
> >>On 10/17/2014 02:48 AM, Ray Jui wrote:
> >>>As part of subsystem that many slave drivers depend on, it's more
> >>>appropriate for the pl330 DMA driver to be initialized at
> >>>subsys_initcall than device_initcall
> >>
> >>Well, we do have -EPROBE_DEFER these days to handle these kinds of
> >>dependencies so we no longer have to these kinds of manual init
> >>reordering tricks.
> >How ould that work?
> >
> >Consider for example SPI and dmanegine. SPI driver got probed, then to start
> >a transaction requested a channel... while dmaengine driver is still getting
> >probed/not probed yet. So SPI driver didnt get a channel.
> >
> 
> Ideally the SPI driver requests the channel in probe function and if
> the DMA controller is not yet probed returns EPROBE_DEFER. If the
> SPI driver requests the channel in the transfer handler it needs to
> deal with being able to fall back to non DMA transfers anyway so
> this shouldn't be a problem.
> 
> But in any case fiddling around with the init sequences is just a
> quick hack and might makes the problem less likely to appear in some
> cases, but there is no guarantee that it works. And I think the
> proper solution at the moment is to use probe deferral.
> 
> Other subsystems have seen patches which moved drivers from using
> subsys_initcall to device_initcall/module_..._driver/ with the
> reasoning that this is no longer necessary because of EPROBE_DEFER.
> So I don't think we should be doing the exact opposite in DMA
> framework. Also if we'd apply this patch it won't take to long until
> somebody suggest going back to module_platform_driver() instead of
> subsys_initcall.

Sure, I don't mind moving the driver to module_ if that solves the problem
with defer probe. I am still not able to wrap my head around on how will
deferral probe solve the problem, for example in above SPI case.

So when we request & channel is not found, it can be all that channels are
given out so nothing to give or controller of interest not available. How do
we distinguish between these and how does controller driver say "looks like
device might not be probed, let me try later"?

-- 
~Vinod

