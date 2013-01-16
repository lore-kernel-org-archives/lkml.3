Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab3APQGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3APQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sonny Rao <sonnyrao@chromium.org>, Puneet Kumar <puneetster@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 138/222] mm: fix calculation of dirtyable memory
Date: Wed, 16 Jan 2013 13:55:38 -0200
Message-Id: <1358351822-7675-139-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonny Rao <sonnyrao@chromium.org>

commit c8b74c2f6604923de91f8aa6539f8bb934736754 upstream.

The system uses global_dirtyable_memory() to calculate number of
dirtyable pages/pages that can be allocated to the page cache.  A bug
causes an underflow thus making the page count look like a big unsigned
number.  This in turn confuses the dirty writeback throttling to
aggressively write back pages as they become dirty (usually 1 page at a
time).  This generally only affects systems with highmem because the
underflowed count gets subtracted from the global count of dirtyable
memory.

The problem was introduced with v3.2-4896-gab8fabd

Fix is to ensure we don't get an underflowed total of either highmem or
global dirtyable memory.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Puneet Kumar <puneetster@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Damien Wyart <damien.wyart@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 mm/page-writeback.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 93d8d2f..e252db8 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -187,6 +187,18 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
 		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
+	 * Unreclaimable memory (kernel memory or anonymous memory
+	 * without swap) can bring down the dirtyable pages below
+	 * the zone's dirty balance reserve and the above calculation
+	 * will underflow.  However we still want to add in nodes
+	 * which are below threshold (negative values) to get a more
+	 * accurate calculation but make sure that the total never
+	 * underflows.
+	 */
+	if ((long)x < 0)
+		x = 0;
+
+	/*
 	 * Make sure that the number of highmem pages is never larger
 	 * than the number of the total dirtyable memory. This can only
 	 * occur in very strange VM situations but we want to make sure
@@ -208,8 +220,8 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
-	    dirty_balance_reserve;
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x -= min(x, dirty_balance_reserve);
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
@@ -276,9 +288,12 @@ static unsigned long zone_dirtyable_memory(struct zone *zone)
 	 * highmem zone can hold its share of dirty pages, so we don't
 	 * care about vm_highmem_is_dirtyable here.
 	 */
-	return zone_page_state(zone, NR_FREE_PAGES) +
-	       zone_reclaimable_pages(zone) -
-	       zone->dirty_balance_reserve;
+	unsigned long nr_pages = zone_page_state(zone, NR_FREE_PAGES) +
+		zone_reclaimable_pages(zone);
+
+	/* don't allow this to underflow */
+	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
+	return nr_pages;
 }
 
 /**
-- 
1.7.9.5

