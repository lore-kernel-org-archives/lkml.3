Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3G2Jda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:33:30 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39933 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3G2Jd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <1375075701-5998-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375075701-5998-7-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 29 Jul 2013 17:33:28 +0800
Message-ID: <CAJd=RBArqpk6+7u3zMkUyEpMmvjZwr35cNy_5t0BcEz2sV9=bw@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] mm, hugetlb: do not use a page in page cache for
 cow optimization
From: Hillf Danton <dhillf@gmail.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 1:28 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
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
>
> So, I change the trigger condition of optimization. If this page is not
> AnonPage, we don't do optimization. This makes this optimization turning
> off for a page cache.
>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
Acked-by: Hillf Danton <dhillf@gmail.com>

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2e52afea..1f6b3a6 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2511,7 +2511,6 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  {
>         struct hstate *h = hstate_vma(vma);
>         struct page *old_page, *new_page;
> -       int avoidcopy;
>         int outside_reserve = 0;
>         unsigned long mmun_start;       /* For mmu_notifiers */
>         unsigned long mmun_end;         /* For mmu_notifiers */
> @@ -2521,10 +2520,8 @@ static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
>  retry_avoidcopy:
>         /* If no-one else is actually using this page, avoid the copy
>          * and just make the page writable */
> -       avoidcopy = (page_mapcount(old_page) == 1);
> -       if (avoidcopy) {
> -               if (PageAnon(old_page))
> -                       page_move_anon_rmap(old_page, vma, address);
> +       if (page_mapcount(old_page) == 1 && PageAnon(old_page)) {
> +               page_move_anon_rmap(old_page, vma, address);
>                 set_huge_ptep_writable(vma, address, ptep);
>                 return 0;
>         }
> --
> 1.7.9.5
>
