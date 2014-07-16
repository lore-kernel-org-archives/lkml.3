Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbaGPO6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:58:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaGPO6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:58:15 -0400
Date: Wed, 16 Jul 2014 10:57:36 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140716145736.GA9794@nhori.redhat.com>
References: <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715155537.GA19454@nhori.bos.redhat.com>
 <20140715160735.GB29269@dhcp22.suse.cz>
 <20140715173439.GU29639@cmpxchg.org>
 <20140715184358.GA31550@nhori.bos.redhat.com>
 <20140715190454.GW29639@cmpxchg.org>
 <20140715204953.GA21016@nhori.bos.redhat.com>
 <20140715214843.GX29639@cmpxchg.org>
 <20140716133050.GA4644@nhori.redhat.com>
 <20140716141447.GY29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716141447.GY29639@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:14:47AM -0400, Johannes Weiner wrote:
...
> > >  	free_hot_cold_page(page, false);
> > >  }
> > >  
> > > @@ -75,7 +75,10 @@ static void __put_compound_page(struct page *page)
> > >  {
> > >  	compound_page_dtor *dtor;
> > >  
> > > -	__page_cache_release(page);
> > > +	if (!PageHuge(page)) {
> > > +		__page_cache_release(page);
> > > +		mem_cgroup_uncharge_page(page);
> 
> I reverted all these mm/swap.c changes again as well.  Instead,
> mem_cgroup_uncharge() now does a preliminary check if the page is
> charged before it touches page->lru.
> 
> That should be much more robust: now the vetting whether a page is
> valid for memcg happens at charge time only, all other operations
> check first if a page is charged before doing anything else to it.
> 
> These two places should be the only ones that need fixing then:

This change also passed my testing, so the problem should be fixed.

Thanks,
Naoya Horiguchi
