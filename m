Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3LRNRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:17:09 -0500
Received: from relay.parallels.com ([195.214.232.42]:54263 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab3LRNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:17:05 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@gmail.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/6] slab: cleanup kmem_cache_create_memcg()
Date: Wed, 18 Dec 2013 17:16:52 +0400
Message-ID: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/slab_common.c |   66 +++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 0b7bb39..5d6f743 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -176,8 +176,9 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 
-	if (!kmem_cache_sanity_check(memcg, name, size) == 0)
-		goto out_locked;
+	err = kmem_cache_sanity_check(memcg, name, size);
+	if (err)
+		goto out_unlock;
 
 	/*
 	 * Some allocators will constraint the set of valid flags to a subset
@@ -189,45 +190,41 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 
 	s = __kmem_cache_alias(memcg, name, size, align, flags, ctor);
 	if (s)
-		goto out_locked;
+		goto out_unlock;
 
 	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
-	if (s) {
-		s->object_size = s->size = size;
-		s->align = calculate_alignment(flags, align, size);
-		s->ctor = ctor;
-
-		if (memcg_register_cache(memcg, s, parent_cache)) {
-			kmem_cache_free(kmem_cache, s);
-			err = -ENOMEM;
-			goto out_locked;
-		}
+	if (!s) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
 
-		s->name = kstrdup(name, GFP_KERNEL);
-		if (!s->name) {
-			kmem_cache_free(kmem_cache, s);
-			err = -ENOMEM;
-			goto out_locked;
-		}
+	s->object_size = s->size = size;
+	s->align = calculate_alignment(flags, align, size);
+	s->ctor = ctor;
 
-		err = __kmem_cache_create(s, flags);
-		if (!err) {
-			s->refcount = 1;
-			list_add(&s->list, &slab_caches);
-			memcg_cache_list_add(memcg, s);
-		} else {
-			kfree(s->name);
-			kmem_cache_free(kmem_cache, s);
-		}
-	} else
+	s->name = kstrdup(name, GFP_KERNEL);
+	if (!s->name) {
 		err = -ENOMEM;
+		goto out_free_cache;
+	}
+
+	err = memcg_register_cache(memcg, s, parent_cache);
+	if (err)
+		goto out_free_cache;
 
-out_locked:
+	err = __kmem_cache_create(s, flags);
+	if (err)
+		goto out_free_cache;
+
+	s->refcount = 1;
+	list_add(&s->list, &slab_caches);
+	memcg_cache_list_add(memcg, s);
+
+out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
 	if (err) {
-
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
@@ -236,11 +233,14 @@ out_locked:
 				name, err);
 			dump_stack();
 		}
-
 		return NULL;
 	}
-
 	return s;
+
+out_free_cache:
+	kfree(s->name);
+	kmem_cache_free(kmem_cache, s);
+	goto out_unlock;
 }
 
 struct kmem_cache *
-- 
1.7.10.4

