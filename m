Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaK0Kqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:46:49 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43336 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaK0Kqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:46:48 -0500
From: Hongbo Zhong <bocui107@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] mm: Remove the highmem zones' memmap in the highmem zone
Date: Thu, 27 Nov 2014 18:46:34 +0800
Message-Id: <1417085194-17042-1-git-send-email-bocui107@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhong Hongbo <bocui107@gmail.com>

Since the commit 01cefaef40c4 ("mm: provide more accurate estimation
of pages occupied by memmap") allocate the pages from lowmem for the
highmem zones' memmap. So It is not need to reserver the memmap's for
the highmem.

A 2G DDR3 for the arm platform:
On node 0 totalpages: 524288
free_area_init_node: node 0, pgdat 80ccd380, node_mem_map 80d38000
  DMA zone: 3568 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 456704 pages, LIFO batch:31
  HighMem zone: 528 pages used for memmap
  HighMem zone: 67584 pages, LIFO batch:15

On node 0 totalpages: 524288
free_area_init_node: node 0, pgdat 80cd6f40, node_mem_map 80d42000
  DMA zone: 3568 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 456704 pages, LIFO batch:31
  HighMem zone: 67584 pages, LIFO batch:15


Signed-off-by: Hongbo Zhong <hongbo.zhong@gmail.com>
---
 mm/page_alloc.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 616a2c9..d2f723c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4851,16 +4851,18 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		 * and per-cpu initialisations
 		 */
 		memmap_pages = calc_memmap_size(size, realsize);
-		if (freesize >= memmap_pages) {
-			freesize -= memmap_pages;
-			if (memmap_pages)
-				printk(KERN_DEBUG
-				       "  %s zone: %lu pages used for memmap\n",
-				       zone_names[j], memmap_pages);
-		} else
-			printk(KERN_WARNING
-				"  %s zone: %lu pages exceeds freesize %lu\n",
-				zone_names[j], memmap_pages, freesize);
+		if (!is_highmem_idx(j)) {
+			if (freesize >= memmap_pages) {
+				freesize -= memmap_pages;
+				if (memmap_pages)
+					printk(KERN_DEBUG
+					       "  %s zone: %lu pages used for memmap\n",
+					       zone_names[j], memmap_pages);
+			} else
+				printk(KERN_WARNING
+					"  %s zone: %lu pages exceeds freesize %lu\n",
+					zone_names[j], memmap_pages, freesize);
+		}
 
 		/* Account for reserved pages */
 		if (j == 0 && freesize > dma_reserve) {
-- 
1.7.9.5

