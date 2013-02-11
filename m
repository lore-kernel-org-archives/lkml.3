Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab3BKQ1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:27:09 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:39569 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589Ab3BKQ1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:07 -0500
Date: Mon, 11 Feb 2013 11:27:01 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>,
        Stewart Smith <stewart@flamingspork.com>
Subject: Re: RFC: mincore: add a bit to indicate a page is dirty.
Message-ID: <20130211162701.GB13218@cmpxchg.org>
References: <87a9rbh7b4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9rbh7b4.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 01:43:03PM +1030, Rusty Russell wrote:
> I am writing an app which really wants to know if a file is on the
> disk or not (ie. do I need to sync?).

When the page is under writeback, it's not necessarily on disk yet,
but you also don't need to sync.  Which semantics make more sense?

I'm leaning toward checking both PG_dirty and PG_writeback.

> mincore() bits other than 0 are undefined (as documented in the man
> page); in fact my Ubuntu 12.10 i386 system seems to write 129 in some
> bytes, so it really shouldn't break anyone.
> 
> Is PG_dirty the right choice?  Is that right for huge pages?  Should I
> assume is_migration_entry(entry) means it's not dirty, or is there some
> other check here?

If your only consequence of finding dirty pages is to sync, would you
be better off using fsync/fdatasync maybe?

This should work even if you only access the file through mmap, due to
the way we trap dirtying with write-protected ptes to accurately
account for dirty pages and update the status in the page cache.

> @@ -36,7 +39,15 @@ static void mincore_hugetlb_page_range(struct vm_area_struct *vma,
>  		 */
>  		ptep = huge_pte_offset(current->mm,
>  				       addr & huge_page_mask(h));
> -		present = ptep && !huge_pte_none(huge_ptep_get(ptep));
> +		if (ptep) {
> +			pte_t pte = huge_ptep_get(ptep);
> +
> +			if (!huge_pte_none(pte)) {
> +				flags = MINCORE_INCORE;
> +				if (pte_dirty(pte))
> +				    flags |= MINCORE_DIRTY;
> +			}
> +		}

This looks good to me.  However, this only covers the hugetlb page
implementation, you also have to annotate mincore_huge_pmd to cover
transparent huge pages:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6001ee6..c632517 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1403,12 +1403,17 @@ int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 	int ret = 0;
 
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+		struct page *page = pmd_page(pmd);
+		unsigned char flags;
 		/*
 		 * All logical pages in the range are present
 		 * if backed by a huge page.
 		 */
+		flags = MINCORE_INCORE;
+		if (PageDirty(page))
+			flags |= MINCORE_DIRTY;
 		spin_unlock(&vma->vm_mm->page_table_lock);
-		memset(vec, 1, (end - addr) >> PAGE_SHIFT);
+		memset(vec, flags, (end - addr) >> PAGE_SHIFT);
 		ret = 1;
 	}
 
> @@ -131,14 +148,15 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  
>  			if (is_migration_entry(entry)) {
>  				/* migration entries are always uptodate */
> -				*vec = 1;
> +				*vec = MINCORE_INCORE;
> +				/* FIXME: Can they be dirty? */

Yes, they can.  Use migration_entry_to_page() [safe with pte lock] and
test PageDirty() on it.
