Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3GYSNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:13:38 -0400
Received: from home.keithp.com ([63.227.221.253]:56168 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756367Ab3GYSNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:13:36 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/5] drm/i915: Add async page flip support for IVB
In-Reply-To: <20130725074757.GE5939@phenom.ffwll.local>
References: <1374544202-15496-1-git-send-email-keithp@keithp.com> <1374544202-15496-5-git-send-email-keithp@keithp.com> <20130723052856.GD5939@phenom.ffwll.local> <86li4v3ds7.fsf@miki.keithp.com> <20130724212308.GZ5939@phenom.ffwll.local> <86siz3v2m7.fsf@miki.keithp.com> <20130725074757.GE5939@phenom.ffwll.local>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Thu, 25 Jul 2013 11:13:29 -0700
Message-ID: <86ppu6tsmu.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Daniel Vetter <daniel@ffwll.ch> writes:

> On Wed, Jul 24, 2013 at 06:40:16PM -0700, Keith Packard wrote:
>> Daniel Vetter <daniel@ffwll.ch> writes:
>>=20
>> > We could just unconditionally increase the alignement in
>> > intel_pin_and_fence_fb_obj - we already have more strict requirements =
due
>> > to a bunch of w/a in other places. So shouldn't hurt at all really.
>>=20
>> That seems like a fine plan; 32kB isn't that onerous. Do you want the
>> trivial patch to do this from me then?
>
> Yes please, merging patches from other people is much easier than begging=
 for
> review for my own ;-)
> -Daniel

Here's a replacement for patch #4 that just adds the alignment
requirement there. Do you want any other changes in this series?

From=209a51e7118fce58c835cabb192f6b6e0a4a5f6660 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Mon, 22 Jul 2013 18:12:28 -0700
Subject: [PATCH 4/5] drm/i915: Add async page flip support for IVB

This adds the necesary register defines for async page flipping
through the command ring, and then hooks those up for Ivybridge (gen7)
page flipping.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/i915_reg.h      |  6 +++++
 drivers/gpu/drm/i915/intel_display.c | 46 ++++++++++++++++++++++++++++++++=
----
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_re=
g.h
index dc3d6a7..029cfb0 100644
=2D-- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -209,6 +209,7 @@
 #define MI_LOAD_SCAN_LINES_INCL MI_INSTR(0x12, 0)
 #define MI_DISPLAY_FLIP		MI_INSTR(0x14, 2)
 #define MI_DISPLAY_FLIP_I915	MI_INSTR(0x14, 1)
+#define   MI_DISPLAY_FLIP_ASYNC_INDICATOR	(1 << 22)
 #define   MI_DISPLAY_FLIP_PLANE(n) ((n) << 20)
 /* IVB has funny definitions for which plane to flip. */
 #define   MI_DISPLAY_FLIP_IVB_PLANE_A  (0 << 19)
@@ -217,6 +218,11 @@
 #define   MI_DISPLAY_FLIP_IVB_SPRITE_B (3 << 19)
 #define   MI_DISPLAY_FLIP_IVB_PLANE_C  (4 << 19)
 #define   MI_DISPLAY_FLIP_IVB_SPRITE_C (5 << 19)
+/* These go in the bottom of the base address value */
+#define   MI_DISPLAY_FLIP_TYPE_SYNC    (0 << 0)
+#define   MI_DISPLAY_FLIP_TYPE_ASYNC   (1 << 0)
+#define   MI_DISPLAY_FLIP_TYPE_STEREO  (2 << 0)
+#define   MI_DISPLAY_FLIP_TYPE_SYNCHRONOUS	(0 << 0)
 #define MI_ARB_ON_OFF		MI_INSTR(0x08, 0)
 #define   MI_ARB_ENABLE			(1<<0)
 #define   MI_ARB_DISABLE		(0<<0)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index bdb8854..f2624a4 100644
=2D-- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1833,8 +1833,10 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
 			alignment =3D 64 * 1024;
 		break;
 	case I915_TILING_X:
