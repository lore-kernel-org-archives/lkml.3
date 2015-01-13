Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbbAMSvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:51:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:6633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbbAMSvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:51:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="440086866"
Date: Tue, 13 Jan 2015 13:50:13 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        willy@linux.intel.com
Subject: Re: [PATCH v12 03/20] mm: Fix XIP fault vs truncate race
Message-ID: <20150113185013.GG5661@wil.cx>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
 <1414185652-28663-4-git-send-email-matthew.r.wilcox@intel.com>
 <20150112150929.55c31ccb22f466a9dbbde5d6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112150929.55c31ccb22f466a9dbbde5d6@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:09:29PM -0800, Andrew Morton wrote:
> On Fri, 24 Oct 2014 17:20:35 -0400 Matthew Wilcox <matthew.r.wilcox@intel.com> wrote:
> > Pagecache faults recheck i_size after taking the page lock to ensure that
> > the fault didn't race against a truncate.  We don't have a page to lock
> > in the XIP case, so use the i_mmap_mutex instead.  It is locked in the
> > truncate path in unmap_mapping_range() after updating i_size.  So while
> > we hold it in the fault path, we are guaranteed that either i_size has
> > already been updated in the truncate path, or that the truncate will
> > subsequently call zap_page_range_single() and so remove the mapping we
> > have just inserted.
> > 
> > There is a window of time in which i_size has been reduced and the
> > thread has a mapping to a page which will be removed from the file,
> > but this is harmless as the page will not be allocated to a different
> > purpose before the thread's access to it is revoked.
> > 
> 
> i_mmap_mutex is no more.  I made what are hopefulyl the appropriate
> changes.
> 
> Also, that new locking rule is pretty subtle and we need to find a way
> of alerting readers (and modifiers) of mm/memory.c to DAX's use of
> i_mmap_lock().  Please review my suggested addition for accuracy and
> cmopleteness.

I find the existing locking rules for truncate pretty subtle too!
It's easy to define what the rule is, but "why does it work" is, as you
say, subtle.

> +++ a/mm/filemap_xip.c
> @@ -255,17 +255,20 @@ again:
>  		__xip_unmap(mapping, vmf->pgoff);
>  
>  found:
> -		/* We must recheck i_size under i_mmap_mutex */
> -		mutex_lock(&mapping->i_mmap_mutex);
> +		/*
> +		 * We must recheck i_size under i_mmap_rwsem to prevent races
> +		 * with truncation
> +		 */
> +		i_mmap_lock_read(mapping);

I think this is correct.  The truncate code has a write lock, so it cannot
be running at the same time as a read lock.

> diff -puN mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix mm/memory.c
> --- a/mm/memory.c~mm-fix-xip-fault-vs-truncate-race-fix
> +++ a/mm/memory.c
> @@ -1327,6 +1327,11 @@ static void unmap_single_vma(struct mmu_
>  			 * safe to do nothing in this case.
>  			 */
>  			if (vma->vm_file) {
> +				/*
> +				 * Note that DAX uses i_mmap_lock to serialise
> +				 * against file truncate - truncate calls into
> +				 * unmap_single_vma().
> +				 */
>  				i_mmap_lock_write(vma->vm_file->f_mapping);
>  				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
>  				i_mmap_unlock_write(vma->vm_file->f_mapping);
> _
> 

But this comment is in the wrong place!  This code is only for the hugetlbfs
case, and would do nothing to protect the DAX code.  I think you want this
instead:

diff --git a/mm/memory.c b/mm/memory.c
index 54f3a9b..67bbbb7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,7 +2384,7 @@ void unmap_mapping_range(struct address_space *mapping,
 	if (details.last_index < details.first_index)
 		details.last_index = ULONG_MAX;
 
-
+	/* DAX uses i_mmap_lock to serialise file truncate vs page fault */
 	i_mmap_lock_write(mapping);
 	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);

Filesystems are obliged to update i_size before calling
truncate_pagecache(), which does:

        unmap_mapping_range(mapping, holebegin, 0, 1);
        truncate_inode_pages(mapping, newsize);
        unmap_mapping_range(mapping, holebegin, 0, 1);

So if we hold i_mmap_lock_read(), we know that unmap_mapping_range()
is blocked waiting for it, and so any page less than i_size is safe to
insert, because it will be removed once unmap_mapping_range() proceeds.
