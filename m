Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3LMREx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 12:04:53 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46618 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab3LMREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 12:04:52 -0500
Date: Fri, 13 Dec 2013 12:04:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] mm: page_alloc: Default allow file pages to use
 remote nodes for fair allocation policy
Message-ID: <20131213170443.GO22729@cmpxchg.org>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <1386943807-29601-8-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386943807-29601-8-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:10:07PM +0000, Mel Gorman wrote:
> Indications from Johannes that he wanted this. Needs some data and/or justification why
> thrash protection needs it plus docs describing how MPOL_LOCAL is now different before
> it should be considered finished. I do not necessarily agree this patch is necessary
> but it's worth punting it out there for discussion and testing.

I demonstrated enormous gains in the original submission of the fair
allocation patch and your tests haven't really shown downsides to the
cache-over-nodes portion of it.  So I don't see why we should revert
the cache-over-nodes fairness without any supporting data.

Reverting cross-node fairness for anon and slab is a good idea.  It
was always about cache and the original patch was too broad stroked,
but it doesn't invalidate everything it was about.

I can see, however, that we might want to make this configurable, but
I'm not eager on exporting user interfaces unless we have to.  As the
node-local fairness was never questioned by anybody, is it necessary
to make it configurable?  Shouldn't we be okay with just a single
vm.pagecache_interleave (name by Rik) sysctl that defaults to 1 but
allows users to go back to pagecache obeying mempolicy?

> Not signed off
> ---
>  mm/page_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bf49918..bce40c0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1885,7 +1885,8 @@ unsigned __bitwise__ zone_distribute_mode __read_mostly;
>  #define DISTRIBUTE_STUPID_ANON	(DISTRIBUTE_LOCAL_ANON|DISTRIBUTE_REMOTE_ANON)
>  #define DISTRIBUTE_STUPID_FILE	(DISTRIBUTE_LOCAL_FILE|DISTRIBUTE_REMOTE_FILE)
>  #define DISTRIBUTE_STUPID_SLAB	(DISTRIBUTE_LOCAL_SLAB|DISTRIBUTE_REMOTE_SLAB)
> -#define DISTRIBUTE_DEFAULT	(DISTRIBUTE_LOCAL_ANON|DISTRIBUTE_LOCAL_FILE|DISTRIBUTE_LOCAL_SLAB)
> +#define DISTRIBUTE_DEFAULT	(DISTRIBUTE_LOCAL_ANON|DISTRIBUTE_LOCAL_FILE|DISTRIBUTE_LOCAL_SLAB| \
> +				 DISTRIBUTE_REMOTE_FILE)
>  
>  /* Only these GFP flags are affected by the fair zone allocation policy */
>  #define DISTRIBUTE_GFP_MASK	((GFP_MOVABLE_MASK|__GFP_PAGECACHE))
> -- 
> 1.8.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
