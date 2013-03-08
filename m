Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3CHAvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:51:08 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45668 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab3CHAvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:51:07 -0500
X-AuditID: 9c930179-b7c78ae000000e4b-da-513935f7c0d4
Date: Fri, 8 Mar 2013 09:51:17 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: clean-up in order to reduce to call
 kmap_high_get()
Message-ID: <20130308005117.GB19010@lge.com>
References: <1362372609-877-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130307132623.GG17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307132623.GG17833@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Russell.

On Thu, Mar 07, 2013 at 01:26:23PM +0000, Russell King - ARM Linux wrote:
> On Mon, Mar 04, 2013 at 01:50:09PM +0900, Joonsoo Kim wrote:
> > In kmap_atomic(), kmap_high_get() is invoked for checking already
> > mapped area. In __flush_dcache_page() and dma_cache_maint_page(),
> > we explicitly call kmap_high_get() before kmap_atomic()
> > when cache_is_vipt(), so kmap_high_get() can be invoked twice.
> > This is useless operation, so remove one.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > index c7e3759..b7711be 100644
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -822,16 +822,16 @@ static void dma_cache_maint_page(struct page *page, unsigned long offset,
> >  		if (PageHighMem(page)) {
> >  			if (len + offset > PAGE_SIZE)
> >  				len = PAGE_SIZE - offset;
> > -			vaddr = kmap_high_get(page);
> > -			if (vaddr) {
> > -				vaddr += offset;
> > -				op(vaddr, len, dir);
> > -				kunmap_high(page);
> > -			} else if (cache_is_vipt()) {
> > -				/* unmapped pages might still be cached */
> > +			if (cache_is_vipt()) {
> 
> This should be:
> 			if (cache_is_vipt_nonaliasing())
> 
> to make it _explicit_ that this technique is only for non-aliasing VIPT
> caches (this doesn't work on any other of our cache types.)  Yes, I
> know we don't support highmem with VIPT aliasing caches - but still,
> we should ensure that this is self-documented in this code.
> 
> Same for arch/arm/mm/flush.c

Okay. I will re-work and will send v2 soon.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
