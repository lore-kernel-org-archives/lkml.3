Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab3IRBVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:21:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37201 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3IRBVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:21:03 -0400
Date: Wed, 18 Sep 2013 11:20:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the drm-intel tree with Linus' tree
Message-Id: <20130918112054.1f8f983461cc9ead5b9a635f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_11_20_54_+1000_LlF4iHQGUOGViQX4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_11_20_54_+1000_LlF4iHQGUOGViQX4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commit 7dc19d5affd7 ("drivers:
convert shrinkers to new count/scan API") from the  tree and commit
e656a6cba0fe ("drm/i915: inline vma_create into lookup_or_create_vma")
from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index df9253d,d00d24f..0000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -4886,61 -4912,3 +4940,37 @@@ unsigned long i915_gem_obj_size(struct=20
 =20
  	return 0;
  }
 +
 +static unsigned long
 +i915_gem_inactive_scan(struct shrinker *shrinker, struct shrink_control *=
sc)
 +{
 +	struct drm_i915_private *dev_priv =3D
 +		container_of(shrinker,
 +			     struct drm_i915_private,
 +			     mm.inactive_shrinker);
 +	struct drm_device *dev =3D dev_priv->dev;
 +	int nr_to_scan =3D sc->nr_to_scan;
 +	unsigned long freed;
 +	bool unlock =3D true;
 +
 +	if (!mutex_trylock(&dev->struct_mutex)) {
 +		if (!mutex_is_locked_by(&dev->struct_mutex, current))
 +			return 0;
 +
 +		if (dev_priv->mm.shrinker_no_lock_stealing)
 +			return 0;
 +
 +		unlock =3D false;
 +	}
 +
 +	freed =3D i915_gem_purge(dev_priv, nr_to_scan);
 +	if (freed < nr_to_scan)
 +		freed +=3D __i915_gem_shrink(dev_priv, nr_to_scan,
 +							false);
 +	if (freed < nr_to_scan)
 +		freed +=3D i915_gem_shrink_all(dev_priv);
 +
 +	if (unlock)
 +		mutex_unlock(&dev->struct_mutex);
 +	return freed;
 +}
-=20
- struct i915_vma *i915_gem_obj_to_vma(struct drm_i915_gem_object *obj,
- 				     struct i915_address_space *vm)
- {
- 	struct i915_vma *vma;
- 	list_for_each_entry(vma, &obj->vma_list, vma_link)
- 		if (vma->vm =3D=3D vm)
- 			return vma;
-=20
- 	return NULL;
- }
-=20
- struct i915_vma *
- i915_gem_obj_lookup_or_create_vma(struct drm_i915_gem_object *obj,
- 				  struct i915_address_space *vm)
- {
- 	struct i915_vma *vma;
-=20
- 	vma =3D i915_gem_obj_to_vma(obj, vm);
- 	if (!vma)
- 		vma =3D i915_gem_vma_create(obj, vm);
-=20
- 	return vma;
- }

--Signature=_Wed__18_Sep_2013_11_20_54_+1000_LlF4iHQGUOGViQX4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSOP/6AAoJEECxmPOUX5FEz8YP/jc8u9YpbnZV4xNzBFl3Q5+D
yXx+rpanXAsZSWEIOheJMWDknMQ2DZfqI7Zyrk/1HAZ3a87bdOo2N8O8dp75pHRk
wctc+LFhs7fLGrtM2qgoNnJWW8W4vubA8PFxFynMEGR8URJOHIPJxAa8nyLyx8+/
HW1p3JxipwImurMZY6E69kUFk7qxNTQ2RZxi+NKQA3h2+z50BVsiz7bpghssuZCN
qvahgLrsgGJ5OPinjE+YPXMwwgZTq/8Bs/EI1CfJIFznC5uSNN/drFQxUG1j+2Ml
CrKr1U5wydy9yDPPvUn4AWSsdapy32TqiSMwITIXvN1YE0WQGgTLuGJYWmcZX6bg
9kyvgxRSYsi1zDNKYM0hp9ZQBnYCypFu9TcwDJEpMa3jnVuc2lyZKfQTf5eiIu+Y
sLyJtpFuMC589YOqkeVlY3hSUW510YW4qoxHu/jC2Y2oZQlCeMcGKuERiF7q8cR8
R0AgPRIG8mkl7ucZDxEWRjoN7SZp70pZhSm9WA1ANxJ7dbLDdhOXG9Qjlb+6dBuc
Ujvs1cjDx4xZkjBzuNV3USOoEaphChkgoZFyPQRZ70MBCdxnRSO3dGQviOKmuxsP
GwXsm+Tpvh14H69didG3djnxxoXrJl/CoZwuBHp/gdW/N5uHtj7X7X+m7CNDXxcj
00MgPUYYPRdgS3m3kmHj
=BPq6
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_11_20_54_+1000_LlF4iHQGUOGViQX4--
