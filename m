Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3LND2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:28:08 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57219 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3LND1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:20 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 115/115] ion: Update system heap shrinker to use the new count/scan interface
Date: Fri, 13 Dec 2013 19:26:35 -0800
Message-Id: <1386991595-6251-23-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the ION system heap shrinker to use the new count/scan
interfaces that landed in 3.12

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 40 +++++++++++++++++++--------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index b5acd6c..144b2272 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -232,15 +232,37 @@ static struct ion_heap_ops system_heap_ops = {
 	.map_user = ion_heap_map_user,
 };
 
-static int ion_system_heap_shrink(struct shrinker *shrinker,
-				  struct shrink_control *sc) {
-
+static unsigned long ion_system_heap_shrink_count(struct shrinker *shrinker,
+				  struct shrink_control *sc)
+{
 	struct ion_heap *heap = container_of(shrinker, struct ion_heap,
 					     shrinker);
 	struct ion_system_heap *sys_heap = container_of(heap,
 							struct ion_system_heap,
 							heap);
 	int nr_total = 0;
+	int i;
+
+	/* total number of items is whatever the page pools are holding
+	   plus whatever's in the freelist */
+	for (i = 0; i < num_orders; i++) {
+		struct ion_page_pool *pool = sys_heap->pools[i];
+		nr_total += ion_page_pool_shrink(pool, sc->gfp_mask, 0);
+	}
+	nr_total += ion_heap_freelist_size(heap) / PAGE_SIZE;
+	return nr_total;
+
+}
+
+static unsigned long ion_system_heap_shrink_scan(struct shrinker *shrinker,
+				  struct shrink_control *sc)
+{
+
+	struct ion_heap *heap = container_of(shrinker, struct ion_heap,
+					     shrinker);
+	struct ion_system_heap *sys_heap = container_of(heap,
+							struct ion_system_heap,
+							heap);
 	int nr_freed = 0;
 	int i;
 
@@ -265,14 +287,7 @@ static int ion_system_heap_shrink(struct shrinker *shrinker,
 	}
 
 end:
-	/* total number of items is whatever the page pools are holding
-	   plus whatever's in the freelist */
-	for (i = 0; i < num_orders; i++) {
-		struct ion_page_pool *pool = sys_heap->pools[i];
-		nr_total += ion_page_pool_shrink(pool, sc->gfp_mask, 0);
-	}
-	nr_total += ion_heap_freelist_size(heap) / PAGE_SIZE;
-	return nr_total;
+	return nr_freed;
 
 }
 
@@ -323,7 +338,8 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 		heap->pools[i] = pool;
 	}
 
-	heap->heap.shrinker.shrink = ion_system_heap_shrink;
+	heap->heap.shrinker.scan_objects = ion_system_heap_shrink_scan;
+	heap->heap.shrinker.count_objects = ion_system_heap_shrink_count;
 	heap->heap.shrinker.seeks = DEFAULT_SEEKS;
 	heap->heap.shrinker.batch = 0;
 	register_shrinker(&heap->heap.shrinker);
-- 
1.8.3.2

