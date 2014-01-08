Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaAHMmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:42:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbaAHMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:42:41 -0500
Date: Wed, 8 Jan 2014 13:42:40 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Bob Liu <lliubbo@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bob Liu <bob.liu@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: could you clarify mm/mempolicy: fix !vma in new_vma_page()
Message-ID: <20140108124240.GH27937@dhcp22.suse.cz>
References: <20140106112422.GA27602@dhcp22.suse.cz>
 <CAA_GA1dNdrG9aQ3UKDA0O=BY721rvseORVkc2+RxUpzysp3rYw@mail.gmail.com>
 <20140106141827.GB27602@dhcp22.suse.cz>
 <CAA_GA1csMEhSYmeS7qgDj7h=Xh2WrsYvirkS55W4Jj3LTHy87A@mail.gmail.com>
 <20140107102212.GC8756@dhcp22.suse.cz>
 <20140107173034.GE8756@dhcp22.suse.cz>
 <CAA_GA1fN5p3-m40Mf3nqFzRrGcJ9ni9Cjs_q4fm1PCLnzW1cEw@mail.gmail.com>
 <20140108100859.GC27937@dhcp22.suse.cz>
 <CAA_GA1emcHt+9zOqAKHPoXLd-ofyfYyuQn9fcdLOox5k7BLgww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1emcHt+9zOqAKHPoXLd-ofyfYyuQn9fcdLOox5k7BLgww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-01-14 20:09:30, Bob Liu wrote:
> On Wed, Jan 8, 2014 at 6:08 PM, Michal Hocko <mhocko@suse.cz> wrote:
> 
> >
> > If I was debugging this I would simply add printk into page_address_in_vma
> > error paths.
> >
> > Anyway, I think that at least hugetlbfs part should be reverted because
> > it might paper over real bugs. Although the migration would fail for
> > such hugetlb page we should catch that a weird page was tried to be
> > migrated. What about the patch below?
> 
> Looks good to me. But we need to confirm whether our assumption is right.

Which assumption you have in mind? non-linear mapping or failing on
anon_vma or f_mapping checks?

> Sasha, could you please have a test with Michal's patch?

I obviously doesn't have anything against testing but we should really
focus on the original issue. This patch simply restores hugetlb code
path.

> Thanks,
> -Bob
> 
> > ---
> > From 2d61421f26a3b63b4670d71b7adc67e2191b6157 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Wed, 8 Jan 2014 10:57:41 +0100
> > Subject: [PATCH] mm: new_vma_page cannot see NULL vma for hugetlb pages
> >
> > 11c731e81bb0 (mm/mempolicy: fix !vma in new_vma_page()) has removed
> > BUG_ON(!vma) from new_vma_page which is partially correct because
> > page_address_in_vma will return EFAULT for non-linear mappings and at
> > least shared shmem might be mapped this way.
> >
> > The patch also tried to prevent NULL ptr for hugetlb pages which is not
> > correct AFAICS because hugetlb pages cannot be mapped as VM_NONLINEAR
> > and other conditions in page_address_in_vma seem to be legit and catch
> > real bugs.
> >
> > This patch restores BUG_ON for PageHuge to catch potential issues when
> > the to-be-migrated page is not setup properly.
> >
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  mm/mempolicy.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 9e8d2d86978a..f3f51464a23b 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1199,10 +1199,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
> >         }
> >
> >         if (PageHuge(page)) {
> > -               if (vma)
> > -                       return alloc_huge_page_noerr(vma, address, 1);
> > -               else
> > -                       return NULL;
> > +               BUG_ON(vma)
> > +               return alloc_huge_page_noerr(vma, address, 1);
> >         }
> >         /*
> >          * if !vma, alloc_page_vma() will use task or system default policy
> > --
> > 1.8.5.2
> >
> > --
> > Michal Hocko
> > SUSE Labs

-- 
Michal Hocko
SUSE Labs
