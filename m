Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaEBMHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:07:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaEBMHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:07:17 -0400
Date: Fri, 2 May 2014 14:07:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] memcg, mm: introduce lowlimit reclaim
Message-ID: <20140502120715.GI3446@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-2-git-send-email-mhocko@suse.cz>
 <20140430225550.GD26041@cmpxchg.org>
 <20140502093628.GC3446@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502093628.GC3446@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-05-14 11:36:28, Michal Hocko wrote:
> On Wed 30-04-14 18:55:50, Johannes Weiner wrote:
> > On Mon, Apr 28, 2014 at 02:26:42PM +0200, Michal Hocko wrote:
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 19d620b3d69c..40e517630138 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -2808,6 +2808,29 @@ static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
> > >  	return mem_cgroup_from_id(id);
> > >  }
> > >  
> > > +/**
> > > + * mem_cgroup_reclaim_eligible - checks whether given memcg is eligible for the
> > > + * reclaim
> > > + * @memcg: target memcg for the reclaim
> > > + * @root: root of the reclaim hierarchy (null for the global reclaim)
> > > + *
> > > + * The given group is reclaimable if it is above its low limit and the same
> > > + * applies for all parents up the hierarchy until root (including).
> > > + */
> > > +bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
> > > +		struct mem_cgroup *root)
> > 
> > Could you please rename this to something that is more descriptive in
> > the reclaim callsite?  How about mem_cgroup_within_low_limit()?
> 
> I have intentionally used somethig that is not low_limit specific. The
> generic reclaim code does't have to care about the reason why a memcg is
> not reclaimable. I agree that having follow_low_limit paramter explicit
> and mem_cgroup_reclaim_eligible not is messy. So something should be
> renamed. I would probably go with s@follow_low_limit@check_reclaim_eligible@
> but I do not have a strong preference.

What about this?
---
>From cbe72efdf89b89d60004c84b359fc3d95db61983 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 2 May 2014 14:03:49 +0200
Subject: [PATCH] mmotm: memcg-mm-introduce-lowlimit-reclaim-fix.patch

Use reclaim eligibility rather than low_limit. Generic code doesn't
have to be aware of the reason why a group is not eligible.
---
 mm/vmscan.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ecf323a1c81..f195a0db5fbb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2215,8 +2215,15 @@ static inline bool should_continue_reclaim(struct zone *zone,
 	}
 }
 
+/**
+ * __shrink_zone - shrinks a given zone
+ *
+ * @zone: zone to shrink
+ * @sc: scan control with additional reclaim parameters
+ * @check_memcg_eligible: check each memcg whether it is eligible for reclaim
+ */
 static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
-		bool follow_low_limit)
+		bool check_memcg_eligible)
 {
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned nr_scanned_groups = 0;
@@ -2237,10 +2244,10 @@ static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
 			struct lruvec *lruvec;
 
 			/*
-			 * Memcg might be under its low limit so we have to
-			 * skip it during the first reclaim round
+			 * Memcg might be protected from the reclaim so we have
+			 * to skip it during the first reclaim round
 			 */
-			if (follow_low_limit &&
+			if (check_memcg_eligible &&
 					!mem_cgroup_reclaim_eligible(memcg, root)) {
 				/*
 				 * It would be more optimal to skip the memcg
@@ -2289,8 +2296,8 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 	if (!__shrink_zone(zone, sc, true)) {
 		/*
 		 * First round of reclaim didn't find anything to reclaim
-		 * because of low limit protection so try again and ignore
-		 * the low limit this time.
+		 * because of the reclaim protection so try again and ignore
+		 * reclaim eligibility of memcgs.
 		 */
 		__shrink_zone(zone, sc, false);
 	}
-- 
2.0.0.rc0

-- 
Michal Hocko
SUSE Labs
