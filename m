Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaH2TRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbaH2TRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:17:36 -0400
Date: Fri, 29 Aug 2014 15:17:19 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        khlebnikov@openvz.org, riel@redhat.com, mgorman@suse.de,
        mhocko@suse.cz, hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] Convert a few VM_BUG_ON callers to VM_BUG_ON_VMA
Message-ID: <20140829191719.GC12774@nhori.bos.redhat.com>
References: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com>
 <1409324059-28692-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409324059-28692-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:54:19AM -0400, Sasha Levin wrote:
> Trivially convert a few VM_BUG_ON calls to VM_BUG_ON_VMA to extract
> more information when they trigger.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
...
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 3e8491c..5fbd0fe 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
...
> @@ -897,7 +897,7 @@ void page_move_anon_rmap(struct page *page,
>  	struct anon_vma *anon_vma = vma->anon_vma;
>  
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
> -	VM_BUG_ON(!anon_vma);
> +	VM_BUG_ON_VMA(!anon_vma, vma);

>  	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);

This line contains both of vma and page.
But I'm not sure that introducing another macro like VM_BUG_ON_PAGE_AND_VMA()
is worth doing. So it's ok for me to keep it untouched.

>  
>  	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
> @@ -1024,7 +1024,7 @@ void do_page_add_anon_rmap(struct page *page,
>  void page_add_new_anon_rmap(struct page *page,
>  	struct vm_area_struct *vma, unsigned long address)
>  {
> -	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
> +	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
>  	SetPageSwapBacked(page);
>  	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
>  	if (PageTransHuge(page))
> @@ -1666,7 +1666,7 @@ static int rmap_walk_file(struct page *page, struct rmap_walk_control *rwc)
>  	 * structure at mapping cannot be freed and reused yet,
>  	 * so we can safely take mapping->i_mmap_mutex.
>  	 */
> -	VM_BUG_ON(!PageLocked(page));
> +	VM_BUG_ON_PAGE(!PageLocked(page), page);

This is not the replacement with VM_BUG_ON_VMA(), but it's fine :)

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi
