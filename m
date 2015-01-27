Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbbA0ARw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:17:52 -0500
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:58568 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbbA0ARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:17:51 -0500
X-Greylist: delayed 2879 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2015 19:17:50 EST
Message-ID: <1422316890.2493.40.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 3/7] mm: Change ioremap to set up huge I/O mappings
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Jan 2015 17:01:30 -0700
In-Reply-To: <20150126155811.0ade183f5f3f89277d11fde6@linux-foundation.org>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
	 <1422314009-31667-4-git-send-email-toshi.kani@hp.com>
	 <20150126155811.0ade183f5f3f89277d11fde6@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 15:58 -0800, Andrew Morton wrote:
> On Mon, 26 Jan 2015 16:13:25 -0700 Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > Change ioremap_pud_range() and ioremap_pmd_range() to set up
> > huge I/O mappings when their capability is enabled and their
> > conditions are met in a given request -- both virtual & physical
> > addresses are aligned and its range fufills the mapping size.
> > 
> > These changes are only enabled when both CONFIG_HUGE_IOMAP
> > and CONFIG_HAVE_ARCH_HUGE_VMAP are defined.
> > 
> > --- a/lib/ioremap.c
> > +++ b/lib/ioremap.c
> > @@ -81,6 +81,14 @@ static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
> >  		return -ENOMEM;
> >  	do {
> >  		next = pmd_addr_end(addr, end);
> > +
> > +		if (ioremap_pmd_enabled() &&
> > +		    ((next - addr) == PMD_SIZE) &&
> > +		    !((phys_addr + addr) & (PMD_SIZE-1))) {
> 
> IS_ALIGNED might be a little neater here.

Right.  Will use IS_ALIGNED.

> > +			pmd_set_huge(pmd, phys_addr + addr, prot);
> > +			continue;
> > +		}
> > +
> >  		if (ioremap_pte_range(pmd, addr, next, phys_addr + addr, prot))
> >  			return -ENOMEM;
> >  	} while (pmd++, addr = next, addr != end);
> > @@ -99,6 +107,14 @@ static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
> >  		return -ENOMEM;
> >  	do {
> >  		next = pud_addr_end(addr, end);
> > +
> > +		if (ioremap_pud_enabled() &&
> > +		    ((next - addr) == PUD_SIZE) &&
> > +		    !((phys_addr + addr) & (PUD_SIZE-1))) {
> 
> And here.

Will do.

Thanks,
-Toshi

