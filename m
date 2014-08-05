Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaHEIBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:01:41 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:33221 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbaHEIBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:01:37 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 1/3] zsmalloc: move pages_allocated to zs_pool
Date: Tue,  5 Aug 2014 17:02:01 +0900
Message-Id: <1407225723-23754-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407225723-23754-1-git-send-email-minchan@kernel.org>
References: <1407225723-23754-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages_allocated has counted in size_class structure and when user
want to see total_size_bytes, it gathers all of value from each
size_class to report the sum.

It's not bad if user don't see the value often but if user start
to see the value frequently, it would be not a good deal for
performance POV.

This patch moves the variable from size_class to zs_pool so it would
reduce memory footprint (from [255 * 8byte] to [sizeof(atomic_t)])
but it adds new locking overhead but it wouldn't be severe because
it's not a hot path in zs_malloc(ie, it is called only when new
zspage is created, not a object).

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index fe78189624cf..a6089bd26621 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -198,9 +198,6 @@ struct size_class {
 
 	spinlock_t lock;
 
-	/* stats */
-	u64 pages_allocated;
-
 	struct page *fullness_list[_ZS_NR_FULLNESS_GROUPS];
 };
 
@@ -216,9 +213,12 @@ struct link_free {
 };
 
 struct zs_pool {
+	spinlock_t stat_lock;
+
 	struct size_class size_class[ZS_SIZE_CLASSES];
 
 	gfp_t flags;	/* allocation flags used when growing pool */
+	unsigned long pages_allocated;
 };
 
 /*
@@ -882,6 +882,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 
 	}
 
+	spin_lock_init(&pool->stat_lock);
 	pool->flags = flags;
 
 	return pool;
@@ -943,8 +944,10 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 			return 0;
 
 		set_zspage_mapping(first_page, class->index, ZS_EMPTY);
+		spin_lock(&pool->stat_lock);
+		pool->pages_allocated += class->pages_per_zspage;
+		spin_unlock(&pool->stat_lock);
 		spin_lock(&class->lock);
-		class->pages_allocated += class->pages_per_zspage;
 	}
 
 	obj = (unsigned long)first_page->freelist;
@@ -997,14 +1000,14 @@ void zs_free(struct zs_pool *pool, unsigned long obj)
 
 	first_page->inuse--;
 	fullness = fix_fullness_group(pool, first_page);
-
-	if (fullness == ZS_EMPTY)
-		class->pages_allocated -= class->pages_per_zspage;
-
 	spin_unlock(&class->lock);
 
-	if (fullness == ZS_EMPTY)
+	if (fullness == ZS_EMPTY) {
+		spin_lock(&pool->stat_lock);
+		pool->pages_allocated -= class->pages_per_zspage;
+		spin_unlock(&pool->stat_lock);
 		free_zspage(first_page);
+	}
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -1100,12 +1103,11 @@ EXPORT_SYMBOL_GPL(zs_unmap_object);
 
 u64 zs_get_total_size_bytes(struct zs_pool *pool)
 {
-	int i;
-	u64 npages = 0;
-
-	for (i = 0; i < ZS_SIZE_CLASSES; i++)
-		npages += pool->size_class[i].pages_allocated;
+	u64 npages;
 
+	spin_lock(&pool->stat_lock);
+	npages = pool->pages_allocated;
+	spin_unlock(&pool->stat_lock);
 	return npages << PAGE_SHIFT;
 }
 EXPORT_SYMBOL_GPL(zs_get_total_size_bytes);
-- 
2.0.0

