Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbaJGX3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:29:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaJGXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 26/37] mm/compaction: check pageblock suitability once per pageblock
Date: Tue,  7 Oct 2014 16:19:43 -0700
Message-Id: <20141007231827.863076734@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

commit c122b2087ab94192f2b937e47b563a9c4e688ece upstream.

isolation_suitable() and migrate_async_suitable() is used to be sure
that this pageblock range is fine to be migragted.  It isn't needed to
call it on every page.  Current code do well if not suitable, but, don't
do well when suitable.

1) It re-checks isolation_suitable() on each page of a pageblock that was
   already estabilished as suitable.
2) It re-checks migrate_async_suitable() on each page of a pageblock that
   was not entered through the next_pageblock: label, because
   last_pageblock_nr is not otherwise updated.

This patch fixes situation by 1) calling isolation_suitable() only once
per pageblock and 2) always updating last_pageblock_nr to the pageblock
that was just checked.

Additionally, move PageBuddy() check after pageblock unit check, since
pageblock check is the first thing we should do and makes things more
simple.

[vbabka@suse.cz: rephrase commit description]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/compaction.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -526,8 +526,25 @@ isolate_migratepages_range(struct zone *
 
 		/* If isolation recently failed, do not retry */
 		pageblock_nr = low_pfn >> pageblock_order;
-		if (!isolation_suitable(cc, page))
-			goto next_pageblock;
+		if (last_pageblock_nr != pageblock_nr) {
+			int mt;
+
+			last_pageblock_nr = pageblock_nr;
+			if (!isolation_suitable(cc, page))
+				goto next_pageblock;
+
+			/*
+			 * For async migration, also only scan in MOVABLE
+			 * blocks. Async migration is optimistic to see if
+			 * the minimum amount of work satisfies the allocation
+			 */
+			mt = get_pageblock_migratetype(page);
+			if (!cc->sync && !migrate_async_suitable(mt)) {
+				cc->finished_update_migrate = true;
+				skipped_async_unsuitable = true;
+				goto next_pageblock;
+			}
+		}
 
 		/*
 		 * Skip if free. page_order cannot be used without zone->lock
@@ -537,18 +554,6 @@ isolate_migratepages_range(struct zone *
 			continue;
 
 		/*
-		 * For async migration, also only scan in MOVABLE blocks. Async
-		 * migration is optimistic to see if the minimum amount of work
-		 * satisfies the allocation
-		 */
-		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
-		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
-			cc->finished_update_migrate = true;
-			skipped_async_unsuitable = true;
-			goto next_pageblock;
-		}
-
-		/*
 		 * Check may be lockless but that's ok as we recheck later.
 		 * It's possible to migrate LRU pages and balloon pages
 		 * Skip any other type of page
@@ -639,7 +644,6 @@ check_compact_cluster:
 
 next_pageblock:
 		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
-		last_pageblock_nr = pageblock_nr;
 	}
 
 	acct_isolated(zone, locked, cc);


