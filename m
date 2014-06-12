Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaFLUiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:38:51 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51472 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaFLUis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:38:48 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <iamjoonsoo.kim@lge.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -mm v3 5/8] slub: make slab_free non-preemptable
Date: Fri, 13 Jun 2014 00:38:19 +0400
Message-ID: <0c66165d4f46fa80cd31df147e7bbcaa5fea784c.1402602126.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1402602126.git.vdavydov@parallels.com>
References: <cover.1402602126.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since per memcg cache destruction is scheduled when the last slab is
freed, to avoid use-after-free in kmem_cache_free we should either
rearrange code in kmem_cache_free so that it won't dereference the cache
ptr after freeing the object, or wait for all kmem_cache_free's to
complete before proceeding to cache destruction.

The former approach isn't a good option from the future development
point of view, because every modifications to kmem_cache_free must be
done with great care then. Hence we should provide a method to wait for
all currently executing kmem_cache_free's to finish.

This patch makes SLUB's implementation of kmem_cache_free
non-preemptable. As a result, synchronize_sched() will work as a barrier
against kmem_cache_free's in flight, so that issuing it before cache
destruction will protect us against the use-after-free.

This won't affect performance of kmem_cache_free, because we already
disable preemption there, and this patch only moves preempt_enable to
the end of the function. Neither should it affect the system latency,
because kmem_cache_free is extremely short, even in its slow path.

SLAB's version of kmem_cache_free already proceeds with irqs disabled,
so we only add a comment explaining why it's necessary for kmemcg there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 mm/slab.c |    6 ++++++
 mm/slub.c |   12 ++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 9ca3b87edabc..b3af82419251 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3450,6 +3450,12 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp,
 {
 	struct array_cache *ac = cpu_cache_get(cachep);
 
+	/*
+	 * Since we free objects with irqs and therefore preemption disabled,
+	 * we can use synchronize_sched() to wait for all currently executing
+	 * kfree's to finish. This is necessary to avoid use-after-free on
+	 * per memcg cache destruction.
+	 */
 	check_irq_off();
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
diff --git a/mm/slub.c b/mm/slub.c
index 35741592be8c..52565a9426ef 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2673,18 +2673,17 @@ static __always_inline void slab_free(struct kmem_cache *s,
 
 	slab_free_hook(s, x);
 
-redo:
 	/*
-	 * Determine the currently cpus per cpu slab.
-	 * The cpu may change afterward. However that does not matter since
-	 * data is retrieved via this pointer. If we are on the same cpu
-	 * during the cmpxchg then the free will succedd.
+	 * We could make this function fully preemptable, but then we wouldn't
+	 * have a method to wait for all currently executing kfree's to finish,
+	 * which is necessary to avoid use-after-free on per memcg cache
+	 * destruction.
 	 */
 	preempt_disable();
+redo:
 	c = this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
-	preempt_enable();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
@@ -2701,6 +2700,7 @@ redo:
 	} else
 		__slab_free(s, page, x, addr);
 
+	preempt_enable();
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
-- 
1.7.10.4

