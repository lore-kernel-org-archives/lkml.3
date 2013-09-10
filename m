Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3IJHQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:16:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47543 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3IJHQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:16:55 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-5d-522ec76421c4
Message-id: <1378797411.15425.17.camel@AMDC1943>
Subject: Re: [RFC PATCH 1/4] zbud: use page ref counter for zbud pages
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Date: Tue, 10 Sep 2013 09:16:51 +0200
In-reply-to: <20130909194733.GE4701@variantweb.net>
References: <1377852176-30970-1-git-send-email-k.kozlowski@samsung.com>
 <1377852176-30970-2-git-send-email-k.kozlowski@samsung.com>
 <20130909194733.GE4701@variantweb.net>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xq7opx/WCDGb9N7KYs34Nm8XGGetZ
	LbpOTWWx+PTyAaPF2aY37BaXd81hs7i35j+rxdojd9ktJr97xmix7Ot7dotD+1axW8xrf8nq
	wOOxeM9LJo9NqzrZPDZ9msTucWLGbxaPB4c2s3h8fHqLxaNvyypGj82nqz0+b5IL4IzisklJ
	zcksSy3St0vgyri08Q17wUvzirPzDrE1MDZrdzFyckgImEgsXbOOBcIWk7hwbz1bFyMXh5DA
	UkaJzmkbWSCcz4wS399uBaviFTCQuLF3ARuILSzgJvHqzGx2EJtNwFhi8/IlYHERAX2J7tkr
	mEGamQXWMUvM3nIWrIhFQFVi6f/DTCA2J1DDxIk9TBAb1jFKbOjpBOtmFlCXmDRvETPETUoS
	u9s72SHi8hKb17xlhrhCUOLH5HssExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQmLoyw7GxcesDjEKcDAq8fAGHNMNEmJNLCuuzD3EKMHBrCTCKz5dL0iINyWx
	siq1KD++qDQntfgQIxMHp1QDY8mWWxdjfUu3b552pqr8H//6yqX5PzfOS3+Sqs9g6iTAJhOf
	w/3wUMcbTZVYxv86G7Kr4irk1K2MT78Vd2nNLGC48CAv6vqm99uaXF/3MkSv/8OzTmBmo+v6
	+c1zJ4W/OMwzSeLCZMcz22Pv6yot2vqgaNqCGZ5pCs9jVROtzM9POHH5bITlSiWW4oxEQy3m
	ouJEAPF7M7N/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On pon, 2013-09-09 at 14:47 -0500, Seth Jennings wrote:
