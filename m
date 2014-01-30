Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaA3Vgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:36:51 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44533 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaA3Vgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:36:50 -0500
Date: Thu, 30 Jan 2014 13:36:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on memcg_create_kmem_cache
 fail path
In-Reply-To: <alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1401301315060.15271@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com> <20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org> <alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, David Rientjes wrote:

> What's funnier is that tmp_name isn't required at all since 
> kmem_cache_create_memcg() is just going to do a kstrdup() on it anyway, so 
> you could easily just pass in the pointer to memory that has been 
> allocated for s->name rather than allocating memory twice.
> 

Something like this untested patch?


mm, memcg: only allocate memory for kmem slab cache name once

We must allocate memory to store a slab cache name when using kmem 
accounting since it involves the name of the memcg itself.  This should be 
the one and only memory allocation for that name, though.

Currently, we keep around a global buffer to construct the "memcg slab 
cache name" since it requires rcu protection and then pass it into
kmem_cache_create_memcg() which does its own kstrdup().

This patch only allocates and creates the slab cache name once and then 
passes a pointer into kmem_cache_create_memcg() as the name.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c  | 25 +++++++------------------
 mm/slab_common.c | 11 +++++------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3400,31 +3400,21 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
 static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 						  struct kmem_cache *s)
 {
+	char *name = NULL;
 	struct kmem_cache *new;
-	static char *tmp_name = NULL;
-	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
 
 	BUG_ON(!memcg_can_account_kmem(memcg));
 
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
-			return NULL;
-	}
+	name = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (unlikely(!name))
+		return NULL;
 
 	rcu_read_lock();
-	snprintf(tmp_name, PATH_MAX, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
+	snprintf(name, PATH_MAX, "%s(%d:%s)", s->name, memcg_cache_id(memcg),
+		 cgroup_name(memcg->css.cgroup));
 	rcu_read_unlock();
 
-	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
+	new = kmem_cache_create_memcg(memcg, name, s->object_size, s->align,
 				      (s->flags & ~SLAB_PANIC), s->ctor, s);
 
 	if (new)
@@ -3432,7 +3422,6 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
 	else
 		new = s;
 
-	mutex_unlock(&mutex);
 	return new;
 }
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -142,7 +142,7 @@ unsigned long calculate_alignment(unsigned long flags,
 
 /*
  * kmem_cache_create - Create a cache.
- * @name: A string which is used in /proc/slabinfo to identify this cache.
+ * @name: A string allocated for this cache used in /proc/slabinfo.
  * @size: The size of objects to be created in this cache.
  * @align: The required alignment for the objects.
  * @flags: SLAB flags
@@ -212,10 +212,7 @@ kmem_cache_create_memcg(struct mem_cgroup *memcg, const char *name, size_t size,
 	s->object_size = s->size = size;
 	s->align = calculate_alignment(flags, align, size);
 	s->ctor = ctor;
-
-	s->name = kstrdup(name, GFP_KERNEL);
-	if (!s->name)
-		goto out_free_cache;
+	s->name = name;
 
 	err = memcg_alloc_cache_params(memcg, s, parent_cache);
 	if (err)
@@ -258,7 +255,6 @@ out_unlock:
 
 out_free_cache:
 	memcg_free_cache_params(s);
-	kfree(s->name);
 	kmem_cache_free(kmem_cache, s);
 	goto out_unlock;
 }
@@ -267,6 +263,9 @@ struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t align,
 		  unsigned long flags, void (*ctor)(void *))
 {
+	const char *cache_name = kstrdup(name, GFP_KERNEL);
+	if (unlikely(!cache_name))
+		return NULL;
 	return kmem_cache_create_memcg(NULL, name, size, align, flags, ctor, NULL);
 }
 EXPORT_SYMBOL(kmem_cache_create);
