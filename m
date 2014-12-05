Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaLEMY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:24:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45215 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaLEMYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:24:25 -0500
Date: Fri, 5 Dec 2014 12:24:23 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arend van Spriel <arend@broadcom.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205122423.GK1630@arm.com>
References: <5481794E.4050406@broadcom.com>
 <20141205094507.GP11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205094507.GP11285@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 09:45:08AM +0000, Russell King - ARM Linux wrote:
> On Fri, Dec 05, 2014 at 10:22:22AM +0100, Arend van Spriel wrote:
> > For our brcm80211 development we are working on getting brcmfmac driver
> > up and running on a Broadcom ARM-based platform. The wireless device is
> > a PCIe device, which is hooked up to the system behind a PCIe host
> > bridge, and we transfer information between host and device using a
> > descriptor ring buffer allocated using dma_alloc_coherent(). We mostly
> > tested on x86 and seen no issue. However, on this ARM platform
> > (single-core A9) we detect occasionally that the descriptor content is
> > invalid. When this occurs we do a dma_sync_single_for_cpu() and this is
> > retried a number of times if the problem persists. Actually, found out
> > that someone made a mistake by using virt_to_dma(va) to get the
> > dma_handle parameter. So probably we only provided a delay in the retry
> > loop. After fixing that a single call to dma_sync_single_for_cpu() is
> > sufficient. The DMA-API-HOWTO clearly states that:
> > 
> > """
> > the hardware should guarantee that the device and the CPU can access the
> > data in parallel and will see updates made by each other without any
> > explicit software flushing.
> > """
> > 
> > So it seems incorrect that we would need to do a dma_sync for this
> > memory. That we do need it seems like this memory can end up in
> > cache(?), or whatever happens, in some rare condition. Is there anyway
> > to investigate this situation either through DMA-API or some low-level
> > ARM specific functions.
> 
> It's been a long while since I looked at the code, and the code for
> dma_alloc_coherent() has completely changed since then with the
> addition of CMA.  I'm afraid that anything I would say about it would
> not be accurate without research into the possible paths through that
> code - it's no longer just a simple allocator.
> 
> What you say is correct however: the memory should not have any cache
> lines associated with it, if it does, there's a bug somewhere.
> 
> Also, the memory will be weakly ordered, which means that writes to such
> memory can be reordered.  If ordering matters, barriers should be used.
> rmb() and wmb() can be used for this.
> 
> (Added Marek for comment on dma_alloc_coherent(), Will for comment on
> barrier stuff.)

I'm not quite clear on the issue being seen here: is this on write from
the CPU to the descriptor ring, or the other way around (or both?).

Either way, you need barriers on the CPU side to ensure ordering of
accesses to the buffer. rmb/wmb will work, but are heavier than what you
need (relaxed versions have been proposed on LKML recently).

Will
