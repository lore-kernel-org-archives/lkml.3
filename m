Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3J3PLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:11:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3J3PLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:11:46 -0400
Date: Wed, 30 Oct 2013 11:10:51 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.jiang@intel.com,
        Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        dhillf@gmail.com
Message-ID: <1383145851-unjeu8ej-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20131028221618.4078637F@viggo.jf.intel.com>
References: <20131028221618.4078637F@viggo.jf.intel.com>
Subject: Re: [PATCH 1/2] mm: hugetlbfs: Add some VM_BUG_ON()s to
 catchnon-hugetlbfs pages
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 03:16:18PM -0700, Dave Hansen wrote:
> 
> Dave Jiang reported that he was seeing oopses when running
> NUMA systems and default_hugepagesz=1G.  I traced the issue down
> to migrate_page_copy() trying to use the same code for hugetlb
> pages and transparent hugepages.  It should not have been trying
> to pass thp pages in there.
> 
> So, add some VM_BUG_ON()s for the next hapless VM developer that

Looks good to me, thanks.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>


> 
> ---
> 
>  linux.git-davehans/include/linux/hugetlb.h |    1 +
>  linux.git-davehans/mm/hugetlb.c            |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff -puN include/linux/hugetlb.h~bug-not-hugetlbfs-in-copy_huge_page include/linux/hugetlb.h
> --- linux.git/include/linux/hugetlb.h~bug-not-hugetlbfs-in-copy_huge_page	2013-10-28 15:06:12.888828815 -0700
> +++ linux.git-davehans/include/linux/hugetlb.h	2013-10-28 15:06:12.893829038 -0700
> @@ -355,6 +355,7 @@ static inline pte_t arch_make_huge_pte(p
>  
>  static inline struct hstate *page_hstate(struct page *page)
>  {
> +	VM_BUG_ON(!PageHuge(page));
>  	return size_to_hstate(PAGE_SIZE << compound_order(page));
>  }
>  
> diff -puN mm/hugetlb.c~bug-not-hugetlbfs-in-copy_huge_page mm/hugetlb.c
> --- linux.git/mm/hugetlb.c~bug-not-hugetlbfs-in-copy_huge_page	2013-10-28 15:06:12.890828904 -0700
> +++ linux.git-davehans/mm/hugetlb.c	2013-10-28 15:06:12.894829082 -0700
> @@ -498,6 +498,7 @@ void copy_huge_page(struct page *dst, st
>  	int i;
>  	struct hstate *h = page_hstate(src);
>  
> +	VM_BUG_ON(!h);
>  	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
>  		copy_gigantic_page(dst, src);
>  		return;
> _
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
