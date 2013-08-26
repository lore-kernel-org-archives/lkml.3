Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3HZOMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:12:47 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39660 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3HZOMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:12:46 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 18/20] mm, hugetlb: clean-up error handling in hugetlb_cow()
In-Reply-To: <1376040398-11212-19-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-19-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 26 Aug 2013 19:42:35 +0530
Message-ID: <87haecczho.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082614-8256-0000-0000-000008F262F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Current code include 'Caller expects lock to be held' in every error path.
> We can clean-up it as we do error handling in one place.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 7e9a651..8743e5c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2500,6 +2500,7 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  	int outside_reserve = 0;
>  	long chg;
>  	bool use_reserve = false;
> +	int ret = 0;
>  	unsigned long mmun_start;	/* For mmu_notifiers */
>  	unsigned long mmun_end;		/* For mmu_notifiers */
>
> @@ -2524,10 +2525,8 @@ retry_avoidcopy:
>  	 * anon_vma prepared.
>  	 */
>  	if (unlikely(anon_vma_prepare(vma))) {
> -		page_cache_release(old_page);
> -		/* Caller expects lock to be held */
> -		spin_lock(&mm->page_table_lock);
> -		return VM_FAULT_OOM;
> +		ret = VM_FAULT_OOM;
> +		goto out_old_page;
>  	}
>
>  	/*
> @@ -2546,11 +2545,8 @@ retry_avoidcopy:
>  	if (!outside_reserve) {
>  		chg = vma_needs_reservation(h, vma, address);
>  		if (chg == -ENOMEM) {
> -			page_cache_release(old_page);
> -
> -			/* Caller expects lock to be held */
> -			spin_lock(&mm->page_table_lock);
> -			return VM_FAULT_OOM;
> +			ret = VM_FAULT_OOM;
> +			goto out_old_page;
>  		}
>  		use_reserve = !chg;
>  	}
> @@ -2584,9 +2580,8 @@ retry_avoidcopy:
>  			WARN_ON_ONCE(1);
>  		}
>
> -		/* Caller expects lock to be held */
> -		spin_lock(&mm->page_table_lock);
> -		return VM_FAULT_SIGBUS;
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_lock;
>  	}
>
>  	copy_user_huge_page(new_page, old_page, address, vma,
> @@ -2617,11 +2612,12 @@ retry_avoidcopy:
>  	spin_unlock(&mm->page_table_lock);
>  	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
>  	page_cache_release(new_page);
> +out_old_page:
>  	page_cache_release(old_page);
> -
> +out_lock:
>  	/* Caller expects lock to be held */
>  	spin_lock(&mm->page_table_lock);
> -	return 0;
> +	return ret;
>  }
>
>  /* Return the pagecache page at a given address within a VMA */
> -- 
> 1.7.9.5

