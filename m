Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaBDTTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:19:32 -0500
Received: from relay.parallels.com ([195.214.232.42]:49186 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaBDTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:19:29 -0500
Message-ID: <52F13D3C.801@parallels.com>
Date: Tue, 4 Feb 2014 23:19:24 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <akpm@linux-foundation.org>, <rientjes@google.com>, <penberg@kernel.org>,
        <cl@linux.com>, <glommer@gmail.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH v2 3/7] memcg, slab: separate memcg vs root cache creation
 paths
References: <cover.1391441746.git.vdavydov@parallels.com> <81a403327163facea2b4c7b720fdc0ef62dd1dbf.1391441746.git.vdavydov@parallels.com> <20140204160336.GL4890@dhcp22.suse.cz>
In-Reply-To: <20140204160336.GL4890@dhcp22.suse.cz>
Content-Type: multipart/mixed;
	boundary="------------030205050305010109080506"
X-Originating-IP: [10.24.25.228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030205050305010109080506
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 02/04/2014 08:03 PM, Michal Hocko wrote:
> On Mon 03-02-14 19:54:38, Vladimir Davydov wrote:
>> Memcg-awareness turned kmem_cache_create() into a dirty interweaving of
>> memcg-only and except-for-memcg calls. To clean this up, let's create a
>> separate function handling memcg caches creation. Although this will
>> result in the two functions having several hunks of practically the same
>> code, I guess this is the case when readability fully covers the cost of
>> code duplication.
> I don't know. The code is apparently cleaner because calling a function
> with NULL memcg just to go via several if (memcg) branches is ugly as
> hell. But having a duplicated function like this calls for a problem
> later.
>
> Would it be possible to split kmem_cache_create into memcg independant
> part and do the rest in a single memcg branch?

May be, something like the patch attached?

>  
>> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
>> ---
>>  include/linux/memcontrol.h |   14 ++---
>>  include/linux/slab.h       |    9 ++-
>>  mm/memcontrol.c            |   16 ++----
>>  mm/slab_common.c           |  130 ++++++++++++++++++++++++++------------------
>>  4 files changed, 90 insertions(+), 79 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 84e4801fc36c..de79a9617e09 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -500,8 +500,8 @@ int memcg_cache_id(struct mem_cgroup *memcg);
>>  
>>  char *memcg_create_cache_name(struct mem_cgroup *memcg,
>>  			      struct kmem_cache *root_cache);
>> -int memcg_alloc_cache_params(struct mem_cgroup *memcg, struct kmem_cache *s,
>> -			     struct kmem_cache *root_cache);
>> +int memcg_alloc_cache_params(struct kmem_cache *s,
>> +		struct mem_cgroup *memcg, struct kmem_cache *root_cache);
> Why is the parameters ordering changed? It really doesn't help
> review the patch.

Oh, this is because seeing something like

memcg_alloc_cache_params(NULL, s, NULL);

hurts my brain :-) I prefer to have NULLs in the end.

> Also what does `s' stand for and can we use a more
> descriptive name, please?

Yes, we can call it `cachep', but it would be too long :-/

