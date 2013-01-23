Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3AWRoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:44:21 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53765 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab3AWRoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:44:18 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-66-5100216f79bb
Message-id: <5100216E.1050104@samsung.com>
Date: Wed, 23 Jan 2013 18:44:14 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107
 Thunderbird/17.0.2
MIME-version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent() and
 dma_get_sgtable()
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
In-reply-to: <1358936986.2584.36.camel@dabdike.int.hansenpartnership.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xq7r5igyBBmvbNC06dn1lsbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlXlp5mLfhuVrHoflED4zXtLkZODgkBE4n/JxqZIWwx
	iQv31rN1MXJxCAksZZRYPKsRymlmkpj3qpkFpIpXQEti0ee3YB0sAqoSa3oXs4HYbAKGEl1v
	u8BsUYFQibX71jBD1AtK/Jh8D6xXRMBa4suqBYwgQ5kFrjNKbD8ymQkkISyQKHHywl4WiG0z
	WCUObtrO2sXIwcEp4CkxpbEMpIZZwEziUcs6ZghbXmLzmrfMExgFZiHZMQtJ2SwkZQsYmVcx
	iqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihATj1x2MS49ZHWIU4GBU4uF1XP0/QIg1say4MvcQ
	owQHs5IIbwYjQ6AQb0piZVVqUX58UWlOavEhRiYOTqkGxoXO7uXflxl1T9htmuOcXeyb/1ep
	v3Db/B3xqgYd95vMXjzTV76VudU2y23CG8uZdR/M95j/zPD/nyTwWOzu19L6/B3/O/v+/A1/
	ErtwxlwLKQUroa+3/JW7zf64Jedrc5rsqNQ90bLNKP2pdm5X3FsVxne/tDSv71mTxX0vd773
	be5ZP00PK7EUZyQaajEXFScCAHF3itYkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 1/23/2013 11:29 AM, James Bottomley wrote:
