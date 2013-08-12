Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3HLNVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:21:15 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33339 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab3HLNVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:21:08 -0400
Message-ID: <1376313658.2457.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 01/20] mm, hugetlb: protect reserved pages when soft
 offlining a hugepage
From: Davidlohr Bueso <davidlohr@hp.com>
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
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Date: Mon, 12 Aug 2013 06:20:58 -0700
In-Reply-To: <1376040398-11212-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1376040398-11212-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 18:26 +0900, Joonsoo Kim wrote:
> Don't use the reserve pool when soft offlining a hugepage.
> Check we have free pages outside the reserve pool before we
> dequeue the huge page. Otherwise, we can steal other's reserve page.
> 
> Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

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


