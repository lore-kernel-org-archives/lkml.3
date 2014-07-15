Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbaGOSV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:21:58 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:63497 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbaGOSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:21:55 -0400
Date: Tue, 15 Jul 2014 20:21:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140715182152.GA30497@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
 <20140715160735.GB29269@dhcp22.suse.cz>
 <20140715173439.GU29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715173439.GU29639@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-07-14 13:34:39, Johannes Weiner wrote:
> On Tue, Jul 15, 2014 at 06:07:35PM +0200, Michal Hocko wrote:
> > On Tue 15-07-14 11:55:37, Naoya Horiguchi wrote:
> > > On Wed, Jun 18, 2014 at 04:40:45PM -0400, Johannes Weiner wrote:
> > > ...
> > > > diff --git a/mm/swap.c b/mm/swap.c
> > > > index a98f48626359..3074210f245d 100644
> > > > --- a/mm/swap.c
> > > > +++ b/mm/swap.c
> > > > @@ -62,6 +62,7 @@ static void __page_cache_release(struct page *page)
> > > >  		del_page_from_lru_list(page, lruvec, page_off_lru(page));
> > > >  		spin_unlock_irqrestore(&zone->lru_lock, flags);
> > > >  	}
> > > > +	mem_cgroup_uncharge(page);
> > > >  }
> > > >  
> > > >  static void __put_single_page(struct page *page)
> > > 
> > > This seems to cause a list breakage in hstate->hugepage_activelist
> > > when freeing a hugetlbfs page.
> > 
> > This looks like a fall out from
> > http://marc.info/?l=linux-mm&m=140475936311294&w=2
> > 
> > I didn't get to review this one but the easiest fix seems to be check
> > HugePage and do not call uncharge.
> 
> Yes, that makes sense.  I'm also moving the uncharge call into
> __put_single_page() and __put_compound_page() so that PageHuge(), a
> function call, only needs to be checked for compound pages.

Hmm, there doesn't seem to be any point in calling __page_cache_release
for HugePage as well. So it should be sufficient that
__put_compound_page doesn't call __page_cache_release for PageHuge and
uncharge can stay there. Maybe this would be slightly better...
-- 
Michal Hocko
SUSE Labs
