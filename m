Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967475Ab3HIKtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:49:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40871 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967122Ab3HIKtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:49:01 -0400
Date: Fri, 9 Aug 2013 11:48:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: DMA masks
Message-ID: <20130809104852.GQ23006@n2100.arm.linux.org.uk>
References: <m3fvujgrcr.fsf@t19.piap.pl> <20130809093506.GN23006@n2100.arm.linux.org.uk> <m3bo57gnks.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3bo57gnks.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 12:34:11PM +0200, Krzysztof Hałasa wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> >> struct device {
> >>         ...
> >> 
> >>         u64             *dma_mask;      /* dma mask (if dma'able device) */
> >> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > "If dma-able device" gives a clue.  It is now the case that the DMA API
> > refuses DMA (via dma_supported) if the DMA mask pointer is NULL.
> 
> But precisely the same effect can be obtained by setting the (actual)
> dma_mask to 0 (most preferably, using DMA API's dma_set_mask()).
> This is what coherent_dma_mask does.

No.  If dma_mask is NULL, then dma_set_mask() will return -EIO no matter
what.  If dma_mask is non-NULL, dma_set_mask() will succeed if the mask
is supported by the hardware.  For example, on x86:

int dma_set_mask(struct device *dev, u64 mask)
{
        if (!dev->dma_mask || !dma_supported(dev, mask))
                return -EIO;

        *dev->dma_mask = mask;

        return 0;
}
EXPORT_SYMBOL(dma_set_mask);

and this is the same pattern we implement on ARM.  So, a valid dma_mask
pointer pointing at a variable holding zero can have a supported mask
set.

> Things like this:
> 	pdev1->dev.dma_mask = &pdev1->dev.coherent_dma_mask;
> 	pdev1->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> (which are all over the place) make me wonder what happens when some
> code requires and tries to set different masks for normal and coherent
> DMA.

Have you looked at my massive dma-masks patch series earlier this week?
Obviously you haven't...

The separate coherent and streaming masks are only required for a very
small subset of devices (rather systems - non-ARM I add).  For the
general case, especially on ARM where the above pattern seems to be
very prevalent, this does not apply; the two masks are always the same.
Many people took the above shortcut, and while not strictly correct, it
is a work-around for the shortcoming in the core device code.

What my patch set does is pull all that out into a central place so that
rather than having to modify a continually growing number of drivers when
we've decided how we're going fix this, we can fix it in one place and
switch everyone over at the same time.  That may not be needed now that
Greg has agreed to having stream_dma_mask in the struct device, but
even so I think removing the direct initialization from drivers is a good
idea.

> > However, placing the storage for the dma_mask pointer into struct device
> > is something which I've recently discussed with Greg, and is something
> > he'd like to see happen, so I'll be adding that to my DMA masks patch
> > series in the very near future.
> 
> Does this mean the dma_mask would remain a pointer, but it would point
> (usually) to a variable in struct device?

Yes.
