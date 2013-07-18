Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab3GRCHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 22:07:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55930 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab3GRCHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 22:07:16 -0400
Date: Thu, 18 Jul 2013 12:07:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>, Ben Widawsky <ben@bwidawsk.net>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130718120711.0a004a1226836e4c22807908@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Jul_2013_12_07_11_+1000_x9E8IbeJ8SLsrgod"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jul_2013_12_07_11_+1000_x9E8IbeJ8SLsrgod
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commit 067556084a0e ("drm/i915:
Correct obj->mm_list link to dev_priv->dev_priv->mm.inactive_list") from
the drm-intel-fixes tree and commit 5cef07e16283 ("drm/i915: Move
active/inactive lists to new mm") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index 97afd26,9a523df..0000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -2275,14 -2282,11 +2276,10 @@@ void i915_gem_reset(struct drm_device *
  	/* Move everything out of the GPU domains to ensure we do any
  	 * necessary invalidation upon reuse.
  	 */
- 	list_for_each_entry(obj,
- 			    &dev_priv->mm.inactive_list,
- 			    mm_list)
- 	{
+ 	list_for_each_entry(obj, &vm->inactive_list, mm_list)
  		obj->base.read_domains &=3D ~I915_GEM_GPU_DOMAINS;
- 	}
 =20
 -	/* The fence registers are invalidated so clear them out */
 -	i915_gem_reset_fences(dev);
 +	i915_gem_restore_fences(dev);
  }
 =20
  /**
@@@ -2666,27 -2679,12 +2671,27 @@@ static void i965_write_fence_reg(struc
  		fence_pitch_shift =3D I965_FENCE_PITCH_SHIFT;
  	}
 =20
 +	fence_reg +=3D reg * 8;
 +
 +	/* To w/a incoherency with non-atomic 64-bit register updates,
 +	 * we split the 64-bit update into two 32-bit writes. In order
 +	 * for a partial fence not to be evaluated between writes, we
 +	 * precede the update with write to turn off the fence register,
 +	 * and only enable the fence as the last step.
 +	 *
 +	 * For extra levels of paranoia, we make sure each step lands
 +	 * before applying the next step.
 +	 */
 +	I915_WRITE(fence_reg, 0);
 +	POSTING_READ(fence_reg);
 +
  	if (obj) {
- 		u32 size =3D obj->gtt_space->size;
+ 		u32 size =3D i915_gem_obj_ggtt_size(obj);
 +		uint64_t val;
 =20
- 		val =3D (uint64_t)((obj->gtt_offset + size - 4096) &
+ 		val =3D (uint64_t)((i915_gem_obj_ggtt_offset(obj) + size - 4096) &
  				 0xfffff000) << 32;
- 		val |=3D obj->gtt_offset & 0xfffff000;
+ 		val |=3D i915_gem_obj_ggtt_offset(obj) & 0xfffff000;
  		val |=3D (uint64_t)((obj->stride / 128) - 1) << fence_pitch_shift;
  		if (obj->tiling_mode =3D=3D I915_TILING_Y)
  			val |=3D 1 << I965_FENCE_TILING_Y_SHIFT;
@@@ -3992,11 -4050,8 +4022,6 @@@ i915_gem_idle(struct drm_device *dev
  	if (!drm_core_check_feature(dev, DRIVER_MODESET))
  		i915_gem_evict_everything(dev);
 =20
- 	/* Hack!  Don't let anybody do execbuf while we don't control the chip.
- 	 * We need to replace this with a semaphore, or something.
- 	 * And not confound mm.suspended!
- 	 */
- 	dev_priv->mm.suspended =3D 1;
 -	i915_gem_reset_fences(dev);
 -
  	del_timer_sync(&dev_priv->gpu_error.hangcheck_timer);
 =20
  	i915_kernel_lost_context(dev);
@@@ -4594,7 -4664,7 +4635,7 @@@ i915_gem_inactive_shrink(struct shrinke
  	list_for_each_entry(obj, &dev_priv->mm.unbound_list, global_list)
  		if (obj->pages_pin_count =3D=3D 0)
  			cnt +=3D obj->base.size >> PAGE_SHIFT;
- 	list_for_each_entry(obj, &dev_priv->mm.inactive_list, mm_list)
 -	list_for_each_entry(obj, &vm->inactive_list, global_list)
++	list_for_each_entry(obj, &vm->inactive_list, mm_list)
  		if (obj->pin_count =3D=3D 0 && obj->pages_pin_count =3D=3D 0)
  			cnt +=3D obj->base.size >> PAGE_SHIFT;
 =20

--Signature=_Thu__18_Jul_2013_12_07_11_+1000_x9E8IbeJ8SLsrgod
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR503PAAoJEECxmPOUX5FEs7cP/i+piN6J6RqyF7EOBkXSZNgr
De9tXZgztCtzRg0DxNHH2Htm8FLTB23QuCso3XZiaU6nsIF2qHR9r+2EPBWzunID
vNF0vn4vMcgRHSafez1BW+wG79YQbyR2qJXBStqOyAVDKPnFBRUpGU9pnu+HX6CQ
mCb/zd0L5PHhWawW1TvbMnKuCXxnfW6F0xFBb4e2chUQmqe6qY2jDU82R3kk8STA
28OSQC3LPWiYEonQP3X24Sho+j9TOB7AgFFK+UeYbkm7HYRDPE7+Vlfib/6J6DcG
UOQqGlkAl44bYDueG9DFiyypErzDtAUvVQQej2GUDLm+KfyCO424a0GwYPz3u/jC
gL4gKjBo4NFA1DGR+oDK3fQ996E902z7n5z6WRWYLKb182JhVPeaahIn7L5WBSAQ
a7WhJLPYe0iJ99AlTj/59W5LGEg/uV/1LwcSIqJgpr/P8HKuklP+83ytuzQNvSxG
bvO7HdzjioBWGuUdx4z2GBElL4ofQ1FuNLQ6RxU7vRh5sdcIMeriRoscggI01kht
gXe0U9q1W7fIRjuCxaWHPRvqxod+xTPT5Z5erJs3AY0AXuZulrx0esRtER32ZiGO
4YkcffPygUnWdrhFbKuJ1PCb/dpOCfk31wwfYMA0aqEPDq/lByFhZ6MQLwPy6F+L
wS90DVwQ0xCue7/qwGy0
=Niv8
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jul_2013_12_07_11_+1000_x9E8IbeJ8SLsrgod--
