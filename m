Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119AbaKNI5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:57:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbaKNI5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:57:44 -0500
Message-ID: <5465C405.4030603@suse.cz>
Date: Fri, 14 Nov 2014 09:57:41 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] mm, compaction: always update cached scanner positions
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz> <1412696019-21761-5-git-send-email-vbabka@suse.cz> <20141027073522.GB23379@js1304-P5Q-DELUXE> <544E12B5.5070008@suse.cz> <20141028070818.GA27813@js1304-P5Q-DELUXE> <5453B088.6080605@suse.cz> <20141104002850.GA8412@js1304-P5Q-DELUXE>
In-Reply-To: <20141104002850.GA8412@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 01:28 AM, Joonsoo Kim wrote:
> On Fri, Oct 31, 2014 at 04:53:44PM +0100, Vlastimil Babka wrote:
>> On 10/28/2014 08:08 AM, Joonsoo Kim wrote:
>>
>> OK, so you don't find a problem with how this patch changes
>> migration scanner caching, just the free scanner, right?
>> So how about making release_freepages() return the highest freepage
>> pfn it encountered (could perhaps do without comparing individual
>> pfn's, the list should be ordered so it could be just the pfn of
>> first or last page in the list, but need to check that) and updating
>> cached free pfn with that? That should ensure rescanning only when
>> needed.
> 
> Hello,
> 
> Updating cached free pfn in release_freepages() looks good to me.
> 
> In fact, I guess that migration scanner also has similar problems, but,
> it's just my guess. I admit your following arguments in patch description.
> 
>    However, the downside is that potentially many pages are rescanned without
>    successful isolation. At worst, there might be a page where isolation from LRU
>    succeeds but migration fails (potentially always).
> 
> So, I'm okay if you update cached free pfn in release_freepages().

Hi, here's the patch-fix to update cached free pfn based on release_freepages().
No significant difference in my testing.

------8<------
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 12 Nov 2014 16:37:21 +0100
Subject: [PATCH] mm-compaction-always-update-cached-scanner-positions-fix

This patch-fix addresses Joonsoo Kim's concerns about free pages potentially
being skipped when they are isolated and then returned due to migration
failure. It does so by setting the cached scanner pfn to the pageblock where
where the free page with the highest pfn of all returned free pages resides.
A small downside is that release_freepages() no longer returns the number of
freed pages, which has been used in a VM_BUG_ON check. I don't think the check
was important enough to warrant a more complex solution.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>

---

When squashed, the following paragraph should be appended to the fixed patch's
changelog:

To prevent free scanner from leaving free pages behind after they are returned
due to page migration failure, the cached scanner pfn is changed to point to
the pageblock of the returned free page with the highest pfn, before leaving
compact_zone().

 mm/compaction.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index e0befc3..3669f92 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -41,15 +41,17 @@ static inline void count_compact_events(enum vm_event_item item, long delta)
 static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
-	unsigned long count = 0;
+	unsigned long high_pfn = 0;
 
 	list_for_each_entry_safe(page, next, freelist, lru) {
+		unsigned long pfn = page_to_pfn(page);
 		list_del(&page->lru);
 		__free_page(page);
-		count++;
+		if (pfn > high_pfn)
+			high_pfn = pfn;
 	}
 
-	return count;
+	return high_pfn;
 }
 
 static void map_pages(struct list_head *list)
@@ -1223,9 +1225,24 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	}
 
 out:
-	/* Release free pages and check accounting */
-	cc->nr_freepages -= release_freepages(&cc->freepages);
-	VM_BUG_ON(cc->nr_freepages != 0);
+	/*
+	 * Release free pages and update where the free scanner should restart,
+	 * so we don't leave any returned pages behind in the next attempt.
+	 */
+	if (cc->nr_freepages > 0) {
+		unsigned long free_pfn = release_freepages(&cc->freepages);
+		cc->nr_freepages = 0;
+
+		VM_BUG_ON(free_pfn == 0);
+		/* The cached pfn is always the first in a pageblock */
+		free_pfn &= ~(pageblock_nr_pages-1);
+		/*
+		 * Only go back, not forward. The cached pfn might have been
+		 * already reset to zone end in compact_finished()
+		 */
+		if (free_pfn > zone->compact_cached_free_pfn)
+			zone->compact_cached_free_pfn = free_pfn;
+	}
 
 	trace_mm_compaction_end(ret);
 
-- 
2.1.2



