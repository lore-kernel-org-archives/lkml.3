Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaFFNWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:22:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:42642 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaFFNWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:22:51 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <iamjoonsoo.kim@lge.com>, <rientjes@google.com>,
        <penberg@kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -mm v2 3/8] memcg: mark caches that belong to offline memcgs as dead
Date: Fri, 6 Jun 2014 17:22:40 +0400
Message-ID: <9e6537847c22a5050f84bd2bf5633f7c022fb801.1402060096.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1402060096.git.vdavydov@parallels.com>
References: <cover.1402060096.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used by the next patches.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
 include/linux/slab.h |    2 ++
 mm/memcontrol.c      |    1 +
 mm/slab.h            |   10 ++++++++++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index d9716fdc8211..d99d5212b815 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -527,6 +527,7 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
  * @list: list_head for the list of all caches in this memcg
  * @root_cache: pointer to the global, root cache, this cache was derived from
  * @refcnt: reference counter
+ * @dead: set to true when owner memcg is turned offline
  * @unregister_work: worker to destroy the cache
  */
 struct memcg_cache_params {
@@ -541,6 +542,7 @@ struct memcg_cache_params {
 			struct list_head list;
 			struct kmem_cache *root_cache;
 			atomic_long_t refcnt;
+			bool dead;
 			struct work_struct unregister_work;
 		};
 	};
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 886b5b414958..ed42fd1105a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3294,6 +3294,7 @@ static void memcg_unregister_all_caches(struct mem_cgroup *memcg)
 	mutex_lock(&memcg_slab_mutex);
 	list_for_each_entry_safe(params, tmp, &memcg->memcg_slab_caches, list) {
 		cachep = memcg_params_to_cache(params);
+		cachep->memcg_params->dead = true;
 		kmem_cache_shrink(cachep);
 		if (atomic_long_dec_and_test(&cachep->memcg_params->refcnt))
 			memcg_unregister_cache(cachep);
diff --git a/mm/slab.h b/mm/slab.h
index 961a3fb1f5a2..9515cc520bf8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -121,6 +121,11 @@ static inline bool is_root_cache(struct kmem_cache *s)
 	return !s->memcg_params || s->memcg_params->is_root_cache;
 }
 
+static inline bool memcg_cache_dead(struct kmem_cache *s)
+{
+	return !is_root_cache(s) && s->memcg_params->dead;
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 					struct kmem_cache *p)
 {
@@ -203,6 +208,11 @@ static inline bool is_root_cache(struct kmem_cache *s)
 	return true;
 }
 
+static inline bool memcg_cache_dead(struct kmem_cache *s)
+{
+	return false;
+}
+
 static inline bool slab_equal_or_root(struct kmem_cache *s,
 				      struct kmem_cache *p)
 {
-- 
1.7.10.4

