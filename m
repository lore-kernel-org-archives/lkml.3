Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIUPSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 11:18:54 -0400
Received: from mx2.parallels.com ([199.115.105.18]:56305 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaIUPPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 11:15:37 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>,
        Glauber Costa <glommer@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>
Subject: [PATCH -mm 07/14] memcg: update memcg_caches array entries on the slab side
Date: Sun, 21 Sep 2014 19:14:39 +0400
Message-ID: <24d740960c2eee761432bf10c63312c049aad59b.1411301245.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1411301245.git.vdavydov@parallels.com>
References: <cover.1411301245.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [81.5.99.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that all manipulations on memcg_caches array must happen where
it is defined, i.e. on the slab side. The array allocation and
relocation paths as well as elements access follow this pattern (see
e.g. cache_from_memcg_idx, memcg_update_all_caches), but elements update
doesn't. We still want to setup new array elements in memcontrol.c (see
memcg_{un,}register_cache), though it may change in the future. Anyway,
let's introduce a simple function for updating the array entries,
cache_install_at_memcg_idx, to match cache_from_memcg_idx.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/memcontrol.c |   15 ++++-----------
 mm/slab.h       |   21 ++++++++++++++++++++-
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 412fa220b9aa..9ae2627bd3b1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3018,15 +3018,8 @@ static void memcg_register_cache(struct mem_cgroup *memcg,
 	css_get(&memcg->css);
 	list_add(&cachep->memcg_params->list, &memcg->memcg_slab_caches);
 
-	/*
-	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
-	 * barrier here to ensure nobody will see the kmem_cache partially
-	 * initialized.
-	 */
-	smp_wmb();
-
-	BUG_ON(root_cache->memcg_params->memcg_caches[id]);
-	root_cache->memcg_params->memcg_caches[id] = cachep;
+	BUG_ON(cache_from_memcg_idx(root_cache, id) != NULL);
+	cache_install_at_memcg_idx(root_cache, id, cachep);
 }
 
 static void memcg_unregister_cache(struct kmem_cache *cachep)
@@ -3043,8 +3036,8 @@ static void memcg_unregister_cache(struct kmem_cache *cachep)
 	memcg = cachep->memcg_params->memcg;
 	id = memcg_cache_id(memcg);
 
-	BUG_ON(root_cache->memcg_params->memcg_caches[id] != cachep);
-	root_cache->memcg_params->memcg_caches[id] = NULL;
+	BUG_ON(cache_from_memcg_idx(root_cache, id) != cachep);
+	cache_install_at_memcg_idx(root_cache, id, NULL);
 
 	list_del(&cachep->memcg_params->list);
 
diff --git a/mm/slab.h b/mm/slab.h
index 52b570932ba0..da798cfe5efa 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -201,12 +201,31 @@ cache_from_memcg_idx(struct kmem_cache *s, int idx)
 	/*
 	 * Make sure we will access the up-to-date value. The code updating
 	 * memcg_caches issues a write barrier to match this (see
-	 * memcg_register_cache()).
+	 * cache_install_at_memcg_idx()).
 	 */
 	smp_read_barrier_depends();
 	return cachep;
 }
 
+/*
+ * Update the entry at index @memcg_idx in the memcg_caches array of
+ * @root_cache. The caller must synchronize against concurrent updates to the
+ * same entry as well as guarantee that the memcg_caches array won't be
+ * relocated under our noses.
+ */
+static inline void cache_install_at_memcg_idx(struct kmem_cache *root_cache,
+				int memcg_idx, struct kmem_cache *memcg_cache)
+{
+	/*
+	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
+	 * barrier here to ensure nobody will see the kmem_cache partially
+	 * initialized.
+	 */
+	smp_wmb();
+
+	root_cache->memcg_params->memcg_caches[memcg_idx] = memcg_cache;
+}
+
 static inline struct kmem_cache *memcg_root_cache(struct kmem_cache *s)
 {
 	if (is_root_cache(s))
-- 
1.7.10.4

