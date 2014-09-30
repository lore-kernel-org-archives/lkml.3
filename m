Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaI3Lbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:31:36 -0400
Received: from 8bytes.org ([81.169.241.247]:59079 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaI3Lbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:31:35 -0400
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org, jroedel@suse.de
Subject: [PATCH] PM / Hibernate: Iterate over set bits instead of PFNs in swsusp_free()
Date: Tue, 30 Sep 2014 13:31:29 +0200
Message-Id: <1412076689-7001-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The existing implementation of swsusp_free iterates over all
pfns in the system and checks every bit in the two memory
bitmaps.

This doesn't scale very well with large numbers of pfns,
especially when the bitmaps are not populated very densly.
Change the algorithm to iterate over the set bits in the
bitmaps instead to make it scale better in large memory
configurations.

Also add a memory_bm_clear_current() helper function that
clears the bit for the last position returned from the
memory bitmap.

This new version adds a !NULL check for the memory bitmaps
before they are walked. Not doing so causes a kernel crash
when the bitmaps are NULL.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 kernel/power/snapshot.c | 54 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index f1604d8..791a618 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -725,6 +725,14 @@ static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 	clear_bit(bit, addr);
 }
 
+static void memory_bm_clear_current(struct memory_bitmap *bm)
+{
+	int bit;
+
+	bit = max(bm->cur.node_bit - 1, 0);
+	clear_bit(bit, bm->cur.node->data);
+}
+
 static int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
 	void *addr;
@@ -1333,23 +1341,39 @@ static struct memory_bitmap copy_bm;
 
 void swsusp_free(void)
 {
-	struct zone *zone;
-	unsigned long pfn, max_zone_pfn;
+	unsigned long fb_pfn, fr_pfn;
 
-	for_each_populated_zone(zone) {
-		max_zone_pfn = zone_end_pfn(zone);
-		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
-			if (pfn_valid(pfn)) {
-				struct page *page = pfn_to_page(pfn);
-
-				if (swsusp_page_is_forbidden(page) &&
-				    swsusp_page_is_free(page)) {
-					swsusp_unset_page_forbidden(page);
-					swsusp_unset_page_free(page);
-					__free_page(page);
-				}
-			}
+	if (!forbidden_pages_map || !free_pages_map)
+		goto out;
+
+	memory_bm_position_reset(forbidden_pages_map);
+	memory_bm_position_reset(free_pages_map);
+
+loop:
+	fr_pfn = memory_bm_next_pfn(free_pages_map);
+	fb_pfn = memory_bm_next_pfn(forbidden_pages_map);
+
+	/*
+	 * Find the next bit set in both bitmaps. This is guaranteed to
+	 * terminate when fb_pfn == fr_pfn == BM_END_OF_MAP.
+	 */
+	do {
+		if (fb_pfn < fr_pfn)
+			fb_pfn = memory_bm_next_pfn(forbidden_pages_map);
+		if (fr_pfn < fb_pfn)
+			fr_pfn = memory_bm_next_pfn(free_pages_map);
+	} while (fb_pfn != fr_pfn);
+
+	if (fr_pfn != BM_END_OF_MAP && pfn_valid(fr_pfn)) {
+		struct page *page = pfn_to_page(fr_pfn);
+
+		memory_bm_clear_current(forbidden_pages_map);
+		memory_bm_clear_current(free_pages_map);
+		__free_page(page);
+		goto loop;
 	}
+
+out:
 	nr_copy_pages = 0;
 	nr_meta_pages = 0;
 	restore_pblist = NULL;
-- 
1.9.1

