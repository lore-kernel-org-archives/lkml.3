Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaA3VBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:01:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3VBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:01:30 -0500
Date: Thu, 30 Jan 2014 13:01:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <mhocko@suse.cz>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: fix mutex not unlocked on
 memcg_create_kmem_cache fail path
Message-Id: <20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org>
In-Reply-To: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 20:01:33 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3400,7 +3400,7 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
>  static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>  						  struct kmem_cache *s)
>  {
> -	struct kmem_cache *new;
> +	struct kmem_cache *new = NULL;
>  	static char *tmp_name = NULL;
>  	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
>  
> @@ -3416,7 +3416,7 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>  	if (!tmp_name) {
>  		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
>  		if (!tmp_name)
> -			return NULL;
> +			goto out;
>  	}
>  
>  	rcu_read_lock();
> @@ -3426,12 +3426,11 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>  
>  	new = kmem_cache_create_memcg(memcg, tmp_name, s->object_size, s->align,
>  				      (s->flags & ~SLAB_PANIC), s->ctor, s);
> -
>  	if (new)
>  		new->allocflags |= __GFP_KMEMCG;
>  	else
>  		new = s;
> -
> +out:
>  	mutex_unlock(&mutex);
>  	return new;
>  }

Well gee, how did that one get through?

What was the point in permanently allocating tmp_name, btw?  "This
static temporary buffer is used to prevent from pointless shortliving
allocation"?  That's daft - memcg_create_kmem_cache() is not a fastpath
and there are a million places in the kernel where we could permanently
leak memory because it is "pointless" to allocate on demand.

The allocation of PATH_MAX bytes is unfortunate - kasprintf() wouild
work well here, but cgroup_name()'s need for rcu_read_lock() screws us
up.


So how about doing this?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: memcg_create_kmem_cache() tweaks

Allocate tmp_name on demand rather than permanently consuming PATH_MAX
bytes of memory.  This permits a small reduction in the mutex hold time as
well.

Cc: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-memcg_create_kmem_cache-tweaks mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-memcg_create_kmem_cache-tweaks
+++ a/mm/memcontrol.c
@@ -3401,17 +3401,14 @@ static struct kmem_cache *memcg_create_k
 						  struct kmem_cache *s)
 {
 	struct kmem_cache *new = NULL;
-	static char *tmp_name = NULL;
+	static char *tmp_name;
 	static DEFINE_MUTEX(mutex);	/* protects tmp_name */
 
 	BUG_ON(!memcg_can_account_kmem(memcg));
 
-	mutex_lock(&mutex);
 	/*
-	 * kmem_cache_create_memcg duplicates the given name and
-	 * cgroup_name for this name requires RCU context.
-	 * This static temporary buffer is used to prevent from
-	 * pointless shortliving allocation.
+	 * kmem_cache_create_memcg duplicates the given name and cgroup_name()
+	 * for this name requires rcu_read_lock().
 	 */
 	if (!tmp_name) {
 		tmp_name = kmalloc(PATH_MAX, GFP_KERNEL);
@@ -3419,6 +3416,7 @@ static struct kmem_cache *memcg_create_k
 			goto out;
 	}
 
+	mutex_lock(&mutex);
 	rcu_read_lock();
 	snprintf(tmp_name, PATH_MAX, "%s(%d:%s)", s->name,
 			 memcg_cache_id(memcg), cgroup_name(memcg->css.cgroup));
@@ -3432,6 +3430,7 @@ static struct kmem_cache *memcg_create_k
 		new = s;
 out:
 	mutex_unlock(&mutex);
+	kfree(tmp_name);
 	return new;
 }
 
_

