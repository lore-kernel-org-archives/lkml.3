Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3ENLuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:50:01 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:34095 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab3ENLt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:49:57 -0400
Message-ID: <519224DF.3070807@gmail.com>
Date: Tue, 14 May 2013 19:49:51 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mm/kmemleak.c: Merge the consecutive scan-areas.
Content-Type: multipart/mixed;
 boundary="------------040500070602080603020209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040500070602080603020209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If the scan-areas are adjacent,it can merge in order to reduce memomy.
And using pr_warn instead of pr_warning.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 mm/kmemleak.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index f0ece93..9590a57 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -746,24 +746,36 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
         return;
     }
 
-    area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
-    if (!area) {
-        pr_warning("Cannot allocate a scan area\n");
-        goto out;
-    }
-
     spin_lock_irqsave(&object->lock, flags);
     if (ptr + size > object->pointer + object->size) {
         kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
         dump_object_info(object);
-        kmem_cache_free(scan_area_cache, area);
         goto out_unlock;
     }
+    hlist_for_each_entry(area, &object->area_list, node) {
+        if (ptr + size == area->start) {
+            area->start = ptr;
+            area->size += size;
+            goto out_unlock;
+        } else if (ptr == area->start + area->size) {
+            area->size += size;
+            goto out_unlock;
+        }
+
+    }
+    spin_unlock_irqrestore(&object->lock, flags);
+
+    area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
+    if (!area) {
+        pr_warn("Cannot allocate a scan area\n");
+        goto out;
+    }
 
     INIT_HLIST_NODE(&area->node);
     area->start = ptr;
     area->size = size;
 
+    spin_lock_irqsave(&object->lock, flags);
     hlist_add_head(&area->node, &object->area_list);
 out_unlock:
     spin_unlock_irqrestore(&object->lock, flags);
-- 
1.8.3.rc1.44.gb387c77


--------------040500070602080603020209
Content-Type: text/x-patch;
 name="0003-mm-kmemleak.c-Merge-the-consecutive-scan-areas.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-mm-kmemleak.c-Merge-the-consecutive-scan-areas.patch"

>From a76e17c129d2f779f1588aa7ae319b76854068eb Mon Sep 17 00:00:00 2001
From: Jianpeng Ma <majianpeng@gmail.com>
Date: Tue, 14 May 2013 19:32:06 +0800
Subject: [PATCH 3/3] mm/kmemleak.c: Merge the consecutive scan-areas.

If the scan-areas are adjacent,it can merge in order to reduce memomy.
And using pr_warn instead of pr_warning.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 mm/kmemleak.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index f0ece93..9590a57 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -746,24 +746,36 @@ static void add_scan_area(unsigned long ptr, size_t size, gfp_t gfp)
 		return;
 	}
 
-	area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
-	if (!area) {
-		pr_warning("Cannot allocate a scan area\n");
-		goto out;
-	}
-
 	spin_lock_irqsave(&object->lock, flags);
 	if (ptr + size > object->pointer + object->size) {
 		kmemleak_warn("Scan area larger than object 0x%08lx\n", ptr);
 		dump_object_info(object);
-		kmem_cache_free(scan_area_cache, area);
 		goto out_unlock;
 	}
+	hlist_for_each_entry(area, &object->area_list, node) {
+		if (ptr + size == area->start) {
+			area->start = ptr;
+			area->size += size;
+			goto out_unlock;
+		} else if (ptr == area->start + area->size) {
+			area->size += size;
+			goto out_unlock;
+		}
+
+	}
+	spin_unlock_irqrestore(&object->lock, flags);
+
+	area = kmem_cache_alloc(scan_area_cache, gfp_kmemleak_mask(gfp));
+	if (!area) {
+		pr_warn("Cannot allocate a scan area\n");
+		goto out;
+	}
 
 	INIT_HLIST_NODE(&area->node);
 	area->start = ptr;
 	area->size = size;
 
+	spin_lock_irqsave(&object->lock, flags);
 	hlist_add_head(&area->node, &object->area_list);
 out_unlock:
 	spin_unlock_irqrestore(&object->lock, flags);
-- 
1.8.3.rc1.44.gb387c77


--------------040500070602080603020209--
