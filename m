Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3HVTZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:25:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab3HVTZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:25:00 -0400
Date: Thu, 22 Aug 2013 15:24:50 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        gong.chen@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1377199490-b3gcxg5-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1377164907-24801-5-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377164907-24801-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1377164907-24801-5-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] mm/hwpoison: drop forward reference declarations
 __soft_offline_page()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1377164907-24801-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:48:26PM +0800, Wanpeng Li wrote:
> Drop forward reference declarations __soft_offline_page.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/memory-failure.c | 129 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 64 insertions(+), 65 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3bfb45f..0a52571 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1498,71 +1498,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
>  	return ret;
>  }
>  
> -static int __soft_offline_page(struct page *page, int flags);
> -
> -/**
> - * soft_offline_page - Soft offline a page.
> - * @page: page to offline
> - * @flags: flags. Same as memory_failure().
> - *
> - * Returns 0 on success, otherwise negated errno.
> - *
> - * Soft offline a page, by migration or invalidation,
> - * without killing anything. This is for the case when
> - * a page is not corrupted yet (so it's still valid to access),
> - * but has had a number of corrected errors and is better taken
> - * out.
> - *
> - * The actual policy on when to do that is maintained by
> - * user space.
> - *
> - * This should never impact any application or cause data loss,
> - * however it might take some time.
> - *
> - * This is not a 100% solution for all memory, but tries to be
> - * ``good enough'' for the majority of memory.
> - */
> -int soft_offline_page(struct page *page, int flags)
> -{
> -	int ret;
> -	unsigned long pfn = page_to_pfn(page);
> -	struct page *hpage = compound_trans_head(page);
> -
> -	if (PageHWPoison(page)) {
> -		pr_info("soft offline: %#lx page already poisoned\n", pfn);
> -		return -EBUSY;
> -	}
> -	if (!PageHuge(page) && PageTransHuge(hpage)) {
> -		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
> -			pr_info("soft offline: %#lx: failed to split THP\n",
> -				pfn);
> -			return -EBUSY;
> -		}
> -	}
> -
> -	ret = get_any_page(page, pfn, flags);
> -	if (ret < 0)
> -		return ret;
> -	if (ret) { /* for in-use pages */
> -		if (PageHuge(page))
> -			ret = soft_offline_huge_page(page, flags);
> -		else
> -			ret = __soft_offline_page(page, flags);
> -	} else { /* for free pages */
> -		if (PageHuge(page)) {
> -			set_page_hwpoison_huge_page(hpage);
> -			dequeue_hwpoisoned_huge_page(hpage);
> -			atomic_long_add(1 << compound_order(hpage),
> -					&num_poisoned_pages);
> -		} else {
> -			SetPageHWPoison(page);
> -			atomic_long_inc(&num_poisoned_pages);
> -		}
> -	}
> -	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
> -	return ret;
> -}
> -
>  static int __soft_offline_page(struct page *page, int flags)
>  {
>  	int ret;
> @@ -1649,3 +1584,66 @@ static int __soft_offline_page(struct page *page, int flags)
>  	}
>  	return ret;
>  }
> +
> +/**
> + * soft_offline_page - Soft offline a page.
> + * @page: page to offline
> + * @flags: flags. Same as memory_failure().
> + *
> + * Returns 0 on success, otherwise negated errno.
> + *
> + * Soft offline a page, by migration or invalidation,
> + * without killing anything. This is for the case when
> + * a page is not corrupted yet (so it's still valid to access),
> + * but has had a number of corrected errors and is better taken
> + * out.
> + *
> + * The actual policy on when to do that is maintained by
> + * user space.
> + *
> + * This should never impact any application or cause data loss,
> + * however it might take some time.
> + *
> + * This is not a 100% solution for all memory, but tries to be
> + * ``good enough'' for the majority of memory.
> + */
> +int soft_offline_page(struct page *page, int flags)
> +{
> +	int ret;
> +	unsigned long pfn = page_to_pfn(page);
> +	struct page *hpage = compound_trans_head(page);
> +
> +	if (PageHWPoison(page)) {
> +		pr_info("soft offline: %#lx page already poisoned\n", pfn);
> +		return -EBUSY;
> +	}
> +	if (!PageHuge(page) && PageTransHuge(hpage)) {
> +		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
> +			pr_info("soft offline: %#lx: failed to split THP\n",
> +				pfn);
> +			return -EBUSY;
> +		}
> +	}
> +
> +	ret = get_any_page(page, pfn, flags);
> +	if (ret < 0)
> +		return ret;
> +	if (ret) { /* for in-use pages */
> +		if (PageHuge(page))
> +			ret = soft_offline_huge_page(page, flags);
> +		else
> +			ret = __soft_offline_page(page, flags);
> +	} else { /* for free pages */
> +		if (PageHuge(page)) {
> +			set_page_hwpoison_huge_page(hpage);
> +			dequeue_hwpoisoned_huge_page(hpage);
> +			atomic_long_add(1 << compound_order(hpage),
> +					&num_poisoned_pages);
> +		} else {
> +			SetPageHWPoison(page);
> +			atomic_long_inc(&num_poisoned_pages);
> +		}
> +	}
> +	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
> +	return ret;
> +}
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
