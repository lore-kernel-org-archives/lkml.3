Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaGILMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:12:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52164 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaGILK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:26 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a7-53bd231be6c8
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 15/21] mm: slub: add kernel address sanitizer hooks
 to slub allocator
Date: Wed, 09 Jul 2014 15:01:12 +0400
Message-id: <1404903678-8257-16-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7rSynuDDQ4eNbbY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+N3w3KmgrfFFfPu3GBqYOyI72Lk5JAQMJGY
	eWMlG4QtJnHh3nogm4tDSGApo8S+KefYIZw+JonerVcYQarYBPQk/s3aDtYhIqAgsbn3GSuI
	zSygI7HxWisTiC0skCgxYe0FdhCbRUBVYtL2d8wgNq+Am8SW3hfMENsUJJYtnwnWywkU7+lZ
	ANYrJOAqsfrzNsYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSEwZcdjIuPWR1i
	FOBgVOLh1ajdHSzEmlhWXJl7iFGCg1lJhNdWdG+wEG9KYmVValF+fFFpTmrxIUYmDk6pBkbV
	xAdLM0+k7l/CuO9kx/Eo/vzA3XNnCup03P3V1e2+Z+fXo1dM2nd9W5LBEuHifvhp1WIJly4W
	BsNrizVFLidtO2ysmHNK72m1UpT01EMWufWeHf37zv3fU77Y0rUir/Hg6tKtKq/lqplO51rc
	frZHKkGipPPMI8bpjOvnT9RYoZdW9spefJESS3FGoqEWc1FxIgCFRXTV4QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch kasan will be able to catch bugs in memory allocated
by slub.
Allocated slab page, this whole page marked as unaccessible
in corresponding shadow memory.
On allocation of slub object requested allocation size marked as
accessible, and the rest of the object (including slub's metadata)
marked as redzone (unaccessible).

We also mark object as accessible if ksize was called for this object.
There is some places in kernel where ksize function is called to inquire
size of really allocated area. Such callers could validly access whole
allocated memory, so it should be marked as accessible by kasan_krealloc call.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/kasan.h |  22 ++++++++++
 include/linux/slab.h  |  19 +++++++--
 lib/Kconfig.kasan     |   2 +
 mm/kasan/kasan.c      | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h      |   5 +++
 mm/kasan/report.c     |  23 +++++++++++
 mm/slab.h             |   2 +-
 mm/slab_common.c      |   9 +++--
 mm/slub.c             |  24 ++++++++++-
 9 files changed, 208 insertions(+), 8 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 4adc0a1..583c011 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -20,6 +20,17 @@ void kasan_init_shadow(void);
 void kasan_alloc_pages(struct page *page, unsigned int order);
 void kasan_free_pages(struct page *page, unsigned int order);
 
+void kasan_kmalloc_large(const void *ptr, size_t size);
+void kasan_kfree_large(const void *ptr);
+void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size);
+void kasan_krealloc(const void *object, size_t new_size);
+
+void kasan_slab_alloc(struct kmem_cache *s, void *object);
+void kasan_slab_free(struct kmem_cache *s, void *object);
+
+void kasan_alloc_slab_pages(struct page *page, int order);
+void kasan_free_slab_pages(struct page *page, int order);
+
 #else /* CONFIG_KASAN */
 
 static inline void unpoison_shadow(const void *address, size_t size) {}
@@ -34,6 +45,17 @@ static inline void kasan_alloc_shadow(void) {}
 static inline void kasan_alloc_pages(struct page *page, unsigned int order) {}
 static inline void kasan_free_pages(struct page *page, unsigned int order) {}
 
+static inline void kasan_kmalloc_large(void *ptr, size_t size) {}
+static inline void kasan_kfree_large(const void *ptr) {}
+static inline void kasan_kmalloc(struct kmem_cache *s, const void *object, size_t size) {}
+static inline void kasan_krealloc(const void *object, size_t new_size) {}
+
+static inline void kasan_slab_alloc(struct kmem_cache *s, void *object) {}
+static inline void kasan_slab_free(struct kmem_cache *s, void *object) {}
+
+static inline void kasan_alloc_slab_pages(struct page *page, int order) {}
+static inline void kasan_free_slab_pages(struct page *page, int order) {}
+
 #endif /* CONFIG_KASAN */
 
 #endif /* LINUX_KASAN_H */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 68b1feab..a9513e9 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -104,6 +104,7 @@
 				(unsigned long)ZERO_SIZE_PTR)
 
 #include <linux/kmemleak.h>
