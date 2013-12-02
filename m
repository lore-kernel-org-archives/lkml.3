Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3LBWoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:44:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3LBWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:44:36 -0500
Date: Mon, 2 Dec 2013 14:44:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 1/9] mm/rmap: recompute pgoff for huge page
Message-Id: <20131202144434.2afc2b5bb69f2b4b45608e4e@linux-foundation.org>
In-Reply-To: <1385624926-28883-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1385624926-28883-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1385624926-28883-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013 16:48:38 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> We have to recompute pgoff if the given page is huge, since result based
> on HPAGE_SIZE is not approapriate for scanning the vma interval tree, as
> shown by commit 36e4f20af833 ("hugetlb: do not use vma_hugecache_offset()
> for vma_prio_tree_foreach") and commit 369a713e ("rmap: recompute pgoff
> for unmapping huge page").
> 
> ...
>
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1714,6 +1714,10 @@ static int rmap_walk_file(struct page *page, int (*rmap_one)(struct page *,
>  
>  	if (!mapping)
>  		return ret;
> +
> +	if (PageHuge(page))
> +		pgoff = page->index << compound_order(page);
> +
>  	mutex_lock(&mapping->i_mmap_mutex);
>  	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
>  		unsigned long address = vma_address(page, vma);

a)  Can't we just do this?

--- a/mm/rmap.c~mm-rmap-recompute-pgoff-for-huge-page-fix
+++ a/mm/rmap.c
@@ -1708,16 +1708,13 @@ static int rmap_walk_file(struct page *p
 		struct vm_area_struct *, unsigned long, void *), void *arg)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << compound_order(page);
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
 	if (!mapping)
 		return ret;
 
-	if (PageHuge(page))
-		pgoff = page->index << compound_order(page);
-
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);

compound_order() does the right thing for all styles of page, yes?

b) If that PageHuge() test you added the correct thing to use?

/*
 * PageHuge() only returns true for hugetlbfs pages, but not for normal or
 * transparent huge pages.  See the PageTransHuge() documentation for more
 * details.
 */

   Obviously we won't be encountering transparent huge pages here,
   but what's the best future-safe approach?


I hate that PageHuge() oddity with a passion!  Maybe it would be better
if it was called PageHugetlbfs.
