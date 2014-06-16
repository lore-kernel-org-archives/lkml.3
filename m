Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaFPXpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:45:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38529 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaFPXpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:45:43 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 17 Jun 2014 08:46:08 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
Message-ID: <20140616234608.GB18790@bbox>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
 <1402923474.3958.34.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402923474.3958.34.camel@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 08:57:54PM +0800, Chen Yucong wrote:
> On Mon, 2014-06-09 at 21:27 +0800, Chen Yucong wrote:
> > Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> > original scan targets introduces extra 40 bytes on the stack. This patch
> > is able to avoid this situation and the call to memcpy(). At the same time,
> > it does not change the relative design idea.
> > 
> > ratio = original_nr_file / original_nr_anon;
> > 
> > If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
> >  x = nr_file - ratio * nr_anon;
> > 
> > if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
> >  x = nr_anon - nr_file / ratio;
> > 
> Hi Andrew Morton,
> 
> I think the patch
>  
> [PATCH]
> mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec-fix.patch
> 
> which I committed should be discarded. Because It have some critical
> defects.
>     1) If we want to solve the divide-by-zero and unfair problems, it
> needs to two variables for recording the ratios.
>  
>     2) For "x = nr_file - ratio * nr_anon", the "x" is likely to be a
> negative number. we can assume:
> 
>       nr[LRU_ACTIVE_FILE] = 30
>       nr[LRU_INACTIVE_FILE] = 30
>       nr[LRU_ACTIVE_ANON] = 0
>       nr[LRU_INACTIVE_ANON] = 40
> 
>       ratio = 60/40 = 3/2
> 
> When the value of (nr_reclaimed < nr_to_reclaim) become false, there are
> the following results:
>       nr[LRU_ACTIVE_FILE] = 15
>       nr[LRU_INACTIVE_FILE] = 15
>       nr[LRU_ACTIVE_ANON] = 0
>       nr[LRU_INACTIVE_ANON] = 25
>  
>       nr_file = 30
>       nr_anon = 25
> 
>       x = 30 - 25 * (3/2) = 30 - 37.5 = -7.5.
> 
> The result is too terrible. 
>    
>    3) This method is less accurate than the original, especially for the
> qualitative difference between FILE and ANON that is very small.

Yes, 3 changed old behavior. I'm ashamed but wanted to clean it up.
Is it worth to clean it up?

>From aedf8288e28a07bdd6c459a403f21cc2615ecc4e Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 17 Jun 2014 08:36:56 +0900
Subject: [PATCH] mm: proportional scanning cleanup

It aims for clean up, not changing behaivor so if anyone doesn't
looks it's more readable or not enough for readability, it should
really drop.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 69 ++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0f16ffe8eb67..acc29315bad0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2054,19 +2054,18 @@ out:
  */
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	unsigned long nr[NR_LRU_LISTS];
 	unsigned long targets[NR_LRU_LISTS];
-	unsigned long nr_to_scan;
+	unsigned long remains[NR_LRU_LISTS];
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
 	bool scan_adjusted;
 
-	get_scan_count(lruvec, sc, nr);
+	get_scan_count(lruvec, sc, targets);
 
-	/* Record the original scan target for proportional adjustments later */
-	memcpy(targets, nr, sizeof(nr));
+	/* Keep the original scan target for proportional adjustments later */
+	memcpy(remains, targets, sizeof(targets));
 
 	/*
 	 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
@@ -2083,19 +2082,21 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			 sc->priority == DEF_PRIORITY);
 
 	blk_start_plug(&plug);
-	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
-					nr[LRU_INACTIVE_FILE]) {
-		unsigned long nr_anon, nr_file, percentage;
-		unsigned long nr_scanned;
+	while (remains[LRU_INACTIVE_ANON] || remains[LRU_ACTIVE_FILE] ||
+					remains[LRU_INACTIVE_FILE]) {
+		unsigned long target, remain_anon, remain_file;
+		unsigned long percentage;
+		unsigned long nr_scanned, nr_to_scan;
 
 		for_each_evictable_lru(lru) {
-			if (nr[lru]) {
-				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
-				nr[lru] -= nr_to_scan;
+			if (!remains[lru])
+				continue;
 
-				nr_reclaimed += shrink_list(lru, nr_to_scan,
-							    lruvec, sc);
-			}
+			nr_to_scan = min(remains[lru], SWAP_CLUSTER_MAX);
+			remains[lru] -= nr_to_scan;
+
+			nr_reclaimed += shrink_list(lru, nr_to_scan,
+						    lruvec, sc);
 		}
 
 		if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
@@ -2108,8 +2109,10 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		 * stop reclaiming one LRU and reduce the amount scanning
 		 * proportional to the original scan target.
 		 */
-		nr_file = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
-		nr_anon = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
+		remain_file = remains[LRU_INACTIVE_FILE] +
+				remains[LRU_ACTIVE_FILE];
+		remain_anon = remains[LRU_INACTIVE_ANON] +
+				remains[LRU_ACTIVE_ANON];
 
 		/*
 		 * It's just vindictive to attack the larger once the smaller
@@ -2117,38 +2120,38 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		 * smaller below, this makes sure that we only make one nudge
 		 * towards proportionality once we've got nr_to_reclaim.
 		 */
-		if (!nr_file || !nr_anon)
+		if (!remain_file || !remain_anon)
 			break;
 
-		if (nr_file > nr_anon) {
-			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
-						targets[LRU_ACTIVE_ANON] + 1;
+		if (remain_file > remain_anon) {
+			target = targets[LRU_ACTIVE_ANON] +
+						targets[LRU_INACTIVE_ANON] + 1;
+			percentage = 100 * (target - remain_anon) / target;
 			lru = LRU_BASE;
-			percentage = nr_anon * 100 / scan_target;
 		} else {
-			unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
-						targets[LRU_ACTIVE_FILE] + 1;
+			target = targets[LRU_ACTIVE_FILE] +
+						targets[LRU_INACTIVE_FILE] + 1;
+			percentage = 100 * (target - remain_file) / target;
 			lru = LRU_FILE;
-			percentage = nr_file * 100 / scan_target;
 		}
 
 		/* Stop scanning the smaller of the LRU */
-		nr[lru] = 0;
-		nr[lru + LRU_ACTIVE] = 0;
+		remains[lru] = 0;
+		remains[lru + LRU_ACTIVE] = 0;
 
 		/*
 		 * Recalculate the other LRU scan count based on its original
 		 * scan target and the percentage scanning already complete
 		 */
 		lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
+		nr_scanned = targets[lru] - remains[lru];
+		remains[lru] = targets[lru] * percentage / 100;
+		remains[lru] -= min(remains[lru], nr_scanned);
 
 		lru += LRU_ACTIVE;
-		nr_scanned = targets[lru] - nr[lru];
-		nr[lru] = targets[lru] * (100 - percentage) / 100;
-		nr[lru] -= min(nr[lru], nr_scanned);
+		nr_scanned = targets[lru] - remains[lru];
+		remains[lru] = targets[lru] * percentage / 100;
+		remains[lru] -= min(remains[lru], nr_scanned);
 
 		scan_adjusted = true;
 	}
-- 
2.0.0


-- 
Kind regards,
Minchan Kim
