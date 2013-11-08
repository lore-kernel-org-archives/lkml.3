Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3KHWPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:15:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:33100 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3KHWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:15:37 -0500
Date: Fri, 8 Nov 2013 23:15:35 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.10.18-rt14
Message-ID: <20131108221535.GA13367@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.10.18-rt14 patch set.

Changes since v3.10.18-rt13
- a SLUB fix. The delayed free might use wrong kmem_cache structure.
- update to Yang Shi's memcontrol sleeping while atomic fix. Thanks you
  Yang Shi.
- dropping the wbinvd in i915. The do_wbinvd module parameter is gone,
  the fix from mainline has been backported. This has been compile
  tested, some feedback would be nice.

Known issues:

      - SLAB support not working

      - The cpsw network driver shows some issues.

      - bcache is disabled.

      - an ancient race (since we got sleeping spinlocks) where the
        TASK_TRACED state is temporary replaced while waiting on a rw
        lock and the task can't be traced.

The delta patch against v3.10.18-rt14 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/incr/patch-3.10.18-rt13-rt14.patch.xz

The RT patch against 3.10.18 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.18-rt14.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patches-3.10.18-rt14.tar.xz

Sebastian

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d62b80d..080b1b2 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -35,7 +35,6 @@
 #include <linux/swap.h>
 #include <linux/pci.h>
 #include <linux/dma-buf.h>
-#include <linux/module.h>
 
 static void i915_gem_object_flush_gtt_write_domain(struct drm_i915_gem_object *obj);
 static void i915_gem_object_flush_cpu_write_domain(struct drm_i915_gem_object *obj);
@@ -2714,47 +2713,17 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
-static bool do_wbinvd = true;
-module_param(do_wbinvd, bool, 0644);
-MODULE_PARM_DESC(do_wbinvd, "Do expensive synchronization. Say no after you pin each GPU process to the same CPU in order to lower the latency.");
-
-static void i915_gem_write_fence__ipi(void *data)
-{
-	wbinvd();
-}
-
 static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 					 struct drm_i915_fence_reg *fence,
 					 bool enable)
 {
-	struct drm_device *dev = obj->base.dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	int fence_reg = fence_number(dev_priv, fence);
-
-	/* In order to fully serialize access to the fenced region and
-	 * the update to the fence register we need to take extreme
-	 * measures on SNB+. In theory, the write to the fence register
-	 * flushes all memory transactions before, and coupled with the
-	 * mb() placed around the register write we serialise all memory
-	 * operations with respect to the changes in the tiler. Yet, on
-	 * SNB+ we need to take a step further and emit an explicit wbinvd()
-	 * on each processor in order to manually flush all memory
-	 * transactions before updating the fence register.
-	 */
-	if (HAS_LLC(obj->base.dev)) {
-		if (do_wbinvd) {
-#ifdef CONFIG_PREEMPT_RT_FULL
-			pr_err_once("WARNING! The i915 invalidates all caches which increases the latency.");
-			pr_err_once("As a workaround use 'i915.do_wbinvd=no' and PIN each process doing ");
-			pr_err_once("any kind of GPU activity to the same CPU to avoid problems.");
-#endif
-			on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
-		}
-	}
-	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
+	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
+	int reg = fence_number(dev_priv, fence);
+
+	i915_gem_write_fence(obj->base.dev, reg, enable ? obj : NULL);
 
 	if (enable) {
-		obj->fence_reg = fence_reg;
+		obj->fence_reg = reg;
 		fence->obj = obj;
 		list_move_tail(&fence->lru_list, &dev_priv->mm.fence_list);
 	} else {
diff --git a/localversion-rt b/localversion-rt
index 9f7d0bd..08b3e75 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt13
+-rt14
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f113cb7..2163f2f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2436,10 +2436,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 {
-	int cpu;
+	int cpu, curcpu;
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
+	curcpu = get_cpu_light();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2449,9 +2450,14 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 			continue;
 		if (!mem_cgroup_same_or_subtree(root_memcg, memcg))
 			continue;
-		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
-			schedule_work_on(cpu, &stock->work);
+		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
+			if (cpu == curcpu)
+				drain_local_stock(&stock->work);
+			else
+				schedule_work_on(cpu, &stock->work);
+		}
 	}
+	put_cpu_light();
 
 	if (!sync)
 		goto out;
diff --git a/mm/slub.c b/mm/slub.c
index 1378cd1..31c6f9f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1428,13 +1428,13 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	__free_memcg_kmem_pages(page, order);
 }
 
-static void free_delayed(struct kmem_cache *s, struct list_head *h)
+static void free_delayed(struct list_head *h)
 {
 	while(!list_empty(h)) {
 		struct page *page = list_first_entry(h, struct page, lru);
 
 		list_del(&page->lru);
-		__free_slab(s, page);
+		__free_slab(page->slab_cache, page);
 	}
 }
 
@@ -2007,7 +2007,7 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 				list_splice_init(&f->list, &tofree);
 				raw_spin_unlock(&f->lock);
 				local_irq_restore(flags);
-				free_delayed(s, &tofree);
+				free_delayed(&tofree);
 				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
@@ -2083,7 +2083,7 @@ static void flush_all(struct kmem_cache *s)
 		raw_spin_lock_irq(&f->lock);
 		list_splice_init(&f->list, &tofree);
 		raw_spin_unlock_irq(&f->lock);
-		free_delayed(s, &tofree);
+		free_delayed(&tofree);
 	}
 }
 
@@ -2331,7 +2331,7 @@ static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	list_splice_init(&f->list, &tofree);
 	raw_spin_unlock(&f->lock);
 	local_irq_restore(flags);
-	free_delayed(s, &tofree);
+	free_delayed(&tofree);
 	return freelist;
 
 new_slab:
