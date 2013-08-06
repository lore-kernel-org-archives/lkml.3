Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3HFFpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:45:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43960 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3HFFpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:45:31 -0400
Date: Tue, 6 Aug 2013 15:45:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the drm-intel tree
Message-Id: <20130806154518.2b3c86349b167312a2a7a8a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Aug_2013_15_45_18_+1000_5ujK6iodcSL8_suY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Aug_2013_15_45_18_+1000_5ujK6iodcSL8_suY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commit a70a3148b0c6 ("drm/i915:
Make proper functions for VMs") from the drm-intel tree and commit
e6950216e0af ("drivers: convert shrinkers to new count/scan API") from
the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index d31e15d,49db617..0000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -4642,10 -4626,10 +4650,9 @@@ i915_gem_inactive_count(struct shrinke
  			     struct drm_i915_private,
  			     mm.inactive_shrinker);
  	struct drm_device *dev =3D dev_priv->dev;
 -	struct i915_address_space *vm =3D &dev_priv->gtt.base;
  	struct drm_i915_gem_object *obj;
- 	int nr_to_scan =3D sc->nr_to_scan;
  	bool unlock =3D true;
- 	int cnt;
+ 	long cnt;
 =20
  	if (!mutex_trylock(&dev->struct_mutex)) {
  		if (!mutex_is_locked_by(&dev->struct_mutex, current))
@@@ -4683,75 -4653,36 +4681,109 @@@
  		mutex_unlock(&dev->struct_mutex);
  	return cnt;
  }
 +
+ static long
+ i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control *=
sc)
+ {
+ 	struct drm_i915_private *dev_priv =3D
+ 		container_of(shrinker,
+ 			     struct drm_i915_private,
+ 			     mm.inactive_shrinker);
+ 	struct drm_device *dev =3D dev_priv->dev;
+ 	int nr_to_scan =3D sc->nr_to_scan;
+ 	long freed;
+ 	bool unlock =3D true;
+=20
+ 	if (!mutex_trylock(&dev->struct_mutex)) {
+ 		if (!mutex_is_locked_by(&dev->struct_mutex, current))
+ 			return 0;
+=20
+ 		if (dev_priv->mm.shrinker_no_lock_stealing)
+ 			return 0;
+=20
+ 		unlock =3D false;
+ 	}
+=20
+ 	freed =3D i915_gem_purge(dev_priv, nr_to_scan);
+ 	if (freed < nr_to_scan)
+ 		freed +=3D __i915_gem_shrink(dev_priv, nr_to_scan,
+ 							false);
+ 	if (freed < nr_to_scan)
+ 		freed +=3D i915_gem_shrink_all(dev_priv);
+=20
+ 	if (unlock)
+ 		mutex_unlock(&dev->struct_mutex);
+ 	return freed;
+ }
++
 +/* All the new VM stuff */
 +unsigned long i915_gem_obj_offset(struct drm_i915_gem_object *o,
 +				  struct i915_address_space *vm)
 +{
 +	struct drm_i915_private *dev_priv =3D o->base.dev->dev_private;
 +	struct i915_vma *vma;
 +
 +	if (vm =3D=3D &dev_priv->mm.aliasing_ppgtt->base)
 +		vm =3D &dev_priv->gtt.base;
 +
 +	BUG_ON(list_empty(&o->vma_list));
 +	list_for_each_entry(vma, &o->vma_list, vma_link) {
 +		if (vma->vm =3D=3D vm)
 +			return vma->node.start;
 +
 +	}
 +	return -1;
 +}
 +
 +bool i915_gem_obj_bound(struct drm_i915_gem_object *o,
 +			struct i915_address_space *vm)
 +{
 +	struct i915_vma *vma;
 +
 +	list_for_each_entry(vma, &o->vma_list, vma_link)
 +		if (vma->vm =3D=3D vm)
 +			return true;
 +
 +	return false;
 +}
 +
 +bool i915_gem_obj_bound_any(struct drm_i915_gem_object *o)
 +{
 +	struct drm_i915_private *dev_priv =3D o->base.dev->dev_private;
 +	struct i915_address_space *vm;
 +
 +	list_for_each_entry(vm, &dev_priv->vm_list, global_link)
 +		if (i915_gem_obj_bound(o, vm))
 +			return true;
 +
 +	return false;
 +}
 +
 +unsigned long i915_gem_obj_size(struct drm_i915_gem_object *o,
 +				struct i915_address_space *vm)
 +{
 +	struct drm_i915_private *dev_priv =3D o->base.dev->dev_private;
 +	struct i915_vma *vma;
 +
 +	if (vm =3D=3D &dev_priv->mm.aliasing_ppgtt->base)
 +		vm =3D &dev_priv->gtt.base;
 +
 +	BUG_ON(list_empty(&o->vma_list));
 +
 +	list_for_each_entry(vma, &o->vma_list, vma_link)
 +		if (vma->vm =3D=3D vm)
 +			return vma->node.size;
 +
 +	return 0;
 +}
 +
 +struct i915_vma *i915_gem_obj_to_vma(struct drm_i915_gem_object *obj,
 +				     struct i915_address_space *vm)
 +{
 +	struct i915_vma *vma;
 +	list_for_each_entry(vma, &obj->vma_list, vma_link)
 +		if (vma->vm =3D=3D vm)
 +			return vma;
 +
 +	return NULL;
 +}

--Signature=_Tue__6_Aug_2013_15_45_18_+1000_5ujK6iodcSL8_suY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAI1zAAoJEECxmPOUX5FEWiIQAJSy6dAtfDZrxdFIEuXD4QhG
Pf5/UD2NgS9DELVn2Aqyqt51vcvyAgqA1nTb5Padd7QgTP/hNb+jfJrpz8oK7riZ
EV2E2mtbpqlxjHWXZ2xdYkdRVaz67YYRMB5Mh2vFkE+trch9DdxlJQn//xI+MSkS
Szp/9dMC6GaKJsN7bS2aIZIEFP3I3VONWsv1dD6Shs9jVj7bRk7V1XMB2Sbo804R
Siqu3zskaYID1RIOryLsRVPQgHjB+tcYkRRjORiGJN0TejG7HDptGYOGNRwHRa+w
N2gKk51pPrLGmK2JMMdZljw4TKBY/E/K/umo+cfnz8eqFGS72gnlb42XXTtdEWun
i39kdcqzkiRiNY5mDQFP/9vqnT62u0UfLezRoS/Q5RUa/iPaSPZJn9Z33NlZ/IaQ
GiaVIHsArEJsAOnC9j6whemWzde29NVcTUiH3po7PrrqNmMXC5gCb78DpCk7CWZ3
AjgNOtHrFNReq5TgpafmELWHGy34nc3Ysf8uK49ATR9U1ianKpny5exa2zBMzM6Z
YcOxpKJtVS5pIoZHh1L78WLyq8MuOVL2moeGp0mItOYEMofBgzddyHoQn6bqMRgG
C9kVhLmMIv6VJkQrS1A8mOWN1ICjsUfd4ctZ8XwG7DIcnAA7RO5r3Cd8QVHJfd3n
Dg5TE/uLqtPrejjGHbrO
=m8IC
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Aug_2013_15_45_18_+1000_5ujK6iodcSL8_suY--
