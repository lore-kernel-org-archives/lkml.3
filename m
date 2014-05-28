Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaE1MKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:10:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaE1MK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:10:26 -0400
Date: Wed, 28 May 2014 14:10:23 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140528121023.GA10735@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Johannes,

On Mon 28-04-14 14:26:41, Michal Hocko wrote:
> This patchset introduces such low limit that is functionally similar
> to a minimum guarantee. Memcgs which are under their lowlimit are not
> considered eligible for the reclaim (both global and hardlimit) unless
> all groups under the reclaimed hierarchy are below the low limit when
> all of them are considered eligible.
> 
> The previous version of the patchset posted as a RFC
> (http://marc.info/?l=linux-mm&m=138677140628677&w=2) suggested a
> hard guarantee without any fallback. More discussions led me to
> reconsidering the default behavior and come up a more relaxed one. The
> hard requirement can be added later based on a use case which really
> requires. It would be controlled by memory.reclaim_flags knob which
> would specify whether to OOM or fallback (default) when all groups are
> bellow low limit.

It seems that we are not in a full agreement about the default behavior
yet. Johannes seems to be more for hard guarantee while I would like to
see the weaker approach first and move to the stronger model later.
Johannes, is this absolutely no-go for you? Do you think it is seriously
handicapping the semantic of the new knob?

My main motivation for the weaker model is that it is hard to see all
the corner case right now and once we hit them I would like to see a
graceful fallback rather than fatal action like OOM killer. Besides that
the usaceses I am mostly interested in are OK with fallback when the
alternative would be OOM killer. I also feel that introducing a knob
with a weaker semantic which can be made stronger later is a sensible
way to go.

It would be helpful to have a counter which would tell us how many times
the lowlimit was breached if we go with the weaker semantic.  I guess we
have touched that already but I haven't posted any patch yet.  So here
it goes.
---
>From 109fbc272b120e70a5d9217abf33a181eb1024f4 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 26 May 2014 10:46:10 +0200
Subject: [PATCH] memcg, vmscan: count how many times low limit has been
 breached

The counter is displayed in memory.stat file.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Documentation/cgroups/memory.txt | 6 +++++-
 include/linux/memcontrol.h       | 5 +++++
 mm/memcontrol.c                  | 7 +++++++
 mm/vmscan.c                      | 8 ++++++--
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 7f3a7414bdf2..ad0f31402d84 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -58,6 +58,9 @@ Brief summary of control files.
 				 (See 5.5 for details)
  memory.limit_in_bytes		 # set/show limit of memory usage
  memory.low_limit_in_bytes	 # set/show low limit for memory reclaim
+ memory.low_limit_breached	 # number of times low_limit has been
+				 # ignored and the cgroup reclaimed even
+				 # when it was above the limit
  memory.memsw.limit_in_bytes	 # set/show limit of memory+Swap usage
  memory.failcnt			 # show the number of memory usage hits limits
  memory.memsw.failcnt		 # show the number of memory+Swap hits limits
@@ -251,7 +254,8 @@ doesn't include groups (and their subgroups - see 6. Hierarchy support)
 which are below the low limit if there is other eligible cgroup in the
 reclaimed hierarchy. If all groups which participate reclaim are under
 their low limits then all of them are reclaimed and the low limit is
-ignored.
+ignored. low_limit_breached counter in memory.stat file can be checked
+to see how many times such an event occurred.
 
 Note2: When panic_on_oom is set to "2", the whole system will panic.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 077a777bd9ff..5e2ca2163b12 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -94,6 +94,8 @@ bool task_in_mem_cgroup(struct task_struct *task,
 
 extern bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
+
+extern void mem_cgroup_guarantee_breached(struct mem_cgroup *memcg);
 extern bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
@@ -297,6 +299,9 @@ static inline bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 {
 	return false;
 }
+static inline  void mem_cgroup_guarantee_breached(struct mem_cgroup *memcg)
+{
+}
 static inline bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4fd4784d1548..4af05d5f59bc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -102,6 +102,7 @@ enum mem_cgroup_events_index {
 	MEM_CGROUP_EVENTS_PGPGOUT,	/* # of pages paged out */
 	MEM_CGROUP_EVENTS_PGFAULT,	/* # of page-faults */
 	MEM_CGROUP_EVENTS_PGMAJFAULT,	/* # of major page-faults */
+	MEM_CGROUP_EVENTS_LOW_LIMIT_FALLBACK, /* # of times low limit was breached */
 	MEM_CGROUP_EVENTS_NSTATS,
 };
 
@@ -110,6 +111,7 @@ static const char * const mem_cgroup_events_names[] = {
 	"pgpgout",
 	"pgfault",
 	"pgmajfault",
+	"low_limit_breached",
 };
 
 static const char * const mem_cgroup_lru_names[] = {
@@ -2833,6 +2835,11 @@ bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 	return false;
 }
 
+void mem_cgroup_guarantee_breached(struct mem_cgroup *memcg)
+{
+	this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_LOW_LIMIT_FALLBACK]);
+}
+
 bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
 {
 	struct mem_cgroup *iter;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2686e47f04cc..8041b0667673 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2245,10 +2245,11 @@ static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
 		do {
 			struct lruvec *lruvec;
+			bool within_guarantee;
 
 			/* Memcg might be protected from the reclaim */
-			if (honor_memcg_guarantee &&
-					mem_cgroup_within_guarantee(memcg, root)) {
+			within_guarantee = mem_cgroup_within_guarantee(memcg, root);
+			if (honor_memcg_guarantee && within_guarantee) {
 				/*
 				 * It would be more optimal to skip the memcg
 				 * subtree now but we do not have a memcg iter
@@ -2258,6 +2259,9 @@ static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
 				continue;
 			}
 
+			if (within_guarantee)
+				mem_cgroup_guarantee_breached(memcg);
+
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 			nr_scanned_groups++;
 
-- 
2.0.0.rc4

-- 
Michal Hocko
SUSE Labs
