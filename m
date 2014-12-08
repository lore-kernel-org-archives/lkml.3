Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaLHRtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:49:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46467 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaLHRtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:49:04 -0500
Date: Mon, 8 Dec 2014 17:48:50 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Miles MH Chen <orca.chen@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove GFP_DMA and GFP_DMA32 from flags before passing
 it into kmalloc.
Message-ID: <20141208174850.GR16185@e104818-lin.cambridge.arm.com>
References: <CAHkaATRAuo=Mh1tmMVDxnWeO8ARjW+KBfHNLpaFG3XxN5uY-hQ@mail.gmail.com>
 <983713E2-1EBC-45CC-8212-20FBFAA9AC0B@arm.com>
 <CAHkaATSUH=sKYJZ1NEM6-M8nCYPeqsU6v3JMBQbm_R=ykbkUjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHkaATSUH=sKYJZ1NEM6-M8nCYPeqsU6v3JMBQbm_R=ykbkUjg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 01:44:15AM +0100, Miles MH Chen wrote:
> On Sat, Sep 27, 2014 at 11:13 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On 27 Sep 2014, at 16:09, Miles MH Chen <orca.chen@gmail.com> wrote:
> >> Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
> >> ---
> >>  arch/arm64/mm/dma-mapping.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
> >> index 4164c5a..273cf6d 100644
> >> --- a/arch/arm64/mm/dma-mapping.c
> >> +++ b/arch/arm64/mm/dma-mapping.c
> >> @@ -103,7 +103,8 @@ static void *__dma_alloc_noncoherent(struct device *dev, size_t size,
> >>      ptr = __dma_alloc_coherent(dev, size, dma_handle, flags, attrs);
> >>      if (!ptr)
> >>          goto no_mem;
> >> -    map = kmalloc(sizeof(struct page *) << order, flags & ~GFP_DMA);
> >> +    map = kmalloc(sizeof(struct page *) << order,
> >> +                    flags & ~(GFP_DMA | GFP_DMA32));
> >
> > Do you have an explanation on why this is needed (and such explanation
> > should also be included in the commit log)? We don’t use ZONE_DMA32 on
> > arm64 (we did initially but it was for the wrong reasons).
> 
> If GFP_DMA32 is passed to dma_alloc_coherent, the flag will go to kmalloc and
> trigger a BUG_ON check in slab allocator:
> 
> __dma_alloc_noncoherent
> kmalloc
> new_slab  BUG_ON(flags & GFP_SLAB_BUG_MASK);
> 
> It can be avoided this by removing GFP_DMA32 before passing it to kmalloc
> or we should block GFP_DMA32 flag earlier in arch/arm64/dma-mapping.c if
> GFP_DMA32 is not allowed in arch/arm64/dma-mapping.c.

With commit d4932f9e81ae (arm64: add atomic pool for non-coherent and CMA
allocations), this fix is no longer needed. Prior to this we could
simply use GFP_KERNEL rather than masking out bits as we don't care
about atomic contexts prior to the commit I mentioned.

-- 
Catalin
