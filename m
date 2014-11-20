Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaKTNIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:08:51 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53531 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKTNIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:08:50 -0500
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: [PATCH] mm/zsmalloc: avoid duplicate assignment of prev_class
Date: Thu, 20 Nov 2014 21:08:33 +0800
Message-Id: <1416488913-9691-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1)
times. And the prev_class only references to the previous alloc
size_class. So we do not need unnecessary assignement.

This patch modifies *prev_class* to *prev_alloc_class*. And the
*prev_alloc_class* will only be assigned when a new size_class
structure is allocated.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
---
 mm/zsmalloc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index b3b57ef..ac2b396 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -970,7 +970,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
-		struct size_class *prev_class;
+		struct size_class *uninitialized_var(prev_alloc_class);
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
@@ -987,9 +987,8 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		 * previous size_class if possible.
 		 */
 		if (i < ZS_SIZE_CLASSES - 1) {
-			prev_class = pool->size_class[i + 1];
-			if (can_merge(prev_class, size, pages_per_zspage)) {
-				pool->size_class[i] = prev_class;
+			if (can_merge(prev_alloc_class, size, pages_per_zspage)) {
+				pool->size_class[i] = prev_alloc_class;
 				continue;
 			}
 		}
@@ -1003,6 +1002,8 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 		class->pages_per_zspage = pages_per_zspage;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
+
+		prev_alloc_class = class;
 	}
 
 	pool->flags = flags;
-- 
1.7.9.5

