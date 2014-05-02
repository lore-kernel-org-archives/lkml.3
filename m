Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaEBJny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:43:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaEBJnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:43:53 -0400
Date: Fri, 2 May 2014 11:43:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] memcg, doc: clarify global vs. limit reclaims
Message-ID: <20140502094351.GD3446@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-4-git-send-email-mhocko@suse.cz>
 <20140430230350.GF26041@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430230350.GF26041@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 19:03:50, Johannes Weiner wrote:
> On Mon, Apr 28, 2014 at 02:26:44PM +0200, Michal Hocko wrote:
> > Be explicit about global and hard limit reclaims in our documentation.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  Documentation/cgroups/memory.txt | 31 +++++++++++++++++--------------
> >  1 file changed, 17 insertions(+), 14 deletions(-)
> > 
> > diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> > index 4937e6fff9b4..add1be001416 100644
> > --- a/Documentation/cgroups/memory.txt
> > +++ b/Documentation/cgroups/memory.txt
> > @@ -236,23 +236,26 @@ it by cgroup.
> >  2.5 Reclaim
> >  
> >  Each cgroup maintains a per cgroup LRU which has the same structure as
> > -global VM. When a cgroup goes over its limit, we first try
> > -to reclaim memory from the cgroup so as to make space for the new
> > -pages that the cgroup has touched. If the reclaim is unsuccessful,
> > -an OOM routine is invoked to select and kill the bulkiest task in the
> > -cgroup. (See 10. OOM Control below.)
> > -
> > -The reclaim algorithm has not been modified for cgroups, except that
> > -pages that are selected for reclaiming come from the per-cgroup LRU
> > -list.
> > -
> > -NOTE: Reclaim does not work for the root cgroup, since we cannot set any
> > -limits on the root cgroup.
> > +global VM. Cgroups can get reclaimed basically under two conditions
> > + - under global memory pressure when all cgroups are reclaimed
> > +   proportionally wrt. their LRU size in a round robin fashion
> > + - when a cgroup or its hierarchical parent (see 6. Hierarchical support)
> > +   hits hard limit. If the reclaim is unsuccessful, an OOM routine is invoked
> > +   to select and kill the bulkiest task in the cgroup. (See 10. OOM Control
> > +   below.)
> 
> In the whole hierarchy, not just that cgroup.

Right. Fixed
 
> > +Global and hard-limit reclaims share the same code the only difference
> > +is the objective of the reclaim. The global reclaim aims at balancing
> > +zones' watermarks while the limit reclaim frees some memory to allow new
> > +charges.
> 
> This is a kswapd vs. direct reclaim issue, not global vs. memcg.
> Memcg reclaim just happens to be direct reclaim.  Either way, I'd
> rather not have such implementation details in the user documentation.

OK, removed
 
> > +NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
> > +any limits on the root cgroup.
> 
> Not sure it's necessary to include this...

removed as well.

Incremental patch on top:
---
>From 30b9505169e574cdb553226e1a361cc527ed492b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 2 May 2014 11:42:35 +0200
Subject: [PATCH] mmotm: memcg-doc-clarify-global-vs-limit-reclaims-fix.patch

update doc as per Johannes

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index add1be001416..2cde96787ceb 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -241,17 +241,9 @@ global VM. Cgroups can get reclaimed basically under two conditions
    proportionally wrt. their LRU size in a round robin fashion
  - when a cgroup or its hierarchical parent (see 6. Hierarchical support)
    hits hard limit. If the reclaim is unsuccessful, an OOM routine is invoked
-   to select and kill the bulkiest task in the cgroup. (See 10. OOM Control
+   to select and kill the bulkiest task in the hiearchy. (See 10. OOM Control
    below.)
 
-Global and hard-limit reclaims share the same code the only difference
-is the objective of the reclaim. The global reclaim aims at balancing
-zones' watermarks while the limit reclaim frees some memory to allow new
-charges.
-
-NOTE: Hard limit reclaim does not work for the root cgroup, since we cannot set
-any limits on the root cgroup.
-
 Note2: When panic_on_oom is set to "2", the whole system will panic.
 
 When oom event notifier is registered, event will be delivered to the root
-- 
2.0.0.rc0

-- 
Michal Hocko
SUSE Labs
