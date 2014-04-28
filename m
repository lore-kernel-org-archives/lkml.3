Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbaD1VEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:04:25 -0400
Received: from mout.gmx.net ([212.227.17.20]:58047 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbaD1VEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:04:21 -0400
Date: Mon, 28 Apr 2014 22:56:20 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        dan.carpenter@oracle.com, w-lkml@lebenslange-mailadresse.de,
        teobaluta@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] staging: rtl8188eu: fix potential leak in
 rtw_wx_read32()
Message-ID: <20140428225620.611319cf@spike>
In-Reply-To: <20140428225431.2ea55d58@spike>
References: <20140428225431.2ea55d58@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qVc+mbKoupVG=7R9.f_n7Za"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:9GfLlUF/KHEGrnj7wM77SryBj7czxdQ1VVnogTrwN2TXLewJLRl
 Y/2qZydIy1UDKboCom3iCDNpQR3dwwHTR0rXuN2FC22Jbme+7cJRjFuuiQx142yx1hZh0HT
 8AXSxwx6WMrjgaFzrt0pziQMOlxSu4sDGKmTRYsHm9wQUwilQBmcPqGCWytoOiyRDgNR4TZ
 w1dpbvEku9yJ0MD5MroTQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qVc+mbKoupVG=7R9.f_n7Za
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Function rtw_wx_read32() dynamically allocates a temporary buffer that is n=
ot
freed in all error paths. Use a centralized exit path and make sure that all
memory is freed correctly. Detected by Coverity - CID 1077711.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/stagi=
ng/rtl8188eu/os_dep/ioctl_linux.c
index cf30a08..45b47e2 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2154,6 +2154,7 @@ static int rtw_wx_read32(struct net_device *dev,
 	u32 bytes;
 	u8 *ptmp;
 	int rv;
+	int ret =3D 0;
=20
 	padapter =3D (struct adapter *)rtw_netdev_priv(dev);
 	p =3D &wrqu->data;
@@ -2163,16 +2164,16 @@ static int rtw_wx_read32(struct net_device *dev,
 		return -ENOMEM;
=20
 	if (copy_from_user(ptmp, p->pointer, len)) {
-		kfree(ptmp);
-		return -EFAULT;
+		ret =3D -EFAULT;
+		goto exit;
 	}
=20
 	bytes =3D 0;
 	addr =3D 0;
 	rv =3D sscanf(ptmp, "%d,%x", &bytes, &addr);
 	if (rv !=3D 2) {
-		kfree(ptmp);
-		return -EINVAL;
+		ret =3D -EINVAL;
+		goto exit;
 	}
=20
 	switch (bytes) {
@@ -2190,12 +2191,14 @@ static int rtw_wx_read32(struct net_device *dev,
 		break;
 	default:
 		DBG_88E(KERN_INFO "%s: usage> read [bytes],[address(hex)]\n", __func__);
-		return -EINVAL;
+		ret =3D -EINVAL;
+		goto exit;
 	}
 	DBG_88E(KERN_INFO "%s: addr =3D 0x%08X data =3D%s\n", __func__, addr, ext=
ra);
=20
+exit:
 	kfree(ptmp);
-	return 0;
+	return ret;
 }
=20
 static int rtw_wx_write32(struct net_device *dev,
--=20
1.9.1

--Sig_/qVc+mbKoupVG=7R9.f_n7Za
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXsB0AAoJEKssnEpaPQKEwbQQAI1UTq8BhV46fs/lKUx8ymdH
9bAflMramArTfL8N3Pm5aw0Gz9rakZY1qeFVrCBATkfiCivdBMzmU5QxqCjom6PT
YeybtmyAjnTGiPRCrBvKqht0b4Jg3h6qBoIjOuIVxG9OejhU1b1thMikQf9MO2vi
/K6POYJ/yZmNRR9rZbWE0EACVe+vAnEK+vWGzWacyJKbI/cfFbhE6pSIKcCuHWxW
mBzC+0FwH4hZNTAqhmqrbpvtSKIuHG65lf1XWlOYL4UkWSmVVrqNM2KwNOJWx5JR
D5+j1BgMVALql4aBeiq5FNuW9Mb+gQt96TfsbG7oKWy1hGpjejgzE6XAgFPBSZ9h
jqfw+glxglyn/I+0Sd5aP1amH3+sod+fc7vviKLFuFaLIk2q6ir+w2dZ5tCAajVc
8tQFV2eDXwIG7he5yTHxERH7ZjjN6rqFiA8F/gekK8QabCauEsC/wKvRN5wJQ5eV
NJ3gfzsRh85OXBr6mQwd4bdVUowsjhpsAPxZontwBsYZ0t+nCBeZXZ9DNaMimzeT
rwoAsKsATwpGVCADi8wGAYASjN3AVtBjRqHNNOaGuHniBUuVwhpsjvmfGdkCY6sC
i7F7JrM0uXsML4/tMXiBXzDNh8XUlGTCTkGjVLpIw920DKMrnRESnRBWWnHTxRuo
HQFS2CIx/HYvxHcw0Wrk
=ru/o
-----END PGP SIGNATURE-----

--Sig_/qVc+mbKoupVG=7R9.f_n7Za--
