Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbaKLBsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:48:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965471AbaKLBsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:48:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Leon Romanovsky <leon@leon.nu>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 203/203] mm: page_alloc: fix zone allocation fairness on UP
Date: Wed, 12 Nov 2014 10:17:53 +0900
Message-Id: <20141112011552.007597313@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit abe5f972912d086c080be4bde67750630b6fb38b upstream.

The zone allocation batches can easily underflow due to higher-order
allocations or spills to remote nodes.  On SMP that's fine, because
underflows are expected from concurrency and dealt with by returning 0.
But on UP, zone_page_state will just return a wrapped unsigned long,
which will get past the <= 0 check and then consider the zone eligible
until its watermarks are hit.

Commit 3a025760fc15 ("mm: page_alloc: spill to remote nodes before
waking kswapd") already made the counter-resetting use
atomic_long_read() to accomodate underflows from remote spills, but it
didn't go all the way with it.

Make it clear that these batches are expected to go negative regardless
of concurrency, and use atomic_long_read() everywhere.

Fixes: 81c0a2bb515f ("mm: page_alloc: fair zone allocator policy")
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Leon Romanovsky <leon@leon.nu>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1957,7 +1957,7 @@ zonelist_scan:
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
 				continue;
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
+			if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0)
 				continue;
 		}
 		/*
@@ -5670,9 +5670,8 @@ static void __setup_per_zone_wmarks(void
 		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 
 		__mod_zone_page_state(zone, NR_ALLOC_BATCH,
-				      high_wmark_pages(zone) -
-				      low_wmark_pages(zone) -
-				      zone_page_state(zone, NR_ALLOC_BATCH));
+			high_wmark_pages(zone) - low_wmark_pages(zone) -
+			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
 
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);


