Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaKLTfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:35:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50341 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaKLTfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:35:00 -0500
Date: Wed, 12 Nov 2014 20:34:50 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: kamezawa.hiroyu@jp.fujitsu.com, "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        mina86@mina86.com, "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 1/2] mm: page_isolation: check pfn validity before access
Message-ID: <20141112193450.GA18936@dhcp22.suse.cz>
References: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cff998$ee0b31d0$ca219570$%yang@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-11-14 16:08:02, Weijie Yang wrote:
> In the undo path of start_isolate_page_range(), we need to check
> the pfn validity before access its page, or it will trigger an
> addressing exception if there is hole in the zone.

This looks a bit fishy to me. I am not familiar with the code much but
at least __offline_pages zone = page_zone(pfn_to_page(start_pfn)) so it
would blow up before we got here. Same applies to the other caller
alloc_contig_range. So either both need a fix and then
start_isolate_page_range doesn't need more checks or this is all
unnecessary.

Please do not make this code more obfuscated than it is already...

> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---
>  mm/page_isolation.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> index d1473b2..3ddc8b3 100644
> --- a/mm/page_isolation.c
> +++ b/mm/page_isolation.c
> @@ -137,8 +137,11 @@ int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
>  undo:
>  	for (pfn = start_pfn;
>  	     pfn < undo_pfn;
> -	     pfn += pageblock_nr_pages)
> -		unset_migratetype_isolate(pfn_to_page(pfn), migratetype);
> +	     pfn += pageblock_nr_pages) {
> +		page = __first_valid_page(pfn, pageblock_nr_pages);
> +		if (page)
> +			unset_migratetype_isolate(page, migratetype);
> +	}
>  
>  	return -EBUSY;
>  }
> -- 
> 1.7.0.4
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
