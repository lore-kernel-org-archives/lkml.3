Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3G2JUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:20:41 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46778 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3G2JUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <1375075701-5998-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375075701-5998-4-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 29 Jul 2013 17:20:39 +0800
Message-ID: <CAJd=RBA7iFOHvX6aOP517tyrWReSsLfC4zmV8PvVfE8px1WEMg@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] mm, hugetlb: clean-up alloc_huge_page()
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
> This patch unifies successful allocation paths to make the code more
> readable. There are no functional changes.
>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
Acked-by: Hillf Danton <dhillf@gmail.com>

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 51564a8..31d78c5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1149,12 +1149,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>         }
>         spin_lock(&hugetlb_lock);
>         page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
> -       if (page) {
> -               /* update page cgroup details */
> -               hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
> -                                            h_cg, page);
> -               spin_unlock(&hugetlb_lock);
> -       } else {
> +       if (!page) {
>                 spin_unlock(&hugetlb_lock);
>                 page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>                 if (!page) {
> @@ -1165,11 +1160,11 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>                         return ERR_PTR(-ENOSPC);
>                 }
>                 spin_lock(&hugetlb_lock);
> -               hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h),
> -                                            h_cg, page);
>                 list_move(&page->lru, &h->hugepage_activelist);
> -               spin_unlock(&hugetlb_lock);
> +               /* Fall through */
>         }
> +       hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, page);
> +       spin_unlock(&hugetlb_lock);
>
>         set_page_private(page, (unsigned long)spool);
>
> --
> 1.7.9.5
>
