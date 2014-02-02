Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaBBQel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:34:41 -0500
Received: from relay.parallels.com ([195.214.232.42]:46414 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaBBQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:34:01 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH 7/8] memcg, slab: unregister cache from memcg before starting to destroy it
Date: Sun, 2 Feb 2014 20:33:52 +0400
Message-ID: <544f00fe8624c89f510a2b3d585f1a8d80606f7b.1391356789.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391356789.git.vdavydov@parallels.com>
References: <cover.1391356789.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, memcg_unregister_cache(), which deletes the cache being
destroyed from the memcg_slab_caches list, is called after
__kmem_cache_shutdown() (see kmem_cache_destroy()), which starts to
destroy the cache. As a result, one can access a partially destroyed
cache while traversing a memcg_slab_caches list, which can have deadly
consequences (for instance, cache_show() called for each cache on a
memcg_slab_caches list from mem_cgroup_slabinfo_read() will dereference
pointers to already freed data).

To fix this, let's move memcg_unregister_cache() before the cache
destruction process beginning, issuing memcg_register_cache() on
failure.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c  |   12 ++++++------
 mm/slab_common.c |    3 ++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d69c427e106b..69e8726aae4f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3224,6 +3224,7 @@ int memcg_alloc_cache_params(struct kmem_cache *s,
 		s->memcg_params->root_cache = root_cache;
 		INIT_WORK(&s->memcg_params->destroy,
 				kmem_cache_destroy_work_func);
+		css_get(&memcg->css);
 	} else
 		s->memcg_params->is_root_cache = true;
 
@@ -3232,6 +3233,10 @@ int memcg_alloc_cache_params(struct kmem_cache *s,
 
 void memcg_free_cache_params(struct kmem_cache *s)
 {
+	if (!s->memcg_params)
+		return;
+	if (!s->memcg_params->is_root_cache)
+		css_put(&s->memcg_params->memcg->css);
 	kfree(s->memcg_params);
 }
 
@@ -3254,9 +3259,6 @@ void memcg_register_cache(struct kmem_cache *s)
 	memcg = s->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
 
-	css_get(&memcg->css);
-
-
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
 	 * barrier here to ensure nobody will see the kmem_cache partially
@@ -3305,10 +3307,8 @@ void memcg_unregister_cache(struct kmem_cache *s)
 	 * after removing it from the memcg_slab_caches list, otherwise we can
 	 * fail to convert memcg_params_to_cache() while traversing the list.
 	 */
-	VM_BUG_ON(!root->memcg_params->memcg_caches[id]);
+	VM_BUG_ON(root->memcg_params->memcg_caches[id] != s);
 	root->memcg_params->memcg_caches[id] = NULL;
-
-	css_put(&memcg->css);
 }
 
 /*
diff --git a/mm/slab_common.c b/mm/slab_common.c
index ade86bcddab9..ea1075e65271 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -312,9 +312,9 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
+		memcg_unregister_cache(s);
 
 		if (!__kmem_cache_shutdown(s)) {
-			memcg_unregister_cache(s);
 			mutex_unlock(&slab_mutex);
 			if (s->flags & SLAB_DESTROY_BY_RCU)
 				rcu_barrier();
@@ -324,6 +324,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 			kmem_cache_free(kmem_cache, s);
 		} else {
 			list_add(&s->list, &slab_caches);
+			memcg_register_cache(s);
 			mutex_unlock(&slab_mutex);
 			printk(KERN_ERR "kmem_cache_destroy %s: Slab cache still has objects\n",
 				s->name);
-- 
1.7.10.4

