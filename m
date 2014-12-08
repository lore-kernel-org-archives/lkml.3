Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaLHQrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:47:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45524 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756008AbaLHQri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:47:38 -0500
Date: Mon, 8 Dec 2014 16:47:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Hante Meuleman <meuleman@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>, hauke@hauke-m.de
Subject: Re: using DMA-API on ARM
Message-ID: <20141208164719.GG11285@n2100.arm.linux.org.uk>
References: <5481794E.4050406@broadcom.com>
 <2863746.4sUSEYqahB@wuerfel>
 <5485D054.7090109@broadcom.com>
 <2048819.2EPzBi8E3T@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2048819.2EPzBi8E3T@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 05:38:57PM +0100, Arnd Bergmann wrote:
> On Monday 08 December 2014 17:22:44 Arend van Spriel wrote:
> > >> The log: first the ring allocation info is printed. Starting at
> > >> 16.124847, ring 2, 3 and 4 are rings used for device to host. In this
> > >> log the failure is on a read of ring 3. Ring 3 is 1024 entries of each
> > >> 16 bytes. The next thing printed is the kernel page tables. Then some
> > >> OpenWRT info and the logging of part of the connection setup. Then at
> > >> 1780.130752 the logging of the failure starts. The sequence number is
> > >> modulo 253 with ring size of 1024 matches an "old" entry (read 40,
> > >> expected 52). Then the different pointers are printed followed by
> > >> the kernel page table. The code does then a cache invalidate on the
> > >> dma_handle and the next read the sequence number is correct.
> > >
> > > How do you invalidate the cache? A dma_handle is of type dma_addr_t
> > > and we don't define an operation for that, nor does it make sense
> > > on an allocation from dma_alloc_coherent(). What happens if you
> > > take out the invalidate?
> > 
> > dma_sync_single_for_cpu(, DMA_FROM_DEVICE) which ends up invalidating 
> > the cache (or that is our suspicion).
> 
> I'm not sure about that:
> 
> static void arm_dma_sync_single_for_cpu(struct device *dev,
>                 dma_addr_t handle, size_t size, enum dma_data_direction dir)
> {
>         unsigned int offset = handle & (PAGE_SIZE - 1);
>         struct page *page = pfn_to_page(dma_to_pfn(dev, handle-offset));
>         __dma_page_dev_to_cpu(page, offset, size, dir);
> }
> 
> Assuming a noncoherent linear (no IOMMU, no swiotlb, no dmabounce) mapping,
> dma_to_pfn will return the correct pfn here, but pfn_to_page will return a
> page pointer into the kernel linear mapping, which is not the same
> as the pointer you get from __alloc_remap_buffer(). The pointer that
> was returned from dma_alloc_coherent is a) non-cachable, and b) not the
> same that you flush here.

Having looked up the details of the Cortex CPU TRMs:

1. The caches are PIPT.
2. A non-cacheable mapping will not hit L1 cache lines which may be
   allocated against the same physical address.  (This is implementation
   specific.)

So, the problem can't be the L1 cache, it has to be the L2 cache.

The L2 cache only deals with physical addresses, so it doesn't really
matter which mapping gets flushed - the result will be the same as far
as the L2 cache is concerned.

If bit 22 is not set in the auxcr, then a non-cacheable access can hit
a cache line which may be allocated in the L2 cache (which may have
been allocated via a speculative prefetch via the cacheable mapping.)

In the case which has been supplied, the physical address does indeed
have two mappings: it has a lowmem mapping which is cacheable, and it
has the DMA mapping which is marked as non-cacheable.  Accesses via
the non-cacheable mapping will not hit L1 (that's an implementation
specific behaviour.)  However, they may hit L2 if bit 22 is clear.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
