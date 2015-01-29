Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbbA2BYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:24:21 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36305 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbA2BYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:24:18 -0500
Date: Thu, 29 Jan 2015 10:24:07 +0900
From: Minchan Kim <minchan@kernel.org>
To: John Moser <john.r.moser@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: OOM at low page cache?
Message-ID: <20150129012356.GA9672@blaptop>
References: <54C2C89C.8080002@gmail.com>
 <54C77086.7090505@suse.cz>
 <20150128062609.GA4706@blaptop>
 <54C8EF16.5080701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C8EF16.5080701@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 28, 2015 at 09:15:50AM -0500, John Moser wrote:
> On 01/28/2015 01:26 AM, Minchan Kim wrote:
> > Hello,
> >
> > On Tue, Jan 27, 2015 at 12:03:34PM +0100, Vlastimil Babka wrote:
> >> CC linux-mm in case somebody has a good answer but missed this in lkml traffic
> >>
> >> On 01/23/2015 11:18 PM, John Moser wrote:
> >>> Why is there no tunable to OOM at low page cache?
> > AFAIR, there were several trial although there wasn't acceptable
> > at that time. One thing I can remember is min_filelist_kbytes.
> > FYI, http://lwn.net/Articles/412313/
> >
> 
> That looks more straight-forward than http://lwn.net/Articles/422291/
> 
> 
> > I'm far away from reclaim code for a long time but when I read again,
> > I found something strange.
> >
> > With having swap in get_scan_count, we keep a mount of file LRU + free
> > as above than high wmark to prevent file LRU thrashing but we don't
> > with no swap. Why?
> >
> 
> That's ... strange.  That means having a token 1MB swap file changes the
> system's practical memory reclaim behavior dramatically?

Basically, yes but 1M is too small. If all of swap consumed, the behavior
will be same so I think we need more explicit logic to prevent cache
thrashing. Could you test below patch?

Thanks.

>From d7659ff20f065b89633037652042968ba9c9f5c2 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Wed, 28 Jan 2015 14:01:57 +0900
Subject: [PATCH] mm: prevent page thrashing for non-swap

Josh reported

"I have no swap configured.  I have 16GB RAM.  If Chrome or Gimp or some
other stupid program goes off the deep end and eats up my RAM, I hit
some 15.5GB or 15.75GB usage and stay there for about 40 minutes.  Every
time the program tries to do something to eat more RAM, it cranks disk
hard; the disk starts thrashing, the mouse pointer stops moving, and
nothing goes on.  It's like swapping like crazy, except you're reading
library files instead of paged anonymous RAM."

With swap enable, get_scan_count has a logic to prevent cache thrasing
but it doesn't with no swap case. This patch adds the check for
non-swap case so that we shouldn't drop all of page cache in non-swap
case, either to prevent cache thrashing.

Reported-by: John Moser <john.r.moser@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 671e47edb584..2a2236fceaee 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1957,6 +1957,22 @@ enum scan_balance {
 	SCAN_FILE,
 };
 
+bool enough_file_pages(struct zone *zone)
+{
+	bool ret = true;
+	unsigned long zonefile;
+	unsigned long zonefree;
+
+	zonefree = zone_page_state(zone, NR_FREE_PAGES);
+	zonefile = zone_page_state(zone, NR_ACTIVE_FILE) +
+		   zone_page_state(zone, NR_INACTIVE_FILE);
+
+	if (unlikely(zonefile + zonefree <= high_wmark_pages(zone)))
+		ret = false;
+
+	return ret;
+}
+
 /*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
@@ -2039,18 +2055,9 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
 	 * thrashing file LRU becomes infinitely more attractive than
 	 * anon pages.  Try to detect this based on file LRU size.
 	 */
-	if (global_reclaim(sc)) {
-		unsigned long zonefile;
-		unsigned long zonefree;
-
-		zonefree = zone_page_state(zone, NR_FREE_PAGES);
-		zonefile = zone_page_state(zone, NR_ACTIVE_FILE) +
-			   zone_page_state(zone, NR_INACTIVE_FILE);
-
-		if (unlikely(zonefile + zonefree <= high_wmark_pages(zone))) {
-			scan_balance = SCAN_ANON;
-			goto out;
-		}
+	if (global_reclaim(sc) && !enough_file_pages(zone)) {
+		scan_balance = SCAN_ANON;
+		goto out;
 	}
 
 	/*
@@ -2143,6 +2150,17 @@ out:
 							denominator);
 				break;
 			case SCAN_FILE:
+				/*
+				 * If there isn't enough page cache to prevent
+				 * cache thrashing, OOM is better than long time
+				 * unresponsible system.
+				 */
+				if (global_reclaim(sc) && file &&
+						!enough_file_pages(zone)) {
+					size = 0;
+					scan = 0;
+					break;
+				}
 			case SCAN_ANON:
 				/* Scan one type exclusively */
 				if ((scan_balance == SCAN_FILE) != file) {
-- 
1.9.1

-- 
Kind regards,
Minchan Kim
