Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbaJWMvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:51:41 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:63726 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbaJWMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:51:34 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [RFC 2/2] staging: ion: debugfs to shrink pool
Date: Thu, 23 Oct 2014 21:52:20 +0900
Message-Id: <1414068740-9553-3-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>
References: <1414068740-9553-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates debugfs files, /sys/kernel/debug/ion/heaps/system_shrink,
to shrink pool or get pool size.
Reading the file returns pool size and writing occurs to shrink pool.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion.c |   31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 290d4d2..ecc1121 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1463,43 +1463,29 @@ static const struct file_operations debug_heap_fops = {
 	.release = single_release,
 };
 
-#ifdef DEBUG_HEAP_SHRINKER
 static int debug_shrink_set(void *data, u64 val)
 {
 	struct ion_heap *heap = data;
-	struct shrink_control sc;
 	int objs;
 
-	sc.gfp_mask = -1;
-	sc.nr_to_scan = 0;
-
-	if (!val)
-		return 0;
-
-	objs = heap->shrinker.shrink(&heap->shrinker, &sc);
-	sc.nr_to_scan = objs;
+	if (val)
+		objs = val;
+	else
+		objs = heap->ops->shrink(heap, __GFP_HIGHMEM, 0);
 
-	heap->shrinker.shrink(&heap->shrinker, &sc);
+	(void)heap->ops->shrink(heap, __GFP_HIGHMEM, objs);
 	return 0;
 }
 
 static int debug_shrink_get(void *data, u64 *val)
 {
 	struct ion_heap *heap = data;
-	struct shrink_control sc;
-	int objs;
-
-	sc.gfp_mask = -1;
-	sc.nr_to_scan = 0;
-
-	objs = heap->shrinker.shrink(&heap->shrinker, &sc);
-	*val = objs;
+	*val = heap->ops->shrink(heap, __GFP_HIGHMEM, 0);
 	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
 			debug_shrink_set, "%llu\n");
-#endif
 
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 {
@@ -1534,8 +1520,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 			path, heap->name);
 	}
 
-#ifdef DEBUG_HEAP_SHRINKER
-	if (heap->shrinker.shrink) {
+	if (heap->ops->shrink) {
 		char debug_name[64];
 
 		snprintf(debug_name, 64, "%s_shrink", heap->name);
@@ -1550,7 +1535,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 				path, debug_name);
 		}
 	}
-#endif
+
 	up_write(&dev->lock);
 }
 
-- 
1.7.9.5

