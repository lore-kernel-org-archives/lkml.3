Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3KRAwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 19:52:16 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55097 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab3KRAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 19:52:04 -0500
Message-ID: <1384735922.2050.21.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Simon Baatz <gmbnomis@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, John David Anglin <dave.anglin@bell.net>
Date: Sun, 17 Nov 2013 16:52:02 -0800
In-Reply-To: <20131117234707.GA25545@p100.box>
References: <20131115220529.GA3160@ls3530.box>
	 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
	 <20131116200717.GA18939@schnuecks.de> <20131116200959.GA14098@kvack.org>
	 <528933BC.50806@gmx.de>
	 <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com>
	 <20131117234707.GA25545@p100.box>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 00:47 +0100, Helge Deller wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com>:
> > On Sun, 2013-11-17 at 22:23 +0100, Helge Deller wrote:
> > > On 11/16/2013 09:09 PM, Benjamin LaHaise wrote:
> > > > On Sat, Nov 16, 2013 at 09:07:18PM +0100, Simon Baatz wrote:
> > > >> On Fri, Nov 15, 2013 at 02:42:05PM -0800, James Bottomley wrote:
> > > >>> On Fri, 2013-11-15 at 23:05 +0100, Helge Deller wrote:
> > > >>>> When a user page mapping is released via kunmap*() functions, the D-cache needs
> > > >>>> to be flushed via flush_dcache_page() to avoid D-cache aliasing issues.
> > > >>>>
> > > >>>> This patch fixes aio on the parisc platform (and probably others).
> > > >>>
> > > >>> This should be flush_kernel_dcache_page().  flush_dcache_page() is for
> > > >>> full coherency but for unmap, we know the page was coherent going in and
> > > >>> may have been modified by the kernel, so only the kernel view needs to
> > > >>> be sync'd.  Technically, by the kernel API, the flush should be done
> > > >>> *before* unmapping.  This would have mattered on parisc until we did
> > > >>> flush via tmpalias which means we no-longer care if the mapping for the
> > > >>> flush exists or not because we always recreate it via the tmpalias
> > > >>> pages.
> > > >>
> > > >> On ARM, flush_kernel_dcache_page() actually assumes that the page is
> > > >> mapped.  It avoids double flushing of highmem pages by not flushing
> > > >> in those cases where kunmap_atomic() already takes care of flushing.
> > > > 
> > > > Helge -- are you going to resubmit a version of this patch that makes the 
> > > > recommended change?
> > > 
> > > Sure, I'll do. May need some time for testing the various machine types though.
> > > Maybe in the end you can drop my patch since we might be able to fix it in the 
> > > parisc arch code.
> > > 
> > > @James, Dave: The patch I sent here was not used on the C8000. The C8000 (PA8800)
> > > works out of the box (and it uses the flush_kernel_dcache_page() function which
> > > is provided by kunmap()). It seems we require the flush_kernel_dcache_page() on
> > > the other machines too?
> > 
> > Well, this is why I think our in-kernel API (not the parisc one) for
> > kmap/kunmap is faulty.  I can't see any valid use of kmap/kunmap where
> > you don't need to flush. 
> 
> Maybe adding a flag to kmap(), e.g. READ_ONLY, WRITE_ONLY or similiar? 
> 
> > Either you kmapped for reading, in which case
> > you need to flush user space before the kernel access, or you kmapped
> > for writing, in which case you need to flush user space just before
> > mapping (eliminate any dirty user line) and the kernel cache before
> > unmap (so the modification becomes visible in main memory).
> 
> That's exactly what Dave told me in a private mail earlier.
> 
> Below is a patch to the parisc arch code which is originally from Dave.
> I only changed kunmap_parisc() to always call
> flush_kernel_dcache_page_addr(addr) - independend if we are on a PA8800/8900
> CPU or not - which is what you proposed in your original mail.
> And yes, this flush_kernel_dcache_page() fixes the aio problems
> on all my machines (32- and 64bit kernels, PA7300LC, PA8700, ...).
> 
> 
> >  I could see
> > an argument that flushing all the user mappings is expensive so only do
> > it if necessary, but I think it looks to be always necessary: even if
> > you're writing only, which means purging the lines above the user
> > mappings, most hardware will panic (HPMC) if it sees inequivalent
> > aliases with clashing dirty lines.
> 
> 
> 
> diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
> index f0e2784..ce6d605 100644
> --- a/arch/parisc/include/asm/cacheflush.h
> +++ b/arch/parisc/include/asm/cacheflush.h
> @@ -43,6 +43,8 @@ static inline void flush_kernel_dcache_page(struct page *page)
>  	flush_kernel_dcache_page_addr(page_address(page));
>  }
>  
> +void flush_user_dcache_page(struct page *page);
> +

The split into flush_kernel.. and flush_user.. is pointless.  We have no
use for a flush_user_.. API because it's not part of the standard linux
one.  Plus it's going to confuse those who come after us no end because
now we're different from every other architecture.

>  #define flush_kernel_dcache_range(start,size) \
>  	flush_kernel_dcache_range_asm((start), (start)+(size));
>  /* vmap range flushes and invalidates.  Architecturally, we don't need
> @@ -125,18 +127,27 @@ flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vma
>  void mark_rodata_ro(void);
>  #endif
>  
> -#ifdef CONFIG_PA8X00
> -/* Only pa8800, pa8900 needs this */
> -
>  #include <asm/kmap_types.h>
>  
>  #define ARCH_HAS_KMAP
>  
> -void kunmap_parisc(void *addr);
> +static inline void kmap_parisc(struct page *page)
> +{
> +	if (parisc_requires_coherency())
> +		flush_user_dcache_page(page);
> +}

No ... if we're genuinely moving coherency into kmap/kunmap, this has to
become

	flush_dcache_page(page);

unconditionally.

James


