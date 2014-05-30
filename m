Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbaE3Nva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:51:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:41522 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaE3NvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:51:19 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <cl@linux.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH -mm 5/8] slab: remove kmem_cache_shrink retval
Date: Fri, 30 May 2014 17:51:08 +0400
Message-ID: <d2bbd28ae0f0c1807f9fe72d0443eccb739b8aa6.1401457502.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1401457502.git.vdavydov@parallels.com>
References: <cover.1401457502.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, nobody uses it. Second, it differs across the implementations:
for SLUB it always returns 0, for SLAB it returns 0 if the cache appears
to be empty. So let's get rid of it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/slab.h |    2 +-
 mm/slab.c            |   11 ++++++++---
 mm/slab.h            |    2 +-
 mm/slab_common.c     |    8 ++------
 mm/slob.c            |    3 +--
 mm/slub.c            |    3 +--
 6 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index d99d5212b815..d88ae36e2a15 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -121,7 +121,7 @@ struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *,
 					   const char *);
 #endif
 void kmem_cache_destroy(struct kmem_cache *);
-int kmem_cache_shrink(struct kmem_cache *);
+void kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
 
 /*
diff --git a/mm/slab.c b/mm/slab.c
index 9ca3b87edabc..cecc01bba389 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2478,7 +2478,7 @@ out:
 	return nr_freed;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *cachep)
+static int __cache_shrink(struct kmem_cache *cachep)
 {
 	int ret = 0, i = 0;
 	struct kmem_cache_node *n;
@@ -2499,12 +2499,17 @@ int __kmem_cache_shrink(struct kmem_cache *cachep)
 	return (ret ? 1 : 0);
 }
 
+void __kmem_cache_shrink(struct kmem_cache *cachep)
+{
+	__cache_shrink(cachep);
+}
+
 int __kmem_cache_shutdown(struct kmem_cache *cachep)
 {
-	int i;
+	int i, rc;
 	struct kmem_cache_node *n;
-	int rc = __kmem_cache_shrink(cachep);
 
+	rc = __cache_shrink(cachep);
 	if (rc)
 		return rc;
 
diff --git a/mm/slab.h b/mm/slab.h
index 9515cc520bf8..c03d707033b7 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -91,7 +91,7 @@ __kmem_cache_alias(const char *name, size_t size, size_t align,
 #define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
 
 int __kmem_cache_shutdown(struct kmem_cache *);
-int __kmem_cache_shrink(struct kmem_cache *);
+void __kmem_cache_shrink(struct kmem_cache *);
 void slab_kmem_cache_release(struct kmem_cache *);
 
 struct seq_file;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 735e01a0db6f..015fa1d854a9 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -380,18 +380,14 @@ EXPORT_SYMBOL(kmem_cache_destroy);
  * @cachep: The cache to shrink.
  *
  * Releases as many slabs as possible for a cache.
- * To help debugging, a zero exit status indicates all slabs were released.
  */
-int kmem_cache_shrink(struct kmem_cache *cachep)
+void kmem_cache_shrink(struct kmem_cache *cachep)
 {
-	int ret;
-
 	get_online_cpus();
 	get_online_mems();
-	ret = __kmem_cache_shrink(cachep);
+	__kmem_cache_shrink(cachep);
 	put_online_mems();
 	put_online_cpus();
-	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
diff --git a/mm/slob.c b/mm/slob.c
index 21980e0f39a8..bb6471f26640 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -620,9 +620,8 @@ int __kmem_cache_shutdown(struct kmem_cache *c)
 	return 0;
 }
 
-int __kmem_cache_shrink(struct kmem_cache *d)
+void __kmem_cache_shrink(struct kmem_cache *d)
 {
-	return 0;
 }
 
 struct kmem_cache kmem_cache_boot = {
diff --git a/mm/slub.c b/mm/slub.c
index d9976ea93710..2fc84853bffb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3396,7 +3396,7 @@ EXPORT_SYMBOL(kfree);
  * being allocated from last increasing the chance that the last objects
  * are freed in them.
  */
-int __kmem_cache_shrink(struct kmem_cache *s)
+void __kmem_cache_shrink(struct kmem_cache *s)
 {
 	int node;
 	int i;
@@ -3457,7 +3457,6 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 	}
 
 	kfree(slabs_by_inuse);
-	return 0;
 }
 
 static int slab_mem_going_offline_callback(void *arg)
-- 
1.7.10.4

