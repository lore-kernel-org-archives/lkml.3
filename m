Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3LRNRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:17:55 -0500
Received: from relay.parallels.com ([195.214.232.42]:54275 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LRNRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:17:06 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@gmail.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/6] memcg, slab: kmem_cache_create_memcg(): free memcg params on error
Date: Wed, 18 Dec 2013 17:16:53 +0400
Message-ID: <9420ad797a2cfa14c23ad1ba6db615a2a51ffee0.1387372122.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plus, rename memcg_register_cache() to memcg_init_cache_params(),
because it actually does not register the cache anywhere, but simply
initialize kmem_cache::memcg_params.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h |   13 +++++++++----
 mm/memcontrol.c            |    9 +++++++--
 mm/slab_common.c           |    3 ++-
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b3e7a66..b357ae3 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -497,8 +497,9 @@ void __memcg_kmem_commit_charge(struct page *page,
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-			 struct kmem_cache *root_cache);
+int memcg_init_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
+			    struct kmem_cache *root_cache);
+void memcg_free_cache_params(struct kmem_cache *s);
 void memcg_release_cache(struct kmem_cache *cachep);
 void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep);
 
@@ -641,12 +642,16 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 }
 
 static inline int
-memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-		     struct kmem_cache *root_cache)
+memcg_init_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
+			struct kmem_cache *root_cache)
 {
 	return 0;
 }
 
+static inline void memcg_free_cache_params(struct kmem_cache *s);
+{
+}
+
 static inline void memcg_release_cache(struct kmem_cache *cachep)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bf5e894..e6ad6ff 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3195,8 +3195,8 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 	return 0;
 }
 
-int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
-			 struct kmem_cache *root_cache)
+int memcg_init_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
+			    struct kmem_cache *root_cache)
 {
 	size_t size;
 
@@ -3224,6 +3224,11 @@ int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
 	return 0;
 }
 
+void memcg_free_cache_params(struct kmem_cache *s)
+{
+	kfree(s->memcg_params);
+}
+
 void memcg_release_cache(struct kmem_cache *s)
 {
 	struct kmem_cache *root;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5d6f743..62712fe 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -208,7 +208,7 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 		goto out_free_cache;
 	}
 
-	err = memcg_register_cache(memcg, s, parent_cache);
+	err = memcg_init_cache_params(memcg, s, parent_cache);
 	if (err)
 		goto out_free_cache;
 
@@ -238,6 +238,7 @@ out_unlock:
 	return s;
 
 out_free_cache:
+	memcg_free_cache_params(s);
 	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
 	goto out_unlock;
-- 
1.7.10.4

