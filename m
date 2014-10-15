Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaJOPSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:18:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaJOPSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:18:39 -0400
Date: Wed, 15 Oct 2014 17:18:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] mm: memcontrol: take a css reference for each
 charged page
Message-ID: <20141015151836.GG23547@dhcp22.suse.cz>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413303637-23862-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-10-14 12:20:34, Johannes Weiner wrote:
> Charges currently pin the css indirectly by playing tricks during
> css_offline(): user pages stall the offlining process until all of
> them have been reparented, whereas kmemcg acquires a keep-alive
> reference if outstanding kernel pages are detected at that point.
> 
> In preparation for removing all this complexity, make the pinning
> explicit and acquire a css references for every charged page.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/cgroup.h          | 26 +++++++++++++++++++++++
>  include/linux/percpu-refcount.h | 47 +++++++++++++++++++++++++++++++++--------
>  mm/memcontrol.c                 | 21 ++++++++++++++----
>  3 files changed, 81 insertions(+), 13 deletions(-)
> 
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 67dabe8b0aa6..a3feead6be15 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2256,6 +2256,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
>  		page_counter_uncharge(&old->memory, stock->nr_pages);
>  		if (do_swap_account)
>  			page_counter_uncharge(&old->memsw, stock->nr_pages);
> +		css_put_many(&old->css, stock->nr_pages);

I have suggested to add a comment about pairing css_get here because the
corresponding refill_stock doesn't take any reference which might be
little bit confusing. Nothing earth shattering of course...

>  		stock->nr_pages = 0;
>  	}
>  	stock->cached = NULL;
> @@ -2513,6 +2514,7 @@ bypass:
>  	return -EINTR;
>  
>  done_restock:
> +	css_get_many(&memcg->css, batch);
>  	if (batch > nr_pages)
>  		refill_stock(memcg, batch - nr_pages);
>  done:
[...]
-- 
Michal Hocko
SUSE Labs
