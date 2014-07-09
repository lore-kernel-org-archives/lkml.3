Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaGILK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:10:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaGILKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:25 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a0-53bd231ab90b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 10/21] mm: slab: share virt_to_cache() between slab
 and slub
Date: Wed, 09 Jul 2014 15:01:07 +0400
Message-id: <1404903678-8257-11-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7pSynuDDX52cFts+/WIzeLyrjls
	DkwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlXFu3jHWgtl8FTfmizcwnuPuYuTkkBAwkXjf
	vJwRwhaTuHBvPVsXIxeHkMBSRokzB9ayQzh9TBKXO5+AVbEJ6En8m7WdDcQWEVCQ2Nz7jBXE
	ZhbQkdh4rZUJxBYWiJC42NLGDGKzCKhKPOt+DBbnFXCT6H30gxVim4LEsuUzwWxOoHhPzwKw
	GiEBV4nVn7cxTmDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJAi+7GBcfMzqEKMA
	B6MSD69G7e5gIdbEsuLK3EOMEhzMSiK8tqJ7g4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwbnbm
	nXVUc4dM59NdzGX1nGU+V6rznR7GzeX80+3X8kJN/OB5FfOVL8Rb2PdZKk1Z8dPsgAr36l/n
	2951Snp+eN20NYDrQ2kId7vt5UdKYTzCiowNX8WUbFxkfli9up82eU9HqaBiqKdktOMde7Pe
	XZtPOE1UWikkF25++sL2+vZdD9TrpTKUWIozEg21mIuKEwGxVDUF4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shares virt_to_cache() between slab and slub and
it used in cache_from_obj() now.
Later virt_to_cache() will be kernel address sanitizer also.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.c |  6 ------
 mm/slab.h | 10 +++++++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e7763db..fa4f840 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -433,12 +433,6 @@ static inline void set_obj_status(struct page *page, int idx, int val) {}
 static int slab_max_order = SLAB_MAX_ORDER_LO;
 static bool slab_max_order_set __initdata;
 
-static inline struct kmem_cache *virt_to_cache(const void *obj)
-{
-	struct page *page = virt_to_head_page(obj);
-	return page->slab_cache;
-}
-
 static inline void *index_to_obj(struct kmem_cache *cache, struct page *page,
 				 unsigned int idx)
 {
diff --git a/mm/slab.h b/mm/slab.h
index 84c160a..1257ade 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -260,10 +260,15 @@ static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
 }
 #endif
 
+static inline struct kmem_cache *virt_to_cache(const void *obj)
+{
+	struct page *page = virt_to_head_page(obj);
+	return page->slab_cache;
+}
+
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 {
 	struct kmem_cache *cachep;
-	struct page *page;
 
 	/*
 	 * When kmemcg is not being used, both assignments should return the
@@ -275,8 +280,7 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
 	if (!memcg_kmem_enabled() && !unlikely(s->flags & SLAB_DEBUG_FREE))
 		return s;
 
-	page = virt_to_head_page(x);
-	cachep = page->slab_cache;
+	cachep = virt_to_cache(x);
 	if (slab_equal_or_root(cachep, s))
 		return cachep;
 
-- 
1.8.5.5

