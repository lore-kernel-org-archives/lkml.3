Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3G2JRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:17:53 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52194 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3G2JRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <1375075701-5998-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375075701-5998-2-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 29 Jul 2013 17:17:51 +0800
Message-ID: <CAJd=RBB4vFovOupFL3DwLT0H+avYr=e+oU28OXUSvHWZJy0sTg@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] mm, hugetlb: move up the code which check
 availability of free huge page
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
> In this time we are holding a hugetlb_lock, so hstate values can't
> be changed. If we don't have any usable free huge page in this time,
> we don't need to proceede the processing. So move this code up.
>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
Acked-by: Hillf Danton <dhillf@gmail.com>

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e2bfbf7..fc4988c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -539,10 +539,6 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
>         struct zoneref *z;
>         unsigned int cpuset_mems_cookie;
>
> -retry_cpuset:
> -       cpuset_mems_cookie = get_mems_allowed();
> -       zonelist = huge_zonelist(vma, address,
> -                                       htlb_alloc_mask, &mpol, &nodemask);
>         /*
>          * A child process with MAP_PRIVATE mappings created by their parent
>          * have no page reserves. This check ensures that reservations are
> @@ -556,6 +552,11 @@ retry_cpuset:
>         if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
>                 goto err;
>
> +retry_cpuset:
> +       cpuset_mems_cookie = get_mems_allowed();
> +       zonelist = huge_zonelist(vma, address,
> +                                       htlb_alloc_mask, &mpol, &nodemask);
> +
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                                 MAX_NR_ZONES - 1, nodemask) {
>                 if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
> @@ -574,7 +575,6 @@ retry_cpuset:
>         return page;
>
>  err:
> -       mpol_cond_put(mpol);
>         return NULL;
>  }
>
> --
> 1.7.9.5
>
