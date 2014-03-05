Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaCEAjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:39:11 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47350 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaCEAjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:39:09 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-e2-5316722ce29c
Date: Wed, 5 Mar 2014 09:39:08 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 3/6] mm: add is_migrate_isolate_page_nolock() for cases
 where locking is undesirable
Message-ID: <20140305003908.GC2340@lge.com>
References: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
 <1393596904-16537-4-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393596904-16537-4-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:15:01PM +0100, Vlastimil Babka wrote:
> This patch complements the addition of get_pageblock_migratetype_nolock() for
> the case where is_migrate_isolate_page() cannot be called with zone->lock held.
> A race with set_pageblock_migratetype() may be detected, in which case a caller
> supplied argument is returned.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/page-isolation.h | 24 ++++++++++++++++++++++++
>  mm/hugetlb.c                   |  2 +-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
> index 3fff8e7..f7bd491 100644
> --- a/include/linux/page-isolation.h
> +++ b/include/linux/page-isolation.h
> @@ -2,10 +2,30 @@
>  #define __LINUX_PAGEISOLATION_H
>  
>  #ifdef CONFIG_MEMORY_ISOLATION
> +/*
> + * Should be called only with zone->lock held. In cases where locking overhead
> + * is undesirable, consider the _nolock version.
> + */
>  static inline bool is_migrate_isolate_page(struct page *page)
>  {
>  	return get_pageblock_migratetype(page) == MIGRATE_ISOLATE;
>  }
> +/*
> + * When called without zone->lock held, a race with set_pageblock_migratetype
> + * may result in bogus values. The race may be detected, in which case the
> + * value of race_fallback argument is returned. For details, see
> + * get_pageblock_migratetype_nolock().
> + */
> +static inline bool is_migrate_isolate_page_nolock(struct page *page,
> +		bool race_fallback)
> +{
> +	int migratetype = get_pageblock_migratetype_nolock(page, MIGRATE_TYPES);
> +
> +	if (unlikely(migratetype == MIGRATE_TYPES))
> +		return race_fallback;
> +
> +	return migratetype == MIGRATE_ISOLATE;
> +}
>  static inline bool is_migrate_isolate(int migratetype)
>  {
>  	return migratetype == MIGRATE_ISOLATE;
> @@ -15,6 +35,10 @@ static inline bool is_migrate_isolate_page(struct page *page)
>  {
>  	return false;
>  }
> +static inline bool is_migrate_isolate_page_nolock(struct page *page)
> +{
> +	return false;
> +}
>  static inline bool is_migrate_isolate(int migratetype)
>  {
>  	return false;

Nitpick.
You need race_fallback parameter for is_migrate_isolate_page_nolock().

