Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaDUBBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 21:01:55 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4170 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751098AbaDUBBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 21:01:52 -0400
X-IronPort-AV: E=Sophos;i="4.97,894,1389715200"; 
   d="scan'208";a="29498323"
Message-ID: <53546DA3.2080709@cn.fujitsu.com>
Date: Mon, 21 Apr 2014 09:00:19 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: <akpm@linux-foundation.org>, <minchan@kernel.org>, <hannes@cmpxchg.org>,
        <shli@kernel.org>, <bob.liu@oracle.com>, <sjenning@linux.vnet.ibm.com>,
        <iamjoonsoo.kim@lge.com>, <aquini@redhat.com>, <mgorman@suse.de>,
        <riel@redhat.com>, <aarcange@redhat.com>, <khalid.aziz@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/swap: cleanup *lru_cache_add* functions
References: <1397835565-6411-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1397835565-6411-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianyu

On 04/18/2014 11:39 PM, Jianyu Zhan wrote:
> Hi, Christoph Hellwig,
> 
>> There are no modular users of lru_cache_add, so please don't needlessly
>> export it.
> 
> yep, I re-checked and found there is no module user of neither 
> lru_cache_add() nor lru_cache_add_anon(), so don't export it.
> 
> Here is the renewed patch:
> ---
> 
> In mm/swap.c, __lru_cache_add() is exported, but actually there are
> no users outside this file. However, lru_cache_add() is supposed to
> be used by vfs, or whatever others, but it is not exported.
> 
> This patch unexports __lru_cache_add(), and makes it static.
> It also exports lru_cache_add_file(), as it is use by cifs, which
> be loaded as module.

What should be exported?

lru_cache_add()
lru_cache_add_anon()
lru_cache_add_file()

It seems you only export lru_cache_add_file() in the patch.

Thanks

> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  include/linux/swap.h | 19 ++-----------------
>  mm/swap.c            | 31 +++++++++++++++++++++++--------
>  2 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 3507115..5a14b92 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -308,8 +308,9 @@ extern unsigned long nr_free_pagecache_pages(void);
>  
>  
>  /* linux/mm/swap.c */
> -extern void __lru_cache_add(struct page *);
>  extern void lru_cache_add(struct page *);
> +extern void lru_cache_add_anon(struct page *page);
> +extern void lru_cache_add_file(struct page *page);
>  extern void lru_add_page_tail(struct page *page, struct page *page_tail,
>  			 struct lruvec *lruvec, struct list_head *head);
>  extern void activate_page(struct page *);
> @@ -323,22 +324,6 @@ extern void swap_setup(void);
>  
>  extern void add_page_to_unevictable_list(struct page *page);
>  
> -/**
> - * lru_cache_add: add a page to the page lists
> - * @page: the page to add
> - */
> -static inline void lru_cache_add_anon(struct page *page)
> -{
> -	ClearPageActive(page);
> -	__lru_cache_add(page);
> -}
> -
> -static inline void lru_cache_add_file(struct page *page)
> -{
> -	ClearPageActive(page);
> -	__lru_cache_add(page);
> -}
> -
>  /* linux/mm/vmscan.c */
>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  					gfp_t gfp_mask, nodemask_t *mask);
> diff --git a/mm/swap.c b/mm/swap.c
> index ab3f508..c0cd7d0 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -582,13 +582,7 @@ void mark_page_accessed(struct page *page)
>  }
>  EXPORT_SYMBOL(mark_page_accessed);
>  
> -/*
> - * Queue the page for addition to the LRU via pagevec. The decision on whether
> - * to add the page to the [in]active [file|anon] list is deferred until the
> - * pagevec is drained. This gives a chance for the caller of __lru_cache_add()
> - * have the page added to the active list using mark_page_accessed().
> - */
> -void __lru_cache_add(struct page *page)
> +static void __lru_cache_add(struct page *page)
>  {
>  	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
>  
> @@ -598,11 +592,32 @@ void __lru_cache_add(struct page *page)
>  	pagevec_add(pvec, page);
>  	put_cpu_var(lru_add_pvec);
>  }
> -EXPORT_SYMBOL(__lru_cache_add);
> +
> +/**
> + * lru_cache_add: add a page to the page lists
> + * @page: the page to add
> + */
> +void lru_cache_add_anon(struct page *page)
> +{
> +	ClearPageActive(page);
> +	__lru_cache_add(page);
> +}
> +
> +void lru_cache_add_file(struct page *page)
> +{
> +	ClearPageActive(page);
> +	__lru_cache_add(page);
> +}
> +EXPORT_SYMBOL(lru_cache_add_file);
>  
>  /**
>   * lru_cache_add - add a page to a page list
>   * @page: the page to be added to the LRU.
> + *
> + * Queue the page for addition to the LRU via pagevec. The decision on whether
> + * to add the page to the [in]active [file|anon] list is deferred until the
> + * pagevec is drained. This gives a chance for the caller of lru_cache_add()
> + * have the page added to the active list using mark_page_accessed().
>   */
>  void lru_cache_add(struct page *page)
>  {
> 


-- 
Thanks.
Zhang Yanfei
