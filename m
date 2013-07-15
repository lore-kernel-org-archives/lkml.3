Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3GOO1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:27:48 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40051 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3GOO1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:27:46 -0400
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
Subject: Re: [PATCH 4/9] mm, hugetlb: fix and clean-up node iteration code to alloc or free
In-Reply-To: <1373881967-16153-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 19:57:37 +0530
Message-ID: <87y597j3ty.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071514-2674-0000-0000-000009CE3069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Current node iteration code have a minor problem which do one more
> node rotation if we can't succeed to allocate. For example,
> if we start to allocate at node 0, we stop to iterate at node 0.
> Then we start to allocate at node 1 for next allocation.

Can you explain the problem in a bit more detail

>
> I introduce new macros "for_each_node_mask_to_[alloc|free]" and
> fix and clean-up node iteration code to alloc or free.
> This makes code more understandable.
>

I found the existing code more readable. Obviously I haven't yet figured
out the problem you have observed with the code. 

> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 0067cf4..a838e6b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -752,33 +752,6 @@ static int hstate_next_node_to_alloc(struct hstate *h,
>  	return nid;
>  }
>
> -static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
> -{
> -	struct page *page;
> -	int start_nid;
> -	int next_nid;
> -	int ret = 0;
> -
> -	start_nid = hstate_next_node_to_alloc(h, nodes_allowed);
> -	next_nid = start_nid;
> -
> -	do {
> -		page = alloc_fresh_huge_page_node(h, next_nid);
> -		if (page) {
> -			ret = 1;
> -			break;
> -		}
> -		next_nid = hstate_next_node_to_alloc(h, nodes_allowed);
> -	} while (next_nid != start_nid);
> -
> -	if (ret)
> -		count_vm_event(HTLB_BUDDY_PGALLOC);
> -	else
> -		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
> -
> -	return ret;
> -}
> -
>  /*
>   * helper for free_pool_huge_page() - return the previously saved
>   * node ["this node"] from which to free a huge page.  Advance the
> @@ -797,6 +770,42 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
>  	return nid;
>  }
>
> +#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
> +	for (nr_nodes = nodes_weight(*mask),				\
> +		node = hstate_next_node_to_alloc(hs, mask);		\
> +		nr_nodes > 0 &&						\
> +		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
> +		nr_nodes--)
> +
> +#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
> +	for (nr_nodes = nodes_weight(*mask),				\
> +		node = hstate_next_node_to_free(hs, mask);		\
> +		nr_nodes > 0 &&						\
> +		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
> +		nr_nodes--)
> +
> +static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
> +{
> +	struct page *page;
> +	int nr_nodes, node;
> +	int ret = 0;
> +
> +	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {


This check for nodes_weight and fail right ? (nr_nodes == 0).  That is
not the case with the existing code. It will allocate from 
h->next_nid_to_alloc. Is that ok ?


> +		page = alloc_fresh_huge_page_node(h, node);
> +		if (page) {
> +			ret = 1;
> +			break;
> +		}
> +	}
> +
> +	if (ret)
> +		count_vm_event(HTLB_BUDDY_PGALLOC);
> +	else
> +		count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
> +
> +	return ret;
> +}
> +

-aneesh

