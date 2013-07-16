Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3GPCFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:05:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40655 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab3GPCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:05:36 -0400
Date: Tue, 16 Jul 2013 12:05:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130716120523.32e132972134f55a0655d3c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_12_05_23_+1000_NoX30Asz.kNAkGtd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_12_05_23_+1000_NoX30Asz.kNAkGtd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commits 19b2dbde5732
("drm/i915: Restore fences after resume and GPU resets") from Linus' tree
and d18b96190342 ("drm/i915: Fix incoherence with fence updates on
Sandybridge+") from the drm-intel-fixes tree and commits f343c5f64773
("drm/i915: Getter/setter for object attributes") and db1b76ca6a79
("drm/i915: don't frob mm.suspended when not using ums") from the
drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index 97afd26,20b10a0..0000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -2666,27 -2673,12 +2665,27 @@@ static void i965_write_fence_reg(struc
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
@@@ -3992,11 -4008,8 +3980,6 @@@ i915_gem_idle(struct drm_device *dev
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

--Signature=_Tue__16_Jul_2013_12_05_23_+1000_NoX30Asz.kNAkGtd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5KpnAAoJEECxmPOUX5FEaDwP/A6ByAaF5QwOunTILeDsz+Gw
0u1E7niw0vh4eSKmQe/P/KMJ0z6b0ZRQEfee+vVloZH3IgDwmCmWqBEWToZ86czy
/gcuWuYd/jN7Kwxg6iYzYgJfC1yCj987ngeFEhnataUiJcalUXOZwJoH4nQ3Tavj
EWr8PSP80bKgXlgTNRmmvx5LaZ+28ivOKjRBaiuHYbhkfs5vwycIEx400jHAFDjx
RQpAK0QHrKtSfka+LVOWWmHToQtzkICGZfchviiOCQU8NGDcvqyIfU9ZnNetPSEm
yqiuySs6OrbownmrEjphjpc0yxsRQcWUgY1O26NOZgZIZTa/MclaMiyI4515/wOX
7NAWFfFLtOsgjEBa+weY63cVx+akpdXJjXJjN1Ism9CyCUeE/wWSRTypi+Uv9NYs
kHzHLMvwIuM6LxEz63Gsx7dXU9OGN8QPl376FjGUpc+eGbeW2xEnt8xFPQP7ZSAD
R1tDditg3YV8kTc7FJq9RfJze4g6heDXCJ7ojysPdAEJ2jrpiJDirEEXtQYqOeip
Bx4y6yIvMSyyg7VPptvV+B7EWi21wDS+tJjpMWPgLykOb9SDLbQlJrfxXY3jFbXt
vxLtzWM0YQbNTI+foSndvyEFCLZKJgE2HQ2+uzZBGLhPMGbsySjHa1azFslLwmvx
v1/zxjAuNEomQ1AKuPzT
=LOWI
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_12_05_23_+1000_NoX30Asz.kNAkGtd--
