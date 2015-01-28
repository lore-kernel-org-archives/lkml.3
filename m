Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbbA1G0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:26:21 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36697 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbA1G0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:26:20 -0500
Date: Wed, 28 Jan 2015 15:26:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: John Moser <john.r.moser@gmail.com>, linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: OOM at low page cache?
Message-ID: <20150128062609.GA4706@blaptop>
References: <54C2C89C.8080002@gmail.com>
 <54C77086.7090505@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C77086.7090505@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 27, 2015 at 12:03:34PM +0100, Vlastimil Babka wrote:
> CC linux-mm in case somebody has a good answer but missed this in lkml traffic
> 
> On 01/23/2015 11:18 PM, John Moser wrote:
> > Why is there no tunable to OOM at low page cache?

AFAIR, there were several trial although there wasn't acceptable
at that time. One thing I can remember is min_filelist_kbytes.
FYI, http://lwn.net/Articles/412313/

> > 
> > I have no swap configured.  I have 16GB RAM.  If Chrome or Gimp or some
> > other stupid program goes off the deep end and eats up my RAM, I hit
> > some 15.5GB or 15.75GB usage and stay there for about 40 minutes.  Every
> > time the program tries to do something to eat more RAM, it cranks disk
> > hard; the disk starts thrashing, the mouse pointer stops moving, and
> > nothing goes on.  It's like swapping like crazy, except you're reading
> > library files instead of paged anonymous RAM.
> > 
> > If only I could tell the system to OOM kill at 512MB or 1GB or 95%
> > non-evictable RAM, it would recover on its own.  As-is, I need to wait
> > or trigger the OOM killer by sysrq.
> > 
> > Am I just the only person in the world who's ever had that problem?  Or
> > is it a matter of questions fast popping up when you try to do this
> > *and* enable paging to disk?  (In my experience, that's a matter of too
> > much swap space:  if you have 16GB RAM and your computer dies at 15.25GB
> > usage, your swap space should be no larger than 750MB plus inactive
> > working RAM; obviously, your computer can't handle paging 750MB back and
> > forth.  If you make it 8GB wide and you start swap thrashing at 2GB
> > usage, you have too much swap available).
> > 
> > I guess you could try to detect excessive swap and page cache thrashing,
> > but that's complex; if anyone really wanted to do that, it would be done
> > by now.  A low-barrier OOM is much simpler.

I'm far away from reclaim code for a long time but when I read again,
I found something strange.

With having swap in get_scan_count, we keep a mount of file LRU + free
as above than high wmark to prevent file LRU thrashing but we don't
with no swap. Why?

Anyway, I believe we should fix it and we now have workingset.c so
there might be more ways to be smart than old(although I am concern
about that shadow shrinker blows out lots of information to be useful
to detect in heavy memory pressure like page thrashing)

Below could be band-aid until we find a elegant solution?

>From c51787f7d75340b54bab2b5e3c587f4a483da51a Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Wed, 28 Jan 2015 14:01:57 +0900
Subject: [PATCH] mm: prevent page thrashing

No-Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 671e47edb584..b258df552e3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2143,6 +2143,25 @@ out:
 							denominator);
 				break;
 			case SCAN_FILE:
+				if (file && global_reclaim(sc)) {
+					unsigned long zonefile;
+					unsigned long zonefree;
+
+					zonefree = zone_page_state(zone,
+								NR_FREE_PAGES);
+					zonefile = zone_page_state(zone,
+							NR_ACTIVE_FILE) +
+							zone_page_state(zone,
+							NR_INACTIVE_FILE);
+
+					/* OOM is better than code thrashing */
+					if (zonefile + zonefree <=
+						high_wmark_pages(zone)) {
+						size = 0;
+						scan = 0;
+					}
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
