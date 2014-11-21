Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaKUNnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:43:46 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47042 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaKUNno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:43:44 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, iamjoonsoo.kim@lge.com,
        ddstreet@ieee.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH v2] mm/zsmalloc: avoid duplicate assignment of prev_class
Date: Fri, 21 Nov 2014 21:43:23 +0800
Message-Id: <1416577403-7887-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1)
times. And the prev_class only references to the previous size_class.
So we do not need unnecessary assignement.

This patch assigns *prev_class* when a new size_class structure
is allocated and uses prev_class to check whether the first class
has been allocated.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>

---
v1 -> v2:
  - follow Dan Streetman's advise to use prev_class to
    check whether the first class has been allocated
  - follow Minchan Kim's advise to remove uninitialized_var()
---
 mm/zsmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b3b57ef..810eda1 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -970,7 +970,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
-		struct size_class *prev_class;
+		struct size_class *prev_class = NULL;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
@@ -986,8 +986,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		 * characteristics. So, we makes size_class point to
 		 * previous size_class if possible.
 		 */
-		if (i < ZS_SIZE_CLASSES - 1) {
-			prev_class = pool->size_class[i + 1];
+		if (prev_class) {
 			if (can_merge(prev_class, size, pages_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
@@ -1003,6 +1002,8 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		class->pages_per_zspage = pages_per_zspage;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
+
+		prev_class = class;
 	}
 
 	pool->flags = flags;
-- 
1.7.9.5

