Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbaCTWLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:11:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:62548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbaCTWLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:11:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Date: Thu, 20 Mar 2014 23:11:04 +0100
Message-ID: <14479462.PmG77WeO2J@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140320183932.GA7528@n2100.arm.linux.org.uk>
References: <201402241200.21944.arnd@arndb.de> <201403201929.13633.arnd@arndb.de> <20140320183932.GA7528@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CAe/PfZ0OsNBz6g3m1+xt79kE79FI/RCAzqoLhv5eb7
 p0vqJZMFHW5ZueX46JLOhm+BU+uVUFIzPp9WTeMFi3tLdbCttO
 DpNS9721LcdYikn/zkcS6xEIaAVbwbujeozY8EOjJexWf4Fqkz
 SNxD81Ae9j/miXslMHIrMomH0y+AT2To34vs5F1ZbXn8Cpma7b
 bRVmyCORzk+zVfexpUymqAZ2A7nh+32MLo57WIfElBCA7oKK2Q
 vYPWzhgVMDMZ3wRFwwSVS0ND56X1pSUxRyJWPSWGSJR/Z2W9gw
 yjYQRxBO2cNrQaGmcGzpQr2+YGF9F1FqEg63FVDpakKpXQOG8Q
 v1mt+MuSWZmGCUtT6UL4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 18:39:32 Russell King - ARM Linux wrote:
> On Thu, Mar 20, 2014 at 07:29:13PM +0100, Arnd Bergmann wrote:
> > On Thursday 20 March 2014, Ben Dooks wrote:

> > Shouldn't that mask be 30 instead of 31 when you only support DMA
> > to the first GB?
> > 
> > Another possibility is that 'EARLY' means it gets applied before
> > the normal mask is set.
> > 
> > Finally, setting the mask itself is not enough. As I mentioned you
> > also need to use the swiotlb_dma_ops. Did you already implement
> > those?
> 
> And the above is no way to handle the DMA mask - it will get
> overwritten if the PCI device calls pci_set_dma_mask().  Please people,
> read the documentation on how this stuff is supposed to work:
> 
>   For correct operation, you must interrogate the kernel in your device
>   probe routine to see if the DMA controller on the machine can properly
>   support the DMA addressing limitation your device has.  It is good
>   style to do this even if your device holds the default setting,
>   because this shows that you did think about these issues wrt. your
>   device.

The trouble is that in the documentation it is also assumed that
the bus can do 32-bit DMA, and only the device may have further
restrictions. Here it is the other way round: the device can do
32-bit DMA, but the bus is limited to 31-bit, and at least the
documentation does not say explicitly how that should be handled.

> Yes, OHCI's PCI driver doesn't do that at the moment, but that's not
> to say that it won't in the future - at which point hacks like the
> above suddenly stop working.

If the OHCI-PCI driver is changed to call
dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))), what do you
think should happen? The way I read it, that call must fail on
this platform, causing the probe() function to bail out and not
use the hardware, which is clearly not what we want here.

> We have other platforms which suffer from this - IXP is one of those
> examples where PCI only has 64MB available.  The unfortunate thing is
> we haven't yet got a good multi-platform way to handle dma_set_mask()
> and dma_set_coherent_mask() with these kinds of restrictions.
> 
> However, the right solution here is that OHCI _should_ be making those
> calls, and we _should_ be applying the platform specific fixups like
> IXP does, but in a more generic way.  That includes using swiotlb
> rather than dmabounce.

IXP uses defines a ixp4xx_pci_platform_notify() function that basically
does the same thing that Ben tried adding here, and then it has a
dma_set_coherent_mask function that checks whether the mask that the
device tries to set is even smaller than that, in which case it returns
a failure, but it returns success if the device tries to set a larger
mask. In no case does it try to actually set the mask. While this seems
like a practical approach, I don't see how that actually matches up
with the documentation, e.g. "dma_set_coherent_mask will always be able
to set the same or a smaller mask as the streaming mask." and
"When dma_set_mask() or dma_set_mask_and_coherent() is successful, and
returns zero, the kernel saves away this mask you have provided."

Once we have figured out what the code should actually do, I think
we can solve the question of how to do it for multiplatform. The
approach I would take here is to treat the legacy platforms with
special requirements the same way we do now -- we will never need
multiplatform support on ixp4xx,  CM-X255/CM-X270 or sa1111.
The majority of the platforms we support today are fine with
always assuming that all of memory can be reached at the physical
address, and the exceptions are either the legacy non-multiplatform
ones, or very new platforms with LPAE that can only be probed using
devicetree. I would think that we can support them all with the
same dma_set_mask/dma_set_coherent_mask implementation that
scans the DT for platform and PCI devices.

	Arnd
