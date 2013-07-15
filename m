Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3GONzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:55:54 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48129 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3GONzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:55:52 -0400
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
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 6/9] mm, hugetlb: do not use a page in page cache for cow optimization
In-Reply-To: <1373881967-16153-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 19:25:40 +0530
Message-ID: <87d2qkj5b7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071513-2000-0000-0000-00000CE4FB17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

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

Do we need to trun of the optimization for page cache completely ?
Can't we check for MAP_PRIVATE case ?

Also, we may want to add the above test into libhugetlbfs 

>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d4a1695..6c1eb9b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2512,7 +2512,6 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  {
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *old_page, *new_page;
> -	int avoidcopy;
>  	int outside_reserve = 0;
>  	unsigned long mmun_start;	/* For mmu_notifiers */
>  	unsigned long mmun_end;		/* For mmu_notifiers */
> @@ -2522,10 +2521,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
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

-aneesh

