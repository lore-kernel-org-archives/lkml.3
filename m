Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaJOSoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:44:20 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:41974 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaJOSoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:44:18 -0400
Date: Wed, 15 Oct 2014 14:44:10 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] mm: memcontrol: take a css reference for each
 charged page
Message-ID: <20141015184410.GB6442@phnom.home.cmpxchg.org>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-3-git-send-email-hannes@cmpxchg.org>
 <20141015151836.GG23547@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015151836.GG23547@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 05:18:36PM +0200, Michal Hocko wrote:
> On Tue 14-10-14 12:20:34, Johannes Weiner wrote:
> > Charges currently pin the css indirectly by playing tricks during
> > css_offline(): user pages stall the offlining process until all of
> > them have been reparented, whereas kmemcg acquires a keep-alive
> > reference if outstanding kernel pages are detected at that point.
> > 
> > In preparation for removing all this complexity, make the pinning
> > explicit and acquire a css references for every charged page.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> > ---
> >  include/linux/cgroup.h          | 26 +++++++++++++++++++++++
> >  include/linux/percpu-refcount.h | 47 +++++++++++++++++++++++++++++++++--------
> >  mm/memcontrol.c                 | 21 ++++++++++++++----
> >  3 files changed, 81 insertions(+), 13 deletions(-)
> > 
> [...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 67dabe8b0aa6..a3feead6be15 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2256,6 +2256,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
> >  		page_counter_uncharge(&old->memory, stock->nr_pages);
> >  		if (do_swap_account)
> >  			page_counter_uncharge(&old->memsw, stock->nr_pages);
> > +		css_put_many(&old->css, stock->nr_pages);
> 
> I have suggested to add a comment about pairing css_get here because the
> corresponding refill_stock doesn't take any reference which might be
> little bit confusing. Nothing earth shattering of course...

Ah, but this isn't the counter-part to refill_stock(), consume_stock()
is.  The references are taken for the charges, and those two functions
do not change the account.  css get/put pair exactly like page counter
charge/uncharge.
