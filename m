Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3J2Jdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:33:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab3J2Jdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:33:31 -0400
Date: Tue, 29 Oct 2013 09:33:23 +0000
From: Mel Gorman <mgorman@suse.de>
To: zhang.mingjun@linaro.org
Cc: minchan@kernel.org, m.szyprowski@samsung.com, akpm@linux-foundation.org,
        haojian.zhuang@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Mingjun Zhang <troy.zhangmingjun@linaro.org>
Subject: Re: [PATCH] mm: cma: free cma page to buddy instead of being cpu hot
 page
Message-ID: <20131029093322.GA2400@suse.de>
References: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1382960569-6564-1-git-send-email-zhang.mingjun@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 07:42:49PM +0800, zhang.mingjun@linaro.org wrote:
> From: Mingjun Zhang <troy.zhangmingjun@linaro.org>
> 
> free_contig_range frees cma pages one by one and MIGRATE_CMA pages will be
> used as MIGRATE_MOVEABLE pages in the pcp list, it causes unnecessary
> migration action when these pages reused by CMA.
> 
> Signed-off-by: Mingjun Zhang <troy.zhangmingjun@linaro.org>
> ---
>  mm/page_alloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0ee638f..84b9d84 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1362,7 +1362,8 @@ void free_hot_cold_page(struct page *page, int cold)
>  	 * excessively into the page allocator
>  	 */
>  	if (migratetype >= MIGRATE_PCPTYPES) {
> -		if (unlikely(is_migrate_isolate(migratetype))) {
> +		if (unlikely(is_migrate_isolate(migratetype))
> +			|| is_migrate_cma(migratetype))
>  			free_one_page(zone, page, 0, migratetype);
>  			goto out;

This slightly impacts the page allocator free path for a marginal gain
on CMA which are relatively rare allocations. There is no obvious
benefit to this patch as I expect CMA allocations to flush the PCP lists
when a range of pages have been isolated and migrated. Is there any
measurable benefit to this patch?

-- 
Mel Gorman
SUSE Labs
