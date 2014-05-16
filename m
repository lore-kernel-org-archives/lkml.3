Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbaEPQU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:20:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30672 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757017AbaEPQU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:20:57 -0400
Date: Fri, 16 May 2014 17:20:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Steve Capper <steve.capper@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: fix pud_huge() for 2-level pagetables
Message-ID: <20140516162006.GJ5624@arm.com>
References: <1400163562-7481-1-git-send-email-msalter@redhat.com>
 <20140516100434.GG5624@arm.com>
 <1400255651.21547.214.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400255651.21547.214.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 04:54:11PM +0100, Mark Salter wrote:
> On Fri, 2014-05-16 at 11:04 +0100, Catalin Marinas wrote:
> > On Thu, May 15, 2014 at 03:19:22PM +0100, Mark Salter wrote:
> > > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > > index 5e9aec3..9bed38f 100644
> > > --- a/arch/arm64/mm/hugetlbpage.c
> > > +++ b/arch/arm64/mm/hugetlbpage.c
> > > @@ -51,7 +51,11 @@ int pmd_huge(pmd_t pmd)
> > >  
> > >  int pud_huge(pud_t pud)
> > >  {
> > > +#ifndef __PAGETABLE_PMD_FOLDED
> > >  	return !(pud_val(pud) & PUD_TABLE_BIT);
> > > +#else
> > > +	return 0;
> > > +#endif
> > >  }
> > >  
> > >  int pmd_huge_support(void)
> > > @@ -64,8 +68,10 @@ static __init int setup_hugepagesz(char *opt)
> > >  	unsigned long ps = memparse(opt, &opt);
> > >  	if (ps == PMD_SIZE) {
> > >  		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
> > > +#ifndef __PAGETABLE_PMD_FOLDED
> > >  	} else if (ps == PUD_SIZE) {
> > >  		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
> > > +#endif
> > 
> > Since PMD_SIZE == PUD_SIZE when __PAGETABLE_PMD_FOLDED, do we need the
> > #ifndef here? Maybe the compiler is smart enough to remove it but it's
> > not on a critical path anyway, so I wouldn't bother.
> 
> Yes, I think it would remove it. In any case, one less ifdef would be
> a good thing.

I merged this patch and dropped the last #ifndef.

I still have doubts about the kvm code calling put_page more than
necessary, especially since pud == pmd and the loop continues after
pud_huge() returns true, but your patch looks harmless.

Unless Steve has any objection, I'll push it to mainline. I also added
Cc: stable # v3.11+

Thanks.

-- 
Catalin