+#include <linux/kasan.h>
 
 struct mem_cgroup;
 /*
@@ -444,6 +445,8 @@ static __always_inline void *kmalloc_large(size_t size, gfp_t flags)
  */
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
 {
+	void *ret;
+
 	if (__builtin_constant_p(size)) {
 		if (size > KMALLOC_MAX_CACHE_SIZE)
 			return kmalloc_large(size, flags);
@@ -454,8 +457,12 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 			if (!index)
 				return ZERO_SIZE_PTR;
 
-			return kmem_cache_alloc_trace(kmalloc_caches[index],
+			ret = kmem_cache_alloc_trace(kmalloc_caches[index],
 					flags, size);
+
+			kasan_kmalloc(kmalloc_caches[index], ret, size);
+
+			return ret;
 		}
 #endif
 	}
@@ -485,6 +492,8 @@ static __always_inline int kmalloc_size(int n)
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
 #ifndef CONFIG_SLOB
+	void *ret;
+
 	if (__builtin_constant_p(size) &&
 		size <= KMALLOC_MAX_CACHE_SIZE && !(flags & GFP_DMA)) {
 		int i = kmalloc_index(size);
@@ -492,8 +501,12 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 		if (!i)
 			return ZERO_SIZE_PTR;
 
-		return kmem_cache_alloc_node_trace(kmalloc_caches[i],
-						flags, node, size);
+		ret = kmem_cache_alloc_node_trace(kmalloc_caches[i],
+						  flags, node, size);
+
+		kasan_kmalloc(kmalloc_caches[i], ret, size);
+
+		return ret;
 	}
 #endif
 	return __kmalloc_node(size, flags, node);
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 2bfff78..289a624 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -5,6 +5,8 @@ if HAVE_ARCH_KASAN
 
 config KASAN
 	bool "AddressSanitizer: dynamic memory error detector"
+	depends on SLUB
+	select STACKTRACE
 	default n
 	help
 	  Enables AddressSanitizer - dynamic memory error detector,
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 109478e..9b5182a 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -177,6 +177,116 @@ void __init kasan_init_shadow(void)
 	}
 }
 
+void kasan_alloc_slab_pages(struct page *page, int order)
+{
+	if (unlikely(!kasan_initialized))
+		return;
+
+	poison_shadow(page_address(page), PAGE_SIZE << order, KASAN_SLAB_REDZONE);
+}
+
+void kasan_free_slab_pages(struct page *page, int order)
+{
+	if (unlikely(!kasan_initialized))
+		return;
+
+	poison_shadow(page_address(page), PAGE_SIZE << order, KASAN_SLAB_FREE);
+}
+
+void kasan_slab_alloc(struct kmem_cache *cache, void *object)
+{
+	if (unlikely(!kasan_initialized))
+		return;
+
+	if (unlikely(object == NULL))
+		return;
+
+	poison_shadow(object, cache->size, KASAN_KMALLOC_REDZONE);
+	unpoison_shadow(object, cache->alloc_size);
+}
+
+void kasan_slab_free(struct kmem_cache *cache, void *object)
+{
+	unsigned long size = cache->size;
+	unsigned long rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
+
+	if (unlikely(!kasan_initialized))
+		return;
+
+	poison_shadow(object, rounded_up_size, KASAN_KMALLOC_FREE);
+}
+
+void kasan_kmalloc(struct kmem_cache *cache, const void *object, size_t size)
+{
+	unsigned long redzone_start;
+	unsigned long redzone_end;
+
+	if (unlikely(!kasan_initialized))
+		return;
+
+	if (unlikely(object == NULL))
+		return;
+
+	redzone_start = round_up((unsigned long)(object + size),
+				KASAN_SHADOW_SCALE_SIZE);
+	redzone_end = (unsigned long)object + cache->size;
+
+	unpoison_shadow(object, size);
+	poison_shadow((void *)redzone_start, redzone_end - redzone_start,
+		KASAN_KMALLOC_REDZONE);
+
+}
+EXPORT_SYMBOL(kasan_kmalloc);
+
+void kasan_kmalloc_large(const void *ptr, size_t size)
+{
+	struct page *page;
+	unsigned long redzone_start;
+	unsigned long redzone_end;
+
+	if (unlikely(!kasan_initialized))
+		return;
+
+	if (unlikely(ptr == NULL))
+		return;
+
+	page = virt_to_page(ptr);
+	redzone_start = round_up((unsigned long)(ptr + size),
+				KASAN_SHADOW_SCALE_SIZE);
+	redzone_end = (unsigned long)ptr + (PAGE_SIZE << compound_order(page));
+
+	unpoison_shadow(ptr, size);
+	poison_shadow((void *)redzone_start, redzone_end - redzone_start,
+		KASAN_PAGE_REDZONE);
+}
+EXPORT_SYMBOL(kasan_kmalloc_large);
+
+void kasan_krealloc(const void *object, size_t size)
+{
+	struct page *page;
+
+	if (unlikely(object == ZERO_SIZE_PTR))
+		return;
+
+	page = virt_to_head_page(object);
+
+	if (unlikely(!PageSlab(page)))
+		kasan_kmalloc_large(object, size);
+	else
+		kasan_kmalloc(page->slab_cache, object, size);
+}
+
+void kasan_kfree_large(const void *ptr)
+{
+	struct page *page;
+
+	if (unlikely(!kasan_initialized))
+		return;
+
+	page = virt_to_page(ptr);
+	poison_shadow(ptr, PAGE_SIZE << compound_order(page), KASAN_FREE_PAGE);
+}
+
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	if (unlikely(!kasan_initialized))
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index be9597e..f925d03 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -6,6 +6,11 @@
 #define KASAN_SHADOW_MASK       (KASAN_SHADOW_SCALE_SIZE - 1)
 
 #define KASAN_FREE_PAGE         0xFF  /* page was freed */
