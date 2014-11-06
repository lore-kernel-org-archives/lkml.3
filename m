Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaKFLam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:30:42 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49127 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:30:36 -0500
Date: Thu, 6 Nov 2014 12:30:32 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20141106113031.GK26297@ulmo>
References: <20141106193618.461c3ae7@canb.auug.org.au>
 <20141106112359.GJ26297@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sWvRP97dwRHm9fX+"
Content-Disposition: inline
In-Reply-To: <20141106112359.GJ26297@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sWvRP97dwRHm9fX+
Content-Type: multipart/mixed; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 12:24:00PM +0100, Thierry Reding wrote:
> On Thu, Nov 06, 2014 at 07:36:18PM +1100, Stephen Rothwell wrote:
> > Hi Andrew,
> >=20
> > After merging the akpm tree, today's linux-next build (sparc defconfig)
> > failed like this:
> >=20
> > mm/slab.c: In function 'slab_alloc':
> > mm/slab.c:3260:4: error: implicit declaration of function 'slab_free' [=
-Werror=3Dimplicit-function-declaration]
> >     slab_free(cachep, objp);
> >     ^
> > mm/slab.c: At top level:
> > mm/slab.c:3534:29: warning: conflicting types for 'slab_free'
> >  static __always_inline void slab_free(struct kmem_cache *cachep, void =
*objp)
> >                              ^
> > mm/slab.c:3534:29: error: static declaration of 'slab_free' follows non=
-static declaration
> > mm/slab.c:3260:4: note: previous implicit declaration of 'slab_free' wa=
s here
> >     slab_free(cachep, objp);
> >     ^
> >=20
> > I am not sure what caused this, but it is something in the akpm-current
> > or akpm trees (possibly interacting with something else).
>=20
> I fixed this using the attached patch.
>=20
> Thierry

