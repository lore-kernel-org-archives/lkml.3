Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaESKPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:15:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaESKPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:15:01 -0400
Message-ID: <5379D99E.1020302@suse.cz>
Date: Mon, 19 May 2014 12:14:54 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
CC: Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm/compaction: avoid rescanning pageblocks in
 isolate_freepages
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com> <1399464550-26447-1-git-send-email-vbabka@suse.cz> <1399464550-26447-2-git-send-email-vbabka@suse.cz>
In-Reply-To: <1399464550-26447-2-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder why nobody complained about the build warning... sorry.

----8<----
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 19 May 2014 12:02:38 +0200
Subject: mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix a (spurious) build warning:

mm/compaction.c:860:15: warning: ‘next_free_pfn’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Seems like the compiler cannot prove that exiting the for loop without updating
next_free_pfn there will mean that the check for crossing the scanners will
trigger. So let's not confuse people who try to see why this warning occurs.

Instead of initializing next_free_pfn to zero with an explaining comment, just
drop the damned variable altogether and work with cc->free_pfn directly as
Nayoa originally suggested.

Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 8db9820..b0f939b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -760,7 +760,6 @@ static void isolate_freepages(struct zone *zone,
 	unsigned long block_start_pfn;	/* start of current pageblock */
 	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
-	unsigned long next_free_pfn; /* start pfn for scaning at next round */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -822,7 +821,7 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-		next_free_pfn = block_start_pfn;
+		cc->free_pfn = block_start_pfn;
 		isolated = isolate_freepages_block(cc, block_start_pfn,
 					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
@@ -852,9 +851,8 @@ static void isolate_freepages(struct zone *zone,
 	 * so that compact_finished() may detect this
 	 */
 	if (block_start_pfn < low_pfn)
-		next_free_pfn = cc->migrate_pfn;
+		cc->free_pfn = cc->migrate_pfn;
 
-	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
-- 
1.8.4.5