+#define KASAN_PAGE_REDZONE      0xFE  /* redzone for kmalloc_large allocations */
+#define KASAN_SLAB_REDZONE      0xFD  /* Slab page redzone, does not belong to any slub object */
+#define KASAN_KMALLOC_REDZONE   0xFC  /* redzone inside slub object */
+#define KASAN_KMALLOC_FREE      0xFB  /* object was freed (kmem_cache_free/kfree) */
+#define KASAN_SLAB_FREE         0xFA  /* free slab page */
 #define KASAN_SHADOW_GAP        0xF9  /* address belongs to shadow memory */
 
 struct access_info {
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 6ef9e57..6d829af 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -43,10 +43,15 @@ static void print_error_description(struct access_info *info)
 	u8 shadow_val = *(u8 *)kasan_mem_to_shadow(info->access_addr);
 
 	switch (shadow_val) {
+	case KASAN_PAGE_REDZONE:
+	case KASAN_SLAB_REDZONE:
+	case KASAN_KMALLOC_REDZONE:
 	case 0 ... KASAN_SHADOW_SCALE_SIZE - 1:
 		bug_type = "buffer overflow";
 		break;
 	case KASAN_FREE_PAGE:
+	case KASAN_SLAB_FREE:
+	case KASAN_KMALLOC_FREE:
 		bug_type = "use after free";
 		break;
 	case KASAN_SHADOW_GAP:
@@ -70,7 +75,25 @@ static void print_address_description(struct access_info *info)
 	page = virt_to_page(info->access_addr);
 
 	switch (shadow_val) {
+	case KASAN_SLAB_REDZONE:
+		cache = virt_to_cache((void *)info->access_addr);
+		slab_err(cache, page, "access to slab redzone");
+		dump_stack();
+		break;
+	case KASAN_KMALLOC_FREE:
+	case KASAN_KMALLOC_REDZONE:
+	case 1 ... KASAN_SHADOW_SCALE_SIZE - 1:
+		if (PageSlab(page)) {
+			cache = virt_to_cache((void *)info->access_addr);
+			slab_start = page_address(virt_to_head_page((void *)info->access_addr));
+			object = virt_to_obj(cache, slab_start,
+					(void *)info->access_addr);
+			object_err(cache, page, object, "kasan error");
+			break;
+		}
+	case KASAN_PAGE_REDZONE:
 	case KASAN_FREE_PAGE:
+	case KASAN_SLAB_FREE:
 		dump_page(page, "kasan error");
 		dump_stack();
 		break;
diff --git a/mm/slab.h b/mm/slab.h
index cb2e776..b22ed8b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -353,6 +353,6 @@ void slab_err(struct kmem_cache *s, struct page *page,
 		const char *fmt, ...);
 void object_err(struct kmem_cache *s, struct page *page,
 		u8 *object, char *reason);
-
+size_t __ksize(const void *obj);
 
 #endif /* MM_SLAB_H */
diff --git a/mm/slab_common.c b/mm/slab_common.c
index f5b52f0..313e270 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -625,6 +625,7 @@ void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
 	page = alloc_kmem_pages(flags, order);
 	ret = page ? page_address(page) : NULL;
 	kmemleak_alloc(ret, size, 1, flags);
+	kasan_kmalloc_large(ret, size);
 	return ret;
 }
 EXPORT_SYMBOL(kmalloc_order);
@@ -797,10 +798,12 @@ static __always_inline void *__do_krealloc(const void *p, size_t new_size,
 	size_t ks = 0;
 
 	if (p)
-		ks = ksize(p);
+		ks = __ksize(p);
 
-	if (ks >= new_size)
+	if (ks >= new_size) {
+		kasan_krealloc((void *)p, new_size);
 		return (void *)p;
+	}
 
 	ret = kmalloc_track_caller(new_size, flags);
 	if (ret && p)
@@ -875,7 +878,7 @@ void kzfree(const void *p)
 
 	if (unlikely(ZERO_OR_NULL_PTR(mem)))
 		return;
-	ks = ksize(mem);
+	ks = __ksize(mem);
 	memset(mem, 0, ks);
 	kfree(mem);
 }
diff --git a/mm/slub.c b/mm/slub.c
index c8dbea7..87d2198 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -33,6 +33,7 @@
 #include <linux/stacktrace.h>
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
+#include <linux/kasan.h>
 
 #include <trace/events/kmem.h>
 
@@ -1245,11 +1246,13 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
 static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
 {
 	kmemleak_alloc(ptr, size, 1, flags);
+	kasan_kmalloc_large(ptr, size);
 }
 
 static inline void kfree_hook(const void *x)
 {
 	kmemleak_free(x);
+	kasan_kfree_large(x);
 }
 
 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
@@ -1267,11 +1270,13 @@ static inline void slab_post_alloc_hook(struct kmem_cache *s,
 	flags &= gfp_allowed_mask;
 	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
 	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
+	kasan_slab_alloc(s, object);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
 {
 	kmemleak_free_recursive(x, s->flags);
+	kasan_slab_free(s, x);
 
 	/*
 	 * Trouble is that we may no longer disable interrupts in the fast path
@@ -1371,6 +1376,8 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if (!page)
 		return NULL;
 
+	kasan_alloc_slab_pages(page, oo_order(oo));
+
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -1450,6 +1457,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	}
 
 	kmemcheck_free_shadow(page, compound_order(page));
+	kasan_free_slab_pages(page, compound_order(page));
 
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
@@ -2907,6 +2915,7 @@ static void early_kmem_cache_node_alloc(int node)
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 	init_tracking(kmem_cache_node, n);
 #endif
+	kasan_kmalloc(kmem_cache_node, n, sizeof(struct kmem_cache_node));
 	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
@@ -3289,6 +3298,8 @@ void *__kmalloc(size_t size, gfp_t flags)
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, flags);
 
+	kasan_kmalloc(s, ret, size);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc);
@@ -3332,12 +3343,14 @@ void *__kmalloc_node(size_t size, gfp_t flags, int node)
 
 	trace_kmalloc_node(_RET_IP_, ret, size, s->size, flags, node);
 
+	kasan_kmalloc(s, ret, size);
+
 	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
-size_t ksize(const void *object)
+size_t __ksize(const void *object)
 {
 	struct page *page;
 
@@ -3353,6 +3366,15 @@ size_t ksize(const void *object)
 
 	return slab_ksize(page->slab_cache);
 }
+
+size_t ksize(const void *object)
+{
+	size_t size = __ksize(object);
+	/* We assume that ksize callers could use whole allocated area,
+	   so we need unpoison this area. */
+	kasan_krealloc(object, size);
+	return size;
+}
 EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
-- 
1.8.5.5

