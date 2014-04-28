Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbaD1VFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:05:10 -0400
Received: from mout.gmx.net ([212.227.17.21]:57110 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858AbaD1VEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:24 -0400
Date: Mon, 28 Apr 2014 23:00:25 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        dan.carpenter@oracle.com, w-lkml@lebenslange-mailadresse.de,
        teobaluta@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_SetRFPath()
Message-ID: <20140428230025.12610fdb@spike>
In-Reply-To: <20140428225431.2ea55d58@spike>
References: <20140428225431.2ea55d58@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/HjJ=ntn4nq.fncCeAPMUK4l"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:2NPbSRxUdeMsYVDB2ffram0Uvw5FPNTKieAoDK6iTc6aIk6RTfh
 nORBDnLexCsjL7lmeR2f+ZVX3ZkVrTqwEb6g+zEUndTo/W2uHSZqDkbSkj0dGPPgGUuOzyA
 fMGTCACEVcOCV4Mg9iPZT/7cf2FDOhANG8EvXzgsJOcMByoJejr8gLJkaPYgPQg7hLZRJIP
 WOpykWrXvkc491jbmXObw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HjJ=ntn4nq.fncCeAPMUK4l
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Function rtw_mp_SetRFPath() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - CID 1077714.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/stagi=
ng/rtl8188eu/os_dep/ioctl_linux.c
index 8b1579b..ea5e1f8 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -7321,11 +7321,14 @@ static int rtw_mp_SetRFPath(struct net_device *dev,
 	struct adapter *padapter =3D rtw_netdev_priv(dev);
 	char	*input =3D kmalloc(wrqu->data.length, GFP_KERNEL);
 	u8 bMain =3D 1, bTurnoff =3D 1;
+	int ret =3D 0;
=20
 	if (!input)
 		return -ENOMEM;
-	if (copy_from_user(input, wrqu->data.pointer, wrqu->data.length))
-			return -EFAULT;
+	if (copy_from_user(input, wrqu->data.pointer, wrqu->data.length)) {
+		ret =3D -EFAULT;
+		goto exit;
+	}
 	DBG_88E("%s:iwpriv in =3D%s\n", __func__, input);
=20
 	bMain =3D strncmp(input, "1", 2); /*  strncmp true is 0 */
@@ -7338,8 +7341,10 @@ static int rtw_mp_SetRFPath(struct net_device *dev,
 		MP_PHY_SetRFPathSwitch(padapter, false);
 		DBG_88E("%s:PHY_SetRFPathSwitch =3D false\n", __func__);
 	}
+
+exit:
 	kfree(input);
-	return 0;
+	return ret;
 }
=20
 static int rtw_mp_QueryDrv(struct net_device *dev,
--=20
1.9.1

--Sig_/HjJ=ntn4nq.fncCeAPMUK4l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXsFpAAoJEKssnEpaPQKEXtUP/AlxIZKZDkig2FBRQ5EYQbkQ
LCxcR3AZE7R+LDHH80vIPWFSz//65glZtAwo1reytXC5dhHLXJN+4nErEdZIvSZ9
u+L0QlzUgXFTPFNspl5/2Tqi0YbRr3hOYvN7JY1rbq4aCVcuShYQoboqx1N6rCpX
KF3A5ygOm/LfoFO0MCO4xARt2jCXqyVbXVf2HUzG0SKjZ+7K4ZB4t8DLOAOE4Bb+
nhLFw/ZrYud2loljKcKkONmYix7YLtaq1vUiHnPHbqczODaw1IGw9FqUnhW06CoE
tdIyFQwaMVJcVU9DhCd6YanfMfpoiZ1CRx+Hkzo2mpU4spaA/oarLaObOjHArFEz
2wzi567ELjwACMBMIaMUSpf7jOQbFWbyVVqFLqeir2tWpeoL1AdHO9i+asF76zd1
51vMOXAjEWBw8aRDds12nJG5/xAch3rmtWSMX/uXI840ggWQ4HPBg2MY3kiseHEB
YgX+ztzyWmxOgBq+Fo/z5LDrD+nh8hddPXXcAr2kmsldujJ9Fjih07ENLekl5iqw
lCII/HOGDayqT5rEk2KSuKBT572NzP9q9I0nb2F8W+OZaCtszN4wsjxMI2waRn+5
zQLQvu+t+LZrGtBeEiICLCVNwGmRtcAgmmTjVo9uk9MMOjmp10fnmHZoEFdOtXmQ
HZHCx/NQRBY+E581Fp9n
=yDNW
-----END PGP SIGNATURE-----

--Sig_/HjJ=ntn4nq.fncCeAPMUK4l--
