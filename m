Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbaIDAWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 20:22:49 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61056 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaIDAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 20:22:47 -0400
Date: Wed, 3 Sep 2014 17:20:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 3/6] mm/hugetlb: fix getting refcount 0 page in
 hugetlb_fault()
In-Reply-To: <1409276340-7054-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.LSU.2.11.1409031649190.10884@eggly.anvils>
References: <1409276340-7054-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1409276340-7054-4-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Naoya Horiguchi wrote:

> When running the test which causes the race as shown in the previous patch,
> we can hit the BUG "get_page() on refcount 0 page" in hugetlb_fault().
> 
> This race happens when pte turns into migration entry just after the first
> check of is_hugetlb_entry_migration() in hugetlb_fault() passed with false.
> To fix this, we need to check pte_present() again with holding ptl.
> 
> This patch also reorders taking ptl and doing pte_page(), because pte_page()
> should be done in ptl. Due to this reordering, we need use trylock_page()
> in page != pagecache_page case to respect locking order.
> 
> ChangeLog v3:
> - doing pte_page() and taking refcount under page table lock
> - check pte_present after taking ptl, which makes it unnecessary to use
>   get_page_unless_zero()
> - use trylock_page in page != pagecache_page case
> - fixed target stable version

ChangeLog vN below the --- (or am I contradicting some other advice?)

> 
> Fixes: 66aebce747ea ("hugetlb: fix race condition in hugetlb_fault()")
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: <stable@vger.kernel.org>  # [3.2+]

One bug, one warning, a couple of suboptimals...

> ---
>  mm/hugetlb.c | 32 ++++++++++++++++++--------------
>  1 file changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git mmotm-2014-08-25-16-52.orig/mm/hugetlb.c mmotm-2014-08-25-16-52/mm/hugetlb.c
> index c5345c5edb50..2aafe073cb06 100644
> --- mmotm-2014-08-25-16-52.orig/mm/hugetlb.c
> +++ mmotm-2014-08-25-16-52/mm/hugetlb.c
> @@ -3184,6 +3184,15 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  								vma, address);
>  	}
>  
> +	ptl = huge_pte_lock(h, mm, ptep);
> +
> +	/* Check for a racing update before calling hugetlb_cow */
> +	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
> +		goto out_ptl;
> +
> +	if (!pte_present(entry))
> +		goto out_ptl;

A comment on that test would be helpful.  Is a migration entry
the only !pte_present() case you would expect to find there?

It would be better to test "entry" for this (or for being a migration
entry) higher up, just after getting "entry": less to unwind on error.

And better to call migration_entry_wait_huge(), after dropping locks,
before returning 0, so that we don't keep the cpu busy faulting while
the migration entry remains there.  Maybe not important, but better.

Probably best done with a goto unwinding code at end of function.

(Whereas we don't worry about "wait"s in the !pte_same case,
because !pte_same indicates that change is already occurring:
it's prolonged pte_same cases that we want to get away from.)

> +
>  	/*
>  	 * hugetlb_cow() requires page locks of pte_page(entry) and
>  	 * pagecache_page, so here we need take the former one
> @@ -3192,22 +3201,17 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	 * so no worry about deadlock.
>  	 */
>  	page = pte_page(entry);
> -	get_page(page);
>  	if (page != pagecache_page)
> -		lock_page(page);
> -
> -	ptl = huge_pte_lockptr(h, mm, ptep);
> -	spin_lock(ptl);
> -	/* Check for a racing update before calling hugetlb_cow */
> -	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
> -		goto out_ptl;
> +		if (!trylock_page(page))
> +			goto out_ptl;

And, again to avoid keeping the cpu busy refaulting, it would be better
to wait_on_page_locked(), after dropping locks, before returning 0;
probably best done with another goto end of function.

>  
> +	get_page(page);
>  
>  	if (flags & FAULT_FLAG_WRITE) {
>  		if (!huge_pte_write(entry)) {
>  			ret = hugetlb_cow(mm, vma, address, ptep, entry,
>  					pagecache_page, ptl);
> -			goto out_ptl;
> +			goto out_put_page;
>  		}
>  		entry = huge_pte_mkdirty(entry);
>  	}
> @@ -3215,7 +3219,11 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	if (huge_ptep_set_access_flags(vma, address, ptep, entry,
>  						flags & FAULT_FLAG_WRITE))
>  		update_mmu_cache(vma, address, ptep);
> -
> +out_put_page:
> +	put_page(page);

If I'm reading this correctly, there's now a small but nasty chance that
this put_page will be the one which frees the page, and the unlock_page
below will then be unlocking a freed page.  Our "Bad page" checks should
detect that case, so it won't be as serious as unlocking someone else's
page; but you still should avoid that possibility.

> +out_unlock_page:

mm/hugetlb.c:3231:1: warning: label `out_unlock_page' defined but not used [-Wunused-label]

> +	if (page != pagecache_page)
> +		unlock_page(page);
>  out_ptl:
>  	spin_unlock(ptl);
>  
> @@ -3223,10 +3231,6 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		unlock_page(pagecache_page);
>  		put_page(pagecache_page);
>  	}
> -	if (page != pagecache_page)
> -		unlock_page(page);
> -	put_page(page);
> -
>  out_mutex:
>  	mutex_unlock(&htlb_fault_mutex_table[hash]);
>  	return ret;
> -- 
> 1.9.3
