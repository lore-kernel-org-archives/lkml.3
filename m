Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaJVQLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:11:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbaJVQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:11:41 -0400
Date: Wed, 22 Oct 2014 18:11:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] mm: memcontrol: remove unnecessary PCG_USED
 pc->mem_cgroup valid flag
Message-ID: <20141022161140.GG30802@dhcp22.suse.cz>
References: <1413818532-11042-1-git-send-email-hannes@cmpxchg.org>
 <1413818532-11042-5-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413818532-11042-5-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-10-14 11:22:12, Johannes Weiner wrote:
> pc->mem_cgroup had to be left intact after uncharge for the final LRU
> removal, and !PCG_USED indicated whether the page was uncharged.  But
> since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") pages are
> uncharged after the final LRU removal.  Uncharge can simply clear the
> pointer and the PCG_USED/PageCgroupUsed sites can test that instead.
> 
> Because this is the last page_cgroup flag, this patch reduces the
> memcg per-page overhead to a single pointer.

Nice. I have an old patch which stuck this flag into page_cgroup pointer
but this is of course much much better!
 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

Just a nit below

[...]
> @@ -2525,9 +2523,10 @@ struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)

memcg = NULL initialization is not needed now

>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  
>  	pc = lookup_page_cgroup(page);
> -	if (PageCgroupUsed(pc)) {
> -		memcg = pc->mem_cgroup;
> -		if (memcg && !css_tryget_online(&memcg->css))
> +	memcg = pc->mem_cgroup;
> +
> +	if (memcg) {
> +		if (!css_tryget_online(&memcg->css))
>  			memcg = NULL;
>  	} else if (PageSwapCache(page)) {
>  		ent.val = page_private(page);

>  #else
>  static inline void memcg_unregister_all_caches(struct mem_cgroup *memcg)
[...]
-- 
Michal Hocko
SUSE Labs
