Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3KRBvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:51:12 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55226 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab3KRBvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:51:05 -0500
Message-ID: <1384739457.2050.28.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] aio: fix D-cache aliasing issues
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: John David Anglin <dave.anglin@bell.net>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>, Simon Baatz <gmbnomis@gmail.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Date: Sun, 17 Nov 2013 17:50:57 -0800
In-Reply-To: <BLU0-SMTP3886F78E435CD570327E2797E40@phx.gbl>
References: <20131115220529.GA3160@ls3530.box>
	 <1384555325.2003.39.camel@dabdike.int.hansenpartnership.com>
	 <20131116200717.GA18939@schnuecks.de> <20131116200959.GA14098@kvack.org>
	 <528933BC.50806@gmx.de>
	 <1384724973.2050.14.camel@dabdike.int.hansenpartnership.com>
	 <20131117234707.GA25545@p100.box>
	 <1384735922.2050.21.camel@dabdike.int.hansenpartnership.com>
	 <BLU0-SMTP3886F78E435CD570327E2797E40@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 20:15 -0500, John David Anglin wrote:
> On 17-Nov-13, at 7:52 PM, James Bottomley wrote:
> 
> >> +void flush_user_dcache_page(struct page *page);
> >> +
> >
> > The split into flush_kernel.. and flush_user.. is pointless.  We  
> > have no
> > use for a flush_user_.. API because it's not part of the standard  
> > linux
> > one.  Plus it's going to confuse those who come after us no end  
> > because
> > now we're different from every other architecture.
> 
> I introduced it because it seemed to be what was needed on parisc when
> we map a kernel page on PA8800/PA8900.  We need this to ensure what the
> kernel sees is up to date and also to ensure that we don't create  
> inequivalent
> aliases between the user and kernel mappings.
> 
> >
> >> #define flush_kernel_dcache_range(start,size) \
> >> 	flush_kernel_dcache_range_asm((start), (start)+(size));
> >> /* vmap range flushes and invalidates.  Architecturally, we don't  
> >> need
> >> @@ -125,18 +127,27 @@ flush_anon_page(struct vm_area_struct *vma,  
> >> struct page *page, unsigned long vma
> >> void mark_rodata_ro(void);
> >> #endif
> >>
> >> -#ifdef CONFIG_PA8X00
> >> -/* Only pa8800, pa8900 needs this */
> >> -
> >> #include <asm/kmap_types.h>
> >>
> >> #define ARCH_HAS_KMAP
> >>
> >> -void kunmap_parisc(void *addr);
> >> +static inline void kmap_parisc(struct page *page)
> >> +{
> >> +	if (parisc_requires_coherency())
> >> +		flush_user_dcache_page(page);
> >> +}
> >
> > No ... if we're genuinely moving coherency into kmap/kunmap, this  
> > has to
> > become
> >
> > 	flush_dcache_page(page);
> >
> > unconditionally.
> 
> There are two things about flush_dcache_page(page):
> 
> 1) The flush could be deferred.  I don't think we want that.

Our deferred flush logic seems a bit bogus to me.  We set a flag that
causes a kernel page flush in invalidate_kernel_vmap_range().  However,
when that function is called we checked this on a page by page bases and
if set we flush the page then we then go and do a dcache flush on the
entire range ... that's got to be wrong.  I also can't really see what
the check for mapping && !mapping_mapped() is about.  Mapping != NULL
means shared mappings with user space !mapping_mapped() means no file
backing (so they must be some form of anonymous vma).  Even if we got
the deferred logic right, I don't think we can avoid flushing in the
anon_vma case

> 2) It seems to unnecessarily call flush_kernel_dcache_page().

Remember flush on parisc is flush and invalidate.  We do need to
invalidate the kernel page in flush_dcache_page() just in case there are
any read only speculated cache lines above it.  I agree there shouldn't
be any dirty cache lines above it in kernel space.

James


