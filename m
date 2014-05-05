Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbaEEOVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:21:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820AbaEEOVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:21:02 -0400
Date: Mon, 5 May 2014 16:21:00 +0200
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
Message-ID: <20140505142100.GC32598@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-2-git-send-email-mhocko@suse.cz>
 <20140430225550.GD26041@cmpxchg.org>
 <20140502093628.GC3446@dhcp22.suse.cz>
 <20140502155805.GO23420@cmpxchg.org>
 <20140502164930.GP3446@dhcp22.suse.cz>
 <20140502220056.GP23420@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502220056.GP23420@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 02-05-14 18:00:56, Johannes Weiner wrote:
> On Fri, May 02, 2014 at 06:49:30PM +0200, Michal Hocko wrote:
> > On Fri 02-05-14 11:58:05, Johannes Weiner wrote:
> > > On Fri, May 02, 2014 at 11:36:28AM +0200, Michal Hocko wrote:
> > > > On Wed 30-04-14 18:55:50, Johannes Weiner wrote:
> > > > > On Mon, Apr 28, 2014 at 02:26:42PM +0200, Michal Hocko wrote:
[...]
> > > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > > index c1cd99a5074b..0f428158254e 100644
> > > > > > --- a/mm/vmscan.c
> > > > > > +++ b/mm/vmscan.c
> > > > [...]
> > > > > > +static void shrink_zone(struct zone *zone, struct scan_control *sc)
> > > > > > +{
> > > > > > +	if (!__shrink_zone(zone, sc, true)) {
> > > > > > +		/*
> > > > > > +		 * First round of reclaim didn't find anything to reclaim
> > > > > > +		 * because of low limit protection so try again and ignore
> > > > > > +		 * the low limit this time.
> > > > > > +		 */
> > > > > > +		__shrink_zone(zone, sc, false);
> > > > > > +	}
> > > 
> > > So I don't think this can work as it is, because we are not actually
> > > changing priority levels yet. 
> > 
> > __shrink_zone returns with 0 only if the whole hierarchy is is under low
> > limit. This means that they are over-committed and it doesn't make much
> > sense to play with priority. Low limit reclaimability is independent on
> > the priority.
> > 
> > > It will give up on the guarantees of bigger groups way before smaller
> > > groups are even seriously looked at.
> > 
> > How would that happen? Those (smaller) groups would get reclaimed and we
> > wouldn't fallback. Or am I missing your point?
> 
> Lol, I hadn't updated my brain to a394cb8ee632 ("memcg,vmscan: do not
> break out targeted reclaim without reclaimed pages") yet...  Yes, you
> are right.

You made me think about this more and you are right ;).
The code as is doesn't cope with many racing reclaimers when some
threads can fallback to ignore the lowlimit although there are groups to
scan in the hierarchy but they were visited by other reclaimers.
The patch bellow should help with that. What do you think?
I am also thinking we want to add a fallback counter in memory.stat?
---
>From e997b8b4ac724aa29bdeff998d2186ee3c0a97d8 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 5 May 2014 15:12:18 +0200
Subject: [PATCH] vmscan: memcg: check whether the low limit should be ignored

Low-limit (aka guarantee) is ignored when there is no group scanned
during the first round of __shink_zone. This approach doesn't work when
multiple reclaimers race and reclaim the same hierarchy (e.g. kswapd
vs. direct reclaim or multiple tasks hitting the hard limit) because
memcg iterator makes sure that multiple reclaimers are interleaved
in the hierarchy. This means that some reclaimers can see 0 scanned
groups although there are groups which are above the low-limit and they
were reclaimed on behalf of other reclaimers. This leads to a premature
low-limit break.

This patch adds mem_cgroup_all_within_guarantee() which will check
whether all the groups in the reclaimed hierarchy are within their low
limit and shrink_zone will allow the fallback reclaim only when that is
true. This alone is still not sufficient however because it would lead
to another problem. If a reclaimer constantly fails to scan anything
because it sees only groups within their guarantees while others do the
reclaim then the reclaim priority would drop down very quickly.
shrink_zone has to be careful to preserve scan at least one group
semantic so __shrink_zone has to be retried until at least one group
is scanned.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h |  5 +++++
 mm/memcontrol.c            | 13 +++++++++++++
 mm/vmscan.c                | 17 ++++++++++++-----
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c00ccc5f70b9..077a777bd9ff 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ bool task_in_mem_cgroup(struct task_struct *task,
 
 extern bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
+extern bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
@@ -296,6 +297,10 @@ static inline bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 {
 	return false;
 }
+static inline bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
+{
+	return false;
+}
 
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 58982d18f6ea..4fd4784d1548 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2833,6 +2833,19 @@ bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 	return false;
 }
 
+bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, root)
+		if (!mem_cgroup_within_guarantee(iter, root)) {
+			mem_cgroup_iter_break(root, iter);
+			return false;
+		}
+
+	return true;
+}
+
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg = NULL;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5f923999bb79..2686e47f04cc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2293,13 +2293,20 @@ static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
 
 static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
-	if (!__shrink_zone(zone, sc, true)) {
+	bool honor_guarantee = true;
+
+	while (!__shrink_zone(zone, sc, honor_guarantee)) {
 		/*
-		 * First round of reclaim didn't find anything to reclaim
-		 * because of the memory guantees for all memcgs in the
-		 * reclaim target so try again and ignore guarantees this time.
+		 * The previous round of reclaim didn't find anything to scan
+		 * because
+		 * a) the whole reclaimed hierarchy is within guarantee so
+		 *    we fallback to ignore the guarantee because other option
+		 *    would be the OOM
+		 * b) multiple reclaimers are racing and so the first round
+		 *    should be retried
 		 */
-		__shrink_zone(zone, sc, false);
+		if (mem_cgroup_all_within_guarantee(sc->target_mem_cgroup))
+			honor_guarantee = false;
 	}
 }
 
-- 
2.0.0.rc0

-- 
Michal Hocko
SUSE Labs
