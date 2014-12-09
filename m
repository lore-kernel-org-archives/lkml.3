Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaLIJYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:24:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbaLIJYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:24:30 -0500
Message-ID: <5486BFCB.4040305@suse.cz>
Date: Tue, 09 Dec 2014 10:24:27 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>, iamjoonsoo.kim@lge.com
CC: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: page_isolation: remove unnecessary freepage_migratetype
 check for unused page
References: <000201d01385$25a6c950$70f45bf0$%yang@samsung.com>
In-Reply-To: <000201d01385$25a6c950$70f45bf0$%yang@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 08:51 AM, Weijie Yang wrote:
> when we test the pages in a range is free or not, there is a little
> chance we encounter some page which is not in buddy but page_count is 0.
> That means that page could be in the page-freeing path but not in the
> buddy freelist, such as in pcplist

This shouldn't happen anymore IMHO. The pageblock is marked as 
MIGRATE_ISOLATE and then a lru+pcplist drain is performed. Nothing 
should be left on pcplist - anything newly freed goes directly to free 
lists. Hm, maybe it could be on lru cache, but that holds a page 
reference IIRC, so this test won't pass.

> or wait for the zone->lock which the
> tester is holding.

That could maybe happen, but is it worth testing? If yes, please add it 
in a comment to the code.

> Back to the freepage_migratetype, we use it for a cached value for decide
> which free-list the page go when freeing page. If the pageblock is isolated
> the page will go to free-list[MIGRATE_ISOLATE] even if the cached type is
> not MIGRATE_ISOLATE, the commit ad53f92e(fix incorrect isolation behavior
> by rechecking migratetype) patch series have ensure this.
>
> So the freepage_migratetype check for page_count==0 page in
> __test_page_isolated_in_pageblock() is meaningless.
> This patch removes the unnecessary freepage_migratetype check.
>
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---
>   mm/page_isolation.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index 6e5174d..f7c9183 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -223,8 +223,7 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
>   		page = pfn_to_page(pfn);
>   		if (PageBuddy(page))
>   			pfn += 1 << page_order(page);
> -		else if (page_count(page) == 0 &&
> -			get_freepage_migratetype(page) == MIGRATE_ISOLATE)
> +		else if (page_count(page) == 0)
>   			pfn += 1;
>   		else if (skip_hwpoisoned_pages && PageHWPoison(page)) {
>   			/*
>

