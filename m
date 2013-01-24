Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3AXLOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:14:41 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58275 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149Ab3AXLOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:14:25 -0500
Message-ID: <1359026060.2394.28.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent()
 and dma_get_sgtable()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Date: Thu, 24 Jan 2013 11:14:20 +0000
In-Reply-To: <5100216E.1050104@samsung.com>
References: <1358073890-3610-1-git-send-email-geert@linux-m68k.org>
	 <1358073890-3610-3-git-send-email-geert@linux-m68k.org>
	 <1358177872.4357.53.camel@t520.localdomain> <50F4D83A.7020803@synopsys.com>
	 <CAMuHMdWjZAY19GPpjoXKfWb3pOp2RbZXDvb4nr5pMmjEMFuB4w@mail.gmail.com>
	 <50F56286.8070200@samsung.com>
	 <1358269008.10591.11.camel@dabdike.int.hansenpartnership.com>
	 <CAMuHMdXk1mdkMViYqypvnXO0_1LdjbH8S7z8FNe97yDUW6BYRA@mail.gmail.com>
	 <1358809159.3975.63.camel@dabdike.int.hansenpartnership.com>
	 <1358849633.2387.11.camel@dabdike.int.hansenpartnership.com>
	 <50FFB19E.3020901@samsung.com>
	 <1358936986.2584.36.camel@dabdike.int.hansenpartnership.com>
	 <5100216E.1050104@samsung.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2013-01-23 at 18:44 +0100, Marek Szyprowski wrote:
