Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab3JJQwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:52:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57848 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3JJQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:52:37 -0400
Date: Thu, 10 Oct 2013 17:51:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Jani Nikula <jani.nikula@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131010165157.GP21581@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9RHkgBN4Ly9iZsmR"
Content-Disposition: inline
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the drm-intel tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9RHkgBN4Ly9iZsmR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today's linux-next merge of the drm-intel tree got additional conflicts
in drivers/gpu/drm/i915/intel_drv.h as a result of interactions between
6aba5b6cf098 (drm/i915/dp: get rid of intel_dp->link_configuration) and
various commits from Paulo Zanoni staticising functions.  I've fixed up
by changing the resolution to that below and can carry:

diff --cc drivers/gpu/drm/i915/i915_dma.c
index 637b695,df6efbf..0c86c48
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@@ -1330,9 -1333,11 +1333,11 @@@ static int i915_load_modeset_init(struc
 =20
  	/* Always safe in the mode setting case. */
  	/* FIXME: do pre/post-mode set stuff in core KMS code */
 -	dev->vblank_disable_allowed =3D 1;
 +	dev->vblank_disable_allowed =3D true;
- 	if (INTEL_INFO(dev)->num_pipes =3D=3D 0)
+ 	if (INTEL_INFO(dev)->num_pipes =3D=3D 0) {
+ 		intel_display_power_put(dev, POWER_DOMAIN_VGA);
  		return 0;
+ 	}
 =20
  	ret =3D intel_fbdev_init(dev);
  	if (ret)
@@@ -1473,7 -1480,14 +1480,7 @@@ int i915_driver_load(struct drm_device=20
  	if (info->gen >=3D 6 && !drm_core_check_feature(dev, DRIVER_MODESET))
  		return -ENODEV;
 =20
- 	dev_priv =3D kzalloc(sizeof(drm_i915_private_t), GFP_KERNEL);
 -	/* i915 has 4 more counters */
 -	dev->counters +=3D 4;
 -	dev->types[6] =3D _DRM_STAT_IRQ;
 -	dev->types[7] =3D _DRM_STAT_PRIMARY;
 -	dev->types[8] =3D _DRM_STAT_SECONDARY;
 -	dev->types[9] =3D _DRM_STAT_DMA;
 -
+ 	dev_priv =3D kzalloc(sizeof(*dev_priv), GFP_KERNEL);
  	if (dev_priv =3D=3D NULL)
  		return -ENOMEM;
 =20
diff --cc drivers/gpu/drm/i915/intel_dp.c
index 98f3b64,f831464..c392ad2
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -1532,8 -1558,8 +1541,8 @@@ static void intel_edp_psr_setup(struct=20
  	intel_edp_psr_write_vsc(intel_dp, &psr_vsc);
 =20
  	/* Avoid continuous PSR exit by masking memup and hpd */
- 	I915_WRITE(EDP_PSR_DEBUG_CTL, EDP_PSR_DEBUG_MASK_MEMUP |
+ 	I915_WRITE(EDP_PSR_DEBUG_CTL(dev), EDP_PSR_DEBUG_MASK_MEMUP |
 -		   EDP_PSR_DEBUG_MASK_HPD);
 +		   EDP_PSR_DEBUG_MASK_HPD | EDP_PSR_DEBUG_MASK_LPSP);
 =20
  	intel_dp->psr_setup_done =3D true;
  }

--9RHkgBN4Ly9iZsmR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVtspAAoJELSic+t+oim9xy4P/2U3KAyMFC9/TJZP6H+Fttb4
Ojv6xQsg7zELYqQJcr8D6O9ymD9GpBCQbi64G1hkXRAPGQ4DH5Jf+DWV8/TPnuM4
I5mBbll3fvurICyxvk0t7TRqVpZCsGMlsIVfiYfnTKCI7gd1RRbvWsxtYFCryopU
NdCyj34lXxVurzKivyByBkIlTAlQ5SXVhA4KveFApuF2t0D10tSq55C0yjr+hhHt
WLX0xit6H+xpJ/ZQTYPcF0uk3L6VpUjh6METoJ9VArWNnzA0DA0qbXMj3oFE9s+U
bIOD0ewydVweDk9zuMP1UFOIXvi+jFz8bi+ifBMMLYRUkXVxsEc/AUDs1jIUwNLO
toIIk+CB4VyV9ILf49KOnxN41mIiboPmDChQSXN93qdeBd2I/LSIe6sOb7MIVLe+
VrXyGzdoQ/eaiadgokxjnja5fUsyE/qOSYgw4b5uN4YjbHjmn8fzxxlbVOK7o28b
cLEYc+gzSrFoIWelgtVxLsKqZKxtGdWmgIutjta9licA2kScNlotV1a069BCF4LU
FF+M/CT4i0N3zxujFY2nIpNC+aRxy7keBqp022DWCgtxuySd3zhFQLrtvMx3cnoL
hmimXpPPP59UOo7z4OXjVLV9TB7mvi81x3PjNy1GGR2TbLz989p7yDew4l9t1mRO
KOpiKw0vNacjIdsHjatg
=p00h
-----END PGP SIGNATURE-----

--9RHkgBN4Ly9iZsmR--
