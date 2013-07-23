Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3GWE0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab3GWE0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:26:38 -0400
Date: Tue, 23 Jul 2013 00:26:07 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Message-ID: <1374553567-p2x98j9o-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1374482191-3500-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1374482191-3500-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1374482191-3500-8-git-send-email-iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 07/10] mm, hugetlb: do not use a page in page cache for
 cow optimization
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1374482191-3500-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 05:36:28PM +0900, Joonsoo Kim wrote:
> Currently, we use a page with mapped count 1 in page cache for cow
> optimization. If we find this condition, we don't allocate a new
> page and copy contents. Instead, we map this page directly.
> This may introduce a problem that writting to private mapping overwrite
> hugetlb file directly. You can find this situation with following code.
> 
>         size = 20 * MB;
>         flag = MAP_SHARED;
>         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p == MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>                 return -1;
>         }
>         p[0] = 's';
>         fprintf(stdout, "BEFORE STEAL PRIVATE WRITE: %c\n", p[0]);
>         munmap(p, size);
> 
>         flag = MAP_PRIVATE;
>         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p == MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>         }
>         p[0] = 'c';
>         munmap(p, size);
> 
>         flag = MAP_SHARED;
>         p = mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p == MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>                 return -1;
>         }
>         fprintf(stdout, "AFTER STEAL PRIVATE WRITE: %c\n", p[0]);
>         munmap(p, size);
> 
> We can see that "AFTER STEAL PRIVATE WRITE: c", not "AFTER STEAL
> PRIVATE WRITE: s". If we turn off this optimization to a page
> in page cache, the problem is disappeared.

Looks good to me. Thanks for the fix.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 7ca8733..8a61638 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2508,7 +2508,6 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  {
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *old_page, *new_page;
> -	int avoidcopy;
>  	int outside_reserve = 0;
>  	unsigned long mmun_start;	/* For mmu_notifiers */
>  	unsigned long mmun_end;		/* For mmu_notifiers */
> @@ -2518,10 +2517,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  retry_avoidcopy:
>  	/* If no-one else is actually using this page, avoid the copy
>  	 * and just make the page writable */
> -	avoidcopy = (page_mapcount(old_page) == 1);
> -	if (avoidcopy) {
> -		if (PageAnon(old_page))
> -			page_move_anon_rmap(old_page, vma, address);
> +	if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
> +		page_move_anon_rmap(old_page, vma, address);
>  		set_huge_ptep_writable(vma, address, ptep);
>  		return 0;
>  	}
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
