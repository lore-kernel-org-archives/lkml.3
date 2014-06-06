Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaFFOxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:53:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51214 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaFFOx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:53:29 -0400
Date: Fri, 6 Jun 2014 15:53:25 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will.deacon@arm.com, steve.capper@linaro.org
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140606145324.GE4179@bivouac.eciton.net>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402065449.15402.2.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 10:37:29AM -0400, Mark Salter wrote:
> On Fri, 2014-06-06 at 11:29 +0100, Leif Lindholm wrote:
> > __early_set_fixmap does not do any synchronization when called to set a
> > fixmap entry. Add call to flush_vmap_cache().
> > 
> > Tested on hardware.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> > Tested-by: Graeme Gregory <graeme.gregory@linaro.org>
> > Cc: Steve Capper <steve.capper@linaro.org>
> > ---
> >  arch/arm64/mm/ioremap.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> > index 7ec3283..5b8766c 100644
> > --- a/arch/arm64/mm/ioremap.c
> > +++ b/arch/arm64/mm/ioremap.c
> > @@ -176,9 +176,10 @@ void __init __early_set_fixmap(enum fixed_addresses idx,
> >  
> >  	pte = early_ioremap_pte(addr);
> >  
> > -	if (pgprot_val(flags))
> > +	if (pgprot_val(flags)) {
> >  		set_pte(pte, pfn_pte(phys >> PAGE_SHIFT, flags));
> > -	else {
> > +		flush_cache_vmap(addr, addr + PAGE_SIZE);
> > +	} else {
> >  		pte_clear(&init_mm, addr, pte);
> >  		flush_tlb_kernel_range(addr, addr+PAGE_SIZE);
> >  	}
> 
> I'm confused by the commit message mentioning synchronization but
> the code doing a cache flush. I see that arm64 implementation of
> flush_cache_vmap() is just a dsb(). If it is synchronization that
> we need here (and it certainly looks like we do), why not just add
> the dsb() directly to make that clear?

It needs this Linux-semantically for the same reason remap_page_range
needs it. From the ARM architectural point of view, the reason is that
the translation table walk is considered a separate observer from the
core data interface.

But since there is a common Linux semantic for this, I preferred
reusing that over just throwing in a dsb(). My interpretation of
flush_cache_vmap() was "flush mappings from cache, so they can be
picked up by table walk". While we don't technically need to flush the
cache here, the underlying requirement is the same.

/
    Leif
