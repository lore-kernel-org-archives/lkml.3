Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaJHN16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:27:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756398AbaJHN15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:27:57 -0400
Date: Wed, 8 Oct 2014 15:27:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: memcontrol: take a css reference for each
 charged page
Message-ID: <20141008132754.GB4592@dhcp22.suse.cz>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
 <1411243235-24680-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411243235-24680-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 20-09-14 16:00:33, Johannes Weiner wrote:
> Charges currently pin the css indirectly by playing tricks during
> css_offline(): user pages stall the offlining process until all of
> them have been reparented, whereas kmemcg acquires a keep-alive
> reference if outstanding kernel pages are detected at that point.
> 
> In preparation for removing all this complexity, make the pinning
> explicit and acquire a css references for every charged page.

OK, all the added {un}charges/atomics happen in a page_counter paths so
there shouldn't be any noticeable overhead.

I cannot judge the percpu counter part but the rest seems OK to me.
Two minor suggestions below.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

For the memcg part
Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/cgroup.h          | 26 +++++++++++++++++++++++++
>  include/linux/percpu-refcount.h | 43 ++++++++++++++++++++++++++++++++---------
>  mm/memcontrol.c                 | 17 +++++++++++++++-
>  3 files changed, 76 insertions(+), 10 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 154161bb7d4c..b832c87ec43b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2317,6 +2317,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  		page_counter_uncharge(&old->memory, stock->nr_pages);
>  		if (do_swap_account)
>  			page_counter_uncharge(&old->memsw, stock->nr_pages);

		/* pairs with css_get_many in try_charge */
> +		css_put_many(&old->css, stock->nr_pages);
>  		stock->nr_pages = 0;
>  	}
>  	stock->cached = NULL;
[...]
> @@ -2803,8 +2808,10 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
>  		page_counter_uncharge(&memcg->memsw, nr_pages);
>  

Wouldn't a single out_css_put be more readable? I was quite confused
when I start reading the patch before I saw the next hunk.

>  	/* Not down to 0 */
> -	if (page_counter_uncharge(&memcg->kmem, nr_pages))
		goto out_css_put;

> +	if (page_counter_uncharge(&memcg->kmem, nr_pages)) {
> +		css_put_many(&memcg->css, nr_pages);
>  		return;
> +	}
>  
>  	/*
>  	 * Releases a reference taken in kmem_cgroup_css_offline in case
> @@ -2816,6 +2823,8 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg,
>  	 */
>  	if (memcg_kmem_test_and_clear_dead(memcg))
>  		css_put(&memcg->css);
> +

out_css_put:
> +	css_put_many(&memcg->css, nr_pages);
>  }
>  
>  /*
-- 
Michal Hocko
SUSE Labs
