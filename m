Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab3DZJmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:42:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39160 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab3DZJmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:42:52 -0400
Date: Fri, 26 Apr 2013 10:41:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        magnus.p.persson@stericsson.com
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though
	dma_slave_config()
Message-ID: <20130426094123.GG14496@n2100.arm.linux.org.uk>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <CACRpkdbFgW6bGYt59WtN4r2izuN09AJw4J1cqir82uzFsuMmWQ@mail.gmail.com> <20130425134402.GN4623@gmail.com> <201304251611.39667.arnd@arndb.de> <CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com> <20130426081646.GD24632@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426081646.GD24632@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 01:46:46PM +0530, Vinod Koul wrote:
> On Fri, Apr 26, 2013 at 10:28:39AM +0200, Linus Walleij wrote:
> > On Thu, Apr 25, 2013 at 4:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > The dma engine driver must know the address in its dma space, while the
> > > slave driver has it available in physical space. These two are often the
> > > same, but there is no generic way to convert between the two, especially
> > > if the dma engine resides behind an IOMMU.
> > >
> > > The best assumption we can make is that the dma engine driver knows
> > > how to convert between the two. Interestingly the documentation for
> > > dma_slave_config talks about "physical address", while the structure
> > > itself uses a dma_addr_t. Linus Walleij introduced the structure in
> > > c156d0a5b0 "DMAENGINE: generic slave channel control v3", so I assume
> > > he can shed some light on what he was thinking. I assume the documentation
> > > is right but the structure is not and should be converted to use
> > > phys_add_t or resource_size_t.
> > 
> > OK I could cook a patch for that, but I think I need some input from
> > Vinod and/or Russell on this.
> the dma_slave_config is physical address that should be passed directly to the
> controller. Obviosuly it should phys_addr_t :)

What you've just said is actually confusing.

"physical address" is normally the term used to describe the addresses
seen to the RAM.  phys_addr_t describes this.  This is not necessarily
what needs to be programmed into the DMA controller.

For RAM addresses, they must be mapped via the DMA API - and this gives
you a dma_addr_t.

"DMA address" is the address to be programmed into a DMA controller to
access a particular address in RAM or device, and has type dma_addr_t.
When you're programming a DMA controller to access a device, you are
clearly telling it the address on the _DMA controller's bus_ to access
that register, which may or may not be the same as the physical address.

There are platforms in existence where phys_addr_t can be 32-bit but
dma_addr_t can be 64-bit.  Getting this stuff wrong can cause problems.
