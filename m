Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaGKMJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:09:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29922 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaGKMJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:09:22 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-b3-53bfd3ef7b06
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] mm: move slab related stuff from util.c to slab_common.c
Date: Fri, 11 Jul 2014 16:03:44 +0400
Message-id: <1405080224-26608-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t/xa7rvL+8PNvjdbGWx7dcjNos569ew
	WVz/9obRYmV3M5vF5V1z2CzurfnPatH2+R+QWLKRyYHDY8GmUo9NqzrZPDZ9msTu0fX2CpPH
	iRm/WTyeXJnO5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZK9p/sxa0mlXs+rWYqYFxkXYX
	IweHhICJxPJHIl2MnECmmMSFe+vZuhi5OIQEljJKbO9YCOX0MUkcOfmKFaSKTUBP4t+s7Wwg
	toiArsSq57uYQYqYBb4ySnzvOMwMkhAW8JRY+usIWAOLgKpE26lN7CA2r4CbxM1vG5kg1ilI
	LFs+k3UCI/cCRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHB9GUH4+JjVocYBTgYlXh4
	NWp3BwuxJpYVV+YeYpTgYFYS4TU/uz9YiDclsbIqtSg/vqg0J7X4ECMTB6dUAyN7a9l3rhCu
	BMe1LDqCGy+FlV9Z1Gy0wOXJFMHiqz0vTRbKqa71uOoU6/91izRrfffjeZdnd66JyDo5wWpd
	WtznoKL7+T9mLjMK/tib96vA5M6vEmuBk5e/XxV+dz6exSu06W2PjHFhRtFEBy2uvZW2aur7
	nwVsmsbZyn9j3vFlidN35svMFVViKc5INNRiLipOBAB8iWB8BAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions krealloc(), __krealloc(), kzfree() belongs to slab API,
so should be placed in slab_common.c
Also move slab allocator's tracepoints defenitions to slab_common.c
No functional changes here.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 mm/slab_common.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/util.c        | 102 -------------------------------------------------------
 2 files changed, 101 insertions(+), 102 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 735e01a..33ed42e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -19,6 +19,8 @@
 #include <asm/tlbflush.h>
 #include <asm/page.h>
 #include <linux/memcontrol.h>
+
+#define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
 #include "slab.h"
@@ -787,3 +789,102 @@ static int __init slab_proc_init(void)
 }
 module_init(slab_proc_init);
 #endif /* CONFIG_SLABINFO */
+
+static __always_inline void *__do_krealloc(const void *p, size_t new_size,
+					   gfp_t flags)
+{
+	void *ret;
+	size_t ks = 0;
+
+	if (p)
+		ks = ksize(p);
+
+	if (ks >= new_size)
+		return (void *)p;
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret && p)
+		memcpy(ret, p, ks);
+
+	return ret;
+}
+
+/**
+ * __krealloc - like krealloc() but don't free @p.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * This function is like krealloc() except it never frees the originally
+ * allocated buffer. Use this if you don't want to free the buffer immediately
+ * like, for example, with RCU.
+ */
+void *__krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	if (unlikely(!new_size))
+		return ZERO_SIZE_PTR;
+
+	return __do_krealloc(p, new_size, flags);
+
+}
+EXPORT_SYMBOL(__krealloc);
+
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return ZERO_SIZE_PTR;
+	}
+
+	ret = __do_krealloc(p, new_size, flags);
+	if (ret && p != ret)
+		kfree(p);
+
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
+/**
+ * kzfree - like kfree but zero memory
+ * @p: object to free memory of
+ *
+ * The memory of the object @p points to is zeroed before freed.
+ * If @p is %NULL, kzfree() does nothing.
+ *
+ * Note: this function zeroes the whole allocated buffer which can be a good
+ * deal bigger than the requested buffer size passed to kmalloc(). So be
+ * careful when using this function in performance sensitive code.
+ */
+void kzfree(const void *p)
+{
+	size_t ks;
+	void *mem = (void *)p;
+
+	if (unlikely(ZERO_OR_NULL_PTR(mem)))
+		return;
+	ks = ksize(mem);
+	memset(mem, 0, ks);
+	kfree(mem);
+}
+EXPORT_SYMBOL(kzfree);
+
+/* Tracepoints definitions. */
+EXPORT_TRACEPOINT_SYMBOL(kmalloc);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
+EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
+EXPORT_TRACEPOINT_SYMBOL(kfree);
+EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
diff --git a/mm/util.c b/mm/util.c
index d5ea733..7b6608d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -16,9 +16,6 @@
 
 #include "internal.h"
 
-#define CREATE_TRACE_POINTS
-#include <trace/events/kmem.h>
-
 /**
  * kstrdup - allocate space for and copy an existing string
  * @s: the string to duplicate
@@ -112,97 +109,6 @@ void *memdup_user(const void __user *src, size_t len)
 }
 EXPORT_SYMBOL(memdup_user);
 
-static __always_inline void *__do_krealloc(const void *p, size_t new_size,
-					   gfp_t flags)
-{
-	void *ret;
-	size_t ks = 0;
-
-	if (p)
-		ks = ksize(p);
-
-	if (ks >= new_size)
-		return (void *)p;
-
-	ret = kmalloc_track_caller(new_size, flags);
-	if (ret && p)
-		memcpy(ret, p, ks);
-
-	return ret;
-}
-
-/**
- * __krealloc - like krealloc() but don't free @p.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * This function is like krealloc() except it never frees the originally
- * allocated buffer. Use this if you don't want to free the buffer immediately
- * like, for example, with RCU.
- */
-void *__krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	if (unlikely(!new_size))
-		return ZERO_SIZE_PTR;
-
-	return __do_krealloc(p, new_size, flags);
-
-}
-EXPORT_SYMBOL(__krealloc);
-
-/**
- * krealloc - reallocate memory. The contents will remain unchanged.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @new_size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
- */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	void *ret;
-
-	if (unlikely(!new_size)) {
-		kfree(p);
-		return ZERO_SIZE_PTR;
-	}
-
-	ret = __do_krealloc(p, new_size, flags);
-	if (ret && p != ret)
-		kfree(p);
-
-	return ret;
-}
-EXPORT_SYMBOL(krealloc);
-
-/**
- * kzfree - like kfree but zero memory
- * @p: object to free memory of
- *
- * The memory of the object @p points to is zeroed before freed.
- * If @p is %NULL, kzfree() does nothing.
- *
- * Note: this function zeroes the whole allocated buffer which can be a good
- * deal bigger than the requested buffer size passed to kmalloc(). So be
- * careful when using this function in performance sensitive code.
- */
-void kzfree(const void *p)
-{
-	size_t ks;
-	void *mem = (void *)p;
-
-	if (unlikely(ZERO_OR_NULL_PTR(mem)))
-		return;
-	ks = ksize(mem);
-	memset(mem, 0, ks);
-	kfree(mem);
-}
-EXPORT_SYMBOL(kzfree);
-
 /*
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate
@@ -504,11 +410,3 @@ out_mm:
 out:
 	return res;
 }
-
-/* Tracepoints definitions. */
-EXPORT_TRACEPOINT_SYMBOL(kmalloc);
-EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
-EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
-EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
-EXPORT_TRACEPOINT_SYMBOL(kfree);
-EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
-- 
1.8.5.5

