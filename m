Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3G3Qtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:49:46 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45322 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3G3Qtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:49:45 -0400
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
Subject: Re: [PATCH 01/18] mm, hugetlb: protect reserved pages when softofflining requests the pages
In-Reply-To: <1375075929-6119-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com> <1375075929-6119-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 30 Jul 2013 22:19:28 +0530
Message-ID: <8761vsq9gn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073016-0260-0000-0000-00000365241E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> alloc_huge_page_node() use dequeue_huge_page_node() without
> any validation check, so it can steal reserved page unconditionally.
> To fix it, check the number of free_huge_page in
> alloc_huge_page_node().


May be we should say. Don't use the reserve pool when soft offlining a huge
page. Check we have free pages outside the reserve pool before we
dequeue the huge page 

Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>


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
> -	struct page *page;
> +	struct page *page = NULL;
>
>  	spin_lock(&hugetlb_lock);
> -	page = dequeue_huge_page_node(h, nid);
> +	if (h->free_huge_pages - h->resv_huge_pages > 0)
> +		page = dequeue_huge_page_node(h, nid);
>  	spin_unlock(&hugetlb_lock);
>
>  	if (!page)
> -- 
> 1.7.9.5

