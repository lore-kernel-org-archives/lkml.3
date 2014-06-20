Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaFTC70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:59:26 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55341 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaFTC7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:59:25 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 20 Jun 2014 12:00:02 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Yucong <slaoub@gmail.com>, mgorman@suse.de, hannes@cmpxchg.org,
        mhocko@suse.cz, riel@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Write down design and intentions in English for
 proportial scan
Message-ID: <20140620030002.GA14884@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:13:22PM -0700, Andrew Morton wrote:
> On Thu, 19 Jun 2014 10:02:39 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > > > @@ -2057,8 +2057,7 @@ out:
> > > >  static void shrink_lruvec(struct lruvec *lruvec, struct scan_control
> > > > *sc)
> > > >  {
> > > >         unsigned long nr[NR_LRU_LISTS];
> > > > -       unsigned long targets[NR_LRU_LISTS];
> > > > -       unsigned long nr_to_scan;
> > > > +       unsigned long file_target, anon_target;
> > > > 
> > > > >From the above snippet, we can know that the "percent" locals come from
> > > > targets[NR_LRU_LISTS]. So this fix does not increase the stack.
> > > 
> > > OK.  But I expect the stack use could be decreased by using more
> > > complex expressions.
> > 
> > I didn't look at this patch yet but want to say.
> > 
> > The expression is not easy to follow since several people already
> > confused/discuss/fixed a bit so I'd like to put more concern to clarity
> > rather than stack footprint.
> 
> That code is absolutely awful :( It's terribly difficult to work out
> what the design is - what the code is actually setting out to achieve. 
> One is reduced to trying to reverse-engineer the intent from the
> implementation and that becomes near impossible when the
> implementation has bugs!
> 
> Look at this miserable comment:
> 
> 		/*
> 		 * For kswapd and memcg, reclaim at least the number of pages
> 		 * requested. Ensure that the anon and file LRUs are scanned
> 		 * proportionally what was requested by get_scan_count(). We
> 		 * stop reclaiming one LRU and reduce the amount scanning
> 		 * proportional to the original scan target.
> 		 */
> 
> 
> > For kswapd and memcg, reclaim at least the number of pages
> > requested.
> 
> *why*?
> 
> > Ensure that the anon and file LRUs are scanned
> > proportionally what was requested by get_scan_count().
> 
> Ungramattical.  Lacks specificity.  Fails to explain *why*.
> 
> > We stop reclaiming one LRU and reduce the amount scanning
> > proportional to the original scan target.
> 
> Ungramattical.  Lacks specificity.  Fails to explain *why*.
> 
> 
> The only way we're going to fix all this up is to stop looking at the
> code altogether.  Write down the design and the intentions in English. 
> Review that.  Then implement that design in C.
> 
> So review and understanding of this code then is a two-stage thing. 
> First, we review and understand the *design*, as written in English. 
> Secondly, we check that the code faithfully implements that design. 
> This second step becomes quite trivial.
> 
> 
> That may all sound excessively long-winded and formal, but
> shrink_lruvec() of all places needs such treatment.  I am completely
> fed up with peering at the code trying to work out what on earth people
> were thinking when they typed it in :(
> 
> 
> So my suggestion is: let's stop fiddling with the code.  Someone please
> prepare a patch which fully documents the design and let's get down and
> review that.  Once that patch is complete, let's then start looking at
> the implementation.
> 

By suggestion from Andrew, first of all, I try to add only comment
but I believe we could make it more clear by some change like this.
https://lkml.org/lkml/2014/6/16/750

Anyway, push this patch firstly.

================= &< =================

>From b1fd007097064db34a211ffeacfe4da9fb22d49e Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 20 Jun 2014 11:37:52 +0900
Subject: [PATCH] mm: Write down design and intentions in English for
 proportial scan

Quote from Andrew
"
That code is absolutely awful :( It's terribly difficult to work out
what the design is - what the code is actually setting out to achieve.
One is reduced to trying to reverse-engineer the intent from the
implementation and that becomes near impossible when the
implementation has bugs!

<snip>

The only way we're going to fix all this up is to stop looking at the
code altogether.  Write down the design and the intentions in English.
Review that.  Then implement that design in C
"

One thing I know it might not be English Andrew expected but other
thing I know is there are lots of native people in here so one of them
will spend his time to make this horrible English smooth.

I alreday spent my time to try to fix this situation so it's your
turn. It's good time balance between non-native and native people
so open source community is fair for all of us.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 521f7eab1798..3a9862895a64 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2071,6 +2071,22 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 
 	get_scan_count(lruvec, sc, nr);
 
+	/*
+	 * Basically, VM scans file/anon LRU list proportionally depending
+	 * on the value of vm.swappiness but doesn't want to reclaim
+	 * excessive pages. So, it might be better to stop scan as soon as
+	 * we meet nr_to_reclaim but it breaks aging balance between LRU lists
+	 * To keep the balance, what we do is as follows.
+	 *
+	 * If we reclaim pages requested, we stop scanning first and
+	 * investigate which LRU should be scanned more depending on
+	 * remained lru size(ie, nr[xxx]). We will scan bigger one more
+	 * so, final goal is
+	 *
+	 * scanned[xxx] = targets[xxx] - nr[xxx]
+	 * targets[anon] : targets[file] = scanned[anon] : scanned[file]
+	 */
+
 	/* Record the original scan target for proportional adjustments later */
 	memcpy(targets, nr, sizeof(nr));
 
@@ -2091,8 +2107,14 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-		unsigned long nr_anon, nr_file, percentage;
+		unsigned long nr_anon, nr_file;
 		unsigned long nr_scanned;
+		/*
+		 * How many pages we should scan to meet target
+		 * calculated by get_scan_count. It means that
+		 * (100 - percentage) = already scanned ratio
+		 */
+		unsigned percentage;
 
 		for_each_evictable_lru(lru) {
 			if (nr[lru]) {
@@ -2108,11 +2130,10 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			continue;
 
 		/*
-		 * For kswapd and memcg, reclaim at least the number of pages
-		 * requested. Ensure that the anon and file LRUs are scanned
-		 * proportionally what was requested by get_scan_count(). We
-		 * stop reclaiming one LRU and reduce the amount scanning
-		 * proportional to the original scan target.
+		 * Here, we reclaimed at least the number of pages requested.
+		 * Then, what we should do is the ensure that the anon and
+		 * file LRUs are scanned proportionally what was requested
+		 * by get_scan_count().
 		 */
 		nr_file = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
 		nr_anon = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
@@ -2126,6 +2147,10 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (!nr_file || !nr_anon)
 			break;
 
+		/*
+		 * Scan the bigger of the LRU more while stop scanning
+		 * the smaller of the LRU to keep aging balance between LRUs
+		 */
 		if (nr_file > nr_anon) {
 			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
 						targets[LRU_ACTIVE_ANON] + 1;
-- 
2.0.0

-- 
Kind regards,
Minchan Kim
