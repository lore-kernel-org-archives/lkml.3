Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaIJJQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:16:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaIJJQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:16:09 -0400
Date: Wed, 10 Sep 2014 10:16:03 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Leon Romanovsky <leon@leon.nu>, Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] mm: page_alloc: Fix setting of ZONE_FAIR_DEPLETED on UP
 v2
Message-ID: <20140910091603.GS17501@suse.de>
References: <1404893588-21371-1-git-send-email-mgorman@suse.de>
 <1404893588-21371-7-git-send-email-mgorman@suse.de>
 <53E4EC53.1050904@suse.cz>
 <20140811121241.GD7970@suse.de>
 <53E8B83D.1070004@suse.cz>
 <20140902140116.GD29501@cmpxchg.org>
 <20140905101451.GF17501@suse.de>
 <CALq1K=JO2b-=iq40RRvK8JFFbrzyH5EyAp5jyS50CeV0P3eQcA@mail.gmail.com>
 <20140908115718.GL17501@suse.de>
 <20140909125318.b07aee9f77b5a15d6b3041f1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140909125318.b07aee9f77b5a15d6b3041f1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:53:18PM -0700, Andrew Morton wrote:
> On Mon, 8 Sep 2014 12:57:18 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > zone_page_state is an API hazard because of the difference in behaviour
> > between SMP and UP is very surprising. There is a good reason to allow
> > NR_ALLOC_BATCH to go negative -- when the counter is reset the negative
> > value takes recent activity into account. This patch makes zone_page_state
> > behave the same on SMP and UP as saving one branch on UP is not likely to
> > make a measurable performance difference.
> > 
> > ...
> >
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -131,10 +131,8 @@ static inline unsigned long zone_page_state(struct zone *zone,
> >  					enum zone_stat_item item)
> >  {
> >  	long x = atomic_long_read(&zone->vm_stat[item]);
> > -#ifdef CONFIG_SMP
> >  	if (x < 0)
> >  		x = 0;
> > -#endif
> >  	return x;
> >  }
> 
> We now have three fixes for the same thing. 

This might be holding a record for most patches for what should have
been a trivial issue :P

> I'm presently holding on
> to hannes's mm-page_alloc-fix-zone-allocation-fairness-on-up.patch.
> 

This is my preferred fix because it clearly points to where the source of the
original problem is. Furthermore, the second hunk really should be reading
the unsigned counter value. It's an inconsequential corner-case but it's
still more correct although it's a pity that it's also a layering violation.
However, adding a new API to return the raw value on UP and SMP is likely
to be interpreted as unwelcome indirection.

> Regularizing zone_page_state() in this fashion seems a good idea and is
> presumably safe because callers have been tested with SMP.  So unless
> shouted at I think I'll queue this one for 3.18?

Both are ok but if we really want to regularise the API then all readers
should be brought in line and declared an API cleanup. That looks like
the following;

---8<---
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH] mm: vmstat: regularize UP and SMP behavior

zone_page_state and friends are an API hazard because of the difference in
behaviour between SMP and UP is very surprising.  There is a good reason
to allow NR_ALLOC_BATCH to go negative -- when the counter is reset the
negative value takes recent activity into account. NR_ALLOC_BATCH callers
that matter access the raw counter but the API hazard is a lesson.

This patch makes zone_page_state, global_page_state and
zone_page_state_snapshot return the same values on SMP and UP as saving
the branches on UP is unlikely to make a measurable performance difference.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Leon Romanovsky <leon@leon.nu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/vmstat.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 82e7db7..873104e 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -120,10 +120,8 @@ static inline void zone_page_state_add(long x, struct zone *zone,
 static inline unsigned long global_page_state(enum zone_stat_item item)
 {
 	long x = atomic_long_read(&vm_stat[item]);
-#ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
-#endif
 	return x;
 }
 
@@ -131,10 +129,8 @@ static inline unsigned long zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
 	long x = atomic_long_read(&zone->vm_stat[item]);
-#ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
-#endif
 	return x;
 }
 
@@ -153,10 +149,10 @@ static inline unsigned long zone_page_state_snapshot(struct zone *zone,
 	int cpu;
 	for_each_online_cpu(cpu)
 		x += per_cpu_ptr(zone->pageset, cpu)->vm_stat_diff[item];
-
+#endif
 	if (x < 0)
 		x = 0;
-#endif
+
 	return x;
 }
 