> On Fri, Aug 30, 2013 at 10:42:53AM +0200, Krzysztof Kozlowski wrote:
> > Use page reference counter for zbud pages. The ref counter replaces
> > zbud_header.under_reclaim flag and ensures that zbud page won't be freed
> > when zbud_free() is called during reclaim. It allows implementation of
> > additional reclaim paths.
> 
> I like this idea.
> 
> > 
> > The page count is incremented when:
> >  - a handle is created and passed to zswap (in zbud_alloc()),
> >  - user-supplied eviction callback is called (in zbud_reclaim_page()).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Reviewed-by: Bob Liu <bob.liu@oracle.com>
> > ---
> >  mm/zbud.c |   97 +++++++++++++++++++++++++++++++++----------------------------
> >  1 file changed, 52 insertions(+), 45 deletions(-)
> > 
> > diff --git a/mm/zbud.c b/mm/zbud.c
> > index ad1e781..aa9a15c 100644
> > --- a/mm/zbud.c
> > +++ b/mm/zbud.c
> > @@ -109,7 +109,6 @@ struct zbud_header {
> >  	struct list_head lru;
> >  	unsigned int first_chunks;
> >  	unsigned int last_chunks;
> > -	bool under_reclaim;
> >  };
> > 
> >  /*****************
> > @@ -138,16 +137,9 @@ static struct zbud_header *init_zbud_page(struct page *page)
> >  	zhdr->last_chunks = 0;
> >  	INIT_LIST_HEAD(&zhdr->buddy);
> >  	INIT_LIST_HEAD(&zhdr->lru);
> > -	zhdr->under_reclaim = 0;
> >  	return zhdr;
> >  }
> > 
> > -/* Resets the struct page fields and frees the page */
> > -static void free_zbud_page(struct zbud_header *zhdr)
> > -{
> > -	__free_page(virt_to_page(zhdr));
> > -}
> > -
> >  /*
> >   * Encodes the handle of a particular buddy within a zbud page
> >   * Pool lock should be held as this function accesses first|last_chunks
> > @@ -188,6 +180,31 @@ static int num_free_chunks(struct zbud_header *zhdr)
> >  	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks - 1;
> >  }
> > 
> > +/*
> > + * Increases ref count for zbud page.
> > + */
> > +static void get_zbud_page(struct zbud_header *zhdr)
> > +{
> > +	get_page(virt_to_page(zhdr));
> > +}
> > +
> > +/*
> > + * Decreases ref count for zbud page and frees the page if it reaches 0
> > + * (no external references, e.g. handles).
> > + *
> > + * Returns 1 if page was freed and 0 otherwise.
> > + */
> > +static int put_zbud_page(struct zbud_header *zhdr)
> > +{
> > +	struct page *page = virt_to_page(zhdr);
> > +	if (put_page_testzero(page)) {
> > +		free_hot_cold_page(page, 0);
> > +		return 1;
> > +	}
> > +	return 0;
> > +}
> > +
> > +
> >  /*****************
> >   * API Functions
> >  *****************/
> > @@ -250,7 +267,7 @@ void zbud_destroy_pool(struct zbud_pool *pool)
> >  int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
> >  			unsigned long *handle)
> >  {
> > -	int chunks, i, freechunks;
> > +	int chunks, i;
> 
> This change (make freechunks a block local variable) is unrelated to the
> patch description and should be its own patch.

Sure, I will split this into 2 patches.


[...]
> >  		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
> >  	}
> > 
> > +	put_zbud_page(zhdr);
> >  	spin_unlock(&pool->lock);
> >  }
> > 
> > @@ -400,7 +414,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
> >   */
> >  int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
> >  {
> > -	int i, ret, freechunks;
> > +	int i, ret;
> >  	struct zbud_header *zhdr;
> >  	unsigned long first_handle = 0, last_handle = 0;
> > 
> > @@ -411,11 +425,24 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
> >  		return -EINVAL;
> >  	}
> >  	for (i = 0; i < retries; i++) {
> > +		if (list_empty(&pool->lru)) {
> > +			/*
> > +			 * LRU was emptied during evict calls in previous
> > +			 * iteration but put_zbud_page() returned 0 meaning
> > +			 * that someone still holds the page. This may
> > +			 * happen when some other mm mechanism increased
> > +			 * the page count.
> > +			 * In such case we succedded with reclaim.
> > +			 */
> > +			spin_unlock(&pool->lock);
> > +			return 0;
> > +		}
> >  		zhdr = list_tail_entry(&pool->lru, struct zbud_header, lru);
> > +		/* Move this last element to beginning of LRU */
> >  		list_del(&zhdr->lru);
> > -		list_del(&zhdr->buddy);
> > +		list_add(&zhdr->lru, &pool->lru);
> 
> This adds the entry back to the lru list, but the entry is never removed
> from the list.  I'm not sure how this could work.

The entry will be removed from LRU and un/buddied list in zbud_free()
called from eviction handler.

So this actually works well however I wonder if this may be a source of
race conditions because during the call to eviction handler, the zbud
header is still present on buddied list (till call to zbud_free()).

Another issue is that I haven't update the documentation for
zbud_reclaim_page(). I fix this in next version.


> >  		/* Protect zbud page against free */
> > -		zhdr->under_reclaim = true;
> > +		get_zbud_page(zhdr);
> >  		/*
> >  		 * We need encode the handles before unlocking, since we can
> >  		 * race with free that will set (first|last)_chunks to 0
> > @@ -440,29 +467,9 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
> >  				goto next;
> >  		}
> >  next:
> > -		spin_lock(&pool->lock);
> > -		zhdr->under_reclaim = false;
> > -		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
> > -			/*
> > -			 * Both buddies are now free, free the zbud page and
> > -			 * return success.
> > -			 */
> > -			free_zbud_page(zhdr);
> > -			pool->pages_nr--;
> > -			spin_unlock(&pool->lock);
> > +		if (put_zbud_page(zhdr))
> 
> There is a single put_zbud_page() regardless of result of the eviction
> attempts.  What if both buddies of a buddied zbud page are evicted?
> Then you leak the zbud page.  What if the eviction in an unbuddied zbud
> page failed?  Then you prematurely free the page and crash later.

This single put_zbud_page() puts the reference obtained few lines
earlier.

If one or two buddies are evicted then the eviction handler should call
zbud_free(). zbud_free() will put the initial ref count (obtained from
zbud_alloc()).

If the eviction handler failed then zbud_free() won't be called so the
initial ref count still be valid and this put_zbud_page() won't free the
page.

Let me show the flow of ref counts:
1. zbud_alloc() for first buddy, ref count = 1
2. zbud_alloc() for last buddy, ref count = 2
3. zbud_reclaim_page() start, ref count = 3
4. calling user eviction handler
5. zbud_free() for first buddy (called from handler), ref count = 2
6. zbud_free() for last buddy (called from handler), ref count = 1
7. zbud_reclaim_page() end, ref count = 0 (free the page)

If eviction handler fails at step 5 or 6, then the ref count won't drop
to 0 as zswap still holds the initial reference to handle.


Thanks for comments. I appreciate them very much.


Best regards,
Krzysztof



