Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaBEImj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:42:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaBEImh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:42:37 -0500
Date: Wed, 5 Feb 2014 09:42:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Holger Kiehl <Holger.Kiehl@dwd.de>, Christoph Lameter <cl@linux.com>,
        Rafael Aquini <aquini@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v2] mm, page_alloc: make first_page visible before
 PageTail
Message-ID: <20140205084235.GA30705@dhcp22.suse.cz>
References: <20140203122052.GC2495@dhcp22.suse.cz>
 <alpine.LRH.2.02.1402031426510.13382@diagnostix.dwd.de>
 <20140203162036.GJ2495@dhcp22.suse.cz>
 <52EFC93D.3030106@suse.cz>
 <alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com>
 <alpine.LRH.2.02.1402040713220.13901@diagnostix.dwd.de>
 <alpine.DEB.2.02.1402041557380.10140@chino.kir.corp.google.com>
 <20140204160641.8f5d369eeb2d0318618d6d5f@linux-foundation.org>
 <alpine.DEB.2.02.1402041613450.14962@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1402041621350.14962@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402041621350.14962@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-02-14 16:22:53, David Rientjes wrote:
> Commit bf6bddf1924e ("mm: introduce compaction and migration for ballooned
> pages") introduces page_count(page) into memory compaction which
> dereferences page->first_page if PageTail(page).
> 
> Introduce a store memory barrier to ensure page->first_page is properly
> initialized so that code that does page_count(page) on pages off the lru
> always have a valid p->first_page.
> 
> Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  v2: with commentary, per checkpatch
> 
>  mm/page_alloc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -369,9 +369,11 @@ void prep_compound_page(struct page *page, unsigned long order)
>  	__SetPageHead(page);
>  	for (i = 1; i < nr_pages; i++) {
>  		struct page *p = page + i;
> -		__SetPageTail(p);
>  		set_page_count(p, 0);
>  		p->first_page = page;
> +		/* Make sure p->first_page is always valid for PageTail() */
> +		smp_wmb();
> +		__SetPageTail(p);

Where is the pairing smp_rmb? I would expect it in comound_head.

>  	}
>  }
>  

-- 
Michal Hocko
SUSE Labs
