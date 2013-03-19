Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab3CSHLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:11:19 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58180 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab3CSHLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:11:18 -0400
Date: Tue, 19 Mar 2013 08:11:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] migrate: enable migrate_pages() to migrate hugepage
Message-ID: <20130319071113.GD5112@dhcp22.suse.cz>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130318154057.GS10192@dhcp22.suse.cz>
 <1363651636-3lsf20se-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363651636-3lsf20se-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-03-13 20:07:16, Naoya Horiguchi wrote:
> On Mon, Mar 18, 2013 at 04:40:57PM +0100, Michal Hocko wrote:
> > On Thu 21-02-13 14:41:44, Naoya Horiguchi wrote:
[...]
> > > @@ -3202,3 +3202,13 @@ void putback_active_hugepages(struct list_head *l)
> > >  	list_for_each_entry_safe(page, page2, l, lru)
> > >  		putback_active_hugepage(page);
> > >  }
> > > +
> > > +void migrate_hugepage_add(struct page *page, struct list_head *list)
> > > +{
> > > +	VM_BUG_ON(!PageHuge(page));
> > > +	get_page(page);
> > > +	spin_lock(&hugetlb_lock);
> > 
> > Why hugetlb_lock? Comment for this lock says that it protects
> > hugepage_freelists, nr_huge_pages, and free_huge_pages.
> 
> I think that this comment is out of date and hugepage_activelists,
> which was introduced recently, should be protected because this
> patchset adds is_hugepage_movable() which runs through the list.
> So I'll update the comment in the next post.
> 
> > > +	list_move_tail(&page->lru, list);
> > > +	spin_unlock(&hugetlb_lock);
> > > +	return;
> > > +}
> > > diff --git v3.8.orig/mm/mempolicy.c v3.8/mm/mempolicy.c
> > > index e2df1c1..8627135 100644
> > > --- v3.8.orig/mm/mempolicy.c
> > > +++ v3.8/mm/mempolicy.c
> > > @@ -525,6 +525,27 @@ static int check_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
> > >  	return addr != end;
> > >  }
> > >  
> > > +static void check_hugetlb_pmd_range(struct vm_area_struct *vma, pmd_t *pmd,
> > > +		const nodemask_t *nodes, unsigned long flags,
> > > +				    void *private)
> > > +{
> > > +#ifdef CONFIG_HUGETLB_PAGE
> > > +	int nid;
> > > +	struct page *page;
> > > +
> > > +	spin_lock(&vma->vm_mm->page_table_lock);
> > > +	page = pte_page(huge_ptep_get((pte_t *)pmd));
> > > +	spin_unlock(&vma->vm_mm->page_table_lock);
> > 
> > I am a bit confused why page_table_lock is used here and why it doesn't
> > cover the page usage.
> 
> I expected this function to do the same for pmd as check_pte_range() does
> for pte, but the above code didn't do it. I should've put spin_unlock
> below migrate_hugepage_add(). Sorry for the confusion.

OK, I see. So you want to prevent from racing with pmd unmap.

> > > +	nid = page_to_nid(page);
> > > +	if (node_isset(nid, *nodes) != !!(flags & MPOL_MF_INVERT)
> > > +	    && ((flags & MPOL_MF_MOVE && page_mapcount(page) == 1)
> > > +		|| flags & MPOL_MF_MOVE_ALL))
> > > +		migrate_hugepage_add(page, private);
> > > +#else
> > > +	BUG();
> > > +#endif
> > > +}
> > > +
> > >  static inline int check_pmd_range(struct vm_area_struct *vma, pud_t *pud,
> > >  		unsigned long addr, unsigned long end,
> > >  		const nodemask_t *nodes, unsigned long flags,
> > > @@ -536,6 +557,11 @@ static inline int check_pmd_range(struct vm_area_struct *vma, pud_t *pud,
> > >  	pmd = pmd_offset(pud, addr);
> > >  	do {
> > >  		next = pmd_addr_end(addr, end);
> > > +		if (pmd_huge(*pmd) && is_vm_hugetlb_page(vma)) {
> > 
> > Why an explicit check for is_vm_hugetlb_page here? Isn't pmd_huge()
> > sufficient?
> 
> I think we need both check here because if we use only pmd_huge(),
> pmd for thp goes into this branch wrongly. 

Bahh. You are right. I thought that pmd_huge is hugetlb thingy but it
obviously checks only _PAGE_PSE same as pmd_large() which is really
unfortunate and confusing. Can we make it hugetlb specific?

> 
> Thanks,
> Naoya
-- 
Michal Hocko
SUSE Labs
