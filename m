Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaBHLos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 06:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaBHLoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 06:44:46 -0500
Date: Sat, 8 Feb 2014 09:43:35 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 02/10] fs: cachefiles: use add_to_page_cache_lru()
Message-ID: <20140208114334.GA25841@localhost.localdomain>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
 <1391475222-1169-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391475222-1169-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 07:53:34PM -0500, Johannes Weiner wrote:
> This code used to have its own lru cache pagevec up until a0b8cab3
> ("mm: remove lru parameter from __pagevec_lru_add and remove parts of
> pagevec API").  Now it's just add_to_page_cache() followed by
> lru_cache_add(), might as well use add_to_page_cache_lru() directly.
>

Just a heads-up, here: take a look at https://lkml.org/lkml/2014/2/7/587

I'm not saying that hunks below will cause the same leak issue as depicted on 
the thread I pointed, but it surely doesn't hurt to double-check them

Regards,
-- Rafael

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Minchan Kim <minchan@kernel.org>
> ---
>  fs/cachefiles/rdwr.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
> index ebaff368120d..4b1fb5ca65b8 100644
> --- a/fs/cachefiles/rdwr.c
> +++ b/fs/cachefiles/rdwr.c
> @@ -265,24 +265,22 @@ static int cachefiles_read_backing_file_one(struct cachefiles_object *object,
>  				goto nomem_monitor;
>  		}
>  
> -		ret = add_to_page_cache(newpage, bmapping,
> -					netpage->index, cachefiles_gfp);
> +		ret = add_to_page_cache_lru(newpage, bmapping,
> +					    netpage->index, cachefiles_gfp);
>  		if (ret == 0)
>  			goto installed_new_backing_page;
>  		if (ret != -EEXIST)
>  			goto nomem_page;
>  	}
>  
> -	/* we've installed a new backing page, so now we need to add it
> -	 * to the LRU list and start it reading */
> +	/* we've installed a new backing page, so now we need to start
> +	 * it reading */
>  installed_new_backing_page:
>  	_debug("- new %p", newpage);
>  
>  	backpage = newpage;
>  	newpage = NULL;
>  
> -	lru_cache_add_file(backpage);
> -
>  read_backing_page:
>  	ret = bmapping->a_ops->readpage(NULL, backpage);
>  	if (ret < 0)
> @@ -510,24 +508,23 @@ static int cachefiles_read_backing_file(struct cachefiles_object *object,
>  					goto nomem;
>  			}
>  
> -			ret = add_to_page_cache(newpage, bmapping,
> -						netpage->index, cachefiles_gfp);
> +			ret = add_to_page_cache_lru(newpage, bmapping,
> +						    netpage->index,
> +						    cachefiles_gfp);
>  			if (ret == 0)
>  				goto installed_new_backing_page;
>  			if (ret != -EEXIST)
>  				goto nomem;
>  		}
>  
> -		/* we've installed a new backing page, so now we need to add it
> -		 * to the LRU list and start it reading */
> +		/* we've installed a new backing page, so now we need
> +		 * to start it reading */
>  	installed_new_backing_page:
>  		_debug("- new %p", newpage);
>  
>  		backpage = newpage;
>  		newpage = NULL;
>  
> -		lru_cache_add_file(backpage);
> -
>  	reread_backing_page:
>  		ret = bmapping->a_ops->readpage(NULL, backpage);
>  		if (ret < 0)
> @@ -538,8 +535,8 @@ static int cachefiles_read_backing_file(struct cachefiles_object *object,
>  	monitor_backing_page:
>  		_debug("- monitor add");
>  
> -		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
> -					cachefiles_gfp);
> +		ret = add_to_page_cache_lru(netpage, op->mapping,
> +					    netpage->index, cachefiles_gfp);
>  		if (ret < 0) {
>  			if (ret == -EEXIST) {
>  				page_cache_release(netpage);
> @@ -549,8 +546,6 @@ static int cachefiles_read_backing_file(struct cachefiles_object *object,
>  			goto nomem;
>  		}
>  
> -		lru_cache_add_file(netpage);
> -
>  		/* install a monitor */
>  		page_cache_get(netpage);
>  		monitor->netfs_page = netpage;
> @@ -613,8 +608,8 @@ static int cachefiles_read_backing_file(struct cachefiles_object *object,
>  	backing_page_already_uptodate:
>  		_debug("- uptodate");
>  
> -		ret = add_to_page_cache(netpage, op->mapping, netpage->index,
> -					cachefiles_gfp);
> +		ret = add_to_page_cache_lru(netpage, op->mapping,
> +					    netpage->index, cachefiles_gfp);
>  		if (ret < 0) {
>  			if (ret == -EEXIST) {
>  				page_cache_release(netpage);
> @@ -631,8 +626,6 @@ static int cachefiles_read_backing_file(struct cachefiles_object *object,
>  
>  		fscache_mark_page_cached(op, netpage);
>  
> -		lru_cache_add_file(netpage);
> -
>  		/* the netpage is unlocked and marked up to date here */
>  		fscache_end_io(op, netpage, 0);
>  		page_cache_release(netpage);
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
