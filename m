Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaEVFoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:44:10 -0400
Received: from ozlabs.org ([103.22.144.67]:50784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaEVFoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:44:09 -0400
Date: Thu, 22 May 2014 15:44:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-ID: <20140522154402.5daf8ac6@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/FXY6D9wGsJ2oAKNGAV4/TeD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FXY6D9wGsJ2oAKNGAV4/TeD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem_execbuffer.c between commit 4eda4e461109
("drm/i915: Prevent negative relocation deltas from wrapping") from the
drm-intel-fixes tree and commit a8ebba75b358 ("drm/i915: Use the coarse
ping-pong mechanism based on drm fd to dispatch the BSD command on BDW
GT3") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 6651195edcad,47fe8ecef135..000000000000
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@@ -1018,25 -1007,37 +1026,56 @@@ i915_reset_gen7_sol_offsets(struct drm_
  	return 0;
  }
 =20
 +static struct drm_i915_gem_object *
 +eb_get_batch(struct eb_vmas *eb)
 +{
 +	struct i915_vma *vma =3D list_entry(eb->vmas.prev, typeof(*vma), exec_li=
st);
 +
 +	/*
 +	 * SNA is doing fancy tricks with compressing batch buffers, which leads
 +	 * to negative relocation deltas. Usually that works out ok since the
 +	 * relocate address is still positive, except when the batch is placed
 +	 * very low in the GTT. Ensure this doesn't happen.
 +	 *
 +	 * Note that actual hangs have only been observed on gen7, but for
 +	 * paranoia do it everywhere.
 +	 */
 +	vma->exec_entry->flags |=3D __EXEC_OBJECT_NEEDS_BIAS;
 +
 +	return vma->obj;
 +}
 +
+ /**
+  * Find one BSD ring to dispatch the corresponding BSD command.
+  * The Ring ID is returned.
+  */
+ static int gen8_dispatch_bsd_ring(struct drm_device *dev,
+ 				  struct drm_file *file)
+ {
+ 	struct drm_i915_private *dev_priv =3D dev->dev_private;
+ 	struct drm_i915_file_private *file_priv =3D file->driver_priv;
+=20
+ 	/* Check whether the file_priv is using one ring */
+ 	if (file_priv->bsd_ring)
+ 		return file_priv->bsd_ring->id;
+ 	else {
+ 		/* If no, use the ping-pong mechanism to select one ring */
+ 		int ring_id;
+=20
+ 		mutex_lock(&dev->struct_mutex);
+ 		if (dev_priv->ring_index =3D=3D 0) {
+ 			ring_id =3D VCS;
+ 			dev_priv->ring_index =3D 1;
+ 		} else {
+ 			ring_id =3D VCS2;
+ 			dev_priv->ring_index =3D 0;
+ 		}
+ 		file_priv->bsd_ring =3D &dev_priv->ring[ring_id];
+ 		mutex_unlock(&dev->struct_mutex);
+ 		return ring_id;
+ 	}
+ }
+=20
  static int
  i915_gem_do_execbuffer(struct drm_device *dev, void *data,
  		       struct drm_file *file,

--Sig_/FXY6D9wGsJ2oAKNGAV4/TeD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfY6mAAoJEMDTa8Ir7ZwVGzQP/0vBkDuL2ZEjSHSTVlzxPc7d
YGKGLIbGGwvTDNbGNipLaTa+FNgWXOxcIABp1j5Ni+mNZHtQQo+A6yVnbs2526Hd
svuc6H3W220JUmGXVT8/nm1IMKbgr6fF6XN7k6bBYNwnaFOurGxa9/fXj+r7l9rq
g2V39K28ppIvn/CDbPOzuNVVzdnnDr/zLZyxH4tcFsz95EcDrzVQmstVwuf3Uymi
FaQLzDdBghq2uNlkhPJcPj1KHghACAwf76ybAMfgf3y/v8iGxDtPJBuUWVMadFrR
9eyWIoXfl5FclQ/P0DzFPnqS3z5gOMJqnmQf7ayg7rh5r6qeZMSjarXTfxFbZuzh
XpY3EB+dTMSnFI2lFXiZgW3Xg3cVeDk28oUmMwA662uB3zX782VlOR9qFTahfGEW
0tZZBo0Mlc4M/ak1Uw12d6cJ1l+QgR770uQ4GKdKkUetPJ8xTxd6qsO0ijnvWYeD
H7cL9xty5F0GkdFhsD2aczmJ3N7n3dqL3/HsAKOAYDXiDQhLlFBQ+0W/FETJKa0a
+CBw/u+huugctkl7M8IfwCszXqFN+NP2yGuzdBUlEnFy7mRNbcvZzI9hETRlfP0u
oWRXgqgCCcRnCNmj4JB0cACPo/OhH0xLH7nm7cRaDJFNz2Ic28MnueJwW2QPjhyz
EPzBoJ8L1SkioCdoLop8
=Q46S
-----END PGP SIGNATURE-----

--Sig_/FXY6D9wGsJ2oAKNGAV4/TeD--
