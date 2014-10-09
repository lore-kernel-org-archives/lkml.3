Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaJIQhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:37:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:18532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550AbaJIQhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:37:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,686,1406617200"; 
   d="scan'208";a="586147612"
Message-ID: <5436B98E.1070407@intel.com>
Date: Thu, 09 Oct 2014 09:36:30 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fengwei Yin <yfw.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
CC: fengguang.wu@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] smaps should deal with huge zero page exactly same as
 normal zero page
References: <CADUXgx7QTWBMxesxgCet5rjpGu-V-xK_-5f2rX9R+v-ggi902A@mail.gmail.com>
In-Reply-To: <CADUXgx7QTWBMxesxgCet5rjpGu-V-xK_-5f2rX9R+v-ggi902A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 02:19 AM, Fengwei Yin wrote:
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 80ca4fb..8550b27 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -476,7 +476,7 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
>  			mss->nonlinear += ptent_size;
>  	}
>  
> -	if (!page)
> +	if (!page || is_huge_zero_page(page))
>  		return;

This really seems like a bit of a hack.  A normal (small) zero page
won't make it to this point because of the vm_normal_page() check in
smaps_pte_entry() which hits the _PAGE_SPECIAL bit in the pte.

Is there a reason we can't set _PAGE_SPECIAL on the huge_zero_page ptes?
 If we did that, we wouldn't need a special case here.

If we can't do that for some reason, can we at least teach
vm_normal_page() about the huge_zero_page in some other way?

>  	if (PageAnon(page))
> @@ -516,7 +516,8 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
>  		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
>  		spin_unlock(ptl);
> -		mss->anonymous_thp += HPAGE_PMD_SIZE;
> +		if (!is_huge_zero_pmd(*pmd))
> +			mss->anonymous_thp += HPAGE_PMD_SIZE;
>  		return 0;
>  	}

How about we just move this hunk in to smaps_pte_entry()?  Something
along these lines:

...
        if (PageAnon(page)) {
                mss->anonymous += ptent_size;
+		if (PageTransHuge(page))
+			mss->anonymous_thp += ptent_size;
	}

If we do that, plus teaching vm_normal_page() about huge_zero_pages, it
will help keep the hacks and the extra code due to huge pages to a miniumum.

> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 63579cb..758f569 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -34,6 +34,10 @@ extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>  			unsigned long addr, pgprot_t newprot,
>  			int prot_numa);
>  
> +extern bool is_huge_zero_page(struct page *page);
> +
> +extern bool is_huge_zero_pmd(pmd_t pmd);
> +
>  enum transparent_hugepage_flag {
>  	TRANSPARENT_HUGEPAGE_FLAG,
>  	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d9a21d06..bedc3ae 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -173,12 +173,12 @@ static int start_khugepaged(void)
>  static atomic_t huge_zero_refcount;
>  static struct page *huge_zero_page __read_mostly;
>  
> -static inline bool is_huge_zero_page(struct page *page)
> +bool is_huge_zero_page(struct page *page)
>  {
>  	return ACCESS_ONCE(huge_zero_page) == page;
>  }
>  
> -static inline bool is_huge_zero_pmd(pmd_t pmd)
> +bool is_huge_zero_pmd(pmd_t pmd)
>  {
>  	return is_huge_zero_page(pmd_page(pmd));
>  }

^^^ And all these exports.