> From a9ec6cfacb892e044a5f76dce3b7fc9a3337d01a Mon Sep 17 00:00:00 2001
> From: Thierry Reding <treding@nvidia.com>
> Date: Thu, 6 Nov 2014 11:59:23 +0100
> Subject: [PATCH] mm/slab: Always predeclare slab_free()
>=20
> Commit 5da1c3c725ab ("slab: recharge slab pages to the allocating memory
> cgroup") added a predeclaration of the new slab_free() helper so that it
> can be used in slab_alloc_node() and slab_alloc(). However the prototype
> is added in an #ifdef CONFIG_NUMA protected section of code, which works
> fine for slab_alloc_node() but fails for slab_alloc().
>=20
> Fixes the following build warnings and errors:
>=20
> 	mm/slab.c: In function 'slab_alloc':
> 	mm/slab.c:3260:4: error: implicit declaration of function 'slab_free' [-=
Werror=3Dimplicit-function-declaration]
> 	    slab_free(cachep, objp);
> 	    ^
> 	mm/slab.c: At top level:
> 	mm/slab.c:3534:29: warning: conflicting types for 'slab_free'
> 	 static __always_inline void slab_free(struct kmem_cache *cachep, void *=
objp)
> 				     ^
> 	mm/slab.c:3534:29: error: static declaration of 'slab_free' follows non-=
static declaration
> 	mm/slab.c:3260:4: note: previous implicit declaration of 'slab_free' was=
 here
> 	    slab_free(cachep, objp);
> 	    ^
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  mm/slab.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/mm/slab.c b/mm/slab.c
> index 61b01c2ae1d9..00cd028404cb 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2961,6 +2961,8 @@ out:
>  	return objp;
>  }
> =20
> +static __always_inline void slab_free(struct kmem_cache *cachep, void *o=
bjp);
> +
>  #ifdef CONFIG_NUMA
>  /*
>   * Try allocating on another node if PFA_SPREAD_SLAB is a mempolicy is s=
et.
> @@ -3133,8 +3135,6 @@ done:
>  	return obj;
>  }
> =20
> -static __always_inline void slab_free(struct kmem_cache *cachep, void *o=
bjp);
> -
>  static __always_inline void *
>  slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
>  		   unsigned long caller)

Attached is a follow-up cleanup patch that avoids the need for a pre-
declaration. Feel free to ignore if you prefer the predeclaration.

Thierry

--9JSHP372f+2dzJ8X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-mm-slab-Shuffle-code-around-to-avoid-a-predeclaratio.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 3ad8947fd8613d13f2b9dc1ccd370d0a9ffaeb7b Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding@nvidia.com>
Date: Thu, 6 Nov 2014 12:25:03 +0100
Subject: [PATCH] mm/slab: Shuffle code around to avoid a predeclaration

Instead of providing a predeclaration for the slab_free() helper, move
the helper and its dependencies before any of their users.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 mm/slab.c | 200 +++++++++++++++++++++++++++++++---------------------------=
----
 1 file changed, 99 insertions(+), 101 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 00cd028404cb..3c025f5934da 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2961,7 +2961,105 @@ out:
 	return objp;
 }
=20
-static __always_inline void slab_free(struct kmem_cache *cachep, void *obj=
p);
+static void cache_flusharray(struct kmem_cache *cachep, struct array_cache=
 *ac)
+{
+	int batchcount;
+	struct kmem_cache_node *n;
+	int node =3D numa_mem_id();
+	LIST_HEAD(list);
+
+	batchcount =3D ac->batchcount;
+#if DEBUG
+	BUG_ON(!batchcount || batchcount > ac->avail);
+#endif
+	check_irq_off();
+	n =3D get_node(cachep, node);
+	spin_lock(&n->list_lock);
+	if (n->shared) {
+		struct array_cache *shared_array =3D n->shared;
+		int max =3D shared_array->limit - shared_array->avail;
+		if (max) {
+			if (batchcount > max)
+				batchcount =3D max;
+			memcpy(&(shared_array->entry[shared_array->avail]),
+			       ac->entry, sizeof(void *) * batchcount);
+			shared_array->avail +=3D batchcount;
+			goto free_done;
+		}
+	}
+
+	free_block(cachep, ac->entry, batchcount, node, &list);
+free_done:
+#if STATS
+	{
+		int i =3D 0;
+		struct list_head *p;
+
+		p =3D n->slabs_free.next;
+		while (p !=3D &(n->slabs_free)) {
+			struct page *page;
+
+			page =3D list_entry(p, struct page, lru);
+			BUG_ON(page->active);
+
+			i++;
+			p =3D p->next;
+		}
+		STATS_SET_FREEABLE(cachep, i);
+	}
+#endif
+	spin_unlock(&n->list_lock);
+	slabs_destroy(cachep, &list);
+	ac->avail -=3D batchcount;
+	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
+}
+
+/*
+ * Release an obj back to its cache. If the obj has a constructed state, i=
t must
+ * be in this state _before_ it is released.  Called with disabled ints.
+ */
+static inline void __cache_free(struct kmem_cache *cachep, void *objp,
+				unsigned long caller)
+{
+	struct array_cache *ac =3D cpu_cache_get(cachep);
+
+	check_irq_off();
+	kmemleak_free_recursive(objp, cachep->flags);
+	objp =3D cache_free_debugcheck(cachep, objp, caller);
+
+	kmemcheck_slab_free(cachep, objp, cachep->object_size);
+
+	/*
+	 * Skip calling cache_free_alien() when the platform is not numa.
+	 * This will avoid cache misses that happen while accessing slabp (which
+	 * is per page memory  reference) to get nodeid. Instead use a global
+	 * variable to skip the call, which is mostly likely to be present in
+	 * the cache.
+	 */
+	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
+		return;
+
+	if (ac->avail < ac->limit) {
+		STATS_INC_FREEHIT(cachep);
+	} else {
+		STATS_INC_FREEMISS(cachep);
+		cache_flusharray(cachep, ac);
+	}
+
+	ac_put_obj(cachep, ac, objp);
+}
+
+static __always_inline void slab_free(struct kmem_cache *cachep, void *obj=
p)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	debug_check_no_locks_freed(objp, cachep->object_size);
+	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
+		debug_check_no_obj_freed(objp, cachep->object_size);
+	__cache_free(cachep, objp, _RET_IP_);
+	local_irq_restore(flags);
+}
=20
 #ifdef CONFIG_NUMA
 /*
@@ -3307,94 +3405,6 @@ static void free_block(struct kmem_cache *cachep, vo=
id **objpp,
 	}
 }
=20
-static void cache_flusharray(struct kmem_cache *cachep, struct array_cache=
 *ac)
-{
-	int batchcount;
-	struct kmem_cache_node *n;
-	int node =3D numa_mem_id();
-	LIST_HEAD(list);
-
-	batchcount =3D ac->batchcount;
-#if DEBUG
-	BUG_ON(!batchcount || batchcount > ac->avail);
-#endif
-	check_irq_off();
-	n =3D get_node(cachep, node);
-	spin_lock(&n->list_lock);
-	if (n->shared) {
-		struct array_cache *shared_array =3D n->shared;
-		int max =3D shared_array->limit - shared_array->avail;
-		if (max) {
-			if (batchcount > max)
-				batchcount =3D max;
-			memcpy(&(shared_array->entry[shared_array->avail]),
-			       ac->entry, sizeof(void *) * batchcount);
-			shared_array->avail +=3D batchcount;
-			goto free_done;
-		}
-	}
-
-	free_block(cachep, ac->entry, batchcount, node, &list);
-free_done:
-#if STATS
-	{
-		int i =3D 0;
-		struct list_head *p;
-
-		p =3D n->slabs_free.next;
-		while (p !=3D &(n->slabs_free)) {
-			struct page *page;
-
-			page =3D list_entry(p, struct page, lru);
-			BUG_ON(page->active);
-
-			i++;
-			p =3D p->next;
-		}
-		STATS_SET_FREEABLE(cachep, i);
-	}
-#endif
-	spin_unlock(&n->list_lock);
-	slabs_destroy(cachep, &list);
-	ac->avail -=3D batchcount;
-	memmove(ac->entry, &(ac->entry[batchcount]), sizeof(void *)*ac->avail);
-}
-
-/*
- * Release an obj back to its cache. If the obj has a constructed state, i=
t must
- * be in this state _before_ it is released.  Called with disabled ints.
- */
-static inline void __cache_free(struct kmem_cache *cachep, void *objp,
-				unsigned long caller)
-{
-	struct array_cache *ac =3D cpu_cache_get(cachep);
-
-	check_irq_off();
-	kmemleak_free_recursive(objp, cachep->flags);
-	objp =3D cache_free_debugcheck(cachep, objp, caller);
-
-	kmemcheck_slab_free(cachep, objp, cachep->object_size);
-
-	/*
-	 * Skip calling cache_free_alien() when the platform is not numa.
-	 * This will avoid cache misses that happen while accessing slabp (which
-	 * is per page memory  reference) to get nodeid. Instead use a global
-	 * variable to skip the call, which is mostly likely to be present in
-	 * the cache.
-	 */
-	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
-		return;
-
-	if (ac->avail < ac->limit) {
-		STATS_INC_FREEHIT(cachep);
-	} else {
-		STATS_INC_FREEMISS(cachep);
-		cache_flusharray(cachep, ac);
-	}
-
-	ac_put_obj(cachep, ac, objp);
-}
-
 /**
  * kmem_cache_alloc - Allocate an object
  * @cachep: The cache to allocate from.
@@ -3531,18 +3541,6 @@ void *__kmalloc_track_caller(size_t size, gfp_t flag=
s, unsigned long caller)
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
=20
-static __always_inline void slab_free(struct kmem_cache *cachep, void *obj=
p)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	debug_check_no_locks_freed(objp, cachep->object_size);
-	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(objp, cachep->object_size);
-	__cache_free(cachep, objp, _RET_IP_);
-	local_irq_restore(flags);
-}
-
 /**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
--=20
2.1.3


--9JSHP372f+2dzJ8X--

--sWvRP97dwRHm9fX+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUW1vXAAoJEN0jrNd/PrOhhfQQAISyX40MuA+bUWOQLT+4ABrn
hSi8B58mQYqKrVIBmFrhyEnR50kYVFdCtYUTaJCAtruIvYUOnxAbHOUdqVJioWYA
KjKEUyhGiZgDaIdd2KJNbCfAnZCGy8jkDPHmoMxorMqPXophPbycuE81vy7rUMMF
Q1ECxQ9N8dQAo1CsHQis3oTimgXB0o7xgXq8xsXicUUKSOb+rmTFGVjKyHCghWWS
aIFoPfbJ2rfLUXtmYQpjP9hvgga9Y4LSrzXK1YA8ga3BcLKZWQ20LrZMvbyZNLot
I0LXtdixR6GXeFEAwbUpDI3r2o0jEv2e22vMy16HvxgZ4D502TL3SSIr8h1XiqdC
yL/Rs0GBhB6h4wKE3LwwZ7E8ZBVG/vAIqXXNnSVaHC8LtWqDtQa6uhXqGoiw+bNi
tJVts8Q+5G8VhcGgyV/ECBkExO0KYl3EVoThQaeuFohpK6ijYXO2mHvJDEjk/MnN
RZO/zUHXo7S50xLwobSkz7g20wZly9xaYusdwY+vD8p+mnQxkdIdZElLcJj/MNlr
PDchvheZGcCFZWhXK35ZxY9Q05sxPe9WCfekV8fcN6nlTuyMgGE7RpuIAu5oLnU6
DZjOsBrxv1RR+tqgaknukkZpb91USPW6uJVU9LkiCyEvtxrcSOxtUSaqsh7snGQj
7UiB7rEUdRo6veLaPdxy
=cEar
-----END PGP SIGNATURE-----

--sWvRP97dwRHm9fX+--
