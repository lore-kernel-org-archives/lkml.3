Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaFEDy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 23:54:58 -0400
Received: from ozlabs.org ([103.22.144.67]:57455 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbaFEDy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 23:54:57 -0400
Date: Thu, 5 Jun 2014 13:54:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Antonov <saproj@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20140605135444.713996ce@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lCL+3q_Mcgo0/6wbsvwq2w1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lCL+3q_Mcgo0/6wbsvwq2w1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/drm_crtc_helper.c between commit ba6f58260665
("drm/crtc-helper: skip locking checks in panicking path") from Linus'
tree and commits 6e9f798d91c5 ("drm: Split connection_mutex out of
mode_config.mutex (v3)") and 51fd371bbaf9 ("drm: convert crtc and
connection_mutex to ww_mutex (v5)") from the drm tree.

I fixed it up (not sure if entirely correctly - see below) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_crtc_helper.c
index 872ba11c4533,eb1c062e04b2..000000000000
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@@ -89,13 -88,8 +89,14 @@@ bool drm_helper_encoder_in_use(struct d
  	struct drm_connector *connector;
  	struct drm_device *dev =3D encoder->dev;
 =20
 -	WARN_ON(!mutex_is_locked(&dev->mode_config.mutex));
 -	WARN_ON(!drm_modeset_is_locked(&dev->mode_config.connection_mutex));
 +	/*
 +	 * We can expect this mutex to be locked if we are not panicking.
 +	 * Locking is currently fubar in the panic handler.
 +	 */
- 	if (!oops_in_progress)
++	if (!oops_in_progress) {
 +		WARN_ON(!mutex_is_locked(&dev->mode_config.mutex));
-=20
++		WARN_ON(!drm_modeset_is_locked(&dev->mode_config.connection_mutex));
++	}
  	list_for_each_entry(connector, &dev->mode_config.connector_list, head)
  		if (connector->encoder =3D=3D encoder)
  			return true;


--Sig_/lCL+3q_Mcgo0/6wbsvwq2w1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTj+oNAAoJEMDTa8Ir7ZwVSJEP/jgINrMJyBgsjujoVbrT/zU2
WqzB0vst1l1wpzQKG43dLY74fycYQFnZimmZMZADt9h/Wo3TqKSFvxN0T/AFZmMZ
PAffp9MdQL+uAA3Jhaq6CkX5eU09xUnfQROrZKNY6NygAtNf+wMVipIq0Smtzubo
OtaQEm59oRfnRjCpt3j8eVUmcQJRwcPBOlcRAzZxdWuJko3emDe1wWh/v163hsyy
XQArHTD1HR0nkdeurG+DUYjFykjjPwCPevXPHUBOIg5dqtLKFa1rq1Wvo4aYE5J1
VBKzwqILC9JWj2JKukXW4TgY+88PkNB2Nh7rTxKTjBKETTDB7n5ui1PF3+gj76El
p9UMhBjZf+Ly5its2/LIGqAQMv6aowWikkNlEq1WgKkI51ZdY9YbyeE9TLsdOhPL
0qjGyvkeLmBIyiaaphtfc3qN6suVQf3l0dQNse65Jo7UkI3blW5RqT+TDw/ortdN
6BkTCzn11kntY47sbMH2693xgmmbF4vkP5WmltVwlogfFlfWixprX7NRr6wqSyZb
yfIeywhpcEEun6eg+daLDOGrJGI07O8RsLEJ3ye5IW4rL0HUuwKBOhUXJ6xj+V1g
qbaWL6XPxlw/09QtwOeCFEvp9yeXRskgxlGTOQsLCmhjdqUQyPFmKArG4uCLfJKd
CpiWAlYGW20M4TPjlAL6
=UWdw
-----END PGP SIGNATURE-----

--Sig_/lCL+3q_Mcgo0/6wbsvwq2w1--
