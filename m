Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaD1VE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:04:28 -0400
Received: from mout.gmx.net ([212.227.15.19]:59413 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbaD1VE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:26 -0400
Date: Mon, 28 Apr 2014 22:59:39 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        dan.carpenter@oracle.com, w-lkml@lebenslange-mailadresse.de,
        teobaluta@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_QueryDrv()
Message-ID: <20140428225939.559d4b5f@spike>
In-Reply-To: <20140428225431.2ea55d58@spike>
References: <20140428225431.2ea55d58@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//4SwM2oFf03/l64bwuaBz+h"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:VBMPJJiXHeL93kginMsZ5Xu6IAebVDQ68SOfGMjWfg8UyHm/3vP
 izEAnDHQ784YqMYyaCDyDJJVIY5DKQ+OaYkBsRw/ZW0Ad5JC9v0GVHZQkpWniLC0gTEVl6y
 +3s0ShmIFbwVQvcl0mO2/c00NO+Hx32jeGI9qjuTyzm7wbCguFO1vjgzx060F4j+NuTsm9S
 GCfTsJOy1ozM/uhGw01gA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//4SwM2oFf03/l64bwuaBz+h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Function rtw_mp_QueryDrv() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - CID 1077713.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/stagi=
ng/rtl8188eu/os_dep/ioctl_linux.c
index 1bd476d..8b1579b 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -7350,12 +7350,15 @@ static int rtw_mp_QueryDrv(struct net_device *dev,
 	char	*input =3D kmalloc(wrqu->data.length, GFP_KERNEL);
 	u8 qAutoLoad =3D 1;
 	struct eeprom_priv *pEEPROM =3D GET_EEPROM_EFUSE_PRIV(padapter);
+	int ret =3D 0;
=20
 	if (!input)
 		return -ENOMEM;
=20
-	if (copy_from_user(input, wrqu->data.pointer, wrqu->data.length))
-			return -EFAULT;
+	if (copy_from_user(input, wrqu->data.pointer, wrqu->data.length)) {
+		ret =3D -EFAULT;
+		goto exit;
+	}
 	DBG_88E("%s:iwpriv in =3D%s\n", __func__, input);
=20
 	qAutoLoad =3D strncmp(input, "autoload", 8); /*  strncmp true is 0 */
@@ -7369,8 +7372,10 @@ static int rtw_mp_QueryDrv(struct net_device *dev,
 		sprintf(extra, "ok");
 	}
 	wrqu->data.length =3D strlen(extra) + 1;
+
+exit:
 	kfree(input);
-	return 0;
+	return ret;
 }
=20
 static int rtw_mp_set(struct net_device *dev,
--=20
1.9.1


--Sig_//4SwM2oFf03/l64bwuaBz+h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXsE7AAoJEKssnEpaPQKEh/4P/03RSH4Ke2Yj2k8zBTwiasod
lU+nPVfWBhwPuLbonF3pS1A2XFY7+Dw08fQ2i9/o8meliE3u0r1yTicnDlDNbLTN
4x/xmsW2vsSemgg071iJw7hYyckfA5r+7J3Gv4OGqoA8tbwLmH8qpEa3kJ+izh9G
JRJJMY03/sxJEvrI0kDQ3kgCUw6eqEWNjVqlsr+DIMd0AU0WUBM3AsrciDgv91R2
6R2W1Zs1gUPZAc5pxxc/Q0JZFddaUiUGVpEezeGf1Up+T+K+ULMw4jbgsB+43RIZ
akTyWUruTef2IANCaS1a7sgzfkvbbYNElEEMJ3rcdVl3XbgKoSxRfr0L59Cq6oOU
MXtTkyZTHp3w8j29L1TmhOb6BVur5adETz4lyy96hCjtejm99oNF6rOPxlfQbTqE
w5t8DjOm2p6K1qfmR3lmKL5La5Zx7UjpMLjIhF2d31LLSrNhnd8/H1z/OdQ+O8xo
hIImODkYMzbFmJAQOUZK4Rq56DZreaqD4UotfwXv6pKza/pPQf8SW/2i08wAjt5P
JYh2BCMDLfVQCbT3eFp+tgcnmi/rBJbWKjm6zG9g2Ljof0JN6dShOj0n+9lBwpLj
JhqMnXAjZpfTEBb/n45owquXG8DHk9jpQMvz37vsGB1R9KuZ3EAHEmW2qoqFDo7u
i01yyvMH0xB/0WKzlzkT
=7C3r
-----END PGP SIGNATURE-----

--Sig_//4SwM2oFf03/l64bwuaBz+h--
