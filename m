Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3JIHIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:08:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30404 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab3JIHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:08:36 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-5b-525500f1c8c0
Message-id: <1381302512.6638.0.camel@AMDC1943>
Subject: Re: [PATCH v3 1/6] zbud: use page ref counter for zbud pages
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Date: Wed, 09 Oct 2013 09:08:32 +0200
In-reply-to: <20131008204317.GA8798@medulla.variantweb.net>
References: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
 <1381238980-2491-2-git-send-email-k.kozlowski@samsung.com>
 <20131008204317.GA8798@medulla.variantweb.net>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xy7ofGUKDDO4cNrKYs34Nm8XGGetZ
	LbpOTWWx+PTyAaPF2aY37BaXd81hs7i35j+rxdojd9ktJr97xmix7Ot7dotD+1axW8xrf8nq
	wOOxeM9LJo9NqzrZPDZ9msTucWLGbxaPB4c2s3h8fHqLxaNvyypGj82nqz0+b5IL4IzisklJ
	zcksSy3St0vgyti87hNTwTrZim3bgxsYj4t1MXJySAiYSPSvncsCYYtJXLi3ng3EFhJYyijR
	f0kIwv7MKHHzoi6IzSugJ7HuwwtWEFtYwFVi/cGdzCA2m4CxxOblS8B6RQT0JbpnrwCKc3Ew
	C6xjlljX8xusiEVAVaJpdQtYEaeAtcSa3YcZQYqEBLYwSqy8fg9sKrOAusSkeYuYIS5Sktjd
	3skOEZeX2LzmLTPEFYISPybfY5nAKDALScssJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1ya
	l66XnJ+7iRESPV93MC49ZnWIUYCDUYmHt4M3JEiINbGsuDL3EKMEB7OSCG/eQqAQb0piZVVq
	UX58UWlOavEhRiYOTqkGxnwduy8P12YYz3yzbIrFR3+1tvZdLgUH3u6q/el12HbPYyG9qlMz
	0pn3pfAr3O9NU+5n1nv1fOX27JKXnMkmyQwrAmN33g3abmJwWjtb7VpBSqXp0eKZT9Qrzf5f
	WrFXwuxR98lp7LO6/c9MNTWcw7toWtPvT8oz2mM4eXXLsyakuNpd4DKMUWIpzkg01GIuKk4E
	ALFOSxR8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2013-10-08 at 15:43 -0500, Seth Jennings wrote:
> On Tue, Oct 08, 2013 at 03:29:35PM +0200, Krzysztof Kozlowski wrote:
> > Use page reference counter for zbud pages. The ref counter replaces
> > zbud_header.under_reclaim flag and ensures that zbud page won't be freed
> > when zbud_free() is called during reclaim. It allows implementation of
> > additional reclaim paths.
> > 
> > The page count is incremented when:
> >  - a handle is created and passed to zswap (in zbud_alloc()),
> >  - user-supplied eviction callback is called (in zbud_reclaim_page()).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Reviewed-by: Bob Liu <bob.liu@oracle.com>
> 
> Other than the nit below:
> 
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Thank you for ACK-s (here and in other patches).


> > ---
> >  mm/zbud.c |  117 +++++++++++++++++++++++++++++++++----------------------------
> >  1 file changed, 64 insertions(+), 53 deletions(-)
> > 
> > diff --git a/mm/zbud.c b/mm/zbud.c
> > index 9451361..7574289 100644
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
> > @@ -273,6 +290,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
> >  				bud = FIRST;
> >  			else
> >  				bud = LAST;
> > +			get_zbud_page(zhdr);
> >  			goto found;
> >  		}
> >  	}
> > @@ -284,6 +302,10 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
> >  		return -ENOMEM;
> >  	spin_lock(&pool->lock);
> >  	pool->pages_nr++;
> > +	/*
> > +	 * We will be using zhdr instead of page, so
> > +	 * don't increase the page count.
> > +	 */
> 
> This comment isn't very clear.  I think what you mean to say is that
> we already have the page ref'ed for this entry because of the initial
> ref count done by alloc_page().
> 
> So maybe:
> 
> /*
>  * Page count is incremented by alloc_page() for the initial
>  * reference so no need to call zbud_get_page() here.
>  */

Good point. I'll change it.

Best regards,
Krzysztof

