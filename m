Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161298Ab3FUMre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:47:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965683Ab3FUMrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:47:32 -0400
Date: Fri, 21 Jun 2013 14:47:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 29/48] mm: migration: add migrate_entry_wait_huge()
Message-ID: <20130621124727.GG12424@dhcp22.suse.cz>
References: <20130618161725.912524266@linuxfoundation.org>
 <20130618161730.095209184@linuxfoundation.org>
 <87a9ml3y8k.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9ml3y8k.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-06-13 18:52:43, Satoru Takeuchi wrote:
> Hi Naoya,
> 
> At Tue, 18 Jun 2013 09:17:55 -0700,
> Greg Kroah-Hartman wrote:
> > 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > 3.9-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > 
> > commit 30dad30922ccc733cfdbfe232090cf674dc374dc upstream.
> > 
> > When we have a page fault for the address which is backed by a hugepage
> > under migration, the kernel can't wait correctly and do busy looping on
> > hugepage fault until the migration finishes.  As a result, users who try
> > to kick hugepage migration (via soft offlining, for example) occasionally
> > experience long delay or soft lockup.
> > 
> > This is because pte_offset_map_lock() can't get a correct migration entry
> > or a correct page table lock for hugepage.  This patch introduces
> > migration_entry_wait_huge() to solve this.
> 
> I suspect that this code doesn't work correctly on i686 box with CONFIG_HIGHPTE.
> If we call hugetlb_fault() -> migration_entry_wait_huge() -> __migration_entry_wait(),
> this function tries to kunmap pte, in this case pte is not-kmapped pmd, via pte_unmap_unlock().
> If CONFIG_DEBUG_HIGHMEM is also enabled, it results in BUG_ON() at __kunmap_atomic().
> 
> Correct me if I'm wrong.

I haven't checked the code closer but the patch doesn't change anything
regarding pte_unmap_unlock. The only thing that it touches is the
_locking_. So whether there ever was a problem with kmap or not this
patch doesn't change it.

That being said, the patch is OK for the stable tree.

> 
> Thanks,
> Satoru
> 
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Reviewed-by: Rik van Riel <riel@redhat.com>
> > Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> > Reviewed-by: Michal Hocko <mhocko@suse.cz>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  include/linux/swapops.h |    3 +++
> >  mm/hugetlb.c            |    2 +-
> >  mm/migrate.c            |   23 ++++++++++++++++++-----
> >  3 files changed, 22 insertions(+), 6 deletions(-)
> > 
> > --- a/include/linux/swapops.h
> > +++ b/include/linux/swapops.h
> > @@ -137,6 +137,7 @@ static inline void make_migration_entry_
> >  
> >  extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
> >  					unsigned long address);
> > +extern void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte);
> >  #else
> >  
> >  #define make_migration_entry(page, write) swp_entry(0, 0)
> > @@ -148,6 +149,8 @@ static inline int is_migration_entry(swp
> >  static inline void make_migration_entry_read(swp_entry_t *entryp) { }
> >  static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
> >  					 unsigned long address) { }
> > +static inline void migration_entry_wait_huge(struct mm_struct *mm,
> > +					pte_t *pte) { }
> >  static inline int is_write_migration_entry(swp_entry_t entry)
> >  {
> >  	return 0;
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -2823,7 +2823,7 @@ int hugetlb_fault(struct mm_struct *mm,
> >  	if (ptep) {
> >  		entry = huge_ptep_get(ptep);
> >  		if (unlikely(is_hugetlb_entry_migration(entry))) {
> > -			migration_entry_wait(mm, (pmd_t *)ptep, address);
> > +			migration_entry_wait_huge(mm, ptep);
> >  			return 0;
> >  		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
> >  			return VM_FAULT_HWPOISON_LARGE |
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -200,15 +200,14 @@ static void remove_migration_ptes(struct
> >   * get to the page and wait until migration is finished.
> >   * When we return from this function the fault will be retried.
> >   */
> > -void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
> > -				unsigned long address)
> > +static void __migration_entry_wait(struct mm_struct *mm, pte_t *ptep,
> > +				spinlock_t *ptl)
> >  {
> > -	pte_t *ptep, pte;
> > -	spinlock_t *ptl;
> > +	pte_t pte;
> >  	swp_entry_t entry;
> >  	struct page *page;
> >  
> > -	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
> > +	spin_lock(ptl);
> >  	pte = *ptep;
> >  	if (!is_swap_pte(pte))
> >  		goto out;
> > @@ -236,6 +235,20 @@ out:
> >  	pte_unmap_unlock(ptep, ptl);
> >  }
> >  
> > +void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
> > +				unsigned long address)
> > +{
> > +	spinlock_t *ptl = pte_lockptr(mm, pmd);
> > +	pte_t *ptep = pte_offset_map(pmd, address);
> > +	__migration_entry_wait(mm, ptep, ptl);
> > +}
> > +
> > +void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte)
> > +{
> > +	spinlock_t *ptl = &(mm)->page_table_lock;
> > +	__migration_entry_wait(mm, pte, ptl);
> > +}
> > +
> >  #ifdef CONFIG_BLOCK
> >  /* Returns true if all buffers are successfully locked */
> >  static bool buffer_migrate_lock_buffers(struct buffer_head *head,
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
