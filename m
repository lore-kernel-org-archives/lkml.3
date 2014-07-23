Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaGWLNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:13:37 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55943 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaGWLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:13:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Ritesh Harjain <ritesh.harjani@gmail.com>,
        David Riley <davidriley@chromium.org>
Subject: Re: [PATCHv4 5/5] arm64: Add atomic pool for non-coherent and CMA allocations.
Date: Wed, 23 Jul 2014 13:12:45 +0200
Message-ID: <7974618.dpxEl8UzaM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722210352.GA10604@arm.com>
References: <1404324218-4743-1-git-send-email-lauraa@codeaurora.org> <201407222006.44666.arnd@arndb.de> <20140722210352.GA10604@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Fc4rXPLd+VHqZ8PPkIY0RHdzU2pK2ymNu533lb1rmbk
 Iyec3cV33kXekjP/77GLbXw0RzB+paG/WrCC2N0mT8dU2W/lXV
 yyn78yxOURBBwJk/gAPc/3Ok8BPVVlRKe+YqUL/LhM0W+lZscg
 EKocDyX/bY4HZoHUpEMEEg7sgHVbdGc+c6Qq12SIjIEovCdKR1
 wmG5/v0SA2AYYeP8OUMzrQqz1YdQkAhXQXgKe5X3eCE4Us52bA
 s/Ej1g9+jgLAt1mwueI9tyEL3+7kDOBzNua1zXqd7GEnCNpV8o
 TCZsfmITGuMuuV7cL1ePK+sO5MsqIJHOz70qtdhFnFinZ1ngT9
 4G0LhUedeTx7oOtReL9Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 22:03:52 Catalin Marinas wrote:
> On Tue, Jul 22, 2014 at 07:06:44PM +0100, Arnd Bergmann wrote:
> > On Wednesday 02 July 2014, Laura Abbott wrote:
> > > +       pgprot_t prot = __pgprot(PROT_NORMAL_NC);
> > > +       unsigned long nr_pages = atomic_pool_size >> PAGE_SHIFT;
> > > +       struct page *page;
> > > +       void *addr;
> > > +
> > > +
> > > +       if (dev_get_cma_area(NULL))
> > > +               page = dma_alloc_from_contiguous(NULL, nr_pages,
> > > +                                       get_order(atomic_pool_size));
> > > +       else
> > > +               page = alloc_pages(GFP_KERNEL, get_order(atomic_pool_size));
> > > +
> > > +
> > > +       if (page) {
> > > +               int ret;
> > > +
> > > +               atomic_pool = gen_pool_create(PAGE_SHIFT, -1);
> > > +               if (!atomic_pool)
> > > +                       goto free_page;
> > > +
> > > +               addr = dma_common_contiguous_remap(page, atomic_pool_size,
> > > +                                       VM_USERMAP, prot, atomic_pool_init);
> > > +
> > 
> > I just stumbled over this thread and noticed the code here: When you do
> > alloc_pages() above, you actually get pages that are already mapped into
> > the linear kernel mapping as cacheable pages. Your new
> > dma_common_contiguous_remap tries to map them as noncacheable. This
> > seems broken because it allows the CPU to treat both mappings as
> > cacheable, and that won't be coherent with device DMA.
> 
> It does *not* allow the CPU to treat both as cacheable. It treats the
> non-cacheable mapping as non-cacheable (and the cacheable one as
> cacheable). The only requirements the ARM ARM makes in this situation
> (B2.9 point 5 in the ARMv8 ARM):
> 
> - Before writing to a location not using the Write-Back attribute,
>   software must invalidate, or clean, a location from the caches if any
>   agent might have written to the location with the Write-Back
>   attribute. This avoids the possibility of overwriting the location
>   with stale data.
> - After writing to a location with the Write-Back attribute, software
>   must clean the location from the caches, to make the write visible to
>   external memory.
> - Before reading the location with a cacheable attribute, software must
>   invalidate the location from the caches, to ensure that any value held
>   in the caches reflects the last value made visible in external memory.
> 
> So we as long as the CPU accesses such memory only via the non-cacheable
> mapping, the only requirement is to flush the cache so that there are no
> dirty lines that could be evicted.

Ok, thanks for the explanation.

> (if the mismatched attributes were for example Normal vs Device, the
> Device guarantees would be lost but in the cacheable vs non-cacheable
> it's not too bad; same for ARMv7).

Right, that's probabably what I misremembered.

> > > +               if (!addr)
> > > +                       goto destroy_genpool;
> > > +
> > > +               memset(addr, 0, atomic_pool_size);
> > > +               __dma_flush_range(addr, addr + atomic_pool_size);
> > 
> > It also seems weird to flush the cache on a virtual address of
> > an uncacheable mapping. Is that well-defined?
> 
> Yes. According to D5.8.1 (Data and unified caches), "if cache
> maintenance is performed on a memory location, the effect of that cache
> maintenance is visible to all aliases of that physical memory location.
> These properties are consistent with implementing all caches that can
> handle data accesses as Physically-indexed, physically-tagged (PIPT)
> caches".

interesting.

> > In the CMA case, the
> > original mapping should already be uncached here, so you don't need
> > to flush it.
> 
> I don't think it is non-cacheable already, at least not for arm64 (CMA
> can be used on coherent architectures as well).

Ok, I see it now.

Sorry for all the confusion on my part.

	Arnd