=2D		/* pin() will align the object as required by fence */
=2D		alignment =3D 0;
+		/* Async page flipping requires X tiling and 32kB alignment, so just
+		 * make all X tiled frame buffers aligned for that
+		 */
+		alignment =3D 32 * 1024;
 		break;
 	case I915_TILING_Y:
 		/* Despite that we check this in framebuffer_init userspace can
@@ -7514,6 +7516,8 @@ static int intel_gen7_queue_flip(struct drm_device *d=
ev,
 	struct intel_crtc *intel_crtc =3D to_intel_crtc(crtc);
 	struct intel_ring_buffer *ring =3D &dev_priv->ring[BCS];
 	uint32_t plane_bit =3D 0;
+	uint32_t cmd;
+	uint32_t base;
 	int ret;
=20
 	ret =3D intel_pin_and_fence_fb_obj(dev, obj, ring);
@@ -7536,13 +7540,43 @@ static int intel_gen7_queue_flip(struct drm_device =
*dev,
 		goto err_unpin;
 	}
=20
+	cmd =3D MI_DISPLAY_FLIP_I915 | plane_bit;
+	base =3D i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspaddr_offset;
+
+	if (flags & DRM_MODE_PAGE_FLIP_ASYNC) {
+
+		/* XXX check limitations for async flip here */
+
+		if (fb->pitches[0] !=3D I915_READ(DSPSTRIDE(intel_crtc->plane))) {
+			WARN_ONCE(1, "mismatching stride in async plane flip (%d !=3D %d)\n",
+				  fb->pitches[0], I915_READ(DSPSTRIDE(intel_crtc->plane)));
+			ret =3D -EINVAL;
+			goto err_unpin;
+		}
+
+		if (obj->tiling_mode !=3D I915_TILING_X) {
+			WARN_ONCE(1, "async plane flip requires X tiling\n");
+			ret =3D -EINVAL;
+			goto err_unpin;
+		}
+
+		if ((I915_READ(DSPCNTR(intel_crtc->plane)) & DISPPLANE_TILED) =3D=3D 0) {
+			WARN_ONCE(1, "display not currently tiled in async plane flip\n");
+			ret =3D -EINVAL;
+			goto err_unpin;
+		}
+=09=09
+		cmd |=3D MI_DISPLAY_FLIP_ASYNC_INDICATOR;
+		base |=3D MI_DISPLAY_FLIP_TYPE_ASYNC;
+	}
+
 	ret =3D intel_ring_begin(ring, 4);
 	if (ret)
 		goto err_unpin;
=20
=2D	intel_ring_emit(ring, MI_DISPLAY_FLIP_I915 | plane_bit);
+	intel_ring_emit(ring, cmd);
 	intel_ring_emit(ring, (fb->pitches[0] | obj->tiling_mode));
=2D	intel_ring_emit(ring, i915_gem_obj_ggtt_offset(obj) + intel_crtc->dspad=
dr_offset);
+	intel_ring_emit(ring, base);
 	intel_ring_emit(ring, (MI_NOOP));
=20
 	intel_mark_page_flip_active(intel_crtc);
@@ -9705,6 +9739,10 @@ void intel_modeset_init(struct drm_device *dev)
 		dev->mode_config.max_width =3D 8192;
 		dev->mode_config.max_height =3D 8192;
 	}
+
+	if (IS_GEN7(dev))
+		dev->mode_config.async_page_flip =3D true;
+
 	dev->mode_config.fb_base =3D dev_priv->gtt.mappable_base;
=20
 	DRM_DEBUG_KMS("%d display pipe%s available.\n",
=2D-=20
1.8.3.2



=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUfFqyTYtFsjWk68qAQi8vw//eLIZB6G1D7cHP1L/IoNmJ05EFNBjkC5M
c+P4rCGioOaCTboe3AR8fMbD4QxiWzleKjCmNpZgQv6OXJhVJnfiOUFFmzCVz2un
JtzmFhFRiwgncvOPfB48twQmlGS4tD+pA2gtlnXf7Xi0pruljzS237COM9+DNCQr
8F5SAnV5at19Bf4OVZruGDSDlUXtT+qhdxwv/vCD1crPOxjisXpKxyKJ/4GX+5V3
F+7ctnPe0wvuyu+P+Cjy9egitxYyRlzOQ9mlwTrMcUBeFSr9Yq92Ei32OSLmryDs
4M7ybFoVeKpEftsE8uoPStdq8UGEz2MGj8OD02KJnzBtgcUaSm7w2pggTmNAqD51
lUFEK4Tkeudv7yPCmy6YA9DitsPVdo/d3nfleBURh7YQSy7i38RuLL78aQy1k9C6
VcH5NSfWkro1RcUu5qu8N5fyv2YMCmepqBachqUjV7KqdW1Vhl3dkbMqQciKaWp2
/Wpi1NTPb4hou84r0tWlOcZ4T2Q5KlYpcxmOIfOdkZs0wcoiQSuu3I+jZukYm8dF
Ti6xNGUplHsfAWAPXr9PWXAnNMFXnCBq6aeKDu1pS3U/q7Gd7GLtnqkVmd/snopg
99xSUGG/C6E692EpJ8n5FLxkASvx1B4G2CBvWx09WybXJXVXSix3Tdj/Xi+mJC4Y
RtnARuz9F+s=
=lVSc
-----END PGP SIGNATURE-----
--=-=-=--
