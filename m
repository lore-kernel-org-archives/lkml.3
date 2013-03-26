Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab3CZURZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:17:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:58933 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab3CZURY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:17:24 -0400
Date: Tue, 26 Mar 2013 21:17:22 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [ANNOUNCE] 3.8.4-rt2
Message-ID: <20130326201722.GA14220@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.8.4-rt2 release.

changes since v3.8.4-rt1:
- build fix for i915 (reported by "Luis Claudio R. Goncalves")
- build fix for fscache (reported by tglx)
- build fix for !RT (kernel/softirq.c did not compile)
- per-cpu rwsem fixed for RT (required only by uprobes so far)
- slub: delay the execution of the ->ctor() hook for newly created
  objects. This lowers the worst case latencies.

Known issues:

      - SLxB is broken on PowerPC.

The delta patch against v3.8.4-rt1 is appended below and can be found
here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.4-rt1-rt2.patch.xz

The RT patch against 3.8.4 can be found here:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.4-rt2.patch.xz

The split quilt queue is available at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.8.4-rt2.tar.xz

Sebastian
---
Index: linux-stable/include/linux/rwsem_rt.h
===================================================================
--- linux-stable.orig/include/linux/rwsem_rt.h
+++ linux-stable/include/linux/rwsem_rt.h
@@ -33,15 +33,22 @@ struct rw_semaphore {
 #define DECLARE_RWSEM(lockname) \
 	struct rw_semaphore lockname = __RWSEM_INITIALIZER(lockname)
 
-extern void  __rt_rwsem_init(struct rw_semaphore *rwsem, char *name,
+extern void  __rt_rwsem_init(struct rw_semaphore *rwsem, const char *name,
 				     struct lock_class_key *key);
 
+#define __rt_init_rwsem(sem, name, key)			\
+	do {						\
+		rt_mutex_init(&(sem)->lock);		\
+		__rt_rwsem_init((sem), (name), (key));\
+	} while (0)
+
+#define __init_rwsem(sem, name, key) __rt_init_rwsem(sem, name, key)
+
 # define rt_init_rwsem(sem)				\
 do {							\
 	static struct lock_class_key __key;		\
 							\
-	rt_mutex_init(&(sem)->lock);			\
-	__rt_rwsem_init((sem), #sem, &__key);		\
+	__rt_init_rwsem((sem), #sem, &__key);		\
 } while (0)
 
 extern void  rt_down_write(struct rw_semaphore *rwsem);
Index: linux-stable/kernel/rt.c
===================================================================
--- linux-stable.orig/kernel/rt.c
+++ linux-stable/kernel/rt.c
@@ -413,7 +413,7 @@ void  rt_down_read_nested(struct rw_sema
 }
 EXPORT_SYMBOL(rt_down_read_nested);
 
-void  __rt_rwsem_init(struct rw_semaphore *rwsem, char *name,
+void  __rt_rwsem_init(struct rw_semaphore *rwsem, const char *name,
 			      struct lock_class_key *key)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
Index: linux-stable/kernel/softirq.c
===================================================================
--- linux-stable.orig/kernel/softirq.c
+++ linux-stable/kernel/softirq.c
@@ -192,6 +192,11 @@ static void handle_softirq(unsigned int 
 }
 
 #ifndef CONFIG_PREEMPT_RT_FULL
+static inline int ksoftirqd_softirq_pending(void)
+{
+	return local_softirq_pending();
+}
+
 static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
 {
 	unsigned int vec_nr;
@@ -440,11 +445,6 @@ static inline void _local_bh_enable_nort
 static void ksoftirqd_set_sched_params(unsigned int cpu) { }
 static void ksoftirqd_clr_sched_params(unsigned int cpu, bool online) { }
 
-static inline int ksoftirqd_softirq_pending(void)
-{
-	return local_softirq_pending();
-}
-
 #else /* !PREEMPT_RT_FULL */
 
 /*
Index: linux-stable/lib/Makefile
===================================================================
--- linux-stable.orig/lib/Makefile
+++ linux-stable/lib/Makefile
@@ -42,8 +42,8 @@ obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock
 ifneq ($(CONFIG_PREEMPT_RT_FULL),y)
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
-lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 endif
+lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt1
+-rt2
Index: linux-stable/mm/slub.c
===================================================================
--- linux-stable.orig/mm/slub.c
+++ linux-stable/mm/slub.c
@@ -1346,8 +1346,10 @@ static void setup_object(struct kmem_cac
 				void *object)
 {
 	setup_object_debug(s, page, object);
+#ifndef CONFIG_PREEMPT_RT_FULL
 	if (unlikely(s->ctor))
 		s->ctor(object);
+#endif
 }
 
 static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
@@ -2437,6 +2439,10 @@ redo:
 
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->object_size);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (unlikely(s->ctor) && object)
+		s->ctor(object);
+#endif
 
 	slab_post_alloc_hook(s, gfpflags, object);
 
Index: linux-stable/lib/percpu-rwsem.c
===================================================================
--- linux-stable.orig/lib/percpu-rwsem.c
+++ linux-stable/lib/percpu-rwsem.c
@@ -84,8 +84,12 @@ void percpu_down_read(struct percpu_rw_s
 
 	down_read(&brw->rw_sem);
 	atomic_inc(&brw->slow_read_ctr);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	up_read(&brw->rw_sem);
+#else
 	/* avoid up_read()->rwsem_release() */
 	__up_read(&brw->rw_sem);
+#endif
 }
 
 void percpu_up_read(struct percpu_rw_semaphore *brw)
Index: linux-stable/fs/fscache/page.c
===================================================================
--- linux-stable.orig/fs/fscache/page.c
+++ linux-stable/fs/fscache/page.c
@@ -796,11 +796,13 @@ void fscache_invalidate_writes(struct fs
 
 	_enter("");
 
-	while (spin_lock(&cookie->stores_lock),
-	       n = radix_tree_gang_lookup_tag(&cookie->stores, results, 0,
-					      ARRAY_SIZE(results),
-					      FSCACHE_COOKIE_PENDING_TAG),
-	       n > 0) {
+	do  {
+		spin_lock(&cookie->stores_lock);
+		n = radix_tree_gang_lookup_tag(&cookie->stores, results, 0,
+				ARRAY_SIZE(results),
+				FSCACHE_COOKIE_PENDING_TAG);
+	       if (n == 0)
+		       break;
 		for (i = n - 1; i >= 0; i--) {
 			page = results[i];
 			radix_tree_delete(&cookie->stores, page->index);
@@ -810,7 +812,7 @@ void fscache_invalidate_writes(struct fs
 
 		for (i = n - 1; i >= 0; i--)
 			page_cache_release(results[i]);
-	}
+	} while (1);
 
 	spin_unlock(&cookie->stores_lock);
 	_leave("");
Index: linux-stable/drivers/gpu/drm/i915/i915_gem.c
===================================================================
--- linux-stable.orig/drivers/gpu/drm/i915/i915_gem.c
+++ linux-stable/drivers/gpu/drm/i915/i915_gem.c
@@ -91,7 +91,6 @@ i915_gem_wait_for_error(struct drm_devic
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct completion *x = &dev_priv->error_completion;
-	unsigned long flags;
 	int ret;
 
 	if (!atomic_read(&dev_priv->mm.wedged))
@@ -116,9 +115,7 @@ i915_gem_wait_for_error(struct drm_devic
 		 * end up waiting upon a subsequent completion event that
 		 * will never happen.
 		 */
-		spin_lock_irqsave(&x->wait.lock, flags);
-		x->done++;
-		spin_unlock_irqrestore(&x->wait.lock, flags);
+		complete(x);
 	}
 	return 0;
 }
@@ -946,12 +943,9 @@ i915_gem_check_wedge(struct drm_i915_pri
 	if (atomic_read(&dev_priv->mm.wedged)) {
 		struct completion *x = &dev_priv->error_completion;
 		bool recovery_complete;
-		unsigned long flags;
 
 		/* Give the error handler a chance to run. */
-		spin_lock_irqsave(&x->wait.lock, flags);
-		recovery_complete = x->done > 0;
-		spin_unlock_irqrestore(&x->wait.lock, flags);
+		recovery_complete = completion_done(x);
 
 		/* Non-interruptible callers can't handle -EAGAIN, hence return
 		 * -EIO unconditionally for these. */
@@ -4366,7 +4360,7 @@ static bool mutex_is_locked_by(struct mu
 	if (!mutex_is_locked(mutex))
 		return false;
 
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_MUTEXES)
+#if (defined(CONFIG_SMP) || defined(CONFIG_DEBUG_MUTEXES)) && !defined(CONFIG_PREEMPT_RT_BASE)
 	return mutex->owner == task;
 #else
 	/* Since UP may be pre-empted, we cannot assume that we own the lock */

-- 
