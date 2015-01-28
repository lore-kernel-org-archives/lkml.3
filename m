Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbbA1UQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:16:05 -0500
Received: from blu004-omc2s5.hotmail.com ([65.55.111.80]:59067 "EHLO
	BLU004-OMC2S5.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbbA1UQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:16:01 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 15:16:00 EST
X-TMN: [TMc8uw1ERhNFrr7XwOD2zalNfyqDnh9n]
X-Originating-Email: [zhangyanfei.ok@hotmail.com]
Message-ID: <BLU436-SMTP153779ECFE274421F0F82DF83330@phx.gbl>
Date: Wed, 28 Jan 2015 21:57:40 +0800
From: Zhang Yanfei <zhangyanfei.ok@hotmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-mm@kvack.org
CC: akpm@linux-foundation.org, kirill@shutemov.name, mhocko@suse.cz,
        mgorman@suse.de, rientjes@google.com, sasha.levin@oracle.com,
        hughd@google.com, hannes@cmpxchg.org, vbabka@suse.cz,
        linux-kernel@vger.kernel.org, riel@redhat.com, aarcange@redhat.com,
        zhangyanfei.linux@aliyun.com
Subject: Re: [PATCH v3] mm: incorporate read-only pages into transparent huge
 pages
References: <1422380353-4407-1-git-send-email-ebru.akagunduz@gmail.com>
In-Reply-To: <1422380353-4407-1-git-send-email-ebru.akagunduz@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Jan 2015 13:57:54.0543 (UTC) FILETIME=[69D737F0:01D03B02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

在 2015/1/28 1:39, Ebru Akagunduz 写道:
> This patch aims to improve THP collapse rates, by allowing
> THP collapse in the presence of read-only ptes, like those
> left in place by do_swap_page after a read fault.
>
> Currently THP can collapse 4kB pages into a THP when
> there are up to khugepaged_max_ptes_none pte_none ptes
> in a 2MB range. This patch applies the same limit for
> read-only ptes.
>
> The patch was tested with a test program that allocates
> 800MB of memory, writes to it, and then sleeps. I force
> the system to swap out all but 190MB of the program by
> touching other memory. Afterwards, the test program does
> a mix of reads and writes to its memory, and the memory
> gets swapped back in.
>
> Without the patch, only the memory that did not get
> swapped out remained in THPs, which corresponds to 24% of
> the memory of the program. The percentage did not increase
> over time.
>
> With this patch, after 5 minutes of waiting khugepaged had
> collapsed 50% of the program's memory back into THPs.
>
> Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Please feel free to add:

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
> Changes in v2:
>  - Remove extra code indent (Vlastimil Babka)
>  - Add comment line for check condition of page_count() (Vlastimil Babka)
>  - Add fast path optimistic check to
>    __collapse_huge_page_isolate() (Andrea Arcangeli)
>  - Move check condition of page_count() below to trylock_page() (Andrea Arcangeli)
>
> Changes in v3:
>  - Add a at-least-one-writable-pte check (Zhang Yanfei)
>  - Debug page count (Vlastimil Babka, Andrea Arcangeli)
>  - Increase read-only pte counter if pte is none (Andrea Arcangeli)
>
> I've written down test results:
> With the patch:
> After swapped out:
> cat /proc/pid/smaps:
> Anonymous:      100464 kB
> AnonHugePages:  100352 kB
> Swap:           699540 kB
> Fraction:       99,88
>
> cat /proc/meminfo:
> AnonPages:      1754448 kB
> AnonHugePages:  1716224 kB
> Fraction:       97,82
>
> After swapped in:
> In a few seconds:
> cat /proc/pid/smaps:
> Anonymous:      800004 kB
> AnonHugePages:  145408 kB
> Swap:           0 kB
> Fraction:       18,17
>
> cat /proc/meminfo:
> AnonPages:      2455016 kB
> AnonHugePages:  1761280 kB
> Fraction:       71,74
>
> In 5 minutes:
> cat /proc/pid/smaps
> Anonymous:      800004 kB
> AnonHugePages:  407552 kB
> Swap:           0 kB
> Fraction:       50,94
>
> cat /proc/meminfo:
> AnonPages:      2456872 kB
> AnonHugePages:  2023424 kB
> Fraction:       82,35
>
> Without the patch:
> After swapped out:
> cat /proc/pid/smaps:
> Anonymous:      190660 kB
> AnonHugePages:  190464 kB
> Swap:           609344 kB
> Fraction:       99,89
>
> cat /proc/meminfo:
> AnonPages:      1740456 kB
> AnonHugePages:  1667072 kB
> Fraction:       95,78
>
> After swapped in:
> cat /proc/pid/smaps:
> Anonymous:      800004 kB
> AnonHugePages:  190464 kB
> Swap:           0 kB
> Fraction:       23,80
>
> cat /proc/meminfo:
> AnonPages:      2350032 kB
> AnonHugePages:  1667072 kB
> Fraction:       70,93
>
> I waited 10 minutes the fractions
> did not change without the patch.
>
>  mm/huge_memory.c | 60 +++++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 49 insertions(+), 11 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 817a875..17d6e59 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2148,17 +2148,18 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  {
>  	struct page *page;
>  	pte_t *_pte;
> -	int referenced = 0, none = 0;
> +	int referenced = 0, none = 0, ro = 0, writable = 0;
>  	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
>  	     _pte++, address += PAGE_SIZE) {
>  		pte_t pteval = *_pte;
>  		if (pte_none(pteval)) {
> +			ro++;
>  			if (++none <= khugepaged_max_ptes_none)
>  				continue;
>  			else
>  				goto out;
>  		}
> -		if (!pte_present(pteval) || !pte_write(pteval))
> +		if (!pte_present(pteval))
>  			goto out;
>  		page = vm_normal_page(vma, address, pteval);
>  		if (unlikely(!page))
> @@ -2168,9 +2169,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		VM_BUG_ON_PAGE(!PageAnon(page), page);
>  		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
>  
> -		/* cannot use mapcount: can't collapse if there's a gup pin */
> -		if (page_count(page) != 1)
> -			goto out;
>  		/*
>  		 * We can do it before isolate_lru_page because the
>  		 * page can't be freed from under us. NOTE: PG_lock
> @@ -2179,6 +2177,34 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		 */
>  		if (!trylock_page(page))
>  			goto out;
> +
> +		/*
> +		 * cannot use mapcount: can't collapse if there's a gup pin.
> +		 * The page must only be referenced by the scanned process
> +		 * and page swap cache.
> +		 */
> +		if (page_count(page) != 1 + !!PageSwapCache(page)) {
> +			unlock_page(page);
> +			goto out;
> +		}
> +		if (!pte_write(pteval)) {
> +			if (++ro > khugepaged_max_ptes_none) {
> +				unlock_page(page);
> +				goto out;
> +			}
> +			if (PageSwapCache(page) && !reuse_swap_page(page)) {
> +				unlock_page(page);
> +				goto out;
> +			}
> +			/*
> +			 * Page is not in the swap cache, and page count is
> +			 * one (see above). It can be collapsed into a THP.
> +			 */
> +			VM_BUG_ON(page_count(page) != 1);
> +		} else {
> +			writable = 1;
> +		}
> +
>  		/*
>  		 * Isolate the page to avoid collapsing an hugepage
>  		 * currently in use by the VM.
> @@ -2197,7 +2223,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		    mmu_notifier_test_young(vma->vm_mm, address))
>  			referenced = 1;
>  	}
> -	if (likely(referenced))
> +	if (likely(referenced && writable))
>  		return 1;
>  out:
>  	release_pte_pages(pte, _pte);
> @@ -2550,7 +2576,7 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> -	int ret = 0, referenced = 0, none = 0;
> +	int ret = 0, referenced = 0, none = 0, ro = 0, writable = 0;
>  	struct page *page;
>  	unsigned long _address;
>  	spinlock_t *ptl;
> @@ -2568,13 +2594,21 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
>  	     _pte++, _address += PAGE_SIZE) {
>  		pte_t pteval = *_pte;
>  		if (pte_none(pteval)) {
> +			ro++;
>  			if (++none <= khugepaged_max_ptes_none)
>  				continue;
>  			else
>  				goto out_unmap;
>  		}
> -		if (!pte_present(pteval) || !pte_write(pteval))
> +		if (!pte_present(pteval))
>  			goto out_unmap;
> +		if (!pte_write(pteval)) {
> +			if (++ro > khugepaged_max_ptes_none)
> +				goto out_unmap;
> +		} else {
> +			writable = 1;
> +		}
> +
>  		page = vm_normal_page(vma, _address, pteval);
>  		if (unlikely(!page))
>  			goto out_unmap;
> @@ -2591,14 +2625,18 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
>  		VM_BUG_ON_PAGE(PageCompound(page), page);
>  		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
>  			goto out_unmap;
> -		/* cannot use mapcount: can't collapse if there's a gup pin */
> -		if (page_count(page) != 1)
> +		/*
> +		 * cannot use mapcount: can't collapse if there's a gup pin.
> +		 * The page must only be referenced by the scanned process
> +		 * and page swap cache.
> +		 */
> +		if (page_count(page) != 1 + !!PageSwapCache(page))
>  			goto out_unmap;
>  		if (pte_young(pteval) || PageReferenced(page) ||
>  		    mmu_notifier_test_young(vma->vm_mm, address))
>  			referenced = 1;
>  	}
> -	if (referenced)
> +	if (referenced && writable)
>  		ret = 1;
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);

