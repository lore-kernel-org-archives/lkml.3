Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaGOP4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbaGOP4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:56:02 -0400
Date: Tue, 15 Jul 2014 11:55:37 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140715155537.GA19454@nhori.bos.redhat.com>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:40:45PM -0400, Johannes Weiner wrote:
...
> diff --git a/mm/swap.c b/mm/swap.c
> index a98f48626359..3074210f245d 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -62,6 +62,7 @@ static void __page_cache_release(struct page *page)
>  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
>  		spin_unlock_irqrestore(&zone->lru_lock, flags);
>  	}
> +	mem_cgroup_uncharge(page);
>  }
>  
>  static void __put_single_page(struct page *page)

This seems to cause a list breakage in hstate->hugepage_activelist
when freeing a hugetlbfs page.
For hugetlbfs, we uncharge in free_huge_page() which is called after
__page_cache_release(), so I think that we don't have to uncharge here.

In my testing, moving mem_cgroup_uncharge() inside if (PageLRU) block
fixed the problem, so if that works for you, could you fold the change
into your patch?

Thanks,
Naoya Horiguchi
