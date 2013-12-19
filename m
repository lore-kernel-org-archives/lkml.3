Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3LSCJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:09:32 -0500
Received: from ozlabs.org ([203.10.76.45]:59527 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab3LSCJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:09:31 -0500
Date: Thu, 19 Dec 2013 13:09:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131219130926.88df43815bf7c642e2c5c357@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Dec_2013_13_09_26_+1100_8ix7TC_Jq5fPR0Fb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Dec_2013_13_09_26_+1100_8ix7TC_Jq5fPR0Fb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/staging/imx-drm/imx-drm-core.c between commit 8007875f0619
("imx-drm: imx-drm-core: fix DRM cleanup paths") from Linus' tree and
commit 9076dccfc532 ("drm/imx: directly call drm_put_dev in ->remove")
from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/imx-drm/imx-drm-core.c
index 96e4eee344ef,0507b662ae40..000000000000
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@@ -443,19 -441,14 +443,21 @@@ static int imx_drm_driver_load(struct d
  	 */
  	imxdrm->drm->vblank_disable_allowed =3D true;
 =20
 -	if (!imx_drm_device_get())
 +	if (!imx_drm_device_get()) {
  		ret =3D -EINVAL;
 +		goto err_vblank;
 +	}
 =20
+ 	platform_set_drvdata(drm->platformdev, drm);
+=20
 -	ret =3D 0;
 +	mutex_unlock(&imxdrm->mutex);
 +	return 0;
 =20
 -err_init:
 +err_vblank:
 +	drm_vblank_cleanup(drm);
 +err_kms:
 +	drm_kms_helper_poll_fini(drm);
 +	drm_mode_config_cleanup(drm);
  	mutex_unlock(&imxdrm->mutex);
 =20
  	return ret;

--Signature=_Thu__19_Dec_2013_13_09_26_+1100_8ix7TC_Jq5fPR0Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSslVZAAoJEMDTa8Ir7ZwVlrcP/RSuaOr7TY1MDMcZlqEvytgj
7vRL4QT1TAwc+Q5ZtTtL+STORl6CXXTTsTwPkzeaRlABIc7iyoUWsfd0WgDX7G9Y
WWpX5HJqZxr/vUsagDqH22UVAhAsVI8LS8mS8Jl5z3DuECw8IJqgTpZv6VjYcEPq
G4W71eJj9NMjs5M4/TKMGN/Gkc26eYEXCU0OXP3DtIFOkbzyqFt3RHvW0DcF3EHm
VHzBVlvEr1HIy4+ZMtNhIHIPBqWpASRuIxwzSw0OkDYHu+vkcah458Q7s+Yh/B/a
MRepsbL4vyyjkavaNM0OyLCqmiKEFOWiqzZVhD+ERZvRa2l2A2b886LDRaI/oEK+
8zzcei+6FCib+oOwDEZ0CvFaHpCxF8OfsV3WIu1yzk/jStHRCCeRU3SZf40jWcDE
Pi882rJinlJDPR0lzO2WlGQWR+j1CW2LmWNNx7rfWBGpS0v1/oIuLk2GDmKbbfFo
BJjLfJgscLA4O6VP+abT0DA4MSsS+hCyclmGiW/eg8TWSCRvRB8smsQC6b3XQxKJ
MKSLXJdC3pJtdLLubNn9m1BN4w72LES2U73Zpd7rKIFp8LDt0RK3kbD45BMitK0P
YN7wXJd8Pni41rWznpXvPNNU/Y/v9KXveYoGbQxcd7arE+zHaGSZl/atzghiMMLg
HKyRN2RYU2hACXxwxtpS
=hJb0
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Dec_2013_13_09_26_+1100_8ix7TC_Jq5fPR0Fb--
