Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbaFSP5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:57:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62703 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbaFSP5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:57:33 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-09-53a3086ab9d0
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ryabinin.a.a@gmail.com, Andrey Ryabinin <a.ryabinin@samsung.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] mm: slub: SLUB_DEBUG=n: use the same alloc/free hooks as for
 SLUB_DEBUG=y
Date: Thu, 19 Jun 2014 19:52:18 +0400
Message-id: <1403193138-7677-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xq7pZHIuDDa6u0rDY9usRm8Wc9WvY
	LG6u2s5ssbK7mc1iZecDVovLu+awWdxb85/Vou3zPyCxZCOTxfGtW5gduDx2zrrL7rFgU6nH
	plWdbB6bPk1i9+h6e4XJ48SM3ywefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlfHqt2/BYfWK
	h8vdGhhPKXQxcnBICJhI9Exh7WLkBDLFJC7cW8/WxcjFISSwlFHi9dbbzBBOH5PEp12vwKrY
	BPQk/s3azgZiiwjoSqx6vgusiFngCJPE22lt7CAJYYEYibf7zrKA2CwCqhKLfrawgWzjFXCV
	mLolHmKbgsSy5TNZJzByL2BkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElpfdjAuPmZ1
	iFGAg1GJh/fD2wXBQqyJZcWVuYcYJTiYlUR4d39dFCzEm5JYWZValB9fVJqTWnyIkYmDU6qB
	kd1JduOOY09XHEq+nd3uU/Dhxq7ZUYHVnrsebPkw165Sp6hwW4D+/5VcOU5Xz5vHbvzsb5es
	LsjLFfLx2tqkO9Z53O1BXUVyk2b95pmR9ez2WX0Ju6Pbwyd4TI/6YH6i4fjTX/2uO2yc/Z+5
	X2orfdpT47Btc0XnQvtQx78Tb7/2aeQxqdWJVWIpzkg01GIuKk4EAH4NfLELAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two versions of alloc/free hooks now - one for CONFIG_SLUB_DEBUG=y
and another one for CONFIG_SLUB_DEBUG=n.

I see no reason why calls to other debugging subsystems (LOCKDEP,
DEBUG_ATOMIC_SLEEP, KMEMCHECK and FAILSLAB) are hidden under SLUB_DEBUG.
All this features should work regardless of SLUB_DEBUG config, as all of
them already have own Kconfig options.

This also fixes failslab for CONFIG_SLUB_DEBUG=n configuration.
It simply not worked before because should_failslab() call was in hook
hidden under "#ifdef CONFIG_SLUB_DEBUG #else".

Note: There is one concealed change in allocation path for SLUB_DEBUG=n and all
other debugging features disabled. might_sleep_if() call can generate some code
even if DEBUG_ATOMIC_SLEEP=n. For PREEMPT_VOLUNTARY=y migth_sleep() inserts
_cond_resched() call, but I think it should be ok.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slub.c | 97 ++++++++++++++++++++++++---------------------------------------
 1 file changed, 36 insertions(+), 61 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b2b0473..8f477c3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -945,60 +945,6 @@ static void trace(struct kmem_cache *s, struct page *page, void *object,
 }
 
 /*
- * Hooks for other subsystems that check memory allocations. In a typical
- * production configuration these hooks all should produce no code at all.
- */
-static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
-{
-	kmemleak_alloc(ptr, size, 1, flags);
-}
-
-static inline void kfree_hook(const void *x)
-{
-	kmemleak_free(x);
-}
-
-static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
-{
-	flags &= gfp_allowed_mask;
-	lockdep_trace_alloc(flags);
-	might_sleep_if(flags & __GFP_WAIT);
-
-	return should_failslab(s->object_size, flags, s->flags);
-}
-
-static inline void slab_post_alloc_hook(struct kmem_cache *s,
-					gfp_t flags, void *object)
-{
-	flags &= gfp_allowed_mask;
-	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
-	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
-}
-
-static inline void slab_free_hook(struct kmem_cache *s, void *x)
-{
-	kmemleak_free_recursive(x, s->flags);
-
-	/*
-	 * Trouble is that we may no longer disable interrupts in the fast path
-	 * So in order to make the debug calls that expect irqs to be
-	 * disabled we need to disable interrupts temporarily.
-	 */
-#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
-	{
-		unsigned long flags;
-
-		local_irq_save(flags);
-		kmemcheck_slab_free(s, x, s->object_size);
-		debug_check_no_locks_freed(x, s->object_size);
-		local_irq_restore(flags);
-	}
-#endif
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(x, s->object_size);
-}
-
-/*
  * Tracking of fully allocated slabs for debugging purposes.
  */
 static void add_full(struct kmem_cache *s,
@@ -1282,6 +1228,12 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node,
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 
+#endif /* CONFIG_SLUB_DEBUG */
+
+/*
+ * Hooks for other subsystems that check memory allocations. In a typical
+ * production configuration these hooks all should produce no code at all.
+ */
 static inline void kmalloc_large_node_hook(void *ptr, size_t size, gfp_t flags)
 {
 	kmemleak_alloc(ptr, size, 1, flags);
@@ -1293,22 +1245,45 @@ static inline void kfree_hook(const void *x)
 }
 
 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
-							{ return 0; }
+{
+	flags &= gfp_allowed_mask;
+	lockdep_trace_alloc(flags);
+	might_sleep_if(flags & __GFP_WAIT);
+
+	return should_failslab(s->object_size, flags, s->flags);
+}
 
-static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
-		void *object)
+static inline void slab_post_alloc_hook(struct kmem_cache *s,
+					gfp_t flags, void *object)
 {
-	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags,
-		flags & gfp_allowed_mask);
+	flags &= gfp_allowed_mask;
+	kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
+	kmemleak_alloc_recursive(object, s->object_size, 1, s->flags, flags);
 }
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
 {
 	kmemleak_free_recursive(x, s->flags);
+
+	/*
+	 * Trouble is that we may no longer disable interrupts in the fast path
+	 * So in order to make the debug calls that expect irqs to be
+	 * disabled we need to disable interrupts temporarily.
+	 */
+#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
+	{
+		unsigned long flags;
+
+		local_irq_save(flags);
+		kmemcheck_slab_free(s, x, s->object_size);
+		debug_check_no_locks_freed(x, s->object_size);
+		local_irq_restore(flags);
+	}
+#endif
+	if (!(s->flags & SLAB_DEBUG_OBJECTS))
+		debug_check_no_obj_freed(x, s->object_size);
 }
 
-#endif /* CONFIG_SLUB_DEBUG */
-
 /*
  * Slab allocation and freeing
  */
-- 
1.8.5.5

