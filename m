Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaGILMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:12:08 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbaGILK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:26 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-3c-53bd231bdc1f
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 13/21] mm: slub: add allocation size field to struct
 kmem_cache
Date: Wed, 09 Jul 2014 15:01:10 +0400
Message-id: <1404903678-8257-14-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7rSynuDDfpOcVls+/WIzeLyrjls
	DkwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlfG2axtTwSvRisN36hsYrwt2MXJySAiYSEy9
	0sIEYYtJXLi3nq2LkYtDSGApo8S5V/3sEE4fk0Tv1iuMIFVsAnoS/2ZtZwOxRQQUJDb3PmMF
	sZkFdCQ2XmsFmyQsEC3RtLiHHcRmEVCVuLF7LVicV8BNov3fSxaIbQoSy5bPBOvlBIr39CwA
	qxEScJVY/Xkb4wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQoLg6w7GpcesDjEK
	cDAq8fC+2L0nWIg1say4MvcQowQHs5IIr63o3mAh3pTEyqrUovz4otKc1OJDjEwcnFINjCXv
	8y81q3g8fybx8pOJup7Ucovwg6oawoIRblNkTlQu3bt298M5IZ3RfOe0NFaXuX/efqZFev1N
	Ow1Nx5+PYxQbP8xZpqN/ttXXZbrc8Ucuc6Wz5Xt4dvs6zMmV8ZS/0bUypP1GRqmM9ROhm2+z
	udikCo3sZqfnF2vPLOwO35/5PGPvDr9+JZbijERDLeai4kQAZzdA9uABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When caller creates new kmem_cache, requested size of kmem_cache
will be stored in alloc_size. Later alloc_size will be used by
kerenel address sanitizer to mark alloc_size of slab object as
accessible and the rest of its size as redzone.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h |  5 +++++
 mm/slab.h                | 10 ++++++++++
 mm/slab_common.c         |  2 ++
 mm/slub.c                |  1 +
 4 files changed, 18 insertions(+)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index d82abd4..b8b8154 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -68,6 +68,11 @@ struct kmem_cache {
 	int object_size;	/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
 	int cpu_partial;	/* Number of per cpu partial objects to keep around */
+
+#ifdef CONFIG_KASAN
+	int alloc_size;		/* actual allocation size kmem_cache_create */
+#endif
+
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
diff --git a/mm/slab.h b/mm/slab.h
index 912af7f..cb2e776 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -260,6 +260,16 @@ static inline void memcg_uncharge_slab(struct kmem_cache *s, int order)
 }
 #endif
 
+#ifdef CONFIG_KASAN
+static inline void kasan_set_alloc_size(struct kmem_cache *s, size_t size)
+{
+	s->alloc_size = size;
+}
+#else
+static inline void kasan_set_alloc_size(struct kmem_cache *s, size_t size) { }
+#endif
+
+
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
 	struct page *page = virt_to_head_page(obj);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8df59b09..f5b52f0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -147,6 +147,7 @@ do_kmem_cache_create(char *name, size_t object_size, size_t size, size_t align,
 	s->name = name;
 	s->object_size = object_size;
 	s->size = size;
+	kasan_set_alloc_size(s, object_size);
 	s->align = align;
 	s->ctor = ctor;
 
@@ -409,6 +410,7 @@ void __init create_boot_cache(struct kmem_cache *s, const char *name, size_t siz
 
 	s->name = name;
 	s->size = s->object_size = size;
+	kasan_set_alloc_size(s, size);
 	s->align = calculate_alignment(flags, ARCH_KMALLOC_MINALIGN, size);
 	err = __kmem_cache_create(s, flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index 3bdd9ac..6ddedf9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3724,6 +3724,7 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 		 * the complete object on kzalloc.
 		 */
 		s->object_size = max(s->object_size, (int)size);
+		kasan_set_alloc_size(s, max(s->alloc_size, (int)size));
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 
 		for_each_memcg_cache_index(i) {
-- 
1.8.5.5

