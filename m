Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3ITBk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 21:40:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35046 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3ITBk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 21:40:27 -0400
Date: Fri, 20 Sep 2013 11:40:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130920114015.c784be4edbe5cb12125858ed@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Sep_2013_11_40_15_+1000_7PZsNuX2qbXEpqPr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Sep_2013_11_40_15_+1000_7PZsNuX2qbXEpqPr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit cc173961a680
("drm/i915: do not update cursor in crtc mode set") from the
drm-intel-fixes tree and commit e9fd1c02aca7 ("drm/i915: don't enable
DPLL for DSI") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_display.c
index d8a1d98,2ed974e..0000000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -4863,21 -4915,27 +4915,24 @@@ static int i9xx_crtc_mode_set(struct dr
 =20
  	refclk =3D i9xx_get_refclk(crtc, num_connectors);
 =20
- 	/*
- 	 * Returns a set of divisors for the desired target clock with the given
- 	 * refclk, or FALSE.  The returned values represent the clock equation:
- 	 * reflck * (5 * (m1 + 2) + (m2 + 2)) / (n + 2) / p1 / p2.
- 	 */
- 	limit =3D intel_limit(crtc, refclk);
- 	ok =3D dev_priv->display.find_dpll(limit, crtc,
- 					 intel_crtc->config.port_clock,
- 					 refclk, NULL, &clock);
- 	if (!ok && !intel_crtc->config.clock_set) {
- 		DRM_ERROR("Couldn't find PLL settings for mode!\n");
- 		return -EINVAL;
+ 	if (!is_dsi && !intel_crtc->config.clock_set) {
+ 		/*
+ 		 * Returns a set of divisors for the desired target clock with
+ 		 * the given refclk, or FALSE.  The returned values represent
+ 		 * the clock equation: reflck * (5 * (m1 + 2) + (m2 + 2)) / (n +
+ 		 * 2) / p1 / p2.
+ 		 */
+ 		limit =3D intel_limit(crtc, refclk);
+ 		ok =3D dev_priv->display.find_dpll(limit, crtc,
+ 						 intel_crtc->config.port_clock,
+ 						 refclk, NULL, &clock);
+ 		if (!ok && !intel_crtc->config.clock_set) {
+ 			DRM_ERROR("Couldn't find PLL settings for mode!\n");
+ 			return -EINVAL;
+ 		}
  	}
 =20
- 	if (is_lvds && dev_priv->lvds_downclock_avail) {
 -	/* Ensure that the cursor is valid for the new mode before changing... */
 -	intel_crtc_update_cursor(crtc, true);
 -
+ 	if (!is_dsi && is_lvds && dev_priv->lvds_downclock_avail) {
  		/*
  		 * Ensure we match the reduced clock's P to the target clock.
  		 * If the clocks don't match, we can't switch the display clock
@@@ -8199,11 -8377,11 +8371,12 @@@ static void intel_dump_pipe_config(stru
  		      pipe_config->gmch_pfit.control,
  		      pipe_config->gmch_pfit.pgm_ratios,
  		      pipe_config->gmch_pfit.lvds_border_bits);
 -	DRM_DEBUG_KMS("pch pfit: pos: 0x%08x, size: 0x%08x\n",
 +	DRM_DEBUG_KMS("pch pfit: pos: 0x%08x, size: 0x%08x, %s\n",
  		      pipe_config->pch_pfit.pos,
 -		      pipe_config->pch_pfit.size);
 +		      pipe_config->pch_pfit.size,
 +		      pipe_config->pch_pfit.enabled ? "enabled" : "disabled");
  	DRM_DEBUG_KMS("ips: %i\n", pipe_config->ips_enabled);
+ 	DRM_DEBUG_KMS("double wide: %i\n", pipe_config->double_wide);
  }
 =20
  static bool check_encoder_cloning(struct drm_crtc *crtc)

--Signature=_Fri__20_Sep_2013_11_40_15_+1000_7PZsNuX2qbXEpqPr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSO6eDAAoJEECxmPOUX5FEW68P/1WKC7PMerNxVHiNCBIN8nUV
5vHi4BJfQnfmiYhJ4HxbdridXrbdc6Uf99a/YOh8E/XpXT6hKg7RbL8boAT1/dVq
uW1hE7rent5QEWyXo28H9UXICmySOTe5axVFVrmW5EMtdLnkecJpzgHFJ5Wqi4qs
R8hlIErZnOmmp5pXPyIehPWfGAow54XosFcgfUHIdYgR8a3NSuTNaoZKJRH0j+qF
kuh28PkMp27xVHYJN5Un6kBml2flw+UJgeLZLEU44CUwyt75RFwqq1+agsINepei
DJBw2ZAepkVIxmhqgNo8z8z0xo0fgUUzjdbCaDzrDn3WRGbRNxmcYjCsFZSV5jUc
aiLVJYE7h5538vGt1a8yhvJ/TZJYTNrIhGx7SZgpPasy6aIxMf6jknDHlSs3NpSW
Kb1ASPl98WD5f78J+72jBirXAUYcavEpiw3ZraQyQZo+SBBTSZ6V5FkCOtI0JStN
ZVdprdrG6NBGLgODzcRz+06vJiEHKVhYALwVCzB9jHGZRH1mIqXb3o7qPTBllqnf
e8mB+ukydnmygKrO3RTYF2r+x4QoBtG8yBYLRP399q4/+h81qNR16IPSduSG4Yav
UoiGMfXSyUwR5nZHmP2UPdT3dzIXlm8MiCOdt9ve/oSf7WGzY12Z08hm9K/p269s
8lehul0aOIM9UaGg0tYe
=njNT
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Sep_2013_11_40_15_+1000_7PZsNuX2qbXEpqPr--
