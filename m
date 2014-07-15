Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaGOQHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:07:42 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37436 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaGOQHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:07:39 -0400
Date: Tue, 15 Jul 2014 18:07:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140715160735.GB29269@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715155537.GA19454@nhori.bos.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-07-14 11:55:37, Naoya Horiguchi wrote:
> On Wed, Jun 18, 2014 at 04:40:45PM -0400, Johannes Weiner wrote:
> ...
> > diff --git a/mm/swap.c b/mm/swap.c
> > index a98f48626359..3074210f245d 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -62,6 +62,7 @@ static void __page_cache_release(struct page *page)
> >  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
> >  		spin_unlock_irqrestore(&zone->lru_lock, flags);
> >  	}
> > +	mem_cgroup_uncharge(page);
> >  }
> >  
> >  static void __put_single_page(struct page *page)
> 
> This seems to cause a list breakage in hstate->hugepage_activelist
> when freeing a hugetlbfs page.

This looks like a fall out from
http://marc.info/?l=linux-mm&m=140475936311294&w=2

I didn't get to review this one but the easiest fix seems to be check
HugePage and do not call uncharge.

> For hugetlbfs, we uncharge in free_huge_page() which is called after
> __page_cache_release(), so I think that we don't have to uncharge here.
> 
> In my testing, moving mem_cgroup_uncharge() inside if (PageLRU) block
> fixed the problem, so if that works for you, could you fold the change
> into your patch?
> 
> Thanks,
> Naoya Horiguchi
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
