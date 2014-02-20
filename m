Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaBTHWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:22:24 -0500
Received: from relay.parallels.com ([195.214.232.42]:45659 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaBTHWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:22:22 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <mhocko@suse.cz>, <akpm@linux-foundation.org>
CC: <rientjes@google.com>, <penberg@kernel.org>, <cl@linux.com>,
        <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH -mm v3 2/7] memcg, slab: cleanup memcg cache creation
Date: Thu, 20 Feb 2014 11:22:04 +0400
Message-ID: <210fa2501be4cbb7f7caf6ca893301f124c92a67.1392879001.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1392879001.git.vdavydov@parallels.com>
References: <cover.1392879001.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanups the memcg cache creation path as follows:
 - Move memcg cache name creation to a separate function to be called
   from kmem_cache_create_memcg(). This allows us to get rid of the
   mutex protecting the temporary buffer used for the name formatting,
   because the whole cache creation path is protected by the slab_mutex.
 - Get rid of memcg_create_kmem_cache(). This function serves as a proxy
   to kmem_cache_create_memcg(). After separating the cache name
   creation path, it would be reduced to a function call, so let's
   inline it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/memcontrol.h |    9 +++++
 mm/memcontrol.c            |   89 +++++++++++++++++++-------------------------
 mm/slab_common.c           |    5 ++-
 3 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index eccfb4a4b379..4d6b481d11db 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -497,6 +497,9 @@ void __memcg_kmem_commit_charge(struct page *page,
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
+
+char *memcg_create_cache_name(struct mem_cgroup *memcg,
+			      struct kmem_cache *root_cache);
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache);
 void memcg_free_cache_params(struct kmem_cache *s);
@@ -641,6 +644,12 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 	return -1;
 }
 
+static inline char *memcg_create_cache_name(struct mem_cgroup *memcg,
+					    struct kmem_cache *root_cache)
+{
+	return NULL;
+}
+
 static inline int memcg_alloc_cache_params(struct mem_cgroup *memcg,
 		struct kmem_cache *s, struct kmem_cache *root_cache)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53885166dc12..62db588a8ca6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3159,6 +3159,29 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 	return 0;
 }
 
+char *memcg_create_cache_name(struct mem_cgroup *memcg,
+			      struct kmem_cache *root_cache)
+{
+	static char *buf = NULL;
+
+	/*
+	 * We need a mutex here to protect the shared buffer. Since this is
+	 * expected to be called only on cache creation, we can employ the
+	 * slab_mutex for that purpose.
+	 */
+	lockdep_assert_held(&slab_mutex);
+
+	if (!buf) {
+		buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
+		if (!buf)
+			return NULL;
+	}
+
+	cgroup_name(memcg->css.cgroup, buf, NAME_MAX + 1);
+	return kasprintf(GFP_KERNEL, "%s(%d:%s)", root_cache->name,
+			 memcg_cache_id(memcg), buf);
+}
+
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache)
 {
@@ -3363,46 +3386,6 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-						  struct kmem_cache *s)
-{
-	struct kmem_cache *new = NULL;
-	static char *tmp_path = NULL, *tmp_name = NULL;
-	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
-
-	BUG_ON(!memcg_can_account_kmem(memcg));
-
-	mutex_lock(&mutex);
-	/*
-	 * kmem_cache_create_memcg duplicates the given name and
-	 * cgroup_name for this name requires RCU context.
-	 * This static temporary buffer is used to prevent from
-	 * pointless shortliving allocation.
-	 */
-	if (!tmp_path || !tmp_name) {
-		if (!tmp_path)
-			tmp_path = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!tmp_name)
-			tmp_name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-		if (!tmp_path || !tmp_name)
-			goto out;
-	}
-
-	cgroup_name(memcg->css.cgroup, tmp_name, NAME_MAX + 1);
-	snprintf(tmp_path, PATH_MAX, "%s(%d:%s)", s->name,
-		 memcg_cache_id(memcg), tmp_name);
-
-	new = kmem_cache_create_memcg(memcg, tmp_path, s->object_size, s->align,
-				      (s->flags & ~SLAB_PANIC), s->ctor, s);
-	if (new)
-		new->allocflags |= __GFP_KMEMCG;
-	else
-		new = s;
-out:
-	mutex_unlock(&mutex);
-	return new;
-}
-
 void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 {
 	struct kmem_cache *c;
@@ -3449,12 +3432,6 @@ void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
 	mutex_unlock(&activate_kmem_mutex);
 }
 
-struct create_work {
-	struct mem_cgroup *memcg;
-	struct kmem_cache *cachep;
-	struct work_struct work;
-};
-
 static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 {
 	struct kmem_cache *cachep;
@@ -3472,13 +3449,25 @@ static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
 	mutex_unlock(&memcg->slab_caches_mutex);
 }
 
+struct create_work {
+	struct mem_cgroup *memcg;
+	struct kmem_cache *cachep;
+	struct work_struct work;
+};
+
 static void memcg_create_cache_work_func(struct work_struct *w)
 {
-	struct create_work *cw;
+	struct create_work *cw = container_of(w, struct create_work, work);
+	struct mem_cgroup *memcg = cw->memcg;
+	struct kmem_cache *cachep = cw->cachep;
+	struct kmem_cache *new;
 
-	cw = container_of(w, struct create_work, work);
-	memcg_create_kmem_cache(cw->memcg, cw->cachep);
-	css_put(&cw->memcg->css);
+	new = kmem_cache_create_memcg(memcg, cachep->name,
+			cachep->object_size, cachep->align,
+			cachep->flags & ~SLAB_PANIC, cachep->ctor, cachep);
+	if (new)
+		new->allocflags |= __GFP_KMEMCG;
+	css_put(&memcg->css);
 	kfree(cw);
 }
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e77b51eb7347..11857abf7057 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -215,7 +215,10 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 	s->align = calculate_alignment(flags, align, size);
 	s->ctor = ctor;
 
-	s->name = kstrdup(name, GFP_KERNEL);
+	if (memcg)
+		s->name = memcg_create_cache_name(memcg, parent_cache);
+	else
+		s->name = kstrdup(name, GFP_KERNEL);
 	if (!s->name)
 		goto out_free_cache;
 
-- 
1.7.10.4

