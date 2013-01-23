Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3AWK3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:29:53 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54303 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390Ab3AWK3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:29:50 -0500
Message-ID: <1358936986.2584.36.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [Linux-c6x-dev] [PATCH 3/9] c6x: Provide dma_mmap_coherent()
 and dma_get_sgtable()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Salter <msalter@redhat.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>, linux-arch@vger.kernel.org,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org
Date: Wed, 23 Jan 2013 10:29:46 +0000
In-Reply-To: <50FFB19E.3020901@samsung.com>
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
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:47 +0100, Marek Szyprowski wrote:
> On 1/22/2013 11:13 AM, James Bottomley wrote:
> > There might be a simple solution:  just replace void *cpu_addr with void
> > **cpu_addr in the API.  This is a bit nasty since compilers think that
> > void ** to void * conversion is quite legal, so it would be hard to pick
> > up misuse of this (uint8_t ** would be better).  That way VIPT could
> > remap the kernel pages to a coherent address.  This would probably have
> > to change in the dma_mmap_attr() and dma_ops structures.
> >
> > All consumers would have to expect cpu_addr might change, but that seems
> > doable.
> 
> I still don't get how this can help having a coherent buffer between DMA
> (devices) and CPU (kernel and user space mappings). The main purpose of
> the dma_mmap_coherent() call is to provide a common API for mapping a
> coherent buffer between DMA (device) and userspace. It is not about
> creating a coherent mapping for sharing memory between userspace and
> kernel space.

OK, so I assume you don't understand how VIPT architectures work?

On a VIPT architecture, the CPU cache is indexed by the virtual address
but tagged by the physical address.  This means that when an address
comes into the CPU, we can do simultaneous lookups in the cache and the
TLB (by the virtual address).  The cache doesn't have the full address
bits of the index, so it usually only looks up the lowest n bits.  The
value of n gives the congruency of the cache (sometimes called the
colour of the cache lines).  The cache usually produces a number of
possible lines depending on its associativity and the TLB lookup
produces the physical address.  We can now sweep through the cache lines
and if a physical address tag matches, return the answer from the cache
instead of having to consult main memory.  This gives a speed advantage
over PIPT (Physically Indexed Physically Tagged) caches because on PIPT
the cache lookup can only occur *after* the TLB lookup instead of
concurrently with.

As an aside, in practise every PIPT CPU actually has a VIPT cache,
purely because of the speed angle.  The trick to making it all work is
to shrink n so that n <= PAGE_SIZE_BITS and increase the associativity.
This means you can get VIPT speed without producing the aliasing
effects.

Coherence is achieved in VIPT CPUs when two mapping addresses for the
same physical page, say v1 and v2 are congruent i.e. (v1 & ((1<<n)-1))
== (v2 & ((1<<n)-1)).  For such mappings, the same cache line is used.
This is why we have an architecture override for
arch_get_unmapped_area(). we use this to ensure all shareable mappings
for all userspace process are at congruent addresses, so we don't get
any aliasing problems in shared VMAs.

Aliasing happens when v1 & ((1<<n)-1)) != (v2 & ((1<<n)-1)) where v1 and
v2 are virtual addresses of the same physical page.  Now that page has
*two* cache copies and you have to be very careful to resolve the
aliases.  This, unfortunately, is the default scenario for kernel
virtual and user virtual addresses because all kernel pages are offset
mapped which is why we have to be annoyingly careful about flushing
kernel pages before we hand control back to userspace.

As you can see, we can only share a mapping between the kernel and user
space without all the aliasing problems if the address is congruent.

dma_mmap_coherent() seeks to be coherent from the device to the kernel
to userspace.  On PARISC, we fix device coherency by loading a coherence
index into our IOMMU (it effectively tells the IOMMU the virtual alias
for the physical memory and allows the CPU cache to be managed as part
of the I/O transaction).  The only way to prevent aliasing between the
kernel and user space is to make the two addresses congruent.  We
already have a fixed user address (given to us by the vma), so our only
choice is to remap the page in the kernel to a congruent address and
bingo we have a buffer shared between device/kernel/user space with no
aliasing problems.

The reason for making the cpu_addr mutable is to allow the
implementation to remap the page and make full congruency happen.  We
can't allow the kernel and userspace addresses to be non-congruent
because kmap will fail horribly (it's required by the dma_buf_ops) and
we also run the risk of getting a machine check if the cache discovers
two dirty aliases of the same page.

James


