Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaK0Pt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:49:28 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56996 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaK0Pt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:49:26 -0500
Date: Thu, 27 Nov 2014 16:49:21 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v17 7/7] mm: Don't split THP page when syscall is called
Message-ID: <20141127154921.GA11051@dhcp22.suse.cz>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
 <1413799924-17946-8-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413799924-17946-8-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-10-14 19:12:04, Minchan Kim wrote:
> We don't need to split THP page when MADV_FREE syscall is
> called. It could be done when VM decide really frees it so
> we could avoid unnecessary THP split.
> 
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Other than a minor comment below
Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/huge_mm.h |  4 ++++
>  mm/huge_memory.c        | 35 +++++++++++++++++++++++++++++++++++
>  mm/madvise.c            | 21 ++++++++++++++++++++-
>  mm/rmap.c               |  8 ++++++--
>  mm/vmscan.c             | 28 ++++++++++++++++++----------
>  5 files changed, 83 insertions(+), 13 deletions(-)
> 
[...]
> diff --git a/mm/madvise.c b/mm/madvise.c
> index a21584235bb6..84badee5f46d 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -271,8 +271,26 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  	spinlock_t *ptl;
>  	pte_t *pte, ptent;
>  	struct page *page;
> +	unsigned long next;
> +
> +	next = pmd_addr_end(addr, end);
> +	if (pmd_trans_huge(*pmd)) {
> +		if (next - addr != HPAGE_PMD_SIZE) {
> +#ifdef CONFIG_DEBUG_VM
> +			if (!rwsem_is_locked(&mm->mmap_sem)) {
> +				pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
> +					__func__, addr, end,
> +					vma->vm_start,
> +					vma->vm_end);
> +				BUG();
> +			}
> +#endif

Why is this code here? madvise_free_pte_range is called only from the
madvise path and we are holding mmap_sem and relying on that for regular
pages as well.

> +			split_huge_page_pmd(vma, addr, pmd);
> +		} else if (!madvise_free_huge_pmd(tlb, vma, pmd, addr))
> +			goto next;
> +		/* fall through */
> +	}
>  
> -	split_huge_page_pmd(vma, addr, pmd);
>  	if (pmd_trans_unstable(pmd))
>  		return 0;
>  
> @@ -316,6 +334,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  	}
>  	arch_leave_lazy_mmu_mode();
>  	pte_unmap_unlock(pte - 1, ptl);
> +next:
>  	cond_resched();
>  	return 0;
>  }
[...]
-- 
Michal Hocko
SUSE Labs