> On 1/23/2013 11:29 AM, James Bottomley wrote:
> > On Wed, 2013-01-23 at 10:47 +0100, Marek Szyprowski wrote:
> > > On 1/22/2013 11:13 AM, James Bottomley wrote:
> > > > There might be a simple solution:  just replace void *cpu_addr with void
> > > > **cpu_addr in the API.  This is a bit nasty since compilers think that
> > > > void ** to void * conversion is quite legal, so it would be hard to pick
> > > > up misuse of this (uint8_t ** would be better).  That way VIPT could
> > > > remap the kernel pages to a coherent address.  This would probably have
> > > > to change in the dma_mmap_attr() and dma_ops structures.
> > > >
> > > > All consumers would have to expect cpu_addr might change, but that seems
> > > > doable.
> > >
> > > I still don't get how this can help having a coherent buffer between DMA
> > > (devices) and CPU (kernel and user space mappings). The main purpose of
> > > the dma_mmap_coherent() call is to provide a common API for mapping a
> > > coherent buffer between DMA (device) and userspace. It is not about
> > > creating a coherent mapping for sharing memory between userspace and
> > > kernel space.
> >
> > OK, so I assume you don't understand how VIPT architectures work?
> > On a VIPT architecture, the CPU cache is indexed by the virtual address
> > but tagged by the physical address.  This means that when an address
> > comes into the CPU, we can do simultaneous lookups in the cache and the
> > TLB (by the virtual address).  The cache doesn't have the full address
> > bits of the index, so it usually only looks up the lowest n bits.  The
> > value of n gives the congruency of the cache (sometimes called the
> > colour of the cache lines).  The cache usually produces a number of
> > possible lines depending on its associativity and the TLB lookup
> > produces the physical address.  We can now sweep through the cache lines
> > and if a physical address tag matches, return the answer from the cache
> > instead of having to consult main memory.  This gives a speed advantage
> > over PIPT (Physically Indexed Physically Tagged) caches because on PIPT
> > the cache lookup can only occur *after* the TLB lookup instead of
> > concurrently with.
> >
> > As an aside, in practise every PIPT CPU actually has a VIPT cache,
> > purely because of the speed angle.  The trick to making it all work is
> > to shrink n so that n <= PAGE_SIZE_BITS and increase the associativity.
> > This means you can get VIPT speed without producing the aliasing
> > effects.
> >
> > Coherence is achieved in VIPT CPUs when two mapping addresses for the
> > same physical page, say v1 and v2 are congruent i.e. (v1 & ((1<<n)-1))
> > == (v2 & ((1<<n)-1)).  For such mappings, the same cache line is used.
> > This is why we have an architecture override for
> > arch_get_unmapped_area(). we use this to ensure all shareable mappings
> > for all userspace process are at congruent addresses, so we don't get
> > any aliasing problems in shared VMAs.
> >
> > Aliasing happens when v1 & ((1<<n)-1)) != (v2 & ((1<<n)-1)) where v1 and
> > v2 are virtual addresses of the same physical page.  Now that page has
> > *two* cache copies and you have to be very careful to resolve the
> > aliases.  This, unfortunately, is the default scenario for kernel
> > virtual and user virtual addresses because all kernel pages are offset
> > mapped which is why we have to be annoyingly careful about flushing
> > kernel pages before we hand control back to userspace.
> >
> > As you can see, we can only share a mapping between the kernel and user
> > space without all the aliasing problems if the address is congruent.
> >
> > dma_mmap_coherent() seeks to be coherent from the device to the kernel
> > to userspace.  On PARISC, we fix device coherency by loading a coherence
> > index into our IOMMU (it effectively tells the IOMMU the virtual alias
> > for the physical memory and allows the CPU cache to be managed as part
> > of the I/O transaction).  The only way to prevent aliasing between the
> > kernel and user space is to make the two addresses congruent.  We
> > already have a fixed user address (given to us by the vma), so our only
> > choice is to remap the page in the kernel to a congruent address and
> > bingo we have a buffer shared between device/kernel/user space with no
> > aliasing problems.
> >
> > The reason for making the cpu_addr mutable is to allow the
> > implementation to remap the page and make full congruency happen.  We
> > can't allow the kernel and userspace addresses to be non-congruent
> > because kmap will fail horribly (it's required by the dma_buf_ops) and
> > we also run the risk of getting a machine check if the cache discovers
> > two dirty aliases of the same page.
> 
> I know what is VIPT, but I didn't know how device coherency is achieved on
> PARISC and I wasn't aware that it is not possible to use non-cached 
> mappings.

It is possible on most ... we have a couple of chips that can't do it
because of some architectural issue.

> Now I have a complete image of this platform, thanks for you very detailed
> description.
> 
> Now we need to find some working solution. This case shows that the current
> DMA mapping API is quite limited and one day it will need complete rewrite.
> 
> Probably the best approach would be to change the API completely and
> introduce some kind of DMA object with the following usage pattern:
> 
> dma_obj *buf = dma_alloc(dev, size, DMA_COHERENT | DMA_USERSPACE | 
> DMA_KERNELSPACE, gfp);

DMA_USERSPACE doesn't really tell us anything useful here.  In order to
force userspace coherence, we need the vma (or the user virtual address)
passed in so we can work out what a coherent address in the kernel
should be.  We could use it as an indicator that the handle should be
removed from the offset map, I suppose.

> if (!buf) {

I think you mean if(buf)

>      dma_addr_t dma_addr = dma_get_device_addr(buf);
>      void *virt_addr = dma_get_kernel_addr(buf);

So this isn't right.  To get congruence we need to remap the kernel page
to and address congruent with the userspace vma, so this would probably
have to take a vma as an argument and have 'kmap' somewhere in the API
prototype

So something like

    dma_addr_t dma_addr = dma_get_device_addr(buf);
    void *virt_addr = dma_kmap_kernel_addr(buf, vma);

We don't explicitly need the vma, we could easily make do with the vma
virtual address, so this could be something like

    void *virt_addr = dma_kmap_kernel_addr(buf, vaddr);

The easiest case for us is doing the alloc and mmap at the same time,
because that way we have all the required information to ascertain the
congruence address and do the remap before the kernel ever sees the
object.

>      ...
> 
>      dma_mmap_buf(buf, vma);
> }
> 
> This way one can specify if kernel mapping or userspace mapping is required
> for the given buffer or not.
> 
> This however requires a lot of work and update in all existing drivers. 
> I doubt
> that this can be done quickly without some period of transition and 
> emulation of
> the old api on top of the new one. It will also need a lot of discussion 
> between
> core kernel developers and a good proposal. I cannot promise that I will 
> handle
> this in any reasonable time frame now.
> 
> In meantime we need to live with the current design of dma_alloc_coherent do
> something with dma_mmap_coherent. You have mentioned cpu_addr update in
> dma_mmap_coherent, but frankly I don't like the '**cpu_addr' approach, as it
> looks very hacky and it will end in various misusage in the drivers. API 
> should
> be clear and simple, but a function which updates the point clearly doesn't
> meet this criteria.
> 
> I wonder if there will be any clients for the dma_mmap_* call on PARISC
> (and other architectures which currently lack good way for mapping coherent
> buffers to userspace). Currently there is no such driver. Maybe we can stick
> with dummy implementation, which returns -EINVAL for now?

Well, that's what lead me to ask the question whether this should be
architecture dependent.  It looks like the only drivers using this are
either SoC or v4l2 SoC type using dma-contig.

I think the best way forward would be to fix ARCH_HAS_DMA_MMAP_COHERENT
and cause a compile break if someone tries to build a driver which
requires this.  Under the current theory that they're all SoC and ARM,
they should not be buildable for PARISC (so allmodconfig and
allyesconfig should be currently safe).  This will allow us to get a
signal if that rule gets broken.

> I think that the complete API redesign will be required one day. There 
> are too
> many limitations of the current API, which even now results in hacks and
> workarounds in the drivers. We tried to avoid hacks in the drivers and 
> update
> the dma-mapping API, but it looks that this was only a top of the iceberg...

Well possibly.  A lot of it comes to us via the separate alloc and map,
which means we have to change kernel virtual address.

James


