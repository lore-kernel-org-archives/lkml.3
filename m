Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab3HZOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:09:57 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59250 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab3HZOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:09:56 -0400
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
Subject: Re: [PATCH v2 17/20] mm, hugetlb: move up anon_vma_prepare()
In-Reply-To: <1376040398-11212-18-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-18-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 26 Aug 2013 19:39:48 +0530
Message-ID: <87k3j8czmb.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082613-5816-0000-0000-00000995FB63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> If we fail with a allocated hugepage, we need some effort to recover
> properly. So, it is better not to allocate a hugepage as much as possible.
> So move up anon_vma_prepare() which can be failed in OOM situation.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2372f75..7e9a651 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2520,6 +2520,17 @@ retry_avoidcopy:
>  	spin_unlock(&mm->page_table_lock);
>
>  	/*
> +	 * When the original hugepage is shared one, it does not have
> +	 * anon_vma prepared.
> +	 */
> +	if (unlikely(anon_vma_prepare(vma))) {
> +		page_cache_release(old_page);
> +		/* Caller expects lock to be held */
> +		spin_lock(&mm->page_table_lock);
> +		return VM_FAULT_OOM;
> +	}
> +
> +	/*
>  	 * If the process that created a MAP_PRIVATE mapping is about to
>  	 * perform a COW due to a shared page count, attempt to satisfy
>  	 * the allocation without using the existing reserves. The pagecache
> @@ -2578,18 +2589,6 @@ retry_avoidcopy:
>  		return VM_FAULT_SIGBUS;
>  	}
>
> -	/*
> -	 * When the original hugepage is shared one, it does not have
> -	 * anon_vma prepared.
> -	 */
> -	if (unlikely(anon_vma_prepare(vma))) {
> -		page_cache_release(new_page);
> -		page_cache_release(old_page);
> -		/* Caller expects lock to be held */
> -		spin_lock(&mm->page_table_lock);
> -		return VM_FAULT_OOM;
> -	}
> -
>  	copy_user_huge_page(new_page, old_page, address, vma,
>  			    pages_per_huge_page(h));
>  	__SetPageUptodate(new_page);
> -- 
> 1.7.9.5

