Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3G2HYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:24:48 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:35052 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3G2HYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <1375075929-6119-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375075929-6119-2-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 29 Jul 2013 15:24:46 +0800
Message-ID: <CAJd=RBCUJg5GJEQ2_heCt8S9LZzedGLbvYvivFkmvfMChPqaCg@mail.gmail.com>
Subject: Re: [PATCH 01/18] mm, hugetlb: protect reserved pages when
 softofflining requests the pages
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

On Mon, Jul 29, 2013 at 1:31 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> alloc_huge_page_node() use dequeue_huge_page_node() without
> any validation check, so it can steal reserved page unconditionally.

Well, why is it illegal to use reserved page here?

> To fix it, check the number of free_huge_page in alloc_huge_page_node().
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6782b41..d971233 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -935,10 +935,11 @@ static struct page *alloc_buddy_huge_page(struct hstate *h, int nid)
>   */
>  struct page *alloc_huge_page_node(struct hstate *h, int nid)
>  {
> -       struct page *page;
> +       struct page *page = NULL;
>
>         spin_lock(&hugetlb_lock);
> -       page = dequeue_huge_page_node(h, nid);
> +       if (h->free_huge_pages - h->resv_huge_pages > 0)
> +               page = dequeue_huge_page_node(h, nid);
>         spin_unlock(&hugetlb_lock);
>
>         if (!page)
> --
> 1.7.9.5
>
