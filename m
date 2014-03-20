Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbaCTWvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:51:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33292 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759998AbaCTWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:51:10 -0400
Date: Thu, 20 Mar 2014 22:50:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: DMABOUNCE in pci-rcar
Message-ID: <20140320225048.GE7528@n2100.arm.linux.org.uk>
References: <201402241200.21944.arnd@arndb.de> <201403201929.13633.arnd@arndb.de> <20140320183932.GA7528@n2100.arm.linux.org.uk> <14479462.PmG77WeO2J@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14479462.PmG77WeO2J@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:11:04PM +0100, Arnd Bergmann wrote:
> On Thursday 20 March 2014 18:39:32 Russell King - ARM Linux wrote:
> > Yes, OHCI's PCI driver doesn't do that at the moment, but that's not
> > to say that it won't in the future - at which point hacks like the
> > above suddenly stop working.
> 
> If the OHCI-PCI driver is changed to call
> dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))), what do you
> think should happen? The way I read it, that call must fail on
> this platform, causing the probe() function to bail out and not
> use the hardware, which is clearly not what we want here.

That depends how you interpret what's going on here.  It's saying
"I may allocate and try and map memory which result in 32-bits
of DMA address".  Under normal situations where there is a 1:1
relationship and a simple mapping done by the DMA API, then yes,
such memory would end up with 32-bits of DMA address.

Now, if the DMA implementation has a way to cope with providing a
restricted DMA address to the device due to bus limitations which
the DMA implementation knows about, then the answer to "can you
cope with memory which would normally result in 32-bits of DMA
address" is yes, even if you can only handle 30 bits.

The reason being is that you're agreeing to the driver using
memory which would be 32-bits, but internally you're guaranteeing
not to violate the bus limitation of 30 bits.

Things get harder with the coherent API, and that's where IXP4xx
has to intercept the call and limit the coherent mask, so the
coherent allocator knows to restrict the memory returned - there's
no way that such memory could be fixed up after the fact.

> IXP uses defines a ixp4xx_pci_platform_notify() function that basically
> does the same thing that Ben tried adding here, and then it has a
> dma_set_coherent_mask function that checks whether the mask that the
> device tries to set is even smaller than that, in which case it returns
> a failure, but it returns success if the device tries to set a larger
> mask.

Yes, IXP has a two-pronged approach because of problem drivers like
OHCI which don't call the DMA mask setting functions.  If everyone
did, then the hooks in the mask setting functions would be all that
it needs, since it could apply its restriction there rather than via
notifiers.

So, what IXP does is it overrides dma_set_coherent_mask() to be a
function which just validates the mask, and doesn't actually allow
the mask to be changed.  This coupled with the notifier sets the
coherent mask to 64M, and ensures that it isn't changed (except by
buggy drivers which access it directly.)

An alternative approach for that would be to accept 64M or larger
masks in dma_set_coherent_mask() but always set the actual coherent
DMA mask to no larger than 64M - but that's only possible where all
drivers properly call dma_set_coherent_mask().

The streaming DMA mask has become more convoluted - it's now set
such that any device which has dmabounce attached to it will ignore
attempts to change the streaming DMA mask value - just like the
above.

> In no case does it try to actually set the mask. While this seems
> like a practical approach, I don't see how that actually matches up
> with the documentation, e.g. "dma_set_coherent_mask will always be able
> to set the same or a smaller mask as the streaming mask." and
> "When dma_set_mask() or dma_set_mask_and_coherent() is successful, and
> returns zero, the kernel saves away this mask you have provided."

IXP4xx used to conform - 6fee48cd330c:

-int
-pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-       if (mask >= SZ_64M - 1 )
-               return 0;
-
-       return -EIO;
-}
-    
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-       if (mask >= SZ_64M - 1 )
-               return 0;
-
-       return -EIO;
-}

Here, both functions have the same behaviour.  The bit about "smaller
mask" is slightly bogus - you can never set a mask that is smaller
than the system's DMA memory pool, because the system never has a way
to guarantee you memory below GFP_DMA allocations.  In this case on
IXP4xx, that is 64MB of memory, so thse functions reject on 64MB or
smaller allocations.

However, because of the bouncing that is implemented, it can accept
drivers asking for larger DMA masks, and because it limits the
coherent memory allocations to 64MB internally within the DMA API,
larger coherent masks are permissible.

So.. there's no problem here.  What is a problem is:

static int dmabounce_set_mask(struct device *dev, u64 dma_mask)
{
        if (dev->archdata.dmabounce)
                return 0;

        return arm_dma_ops.set_dma_mask(dev, dma_mask);
}

which says "I'll accept anything if I'm a DMA bounce-hindered device"
which isn't actually correct, since we should still be rejecting
masks smaller than the system can allocate for.

That's checked for by dma_supported() which should really be in 
the above.

The remaining gotcha for multiplatform is the coherent mask, which
doesn't have a way for it to be intercepted by the platform.  That
means any /good/ driver which calls dma_set_coherent_mask() results
in resetting the coherent mask to the driver specified mask.

> The majority of the platforms we support today are fine with
> always assuming that all of memory can be reached at the physical
> address,

That's only because they're now all fine with 32-bit addresses.

> and the exceptions are either the legacy non-multiplatform
> ones, or very new platforms with LPAE that can only be probed using
> devicetree.

Remember with LPAE and its strange memory setups, physical address !=
DMA address, and that's going to be something that everyone is going
to /have/ to learn to get used to.  No longer will it be possible to
assume that the two are the same, or you can just crop the bits above
32-bit off to make it fit in a 32-bit controller - consider 8G of
memory on LPAE with a 32-bit DMA controller.

That's where dealing with the DMA mask correctly (representing the number
of bits the /device/ can accept rather than the number of physical address
bits) matters, and thankfully that should now be solved.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
