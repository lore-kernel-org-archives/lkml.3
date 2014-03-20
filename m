Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbaCTSju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:39:50 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33083 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933332AbaCTSjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:39:48 -0400
Date: Thu, 20 Mar 2014 18:39:32 +0000
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
Message-ID: <20140320183932.GA7528@n2100.arm.linux.org.uk>
References: <201402241200.21944.arnd@arndb.de> <20140320173106.GA19395@obsidianresearch.com> <532B2628.5080305@codethink.co.uk> <201403201929.13633.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403201929.13633.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 07:29:13PM +0100, Arnd Bergmann wrote:
> On Thursday 20 March 2014, Ben Dooks wrote:
> > On 20/03/14 18:31, Jason Gunthorpe wrote:
> > > On Thu, Mar 20, 2014 at 06:25:25PM +0100, Ben Dooks wrote:
> > >> So doing:
> > >>
> > >> static void pci_rcar_fixup(struct pci_dev *dev)
> > >> {
> > >>      if (dev->bus->ops == &rcar_pci_ops) {
> > >>              dev_info(&dev->dev, "applying new dma mask\n");
> > >>              dev->dma_mask = DMA_BIT_MASK(31);
> > >>      }
> > >> }
> > >>
> > >> DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, pci_rcar_fixup);
> > >>
> > >> Did not work for me :(
> > >
> > > Seems like it should work, do you have CONFIG_PCI_QUIRKS turned on?
> > 
> > Yes, see the print happening, just still PCI OHCI dies horribly.
> 
> Shouldn't that mask be 30 instead of 31 when you only support DMA
> to the first GB?
> 
> Another possibility is that 'EARLY' means it gets applied before
> the normal mask is set.
> 
> Finally, setting the mask itself is not enough. As I mentioned you
> also need to use the swiotlb_dma_ops. Did you already implement
> those?

And the above is no way to handle the DMA mask - it will get
overwritten if the PCI device calls pci_set_dma_mask().  Please people,
read the documentation on how this stuff is supposed to work:

  For correct operation, you must interrogate the kernel in your device
  probe routine to see if the DMA controller on the machine can properly
  support the DMA addressing limitation your device has.  It is good
  style to do this even if your device holds the default setting,
  because this shows that you did think about these issues wrt. your
  device.

Yes, OHCI's PCI driver doesn't do that at the moment, but that's not
to say that it won't in the future - at which point hacks like the
above suddenly stop working.

We have other platforms which suffer from this - IXP is one of those
examples where PCI only has 64MB available.  The unfortunate thing is
we haven't yet got a good multi-platform way to handle dma_set_mask()
and dma_set_coherent_mask() with these kinds of restrictions.

However, the right solution here is that OHCI _should_ be making those
calls, and we _should_ be applying the platform specific fixups like
IXP does, but in a more generic way.  That includes using swiotlb
rather than dmabounce.

That all said, what I find most annoying is that Ben has ignored my
question about exactly what the nature of the limitation is on this
platform.  My response to that is - if you're not going to do the
curtesy of answering such a simple question, then you don't get to
patch the kernel for this problem.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
