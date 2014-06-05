Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaFED77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 23:59:59 -0400
Received: from ozlabs.org ([103.22.144.67]:39565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaFED75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 23:59:57 -0400
Date: Thu, 5 Jun 2014 13:59:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhao Yakui <yakui.zhao@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20140605135950.78ee7dee@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GMQnUCfHxg.+AN2s37K2.oI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GMQnUCfHxg.+AN2s37K2.oI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem_execbuffer.c between commit d23db88c3ab2
("drm/i915: Prevent negative relocation deltas from wrapping") from
Linus' tree and commit a8ebba75b358 ("drm/i915: Use the coarse
ping-pong mechanism based on drm fd to dispatch the BSD command on BDW
GT3") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 20fef6c50267,008e208e9a3a..000000000000
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@@ -597,38 -595,8 +600,38 @@@ i915_gem_execbuffer_reserve_vma(struct=20
  	return 0;
  }
 =20
 +static bool
 +eb_vma_misplaced(struct i915_vma *vma, bool has_fenced_gpu_access)
 +{
 +	struct drm_i915_gem_exec_object2 *entry =3D vma->exec_entry;
 +	struct drm_i915_gem_object *obj =3D vma->obj;
 +	bool need_fence, need_mappable;
 +
 +	need_fence =3D
 +		has_fenced_gpu_access &&
 +		entry->flags & EXEC_OBJECT_NEEDS_FENCE &&
 +		obj->tiling_mode !=3D I915_TILING_NONE;
 +	need_mappable =3D need_fence || need_reloc_mappable(vma);
 +
 +	WARN_ON((need_mappable || need_fence) &&
 +	       !i915_is_ggtt(vma->vm));
 +
 +	if (entry->alignment &&
 +	    vma->node.start & (entry->alignment - 1))
 +		return true;
 +
 +	if (need_mappable && !obj->map_and_fenceable)
 +		return true;
 +
 +	if (entry->flags & __EXEC_OBJECT_NEEDS_BIAS &&
 +	    vma->node.start < BATCH_OFFSET_BIAS)
 +		return true;
 +
 +	return false;
 +}
 +
  static int
- i915_gem_execbuffer_reserve(struct intel_ring_buffer *ring,
+ i915_gem_execbuffer_reserve(struct intel_engine_cs *ring,
  			    struct list_head *vmas,
  			    bool *need_relocs)
  {
@@@ -1018,25 -1009,37 +1028,56 @@@ i915_reset_gen7_sol_offsets(struct drm_
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
+ 		if (dev_priv->mm.bsd_ring_dispatch_index =3D=3D 0) {
+ 			ring_id =3D VCS;
+ 			dev_priv->mm.bsd_ring_dispatch_index =3D 1;
+ 		} else {
+ 			ring_id =3D VCS2;
+ 			dev_priv->mm.bsd_ring_dispatch_index =3D 0;
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

--Sig_/GMQnUCfHxg.+AN2s37K2.oI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTj+s7AAoJEMDTa8Ir7ZwVFWgP/0VKja2C8aIJQ979A1l/uQB8
5ESfXvEmNEii9z991jhl+8DfycMK6gBGa88BzrfTABmB/CuFxpVwdWG+mJQVDDBE
PlT9nNbuR8VyE/H4czbXoPcVvwWCbb7HhGkCFMQRHmRN2hW98jF++TOYPcVzAGP+
ns+m4DGNyRVZOyNG53XxwR1i1eLQ2NMss2Ui7Mxihou45V6IyoTqR9sXBI1q0d2j
LnnyeVdLeY07lJMGVTjeVkULdYqeQGcIEPFW6kvICt2ILI8UuWSSygUtSxOWjHqB
8NNMcvZGafADh6N5YVlEQ/OrnUBgh7ak8KkXfLRGUlZqtuj28UY2zF+GoajBfA0S
w93y9pvwn94RJASu40rJbgnodTZAN/6ZG5R8zQEreduA1ut8bHe/gF7X9fORwk5J
LapJaR6ir/+zj5AMF/GWFjD3D3eTVV+xgj3//UD/PU2a/yEP/Y7u5fqHsyj22UI8
BG+i/qusWTGbBDva6Rv72uGMiqVtHLOUManu22zSfzAv7Pyj86jW2Jb+K64BgJm5
aAV7fjorKegsezmBcPmh4IwufWuXWpJ257E8YoI3/PkboQFRGGK1wWkLF15rYWgm
C/KlDnzU/7m3yduoXyptut4MEfLI73d1AncQosZUw3LptC7E6+0x7zywBGm5CxrP
s9g+TO38cE53MOt3r1yV
=9HBk
-----END PGP SIGNATURE-----

--Sig_/GMQnUCfHxg.+AN2s37K2.oI--
