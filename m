Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3GMAO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:14:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36616 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab3GMAOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:14:55 -0400
Date: Sat, 13 Jul 2013 01:14:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC/RFT PATCH 4/5] ARM: mm: change max*pfn to include the
	physical offset of memory
Message-ID: <20130713001442.GL24642@n2100.arm.linux.org.uk>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <1373665694-7580-5-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373665694-7580-5-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 05:48:13PM -0400, Santosh Shilimkar wrote:
> Most of the kernel code assumes that max*pfn is maximum pfns because
> the physical start of memory is expected to be PFN0. Since this
> assumption is not true on ARM architectures, the meaning of max*pfn
> is number of memory pages. This is done to keep drivers happy which
> are making use of of these variable to calculate the dma bounce limit
> using dma_mask.
> 
> Now since we have a architecture override possibility for DMAable
> maximum pfns, lets make meaning of max*pfns as maximum pnfs on ARM
> as well.
> 
> In the patch, the dma_to_pfn/pfn_to_dma() pair is hacked to take care of
> the physical memory offset. It is done this way just to enable testing
> since its understood that it can come in way of single zImage.

As Santosh says, this is a hack - but we need to have a discussion about
how to handle translations from PFN to bus addresses.

Currently, the way we do that on ARM is mostly assume that physical
addresses are the same as bus addresses, but that's not true everywhere,
and certainly isn't true when you have a 32-bit DMA controller which
can access physical memory, where the physical memory is above 4GB
in physical space.

We have certain platforms where the DMA address is already being
programmed into a controller with less than 32-bits in its address
register, and with a physical memory offset - and of course this
case just works out of the box because the high bits are ignored
by the device.

What I'm basically saying is we've had this problem for a while, and
we've lived with it by hoping and hacking, and adjusting max*pfn, but
this is not long-term sustainable.  We *need* to get away from the
idea that DMA addresses are physical addresses and device DMA masks
have some relationship to physical addresses.

Consider for a moment:

	PCI address 0x00000000 ---> physical address 0xc0000000.

You plug a card in which can't do 32-bit addressing (remember, there
are such PCI cards in the past...).  The driver sets the DMA mask to
0x0fffffff (or whatever).  How does that relate to the PCI bus address?
It's 0x00000000 to 0x0fffffff.  How does that relate to the physical
address space?  0xc0000000 to 0xcfffffff.

This is why DMA masks can't be treated as some notional address limit.
It just doesn't work when you have bus offsets.

And the extreme case of that is LPAE with all system memory above the
4GB physical mark, with 32-bit DMA capable peripherals - which we're
starting to see now.

Ideally, I think we need some kind of per-bus DT property to describe
the memory which can be accessed from the bus - to do it properly to
cover the cases we've already seen, that would be an offset and a size.

We then need some way for dma_to_pfn() and pfn_to_dma() to efficiently
get at that information - bear in mind that they're hot paths when doing
DMA mappings and the like.  I doubt we want to be looking up the same
property time and time again inside them.
