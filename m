Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaFFPKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaFFPKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:10:01 -0400
Message-ID: <1402067373.15402.9.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
From: Mark Salter <msalter@redhat.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will.deacon@arm.com, steve.capper@linaro.org
Date: Fri, 06 Jun 2014 11:09:33 -0400
In-Reply-To: <20140606145324.GE4179@bivouac.eciton.net>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
	 <1402065449.15402.2.camel@deneb.redhat.com>
	 <20140606145324.GE4179@bivouac.eciton.net>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 15:53 +0100, Leif Lindholm wrote:
> On Fri, Jun 06, 2014 at 10:37:29AM -0400, Mark Salter wrote:
> > On Fri, 2014-06-06 at 11:29 +0100, Leif Lindholm wrote:
> > > __early_set_fixmap does not do any synchronization when called to set a
> > > fixmap entry. Add call to flush_vmap_cache().
> > > 
> > > Tested on hardware.
> > > 
> > > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > > Tested-by: Graeme Gregory <graeme.gregory@linaro.org>
> > > Cc: Steve Capper <steve.capper@linaro.org>
> > > ---
> > >  arch/arm64/mm/ioremap.c |    5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> > > index 7ec3283..5b8766c 100644
> > > --- a/arch/arm64/mm/ioremap.c
> > > +++ b/arch/arm64/mm/ioremap.c
> > > @@ -176,9 +176,10 @@ void __init __early_set_fixmap(enum fixed_addresses idx,
> > >  
> > >  	pte = early_ioremap_pte(addr);
> > >  
> > > -	if (pgprot_val(flags))
> > > +	if (pgprot_val(flags)) {
> > >  		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
> > > -	else {
> > > +		flush_cache_vmap(addr, addr + PAGE_SIZE);
> > > +	} else {
> > >  		pte_clear(&init_mm, addr, pte);
> > >  		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
> > >  	}
> > 
> > I'm confused by the commit message mentioning synchronization but
> > the code doing a cache flush. I see that arm64 implementation of
> > flush_cache_vmap() is just a dsb(). If it is synchronization that
> > we need here (and it certainly looks like we do), why not just add
> > the dsb() directly to make that clear?
> 
> It needs this Linux-semantically for the same reason remap_page_range
> needs it. From the ARM architectural point of view, the reason is that
> the translation table walk is considered a separate observer from the
> core data interface.
> 
> But since there is a common Linux semantic for this, I preferred
> reusing that over just throwing in a dsb(). My interpretation of
> flush_cache_vmap() was "flush mappings from cache, so they can be
> picked up by table walk". While we don't technically need to flush the
> cache here, the underlying requirement is the same.
> 

But the range you are flushing is not a range seen by the table walk
observer. I just think it is clearer to explicitly show that it is
the pte write which we want the table walk to see rather than to
rely on the implicit behavior of a cache flush routine.

>From Documentation/cachetlb.txt:

6) void flush_cache_vmap(unsigned long start, unsigned long end)
   void flush_cache_vunmap(unsigned long start, unsigned long end)

	Here in these two interfaces we are flushing a specific range
	of (kernel) virtual addresses from the cache.  After running,
	there will be no entries in the cache for the kernel address
	space for virtual addresses in the range 'start' to 'end-1'.

	The first of these two routines is invoked after map_vm_area()
	has installed the page table entries.  The second is invoked
	before unmap_kernel_range() deletes the page table entries.



