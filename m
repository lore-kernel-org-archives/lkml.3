Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3HZNqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:46:46 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45341 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3HZNqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:46:45 -0400
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
Subject: Re: [PATCH v2 14/20] mm, hugetlb: call vma_needs_reservation before entering alloc_huge_page()
In-Reply-To: <87vc2sd15e.fsf@linux.vnet.ibm.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-15-git-send-email-iamjoonsoo.kim@lge.com> <87vc2sd15e.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 26 Aug 2013 19:16:33 +0530
Message-ID: <87mwo4d0p2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082613-1396-0000-0000-00000374BDA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>
>> In order to validate that this failure is reasonable, we need to know
>> whether allocation request is for reserved or not on caller function.
>> So moving vma_needs_reservation() up to the caller of alloc_huge_page().
>> There is no functional change in this patch and following patch use
>> this information.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 8dff972..bc666cf 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1110,13 +1110,11 @@ static void vma_commit_reservation(struct hstate *h,
>>  }
>>
>>  static struct page *alloc_huge_page(struct vm_area_struct *vma,
>> -				    unsigned long addr, int avoid_reserve)
>> +				    unsigned long addr, int use_reserve)
>>  {
>>  	struct hugepage_subpool *spool = subpool_vma(vma);
>>  	struct hstate *h = hstate_vma(vma);
>>  	struct page *page;
>> -	long chg;
>> -	bool use_reserve;
>>  	int ret, idx;
>>  	struct hugetlb_cgroup *h_cg;
>>
>> @@ -1129,10 +1127,6 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>>  	 * need pages and subpool limit allocated allocated if no reserve
>>  	 * mapping overlaps.
>>  	 */
>> -	chg = vma_needs_reservation(h, vma, addr);
>> -	if (chg < 0)
>> -		return ERR_PTR(-ENOMEM);
>> -	use_reserve = (!chg && !avoid_reserve);
>>  	if (!use_reserve)
>>  		if (hugepage_subpool_get_pages(spool, 1))
>>  			return ERR_PTR(-ENOSPC);
>> @@ -2504,6 +2498,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>>  	struct hstate *h = hstate_vma(vma);
>>  	struct page *old_page, *new_page;
>>  	int outside_reserve = 0;
>> +	long chg;
>> +	bool use_reserve;
>>  	unsigned long mmun_start;	/* For mmu_notifiers */
>>  	unsigned long mmun_end;		/* For mmu_notifiers */
>>
>> @@ -2535,7 +2531,17 @@ retry_avoidcopy:
>>
>>  	/* Drop page_table_lock as buddy allocator may be called */
>>  	spin_unlock(&mm->page_table_lock);
>> -	new_page = alloc_huge_page(vma, address, outside_reserve);
>> +	chg = vma_needs_reservation(h, vma, address);
>> +	if (chg == -ENOMEM) {
>
> why not 
>
>     if (chg < 0) ?
>
> Should we try to unmap the page from child and avoid cow here ?. May be
> with outside_reserve = 1 we will never have vma_needs_reservation fail.
> Any how it would be nice to document why this error case is different
> from alloc_huge_page error case.
>

I guess patch  16 address this . So if we do if (chg < 0) we are good
here.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh

