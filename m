Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbaGWDSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:18:32 -0400
Received: from ozlabs.org ([103.22.144.67]:43714 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbaGWDSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:18:30 -0400
Date: Wed, 23 Jul 2014 13:18:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-ID: <20140723131822.3d058c1e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uNNKylsmTlb/e=tsHHFmDVV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uNNKylsmTlb/e=tsHHFmDVV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_dp.c between commit b19729617929 ("drm/i915:
fix psr match conditions screw ups") from the drm tree and commit
24acaf94ed4a ("drm/i915: Fix up PSR frontbuffer tracking") from the
drm-intel tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_dp.c
index eda73ea3002f,9274ddfd78c7..000000000000
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -1801,20 -1762,17 +1796,18 @@@ static bool intel_edp_psr_match_conditi
  	struct intel_digital_port *dig_port =3D dp_to_dig_port(intel_dp);
  	struct drm_device *dev =3D dig_port->base.base.dev;
  	struct drm_i915_private *dev_priv =3D dev->dev_private;
 -	struct drm_crtc *crtc =3D dig_port->base.base.crtc;
 -	struct intel_crtc *intel_crtc =3D to_intel_crtc(crtc);
 +	struct drm_crtc *crtc;
 +	struct intel_crtc *intel_crtc;
- 	struct drm_i915_gem_object *obj;
- 	struct intel_encoder *intel_encoder =3D &dp_to_dig_port(intel_dp)->base;
 =20
- 	dev_priv->psr.source_ok =3D false;
+ 	lockdep_assert_held(&dev_priv->psr.lock);
+ 	lockdep_assert_held(&dev->struct_mutex);
+ 	WARN_ON(!drm_modeset_is_locked(&dev->mode_config.connection_mutex));
++	crtc =3D dig_port->base.base.crtc;
+ 	WARN_ON(!drm_modeset_is_locked(&crtc->mutex));
 =20
- 	if (!HAS_PSR(dev)) {
- 		DRM_DEBUG_KMS("PSR not supported on this platform\n");
- 		return false;
- 	}
+ 	dev_priv->psr.source_ok =3D false;
 =20
- 	if (IS_HASWELL(dev) && (intel_encoder->type !=3D INTEL_OUTPUT_EDP ||
- 				dig_port->port !=3D PORT_A)) {
+ 	if (IS_HASWELL(dev) && dig_port->port !=3D PORT_A) {
  		DRM_DEBUG_KMS("HSW ties PSR to DDI A (eDP)\n");
  		return false;
  	}
@@@ -1847,11 -1786,6 +1821,7 @@@
  	if (IS_BROADWELL(dev))
  		goto out;
 =20
- 	if (I915_READ(SPRCTL(intel_crtc->pipe)) & SPRITE_ENABLE) {
- 		DRM_DEBUG_KMS("PSR condition failed: Sprite is Enabled\n");
- 		return false;
- 	}
-=20
++	intel_crtc =3D to_intel_crtc(crtc);
  	if (I915_READ(HSW_STEREO_3D_CTL(intel_crtc->config.cpu_transcoder)) &
  	    S3D_ENABLE) {
  		DRM_DEBUG_KMS("PSR condition failed: Stereo 3D is Enabled\n");
@@@ -3712,10 -3620,7 +3753,8 @@@ intel_dp_detect(struct drm_connector *c
  	enum drm_connector_status status;
  	enum intel_display_power_domain power_domain;
  	struct edid *edid =3D NULL;
 +	bool ret;
 =20
- 	intel_runtime_pm_get(dev_priv);
-=20
  	power_domain =3D intel_display_port_power_domain(intel_encoder);
  	intel_display_power_get(dev_priv, power_domain);
 =20

--Sig_/uNNKylsmTlb/e=tsHHFmDVV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzymDAAoJEMDTa8Ir7ZwV9SUP/jZRQYdhTag7ytu1Nv40Bssx
XZujRmAseEbv/ArDkmaaKEW3ICXeeky4gC4LitSegDG3A4Mc8EUgnlQIGbrreP8Y
tnBiXQSSiQVX2sntSiMHxLMA0ruqsLA+GOxkvg4qhlor8aHMnSCs5R3F05/XYHF5
F5ekmLHnXaLwDCbDJcVObqCjrU77LfQT9GkmOSU+yUYq9i7bpeOOt2gVxb4KbxzG
z6vn2DyMGRAzLo+QgxRQLGcs3PdOccs6nHGoP8gu3vdKy0rZR4b4jy1JUFlX255n
FU0Jzhozz+4W7v5i1WUVMC9dL3D/MA06Nnegnes6gOpONhLaPZFxxiYbOChTKqr7
nUn0H3+aUj8iLw6XYaYqRiXyIvolDVXH/1t8ngf0QMQRs1/IAau8nOMYnQ+00Yuk
UgrSu4nLk/FXhJtImGMID5TDWC3Wt+sK8mY49igTpvx6Prw4Wh2PTEQW2hMSNWpM
YUbD+M6ojpKA3TnUEJMFZrbEwnZYsX3fl7/VApCKqFjRQaUmGw14X8FgqwrBd1PN
Ul5sIDadsczBDZYmqvrRAnoX3bQhNGI8qHmf0dlUrXnlKlcv6OHCmG9nK9P1Kt56
WhWMCKEZasxVIFMF1nSe9tbhAKbWMtepqLtTLGyPLQlewZSFrmgZkh+i7XY5LvsL
Ms7lLdEnrOrtj0KdD3O6
=ZFLF
-----END PGP SIGNATURE-----

--Sig_/uNNKylsmTlb/e=tsHHFmDVV--
