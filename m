Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaIEF3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbaIEF3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:29:05 -0400
Date: Fri, 5 Sep 2014 01:28:55 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 5/6] mm/hugetlb: add migration entry check in
 __unmap_hugepage_range
Message-ID: <20140905052855.GD6883@nhori.redhat.com>
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1409276340-7054-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.LSU.2.11.1409031821220.11485@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1409031821220.11485@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 06:47:38PM -0700, Hugh Dickins wrote:
> On Thu, 28 Aug 2014, Naoya Horiguchi wrote:
> 
> > If __unmap_hugepage_range() tries to unmap the address range over which
> > hugepage migration is on the way, we get the wrong page because pte_page()
> > doesn't work for migration entries. This patch calls pte_to_swp_entry() and
> > migration_entry_to_page() to get the right page for migration entries.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Cc: <stable@vger.kernel.org>  # [2.6.36+]
> 
> 2.6.36+?  But this one doesn't affect hwpoisoned.
> I admit I've lost track of how far back hugetlb migration goes:
> oh, to 2.6.37+, that fits with what you marked on some commits earlier.
> But then 2/6 says 3.12+.  Help!  Please remind me of the sequence of events.

The bug of this patch exists after any kind of hugetlb migration appears,
so I tagged as [2.6.36+] (Fixes: 290408d4a2 "hugetlb: hugepage migration core".)
As for patch 2/6, the related bug was introduced due to follow_huge_pmd()
with FOLL_GET, which can happen after commit e632a938d914 "mm: migrate:
add hugepage migration code to move_pages()", so I tagged as [3.12+].

> 
> > ---
> >  mm/hugetlb.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git mmotm-2014-08-25-16-52.orig/mm/hugetlb.c mmotm-2014-08-25-16-52/mm/hugetlb.c
> > index 1ed9df6def54..0a4511115ee0 100644
> > --- mmotm-2014-08-25-16-52.orig/mm/hugetlb.c
> > +++ mmotm-2014-08-25-16-52/mm/hugetlb.c
> > @@ -2652,6 +2652,13 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  		if (huge_pte_none(pte))
> >  			goto unlock;
> >  
> > +		if (unlikely(is_hugetlb_entry_migration(pte))) {
> > +			swp_entry_t entry = pte_to_swp_entry(pte);
> > +
> > +			page = migration_entry_to_page(entry);
> > +			goto clear;
> > +		}
> > +
> 
> This surprises me: are you sure?  Obviously you know hugetlb migration
> much better than I do: is it done in a significantly different way from
> order:0 page migration?  In the order:0 case, there is no reference to
> the page corresponding to the migration entry placed in a page table,
> just the remaining reference held by the task doing the migration.  But
> here you are jumping to the code which unmaps and frees a present page.

Sorry, I misread the code again, you're right.

> I can see that a fix is necessary, but I would have expected it to
> consist of merely changing the "HWPoisoned" comment below to include
> migration entries, and changing its test from
> 		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
> to
> 		if (unlikely(!pte_present(pte))) {

Yes, this looks the best way.

> 
> >  		/*
> >  		 * HWPoisoned hugepage is already unmapped and dropped reference
> >  		 */
> > @@ -2677,7 +2684,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  			 */
> >  			set_vma_resv_flags(vma, HPAGE_RESV_UNMAPPED);
> >  		}
> > -
> > +clear:
> >  		pte = huge_ptep_get_and_clear(mm, address, ptep);
> >  		tlb_remove_tlb_entry(tlb, ptep, address);
> >  		if (huge_pte_dirty(pte))
> > -- 
> > 1.9.3
> 
