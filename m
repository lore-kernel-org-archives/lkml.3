Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbaD1VEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:04:31 -0400
Received: from mout.gmx.net ([212.227.17.20]:57637 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbaD1VE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:29 -0400
Date: Mon, 28 Apr 2014 23:02:03 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        dan.carpenter@oracle.com, w-lkml@lebenslange-mailadresse.de,
        teobaluta@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_pwrtrk()
Message-ID: <20140428230203.20dd00c0@spike>
In-Reply-To: <20140428225431.2ea55d58@spike>
References: <20140428225431.2ea55d58@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VfGhBd1MAiX0aSBjcfd3O6F"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:oI1IwkuqMXK5eq7It13Ed9szkVB0POimo+uwlMEROzXhRPVmJEe
 /a+D5HQfxcgexiM3/eJcaEej02JFWL6l3i8OWCC3Y8CMxD+alCB0Q2pVfiQ4ccDuv3a0n6O
 j78fX7ZWN7w+8EqpYYEiho3KraC/eldCcmQybbUJGQdXkpe0rkaA4l4MC4OGI5enrMdT2u5
 UdnxFzAkmxKwTWQoZHIVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VfGhBd1MAiX0aSBjcfd3O6F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Function rtw_mp_pwrtrk() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - 1077715.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 28 ++++++++++++++++------=
----
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/stagi=
ng/rtl8188eu/os_dep/ioctl_linux.c
index ea5e1f8..f04aaa3 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -7119,15 +7119,15 @@ static int rtw_mp_pwrtrk(struct net_device *dev,
 {
 	u8 enable;
 	u32 thermal;
-	s32 ret;
 	struct adapter *padapter =3D rtw_netdev_priv(dev);
 	char	*input =3D kmalloc(wrqu->length, GFP_KERNEL);
+	int ret =3D 0;
=20
 	if (!input)
 		return -ENOMEM;
 	if (copy_from_user(input, wrqu->pointer, wrqu->length)) {
-		kfree(input);
-		return -EFAULT;
+		ret =3D -EFAULT;
+		goto exit;
 	}
 	_rtw_memset(extra, 0, wrqu->length);
=20
@@ -7138,22 +7138,28 @@ static int rtw_mp_pwrtrk(struct net_device *dev,
 			sprintf(extra, "mp tx power tracking stop");
 		} else if (sscanf(input, "ther =3D%d", &thermal)) {
 				ret =3D Hal_SetThermalMeter(padapter, (u8)thermal);
-				if (ret =3D=3D _FAIL)
-					return -EPERM;
+				if (ret =3D=3D _FAIL) {
+					ret =3D -EPERM;
+					goto exit;
+				}
 				sprintf(extra, "mp tx power tracking start, target value =3D%d ok ", t=
hermal);
 		} else {
-			kfree(input);
-			return -EINVAL;
+			ret =3D -EINVAL;
+			goto exit;
 		}
 	}
=20
-	kfree(input);
 	ret =3D Hal_SetPowerTracking(padapter, enable);
-	if (ret =3D=3D _FAIL)
-		return -EPERM;
+	if (ret =3D=3D _FAIL) {
+		ret =3D -EPERM;
+		goto exit;
+	}
=20
 	wrqu->length =3D strlen(extra);
-	return 0;
+
+exit:
+	kfree(input);
+	return ret;
 }
=20
 static int rtw_mp_psd(struct net_device *dev,
--=20
1.9.1

--Sig_/VfGhBd1MAiX0aSBjcfd3O6F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXsHLAAoJEKssnEpaPQKEGHQP/Re2axoLf4cYVHvsL5mLm1Ll
k8d/0b4EbdJ+2cRucC7eCkAnim9ltAFd+XAoaAqUtQJJEDKHjuk6OssUu/ADfG9Y
4hoyeUyHOZ2ipwkFLYG6ffhE0Qu381vuVIxsTMzK+IqvELJyGVcY5YC4owzMHVof
YMf3550YcNxxLTsdVz5QbHoHszS/rsEcDfVIS0Cts5qt4ZyWzz0kK7dhZ0vTpiYh
PQD/dmD7njpHLidYeIo8qx95cGO/dyLTuBc86QhzwvGY7/gVp3K9FOrC9qMhlVQI
ZUlwYzeHpHusFMYU1VCL/v58B1240MDlKvorhA40ClHy3Ud4lde3hezr7Un0ILZ+
ald3gbDmpS2vWfIS+njsRVqOSx+t3R9WuxiN19YUAmvZzIzC1UwrZmyF1doGlz2V
i9QhAe08TFF8sRf01tKvzqHi15hRoEV+i3MgEkwbUEmdYP301Jo2n8DCUuTuMtnU
BiI84I6O3pyKZzq3ipak2HrtihGUeXiXa9Ib5Gsk0iSRaDcxpenMCQKRKiNKqEgO
mRNzg3tdeurH0+2QVbFuuKvZ19n0QnASG2tdImjs7W9HUzgquxbtA2O6FE++X8Jr
boZ09iAEyqWCY8C3vSxh8FOZq6ZbTLoZR+6eb/nchha1fw7qo1pZPEnKSka9trWr
ys3KH8iW3a854vleu2hb
=iPLI
-----END PGP SIGNATURE-----

--Sig_/VfGhBd1MAiX0aSBjcfd3O6F--
