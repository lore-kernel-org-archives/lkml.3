Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbaEPPyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaEPPyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:54:39 -0400
Message-ID: <1400255651.21547.214.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: fix pud_huge() for 2-level pagetables
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Steve Capper <steve.capper@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 16 May 2014 11:54:11 -0400
In-Reply-To: <20140516100434.GG5624@arm.com>
References: <1400163562-7481-1-git-send-email-msalter@redhat.com>
	 <20140516100434.GG5624@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 11:04 +0100, Catalin Marinas wrote:
> On Thu, May 15, 2014 at 03:19:22PM +0100, Mark Salter wrote:
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index 5e9aec3..9bed38f 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -51,7 +51,11 @@ int pmd_huge(pmd_t pmd)
> >  
> >  int pud_huge(pud_t pud)
> >  {
> > +#ifndef __PAGETABLE_PMD_FOLDED
> >  	return !(pud_val(pud) & PUD_TABLE_BIT);
> > +#else
> > +	return 0;
> > +#endif
> >  }
> >  
> >  int pmd_huge_support(void)
> > @@ -64,8 +68,10 @@ static __init int setup_hugepagesz(char *opt)
> >  	unsigned long ps = memparse(opt, &opt);
> >  	if (ps == PMD_SIZE) {
> >  		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
> > +#ifndef __PAGETABLE_PMD_FOLDED
> >  	} else if (ps == PUD_SIZE) {
> >  		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
> > +#endif
> 
> Since PMD_SIZE == PUD_SIZE when __PAGETABLE_PMD_FOLDED, do we need the
> #ifndef here? Maybe the compiler is smart enough to remove it but it's
> not on a critical path anyway, so I wouldn't bother.
> 

Yes, I think it would remove it. In any case, one less ifdef would be
a good thing.


