Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaEAKcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:32:55 -0400
Received: from mout.gmx.net ([212.227.15.18]:52366 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbaEAKcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 06:32:54 -0400
Date: Thu, 1 May 2014 11:45:00 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, linuxgeek@gmail.com,
        paul.gortmaker@windriver.com, andriy.shevchenko@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: fix potential leak in
 r871x_wx_set_enc_ext()
Message-ID: <20140501114500.756b95d0@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Zs+z7Uh4nzgdCOPFSW5mnEu"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:g2LUCNaicOI8U1xj2Z32jS+LZ2RVVIe5ZKUsD89p+k9NAswaPg5
 8/cD6eKc+Ckp5uvzYm4lOaO427NHIL6hi5OljlCq4e/zaDnzy4xmV5DVjvBp6yb3OcBq5rE
 ZoBTfsaX/iV9C6d1IwlWOahFAVQ6BZHQgy6PqVMunhtCa/bZ/iZItqgAG4YaocnUMUbTT2D
 8Q8dnBRy438Xc3n5Rt9dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Zs+z7Uh4nzgdCOPFSW5mnEu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Fix a potential leak in the error path of r871x_wx_set_enc_ext(). In case t=
he
requested algorithm is not supported by the driver, the function returns
without freeing the already allocated 'param' struct. Move the input
verification to the beginning of the function so that the direct return is
safe. Detected by Coverity - CID 144373.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/stagin=
g/rtl8712/rtl871x_ioctl_linux.c
index 23d539d..1eca992 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1801,13 +1801,6 @@ static int r871x_wx_set_enc_ext(struct net_device *d=
ev,
 	u32 param_len;
 	int ret =3D 0;
=20
-	param_len =3D sizeof(struct ieee_param) + pext->key_len;
-	param =3D (struct ieee_param *)_malloc(param_len);
-	if (param =3D=3D NULL)
-		return -ENOMEM;
-	memset(param, 0, param_len);
-	param->cmd =3D IEEE_CMD_SET_ENCRYPTION;
-	memset(param->sta_addr, 0xff, ETH_ALEN);
 	switch (pext->alg) {
 	case IW_ENCODE_ALG_NONE:
 		alg_name =3D "none";
@@ -1824,6 +1817,15 @@ static int r871x_wx_set_enc_ext(struct net_device *d=
ev,
 	default:
 		return -EINVAL;
 	}
+
+	param_len =3D sizeof(struct ieee_param) + pext->key_len;
+	param =3D (struct ieee_param *)_malloc(param_len);
+	if (param =3D=3D NULL)
+		return -ENOMEM;
+	memset(param, 0, param_len);
+	param->cmd =3D IEEE_CMD_SET_ENCRYPTION;
+	memset(param->sta_addr, 0xff, ETH_ALEN);
+
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
 	if (pext->ext_flags & IW_ENCODE_EXT_GROUP_KEY)
 		param->u.crypt.set_tx =3D 0;
--=20
1.9.1

--Sig_/Zs+z7Uh4nzgdCOPFSW5mnEu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYhecAAoJEKssnEpaPQKEjrkQALgRLA3K/wp8ODXxuRn0rlr6
BmMc85mbdNpoTDx07JUvPzydtDuycMH6czwWVamSgMLIj6DNhR+mK7lwhKhJ6bAY
YFiZmuQ9TUKHxAlWFDn5Aluuf5dPcSEBLXeVTJebhfNOy5t/ylfkmGYSxigMFk62
nFBLovgdAcf5jaRcFjHZEbGhzrYPfaogVydvhAI4+RExNkcGF0hfQ2YUUiSrJ1CC
UNb4LLB/9gVEwGC/TUEWnsaXdNB7/+He3fbVx3gxGRmfjb14iJ8qUrvcHL1Q9aY/
NxSQxWQpLnXXBUmSiMaenZ0Lo0b0ehsn2W56GubFvAHRSAqR8Kw+LLl+Q7Pb7/Uk
UqJUzbpPojllAucfzLZgOSQI8Yw4vMJ2MV0/EyIW2OpGJebmWP4VYIst9ktGno10
P7xy3nyz7ZNnQSoUgXFTIKECTHa/SXQaNKXWvxVyevtBLxSiyHTaSdzTbr7A2PH9
tMWVb3SUG5H5SNpeD8Bkoe8S4Bab8xvRdTQEZIcvDNvxk2o6oPh3pa4HZS+QquNt
izfi2K8sP2L5C/r51MXiIyj6J7uthszr7nLX8KaIwwqSd7uSxZ63uLyeeWVYL02r
ohF9Ai8phWs08/IDPQx7M5UYGEUoaODo1DIjR6pShFEBawtYEaUXNungdG/XqZbg
/K8cHllFt9KQj7+qVDIG
=sDlK
-----END PGP SIGNATURE-----

--Sig_/Zs+z7Uh4nzgdCOPFSW5mnEu--
