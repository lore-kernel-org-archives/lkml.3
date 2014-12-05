Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaLEPHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:07:06 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:39445 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920AbaLEPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:07:03 -0500
Date: Fri, 5 Dec 2014 15:06:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hante Meuleman <meuleman@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend Van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: using DMA-API on ARM
Message-ID: <20141205150648.GT11285@n2100.arm.linux.org.uk>
References: <5481794E.4050406@broadcom.com>
 <20141205094507.GP11285@n2100.arm.linux.org.uk>
 <20141205122423.GK1630@arm.com>
 <F51492713EF10846800D8C0ED37A7DCE019016E1@SJEXCHMB15.corp.ad.broadcom.com>
 <20141205132332.GS11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205132332.GS11285@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing more digging into the current DMA code, and I'm dismayed
to see that there's new bugs in it...

commit 513510ddba9650fc7da456eefeb0ead7632324f6
Author: Laura Abbott <lauraa@codeaurora.org>
Date:   Thu Oct 9 15:26:40 2014 -0700

    common: dma-mapping: introduce common remapping functions

This uses map_vm_area() to achieve the remapping of pages allocated inside
dma_alloc_coherent().  dma_alloc_coherent() is documented in a rather
round-about way in Documentation/DMA-API.txt:

| Part Ia - Using large DMA-coherent buffers
| ------------------------------------------
| 
| void *
| dma_alloc_coherent(struct device *dev, size_t size,
|                              dma_addr_t *dma_handle, gfp_t flag)
| 
| void
| dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
|                            dma_addr_t dma_handle)
| 
| Free a region of consistent memory you previously allocated.  dev,
| size and dma_handle must all be the same as those passed into
| dma_alloc_coherent().  cpu_addr must be the virtual address returned by
| the dma_alloc_coherent().
| 
| Note that unlike their sibling allocation calls, these routines
| may only be called with IRQs enabled.

Note that very last paragraph.  What this says is that it is explicitly
permitted to call dma_alloc_coherent() with IRQs disabled.

Now, the question is: is it safe to call map_vm_area() with IRQs disabled?
Well, map_vm_area() calls pud_alloc(), pmd_alloc(), and pte_alloc_kernel().
These functions all call into the kernel memory allocator *without*
GFP_ATOMIC - in other words, these allocations are permitted to sleep.
Except, IRQs are off, so it's a bug to call these functions from
dma_alloc_coherent().

Now, if we look at the previous code, it used ioremap_page_range().  This
has the same problem: it needs to allocate page tables, and it can only
do it via functions which may sleep.

If we go back even further, we find that the use of ioremap_page_range()
in dma_alloc_coherent() was introduced by:

commit e9da6e9905e639b0f842a244bc770b48ad0523e9
Author: Marek Szyprowski <m.szyprowski@samsung.com>
Date:   Mon Jul 30 09:11:33 2012 +0200

    ARM: dma-mapping: remove custom consistent dma region

which is the commit which removed my pre-allocated page tables for the
DMA re-mapping region - code which I explicitly had to specifically
avoid this issue.

Obviously, this isn't a big problem, because people haven't reported
that they've hit any of the might_sleep() checks in the memory
allocators, which I think is our only saving grace - but it's still
wrong to the specified calling conditions of the DMA API.

If the problem which you (Broadcom) are suffering from is down to the
issue I suspect (that being having mappings with different cache
attributes) then I'm not sure that there's anything we can realistically
do about that.  There's a number of issues which make it hard to see a
way forward.

One example is that if we allocate memory, we need to be able to change
(or remove) the cacheable mappings associated with that memory.  We'd
need to touch the L1 page table, either to change the attributes of the
section mapping, or to convert the section mapping to a L2 page table
pointer.  We need to change the attributes in a break-flush-make sequence
to avoid TLB conflicts.

However, those mappings may be shared between other CPUs in a SMP system.
So, we would need to flush the TLBs on other CPUs before we could proceed
to create replacement mappings.  That means something like stop_machine()
or sending (and waiting for completion) of an IPI to the other CPUs.  That
is totally impractical due to dma_alloc_coherent() being allowed to be
called with IRQs off.

I'll continue to think about it, but I don't see many possibilities to
satisfy dma_alloc_coherent()'s documented requirements other than by
pre-allocating a chunk of memory at boot time to be served out as
DMA-able memory for these horrid cases.

I don't see much point in keeping the map_vm_area() approach on ARM
even if we did fallback - if we're re-establishing mappings for
the surrounding pages in lowmem, we might as well insert appropriately
attributed mappings for the DMA memory as well.

On the face of it, it would be better to allocate one section at a
time, but my unfortunate experience is that 3.x kernels are a /lot/
more trigger happy with the OOM killer, and the chances of being able
to allocate 1MB of memory at a go after the system has been running
for a while is near-on impossible.  So I don't think that's a reality.

Even if we did break up section mappings in this way, it would also
mean that over time, we'd end up with much of lowmem mapped using 4K
page table entries, which would place significant pressure on the MMU
TLBs.

So, we might just be far better off pre-allocating enough "DMA
coherent" memory at boot time and be done with it.  Those who want
it dynamic can use CMA instead.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
