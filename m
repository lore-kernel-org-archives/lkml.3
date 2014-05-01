Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaEAWPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:15:32 -0400
Received: from mout.gmx.net ([212.227.17.20]:52433 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaEAWPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:15:30 -0400
Date: Fri, 2 May 2014 00:11:24 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        Jes.Sorensen@redhat.com, mguzik@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8188eu: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140502001124.4af50742@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/MiDZX2N22nNFuRiFJD7Td3c"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:c646LPBEQnIfUq8Hw5C/FjGtxdvy4tKdQnM4qtPheXiuWZBwEIF
 /s+aK8pUVix6PNXYPlO0NMkUniU7Q4XcFrY7fY9qFQxOcgan/ICfTPUO45r4mB5M+dqObBS
 bVwfYUjoQCXP2NvI4whnXzN3YYWMs6gukzP79DKVb1PSuCqGsZjaw7zTG6fCTc0N03k59JN
 axpAWY4Fs57fbN8qpyNTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MiDZX2N22nNFuRiFJD7Td3c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential leak in the error path of function update_bcn_wps_ie().
Move the affected input verification to the beginning of the function so
that it may return directly without leaking already allocated memory.
Detected by Coverity - CID 1077718.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
v2: Added change suggested by Mateusz Guzik for the rtl8723au variant:

    Move the check before allocating the memory instead of freeing the
    resource afterwards in the error path.

Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8188eu/core/rtw_ap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8=
188eu/core/rtw_ap.c
index ff74d0d..85fda61 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -1306,6 +1306,10 @@ static void update_bcn_wps_ie(struct adapter *padapt=
er)
=20
 	DBG_88E("%s\n", __func__);
=20
+	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
+	if (pwps_ie_src =3D=3D NULL)
+		return;
+
 	pwps_ie =3D rtw_get_wps_ie(ie+_FIXED_IE_LENGTH_, ielen-_FIXED_IE_LENGTH_,=
 NULL, &wps_ielen);
=20
 	if (pwps_ie =3D=3D NULL || wps_ielen =3D=3D 0)
@@ -1323,10 +1327,6 @@ static void update_bcn_wps_ie(struct adapter *padapt=
er)
 			memcpy(pbackup_remainder_ie, premainder_ie, remainder_ielen);
 	}
=20
-	pwps_ie_src =3D pmlmepriv->wps_beacon_ie;
-	if (pwps_ie_src =3D=3D NULL)
-		return;
-
 	wps_ielen =3D (uint)pwps_ie_src[1];/* to get ie data len */
 	if ((wps_offset+wps_ielen+2+remainder_ielen) <=3D MAX_IE_SZ) {
 		memcpy(pwps_ie, pwps_ie_src, wps_ielen+2);
--=20
1.9.1

--Sig_/MiDZX2N22nNFuRiFJD7Td3c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYsaMAAoJEKssnEpaPQKEcukQAJx8QZW7sFA7pMrUmjPCMql/
47HJKTe/OHgLjyDSOVjHAhc5CJRsp1+zblnThrn8rbML/Q201FTAhG7m+8GpqsbB
jy80un5Q578yY2LGRmH19yQk/Krv/7hVziYAUxyDcbiOvibVTiaCq7I/nqxCj34L
bz4iVXqPqjPx7aLiTnTZWQTXskAopjGFh8NHI/ttqUXqqA18ZBRKVthOe/CDEXK0
A7YRZCnoYmAtup97bphEny3yLILMHsL/tZ19Xdht0JT8Bcx/b2Ws3CctK95khRfc
Kjxa9Jn5tp6ilYfbyyLKosVtnrJC2E0m+zPkeZ8VcZKcFkGhtpIXuL/LwUY6naJG
nGdyz8Jd7lWnLS0OajhYL4HySvgjBm8rzuilOfkknqYbSWfXwLhQqxRmXILP8CFc
8ANjqBxRKw9BPK9Krc92CjMr5VsUpjNbefnV7DQbZSfTIsn/Jihf2T9GmAtSlETs
njPNj7V5gFktRMmoAjhZIh9nTS/amQW9ctZoeQvMiGuGFTWLQSwMJonTWXDtHfYV
II2hIpK9FX8STKBJJc/fCHdlemNVF5uLj0G3tcIWy51u6mpsncFBw41s4ovRfelZ
Yg9OrUifGyTrL3Qv8KoBaw0+nCHiFbEVVrHGn1wUHrL3vsLjnUDxpn1lXlRkxf3X
UHYdNq6kfEA39r5WVVVe
=cbZE
-----END PGP SIGNATURE-----

--Sig_/MiDZX2N22nNFuRiFJD7Td3c--
