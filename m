Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBCP4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:56:19 -0500
Received: from relay.parallels.com ([195.214.232.42]:35572 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaBCPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:54:46 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <mhocko@suse.cz>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH v2 2/7] memcg, slab: cleanup memcg cache name creation
Date: Mon, 3 Feb 2014 19:54:37 +0400
Message-ID: <ec86147b3dfd5bf7da5b34e12b7a4e4881f49690.1391441746.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1391441746.git.vdavydov@parallels.com>
References: <cover.1391441746.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way memcg_create_kmem_cache() creates the name for a memcg cache
looks rather strange: it first formats the name in the static buffer
tmp_name protected by a mutex, then passes the pointer to the buffer to
kmem_cache_create_memcg(), which finally duplicates it to the cache
name.

Let's clean this up by moving memcg cache name creation to a separate
function to be called by kmem_cache_create_memcg(), and estimating the
length of the name string before copying anything to it so that we won't
need a temporary buffer.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/memcontrol.h |    9 +++++
 mm/memcontrol.c            |   94 ++++++++++++++++++++++----------------------
 mm/slab_common.c           |    5 ++-
 3 files changed, 59 insertions(+), 49 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index abd0113b6620..84e4801fc36c 100644
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
index 53385cd4e6f0..9e321650efb2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3193,6 +3193,37 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 	return 0;
 }
 
+static int memcg_print_cache_name(char *buf, size_t size,
+		struct mem_cgroup *memcg, struct kmem_cache *root_cache)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = snprintf(buf, size, "%s(%d:%s)", root_cache->name,
+		       memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
+	rcu_read_unlock();
+	return ret;
+}
+
+char *memcg_create_cache_name(struct mem_cgroup *memcg,
+			      struct kmem_cache *root_cache)
+{
+	int len;
+	char *name;
+
+	/*
+	 * We cannot use kasprintf() here, because cgroup_name() must be called
+	 * under RCU protection.
+	 */
+	len = memcg_print_cache_name(NULL, 0, memcg, root_cache);
+
+	name = kmalloc(len + 1, GFP_KERNEL);
+	if (name)
+		memcg_print_cache_name(name, len + 1, memcg, root_cache);
+
+	return name;
+}
+
 int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
 			     struct kmem_cache *root_cache)
 {
@@ -3397,44 +3428,6 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 	schedule_work(&cachep->memcg_params->destroy);
 }
 
-static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
-						  struct kmem_cache *s)
-{
-	struct kmem_cache *new = NULL;
-	static char *tmp_name = NULL;
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
-	if (!tmp_name) {
-		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (!tmp_name)
-			goto out;
-	}
-
-	rcu_read_lock();
-	snprintf(tmp_name, PATH_MAX, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
-	rcu_read_unlock();
-
-	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
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
@@ -3481,12 +3474,6 @@ void kmem_cache_destroy_memcg_children(struct kmem_cache *s)
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
@@ -3504,13 +3491,24 @@ static void mem_cgroup_destroy_all_caches(struct mem_cgroup *memcg)
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
+	struct kmem_cache *s = cw->cachep;
+	struct kmem_cache *new;
 
-	cw = container_of(w, struct create_work, work);
-	memcg_create_kmem_cache(cw->memcg, cw->cachep);
-	css_put(&cw->memcg->css);
+	new = kmem_cache_create_memcg(memcg, s->name, s->object_size, s->align,
+				      (s->flags & ~SLAB_PANIC), s->ctor, s);
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

