Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab3KLPGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:06:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42692 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3KLPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:06:06 -0500
Date: Tue, 12 Nov 2013 15:05:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, konrad@kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH 2/2] swiotlb-xen: xen_swiotlb_map_page: do
	not error out if dma_capable fails
Message-ID: <20131112150540.GN16735@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1311121404590.26077@kaball.uk.xensource.com> <1384265520-6833-2-git-send-email-stefano.stabellini@eu.citrix.com> <20131112144832.GC9435@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112144832.GC9435@phenom.dumpdata.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 09:48:32AM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 12, 2013 at 02:12:00PM +0000, Stefano Stabellini wrote:
> > Many ARM devices do not set the dma_mask correctly today.
> > As a consequence dma_capable fails for them regardless of the address
> > passed to it.
> 
> Wouldn't the DMA API debug warn of bad usage.

No.  The problem is that dev->dma_mask is NULL, and that's generally
interpreted as "this device doesn't do DMA".

ARM drivers have been particularly bad in respect of getting this right:
there's an overwhelming problem here of "I don't need to do that so I'm
not going to do it" rather than taking the attitude of "it's good
practice to do X because it will save me hastles in the future".

I'll admit that even I'm guilty of the former in this regard to some
extent: I've not added the necessary dma_set_mask/dma_set_coherent_mask()
calls to the various drivers because they haven't been a concern.  That
was wrong, because the DMA API technically requires it.

However, not having a DMA mask set when the device is created is
something I'm not guilty of - I always ensured with the old board
files that a DMA capabable device had a DMA mask set and those which
weren't capable didn't: this causes the DMA API to behave correctly
and report according to the way the device was declared whether it is
DMA capable or not.

Unfortunately, others decided (especially post DT) that the solution
to this was to have the driver code - which could be modular - do things
like this:

static u64 mask = blah;

foo_probe(dev)
{
	if (!dev->dma_mask)
		dev->dma_mask = &mask;
}

which works nicely until you reload the module.

I strongly suggest _not_ working around this problem in subsystem code
but raising bug reports against the buggy drivers.  All drivers without
exception using DMA should have something like this pattern:

foo_probe(dev)
{
	int rc;

	rc = dma_set_mask(dev, DMA_BIT_MASK(bits));
	if (rc)
		return rc;
	dma_set_coherent_mask(dev, DMA_BIT_MASK(bits));
	...
}

The first call is required if the driver uses dma_map_*, the second call
is required if it makes use of coherent allocations and can be of the
above form if it's previously used dma_set_mask with the same mask.
Otherwise, the return value of dma_set_coherent_mask() must be checked.

Of course, dma_set_mask() will fail if dev->dma_mask is NULL - and that's
something which must be fixed where the device was created, not by the
driver.
