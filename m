Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3HUKta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:49:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35176 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3HUKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:49:29 -0400
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
Subject: Re: [PATCH v2 10/20] mm, hugetlb: remove resv_map_put()
In-Reply-To: <1376040398-11212-11-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-11-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 21 Aug 2013 16:19:20 +0530
Message-ID: <8761uzgvyn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082110-8878-0000-0000-0000087C1D6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> In following patch, I change vma_resv_map() to return resv_map
> for all case. This patch prepares it by removing resv_map_put() which
> doesn't works properly with following change, because it works only for
> HPAGE_RESV_OWNER's resv_map, not for all resv_maps.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 73034dd..869c3e0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2212,15 +2212,6 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
>  		kref_get(&resv->refs);
>  }
>
> -static void resv_map_put(struct vm_area_struct *vma)
> -{
> -	struct resv_map *resv = vma_resv_map(vma);
> -
> -	if (!resv)
> -		return;
> -	kref_put(&resv->refs, resv_map_release);
> -}

Why not have seperate functions to return vma_resv_map for
HPAGE_RESV_OWNER and one for put ? That way we could have something like

resv_map_hpage_resv_owner_get()
resv_map_hpge_resv_put() 

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> -
>  static void hugetlb_vm_op_close(struct vm_area_struct *vma)
>  {
>  	struct hstate *h = hstate_vma(vma);
> @@ -2237,7 +2228,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
>  		reserve = (end - start) -
>  			region_count(resv, start, end);
>
> -		resv_map_put(vma);
> +		kref_put(&resv->refs, resv_map_release);
>
>  		if (reserve) {
>  			hugetlb_acct_memory(h, -reserve);
> @@ -3164,8 +3155,8 @@ int hugetlb_reserve_pages(struct inode *inode,
>  		region_add(resv_map, from, to);
>  	return 0;
>  out_err:
> -	if (vma)
> -		resv_map_put(vma);
> +	if (vma && is_vma_resv_set(vma, HPAGE_RESV_OWNER))
> +		kref_put(&resv_map->refs, resv_map_release);

for this

    if (alloc)
           resv_map_hpage_resv_put();

>  	return ret;
>  }
>
> -- 
> 1.7.9.5