`s' is the common name for a kmem_cache throughout mm/sl[au]b.c so I
guess it fits here. However, this function certainly needs a comment - I
guess I'll do it along with swapping the function parameters in a
separate patch.

Thanks.

--------------030205050305010109080506
Content-Type: text/x-patch;
	name="0001-memcg-slab-separate-memcg-vs-root-cache-creation-pat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-memcg-slab-separate-memcg-vs-root-cache-creation-pat.pa";
	filename*1="tch"

>From 55f0916c794ad25a8bf45566f6d333bea956e0d4 Mon Sep 17 00:00:00 2001
From: Vladimir Davydov <vdavydov@parallels.com>
Date: Mon, 3 Feb 2014 19:18:22 +0400
Subject: [PATCH] memcg, slab: separate memcg vs root cache creation paths

Memcg-awareness turned kmem_cache_create() into a dirty interweaving of
memcg-only and except-for-memcg calls. To clean this up, let's create a
separate function handling memcg caches creation. Although this will
result in the two functions having several hunks of practically the same
code, I guess this is the case when readability fully covers the cost of
code duplication.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/slab.h |    9 ++-
 mm/memcontrol.c      |   12 +---
 mm/slab_common.c     |  174 +++++++++++++++++++++++++++-----------------------
 3 files changed, 101 insertions(+), 94 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 9260abdd67df..e8c95d0bb879 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -113,11 +113,10 @@ void __init kmem_cache_init(void);
 int slab_is_available(void);
 
 struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
-			unsigned long,
-			void (*)(void *));
-struct kmem_cache *
-kmem_cache_create_memcg(struct mem_cgroup *, const char *, size_t, size_t,
-			unsigned long, void (*)(void *), struct kmem_cache *);
+				     unsigned long, void (*)(void *));
+#ifdef CONFIG_MEMCG_KMEM
+int kmem_cache_create_memcg(struct mem_cgroup *, struct kmem_cache *);
+#endif
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 43e08b7bb365..3857033c2718 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3495,15 +3495,9 @@ struct create_work {
 static void memcg_create_cache_work_func(struct work_struct *w)
 {
 	struct create_work *cw = container_of(w, struct create_work, work);
-	struct mem_cgroup *memcg = cw->memcg;
-	struct kmem_cache *s = cw->cachep;
-	struct kmem_cache *new;
-
-	new = kmem_cache_create_memcg(memcg, s->name, s->object_size, s->align,
-				      (s->flags & ~SLAB_PANIC), s->ctor, s);
-	if (new)
-		new->allocflags |= __GFP_KMEMCG;
-	css_put(&memcg->css);
+
+	kmem_cache_create_memcg(cw->memcg, cw->cachep);
+	css_put(&cw->memcg->css);
 	kfree(cw);
 }
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 11857abf7057..6bee919ece80 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -29,8 +29,7 @@ DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
 #ifdef CONFIG_DEBUG_VM
-static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
-				   size_t size)
+static int kmem_cache_sanity_check(const char *name, size_t size)
 {
 	struct kmem_cache *s = NULL;
 
@@ -57,13 +56,7 @@ static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
 		}
 
 #if !defined(CONFIG_SLUB) || !defined(CONFIG_SLUB_DEBUG_ON)
-		/*
-		 * For simplicity, we won't check this in the list of memcg
-		 * caches. We have control over memcg naming, and if there
-		 * aren't duplicates in the global list, there won't be any
-		 * duplicates in the memcg lists as well.
-		 */
-		if (!memcg && !strcmp(s->name, name)) {
+		if (!strcmp(s->name, name)) {
 			pr_err("%s (%s): Cache name already exists.\n",
 			       __func__, name);
 			dump_stack();
@@ -77,8 +70,7 @@ static int kmem_cache_sanity_check(struct mem_cgroup *memcg, const char *name,
 	return 0;
 }
 #else
-static inline int kmem_cache_sanity_check(struct mem_cgroup *memcg,
-					  const char *name, size_t size)
+static inline int kmem_cache_sanity_check(const char *name, size_t size)
 {
 	return 0;
 }
@@ -139,6 +131,47 @@ unsigned long calculate_alignment(unsigned long flags,
 	return ALIGN(align, sizeof(void *));
 }
 
+static struct kmem_cache *
+do_kmem_cache_create(char *name, size_t object_size, size_t size, size_t align,
+		     unsigned long flags, void (*ctor)(void *),
+		     struct mem_cgroup *memcg, struct kmem_cache *cachep)
+{
+	struct kmem_cache *s = NULL;
+	int err = -ENOMEM;
+
+	if (!name)
+		goto out;
+
+	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
+	if (!s)
+		goto out;
+
+	s->name = name;
+	s->object_size = object_size;
+	s->size = size;
+	s->align = align;
+	s->ctor = ctor;
+
+	err = memcg_alloc_cache_params(memcg, s, cachep);
+	if (err)
+		goto out;
+
+	err = __kmem_cache_create(s, flags);
+	if (err)
+		goto out;
+
+	s->refcount = 1;
+	list_add(&s->list, &slab_caches);
+	memcg_register_cache(s);
+out:
+	if (err) {
+		memcg_free_cache_params(s);
+		kfree(name);
+		kfree(s);
+		s = ERR_PTR(err);
+	}
+	return s;
+}
 
 /*
  * kmem_cache_create - Create a cache.
@@ -164,11 +197,9 @@ unsigned long calculate_alignment(unsigned long flags,
  * cacheline.  This can be beneficial if you're counting cycles as closely
  * as davem.
  */
-
 struct kmem_cache *
-kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
-			size_t align, unsigned long flags, void (*ctor)(void *),
-			struct kmem_cache *parent_cache)
+kmem_cache_create(const char *name, size_t size, size_t align,
+		  unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s = NULL;
 	int err;
@@ -176,22 +207,10 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 	get_online_cpus();
 	mutex_lock(&slab_mutex);
 
-	err = kmem_cache_sanity_check(memcg, name, size);
+	err = kmem_cache_sanity_check(name, size);
 	if (err)
 		goto out_unlock;
 
-	if (memcg) {
-		/*
-		 * Since per-memcg caches are created asynchronously on first
-		 * allocation (see memcg_kmem_get_cache()), several threads can
-		 * try to create the same cache, but only one of them may
-		 * succeed. Therefore if we get here and see the cache has
-		 * already been created, we silently return NULL.
-		 */
-		if (cache_from_memcg_idx(parent_cache, memcg_cache_id(memcg)))
-			goto out_unlock;
-	}
-
 	/*
 	 * Some allocators will constraint the set of valid flags to a subset
 	 * of all flags. We expect them to define CACHE_CREATE_MASK in this
@@ -200,55 +219,20 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 	 */
 	flags &= CACHE_CREATE_MASK;
 
-	if (!memcg) {
-		s = __kmem_cache_alias(name, size, align, flags, ctor);
-		if (s)
-			goto out_unlock;
-	}
-
-	err = -ENOMEM;
-	s = kmem_cache_zalloc(kmem_cache, GFP_KERNEL);
-	if (!s)
+	s = __kmem_cache_alias(name, size, align, flags, ctor);
+	if (s)
 		goto out_unlock;
 
-	s->object_size = s->size = size;
-	s->align = calculate_alignment(flags, align, size);
-	s->ctor = ctor;
-
-	if (memcg)
-		s->name = memcg_create_cache_name(memcg, parent_cache);
-	else
-		s->name = kstrdup(name, GFP_KERNEL);
-	if (!s->name)
-		goto out_free_cache;
-
-	err = memcg_alloc_cache_params(memcg, s, parent_cache);
-	if (err)
-		goto out_free_cache;
-
-	err = __kmem_cache_create(s, flags);
-	if (err)
-		goto out_free_cache;
-
-	s->refcount = 1;
-	list_add(&s->list, &slab_caches);
-	memcg_register_cache(s);
+	s = do_kmem_cache_create(kstrdup(name, GFP_KERNEL),
+			size, size, calculate_alignment(flags, align, size),
+			flags, ctor, NULL, NULL);
+	err = IS_ERR(s) ? PTR_ERR(s) : 0;
 
 out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
 	if (err) {
-		/*
-		 * There is no point in flooding logs with warnings or
-		 * especially crashing the system if we fail to create a cache
-		 * for a memcg. In this case we will be accounting the memcg
-		 * allocation to the root cgroup until we succeed to create its
-		 * own cache, but it isn't that critical.
-		 */
-		if (!memcg)
-			return NULL;
-
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
@@ -260,21 +244,51 @@ out_unlock:
 		return NULL;
 	}
 	return s;
-
-out_free_cache:
-	memcg_free_cache_params(s);
-	kfree(s->name);
-	kmem_cache_free(kmem_cache, s);
-	goto out_unlock;
 }
+EXPORT_SYMBOL(kmem_cache_create);
 
-struct kmem_cache *
-kmem_cache_create(const char *name, size_t size, size_t align,
-		  unsigned long flags, void (*ctor)(void *))
+#ifdef CONFIG_MEMCG_KMEM
+/*
+ * kmem_cache_create_memcg - Create a cache for a memory cgroup.
+ * @memcg: The memory cgroup the new cache is for.
+ * @cachep: The parent of the new cache.
+ *
+ * This function creates a kmem cache that will serve allocation requests going
+ * from @memcg to @cachep. The new cache inherits properties from its parent.
+ *
+ * Returns 0 on success, -errno on failure.
+ */
+int kmem_cache_create_memcg(struct mem_cgroup *memcg, struct kmem_cache *cachep)
 {
-	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor, NULL);
+	struct kmem_cache *s;
+	int err;
+
+	get_online_cpus();
+	mutex_lock(&slab_mutex);
+
+	/*
+	 * Since per-memcg caches are created asynchronously on first
+	 * allocation (see memcg_kmem_get_cache()), several threads can try to
+	 * create the same cache, but only one of them may succeed.
+	 */
+	err = -EEXIST;
+	if (cache_from_memcg_idx(cachep, memcg_cache_id(memcg)))
+		goto out_unlock;
+
+	s = do_kmem_cache_create(memcg_create_cache_name(memcg, cachep),
+			cachep->object_size, cachep->size, cachep->align,
+			cachep->flags & ~SLAB_PANIC, cachep->ctor,
+			memcg, cachep);
+	err = IS_ERR(s) ? PTR_ERR(s) : 0;
+	if (!err)
+		s->allocflags |= __GFP_KMEMCG;
+
+out_unlock:
+	mutex_unlock(&slab_mutex);
+	put_online_cpus();
+	return err;
 }
-EXPORT_SYMBOL(kmem_cache_create);
+#endif /* CONFIG_MEMCG_KMEM */
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-- 
1.7.10.4


--------------030205050305010109080506--
