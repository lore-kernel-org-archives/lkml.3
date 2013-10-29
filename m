Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab3J2SDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:03:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41872 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3J2SDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:03:36 -0400
Date: Tue, 29 Oct 2013 18:01:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com,
        will.deacon@arm.com
Subject: Re: [PATCH v9 01/18] arm: make SWIOTLB available
Message-ID: <20131029180105.GR16735@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com> <1382698313-13161-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1310251206450.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1310290441260.26077@kaball.uk.xensource.com> <20131029142023.GE20487@phenom.dumpdata.com> <20131029142626.GQ16735@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1310291716120.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1310291716120.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 05:24:50PM +0000, Stefano Stabellini wrote:
> On Tue, 29 Oct 2013, Russell King - ARM Linux wrote:
> > This looks like a hack.  Either we want to use the streaming mask or
> > the coherent mask as appropriate for the caller.  That should be a choice
> > the caller makes, not the implementation of this behind the callers back.
> 
> How should I choose?
> Admittedly this is a workaround because some drivers (including Calxeda
> xgmac) don't set the dma_mask when they should:
> 
> http://marc.info/?l=linux-arm-kernel&m=138082570519601&w=2
> 
> I am happy to reduce this to:
> 
> if (dev->dma_mask)
>     mask = *dev->dma_mask;
> 
> even though it means that xgmac & co won't be dma_capable.

Well, if xgmac (there's two in the kernel tree so I'm not sure which
you're referring to) is using DMA of any kind, it really ought to be
setting a DMA mask via the standard functions - in todays kernel,
that is dma_set_mask() for the streaming mask and dma_set_coherent_mask()
for the coherent mask.  The appropriate mask which the driver is aware
of for the hardware should be set here.

In the case that a driver needs to call both, and the kernel has my
patch set applied, dma_set_mask_and_coherent() can be used to set both
at the same time.

dma_set_mask() (and dma_set_mask_and_coherent) will fail if storage for
the DMA mask has not been allocated previously - iow, if the dev->dma_mask
pointer is NULL.  The allocation of this storage is the responsibility
of the struct device creator, and the struct device creator should
initialise the DMA masks to a sensible default for the type of bus.

I provide one last call in my patch set - a method that drivers can
coerce the DMA mask to whatever they desire irrespective of whether
the DMA mask allocation has been setup.  This is provided as a way to
mark the drivers which are doing this and to ensure that drivers do
this in a safe manner - we've had drivers setting it to static storage
in module space if it isn't previously set, which is a problem if the
module ever gets unloaded.

So... what I'm saying is please fix xgmac to use the DMA API properly
rather than working around such problems. :)