> On Wed, 2013-01-23 at 10:47 +0100, Marek Szyprowski wrote:
> > On 1/22/2013 11:13 AM, James Bottomley wrote:
> > > There might be a simple solution:  just replace void *cpu_addr with void
> > > **cpu_addr in the API.  This is a bit nasty since compilers think that
> > > void ** to void * conversion is quite legal, so it would be hard to pick
> > > up misuse of this (uint8_t ** would be better).  That way VIPT could
> > > remap the kernel pages to a coherent address.  This would probably have
> > > to change in the dma_mmap_attr() and dma_ops structures.
> > >
> > > All consumers would have to expect cpu_addr might change, but that seems
> > > doable.
> >
> > I still don't get how this can help having a coherent buffer between DMA
> > (devices) and CPU (kernel and user space mappings). The main purpose of
> > the dma_mmap_coherent() call is to provide a common API for mapping a
> > coherent buffer between DMA (device) and userspace. It is not about
> > creating a coherent mapping for sharing memory between userspace and
> > kernel space.
>
> OK, so I assume you don't understand how VIPT architectures work?
> On a VIPT architecture, the CPU cache is indexed by the virtual address
> but tagged by the physical address.  This means that when an address
> comes into the CPU, we can do simultaneous lookups in the cache and the
> TLB (by the virtual address).  The cache doesn't have the full address
> bits of the index, so it usually only looks up the lowest n bits.  The
> value of n gives the congruency of the cache (sometimes called the
> colour of the cache lines).  The cache usually produces a number of
> possible lines depending on its associativity and the TLB lookup
> produces the physical address.  We can now sweep through the cache lines
> and if a physical address tag matches, return the answer from the cache
> instead of having to consult main memory.  This gives a speed advantage
> over PIPT (Physically Indexed Physically Tagged) caches because on PIPT
> the cache lookup can only occur *after* the TLB lookup instead of
> concurrently with.
>
> As an aside, in practise every PIPT CPU actually has a VIPT cache,
> purely because of the speed angle.  The trick to making it all work is
> to shrink n so that n <= PAGE_SIZE_BITS and increase the associativity.
> This means you can get VIPT speed without producing the aliasing
> effects.
>
> Coherence is achieved in VIPT CPUs when two mapping addresses for the
> same physical page, say v1 and v2 are congruent i.e. (v1 & ((1<<n)-1))
> == (v2 & ((1<<n)-1)).  For such mappings, the same cache line is used.
> This is why we have an architecture override for
> arch_get_unmapped_area(). we use this to ensure all shareable mappings
> for all userspace process are at congruent addresses, so we don't get
> any aliasing problems in shared VMAs.
>
> Aliasing happens when v1 & ((1<<n)-1)) != (v2 & ((1<<n)-1)) where v1 and
> v2 are virtual addresses of the same physical page.  Now that page has
> *two* cache copies and you have to be very careful to resolve the
> aliases.  This, unfortunately, is the default scenario for kernel
> virtual and user virtual addresses because all kernel pages are offset
> mapped which is why we have to be annoyingly careful about flushing
> kernel pages before we hand control back to userspace.
>
> As you can see, we can only share a mapping between the kernel and user
> space without all the aliasing problems if the address is congruent.
>
> dma_mmap_coherent() seeks to be coherent from the device to the kernel
> to userspace.  On PARISC, we fix device coherency by loading a coherence
> index into our IOMMU (it effectively tells the IOMMU the virtual alias
> for the physical memory and allows the CPU cache to be managed as part
> of the I/O transaction).  The only way to prevent aliasing between the
> kernel and user space is to make the two addresses congruent.  We
> already have a fixed user address (given to us by the vma), so our only
> choice is to remap the page in the kernel to a congruent address and
> bingo we have a buffer shared between device/kernel/user space with no
> aliasing problems.
>
> The reason for making the cpu_addr mutable is to allow the
> implementation to remap the page and make full congruency happen.  We
> can't allow the kernel and userspace addresses to be non-congruent
> because kmap will fail horribly (it's required by the dma_buf_ops) and
> we also run the risk of getting a machine check if the cache discovers
> two dirty aliases of the same page.

I know what is VIPT, but I didn't know how device coherency is achieved on
PARISC and I wasn't aware that it is not possible to use non-cached 
mappings.
Now I have a complete image of this platform, thanks for you very detailed
description.

Now we need to find some working solution. This case shows that the current
DMA mapping API is quite limited and one day it will need complete rewrite.

Probably the best approach would be to change the API completely and
introduce some kind of DMA object with the following usage pattern:

dma_obj *buf = dma_alloc(dev, size, DMA_COHERENT | DMA_USERSPACE | 
DMA_KERNELSPACE, gfp);
if (!buf) {
     dma_addr_t dma_addr = dma_get_device_addr(buf);
     void *virt_addr = dma_get_kernel_addr(buf);
     ...

     dma_mmap_buf(buf, vma);
}

This way one can specify if kernel mapping or userspace mapping is required
for the given buffer or not.

This however requires a lot of work and update in all existing drivers. 
I doubt
that this can be done quickly without some period of transition and 
emulation of
the old api on top of the new one. It will also need a lot of discussion 
between
core kernel developers and a good proposal. I cannot promise that I will 
handle
this in any reasonable time frame now.

In meantime we need to live with the current design of dma_alloc_coherent do
something with dma_mmap_coherent. You have mentioned cpu_addr update in
dma_mmap_coherent, but frankly I don't like the '**cpu_addr' approach, as it
looks very hacky and it will end in various misusage in the drivers. API 
should
be clear and simple, but a function which updates the point clearly doesn't
meet this criteria.

I wonder if there will be any clients for the dma_mmap_* call on PARISC
(and other architectures which currently lack good way for mapping coherent
buffers to userspace). Currently there is no such driver. Maybe we can stick
with dummy implementation, which returns -EINVAL for now?

I think that the complete API redesign will be required one day. There 
are too
many limitations of the current API, which even now results in hacks and
workarounds in the drivers. We tried to avoid hacks in the drivers and 
update
the dma-mapping API, but it looks that this was only a top of the iceberg...

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


