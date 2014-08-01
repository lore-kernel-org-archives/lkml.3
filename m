Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbaHAV6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 17:58:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaHAV6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 17:58:52 -0400
Date: Fri, 1 Aug 2014 17:58:45 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v2 1/3] mm/hugetlb: take refcount under page table lock
 in follow_huge_pmd()
Message-ID: <20140801215845.GA18622@nhori.bos.redhat.com>
References: <1406914663-8631-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140801145358.0d673fc05235d941ca9dec0e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801145358.0d673fc05235d941ca9dec0e@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:53:58PM -0700, Andrew Morton wrote:
> On Fri,  1 Aug 2014 13:37:41 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > We have a race condition between move_pages() and freeing hugepages,
> > where move_pages() calls follow_page(FOLL_GET) for hugepages internally
> > and tries to get its refcount without preventing concurrent freeing.
> > This race crashes the kernel, so this patch fixes it by moving FOLL_GET
> > code for hugepages into follow_huge_pmd() with taking the page table lock.
> > 
> > This patch passes the following test. And libhugetlbfs test shows no
> > regression.
> > 
> > ...
> 
> How were these bugs discovered?  Are we missing some Reported-by's?

Hugh pointed out this a few months ago, so I should have added his
Reported-by tag.

> > --- mmotm-2014-07-22-15-58.orig/include/linux/hugetlb.h
> > +++ mmotm-2014-07-22-15-58/include/linux/hugetlb.h
> > @@ -101,6 +101,8 @@ struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
> >  				pmd_t *pmd, int write);
> >  struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
> >  				pud_t *pud, int write);
> > +struct page *follow_huge_pmd_lock(struct vm_area_struct *vma,
> > +				unsigned long address, pmd_t *pmd, int flags);
> >  int pmd_huge(pmd_t pmd);
> >  int pud_huge(pud_t pmd);
> >  unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
> >
> > ...
> >
> > --- mmotm-2014-07-22-15-58.orig/mm/hugetlb.c
> > +++ mmotm-2014-07-22-15-58/mm/hugetlb.c
> > @@ -3687,6 +3687,33 @@ follow_huge_pud(struct mm_struct *mm, unsigned long address,
> >  
> >  #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
> >  
> > +struct page *follow_huge_pmd_lock(struct vm_area_struct *vma,
> > +				unsigned long address, pmd_t *pmd, int flags)
> 
> Some documentation here wouldn't hurt.  Why it exists, what it does. 
> And especially: any preconditions to calling it (ie: locking).
> 
> > +{
> > +	struct page *page;
> > +	spinlock_t *ptl;
> > +
> > +	if (flags & FOLL_GET)
> > +		ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
> > +
> > +	page = follow_huge_pmd(vma->vm_mm, address, pmd, flags & FOLL_WRITE);
> > +
> > +	if (flags & FOLL_GET) {
> > +		/*
> > +		 * Refcount on tail pages are not well-defined and
> > +		 * shouldn't be taken. The caller should handle a NULL
> > +		 * return when trying to follow tail pages.
> > +		 */
> > +		if (PageHead(page))
> > +			get_page(page);
> > +		else
> > +			page = NULL;
> > +		spin_unlock(ptl);
> > +	}
> > +
> > +	return page;
> > +}
> > +
> >  #ifdef CONFIG_MEMORY_FAILURE
> 
> I can't find an implementation of follow_huge_pmd() which actually uses
> the fourth argument "write".  Zap?

OK, I'll post it later.

Thanks,
Naoya Horiguchi

> 
> Ditto for follow_huge_pud().
