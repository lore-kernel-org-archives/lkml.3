Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbbALWSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:18:50 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57197 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbbALWSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:18:49 -0500
Date: Mon, 12 Jan 2015 17:18:39 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] mm: vmscan: account slab pages on memcg reclaim
Message-ID: <20150112221839.GB25609@phnom.home.cmpxchg.org>
References: <880700a513472a8b86fd3100aef674322c66c68e.1421054931.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880700a513472a8b86fd3100aef674322c66c68e.1421054931.git.vdavydov@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:30:37PM +0300, Vladimir Davydov wrote:
> Since try_to_free_mem_cgroup_pages() can now call slab shrinkers, we
> should initialize reclaim_state and account reclaimed slab pages in
> scan_control->nr_reclaimed.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  mm/vmscan.c |   33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 16f3e45742d6..b2c041139a51 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -367,13 +367,16 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>   * the ->seeks setting of the shrink function, which indicates the
>   * cost to recreate an object relative to that of an LRU page.
>   *
> - * Returns the number of reclaimed slab objects.
> + * Returns the number of reclaimed slab objects. The number of reclaimed
> + * pages is added to *@ret_nr_reclaimed.
>
>  static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>  				 struct mem_cgroup *memcg,
>  				 unsigned long nr_scanned,
> -				 unsigned long nr_eligible)
> +				 unsigned long nr_eligible,
> +				 unsigned long *ret_nr_reclaimed)

Can't we just return the number of pages directly from this function?

> @@ -426,7 +434,7 @@ void drop_slab_node(int nid)
>  		freed = 0;
>  		do {
>  			freed += shrink_slab(GFP_KERNEL, nid, memcg,
> -					     1000, 1000);
> +					     1000, 1000, &nr_reclaimed);
>  		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>  	} while (freed > 10);

This is the only caller that cares about the return value, and it's a
magic number that could probably be changed to comparing with a magic
number of pages instead.
