Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbaEMNg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:36:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbaEMNg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:36:27 -0400
Message-ID: <53721FD9.6000106@suse.cz>
Date: Tue, 13 May 2014 15:36:25 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 11/19] mm: page_alloc: Lookup pageblock migratetype with
 IRQs enabled during free
References: <1399974350-11089-1-git-send-email-mgorman@suse.de> <1399974350-11089-12-git-send-email-mgorman@suse.de>
In-Reply-To: <1399974350-11089-12-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 11:45 AM, Mel Gorman wrote:
> get_pageblock_migratetype() is called during free with IRQs disabled. This
> is unnecessary and disables IRQs for longer than necessary.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Rik van Riel <riel@redhat.com>

With a comment below,

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/page_alloc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3948f0a..fcbf637 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -773,9 +773,9 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>   	if (!free_pages_prepare(page, order))
>   		return;
>
> +	migratetype = get_pfnblock_migratetype(page, pfn);
>   	local_irq_save(flags);
>   	__count_vm_events(PGFREE, 1 << order);
> -	migratetype = get_pfnblock_migratetype(page, pfn);
>   	set_freepage_migratetype(page, migratetype);

The line above could be also outside disabled IRQ, no?

>   	free_one_page(page_zone(page), page, pfn, order, migratetype);
>   	local_irq_restore(flags);
>

