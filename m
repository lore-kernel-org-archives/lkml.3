Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3J1FqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:46:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45583 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3J1FqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:46:20 -0400
Date: Mon, 28 Oct 2013 16:46:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>
Subject: linux-next: manual merge of the drm tree with the drm-intel-fixes
 tree
Message-Id: <20131028164609.bdec95d18a41b59fc37fbae1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_16_46_09_+1100_ZlVbvqtM.l9TiRMz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_16_46_09_+1100_ZlVbvqtM.l9TiRMz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_dp.c between commit 0cc4b69960f3 ("drm/i915:
Mask LPSP to get PSR working even with Power Well in use by audio") from
Linus' tree and commit 52e1e223456e ("drm/i915/dp: workaround BIOS eDP
bpp clamping issue") from the drm-intel-fixes tree and commits
18442d087864 ("drm/i915: Fix port_clock and adjusted_mode.clock readout
all over") and 18b5992c3756 ("drm/i915: Calculate PSR register offsets
from base + gen") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_dp.c
index 1a431377d83b,1e3d2720d811..000000000000
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -1402,31 -1469,20 +1469,40 @@@ static void intel_dp_get_config(struct=20
  			pipe_config->port_clock =3D 270000;
  	}
 =20
 +	if (is_edp(intel_dp) && dev_priv->vbt.edp_bpp &&
 +	    pipe_config->pipe_bpp > dev_priv->vbt.edp_bpp) {
 +		/*
 +		 * This is a big fat ugly hack.
 +		 *
 +		 * Some machines in UEFI boot mode provide us a VBT that has 18
 +		 * bpp and 1.62 GHz link bandwidth for eDP, which for reasons
 +		 * unknown we fail to light up. Yet the same BIOS boots up with
 +		 * 24 bpp and 2.7 GHz link. Use the same bpp as the BIOS uses as
 +		 * max, not what it tells us to use.
 +		 *
 +		 * Note: This will still be broken if the eDP panel is not lit
 +		 * up by the BIOS, and thus we can't get the mode at module
 +		 * load.
 +		 */
 +		DRM_DEBUG_KMS("pipe has %d bpp for eDP panel, overriding BIOS-provided =
max %d bpp\n",
 +			      pipe_config->pipe_bpp, dev_priv->vbt.edp_bpp);
 +		dev_priv->vbt.edp_bpp =3D pipe_config->pipe_bpp;
 +	}
++
+ 	dotclock =3D intel_dotclock_calculate(pipe_config->port_clock,
+ 					    &pipe_config->dp_m_n);
+=20
+ 	if (HAS_PCH_SPLIT(dev_priv->dev) && port !=3D PORT_A)
+ 		ironlake_check_encoder_dotclock(pipe_config, dotclock);
+=20
+ 	pipe_config->adjusted_mode.crtc_clock =3D dotclock;
  }
 =20
- static bool is_edp_psr(struct intel_dp *intel_dp)
+ static bool is_edp_psr(struct drm_device *dev)
  {
- 	return is_edp(intel_dp) &&
- 		intel_dp->psr_dpcd[0] & DP_PSR_IS_SUPPORTED;
+ 	struct drm_i915_private *dev_priv =3D dev->dev_private;
+=20
+ 	return dev_priv->psr.sink_support;
  }
 =20
  static bool intel_edp_is_psr_enabled(struct drm_device *dev)
@@@ -1486,8 -1542,8 +1562,8 @@@ static void intel_edp_psr_setup(struct=20
  	intel_edp_psr_write_vsc(intel_dp, &psr_vsc);
 =20
  	/* Avoid continuous PSR exit by masking memup and hpd */
 -	I915_WRITE(EDP_PSR_DEBUG_CTL(dev), EDP_PSR_DEBUG_MASK_MEMUP |
 +	I915_WRITE(EDP_PSR_DEBUG_CTL, EDP_PSR_DEBUG_MASK_MEMUP |
- 		   EDP_PSR_DEBUG_MASK_HPD | EDP_PSR_DEBUG_MASK_LPSP);
+ 		   EDP_PSR_DEBUG_MASK_HPD);
 =20
  	intel_dp->psr_setup_done =3D true;
  }

--Signature=_Mon__28_Oct_2013_16_46_09_+1100_ZlVbvqtM.l9TiRMz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbfolAAoJEMDTa8Ir7ZwV+C0P/0p/tGfVKK1ry41dhKKSjgGE
tOJ2oYRvmTLi3BJpKU+pKR5K1rjAAB5KG+a3F8kPwjvnNWfTLwvlDTsg2+cApIMR
tThaQqPkOBuhUlpwA5GhqhZw5mnpwwLke35Cn35u1/XxgSX4nmzVJm4/cjIaluMw
9mYYVa9pE00k8dvdIR+65PbO7fSnZdNb8B8BBCmYbIAvhZpzPKlMPM+Qd2N+4PLB
+bSr/vMGXxnd1KqdTdUSV8PuxDQt1BMJR7mxqBrlJ02cvRaWgiIkjTndyhRaBxNE
68kx4kUi3ShFOZT5pi1+y0+jmrsY2FUu5qnJwoM0kM444f1/Qhiu21X6bbQwsi35
2CWNAkDcJ3kw75u8MLj5kwJ4FUoPqGnBAsPPXr+5ZeZ81ahGBjr9cEUD8YViTOcm
RfcVpJGv7Ghh0mQbgJ7IhNCqcGLiBvFBSU2QLLZLfARKgbPjb+0EHb/Dmrqzg8gw
46Z7Di7JCbq1BLM40wPC/VnYh/Lk+OJFUDWzeSaKjoupuRuSL+pyXQAnCfbHChOf
xjTR/FjFWtr/hHy+XCFRxiXNgfh8rkmQCFBQG4jm3wIwtU8ykY+2kn/y1XfkSbph
NGcoeLf9A10BhbG5Aho1eM0rUdyCs98r/FTaeJC8tPxyUrkGq3rItNRqi2Slr1iK
01BjmFN3lilpUvctLVnz
=Tlzc
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_16_46_09_+1100_ZlVbvqtM.l9TiRMz--
